/**
 * Admin API: Update inquiry status
 * Path: /functions/api/admin/update.js
 * Method: POST
 * Body: { id, status }
 */

export async function onRequestPost(context) {
    const { request, env } = context;
    const token = request.headers.get('X-Admin-Token');

    if (!env.ADMIN_TOKEN || token !== env.ADMIN_TOKEN) {
        return new Response(JSON.stringify({ error: 'Unauthorized' }), {
            status: 401,
            headers: { 'Content-Type': 'application/json' }
        });
    }

    try {
        const body = await request.json();
        const { id, status } = body;

        if (!id || !status) {
            return new Response(JSON.stringify({ error: 'Missing id or status' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const validStatuses = ['new', 'contacted', 'quoted', 'won', 'lost'];
        if (!validStatuses.includes(status)) {
            return new Response(JSON.stringify({ error: 'Invalid status' }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        if (!env.INQUIRIES) {
            return new Response(JSON.stringify({ error: 'INQUIRIES KV not bound' }), {
                status: 500,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const existing = await env.INQUIRIES.get(id);
        if (!existing) {
            return new Response(JSON.stringify({ error: 'Inquiry not found' }), {
                status: 404,
                headers: { 'Content-Type': 'application/json' }
            });
        }

        const data = JSON.parse(existing);
        data.status = status;
        data.status_updated_at = new Date().toISOString();

        await env.INQUIRIES.put(id, JSON.stringify(data));

        // Update list index
        const listRaw = await env.INQUIRIES.get('inquiries:list');
        const list = listRaw ? JSON.parse(listRaw) : [];
        const idx = list.findIndex(i => i.id === id);
        if (idx >= 0) {
            list[idx].status = status;
            await env.INQUIRIES.put('inquiries:list', JSON.stringify(list));
        }

        return new Response(JSON.stringify({ success: true }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (e) {
        return new Response(JSON.stringify({ error: e.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

export async function onRequestGet() {
    return new Response('Method not allowed. Use POST.', { status: 405 });
}
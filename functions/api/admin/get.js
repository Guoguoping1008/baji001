/**
 * Admin API: Get single inquiry detail
 * Path: /functions/api/admin/get.js?id=xxx
 */

export async function onRequestGet(context) {
    const { request, env } = context;
    const token = request.headers.get('X-Admin-Token');

    if (!env.ADMIN_TOKEN || token !== env.ADMIN_TOKEN) {
        return new Response(JSON.stringify({ error: 'Unauthorized' }), {
            status: 401,
            headers: { 'Content-Type': 'application/json' }
        });
    }

    const url = new URL(request.url);
    const id = url.searchParams.get('id');

    if (!id) {
        return new Response(JSON.stringify({ error: 'Missing id parameter' }), {
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

    const data = await env.INQUIRIES.get(id);
    if (!data) {
        return new Response(JSON.stringify({ error: 'Inquiry not found' }), {
            status: 404,
            headers: { 'Content-Type': 'application/json' }
        });
    }

    return new Response(JSON.stringify({
        success: true,
        inquiry: JSON.parse(data)
    }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' }
    });
}
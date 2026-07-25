/**
 * Admin API: List inquiries
 * Path: /functions/api/admin/list.js
 *
 * Auth: send X-Admin-Token header matching env.ADMIN_TOKEN
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

    if (!env.INQUIRIES) {
        return new Response(JSON.stringify({
            error: 'INQUIRIES KV namespace not bound',
            list: []
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }

    try {
        const listRaw = await env.INQUIRIES.get('inquiries:list');
        const list = listRaw ? JSON.parse(listRaw) : [];

        // Stats
        const stats = {
            total: list.length,
            byStatus: {},
            byProduct: {},
            byCountry: {},
            last24h: 0,
        };

        const oneDayAgo = Date.now() - 86400000;
        list.forEach(item => {
            stats.byStatus[item.status] = (stats.byStatus[item.status] || 0) + 1;
            stats.byProduct[item.product_type] = (stats.byProduct[item.product_type] || 0) + 1;
            stats.byCountry[item.country] = (stats.byCountry[item.country] || 0) + 1;
            if (new Date(item.timestamp).getTime() > oneDayAgo) stats.last24h++;
        });

        return new Response(JSON.stringify({
            success: true,
            stats,
            list,
            count: list.length
        }), {
            status: 200,
            headers: {
                'Content-Type': 'application/json',
                'Cache-Control': 'no-store'
            }
        });
    } catch (e) {
        return new Response(JSON.stringify({ error: e.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}
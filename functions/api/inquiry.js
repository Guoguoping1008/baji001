/**
 * Cloudflare Pages Function: Persist inquiry to KV
 * Path: /functions/api/inquiry.js
 *
 * Requires KV namespace binding INQUIRIES in wrangler.toml:
 * [[kv_namespaces]]
 * binding = "INQUIRIES"
 * id = "your-kv-id-here"
 *
 * Admin token: ADMIN_TOKEN env var (e.g., 'pinforge2025')
 */

export async function onRequestPost(context) {
    const { request, env } = context;

    try {
        const formData = await request.formData();
        const data = {
            id: `inq_${Date.now()}_${Math.random().toString(36).slice(2, 8)}`,
            timestamp: new Date().toISOString(),
            company: formData.get('company') || '',
            name: formData.get('name') || '',
            email: formData.get('email') || '',
            phone: formData.get('phone') || '',
            country: formData.get('country') || '',
            product_type: formData.get('product_type') || '',
            quantity: formData.get('quantity') || '',
            size: formData.get('size') || '',
            budget: formData.get('budget') || '',
            deadline: formData.get('deadline') || '',
            description: formData.get('description') || '',
            nda: formData.get('nda') || 'no',
            sample: formData.get('sample') || 'no',
            newsletter: formData.get('newsletter') || 'no',
            source: formData.get('source') || 'direct',
            utm_source: new URL(request.url).searchParams.get('utm_source') || '',
            utm_campaign: new URL(request.url).searchParams.get('utm_campaign') || '',
            ip: request.headers.get('CF-Connecting-IP') || '',
            country_ip: request.headers.get('CF-IPCountry') || '',
            status: 'new', // new | contacted | quoted | won | lost
        };

        // 1. Save to KV
        if (env.INQUIRIES) {
            await env.INQUIRIES.put(data.id, JSON.stringify(data), {
                // Keep inquiries for 90 days
                expirationTtl: 60 * 60 * 24 * 90
            });

            // Also add to a list index
            const listKey = 'inquiries:list';
            const existing = await env.INQUIRIES.get(listKey);
            const list = existing ? JSON.parse(existing) : [];
            list.unshift({
                id: data.id,
                timestamp: data.timestamp,
                company: data.company,
                email: data.email,
                country: data.country,
                product_type: data.product_type,
                quantity: data.quantity,
                status: data.status,
            });
            // Cap list at 500
            const cappedList = list.slice(0, 500);
            await env.INQUIRIES.put(listKey, JSON.stringify(cappedList));
        }

        // 2. Forward to Slack if webhook configured
        if (env.SLACK_WEBHOOK_URL) {
            await forwardToSlack(env.SLACK_WEBHOOK_URL, data);
        }

        // 3. Send email via Resend if configured
        if (env.RESEND_API_KEY) {
            await sendEmail(env.RESEND_API_KEY, data);
        }

        // 4. Fallback: log to console (visible in Pages Functions logs)
        console.log('New inquiry:', JSON.stringify(data));

        return new Response(JSON.stringify({
            success: true,
            id: data.id,
            message: 'Quote request received! We will respond within 24 hours.'
        }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        console.error('Inquiry form error:', error);
        return new Response(JSON.stringify({
            success: false,
            message: 'Failed to process request. Please email us directly at Devllin@outlook.com'
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

export async function onRequestGet() {
    return new Response('Method not allowed. Use POST.', { status: 405 });
}

async function forwardToSlack(webhookUrl, data) {
    const text = `📩 *New Quote Request*\n\n` +
        `*Company:* ${data.company}\n` +
        `*Contact:* ${data.name}\n` +
        `*Email:* ${data.email}\n` +
        `*Phone:* ${data.phone || 'N/A'}\n` +
        `*Country:* ${data.country} (${data.country_ip})\n` +
        `*Product:* ${data.product_type}\n` +
        `*Quantity:* ${data.quantity}\n` +
        `*Budget:* ${data.budget || 'N/A'}\n` +
        `*Deadline:* ${data.deadline || 'N/A'}\n` +
        `*Description:* ${data.description}\n` +
        `*Source:* ${data.source} / ${data.utm_source}\n` +
        `*ID:* ${data.id}`;

    await fetch(webhookUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text })
    });
}

async function sendEmail(apiKey, data) {
    await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`
        },
        body: JSON.stringify({
            from: 'noreply@pinforge.com',
            to: 'Devllin@outlook.com',
            subject: `[${data.product_type}] ${data.company} - ${data.country}`,
            html: `
                <h2>New Quote Request</h2>
                <table style="border-collapse:collapse">
                    <tr><td><b>Company</b></td><td style="padding-left:16px">${data.company}</td></tr>
                    <tr><td><b>Contact</b></td><td style="padding-left:16px">${data.name} (${data.email})</td></tr>
                    <tr><td><b>Country</b></td><td style="padding-left:16px">${data.country}</td></tr>
                    <tr><td><b>Product</b></td><td style="padding-left:16px">${data.product_type}</td></tr>
                    <tr><td><b>Quantity</b></td><td style="padding-left:16px">${data.quantity}</td></tr>
                    <tr><td><b>Budget</b></td><td style="padding-left:16px">${data.budget || 'N/A'}</td></tr>
                    <tr><td><b>Deadline</b></td><td style="padding-left:16px">${data.deadline || 'N/A'}</td></tr>
                    <tr><td><b>NDA</b></td><td style="padding-left:16px">${data.nda}</td></tr>
                    <tr><td><b>Sample</b></td><td style="padding-left:16px">${data.sample}</td></tr>
                </table>
                <h3>Description</h3>
                <p>${data.description}</p>
                <p style="color:#999;font-size:12px">ID: ${data.id} · ${data.timestamp}</p>
            `
        })
    });
}
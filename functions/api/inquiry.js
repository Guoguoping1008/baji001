// Cloudflare Pages Function - handles inquiry form submissions
// File path: /functions/api/inquiry.js
// Endpoint: POST /api/inquiry

export async function onRequestPost(context) {
    const { request, env } = context;
    
    try {
        const formData = await request.formData();
        
        // Extract fields
        const data = {
            company: formData.get('company'),
            name: formData.get('name'),
            email: formData.get('email'),
            phone: formData.get('phone'),
            country: formData.get('country'),
            product_type: formData.get('product_type'),
            quantity: formData.get('quantity'),
            description: formData.get('description'),
            timestamp: new Date().toISOString(),
            source: formData.get('source') || 'direct',
        };

        // ---- Option 1: Send email via Cloudflare Email Workers / Resend / SendGrid ----
        // await sendEmail(env, data);

        // ---- Option 2: Forward to Formspree ----
        // await fetch('https://formspree.io/f/YOUR_ID', { method: 'POST', body: formData });

        // ---- Option 3: Save to Cloudflare KV / D1 ----
        // await env.INQUIRIES.put(`inquiry-${Date.now()}`, JSON.stringify(data));

        // ---- Option 4: Forward to Slack / Discord webhook ----
        await forwardToSlack(env, data);

        return new Response(JSON.stringify({ 
            success: true, 
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

async function forwardToSlack(env, data) {
    const webhookUrl = env.SLACK_WEBHOOK_URL;
    if (!webhookUrl) return;

    const text = `📩 *New Quote Request*\n\n` +
        `*Company:* ${data.company}\n` +
        `*Contact:* ${data.name}\n` +
        `*Email:* ${data.email}\n` +
        `*Phone:* ${data.phone || 'N/A'}\n` +
        `*Country:* ${data.country}\n` +
        `*Product:* ${data.product_type}\n` +
        `*Quantity:* ${data.quantity}\n` +
        `*Description:* ${data.description}\n` +
        `*Source:* ${data.source}`;

    await fetch(webhookUrl, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ text })
    });
}

async function sendEmail(env, data) {
    // Example using Resend API
    const apiKey = env.RESEND_API_KEY;
    if (!apiKey) return;

    await fetch('https://api.resend.com/emails', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`
        },
        body: JSON.stringify({
            from: 'noreply@pinforge.example',
            to: 'Devllin@outlook.com',
            subject: `New Quote: ${data.company} - ${data.product_type}`,
            html: `
                <h2>New Quote Request</h2>
                <p><strong>Company:</strong> ${data.company}</p>
                <p><strong>Contact:</strong> ${data.name} (${data.email})</p>
                <p><strong>Country:</strong> ${data.country}</p>
                <p><strong>Product:</strong> ${data.product_type}</p>
                <p><strong>Quantity:</strong> ${data.quantity}</p>
                <p><strong>Description:</strong> ${data.description}</p>
            `
        })
    });
}
// Cloudflare Pages Function - handles simple contact form
// File path: /functions/api/contact.js
// Endpoint: POST /api/contact

export async function onRequestPost(context) {
    const { request, env } = context;
    
    try {
        const formData = await request.formData();
        const data = {
            name: formData.get('name'),
            email: formData.get('email'),
            subject: formData.get('subject'),
            message: formData.get('message'),
            timestamp: new Date().toISOString(),
        };

        // Forward to Slack if webhook configured
        if (env.SLACK_WEBHOOK_URL) {
            await fetch(env.SLACK_WEBHOOK_URL, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({
                    text: `📨 *New Contact Message*\n\n*From:* ${data.name} (${data.email})\n*Subject:* ${data.subject}\n*Message:* ${data.message}`
                })
            });
        }

        return new Response(JSON.stringify({ 
            success: true, 
            message: 'Message sent!' 
        }), {
            status: 200,
            headers: { 'Content-Type': 'application/json' }
        });
    } catch (error) {
        return new Response(JSON.stringify({ 
            success: false, 
            message: 'Failed to send. Please email Devllin@outlook.com directly.' 
        }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' }
        });
    }
}

export async function onRequestGet() {
    return new Response('Method not allowed. Use POST.', { status: 405 });
}
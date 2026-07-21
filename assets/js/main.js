/* ==============================================
   PinForge — Main JavaScript v1.1
   ============================================== */

(function() {
    'use strict';

    // ---- Mobile Nav Toggle ----
    const navToggle = document.querySelector('.nav-toggle');
    const navMenu = document.querySelector('.nav-menu');
    if (navToggle && navMenu) {
        navToggle.addEventListener('click', () => {
            navMenu.classList.toggle('active');
            navToggle.textContent = navMenu.classList.contains('active') ? '✕' : '☰';
        });
    }

    // ---- Smooth scroll ----
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function (e) {
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                e.preventDefault();
                target.scrollIntoView({ behavior: 'smooth', block: 'start' });
                if (navMenu && navMenu.classList.contains('active')) {
                    navMenu.classList.remove('active');
                    navToggle.textContent = '☰';
                }
            }
        });
    });

    // ---- Product Filter Tabs ----
    const filterTabs = document.querySelectorAll('.filter-tab');
    const productCards = document.querySelectorAll('.product-card');

    if (filterTabs.length > 0) {
        filterTabs.forEach(tab => {
            tab.addEventListener('click', () => {
                filterTabs.forEach(t => t.classList.remove('active'));
                tab.classList.add('active');
                const filter = tab.dataset.filter;

                productCards.forEach(card => {
                    if (filter === 'all' || card.dataset.category === filter) {
                        card.style.display = '';
                        card.style.animation = 'fadeIn 0.4s ease forwards';
                    } else {
                        card.style.display = 'none';
                    }
                });

                // Track filter usage
                if (typeof gtag !== 'undefined') {
                    gtag('event', 'filter_products', { filter_category: filter });
                }
            });
        });
    }

    // ---- Inquiry Form Submission ----
    const inquiryForm = document.getElementById('inquiryForm');
    if (inquiryForm) {
        inquiryForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const submitBtn = inquiryForm.querySelector('button[type="submit"]');
            const originalText = submitBtn.textContent;

            submitBtn.disabled = true;
            submitBtn.textContent = 'Sending...';

            // Collect form data for tracking
            const formDataObj = {
                company: inquiryForm.company?.value || '',
                country: inquiryForm.country?.value || '',
                product_type: inquiryForm.product_type?.value || '',
                quantity: inquiryForm.quantity?.value || '',
                source: inquiryForm.source?.value || 'direct',
            };

            try {
                const formData = new FormData(inquiryForm);

                // Submit to Cloudflare Function
                const response = await fetch('/api/inquiry', {
                    method: 'POST',
                    body: formData
                });

                if (!response.ok) throw new Error('Network error');

                // ---- TRACK CONVERSION on all pixels ----
                // Google Analytics 4
                if (typeof gtag !== 'undefined' && typeof window.trackQuoteRequest === 'function') {
                    window.trackQuoteRequest(formDataObj);
                }
                // Meta Pixel
                if (typeof window.trackMetaLead === 'function') {
                    window.trackMetaLead(formDataObj);
                }
                // TikTok Pixel
                if (typeof window.trackTikTokLead === 'function') {
                    window.trackTikTokLead(formDataObj);
                }

                showNotification('✅ Quote request sent! We\'ll respond within 24 hours.', 'success');
                inquiryForm.reset();
            } catch (error) {
                console.error('Form error:', error);
                showNotification('❌ Something went wrong. Please try WhatsApp or email us directly at sales@pinforge.example.', 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.textContent = originalText;
            }
        });
    }

    // ---- Contact Form Submission ----
    const contactForm = document.querySelector('.contact-form');
    if (contactForm) {
        contactForm.addEventListener('submit', async (e) => {
            e.preventDefault();
            const submitBtn = contactForm.querySelector('button[type="submit"]');
            const originalText = submitBtn.textContent;

            submitBtn.disabled = true;
            submitBtn.textContent = 'Sending...';

            try {
                const formData = new FormData(contactForm);
                const response = await fetch('/api/contact', {
                    method: 'POST',
                    body: formData
                });

                if (!response.ok) throw new Error('Network error');

                // Track conversion
                if (typeof gtag !== 'undefined') {
                    gtag('event', 'generate_lead', { form_type: 'contact' });
                }
                if (typeof fbq !== 'undefined') {
                    fbq('track', 'Lead', { content_name: 'contact_form' });
                }
                if (typeof ttq !== 'undefined') {
                    ttq.track('SubmitForm', { content_type: 'contact' });
                }

                showNotification('✅ Message sent! We\'ll get back to you within 24 hours.', 'success');
                contactForm.reset();
            } catch (error) {
                showNotification('❌ Failed to send. Please email sales@pinforge.example directly.', 'error');
            } finally {
                submitBtn.disabled = false;
                submitBtn.textContent = originalText;
            }
        });
    }

    // ---- Notification helper ----
    function showNotification(message, type) {
        const existing = document.querySelector('.notification');
        if (existing) existing.remove();

        const notif = document.createElement('div');
        notif.className = `notification notification-${type}`;
        notif.textContent = message;
        notif.style.cssText = `
            position: fixed;
            top: 90px;
            right: 24px;
            padding: 16px 24px;
            background: ${type === 'success' ? '#10B981' : '#EF4444'};
            color: white;
            border-radius: 12px;
            box-shadow: 0 12px 32px rgba(0,0,0,0.2);
            z-index: 1000;
            font-weight: 600;
            max-width: 380px;
            animation: slideIn 0.3s ease;
        `;
        document.body.appendChild(notif);

        setTimeout(() => {
            notif.style.opacity = '0';
            notif.style.transition = 'opacity 0.3s';
            setTimeout(() => notif.remove(), 300);
        }, 5000);
    }

    // ---- Scroll-reveal animation ----
    if ('IntersectionObserver' in window) {
        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('in-view');
                    observer.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

        document.querySelectorAll('.category-card, .feature, .step, .testimonial, .product-card, .capability, .cert-card').forEach(el => {
            observer.observe(el);
        });
    }

    // ---- Track source from URL params (UTM) ----
    const urlParams = new URLSearchParams(window.location.search);
    const source = urlParams.get('utm_source') || 'direct';
    document.querySelectorAll('input[name="source"]').forEach(input => {
        input.value = source;
    });

    // ---- Track outbound link clicks (B2B-specific) ----
    document.querySelectorAll('a[href^="https://wa.me"], a[href^="https://facebook.com"], a[href^="https://instagram.com"], a[href^="https://tiktok.com"], a[href^="https://xiaohongshu.com"]').forEach(link => {
        link.addEventListener('click', () => {
            if (typeof gtag !== 'undefined') {
                gtag('event', 'click_social', {
                    link_url: link.href,
                    link_text: link.textContent.trim().slice(0, 50)
                });
            }
        });
    });

    // ---- Track CTA button clicks ----
    document.querySelectorAll('.btn-primary').forEach(btn => {
        btn.addEventListener('click', () => {
            if (typeof gtag !== 'undefined') {
                gtag('event', 'click_cta', {
                    button_text: btn.textContent.trim().slice(0, 50),
                    page_path: window.location.pathname
                });
            }
        });
    });

    console.log('📌 PinForge site loaded — B2B Pin Manufacturer');
})();

// ---- CSS Animations (injected) ----
const style = document.createElement('style');
style.textContent = `
    @keyframes fadeIn {
        from { opacity: 0; transform: translateY(10px); }
        to { opacity: 1; transform: translateY(0); }
    }
    @keyframes slideIn {
        from { transform: translateX(100%); opacity: 0; }
        to { transform: translateX(0); opacity: 1; }
    }
    .category-card, .feature, .step, .testimonial, .product-card, .capability, .cert-card {
        opacity: 0;
        transform: translateY(20px);
        transition: opacity 0.6s ease, transform 0.6s ease;
    }
    .category-card.in-view, .feature.in-view, .step.in-view,
    .testimonial.in-view, .product-card.in-view, .capability.in-view, .cert-card.in-view {
        opacity: 1;
        transform: translateY(0);
    }
`;
document.head.appendChild(style);
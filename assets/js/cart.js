/* ==============================================
   PinForge — Shopping Cart (Client-side)
   - LocalStorage persistence
   - Quantity +/- controls
   - WhatsApp checkout (sends order summary to sales)
   - GA4 + Meta Pixel add_to_cart tracking
   ============================================== */

const CART_KEY = 'pinforge_cart_v1';

const Cart = {
    items: [],

    init() {
        this.load();
        this.bindUI();
        this.render();
    },

    load() {
        try {
            this.items = JSON.parse(localStorage.getItem(CART_KEY) || '[]');
        } catch (e) {
            this.items = [];
        }
    },

    save() {
        localStorage.setItem(CART_KEY, JSON.stringify(this.items));
        this.render();
        this.updateBadge();
    },

    add(product, qty = 50) {
        // product: { id, name, sku, price, image, url, category, minQty }
        const existing = this.items.find(i => i.id === product.id);
        if (existing) {
            existing.qty += qty;
        } else {
            this.items.push({ ...product, qty });
        }
        this.save();

        // Track conversion
        if (typeof gtag !== 'undefined') {
            gtag('event', 'add_to_cart', {
                currency: 'USD',
                value: product.price * qty,
                items: [{
                    item_id: product.id,
                    item_name: product.name,
                    item_category: product.category,
                    price: product.price,
                    quantity: qty
                }]
            });
        }
        if (typeof fbq !== 'undefined') {
            fbq('track', 'AddToCart', {
                content_ids: [product.id],
                content_name: product.name,
                content_type: product.category,
                value: product.price * qty,
                currency: 'USD'
            });
        }

        this.showToast(`✅ Added ${qty}× ${product.name} to cart`);
    },

    remove(id) {
        this.items = this.items.filter(i => i.id !== id);
        this.save();
    },

    updateQty(id, qty) {
        const item = this.items.find(i => i.id === id);
        if (!item) return;
        if (qty < (item.minQty || 1)) {
            this.remove(id);
            return;
        }
        item.qty = qty;
        this.save();
    },

    clear() {
        this.items = [];
        this.save();
    },

    total() {
        return this.items.reduce((sum, item) => sum + item.price * item.qty, 0);
    },

    count() {
        return this.items.reduce((sum, item) => sum + item.qty, 0);
    },

    updateBadge() {
        const badge = document.querySelector('.cart-badge');
        if (!badge) return;
        const count = this.count();
        badge.textContent = count;
        badge.style.display = count > 0 ? 'inline-flex' : 'none';
    },

    render() {
        this.updateBadge();
        const cartItemsEl = document.querySelector('.cart-items');
        const cartTotalEl = document.querySelector('.cart-total-amount');
        if (!cartItemsEl) return; // not on cart page

        if (this.items.length === 0) {
            cartItemsEl.innerHTML = '<p class="cart-empty">Your cart is empty. <a href="products.html">Browse catalog →</a></p>';
            if (cartTotalEl) cartTotalEl.textContent = '$0.00';
            return;
        }

        cartItemsEl.innerHTML = this.items.map(item => `
            <div class="cart-item" data-id="${item.id}">
                <img src="${item.image}" alt="${item.name}" class="cart-item-img" loading="lazy">
                <div class="cart-item-info">
                    <h3>${item.name}</h3>
                    <p class="cart-item-sku">SKU: ${item.sku}</p>
                    <p class="cart-item-price">$${item.price.toFixed(2)} / pc</p>
                </div>
                <div class="cart-item-qty">
                    <button class="qty-btn qty-minus" data-id="${item.id}">−</button>
                    <input type="number" class="qty-input" value="${item.qty}" min="${item.minQty || 1}" data-id="${item.id}">
                    <button class="qty-btn qty-plus" data-id="${item.id}">+</button>
                </div>
                <div class="cart-item-subtotal">
                    <strong>$${(item.price * item.qty).toFixed(2)}</strong>
                    <button class="cart-item-remove" data-id="${item.id}">Remove</button>
                </div>
            </div>
        `).join('');

        if (cartTotalEl) cartTotalEl.textContent = `$${this.total().toFixed(2)}`;

        // Bind qty controls
        cartItemsEl.querySelectorAll('.qty-minus').forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.dataset.id;
                const item = this.items.find(i => i.id === id);
                if (item) this.updateQty(id, item.qty - (item.minQty || 1));
            });
        });
        cartItemsEl.querySelectorAll('.qty-plus').forEach(btn => {
            btn.addEventListener('click', () => {
                const id = btn.dataset.id;
                const item = this.items.find(i => i.id === id);
                if (item) this.updateQty(id, item.qty + (item.minQty || 1));
            });
        });
        cartItemsEl.querySelectorAll('.qty-input').forEach(input => {
            input.addEventListener('change', () => {
                const id = input.dataset.id;
                const qty = parseInt(input.value) || 1;
                this.updateQty(id, qty);
            });
        });
        cartItemsEl.querySelectorAll('.cart-item-remove').forEach(btn => {
            btn.addEventListener('click', () => this.remove(btn.dataset.id));
        });
    },

    bindUI() {
        // Cart trigger (open cart page)
        document.querySelectorAll('[data-action="cart"], .cart-trigger').forEach(el => {
            el.addEventListener('click', (e) => {
                e.preventDefault();
                window.location.href = 'cart.html';
            });
        });
    },

    showToast(msg) {
        const existing = document.querySelector('.cart-toast');
        if (existing) existing.remove();

        const t = document.createElement('div');
        t.className = 'cart-toast';
        t.textContent = msg;
        t.style.cssText = `
            position: fixed;
            top: 90px;
            right: 24px;
            padding: 14px 20px;
            background: var(--success);
            color: white;
            border-radius: 10px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
            z-index: 1000;
            font-weight: 600;
            animation: slideIn 0.3s ease;
        `;
        document.body.appendChild(t);
        setTimeout(() => {
            t.style.opacity = '0';
            t.style.transition = 'opacity 0.3s';
            setTimeout(() => t.remove(), 300);
        }, 3000);
    },

    checkoutWhatsApp() {
        if (this.items.length === 0) {
            alert('Cart is empty');
            return;
        }
        const lines = [
            `Hi PinForge! I'd like to order:`,
            ``,
            ...this.items.map(i => `• ${i.qty}× ${i.name} (${i.sku}) — $${(i.price * i.qty).toFixed(2)}`),
            ``,
            `*Total: $${this.total().toFixed(2)}* (before shipping)`,
            ``,
            `Please confirm MOQ, lead time & shipping to my country. Thanks!`
        ];
        const text = lines.join('\n');
        const url = `https://wa.me/861****8590?text=${encodeURIComponent(text)}`;
        window.open(url, '_blank');

        // Track checkout event
        if (typeof gtag !== 'undefined') {
            gtag('event', 'begin_checkout', {
                currency: 'USD',
                value: this.total(),
                items: this.items.map(i => ({
                    item_id: i.id,
                    item_name: i.name,
                    price: i.price,
                    quantity: i.qty
                }))
            });
        }
        if (typeof fbq !== 'undefined') {
            fbq('track', 'InitiateCheckout', {
                content_ids: this.items.map(i => i.id),
                num_items: this.count(),
                value: this.total(),
                currency: 'USD'
            });
        }
    }
};

// Global helper: add to cart from product pages
window.addProductToCart = function(product) {
    Cart.add(product, product.minQty || 50);
};

document.addEventListener('DOMContentLoaded', () => Cart.init());
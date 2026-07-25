/* ==============================================
   Product Gallery — Image switcher for product detail pages
   ============================================== */

(function() {
    'use strict';

    const mainImage = document.getElementById('mainImage');
    const thumbs = document.querySelectorAll('.thumb');

    if (!mainImage || thumbs.length === 0) return;

    thumbs.forEach(thumb => {
        thumb.addEventListener('click', () => {
            const imgUrl = thumb.dataset.img;
            if (!imgUrl) return;

            // Update main image with fade effect
            mainImage.style.opacity = '0';
            setTimeout(() => {
                mainImage.src = imgUrl;
                mainImage.style.opacity = '1';
            }, 150);

            // Update active thumb
            thumbs.forEach(t => t.classList.remove('active'));
            thumb.classList.add('active');
        });
    });

    // Keyboard navigation for accessibility
    let currentIndex = 0;
    document.addEventListener('keydown', (e) => {
        if (!mainImage) return;
        if (e.key === 'ArrowLeft') {
            currentIndex = (currentIndex - 1 + thumbs.length) % thumbs.length;
            thumbs[currentIndex].click();
        } else if (e.key === 'ArrowRight') {
            currentIndex = (currentIndex + 1) % thumbs.length;
            thumbs[currentIndex].click();
        }
    });

    // Update currentIndex on thumb click
    thumbs.forEach((thumb, i) => {
        thumb.addEventListener('click', () => { currentIndex = i; });
    });
})();
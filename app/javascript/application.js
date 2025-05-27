// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
document.addEventListener('DOMContentLoaded', () => {
  const flashMessages = document.querySelectorAll('.alert');
  flashMessages.forEach((el) => {
    setTimeout(() => {
      el.style.transition = 'opacity 0.5s ease-out';
      el.style.opacity = '0';
      setTimeout(() => el.remove(), 500); // remove from DOM after fade out
    }, 3000); // 2 seconds
  });
});

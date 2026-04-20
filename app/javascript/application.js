// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails

const fadeFlashMessages = () => {
  const flashMessages = document.querySelectorAll(".alert")
  flashMessages.forEach((el) => {
    if (el.dataset.fadeScheduled === "true") return
    el.dataset.fadeScheduled = "true"

    setTimeout(() => {
      el.style.transition = "opacity 0.5s ease-out"
      el.style.opacity = "0"
      setTimeout(() => el.remove(), 500)
    }, 3000)
  })
}

document.addEventListener("DOMContentLoaded", () => {
  fadeFlashMessages()
})

document.addEventListener("turbo:load", () => {
  fadeFlashMessages()
})

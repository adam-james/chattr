export default function global() {
  hamburgerMenu()
}

function hamburgerMenu() {
  var rootElem = document.querySelector('.NavMenu')
  var toggleElem = document.getElementById('hamburger-toggle')
  var openClassName = 'NavMenu--open'

  toggleElem.addEventListener('click', handleOpen)

  function handleOpen() {
    openMenu()
    setTimeout(() => {
      toggleElem.removeEventListener('click', handleOpen)
      window.addEventListener('click', handleClose)
    }, 0)
  }

  function handleClose() {
    window.removeEventListener('click', handleClose)
    toggleElem.addEventListener('click', handleOpen)
    closeMenu()
  }

  function openMenu() {
    rootElem.classList.add(openClassName)
  }

  function closeMenu() {
    rootElem.classList.remove(openClassName)    
  }

  function isOpen() {
    return rootElem.classList.contains(openClassName)
  }
}

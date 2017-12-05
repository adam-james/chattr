export default function global() {
  hamburgerMenu()
}

function hamburgerMenu() {
  var rootElem = document.querySelector('.NavMenu')
  var toggleElem = document.getElementById('hamburger-toggle')
  var openClassName = 'NavMenu--open'

  toggleElem.addEventListener('click', handleToggle)

  function handleToggle() {
    if (isOpen()) {
      return closeMenu()
    }
    openMenu()
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

export default function showTopic() {
  chatMeta()
}

function chatMeta() {
  let metaHeaderElem = document.querySelector('.TopicMeta__header')
  let headerHeight = document.querySelector('.GlobalHeader').clientHeight
  let metaFixed = (window.pageYOffset > headerHeight)
  let fixedClassName = 'TopicMeta__header--fixed'

  window.addEventListener('scroll', handleScroll)

  function handleScroll() {
    if (shouldBeFixed() && !metaFixed) fixMeta()
    if (!shouldBeFixed() && metaFixed) unFixMeta()
  }

  function shouldBeFixed() {
    return window.pageYOffset > headerHeight
  }

  function fixMeta() {
    metaFixed = true
    metaHeaderElem.classList.add(fixedClassName)
  }

  function unFixMeta() {
    metaFixed = false
    metaHeaderElem.classList.remove(fixedClassName)
  }
}

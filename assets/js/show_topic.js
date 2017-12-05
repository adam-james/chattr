import { chat } from "./socket"

export default function showTopic() {
  chatMeta()
  chat()
}

function chatMeta() {
  let metaHeaderElem = document.querySelector('.TopicMeta__header')
  let headerHeight = document.querySelector('.GlobalHeader').clientHeight
  let fixedClassName = 'TopicMeta__header--fixed'

  window.addEventListener('scroll', handleScroll)

  function handleScroll() {
    if (shouldBeFixed() && !isFixed()) fixMeta()
    if (!shouldBeFixed() && isFixed()) unFixMeta()
  }

  function isFixed() {
    return metaHeaderElem.classList.contains(fixedClassName)
  }

  function shouldBeFixed() {
    return window.pageYOffset > headerHeight
  }

  function fixMeta() {
    metaHeaderElem.classList.add(fixedClassName)
  }

  function unFixMeta() {
    metaHeaderElem.classList.remove(fixedClassName)
  }
}

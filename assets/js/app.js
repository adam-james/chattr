// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import { chat } from "./socket"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

function slideUpLead() {
  let landingLead = document.getElementById('landing-lead')
  setTimeout(function() {
    landingLead.classList.add('slide-up--visible')  
  }, 500)
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

if (window.location.pathname === '/') {
  slideUpLead()
} else if (/\/chat\/topics\/[0-9]+/.test(location.pathname)) {
  chat()
  chatMeta()
}

export default function landingPage() {
  slideUpLead()
}

function slideUpLead() {
  let landingLead = document.getElementById('landing-lead')
  setTimeout(function() {
    landingLead.classList.add('slide-up--visible')  
  }, 500)
}

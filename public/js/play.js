$(document).ready(function() {
  $(".add, .remove, .star").click(function(){
    element = $(this)
    element
      .parent()
      .html('<img src="/images/spinner.gif" />')
      .load(element.attr("href"), {q: ''})
    return false
  })
})

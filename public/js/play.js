$(document).ready(function() {
  $(".add, .remove").click(function(){
    element = $(this)
    element
      .parent()
      .html('<img src="/images/spinner.gif" />')
      .load(element.attr("href"))
    return false
  })
})

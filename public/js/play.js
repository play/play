$(document).ready(function() {
  $(".add, .remove, .star").click(function(){
    element = $(this)
    element
      .parent()
      .html('<img src="/images/spinner.gif" class="spinner" />')
      .load(element.attr("href"), {q: ''})
    return false
  })

  $(".controller a").click(function(){
    element = $(this)
    $.post(element.attr("href"), function(){
      if (element.text() == "❯")
        element.text('❙❙')
      else if (element.text() == "❯❯")
        ''
      else
        element.text('❯')
    })
    return false
  })
})

class SongView extends Backbone.View
  #tagName: 'li'
  initialize: ->
    @template = $('#color-box-template').template()
    @model.bind 'change', @render
    @model.view = @

  render: =>
    $(@el).html $.tmpl @template, @model.toJSON()
    return @
class Cust
  description: ""
  constructor: (@description) ->



SfuncubeHackathon.EditMessageView = Ember.View.extend
  templateName: "edit_message"
  classNames: ["edit-body"]

SfuncubeHackathon.CustomizationsSelectView = Ember.View.extend
  class: "select-customizations"
  templateName: "customizations"
  availableCustomizations: [ ]
  init: ->
    @_super()
    @set 'availableCustomizations', [
      new Cust( "Louisiana has the best solar rebates in the country: get tax breaks to pay for 80% of your system"),
      new Cust( "You can own solar for less than it costs to lease"),
      new Cust("The average out of pocket cost is less than $4,000")
    ]




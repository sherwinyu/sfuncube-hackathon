SfuncubeHackathon.SelectRecipientView = Ember.View.extend
  classNames: ["select-recipient"]
  templateName: "select_recipient"
  _rankedFriends: null
  query: ""
  selectedFriends: null

  actions:
    addFriend: (friend)->
      @set('selectedFriends', []) unless @get('selectedFriends')
      @get('selectedFriends').pushObject(friend)

    removeFriend: (friend) ->
      @get('selectedFriends').pushObject(friend)
      @get('selectedFriends').removeObject(friend)

  displayingFriends: (->
    @get('query')?.length > 0
  ).property('query')

  displayingNewFriendSuggestion: (->
    @get('query')?.length > 0
  ).property 'query'

  displayedFriends: (->
    @get('_rankedFriends')
  ).property '_rankedFriends', '_rankedFriends.@each'

  newFriendClicked: (friendName) ->
    recipient = Weave.User.createRecord
      name: friendName
    recipient.set('meta.role', 'recipient-new')
    @get('context').set('recipient', recipient)
    @get('controller').send 'recipientSelected'

  friendClicked: (friend)->
    recipient = Weave.User.createRecord friend.user
    recipient.set('meta.role', 'recipient')
    @get('context').set('recipient', recipient)

    # Fill in the input fields
    @$("#name-or-email").val friend.user.name
    @get('controller').send 'recipientSelected'


  didInsertElement: ->
    @initAutocompletion @$('input')
    if @get('controller.selectingRecipient')
      @$('#wala')?.val ''

  init: ->
    @set('_rankedFriends', [])

    @set('friendFilter', lu 'friendFilter:main')
    @_super()

  initAutocompletion: ($el) ->
    $el.autocomplete
      select: (event, ui) =>
        Em.assert "jquery-autocomplete-select event should not happen because we are custom rolling a solution"

      focus: (event, ui) =>
        @$(".recipient-name-or-email").val ui.item.label
      minLength: 2

      source: (request, response) =>
        @get('friendFilter').filterAndRankAgainst(request.term).then (friends) =>
          @updateDisplayedFriends(friends)
          unless @get('recdFriends')?
            @get('friendFilter')._friends.then (ff) =>
              recdFriends = ff.slice(30,35)
              @set 'recdFriends', recdFriends

  # updateDisplayedFriends
  # Context: called by autocomplete#source with the result of
  # `friendFilter.rankAgainstTerm`.
  # param friends: a list of friendStructs
  # Behavior
  #   1) it sets the view's _rankedFriends to a copy of the friends
  #   2) it notifiesPropertyChange of _rankedFriends
  updateDisplayedFriends: (friends) ->
    @set('_rankedFriends', friends.copy())
    @notifyPropertyChange('_rankedFriends')

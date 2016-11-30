twit = require 'twit'
config = require './config.js'

rand = (arr) ->
  index = Math.floor(Math.random()*arr.length)
  return arr[index]

Twitter = new twit config

retweet = () ->
  params =
    q: '#logistics, #shipping, #freight, #supplychain'
    result_type: 'mixed'
    lang: 'en'

  Twitter.get 'search/tweets', params, (err, data) ->
    if not err
      retweetId = data.statuses[0].id_str
      Twitter.post 'statuses/retweet/:id',
        id: retweetId
        (err, response) ->
          if response
            console.log 'Retweeted!'
          if err
            console.log 'Something went wrong while Retweeting.'
            console.log err
    else
      console.log 'Something went wrong while Searching.'

favoriteTweet = () ->
  params = 
    q: '#logistics, #shipping, #transport'
    result_type: 'mixed'
    lang: 'en'

  Twitter.get 'search/tweets', params, (err, data) ->
    tweet = data.statuses
    randomTweet = rand tweet

    if typeof randomTweet != 'undefined'
      Twitter.post 'favorites/create', {id: randomTweet.id_str}, (err, response) ->
        if err
          console.log 'Something went wrong on Favorite Tweet.'
        else
          console.log 'Favorite OK.'

favoriteTweet()

setInterval favoriteTweet, 15*60*1000

retweet()

setInterval retweet, 15*60*1000





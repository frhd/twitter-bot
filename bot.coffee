twit = require 'twit'
config = require './config.js'

rand = (arr) ->
  index = Math.floor(Math.random()*arr.length)
  return arr[index]

Twitter = new twit config

queryList = ['#logistics', '#shipping', '#freight', '#supplychain', '#exports', '#trade']

retweet = () ->
  params =
    q: rand queryList
    result_type: 'mixed'
    lang: 'en'

  Twitter.get 'search/tweets', params, (err, data) ->
    tweet = data.statuses
    randomTweet = rand tweet

    if !err?
      retweetId = randomTweet.id_str
      Twitter.post 'statuses/retweet/:id',
        id: retweetId
        (err, response) ->
          if response? && !err?
            console.log 'Retweeted!'
          if err?
            console.log 'Something went wrong while Retweeting.'
            console.log err.message
    else
      console.log 'Something went wrong while Searching.'
      console.log err

favoriteTweet = () ->
  params =
    q: rand queryList
    result_type: 'mixed'
    lang: 'en'

  Twitter.get 'search/tweets', params, (err, data) ->
    tweet = data.statuses
    randomTweet = rand tweet

    if typeof randomTweet != 'undefined'
      Twitter.post 'favorites/create', {id: randomTweet.id_str}, (err, response) ->
        if err?
          console.log 'Something went wrong on Favorite Tweet.'
          console.log err.message
        else
          console.log 'Favorite OK.'

favoriteTweet()

setInterval favoriteTweet, 5*60*1000

retweet()

setInterval retweet, 5*60*1000

module.exports = (app) ->
  app.get '/', (req, res) ->
    vars =
      voteKeys:
        yea: 'Voted Yea'
        nay: 'Voted Nay'
        excused: 'Excused'
        notvoting: 'Not Voting'
        unknown: 'Unknown'

    res.render 'index', vars

#

UrbanAirship = require 'urban-airship'

ua = new UrbanAirship process.env.URBANAIRSHIP_DEV_APP_KEY,
  process.env.URBANAIRSHIP_DEV_SECRET,
  process.env.URBANAIRSHIP_DEV_MASTER_SECRET

ALERT_MSG = "Your ThermoStat has been recalled! Please contact the manufacturer"

exports.log_drain = (req, res) ->
  req.body.map (line) ->
    if line.recall
      push_token = process.env.PUSH_TOKEN || line.push_token
      payload =
        device_tokens: [push_token]
        aps:
          alert: ALERT_MSG
          badge: 0
      ua.pushNotification '/api/push', payload, (err) ->
        console.log "push-notification=#{push_token}"
        console.log(err) if err

  res.send('OK')

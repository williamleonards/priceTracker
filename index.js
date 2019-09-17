const PushNotifications = require('@pusher/push-notifications-server');
const request = require('request');
const express = require('express');
const SetInterval = require('set-interval')

var app = express();

var currentPrice = 10527;
var prevPrice = 10527;
var todayHigh;
var todayLow;
var lowBound = 10500;
var highBound = 10550;

app.get('/hello', function (req, res) {
  res.send("Hello World!");
});

// app.post('/', function (req,res) {

// });

app.listen(3000);

function precise(x) {
  return Number.parseFloat(x).toPrecision(4);
}

function notify(message) {
  let beamsClient = new PushNotifications({
    instanceId: '6a0f389a-e1ac-4d26-8aa7-53c13a76c540',
    secretKey: '902B2A9CB48D899FB81E7666BF868BE5ADA33D34E1A932DCE08AA65C43D65D53'
  });

  beamsClient.publish(['hello'], {
    apns: {
      aps: {
        alert: message
      }
    }
  }).then((publishResponse) => {
    console.log('Just published:', publishResponse.publishId);
  }).catch((error) => {
    console.log('Error:', error);
  });
}

function updatePrice(price) {
  prevPrice = currentPrice;
  currentPrice = price
}

function getPrice(low, high) {
  console.log("Fetching price...")
  request.get("https://api.coindesk.com/v1/bpi/currentprice.json", (err, res) => {

    if (err) {
      console.log(err);
      notify(err);
      return;
    }

    const body = JSON.parse(res.body);
    updatePrice(body.bpi.USD.rate_float);

    // TO BE ENCLOSED IN A FUNCTION LATER
    if (currentPrice > highBound && prevPrice <= highBound) {
      notify("BTC price exceeds " + highBound.toString() + ". Now at " + currentPrice.toString());
      // SET TO UPDATE BOUNDS BY A WIDTH OF 4%
      lowBound = precise(highBound * 0.98);
      highBound = precise(highBound * 1.02);
    } else if (currentPrice < lowBound && prevPrice >= lowBound) {
      notify("BTC price dips below " + lowBound.toString() + ". Now at " + currentPrice.toString());
      // SET TO UPDATE BOUNDS BY A WIDTH OF 4%
      highBound = precise(lowBound * 1.02);
      loqBound = precise(lowBound * 0.98);
    }

    console.log("Fetched price. \nPrev: " + prevPrice + "\nCurrent: " + currentPrice
      + "\nHighBound: " + highBound + "\nLowBound: " + lowBound);
    console.log("______________________________________________")
  });
}

SetInterval.start(getPrice, 60000, 'test')

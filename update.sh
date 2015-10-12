#!/usr/bin/env node

var cheerio = require('cheerio')
var fetch = require('node-fetch')
var fs = require('fs')

var constants = {}
var url = 'http://doc.satoshilabs.com/slips/slip-0044.html'

fetch(url).then(function (res) {
  return res.text()
})
.then(function (body) {
  $ = cheerio.load(body)
  $('table tr').each(function (i, el) {
    var cols = $(el).find('td')
    var index = $(cols[0]).text()
    if (!index) return // table header

    var coin = $(cols[2]).text().replace(/\(.*/, '').trim()
    var constant = $(cols[1]).text()
    constants[coin] = constant
  })
  fs.writeFileSync('./constants.json', JSON.stringify(constants, null, 2))
})
.catch(function (err) {
  console.error(err)
  process.exit(1)
})
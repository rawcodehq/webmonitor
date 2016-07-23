const assert = require('chai').assert;

const index = require('../index.js')

describe('handler', ()=>{
  it('200 status should return a successful response for http', (done)=>{
    index.handler({url: "http://httpstat.us/200"}, null, function(err, resp){
      assert.equal(err, null)
      assert.equal(resp.status, 200)
      assert.equal(resp.response_time_ms > 100 && resp.response_time_ms < 1000, true)
      done()
    })
  })

  it('200 status should return a successful response for https', (done)=>{
    index.handler({url: "https://webmonitorhq.com/"}, null, function(err, resp){
      assert.equal(err, null)
      assert.equal(resp.status, 200)
      assert.equal(resp.response_time_ms > 100 && resp.response_time_ms < 1000, true)
      done()
    })
  })

  it('non 200 status should return the status as is', (done)=>{
    index.handler({url:  "http://httpstat.us/203"}, null, function(err, resp){
      assert.equal(err, null)
      assert.equal(resp.status, 203)
      assert.equal(resp.response_time_ms > 100 && resp.response_time_ms < 1000, true)
      done()
    })
  })

  it('300 series status should return status as is', (done)=>{
    index.handler({url:  "http://httpstat.us/303"}, null, function(err, resp){
      assert.equal(err, null)
      assert.equal(resp.status, 303)
      assert.equal(resp.response_time_ms > 100 && resp.response_time_ms < 1000, true)
      done()
    })
  })

  it('400 series status should return status as is', (done)=>{
    index.handler({url:  "http://httpstat.us/404"}, null, function(err, resp){
      assert.equal(err, null)
      assert.equal(resp.status, 404)
      assert.equal(resp.response_time_ms > 100 && resp.response_time_ms < 1000, true)
      done()
    })
  })

  it('500 series status should return status as is', (done)=>{
    index.handler({url: "http://httpstat.us/503"}, null, function(err, resp){
      assert.equal(err, null)
      assert.equal(resp.status, 503)
      assert.equal(resp.response_time_ms > 100 && resp.response_time_ms < 1000, true)
      done()
    })
  })

  it('nxdomain should return a down status', (done)=>{
    index.handler({url: "http://mujjuisawesomeandzainabtoo"}, null, function(err, resp){
      assert.equal(err, null)
      assert.equal(resp.status, 'down')
      assert.equal(resp.response_time_ms > 0 && resp.response_time_ms < 1000, true)
      done()
    })
  })

  it('connection error should return a down status', function(done){
    this.timeout(1.5 * 1000);

    index.handler({url: "http://httpstat.us:5033/"}, null, function(err, resp){
      assert.equal(err, null)
      assert.equal(resp.status, 'down')
      assert.equal(resp.response_time_ms > 0 && resp.response_time_ms < 1.5 * 1000, true)
      done()
    })
  })

})

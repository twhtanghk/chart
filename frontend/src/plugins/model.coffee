{Model} = require('model').default

export default
  Stock: new Model
    baseUrl: "#{process.env.API_URL}/stock"
  CryptoCurr: new Model
    baseUrl: "#{process.env.API_URL}/cryptoCurr"
  Breadth: new Model
    baseUrl: "#{process.env.API_URL}/breadth"

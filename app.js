const express = require('express');
const multer = require('multer');
const ejs = require('ejs');
const path = require('path');


const app = express()
const port = 3000

app.set('view engine', 'ejs');
app.use(express.static('./public'))

app.get('/', (req, res) => res.render('index'))

app.post('/upload', (req, res) => { // we use app.post request to /uploads 
  upload(req, res, (err) => {
    if(err){
      res.render('index', {
        msg: err
      });
    } else {
      console.log(req.file);
      res.send('test');
    }

  })
})

app.listen(port, () => console.log(`Example app listening on port ${port}!`))

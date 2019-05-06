const http = require('http');
const multer = require('multer');
const ejs = require('ejs');
const path = require('path');

const express = require('express');
const router = express.Router();
const app = express();

router.get('/',function(req,res){
  res.sendFile(path.join(__dirname+'/index.html'));
  
});


const hostname = '127.0.0.1';
const port = 3000;

app.get('/',function(req,res) {
  res.sendFile('index.html');
});

const server = http.createServer((req, res) => {
  res.statusCode = 200;
  res.setHeader('Content-Type', 'text/plain');
});

server.listen(port, hostname, () => {
  console.log(`Server running at http://${hostname}:${port}/`);
});
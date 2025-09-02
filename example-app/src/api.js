import http from 'node:http';
import process from 'node:process';

http.createServer((_request, response) => {
  response.writeHead(200);
  response.end('hey');
}).listen(process.env.PORT || 3000, () => {
  console.log('App listening on port 3000');
});

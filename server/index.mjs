import Server from './server.mjs'
const app = new Server({
  port: 8080
})
app.get('/hello', (req, res) => {
  res.status(200)
    .send('howdy 🤠')
})

app.start()

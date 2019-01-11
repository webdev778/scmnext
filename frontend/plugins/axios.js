export default function ({ $axios, redirect }) {
  $axios.onResponse( response => {
    console.log("plugin")
    console.log(response)
  })
  $axios.onError( error => {
    console.log("plugin")
    console.log(error)
  })
}
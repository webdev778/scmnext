export default function ({ store, $axios, redirect }) {
  $axios.onRequest( config => {
    if (store.getters.isLoggedIn){
      config.headers['access-token'] = store.state.auth.accessToken
      config.headers['client'] = store.state.auth.client
      config.headers['uid'] = store.state.auth.uid
    }
    return config
  })
  $axios.onResponse( response => {
    let headers = response.headers
    if (headers['access-token']){
      let auth = {
        accessToken: headers['access-token'],
        client: headers['client'],
        uid: headers['uid']
      }
      console.log('set token')
      console.log(auth)
      store.commit('setAuth', auth)
    }
    return response
  })
  $axios.onError( error => {
    return error
  })
}
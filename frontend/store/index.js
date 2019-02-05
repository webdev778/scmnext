// import Vuex from 'vuex'
const cookieparser = process.server ? require('cookieparser') : undefined
const Cookie = process.client ? require('js-cookie') : undefined

export const state = () => ({
  auth: null,
  loginErrors: []
})

export const mutations = {
  setAuth (state, auth) {
    state.auth = auth
    if (process.client){
      Cookie.set('auth', auth)
    }
  },
  setLoginErrors (state, errors) {
    state.loginErrors = errors
  }
}

export const getters = {
  isLoggedIn: state => {
    return state.auth != null
  }
}

export const actions = {
  nuxtServerInit({ commit }, { req }) {
    let auth = null
    if (req.headers.cookie) {
      const parsed = cookieparser.parse(req.headers.cookie)
      try {
        auth = JSON.parse(parsed.auth)
        commit('setAuth', auth)
      } catch (err) {
        console.log(err)
        // No valid cookie found
      }
    }
  },
  login( {commit}, { email, password }) {
    this.$axios.post('/auth/sign_in', { email: email, password: password})
    .then(result=>{
      if (result && result.data) {
        console.log("hoge")
        this.$router.push('/')
      } else if (result.response) {
        console.log("hoge")
        console.log(result.response.data)
        commit('setLoginErrors', result.response.data.errors)
      } else {
        console.log(result)
        commit('setLoginErrors', ["接続エラー"])
      }
    })
  },
  logout( {commit} ) {
    commit('setAuth', null)
    this.$router.push('/session/new')
  }

}

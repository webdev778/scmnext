// import Vuex from 'vuex'
const cookieparser = process.server ? require('cookieparser') : undefined
const Cookie = process.client ? require('js-cookie') : undefined

export const state = () => ({
  auth: null
})

export const mutations = {
  setAuth (state, auth) {
    state.auth = auth
    Cookie.set('auth', auth)
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
  async login( {}, { email, password }) {
    let result = await this.$axios.post('/auth/sign_in', { email: email, password: password})
    .then(result=>{
      this.$router.push('/')
      return result
    })
    .catch(error=>{
      return error.response
    })
    return result
  },
  logout( {commit} ) {
    commit('setAuth', null)
    this.$router.push('/session/new')
  }

}

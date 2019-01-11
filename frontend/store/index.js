import Vuex from 'vuex'
const cookieparser = process.server ? require('cookieparser') : undefined

export const state = () => ({
  auth: null
})

export const mutations = {
  setAuth(state, auth) {
    console.log('setAuth')
    console.log(auth)
    state.auth = auth
  }
}

export const actions = {
  nuxtServerInit({ commit }, { req }) {
    let auth = null
    console.log("init")
    if (req.headers.cookie) {
      console.log(req.headers.cookie)
      const parsed = cookieparser.parse(req.headers.cookie)
      console.log(parsed)
      try {
        auth = JSON.parse(parsed.auth)
      } catch (err) {
        console.log(err)
        // No valid cookie found
      }
    }
    commit('setAuth', auth)
  },
  login({}, { email, password }) {

  },
  logout({ commit }) {
    commit('setAuth', null)
  }

}

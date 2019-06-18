// import Vuex from 'vuex'
const cookieparser = process.server ? require('cookieparser') : undefined
const Cookie = process.client ? require('js-cookie') : undefined

export const state = () => ({
  auth: null,
  uid: null,
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
    console.log('ログインチェック')
    if (state.auth != null){
      console.log('ログイン中')
    } else {
      console.log('未ログイン')
    }
    return state.auth != null
  }
}

export const actions = {
  nuxtServerInit({ commit }, { req }) {
    let auth = null
    if (req.headers.cookie) {
      const parsed = cookieparser.parse(req.headers.cookie)
      console.log(parsed)
      try {
        if (parsed.auth){
          auth = JSON.parse(parsed.auth)
          commit('setAuth', auth)
        }
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
        // 成功時
        Cookie.set('uid', email)
        this.$router.push('/')
      } else if (result.response) {
        // 認証不成功時
        console.log('認証エラー')
        console.log(result.response.data)
        commit('setLoginErrors', result.response.data.errors)
      } else {
        // サーバー接続不成功時
        console.log('接続エラー')
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

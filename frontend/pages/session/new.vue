<template lang="pug">
  .app.flex-row.align-items-center
    .container
      b-row.justify-content-center
        b-col(md="6")
          b-card-group
            b-card.p-4(no-body="")
              b-card-body
                h1 ログイン
                p.text-muted メールアドレスとパスワードを入力してサインインしてください。
                .alert.alert-danger(v-if='errorMessages.length > 0')
                  ul
                    li(v-for="(msg, index) in errorMessages") {{msg}}
                b-input-group.mb-3
                  b-input-group-prepend
                    b-input-group-text
                      i.icon-user
                  input.form-control(type="text" placeholder="Eメール" v-model="email")
                b-input-group.mb-4
                  b-input-group-prepend
                    b-input-group-text
                      i.icon-lock
                  input.form-control(type="password" placeholder="パスワード" v-model="password")
                b-row
                  b-col(cols="6")
                    b-button.px-4(variant="primary" v-on:click="login") ログイン
                  b-col.text-right(cols="6")
                    b-button.px-0(variant="link") パスワードを忘れた場合
</template>

<script>
const Cookie = process.client ? require('js-cookie') : undefined

export default {
  name: 'Login',
  layout: 'clean',
  middleware: 'notAuthenticated',
  data() {
    return {
      errorMessages: [],
      email: null,
      password: null
    }
  },
  methods: {
    login() {
      this.$axios.post('/auth/sign_in', {email: this.email, password: this.password})
      .then( response=>{
        console.log(response.headers)
        console.log(response.data)
        const auth = {
          accessToken: response.headers["access-token"]
        }
        Cookie.set('auth', auth)
        this.$store.setAuth(auth)
      })
      .catch( error=>{
        if (error.response){
          this.errorMessages = []
          error.response.data.errors.forEach(msg=>{
            this.errorMessages.push(msg)
          })
          console.log(error.response.data)
          console.log(error.response.headers)
        }
      })
    }
  }
}
</script>

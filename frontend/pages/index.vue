<template lang="pug">
  div(v-if="$store.state.auth")
    .animated.fadeIn
      | yay!
</template>

<script>

export default {
  name: 'toppage',
  data: function () {
    return {}
  },
  mounted() {
    console.log(this.$store.state.auth)
    if (!this.$store.state.auth) {
      console.log('not logged in')
      this.$router.push("/session/new")
    }
  }
}
</script>
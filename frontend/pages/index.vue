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
  }
}
</script>
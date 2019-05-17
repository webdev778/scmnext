<template>
      <b-nav-item-dropdown right no-caret>
        <template slot="button-content">
          <img src="~static/img/avatars/user.jpg" class="img-avatar">
        </template>
        <b-dropdown-item @click="logout"><i class="fa fa-lock"></i> ログアウト</b-dropdown-item>
      </b-nav-item-dropdown>
</template>

<script>
  export default {
    name: 'header-dropdown',
    data: () => {
      return { itemsCount: 42 }
    },
    methods: {
      logout() {
        this.$store.dispatch('logout')
      }
    }
  }
</script>


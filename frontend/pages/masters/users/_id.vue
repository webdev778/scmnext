<template lang="pug">
  rest-form(
    title="ユーザー詳細"
    name="user"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:can-edit="false"
  )
</template>

<script>
import RestForm from '~/components/Rest/RestForm.vue'

export default {
  components: {RestForm},
  data() {
    return {
      id: null,
      fields: [
        {
          key: "id",
          type: "hidden"
        },
        {
          key: "provider",
          type: "text",
          label: "プロバイダ"
        },
        {
          key: "uid",
          type: "text",
          label: "UID"
        },
        {
          key: "email",
          type: "text",
          label: "EMAIL"
        },
        {
          key: "encrypted_password",
          type: "text",
          label: "パスワード(暗号化済)"
        },
        {
          key: "reset_password_token",
          type: "text",
          label: "パスワードリセット時トークン"
        },
        {
          key: "reset_password_sent_at",
          type: "text",
          label: "パスワードリセット要求日時"
        },
        {
          key: "remember_created_at",
          type: "text",
          label: "remember_created_at"
        },
        {
          key: "sign_in_count",
          type: "text",
          label: "サインイン回数"
        },
        {
          key: "current_sign_in_at",
          type: "text",
          label: "現在サインイン日時"
        },
        {
          key: "last_sign_in_at",
          type: "text",
          label: "最終サインイン日時"
        },
        {
          key: "current_sign_in_ip",
          type: "text",
          label: "現在サインインIPアドレス"
        },
        {
          key: "last_sign_in_ip",
          type: "text",
          label: "最終サインインIPアドレス"
        },
        {
          key: "password_salt",
          type: "text",
          label: "パスワードソルト"
        },
        {
          key: "tokens",
          type: "text",
          label: "tokens"
        },
        {
          key: "accesable_type",
          type: "text",
          label: "accesable_type"
        },
        {
          key: "accesable_id",
          type: "text",
          label: "accesable_id"
        }
      ]
    }
  }
}
</script>


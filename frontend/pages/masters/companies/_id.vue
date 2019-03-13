<template lang="pug">
  rest-form(
    title="PPS詳細"
    name="company"
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
          key: "name",
          type: "text",
          label: "名前"
        },
        {
          key: "code",
          type: "text",
          label: "コード"
        },
        {
          key: "name_kana",
          type: "text",
          label: "名前(カナ)"
        },
        {
          key: "postal_code",
          type: "text",
          label: "郵便番号"
        },
        {
          key: "pref_no",
          label: "都道府県番号"
        },
        {
          key: "city",
          type: "text",
          label: "市区町村"
        },
        {
          key: "address",
          type: "text",
          label: "住所"
        },
        {
          key: "tel",
          type: "text",
          label: "TEL"
        },
        {
          key: "fax",
          type: "text",
          label: "FAX"
        },
        {
          key: "email",
          type: "text",
          label: "EMAIL"
        }
      ]
    }
  }
}
</script>


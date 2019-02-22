<template lang="pug">
  rest-form(
    title="契約顧客詳細"
    name="consumer"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:options="options"
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
          key: "company_id",
          type: "select",
          label: "PPS ID"
        },
        {
          key: "code",
          type: "text",
          label: "コード"
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
        },
        {
          key: "postal_code",
          type: "text",
          label: "郵便番号"
        },
        {
          key: "pref_no",
          type: "text",
          label: "都道府県"
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
          key: "person_in_charge",
          type: "text",
          label: "担当者"
        },
        {
          key: "person_in_charge_kana",
          type: "text",
          label: "担当者カナ"
        }
      ],
      options: {
        company_id: {}
      }
    }
  },
  created() {
    this.$axios.$get(`/v1/companies`)
    .then(result=>{
      this.options['company_id'] = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
    })
  }
}
</script>


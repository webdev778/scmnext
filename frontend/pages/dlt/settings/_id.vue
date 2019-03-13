<template lang="pug">
  rest-form(
    title="ダウンロード設定詳細"
    name="dlt/setting"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:options="options"
    v-bind:can-edit="true"
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
          key: "company_id",
          type: "select",
          label: "PPS"
        },
        {
          key: "district_id",
          type: "select",
          label: "エリア"
        },
        {
          key: "state",
          type: "text",
          label: "状態"
        }
      ],
      options: {
        company_id: {},
        district_id: {}
      }
    }
  },
  created() {
    this.$axios.$get('/v1/companies')
    .then(result=>{
      let companies = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      companies.unshift({value: null, text: ""})
      this.options['company_id'] = companies
    })
    this.$axios.$get('/v1/districts')
    .then(result=>{
      let districts = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      districts.unshift({value: null, text: ""})
      this.options['district_id'] = districts
    })
  }
}
</script>


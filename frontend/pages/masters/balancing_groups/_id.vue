<template lang="pug">
  rest-form(
    title="バランシンググループ詳細"
    name="balancing_group"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:options="options"
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
          key: "code",
          type: "text",
          label: "コード"
        },
        {
          key: "name",
          type: "text",
          label: "名前"
        },
        {
          key: "district_id",
          type: "select",
          label: "エリア"
        },
        {
          key: "leader_company_id",
          type: "select",
          label: "リーダーPPS"
        }
      ],
      options: {
        district_id: {},
        leader_company_id: {}
      }
    }
  },
  created() {
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
    this.$axios.$get(`/v1/companies`)
    .then(result=>{
      let companies = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      companies.unshift({value: null, text: ""})
      this.options['leader_company_id'] = companies
    })
  }
}
</script>


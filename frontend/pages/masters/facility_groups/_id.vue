<template lang="pug">
  rest-form(
    title="施設グループ詳細"
    name="facility_group"
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
          key: "name",
          type: "text",
          label: "名前"
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
          key: "contract_id",
          type: "select",
          label: "契約"
        },
        {
          key: "voltage_type_id",
          type: "select",
          label: "電圧種別"
        },
        {
          key: "contract_capacity",
          type: "text",
          label: "契約容量"
        }
      ],
      options: {
        company_id: {},
        district_id: {},
        contract_id: {},
        voltage_type_id: {}
      }
    }
  },
  created() {
    this.$axios.$get(`/v1/companies`)
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
    this.$axios.$get(`/v1/districts`)
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
    this.$axios.$get(`/v1/contracts`)
    .then(result=>{
      let contracts = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      contracts.unshift({value: null, text: ""})
      this.options['contract_id'] = contracts
    })
    this.$axios.$get(`/v1/voltage_types`)
    .then(result=>{
      let voltage_types = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      voltage_types.unshift({value: null, text: ""})
      this.options['voltage_type_id'] = voltage_types
    })
  }
}
</script>


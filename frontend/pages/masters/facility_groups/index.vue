<template lang="pug">
  rest-index(
    title="施設グループ一覧"
    name="facility_groups"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="名前"
            label-for="name"
            )
            b-form-input(
              id="name"
              v-model="query.name_cont"
            )
        b-col
          b-form-group(
            label="PPS"
            label-for="company_id"
            )
            b-form-select(
              id="company_id"
              v-model="query.company_id_eq"
              v-bind:options="companies"
            )
        b-col
          b-form-group(
            label="エリア"
            label-for="district_id"
            )
            b-form-select(
              id="district_id"
              v-model="query.district_id_eq"
              v-bind:options="districts"
            )
        b-col
          b-form-group(
            label="契約"
            label-for="contract_id"
            )
            b-form-select(
              id="contract_id"
              v-model="query.contract_id_eq"
              v-bind:options="contracts"
            )
        b-col
          b-form-group(
            label="電圧種別"
            label-for="voltage_type_id"
            )
            b-form-select(
              id="voltage_type_id"
              v-model="query.voltage_type_id_eq"
              v-bind:options="voltage_types"
            )
</template>

<script>
import RestIndex from '~/components/Rest/RestIndex.vue'

export default {
  components: { RestIndex },
  data() {
    return {
      fields: [
        {
          key: "id",
          label: "ID"
        },
        {
          key: "name",
          label: "名前"
        },
        {
          key: "company.name",
          label: "PPS名"
        },
        {
          key: "district.name",
          label: "エリア名"
        },
        {
          key: "contract.name",
          label: "契約名"
        },
        {
          key: "voltage_type.name",
          label: "電圧種別名"
        },
        {
          key: "created_at",
          label: "作成日時",
          formatter: 'formatDatetime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: 'formatDatetime'
        }
      ],
      query: {
        name_cont: null,
        company_id_eq: null,
        district_id_eq: null,
        contract_id_eq: null,
        voltage_type_id_eq: null
      },
      companies: [],
      districts: [],
      contracts: [],
      voltage_types: []
    }
  },
  created() {
    this.$axios.$get(`/v1/companies`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.companies = options
    })
    this.$axios.$get(`/v1/districts`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.districts = options
    })
    this.$axios.$get(`/v1/contracts`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.contracts = options
    })
    this.$axios.$get(`/v1/voltage_types`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.voltage_types = options
    })
  }
}
</script>


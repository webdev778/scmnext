<template lang="pug">
  rest-index(
    title="不整合供給地点一覧"
    name="dlt/invalid_supply_points"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:list-only="true"
    v-bind:canEdit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="PPS名"
            label-for="company_id_eq"
            )
            b-form-select(id="company_id_eq" v-model="query.company_id_eq" v-bind:options="companies")
        b-col
          b-form-group(
            label="エリア名"
            label-for="district_id_eq"
            )
            b-form-select(id="district_id_eq" v-model="query.district_id_eq" v-bind:options="districts")
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
          key: "company.name",
          label: "PPS名"
        },
        {
          key: "district.name",
          label: "エリア名",
        },
        {
          key: "number",
          label: "供給地点特定番号",
        },
        {
          key: "name",
          label: "顧客名",
        },
        {
          key: "comment",
          label: "内容",
        },
        {
          key: "created_at",
          label: "作成日時"
        },
        {
          key: "updated_at",
          label: "更新日時"
        }
      ],
      query: {
        company_id_eq: null,
        district_id_eq: null
      },
      companies: [],
      districts: []
    }
  },
  created (){
    this.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.companies = result
    })
    this.$restApi.list('districts', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.districts = result
    })
  }
}
</script>


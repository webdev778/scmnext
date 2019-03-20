<template lang="pug">
  rest-index(
    title="ダウンロード設定一覧"
    name="dlt/settings"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:canEdit="true"
  )
    template(slot="search")
      b-row
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
            label="状態"
            label-for="state_eq"
            )
            b-form-select(
              id="state_eq"
              v-model="query.state_eq"
              v-bind:options="states"
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
          key: "company.name",
          label: "PPS名"
        },
        {
          key: "district.name",
          label: "エリア名"
        },
        {
          key: "state_i18n",
          label: "状態"
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
        district_id_eq: null,
        state_eq: null
      },
      companies: [],
      districts: [],
      states: []
    }
  },
  created() {
    this.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.companies = result
    })
    this.$restApi.list('districts', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.districts = result
    })
    this.$restApi.enums('dlt/settings', 'states', {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.states = result
    })
  }
}
</script>


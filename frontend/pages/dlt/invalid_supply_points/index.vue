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
            label="BG名"
            label-for="bg_member_balancing_group_id_eq"
            )
            b-form-select(id="bg_member_balancing_group_id_eq" v-model="query.bg_member_balancing_group_id_eq" v-bind:options="balancing_groups")
        b-col
          b-form-group(
            label="PPS名"
            label-for="bg_member_company_id_eq"
            )
            b-form-select(id="bg_member_company_id_eq" v-model="query.bg_member_company_id_eq" v-bind:options="companies")
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
          key: "bg_member.balancing_group.name",
          label: "BG名",
        },
        {
          key: "bg_member.company.name",
          label: "PPS名"
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
        bg_member_balancing_group_id_eq: null,
        bg_member_company_id_eq: null
      },
      balancing_groups: [],
      companies: []
    }
  },
  created (){
    this.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.balancing_groups = result
    })
    this.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.companies = result
    })
  }
}
</script>


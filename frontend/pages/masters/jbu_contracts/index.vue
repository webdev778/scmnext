<template lang="pug">
  rest-index(
    title="常時バックアップ電源契約一覧"
    name="jbu_contracts"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="バランシンググループ名"
            label-for="bg_member_balancing_group_id_eq"
            )
            b-form-select(
              id="bg_member_balancing_group_id_eq"
              v-model="query.bg_member_balancing_group_id_eq"
              v-bind:options="balancing_groups"
            )
        b-col
          b-form-group(
            label="PPS名"
            label-for="bg_member_company_id_eq"
            )
            b-form-select(
              id="bg_member_company_id_eq"
              v-model="query.bg_member_company_id_eq"
              v-bind:options="companies"
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
          key: "bg_member.balancing_group.name",
          label: "バランシンググループ名"
        },
        {
          key: "bg_member.company.name",
          label: "PPS名"
        },
        {
          key: "start_date",
          label: "開始日"
        },
        {
          key: "end_date",
          label: "終了日"
        },
        {
          key: "contract_power",
          label: "契約容量"
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
        bg_member_balancing_group_id_eq: null,
        bg_member_company_id_eq: null
      },
      balancing_groups: [],
      companies: []
    }
  },
  created() {
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


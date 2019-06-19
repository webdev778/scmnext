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
        b-col
          b-form-group(
            label="契約名"
            label-for="contract_name_cont"
            )
            b-form-input(
              id="contract_name_cont"
              v-model="query.contract_name_cont"
            )
        b-col
          b-form-group(
            label="電圧種別"
            label-for="voltage_type_id_eq"
            )
            b-form-select(
              id="voltage_type_id_eq"
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
          key: "bg_member.balancing_group.name",
          label: "バランシンググループ名"
        },
        {
          key: "bg_member.company.name",
          label: "PPS名"
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
        bg_member_balancing_group_id_eq: null,
        bg_member_company_id_eq: null,
        contract_name_cont: null,
        voltage_type_id_eq: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      balancing_groups: await ctx.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '全て'}),
      companies: await ctx.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'}),
      voltage_types: await ctx.$restApi.list('voltage_types', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>


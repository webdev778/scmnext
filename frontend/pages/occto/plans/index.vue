<template lang="pug">
  rest-index(
    title="翌日需要調達計画一覧"
    name="occto/plans"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:list-only="false"
    v-bind:canEdit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="バランシンググループ名"
            label-for="balancing_group_id_eq"
            )
            b-form-select(id="balancing_group_id_eq" v-model="query.balancing_group_id_eq" v-bind:options="balancing_groups")
        b-col
          b-form-group(
            label="年月日From"
            label-for="date_gteq"
            )
            b-form-input(id="date_gteq" type="date" v-model="query.date_gteq")
        b-col
          b-form-group(
            label="年月日To"
            label-for="date_lteq"
            )
            b-form-input(id="date_lteq" type="date" v-model="query.date_lteq")
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
          key: "date",
          label: "日付",
          formatter: "formatDate"
        },
        {
          key: "balancing_group.name",
          label: "バランシンググループ名",
        },
        {
          key: "created_at",
          label: "作成日時",
          formatter: "formatDatetime"
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: "formatDatetime"
        }
      ],
      query: {
        balancing_group_id_eq: null,
        date_gteq: null,
        date_lteq: null
      }
    }
  },
  async asyncData (ctx){
    return {
      balancing_groups: await ctx.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>


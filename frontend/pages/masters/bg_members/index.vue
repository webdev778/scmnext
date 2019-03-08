<template lang="pug">
  rest-index(
    title="BGメンバー一覧"
    name="bg_members"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="バランシンググループ"
            label-for="balancing_group_id"
            )
            b-form-select(
              id="district_id"
              v-model="query.balancing_group_id_eq"
              v-bind:options="balancing_groups"
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
          key: "balancing_group.name",
          label: "バランシンググループ名"
        },
        {
          key: "company.name",
          label: "PPS名"
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
        balancing_group_id_eq: null,
        company_id_eq: null
      },
      balancing_groups: [],
      companies: []
    }
  },
  created() {
    this.$axios.$get(`/v1/balancing_groups`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.balancing_groups = options
    })
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
  }
}
</script>


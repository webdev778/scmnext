<template lang="pug">
  rest-index(
    title="需要家一覧"
    name="consumers"
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
          label: "ID",
          width: 50
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
          key: "created_at",
          label: "作成日時",
          width: 180,
          formatter: 'formatDatetime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          width: 180,
          formatter: 'formatDatetime'
        }
      ],
      query: {
        name_cont: null,
        company_id_eq: null
      },
      companies: []
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
  }
}
</script>


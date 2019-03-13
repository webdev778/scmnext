<template lang="pug">
  rest-index(
    title="リソース一覧"
    name="resources"
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
            label="バランシンググループ"
            label-for="balancing_group_id"
            )
            b-form-select(
              id="balancing_group_id"
              v-model="query.balancing_group_id_eq"
              v-bind:options="balancing_groups"
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
          label: "名称"
        },
        {
          key: "balancing_group.name",
          label: "バランシンググループ名"
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
        balancing_group_id_eq: null
      },
      balancing_groups: []
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
  }
}
</script>


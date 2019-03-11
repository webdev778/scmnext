<template lang="pug">
  rest-form(
    title="リソース詳細"
    name="resource"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:options="options"
    v-bind:can-edit="false"
  )
</template>

<script>
import RestForm from '~/components/Rest/RestForm.vue'

export default {
  components: {RestForm},
  data() {
    return {
      id: null,
      fields: [
        {
          key: "id",
          type: "hidden"
        },
        
        {
          key: "balancing_group_id",
          type: "select",
          label: "バランシンググループ"
        },
        {
          key: "type",
          type: "text",
          label: "種別"
        },
        {
          key: "code",
          type: "text",
          label: "コード"
        },
        {
          key: "name",
          type: "text",
          label: "名称"
        }
      ],
      options: {
        balancing_group_id: {}
      }
    }
  },
  created() {
    this.$axios.$get(`/v1/balancing_groups`)
    .then(result=>{
      let balancing_groups = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      balancing_groups.unshift({value: null, text: ""})
      this.options['balancing_group_id'] = balancing_groups
    })
  }
}
</script>


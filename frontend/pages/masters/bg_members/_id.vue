<template lang="pug">
  rest-form(
    title="BGメンバー詳細"
    name="bg_member"
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
          key: "company_id",
          type: "select",
          label: "PPS"
        }
      ],
      options: {
        balancing_group_id: {},
        company_id: {}
      }
    }
  },
  created() {
    this.$axios.$get('/v1/balancing_groups')
    .then(result=>{
      this.options['balancing_group_id'] = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
    })
    this.$axios.$get('/v1/companies')
    .then(result=>{
      this.options['company_id'] = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
    })
  }
}
</script>


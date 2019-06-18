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
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        balancing_group_id: await ctx.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '未設定'}),
        company_id: await ctx.$restApi.list('companies', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


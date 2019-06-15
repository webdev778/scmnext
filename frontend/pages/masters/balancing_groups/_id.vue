<template lang="pug">
  rest-form(
    title="バランシンググループ詳細"
    name="balancing_group"
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
          key: "code",
          type: "text",
          label: "コード"
        },
        {
          key: "name",
          type: "text",
          label: "名前"
        },
        {
          key: "district_id",
          type: "select",
          label: "エリア"
        },
        {
          key: "leader_company_id",
          type: "select",
          label: "リーダーPPS"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        district_id: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '未設定'}),
        leader_company_id: await ctx.$restApi.list('companies', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


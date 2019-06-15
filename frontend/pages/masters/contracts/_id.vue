<template lang="pug">
  rest-form(
    title="契約詳細"
    name="contract"
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
          key: "name",
          type: "text",
          label: "名称"
        },
        {
          key: "name_for_invoice",
          type: "text",
          label: "請求用名称"
        },
        {
          key: "voltage_type_id",
          type: "select",
          label: "電圧種別"
        },
        {
          key: "contract_item_group_id",
          type: "select",
          label: "契約アイテムグループ"
        },
        {
          key: "start_date",
          type: "text",
          label: "開始日"
        },
        {
          key: "end_date",
          type: "text",
          label: "終了日"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        voltage_type_id: await ctx.$restApi.list('voltage_types', null, {format: 'options', emptyValue: '未設定'}),
        contract_item_group_id: await ctx.$restApi.list('contract_item_groups', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


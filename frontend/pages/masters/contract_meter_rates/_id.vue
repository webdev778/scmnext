<template lang="pug">
  rest-form(
    title="契約・契約アイテム別従量料金詳細"
    name="contract_meter_rate"
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
          key: "contract_id",
          type: "select",
          label: "契約"
        },
        {
          key: "contract_item_id",
          type: "select",
          label: "契約アイテム"
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
        },
        {
          key: "rate",
          type: "text",
          label: "レート"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        contract_id: await ctx.$restApi.list('contracts', null, {format: 'options', emptyValue: '未設定'}),
        contract_item_id: await ctx.$restApi.list('contract_items', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


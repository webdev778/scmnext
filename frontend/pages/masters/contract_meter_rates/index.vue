<template lang="pug">
  rest-index(
    title="契約・契約アイテム別従量料金一覧"
    name="contract_meter_rates"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="契約"
            label-for="contract_id"
            )
            b-form-select(
              id="contract_id"
              v-model="query.contract_id_eq"
              v-bind:options="contracts"
            )
        b-col
          b-form-group(
            label="契約アイテム"
            label-for="contract_item_id"
            )
            b-form-select(
              id="contract_item_id"
              v-model="query.contract_item_id_eq"
              v-bind:options="contract_items"
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
          key: "contract.name",
          label: "契約名"
        },
        {
          key: "contract_item.name",
          label: "契約アイテム名"
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
        contract_id_eq: null,
        contract_item_id_eq: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      contracts: await ctx.$restApi.list('contracts', null, {format: 'options', emptyValue: '全て'}),
      contract_items: await ctx.$restApi.list('contract_items', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>


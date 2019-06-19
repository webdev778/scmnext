<template lang="pug">
  rest-index(
    title="契約一覧"
    name="contracts"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="名称"
            label-for="name"
            )
            b-form-input(
              id="name"
              v-model="query.name_cont"
            )
        b-col
          b-form-group(
            label="電圧種別"
            label-for="voltage_type_id"
            )
            b-form-select(
              id="voltage_type_id"
              v-model="query.voltage_type_id_eq"
              v-bind:options="voltage_types"
            )
        b-col
          b-form-group(
            label="契約アイテムグループ"
            label-for="contract_item_group_id"
            )
            b-form-select(
              id="contract_item_group_id"
              v-model="query.contract_item_group_id_eq"
              v-bind:options="contract_item_groups"
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
          key: "voltage_type.name",
          label: "電圧種別名"
        },
        {
          key: "contract_item_group.name",
          label: "契約アイテムグループ名"
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
        voltage_type_id_eq: null,
        contract_item_group_id_eq: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      voltage_types: await ctx.$restApi.list('voltage_types', null, {format: 'options', emptyValue: '全て'}),
      contract_item_groups: await ctx.$restApi.list('contract_item_groups', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>


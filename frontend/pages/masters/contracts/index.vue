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
          label: "ID",
          width: 50
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
        voltage_type_id_eq: null,
        contract_item_group_id_eq: null
      },
      voltage_types: [],
      contract_item_groups: []
    }
  },
  created() {
    this.$axios.$get(`/v1/voltage_types`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.voltage_types = options
    })
    this.$axios.$get(`/v1/contract_item_groups`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.contract_item_groups = options
    })
  }
}
</script>


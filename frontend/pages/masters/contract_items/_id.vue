<template lang="pug">
  rest-form(
    title="契約アイテム詳細"
    name="contract_item"
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
          label: "名前"
        },
        {
          key: "voltage_type_id",
          type: "select",
          label: "電圧種別"
        },
        {
          key: "calculation_order",
          type: "text",
          label: "計算順序"
        },
        {
          key: "enabled",
          type: "text",
          label: "有効フラグ"
        }
      ],
      options: {
        voltage_type_id: {}
      }
    }
  },
  created() {
    this.$axios.$get(`/v1/voltage_types`)
    .then(result=>{
      this.options['voltage_type_id'] = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
    })
  }
}
</script>


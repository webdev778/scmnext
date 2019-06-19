<template lang="pug">
  rest-form(
    title="燃料調整費詳細"
    name="fuel_cost_adjustment"
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
          key: "district_id",
          type: "select",
          label: "エリア"
        },
        {
          key: "year",
          type: "text",
          label: "年"
        },
        {
          key: "month",
          type: "text",
          label: "月"
        },
        {
          key: "voltage_class",
          type: "text",
          label: "電圧区分"
        },
        {
          key: "unit_price",
          type: "text",
          label: "単価"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        district_id: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


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
      ],
      options: {
        district_id: {}
      }
    }
  },
  created() {
    this.$axios.$get('/v1/districts')
    .then(result=>{
      let districts = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      districts.unshift({value: null, text: ""})
      this.options['district_id'] = districts
    })
  }
}
</script>


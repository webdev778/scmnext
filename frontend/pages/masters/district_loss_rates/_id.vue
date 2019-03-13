<template lang="pug">
  rest-form(
    title="エリア別損失率詳細"
    name="district_loss_rate"
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
          key: "voltage_type_id",
          type: "select",
          label: "電圧種別"
        },
        {
          key: "rate",
          type: "text",
          label: "損失率"
        },
        {
          key: "application_start_date",
          type: "text",
          label: "適用開始日"
        },
        {
          key: "application_end_date",
          type: "text",
          label: "適用終了日"
        }
      ],
      options: {
        district_id: {},
        voltage_type_id: {}
      }
    }
  },
  created() {
    this.$axios.$get(`/v1/districts`)
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
    this.$axios.$get(`/v1/voltage_types`)
    .then(result=>{
      let voltage_types = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      voltage_types.unshift({value: null, text: ""})
      this.options['voltage_type_id'] = voltage_types
    })
  }
}
</script>


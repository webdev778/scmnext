<template lang="pug">
  rest-form(
    title="託送料金詳細"
    name="wheeler_charge"
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
          key: "voltage_class",
          type: "text",
          label: "電圧区分"
        },
        {
          key: "start_date",
          type: "text",
          label: "適用開始日"
        },
        {
          key: "basic_charge",
          type: "text",
          label: "基本料金(kW)"
        },
        {
          key: "meter_rate_charge",
          type: "text",
          label: "電力量料金(kWh)"
        },
        {
          key: "meter_rate_charge_daytime",
          type: "text",
          label: "電力量料金(昼間時間)(kWh)"
        },
        {
          key: "meter_rate_charge_night",
          type: "text",
          label: "電力量料金(夜間時間)(kWh)"
        },
        {
          key: "peak_shift_discount",
          type: "text",
          label: "ピークシフト割引(kW)"
        },
        {
          key: "a_charge",
          type: "text",
          label: "予備送電サービスA料金(kW)"
        },
        {
          key: "b_charge",
          type: "text",
          label: "予備送電サービスB料金(kW)"
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


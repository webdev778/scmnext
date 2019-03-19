<template lang="pug">
  rest-form(
    title="JEPXスポット市場取引結果詳細"
    name="jepx/spot_trade"
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
          key: "date",
          type: "text",
          label: "年月日"
        },
        {
          key: "time_index_id",
          type: "select",
          label: "時間枠"
        },
        {
          key: "sell_bit_amount",
          type: "text",
          label: "売り入札量(kWh)"
        },
        {
          key: "buy_bit_amount",
          type: "text",
          label: "買い入札量(kWh)"
        },
        {
          key: "execution_amount",
          type: "text",
          label: "約定総量(kWh)"
        },
        {
          key: "system_price",
          type: "text",
          label: "システムプライス(円/kWh)"
        },
        {
          key: "avoidable_cost",
          type: "text",
          label: "回避可能原価全国値(円/kWh)"
        },
        {
          key: "spot_avg_per_price",
          type: "text",
          label: "スポット・時間前平均価格(円/kWh)"
        },
        {
          key: "alpha_max_times_spot_avg_per_price",
          type: "text",
          label: "α上限値×スポット・時間前平均価格(円/kWh)"
        },
        {
          key: "alpha_min_times_spot_avg_per_price",
          type: "text",
          label: "α下限値×スポット・時間前平均価格(円/kWh)"
        },
        {
          key: "alpha_preliminary_times_spot_avg_per_price",
          type: "text",
          label: "α速報値×スポット・時間前平均価格(円/kWh)"
        },
        {
          key: "alpha_fixed_times_spot_avg_per_price",
          type: "text",
          label: "α確報値×スポット・時間前平均価格(円/kWh)"
        }
      ],
      options: {
        time_index_id: {}
      }
    }
  },
  created() {
    this.$axios.$get('/v1/time_indices')
    .then(result=>{
      let time_indices = result.map(item=>{
        return {
          value: item.id,
          text: item.time
        }
      })
      time_indices.unshift({value: null, text: ""})
      this.options['time_index_id'] = time_indices
    })
  }
}
</script>


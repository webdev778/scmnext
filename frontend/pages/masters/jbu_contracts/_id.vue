<template lang="pug">
  rest-form(
    title="常時バックアップ電源契約契約詳細"
    name="jbu_contract"
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
          key: "bg_member_id",
          type: "select",
          label: "BGメンバー名"
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
          key: "contract_power",
          type: "text",
          label: "契約容量"
        },
        {
          key: "basic_charge",
          type: "text",
          label: "基本料金(kW)"
        },
        {
          key: "meter_rate_charge_summer_season_daytime",
          type: "text",
          label: "従量料金(夏季昼間)"
        },
        {
          key: "meter_rate_charge_other_season_daytime",
          type: "text",
          label: "従量料金(他季昼間)"
        },
        {
          key: "meter_rate_charge_night",
          type: "text",
          label: "従量料金(夜間)"
        },
        {
          key: "meter_rate_charge_peak_time",
          type: "text",
          label: "従量料金(ピークタイム)"
        },
        {
          key: "fuel_cost_adjustment_charge",
          type: "text",
          label: "燃料調整費単価"
        }
      ],
      options: {
        resource_id: {}
      }
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        resource_id: await ctx.$restApi.list('resources', {"type": "ResourceJbu"}, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


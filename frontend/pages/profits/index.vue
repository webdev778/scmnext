<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-row
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            style="overflow-x: scroll; height: 700px; overflow-y: scroll;"
            )
            b-table(small v-bind:items="items" v-bind:fields="fields" style="width: 2000px;")

</template>

<script>
export default {
  data() {
    return {
      items: [],
      fields: [
        { key: "facility_group_id", label: "ID" },
        { key: "facility_group_name", label: "名称" },
        { key: "amount_actual", label: "需要<br>電力使用量", variant: 'align-right', formatter: "formatNumber" },
        { key: "amount_planned", label: "需要<br>計画値", variant: 'align-right', formatter: "formatNumber"  },
        { key: "amount_loss", label: "需要<br>損失量", variant: 'align-right', formatter: "formatNumber"  },
        { key: "amount_imbalance", label: "需要<br>インバランス", variant: 'align-right', formatter: "formatNumber"  },
        { key: "sales_basic_charge", label: "売上<br>基本料金", variant: 'align-right', formatter: "formatNumber" },
        { key: "sales_mater_rate_charge", label: "売上<br>従量料金", variant: 'align-right', formatter: "formatNumber"  },
        { key: "sales_fuel_cost_adjustment", label: "売上<br>燃料費調整", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_jbu", label: "供給<br>JBU", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_jepx_spot", label: "供給<br>JEPXスポット", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_jepx_1hour", label: "供給<br>一時間前", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_fit", label: "供給<br>FIT", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_matching", label: "供給<br>相対", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jbu_basic_charge", label: "仕入<br>JBU基本料金", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jbu_meter_rate_charge", label: "仕入<br>JBU従量料金", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jbu_fuel_cost_adjustment", label: "仕入<br>JBU燃料費調整", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jepx_spot", label: "仕入<br>JEPXスポット", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jepx_1hour", label: "仕入<br>JEPX一時間前", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_fit", label: "仕入<br>FIT", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_matching", label: "仕入<br>相対", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_imbalance", label: "仕入<br>インバランス", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_wheeler_fundamental_charge", label: "仕入<br>託送基本料金", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_wheeler_mater_rate_charge", label: "仕入<br>託送従量料金", variant: 'align-right', formatter: "formatNumber"  }
      ]
    }
  },
  created() {
    this.fetchData()
  },
  methods: {
    fetchData(){
      this.$axios.$get('/v1/profits/fixed', {params: {date: this.targetDate}})
      .then( (result)=>{
        this.items = result
      })
    },
    formatNumber(value){
      let formatter = new Intl.NumberFormat('ja-JP')
      if(!value) {
        return null
      } else {
        return formatter.format(Number(value).toFixed(0))
      }
    }
  }
}
</script>

<style scope="scoped">
  td.table-align-right {
    text-align: right;
  }
</style>
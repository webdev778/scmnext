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
        { key: "links", label: "日付別詳細" },
        { key: "facility_group_id", label: "ID" },
        { key: "facility_group_name", label: "名称" },
        { key: "amount_actual", label: "需要<br>電力使用量", variant: 'align-right', formatter: "formatNumber" },
        { key: "amount_planned", label: "需要<br>計画値", variant: 'align-right', formatter: "formatNumber"  },
        { key: "amount_loss", label: "需要<br>損失量", variant: 'align-right', formatter: "formatNumber"  },
        { key: "amount_imbalance", label: "需要<br>インバランス", variant: 'align-right', formatter: "formatNumber"  },
        { key: "sales_basic_charge", label: "売上<br>基本料金", variant: 'align-right', formatter: "formatNumber" },
        { key: "sales_mater_rate_charge", label: "売上<br>従量料金", variant: 'align-right', formatter: "formatNumber"  },
        { key: "sales_fuel_cost_adjustment", label: "売上<br>燃料調整費", variant: 'align-right', formatter: "formatNumber"  },
        { key: "sales_total", label: "売上<br>合計", variant: 'align-right', formatter: "formatNumber"  },
        { key: "sales_kw_unit_price", label: "売上<br>kw単価", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_jbu", label: "供給<br>JBU", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_jepx_spot", label: "供給<br>JEPXスポット", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_jepx_1hour", label: "供給<br>一時間前", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_fit", label: "供給<br>FIT", variant: 'align-right', formatter: "formatNumber"  },
        { key: "usage_matching", label: "供給<br>相対", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jbu_basic_charge", label: "仕入<br>JBU基本料金", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jbu_meter_rate_charge", label: "仕入<br>JBU従量料金", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jbu_fuel_cost_adjustment", label: "仕入<br>JBU燃料調整費", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jepx_spot", label: "仕入<br>JEPXスポット", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_jepx_1hour", label: "仕入<br>JEPX一時間前", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_fit", label: "仕入<br>FIT", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_matching", label: "仕入<br>相対", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_imbalance", label: "仕入<br>インバランス", variant: 'align-right', formatter: "formatNumber"  },
        { key: "supply_wheeler_fundamental_charge", label: "仕入<br>託送基本料金", variant: 'align-right', formatter: "formatNumber" },
        { key: "supply_wheeler_mater_rate_charge", label: "仕入<br>託送従量料金", variant: 'align-right', formatter: "formatNumber" },
        { key: "supply_total", label: "仕入<br>合計", variant: 'align-right', formatter: "formatNumber" },
        { key: "supply_kw_unit_price", label: "仕入<br>kw単価", variant: 'align-right', formatter: "formatNumber" },
        { key: "profit", label: "売上総利益", variant: 'align-right', formatter: "formatNumber" },
        { key: "profit_rate", label: "利益率", variant: 'align-right', formatter: "formatNumber" },
        { key: "load_factor", label: "負荷率", variant: 'align-right', formatter: "formatNumber" }
      ],
      balancingGroups: [],
      balancingGroupId: null,
      bgMembers: [],
      bgMemberId: null,
      targetYear: null,
      targetMonth: null,
      dataType: 'preliminary',
      dataTypes: [
        {value: 'preliminary', text: '速報値'},
        {value: 'fixed', text: '確定値'}
      ]
    }
  },
  computed: {
    targetYearMonth() {
      return this.targetYear + this.targetMonth
    }
  },
  created() {
    this.init()
  },
  watch: {
    balancingGroupId(val){
      this.$restApi.list('bg_members', {"q[balancing_group_id_eq]": val}, {format: 'options'})
      .then( (result)=>{
        this.bgMembers = result
        if (result.length > 0){
          this.bgMemberId = result[0].value
        }
      })
    }
  },
  methods: {
    init(){
      this.$restApi.list('balancing_groups', null, {format: 'options'})
      .then( (result)=>{
        this.balancingGroups = result
        if (result.length > 0){
          this.balancingGroupId = result[0].value
        }
      })
      this.month = [...Array(12).keys()].map(i =>{
        let monthText = ("0" + (i + 1)).substr(-2)
        return {text: monthText, value: monthText}
      })
      this.targetYear = this.$moment().format('YYYY')
      this.targetMonth = this.$moment().format('MM')
    },
    fetchData(format){
      let params = {
        target_year_month: this.targetYearMonth,
      }
      this.$axios.$get(`/v1/profits/${this.dataType}/${this.bgMemberId}.${format}`, {params: params} )
      .then( (result)=>{
        if (result == null) {
          alert('エラー')
          return
        }
        if (result.length == 0){
          alert('データがありません。')
          return
        }
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

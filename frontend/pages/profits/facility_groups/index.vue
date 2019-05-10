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
            b-row
              b-col
                b-form(inline)
                  b-form-select(
                    v-model="balancingGroupId"
                    v-bind:options="balancingGroups"
                  )
                  | &nbsp;
                  b-form-select(
                    v-model="bgMemberId"
                    v-bind:options="bgMembers"
                  )
                  | &nbsp;
                  b-form-input(
                    type="number"
                    v-model="targetYear"
                  )
                  | &nbsp;
                  b-form-select(
                    v-model="targetMonth"
                    v-bind:options="month"
                  )
                  | &nbsp;
                  b-form-radio-group(
                    id="data_type"
                    v-bind:options="$store.state.profit.dataTypes"
                    v-model="dataType"
                    name="data-type"
                  )
                  b-button(
                    v-on:click="fetchData('json')"
                  ) 表示
                  b-link.btn.btn-secondary(
                    v-bind:href="urlFor('csv')"
                  ) CSVエクスポート
                  b-link.btn.btn-secondary(
                    v-bind:href="urlFor('xlsx')"
                  ) EXCELエクスポート
            b-table(small v-bind:items="items" v-bind:fields="$store.getters['profit/fields']('facility_group')" style="width: 2000px;")
              template(v-for="slotName in $store.getters['profit/headerSlotNames']('facility_group')" v-slot:[slotName]="data")
                span(v-html="data.label")
              template(v-slot:links="data")
                b-link(v-bind:to="{ path: `/profits/${dataType}/facility_groups/${data.item.facility_group_id}?target_year_month=${targetYearMonth}` }")
                  | 詳細
</template>

<script>
export default {
  data() {
    return {
      items: [],
      balancingGroups: [],
      balancingGroupId: null,
      bgMembers: [],
      bgMemberId: null,
      targetYear: null,
      targetMonth: null,
      slotName: "HEAD_usage_jbu",
      dataType: this.$store.state.profit.dataTypes[0].value,
      csvUrl: null
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
    urlFor(format){
      return this.$axios.defaults.baseURL + this.pathFor(format)
    },
    pathFor(format){
      return `/v1/profits/${this.dataType}/bg_members/${this.bgMemberId}.${format}?target_year_month=${this.targetYearMonth}`
    },
    fetchData(){
      this.$axios.$get(this.pathFor('json'))
      .then( (result)=>{
        if (result == null) {
          this.items = []
          alert('エラー')
          return
        }
        if (result.length == 0){
          this.items = []
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

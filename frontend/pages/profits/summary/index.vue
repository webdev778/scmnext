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
                    type="date"
                    v-model="query.date_from"
                  )
                  | &nbsp;
                  b-form-input(
                    type="date"
                    v-model="query.date_to"
                  )
                  b-button(
                    v-on:click="prevMonth"
                  ) &lt;
                  | &nbsp;
                  b-button(
                    v-on:click="nextMonth"
                  ) &gt;
                  | &nbsp;
                  b-form-radio-group(
                    id="data_type"
                    v-bind:options="$store.state.profit.dataTypes"
                    v-model="dataType"
                  )
                  b-form-radio-group(
                    id="group_by_unit"
                    v-bind:options="groupByUnits"
                    v-model="query.group_by_unit"
                  )
            b-row
              b-col
                b-button(
                  v-on:click="fetchData('json')"
                ) 表示
                b-link.btn.btn-secondary(
                  v-bind:href="urlFor('csv')"
                ) CSVエクスポート
                b-link.btn.btn-secondary(
                  v-bind:href="urlFor('xlsx')"
                ) EXCELエクスポート
            b-table(small v-bind:items="items" v-bind:fields="$store.getters['profit/fields'](query.group_by_unit)" fixed)
              template(v-for="slotName in $store.getters['profit/headerSlotNames'](query.group_by_unit)" v-slot:[slotName]="data")
                span(v-html="data.label")
              template(v-slot:links="data")
                b-link(v-bind:to="{path: $store.getters['profit/getDetailPath'](dataType, bgMemberId, query, data)}")
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
      query: {
        date_from: null,
        date_to: null,
        group_by_unit: "facility_group_id"
      },
      slotName: "HEAD_usage_jbu",
      dataType: this.$store.state.profit.dataTypes[0].value,
      groupByUnits: [
        {value: "facility_group_id", text: "施設グループ別"},
        {value: "date", text: "日別"}
      ]
    }
  },
  computed: {
    targetYearMonth() {
      return this.targetYear + this.targetMonth
    }
  },
  async asyncData(ctx) {
    let balancingGroups = await ctx.$restApi.list('balancing_groups', null, {format: 'options'})
    let balancingGroupId = null
    let bgMembers = []
    let bgMemberId = null
    if (balancingGroups.length > 0){
      balancingGroupId = balancingGroups[0].value
      bgMembers = await ctx.$restApi.list('bg_members', {"q[balancing_group_id_eq]": balancingGroupId}, {format: 'options'})
      if (bgMembers.length > 0){
          bgMemberId = bgMembers[0].value
      }
    }
    return {
      balancingGroups: balancingGroups,
      balancingGroupId: balancingGroupId,
      bgMembers: bgMembers,
      bgMemberId: bgMemberId
    }
  },
  created() {
    this.setDateRangeToMonthStartAndEnd(this.$moment().subtract('month', 1))
  },
  watch: {
    async balancingGroupId(val){
      this.bgMembers = await this.$restApi.list('bg_members', {"q[balancing_group_id_eq]": val}, {format: 'options'})
      if (this.bgMembers.length > 0){
          this.bgMemberId = this.bgMembers[0].value
      }
    }
  },
  methods: {
    urlFor(format){
      return this.$axios.defaults.baseURL + this.$store.getters['profit/getApiUrl'](format, this.dataType, this.bgMemberId, this.query)
    },
    fetchData(){
      this.$nuxt.$loading.start()
      this.$axios.$get(this.$store.getters['profit/getApiUrl']('json', this.dataType, this.bgMemberId, this.query))
      .then( (result)=>{
        this.$nuxt.$loading.finish()
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
    prevMonth(){
      this.processMonth(-1)
    },
    nextMonth(){
      this.processMonth(1)
    },
    processMonth(num){
      this.setDateRangeToMonthStartAndEnd(this.$moment(this.query.date_from).add('month', num))
    },
    setDateRangeToMonthStartAndEnd(baseDate){
      this.query.date_from = baseDate.startOf('month').format(this.$moment.HTML5_FMT.DATE)
      this.query.date_to = baseDate.endOf('month').format(this.$moment.HTML5_FMT.DATE)
    },
    currency(value){
      return this.$formatter.currency(value);
    },
    decimal(value){
      return this.$formatter.decimal(value);
    },
    integer(value){
      return this.$formatter.integer(value);
    },
    percent(value){
      return this.$formatter.percent(value);
    }
  }
}
</script>

<style scope="scoped">
  td.table-align-right {
    text-align: right;
  }
  td.td-text {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
</style>

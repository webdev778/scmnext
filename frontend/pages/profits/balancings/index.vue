<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-row
        b-col(cols=9)
          b-card(
            header-tag="header"
            footer-tag="footer"
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
                    v-model="targetDate"
                  )
                  | &nbsp;
                  b-form-radio-group(
                    id="data_type"
                    v-bind:options="dataTypes"
                    v-model="dataType"
                    name="data-type"
                  )
                  b-button(
                    v-on:click="fetchData"
                  ) 表示
            bar-chart(
              v-bind:chart-data="chartData"
              v-bind:height=250
            )
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            b-table(small v-bind:items="tableData")

</template>

<script>
import BarChart from '~/components/Charts/BarChart.vue'

export default {
  components: {BarChart},
  data() {
    return {
      balancingGroupId: null,
      balancingGroups: [],
      bgMemberId: null,
      bgMembers: [],
      dataType: 'preliminary',
      dataTypes: [
        {value: 'preliminary', text: '速報値'},
        {value: 'fixed', text: '確定値'}
      ],
      chartFields: [
        {
          key: 'matching',
          label: '相対',
          color: '#ff9234',
          stack: 'plan'
        },
        {
          key: 'jbu',
          label: 'JBU',
          color: '#ffcd3c',
          stack: 'plan'
        },
        {
          key: 'fit',
          label: 'FIT',
          color: '#c5f0a4',
          stack: 'plan'
        },
        {
          key: 'jepx_spot',
          label: 'JEPX(SPOT)',
          color: '#35d0ba',
          stack: 'plan'
        },
        {
          key: 'jepx_1hour',
          label: 'JEPX(1hour)',
          color: '#35d0ba',
          stack: 'plan'
        },
        {
          key: 'usage',
          label: '確定値',
          color: '#78909c',
          stack: 'actual'
        },
        {
          key: 'loss',
          label: '損失',
          color: '#bdbdbd',
          stack: 'actual'
        }
      ],
      targetDate: null,
      tableData: []
    }
  },
  computed: {
    chartData() {
      if (!this.tableData){
        return null
      }
      let labels = this.tableData.map((item)=>{
        return item.time_index_id
      })
      let datasets = this.chartFields.map((field)=>{
        let dataset = {
          label: field.label,
          backgroundColor: field.color,
          stack: field.stack,
          data: null
        }
        dataset.data = this.tableData.map((item)=>{
          return item[field.key] ? item[field.key] : null
        })
        return dataset
      })
      return {
        labels: labels,
        datasets: datasets
      }
    }
    // tableData() {
    //   let result = []
    //   if (this.preliminary.length == 0 && this.fixed.lenght == 0){
    //     return null
    //   }
    //   for(let i=1; i<=48 ; i++){
    //     let title = ("0" + Math.floor((i-1)/2)).substr(-2) + ":" + ((i-1)%2==0 ? "00" : "30")
    //     result.push({
    //       label: title,
    //       preliminary: (this.preliminary[i] ? this.preliminary[i] : '-'),
    //       fixed: (this.fixed[i] ? this.fixed[i] : '-'),
    //     })
    //   }
    //   return result
    // },
    // chartData() {
    //   if (this.preliminary.length == 0 && this.fixed.lenght == 0){
    //     return null
    //   }
    //   let chartLabels = []
    //   let preliminaryChart = []
    //   let fixedChart = []
    //   for(let i=1; i<=48 ; i++){
    //     let title = ("0" + Math.floor((i-1)/2)).substr(-2) + ":" + ((i-1)%2==0 ? "00" : "30")
    //     chartLabels.push(title)
    //     preliminaryChart.push((this.preliminary[i] ? this.preliminary[i] : 0))
    //     fixedChart.push((this.fixed[i] ? this.fixed[i] : 0))
    //   }
    //   let result = {
    //     labels: chartLabels,
    //     datasets: [
    //       {
    //         label: "速報値",
    //         data: preliminaryChart,
    //         backgroundColor: "#ff0000",
    //         fill: false
    //       },
    //       {
    //         label: "確定値",
    //         data: fixedChart,
    //         backgroundColor: "#00ff00",
    //         fill: false
    //       }
    //     ]
    //   }
    //   return result
    // }
  },
  created() {
    this.init()
  },
  watch: {
    balancingGroupId(val){
      this.$axios.$get(`/v1/balancing_groups/${val}/bg_members`)
      .then( (result)=>{
        this.bgMemberId = result[0].id
        this.bgMembers = result.map((item)=>{
          return {value: item.id, text: item.name}
        })
      })
    }
  },
  methods: {
    init(){
      this.$axios.$get('/v1/balancing_groups')
      .then( (result)=>{
        this.balancingGroupId = result[0].id
        this.balancingGroups = result.map((item)=>{
          return {value: item.id, text: item.name}
        })
      })
    },
    fetchData(){
      this.$axios.$get('/v1/balancings', {params: {date: this.targetDate, type: this.dataType, bg_member_id: this.bgMemberId}})
      .then( (result)=>{
        this.tableData = result
      })
    }
  }
}
</script>

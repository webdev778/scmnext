<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-row
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            b-form-input(
              type="date"
              v-model="targetDate"
              v-on:change="fetchData()"
            )
            line-chart(v-bind:chart-data="chartData")
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            b-table(small v-bind:items="tableData")

</template>

<script>
import LineChart from '~/components/Charts/LineChart.vue'

export default {
  components: {LineChart},
  data() {
    return {
      targetDate: null,
      preliminary: {},
      fixed: {}
    }
  },
  computed: {
    tableData() {
      let result = []
      if (this.preliminary.length == 0 && this.fixed.lenght == 0){
        return null
      }
      for(let i=1; i<=48 ; i++){
        let title = ("0" + Math.floor((i-1)/2)).substr(-2) + ":" + ((i-1)%2==0 ? "00" : "30")
        result.push({
          label: title,
          preliminary: (this.preliminary[i] ? this.preliminary[i] : '-'),
          fixed: (this.fixed[i] ? this.fixed[i] : '-'),
        })
      }
      return result
    },
    chartData() {
      let chartLabels = []
      let preliminaryChart = []
      let fixedChart = []
      for(let i=1; i<=48 ; i++){
        let title = ("0" + Math.floor((i-1)/2)).substr(-2) + ":" + ((i-1)%2==0 ? "00" : "30")
        chartLabels.push(title)
        preliminaryChart.push((this.preliminary[i] ? this.preliminary[i] : 0))
        fixedChart.push((this.fixed[i] ? this.fixed[i] : 0))
      }
      let result = {
        labels: chartLabels,
        datasets: [
          {
            label: "速報値",
            data: preliminaryChart,
            backgroundColor: "#ff0000",
            fill: false
          },
          {
            label: "確定値",
            data: fixedChart,
            backgroundColor: "#00ff00",
            fill: false
          }
        ]
      }
      console.log(result)
      return result
    }
  },
  created() {
    this.fetchData()
  },
  methods: {
    fetchData(){
      this.$axios.$get('/v1/power_usages/preliminary', {params: {date: this.targetDate}})
      .then( (result)=>{
        console.log(result)
        this.preliminary = result
      })
      this.$axios.$get('/v1/power_usages/fixed', {params: {date: this.targetDate}})
      .then( (result)=>{
        this.fixed = result
      })
    }
  }
}
</script>

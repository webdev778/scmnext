<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-row
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            line-chart(v-bind:chart-data="chartdata")
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            b-table(small v-bind:items="tabledata")

</template>

<script>
import LineChart from '~/components/Charts/LineChart.vue'

export default {
  components: {LineChart},
  data() {
    return {
      tabledata: [],
      chartdata: null
    }
  },
  mounted() {
    this.init()
  },
  methods: {
    async init() {
      let preliminary = await this.$axios.$get('/v1/power_usages/preliminaly')
      let fixed = await this.$axios.$get('/v1/power_usages/fixed')
      let chartLabels = []
      let preliminaryChart = []
      let fixedChart = []
      for(let i=1; i<=48 ; i++){
        let title = ("0" + Math.floor((i-1)/2)).substr(-2) + ":" + ((i-1)%2==0 ? "00" : "30")
        this.tabledata.push({
          label: title,
          preliminary: (preliminary[i] ? preliminary[i] : '-'),
          fixed: (fixed[i] ? fixed[i] : '-'),
        })
        chartLabels.push(title)
        preliminaryChart.push((preliminary[i] ? preliminary[i] : 0))
        fixedChart.push((fixed[i] ? fixed[i] : 0))
      }
      this.chartdata = {
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
          },
        ]
      }
      console.log(this.chartdata)
    }
  }
}
</script>

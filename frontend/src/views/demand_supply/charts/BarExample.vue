<script>
import { Line } from 'vue-chartjs'
import { CustomTooltips } from '@coreui/coreui-plugin-chartjs-custom-tooltips'

export default {
  extends: Line,
  props: {
    items: Array
  },
  computed: {
    labels(){
      return this.items.map( (item)=>{
        return item["時刻"]
      })
    },
    ai18h(){
      return this.items.map( (item)=>{
        return item["AI18H"]
      })
    },
    ai30h(){
      return this.items.map( (item)=>{
        return item["AI30H"]
      })
    }
  },
  mounted () {
    this.renderChart(
      {
        labels: this.labels,
        datasets: [
          {
            label: 'AI18H',
            backgroundColor: '#f87979',
            data: this.ai18h
          },
          {
            label: 'AI30H',
            backgroundColor: '#7979f8',
            data: this.ai30h
          }
        ]
      },
      {
        responsive: true,
        maintainAspectRatio: true,
        tooltips: {
          enabled: false,
          custom: CustomTooltips,
          intersect: true,
          mode: 'index',
          position: 'nearest',
          callbacks: {
            labelColor: function (tooltipItem, chart) {
              return { backgroundColor: chart.data.datasets[tooltipItem.datasetIndex].backgroundColor }
            }
          }
        }
      }
    )
  }
}
</script>

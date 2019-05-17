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
import BarChart from '~/components/charts/BarChart.vue'

export default {
  components: {BarChart},
  data() {
    return {
      bgMemberId: null,
      bgMembers: [],
      targetDate: null,
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
          key: 'self',
          label: 'その他',
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
  },
  async asyncData(ctx) {
    let balancingGroups = await ctx.$restApi.list('balancing_groups', null, {format: 'options'})
    let balancingGroupId = null
    if (balancingGroups.length > 0){

      balancingGroupId = balancingGroups[0].value
    }
    console.log(balancingGroupId)
    let targetDate = ctx.$moment().format('YYYY-MM-DD')
    return {
      balancingGroups: balancingGroups,
      balancingGroupId: balancingGroupId,
      targetDate: targetDate
    }
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
    fetchData(){
      this.$axios.$get('/v1/balancings', {params: {date: this.targetDate, type: this.dataType, bg_member_id: this.bgMemberId}})
      .then( (result)=>{
        this.tableData = result
      })
    }
  }
}
</script>

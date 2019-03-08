<template lang="pug">
  rest-index(
    title="施設一覧"
    name="facilities"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="名前"
            label-for="name"
            )
            b-form-input(
              id="name"
              v-model="query.name_cont"
            )
        b-col
          b-form-group(
            label="供給地点特定番号"
            label-for="supply_point_number"
            )
            b-form-input(
              id="supply_point_number"
              v-model="query.supply_point_number_cont"
            )
        b-col
          b-form-group(
            label="需要家名"
            label-for="consumer_name"
            )
            b-form-input(
              id="consumer_name"
              v-model="query.consumer_name_cont"
            )
      b-row
        b-col
          b-form-group(
            label="PPS"
            label-for="consumer_company_id"
            )
            b-form-select(
              id="district_id"
              v-model="query.consumer_company_id_eq"
              v-bind:options="companies"
            )
        b-col
          b-form-group(
            label="エリア"
            label-for="district_id"
            )
            b-form-select(
              id="district_id"
              v-model="query.district_id_eq"
              v-bind:options="districts"
            )
        b-col
</template>

<script>
import RestIndex from '~/components/Rest/RestIndex.vue'

export default {
  components: { RestIndex },
  data() {
    return {
      fields: [
        {
          key: "id",
          label: "ID"
        },
        {
          key: "name",
          label: "名前"
        },
        {
          key: "supply_point.number",
          label: "供給地点特定番号",
          width: 180
        },
        {
          key: "consumer.company.name",
          label: "PPS"
        },
        {
          key: "consumer.name",
          label: "需要家名"
        },
        {
          key: "district.name",
          label: "エリア",
          width: 70
        },
        {
          key: "created_at",
          label: "作成日時",
          formatter: 'formatDatetime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: 'formatDatetime'
        }
      ],
      query: {
        name_cont: null,
        supply_point_number_cont: null,
        consumer_name_cont: null,
        consumer_company_id_eq: null,
        district_id_eq: null
      },
      companies: [],
      districts: []
    }
  },
  created() {
    this.$axios.$get(`/v1/companies`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.companies = options
    })
    this.$axios.$get(`/v1/districts`)
    .then(result=>{
      let options = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      options.unshift({value: null, text: "全て"})
      this.districts = options
    })
  }
}
</script>


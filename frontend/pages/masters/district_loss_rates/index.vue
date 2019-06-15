<template lang="pug">
  rest-index(
    title="エリア別損失率一覧"
    name="district_loss_rates"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="エリア"
            label-for="district_id_eq"
            )
            b-form-select(
              id="district_id_eq"
              v-model="query.district_id_eq"
              v-bind:options="districts"
            )
        b-col
          b-form-group(
            label="電圧種別"
            label-for="voltage_type_id_eq"
            )
            b-form-select(
              id="voltage_tvoltage_type_id_eqype_id"
              v-model="query.voltage_type_id_eq"
              v-bind:options="voltage_types"
            )
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
          key: "district.name",
          label: "エリア名"
        },
        {
          key: "voltage_type.name",
          label: "電圧種別名"
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
        district_id_eq: null,
        voltage_type_id_eq: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      districts: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '全て'}),
      voltage_types: await ctx.$restApi.list('voltage_types', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>


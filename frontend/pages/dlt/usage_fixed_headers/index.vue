<template lang="pug">
  rest-index(
    title="確定使用量ヘッダ一覧"
    name="dlt/usage_fixed_headers"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:canEdit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="供給地点特定番号"
            label-for="supply_point_number"
            )
            b-form-input(
              id="supply_point_number"
              v-model="query.supply_point_number_cont"
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
          key: "year",
          label: "年"
        },
        {
          key: "month",
          label: "月"
        },
        {
          key: "record_date",
          label: "検針日"
        },
        {
          key: "supply_point_number",
          label: "供給地点特定番号"
        },
        {
          key: "created_at",
          label: "作成日時"
        },
        {
          key: "updated_at",
          label: "更新日時"
        }
      ]
    }
  }
}
</script>


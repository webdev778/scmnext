<template lang="pug">
  rest-form(
    title="確定使用量ヘッダ詳細"
    name="dlt/usage_fixed_header"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:options="options"
    v-bind:can-edit="false"
  )
</template>

<script>
import RestForm from '~/components/Rest/RestForm.vue'

export default {
  components: {RestForm},
  data() {
    return {
      id: null,
      fields: [
        {
          key: "id",
          type: "hidden"
        },
        {
          key: "file_id",
          type: "select",
          label: "ファイル"
        },
        {
          key: "year",
          type: "text",
          label: "年"
        },
        {
          key: "month",
          type: "text",
          label: "月"
        },
        {
          key: "supply_point_number",
          type: "text",
          label: "供給地点特定番号"
        },
        {
          key: "consumer_code",
          type: "text",
          label: "需要家識別番号"
        },
        {
          key: "consumer_name",
          type: "text",
          label: "需要家名称"
        },
        {
          key: "supply_point_name",
          type: "text",
          label: "供給場所"
        },
        {
          key: "voltage_class_name",
          type: "text",
          label: "電圧区分名"
        },
        {
          key: "journal_code",
          type: "text",
          label: "仕訳コード"
        },
        {
          key: "can_provide",
          type: "text",
          label: "提供可否"
        },
        {
          key: "usage_all",
          type: "text",
          label: "月間電力量全量"
        },
        {
          key: "usage",
          type: "text",
          label: "月間電力量仕訳後"
        },
        {
          key: "power_factor",
          type: "text",
          label: "力率"
        },
        {
          key: "max_power",
          type: "text",
          label: "最大需要電力"
        },
        {
          key: "next_meter_reading_date",
          type: "text",
          label: "次回定例検針予定日"
        }
      ],
      options: {
        file_id: {}
      }
    }
  },
  created() {
    this.$axios.$get(`/v1/dlt/files`)
    .then(result=>{
      let files = result.map(item=>{
        return {
          value: item.id,
          text: item.content_blob.filename
        }
      })
      files.unshift({value: null, text: ""})
      this.options['file_id'] = files
    })
  }
}
</script>


<template lang="pug">
  rest-form(
    title="エリア別損失率詳細"
    name="district_loss_rate"
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
          key: "district_id",
          type: "select",
          label: "エリア"
        },
        {
          key: "voltage_type_id",
          type: "select",
          label: "電圧種別"
        },
        {
          key: "rate",
          type: "text",
          label: "損失率"
        },
        {
          key: "application_start_date",
          type: "text",
          label: "適用開始日"
        },
        {
          key: "application_end_date",
          type: "text",
          label: "適用終了日"
        }
      ],
      options: {
        district_id: {},
        voltage_type_id: {}
      }
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        district_id: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '未設定'}),
        voltage_type_id: await ctx.$restApi.list('voltage_types', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


<template lang="pug">
  rest-form(
    title="供給エリア詳細"
    name="district"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
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
          key: "name",
          type: "text",
          label: "名前"
        },
        {
          key: "company_id",
          type: "text",
          label: "PPS ID"
        },
        {
          key: "code",
          type: "text",
          label: "コード"
        },
        {
          key: "loss_rate_special_high_voltage",
          type: "text",
          label: "損失率(特別高圧)"
        },
        {
          key: "loss_rate_high_voltage",
          type: "text",
          label: "損失率(高圧)"
        },
        {
          key: "loss_rate_low_voltage",
          type: "text",
          label: "損失率(低圧)"
        }
      ]
    }
  }
}
</script>


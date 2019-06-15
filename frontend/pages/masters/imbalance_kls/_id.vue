<template lang="pug">
  rest-form(
    title="インバランスK値・L値詳細"
    name="imbalance_kl"
    v-bind:id="$route.params.id"
    v-bind:fields="fields"
    v-bind:options="options"
    v-bind:can-edit="true"
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
          key: "start_date",
          type: "date",
          label: "開始日"
        },
        {
          key: "k_value",
          type: "text",
          label: "K値"
        },
        {
          key: "l_value",
          type: "text",
          label: "L値"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        district_id: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


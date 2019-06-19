<template lang="pug">
  rest-form(
    title="JEPXインバランスβ値詳細"
    name="jepx/imbalance_beta"
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
          key: "district_id",
          type: "select",
          label: "エリア"
        },
        {
          key: "value",
          type: "text",
          label: "値"
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


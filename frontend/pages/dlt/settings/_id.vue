<template lang="pug">
  rest-form(
    title="ダウンロード設定詳細"
    name="dlt/setting"
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
          key: "bg_member_id",
          type: "select",
          label: "BGメンバー",
        },
        {
          key: "state",
          type: "radio",
          label: "状態"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        bg_member_id: await ctx.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '未設定'}),
        states: await ctx.$restApi.enums('dlt/files', 'states', {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


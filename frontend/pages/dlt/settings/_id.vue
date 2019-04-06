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
      ],
      options: {
        bg_member_id: {},
        state: {}
      }
    }
  },
  created() {
    this.$restApi.list('bg_members', null, {format: 'options', emptyValue: '未設定'})
    .then(result=>{
      this.options['bg_member_id'] = result
    })
    this.$restApi.enums('dlt/settings', 'state', {format: 'options'})
    .then(result=>{
      this.options['state'] = result
    })
  }
}
</script>


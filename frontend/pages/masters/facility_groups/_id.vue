<template lang="pug">
  rest-form(
    title="施設グループ詳細"
    name="facility_group"
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
          key: "name",
          type: "text",
          label: "名前"
        },
        {
          key: "bg_member_id",
          type: "select",
          label: "BGメンバー名"
        },
        {
          key: "contract_id",
          type: "select",
          label: "契約名"
        },
        {
          key: "voltage_type_id",
          type: "select",
          label: "電圧種別"
        },
        {
          key: "contract_capacity",
          type: "text",
          label: "契約容量"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        bg_member_id: await ctx.$restApi.list('bg_members', null, {format: 'options', emptyValue: '未設定'}),
        contract_id: await ctx.$restApi.list('contracts', null, {format: 'options', emptyValue: '未設定'}),
        voltage_type_id: await ctx.$restApi.list('voltage_types', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


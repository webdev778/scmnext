<template lang="pug">
  rest-form(
    title="リソース詳細"
    name="resource"
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
          key: "bg_member_id",
          type: "select",
          label: "BGメンバー"
        },
        {
          key: "type",
          type: "text",
          label: "種別"
        },
        {
          key: "code",
          type: "text",
          label: "コード"
        },
        {
          key: "name",
          type: "text",
          label: "名称"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        bg_member_id: await ctx.$restApi.list('bg_members', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


<template lang="pug">
  rest-index(
    title="エリア一覧"
    name="districts"
    v-bind:fields="fields"
    can-edit=true
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
          label: "ID",
          width: 50
        },
        {
          key: "name",
          label: "名前"
        },
        {
          key: "created_at",
          label: "作成日時",
          width: 180,
          formatter: 'formatDatetime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          width: 180,
          formatter: 'formatDatetime'
        }
      ]
    }
  }
}
</script>


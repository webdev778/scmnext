<template lang="pug">
  rest-index(
    title="燃料調整費一覧"
    name="fuel_cost_adjustments"
    v-bind:fields="fields"
    v-bind:can-edit="false"
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
          label: "ID"
        },
        {
          key: "created_at",
          label: "作成日時",
          formatter: 'formatDatetime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: 'formatDatetime'
        }
      ]
    }
  }
}
</script>


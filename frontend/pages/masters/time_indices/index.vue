<template lang="pug">
  rest-index(
    title="時間枠一覧"
    name="time_indices"
    v-bind:fields="fields"
    v-bind:list-only="true"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="時間"
            label-for="time"
            )
            b-form-input(
              id="time"
              v-model="query.time_text_cont"
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
          key: "time",
          label: "時間"
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
      ],
      query: {
        time_text_cont: null
      }
    }
  }
}
</script>


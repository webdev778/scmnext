<template lang="pug">
  rest-index(
    title="施設別割引一覧"
    name="discounts_for_facilities"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="施設名"
            label-for="facility_name_cont"
            )
            b-form-input(
              id="facility_id"
              v-model="query.facility_name_cont"
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
          key: "facility.name",
          label: "施設名"
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
        facility_name_cont: null
      }
    }
  }
}
</script>


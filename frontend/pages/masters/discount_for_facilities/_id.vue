<template lang="pug">
  rest-form(
    title="施設別割引詳細"
    name="discount_for_facility"
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
          key: "facility_id",
          type: "select",
          label: "施設"
        },
        {
          key: "start_date",
          type: "text",
          label: "適用開始日"
        },
        {
          key: "rate",
          type: "text",
          label: "割引率"
        }
      ],
      options: {
        facility_id: {}
      }
    }
  },
  created() {
    this.$axios.$get(`/v1/facilities`)
    .then(result=>{
      let facilities = result.map(item=>{
        return {
          value: item.id,
          text: item.name
        }
      })
      facilities.unshift({value: null, text: ""})
      this.options['facility_id'] = facilities
    })
  }
}
</script>


<template lang="pug">
  rest-form(
    title="BG詳細"
    name="balancing_group"
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
          key: "district_id",
          type: "select",
          label: "エリア"
        }
      ],
      options: {district_id: {}}
    }
  },
  created() {
    this.$axios.$get('/v1/districts')
    .then(result=>{
      this.options['district_id'] = result.map(district=>{
        return {value: district.id, text: district.name}
      })
    })
  }
}
</script>


<template lang="pug">
  rest-form(
    title="BG詳細"
    name="balancing_group"
    v-bind:id="id"
    v-bind:fields="fields"
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
      ]
    }
  },
  async created() {
    this.id = Number(this.$route.params.id)
    let options = await this.$axios.$get('/v1/districts')
    let list = options.map( (district)=>{
      return {value: district.id, text: district.name}
    })
    this.$set(this.fields[2], 'options', list)
  }
}
</script>


<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-row
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            div(slot="header")
              i.fa.fa-align-justify
              strong 施設詳細
            div
            b-alert(
              variant="danger"
              fade
              dismissible
              v-bind:show="errors != null"
              v-on:dismissed="errors =null"
              )
              ul
                li(v-for="(error, index) in errors") {{error}}
            b-form(
              v-if="data"
              v-on:submit="save"
              )
              template(v-for="(field, index) in fields")
                template(v-if="field.type=='hidden'")
                  input(type="hidden" v-model="data[field.key]")
                template(v-else-if="field.type=='select'")
                  b-form-group(
                    v-bind:label="field.label"
                    v-bind:label-for="field.key"
                    )
                    b-form-select(
                      v-bind:id="field.key"
                      v-bind:options="getValue(field.options)"
                      v-model="data[field.key]"
                    )
                template(v-else)
                  b-form-group(
                    v-bind:label="field.label"
                    v-bind:label-for="field.key"
                    )
                    b-form-input(
                      v-bind:id="field.key"
                      v-bind:type="field.type"
                      v-model="data[field.key]"
                    )
              b-button(type="submit" variant="primary") 保存
              | &nbsp;
              b-button(type="reset" variant="danger") リセット

</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      data: null,
      errors: null,
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
          key: "supply_point_number",
          type: "text",
          label: "供給地点特定番号"
        },
        {
          key: "district_id",
          type: "select",
          label: "エリア",
          source: "districts",
          options: "districtList"
        }
      ],
      districtList: null
    }
  },
  async mounted(){
    let district = await this.$axios.$get(`/v1/districts`)
    this.districtList = district.map((item)=>{
      return {value: item.id, text: item.name}
    })
    this.data = await this.$axios.$get(`/v1/facilities/${this.$route.params.id}`)
  },
  methods: {
    getValue(name) {
      return this[name]
    },
    save() {
      this.$axios.put(`/v1/facilities/${this.$route.params.id}`, {facility: this.data} ).then( (response)=>{
        console.log(response)
        if (response.data.result == 'ok'){
          this.$router.push({ name: '施設'})
        } else {
          this.errors = response.data.errors
        }
      })
    }
  }
}
</script>


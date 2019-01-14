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
              strong {{title}}
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
</template>

<script>
import axios from 'axios'

export default {
  data() {
    return {
      entity: null
    }
  },
  props: {
    title: {
      type: String,
      required: true,
      default: () => null
    },
    name: {
      type: String,
      required: true,
      default: () => null
    },
    id: {
      type: Integer,
      required: true,
      default: () => null
    }
  },
  async mounted(){
    this.entity = await this.$axios.$get(`/v1/${this.name}/${this.id.id}`)
  },
  methods: {
    save() {
      this.$axios.put(`/v1/${this.name}/${this.id.id}`, {facility: this.data} ).then( (response)=>{
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


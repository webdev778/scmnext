<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-card(
        header-tag="header"
        footer-tag="footer"
        )
        div(slot="header")
          i.fa.fa-align-justify
          strong {{title}}
          b-btn.pull-right(size="sm" variant="secondary" v-on:click="back")
            | 戻る
        b-alert(
          variant="danger"
          fade
          dismissible
          v-bind:show="errors != null"
          v-on:dismissed="errors = null"
          )
          ul
            li(v-for="(error, index) in errors") {{error}}
        b-form(
          v-if="formData"
          v-on:submit.prevent.stop="save"
          )
          template(v-for="(field, index) in fields")
            template(v-if="field.type=='hidden'")
              input(type="hidden" v-model="formData[field.key]")
            template(v-else-if="field.type=='select'")
              b-form-group(
                v-bind:label="field.label"
                v-bind:label-for="field.key"
                )
                b-form-select(
                  v-bind:id="field.key"
                  v-bind:options="options[field.key]"
                  v-model="formData[field.key]"
                )
            template(v-else)
              b-form-group(
                v-bind:label="field.label"
                v-bind:label-for="field.key"
                )
                b-form-input(
                  v-bind:id="field.key"
                  v-bind:type="field.type"
                  v-model="formData[field.key]"
                )
          b-button(type="submit" variant="primary") 保存
</template>

<script>
import pluralize from 'pluralize'

export default {
  data() {
    return {
      errors: null,
      formData: null
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
      type: Number,
      required: true,
      default: () => null
    },
    fields: {
      type: Array,
      required: true,
      default: () => []
    },
    options: {
      type: Object,
      required: false,
      dedault: () => {}
    }
  },
  computed: {
    pluralName() {
      return pluralize.plural(this.name)
    },
    resourceUrl() {
      return `/v1/${this.pluralName}/${this.id}`
    }
  },
  mounted(){
    this.init()
  },
  methods: {
    init() {
      this.$axios.$get(this.resourceUrl)
      .then( (response)=>{
        this.formData = response
      })
    },
    save() {
      this.$axios.$put(this.resourceUrl, {[this.name]: this.formData} )
      .then( (response)=>{
        if (response.success){
          this.back()
        } else {
          this.errors = response.errors
          console.log(this.errors)
        }
      })
    },
    back() {
      this.$router.go(-1)
    }
  }
}
</script>


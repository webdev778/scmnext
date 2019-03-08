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
                  v-bind:disabled="fieldDisabled(field)"
                )
            template(v-else-if="field.type=='radio'")
              b-form-group(
                v-bind:label="field.label"
                v-bind:label-for="field.key"
                )
                b-form-radio-group(
                  v-bind:id="field.key"
                  v-bind:options="options[field.key]"
                  v-model="formData[field.key]"
                  v-bind:disabled="fieldDisabled(field)"
                )
            template(v-else-if="field.type=='nested'")
              b-form-group(
                v-bind:label="field.label"
                v-bind:label-for="field.key"
              )
                table.table
                  thead
                    tr
                      th(
                        v-for="(nestedField, nestdFieldIndex) in field.fields"
                        v-if="nestedField.type!='hidden'"
                      )
                        | {{nestedField.label}}
                  tbody
                    tr(v-for="(nestedFormData, detailIndex) in formData[field.key]")
                      template(v-for="(nestedField, nestdFieldIndex) in field.fields")
                        template(v-if="nestedField.type=='hidden'")
                          input(
                            v-bind:id="nestedField.key"
                            type="hidden"
                            v-model="nestedFormData[nestedField.key]"
                            v-bind:disabled="fieldDisabled(field)"
                          )
                        template(v-else-if="nestedField.type=='select'")
                          td
                            b-form-select(
                              v-if="options[field.key][nestedField.key]"
                              v-bind:id="nestedField.key"
                              v-bind:options="options[field.key][nestedField.key]"
                              v-model="nestedFormData[nestedField.key]"
                              v-bind:disabled="fieldDisabled(nestedField)"
                            )
                        template(v-else)
                          td
                            b-form-input(
                              v-bind:id="nestedField.key"
                              v-bind:type="nestedField.type"
                              v-model="nestedFormData[nestedField.key]"
                              v-bind:disabled="fieldDisabled(field)"
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
                  v-bind:disabled="fieldDisabled(field)"
                )
          b-button(v-if="canEdit" type="submit" variant="primary") 保存
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
      type: null,
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
      default: () => {}
    },
    canEdit: {
      type: Boolean,
      required: false,
      default: true
    }
  },
  computed: {
    pluralName() {
      return pluralize.plural(this.name)
    },
    resourceUrl() {
      if (this.isCreateMode){
        return `/v1/${this.pluralName}`
      }else{
        return `/v1/${this.pluralName}/${this.id}`
      }
    },
    isCreateMode() {
      return this.id == 'new'
    }
  },
  mounted(){
    this.init()
  },
  methods: {
    init() {
      if (this.isCreateMode){
        this.formData = {}
        this.fields.forEach(field=>{
          this.formData[field.key] = null
        })
      }else{
        this.$axios.$get(this.resourceUrl)
        .then( (response)=>{
          this.formData = response
        })
      }
    },
    save() {
      let method = null
      if (this.isCreateMode){
        method = '$post'
      } else {
        method = '$put'
      }
      this.$axios[method](this.resourceUrl, {[this.name]: this.formData} )
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
    },
    fieldDisabled(field) {
      return !this.canEdit || field.disabled
    }
  }
}
</script>


<template lang ="pug">
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
              strong PLS編集画面
            div
            div
              b-form-group(
                label="種別"
                label-for="bg"
                )
              b-form-radio-group(v-model='typeSelected', :options='options', name='radio-inline')
            div

          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            div(slot="header")
              i.fa.fa-align-justify
              strong PLS
            div
            component(:is='typeSelected')
</template>

<script>
import axios from "axios"
import Bg from "../../../../components/Pages/pls_form/_id/Bg"
import Fit from "../../../../components/Pages/pls_form/_id/Fit"
import JepxSpot from "../../../../components/Pages/pls_form/_id/JepxSpot"
import Jepx1Hr from "../../../../components/Pages/pls_form/_id/Jepx1Hr"
import JojiBackup from "../../../../components/Pages/pls_form/_id/JojiBackup"
import Sotai from "../../../../components/Pages/pls_form/_id/Sotai"

export default {
    components : {
      Bg,
      Fit,
      JepxSpot,
      Jepx1Hr,
      JojiBackup,
      Sotai
    },
    data() {
      return {
        typeSelected: 'Bg',
        options: [
          { text: 'BG', value: 'Bg' },
          { text: 'JEPXスポット', value: 'JepxSpot' },
          { text: 'JEPX1時間前', value: 'Jepx1Hr' },
          { text: '常時バックアップ', value: 'JojiBackup' },
          { text: 'FIT', value: 'Fit' },
          { text: '相対', value: 'Sotai' }
        ]
      }     
    },
    async asyncData(ctx) {
      console.log("getting bg by api")
      let resource = await ctx.$restApi.list('balancing_groups', null, {format: 'options'})
      return {
        resource: resource
      }
    },
    mounted(){
      this.init()
    },
    computed: {
      resourceUrl() {
        if (this.isCreateMode){
          return `/v1/resources`
        }else{
          return `/v1/resources/${this.id}`
        }
      },
      isCreateMode() {
        return this.id == 'new'
      }
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
        this.$axios[method](this.resourceUrl, { resource: this.formData} )
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
      typeSelectDisabled() {
        
      }

    }
  }
</script>
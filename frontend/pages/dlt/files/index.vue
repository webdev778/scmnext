<template lang="pug">
  rest-index(
    title="託送ダウンロードファイル一覧"
    name="dlt/files"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:list-only="true"
    v-bind:canEdit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="PPS名"
            label-for="setting_company_id_eq"
            )
            b-form-select(id="setting_company_id_eq" v-model="query.setting_company_id_eq" v-bind:options="companies")
        b-col
          b-form-group(
            label="エリア名"
            label-for="setting_district_id_eq"
            )
            b-form-select(id="setting_district_id_eq" v-model="query.setting_district_id_eq" v-bind:options="districts")
        b-col
          b-form-group(
            label="ファイル名"
            label-for="filename"
            )
            b-form-input(id="filename" v-model="query.content_blob_filename_cont")
      b-row
        b-col
          b-form-group(
            label="ステータス"
            label-for="state_in"
            )
            b-form-checkbox-group(id="state_in" name="state_in" v-model="query.state_in" v-bind:options="states")
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
          key: "setting.company.name",
          label: "PPS名"
        },
        {
          key: "setting.district.name",
          label: "エリア名",
          width: 80
        },
        {
          key: "content_blob.filename",
          label: "ファイル名",
          width: 240
        },
        {
          key: "state_i18n",
          label: "ステータス",
          width: 80
        },
        {
          key: "created_at",
          label: "作成日時",
          width: 180,
        },
        {
          key: "updated_at",
          label: "更新日時",
          width: 180,
        }
      ],
      query: {
        id_eq: null,
        setting_company_id_eq: null,
        setting_district_id_eq: null,
        content_blob_filename_cont: null
      },
      companies: [],
      districts: [],
      states: []
    }
  },
  created (){
    this.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.companies = result
    })
    this.$restApi.list('districts', null, {format: 'options', emptyValue: '全て'})
    .then(result=>{
      this.districts = result
    })
    this.$restApi.enums('dlt/files', 'states', {format: 'options'})
    .then(result=>{
      this.states = result
    })

  }
}
</script>


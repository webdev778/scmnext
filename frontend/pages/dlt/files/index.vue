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
            label="バランシンググループ名"
            label-for="setting_bg_member_balancing_group_id_eq"
            )
            b-form-select(id="setting_bg_member_balancing_group_id_eq" v-model="query.setting_bg_member_balancing_group_id_eq" v-bind:options="balancing_groups")
        b-col
          b-form-group(
            label="PPS名"
            label-for="setting_bg_member_company_id_eq"
            )
            b-form-select(id="setting_bg_member_company_id_eq" v-model="query.setting_bg_member_company_id_eq" v-bind:options="companies")
        b-col
          b-form-group(
            label="ファイル名"
            label-for="content_blob_filename_cont"
            )
            b-form-input(id="content_blob_filename_cont" v-model="query.content_blob_filename_cont")
      b-row
        b-col
          b-form-group(
            label="記録日from"
            label-for="record_date_gteq"
            )
            b-form-input(id="record_date_gteq" name="record_date_gteq" type="date" v-model="query.record_date_gteq")
        b-col
          b-form-group(
            label="記録日to"
            label-for="record_date_lteq"
            )
            b-form-input(id="record_date_lteq" name="record_date_lteq" type="date" v-model="query.record_date_lteq")
        b-col
          b-form-group(
            label="電圧モード"
            label-for="voltage_mode_in"
            )
            b-form-checkbox-group(id="voltage_mode_in" name="voltage_mode_in" v-model="query.voltage_mode_in" v-bind:options="voltage_modes")
      b-row
        b-col
          b-form-group(
            label="データ種別"
            label-for="data_type_in"
            )
            b-form-checkbox-group(id="data_type_in" name="data_type_in" v-model="query.data_type_in" v-bind:options="data_types")
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
          key: "setting.bg_member.balancing_group.name",
          label: "バランシンググループ名",
          width: 180
        },
        {
          key: "setting.bg_member.company.name",
          label: "PPS名"
        },
        {
          key: "voltage_mode_i18n",
          label: "電圧モード",
          width: 80
        },
        {
          key: "data_type_i18n",
          label: "データ種別",
          width: 80
        },
        {
          key: "record_date",
          label: "記録日",
          formatter: 'formatDate',
          width: 100
        },
        {
          key: "record_time_index_id",
          label: "記録時間枠ID",
          width: 100
        },
        {
          key: "revision",
          label: "更新番号",
          width: 80
        },
        {
          key: "section_number",
          label: "分割番号",
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
          formatter: 'formatDatetime'
        },
        {
          key: "updated_at",
          label: "更新日時",
          formatter: 'formatDatetime'
        }
      ],
      query: {
        id_eq: null,
        setting_bg_member_balancing_group_id_eq: null,
        setting_bg_member_company_id_eq: null,
        content_blob_filename_cont: null,
        record_date_gteq: null,
        record_date_lteq: null,
        voltage_mode_in: null,
        data_type_in: null,
        state_in: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      balancing_groups: await ctx.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '全て'}),
      companies: await ctx.$restApi.list('companies', null, {format: 'options', emptyValue: '全て'}),
      voltage_modes: await ctx.$restApi.enums('dlt/files', 'voltage_modes', {format: 'options'}),
      data_types: await ctx.$restApi.enums('dlt/files', 'data_types', {format: 'options'}),
      states: await ctx.$restApi.enums('dlt/files', 'states', {format: 'options'})
    }
  }
}
</script>


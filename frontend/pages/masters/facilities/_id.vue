<template lang="pug">
  rest-form(
    title="施設詳細"
    name="facility"
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
          key: "code",
          type: "text",
          label: "コード"
        },
        {
          key: "consumer_id",
          type: "select",
          label: "需要家"
        },
        {
          key: "district_id",
          type: "select",
          label: "エリア"
        },
        {
          key: "voltage_type_id",
          type: "select",
          label: "電圧種別"
        },
        {
          key: "contract_capacity",
          type: "text",
          label: "契約容量"
        },
        {
          key: "tel",
          type: "text",
          label: "TEL"
        },
        {
          key: "fax",
          type: "text",
          label: "FAX"
        },
        {
          key: "email",
          type: "text",
          label: "EMAIL"
        },
        {
          key: "url",
          type: "text",
          label: "URL"
        },
        {
          key: "postal_code",
          type: "text",
          label: "郵便番号"
        },
        {
          key: "pref_no",
          type: "text",
          label: "都道府県番号"
        },
        {
          key: "city",
          type: "text",
          label: "市区町村"
        },
        {
          key: "address",
          type: "text",
          label: "住所"
        },
        {
          key: "person_in_charge",
          type: "text",
          label: "担当者"
        },
        {
          key: "person_in_charge_kana",
          type: "text",
          label: "担当者カナ"
        }
      ]
    }
  },
  async asyncData(ctx) {
    return {
      options: {
        consumer_id: await ctx.$restApi.list('consumers', null, {format: 'options', emptyValue: '未設定'}),
        district_id: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '未設定'}),
        voltage_type_id: await ctx.$restApi.list('voltage_types', null, {format: 'options', emptyValue: '未設定'})
      }
    }
  }
}
</script>


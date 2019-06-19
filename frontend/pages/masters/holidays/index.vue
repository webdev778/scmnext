<template lang="pug">
  rest-index(
    title="休日一覧"
    name="holidays"
    v-bind:fields="fields"
    v-bind:query="query"
    v-bind:can-edit="false"
  )
    template(slot="search")
      b-row
        b-col
          b-form-group(
            label="日付From"
            label-for="date_gteq"
            )
            b-form-input(
              id="date_gteq"
              v-model="query.date_gteq"
              type="date"
            )
        b-col
          b-form-group(
            label="日付To"
            label-for="date_lteq"
            )
            b-form-input(
              id="date_lteq"
              v-model="query.date_lteq"
              type="date"
            )
        b-col
          b-form-group(
            label="名称"
            label-for="name_cont"
            )
            b-form-input(
              id="name_cont"
              v-model="query.name_cont"
            )
        b-col
          b-form-group(
            label="エリア"
            label-for="district_id"
            )
            b-form-select(
              id="district_id"
              v-model="query.district_id_eq"
              v-bind:options="districts"
            )
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
          key: "date",
          label: "日付"
        },
        {
          key: "name",
          label: "名称"
        },
        {
          key: "district.name",
          label: "エリア名"
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
        date_gteq: null,
        date_lteq: null,
        name_cont: null,
        district_id_eq: null
      }
    }
  },
  async asyncData(ctx) {
    return {
      districts: await ctx.$restApi.list('districts', null, {format: 'options', emptyValue: '全て'})
    }
  }
}
</script>


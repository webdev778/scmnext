<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-row(v-if="data")
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            div(slot="header")
              i.fa.fa-align-justify
              strong 施設一覧
            div
              b-pagination(
                size="md"
                v-bind:per-page="data.pages.per_page"
                v-bind:total-rows="data.pages.total_count"
                v-model="currentPage")
              b-table(
                v-bind:items='data.records'
                v-bind:fields='fields'
                hover
                striped
                bordered
                small
                fixed
                xs
                )
                template(slot="table-colgroup")
                  col(style="width: 50px;")
                  col
                  col(style="width: 180px;")
                  col(style="width: 180px;")
                template(slot="name" slot-scope="data")
                  router-link(v-bind:to="{ name : 'facilities-id', params : { id: data.item.id }}")
                    | {{data.value}}
</template>

<script>
import Vue from 'vue'

export default {
  data() {
    return {
      currentPage: null,
      data: null,
      fields: [
        {
          key: "id",
          label: "ID"
        },
        {
          key: "name",
          label: "名前"
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
      ]
    }
  },
  watch: {
    currentPage: async function (newPage) {
      this.data = await this.$axios.$get(`/v1/facilities?page=${newPage}`)
    }
  },
  mounted() {
    this.currentPage = 1
  },
  methods: {
    formatDatetime(value) {
      return value
      //return this.$moment(value).format('lll')
    }
  },
  mounted() {
    this.currentPage = 1
  },
}
</script>


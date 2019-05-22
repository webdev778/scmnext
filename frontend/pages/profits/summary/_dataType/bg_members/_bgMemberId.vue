<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-row
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            b-row
              b-col
                b-link.btn.btn-secondary(
                  v-bind:href="urlFor('csv')"
                ) CSVエクスポート
                b-link.btn.btn-secondary(
                  v-bind:href="urlFor('xlsx')"
                ) EXCELエクスポート
                b-link.btn.btn-secondary(
                  v-on:click="$router.go(-1)"
                ) 戻る
            b-table(small v-bind:items="items" v-bind:fields="$store.getters['profit/fields'](query.group_by_unit)" fixed responsive)
              template(v-for="slotName in $store.getters['profit/headerSlotNames'](query.group_by_unit)" v-slot:[slotName]="data")
                span(v-html="data.label")
              template(v-slot:links="data")
                b-link(v-if="$store.getters['profit/getDetailPath'](dataType, bgMemberId, query, data)" v-bind:to="{path: $store.getters['profit/getDetailPath'](dataType, bgMemberId, query, data)}")
                  | 詳細
</template>

<script>
export default {
  async asyncData(ctx) {
    let route = ctx.route
    let $axios = ctx.$axios
    let store = ctx.store
    let dataType = route.params.dataType
    let bgMemberId = route.params.bgMemberId
    let query = route.query
    let url = store.getters['profit/getApiUrl']('json', dataType, bgMemberId, query)
    let items = await $axios.$get(store.getters['profit/getApiUrl']('json', dataType, bgMemberId, query))
    return {
      dataType: dataType,
      bgMemberId: bgMemberId,
      query: query,
      items: items
    }
  },
  watch: {
    async $route(to, from) {
      let dataType = this.$route.params.dataType
      let bgMemberId = this.$route.params.bgMemberId
      this.query = this.$route.query
      this.items = await this.$axios.$get(this.$store.getters['profit/getApiUrl']('json', dataType, bgMemberId, this.query))
    }
  },
  methods: {
    urlFor(format){
      return this.$axios.defaults.baseURL + this.$store.getters['profit/getApiUrl'](format, this.dataType, this.bgMemberId, this.query)
    },
    currency(value){
      return this.$formatter.currency(value);
    },
    decimal(value){
      return this.$formatter.decimal(value);
    },
    integer(value){
      return this.$formatter.integer(value);
    },
    percent(value){
      return this.$formatter.percent(value);
    }
  }
}
</script>

<style scope="scoped">
  td.table-align-right {
    text-align: right;
  }
  td.td-text {
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
  }
</style>

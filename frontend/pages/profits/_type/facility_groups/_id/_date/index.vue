<template lang="pug">
  .wrapper
    .animated.fadeIn
      b-row
        b-col
          b-card(
            header-tag="header"
            footer-tag="footer"
            style="overflow-x: scroll; height: 700px; overflow-y: scroll;"
            )
            b-row
              b-col
                b-form(inline)
                  b-button(
                    v-on:click="fetchData('csv')"
                  ) CSVエクスポート
                  b-button(
                    v-on:click="fetchData('xlsx')"
                  ) EXCELエクスポート
            b-table(small v-bind:items="items" v-bind:fields="$store.getters['profit/fields']('time_index_id')" style="width: 2000px;")
              template(v-for="slotName in $store.getters['profit/headerSlotNames']('time_index_id')" v-slot:[slotName]="data")
                span(v-html="data.label")
</template>

<script>
export default {
  async asyncData ({ $axios, params, query, error }) {
    const response = await $axios.$get(`/v1/profits/${params.type}/facility_groups/${params.id}/${params.date}.json`)
    .catch(err => {
      error({message: "エラーaaaa"})
      return err
    })
    return {
      dataType: params.type,
      facilityGroupId: params.id,
      date: params.date,
      items: response
    }
  }
}
</script>

<style scope="scoped">
  td.table-align-right {
    text-align: right;
  }
</style>

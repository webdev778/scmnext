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
            b-table(small v-bind:items="items" v-bind:fields="$store.getters['profit/fields']('date')" style="width: 2000px;")
              template(v-for="slotName in $store.getters['profit/headerSlotNames']('date')" v-slot:[slotName]="data")
                span(v-html="data.label")
              template(v-slot:links="data")
                b-link(v-bind:to="{ path: `/profits/${dataType}/facility_groups/${facilityGroupId}/${data.item.date}` }")
                  | 詳細
</template>

<script>
export default {
  async asyncData ({ $axios, params, query, error }) {
    console.log("asyncData")
    const response = await $axios.$get(`/v1/profits/${params.type}/facility_groups/${params.id}.json`, {params: query} )
    .catch(err => {
      error({message: "エラーaaaa"})
      return err
    })
    return {
      dataType: params.type,
      facilityGroupId: params.id,
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

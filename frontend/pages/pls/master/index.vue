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
              strong PLSマスター一覧条件
            div
            div
              b-form-group(
                label="BG名"
                label-for="bg"
                )
              b-form-select(v-model='selected', :options='balancing_groups')
              .mt-3
            b-button.mr-1(
              @click='fetchData()' 
              variant="primary"
              )
              | 検索
          b-card(
            header-tag="header"
            footer-tag="footer"
            )
            div(slot="header")
              i.fa.fa-align-justify
              strong PLSマスター一覧
            div
              b-row
                b-col
                  b-pagination(
                    size="md"
                    v-bind:limit=20
                    v-bind:per-page="items.pages.per_page"
                    v-bind:total-rows="items.pages.total_count"
                    v-model="currentPage")
                b-col
                  b-badge
                    | 総件数: {{items.pages.total_count}}
                b-col(cols=2)
                  b-form-select(
                    v-model="perPage"
                    v-bind:options="perPages"
                  )
            b-table(small v-bind:items="items.records" v-bind:fields="fields" fixed responsive)
              template(slot='actions', slot-scope='row')
                nuxt-link(:to="'/pls/master/'+ row.item.id")
                  b-button.mr-1(size='sm', variant="primary")
                    | 編集
                b-button(size='sm', @click='deleteRow(row.item.id)', variant="primary")
                  | 削除
</template>

<script>
export default {
    data() {
      return {
        selected: null,
        fields: [
          { key: 'actions', label: '' },
          { key: 'type', label: '種別', sortable: true, sortDirection: 'desc' },
          { key: 'code', label: 'コード', sortable: true, class: 'text-center' },
          { key: 'contract_no', label: '契約番号' },
          { key: 'name', label: 'BGメンバー' },
          { key: 'max', label: '最大数'},
          { key: 'min', label: '最小数'},
          { key: 'unit', label: '単位'}
        ],
        totalRows: 1,
        currentPage: 1,
        perPage: 5,
        perPages: [10, 20, 50, 100, 200],
        sortDirection: 'asc',
        filter: null,
      }
    },
    computed: {
      sortOptions() {
        return this.fields
          .filter(f => f.sortable)
          .map(f => {
            return { text: f.label, value: f.key }
          })
      }
    },
    async asyncData(ctx) {
      let balancingGroups = []
      let balancingGroupId = null
      let bgMembers = []
      let bgMemberId = null
      let resources = []
      let currentPage = 1
      let perPage = 5
      
      balancingGroups = await ctx.$restApi.list('balancing_groups', null, {format: 'options', emptyValue: '全て'})

      if (balancingGroups.length > 0){
        balancingGroupId = balancingGroups[0].value
        let params = { 
          "q[bg_member_balancing_group_id_eq]": balancingGroupId,
          page: currentPage, 
          per: perPage
        }
        resources = await ctx.$restApi.index('resources', {params})
      }

      return {
        balancing_groups: balancingGroups,
        balancingGroupId: balancingGroupId,
        items: resources,
        currentPage: currentPage, 
        perPage: perPage
      }
  },
    mounted() {
      this.totalRows = this.items.length
    },
    watch: {
      currentPage: function(newPage){
        this.fetchData()
      },
      perPage: function(newPerPage){
        this.fetchData()
      }
    },
    methods: {
      async deleteRow(id) { 
        await this.$axios.$delete(`/v1/resources/${id}`)
        this.fetchData() 
      },
      async fetchData(){
        let params = {
          "q[bg_member_balancing_group_id_eq]": this.selected,
          page: this.currentPage, 
          per: this.perPage
          }
        this.$axios.$get('/v1/resources', { params })
        .then( (result)=>{
          this.items = result
        })
      }
    }
  }
</script>
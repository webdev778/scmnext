<template lang ="pug">
  .wrapper
    .animated.fadeIn
      b-container(fluid='')
        b-row.my-1(v-for='type in types', :key='type')
          b-col(sm='3')
            label(:for='`type-${type}`') Type {{ type }}:
          b-col(sm='9')
            b-form-input(:id='`type-${type}`', :type='type')
        b-button(size='sm', @click='addTableRow', variant="primary")
                  | addrow
        b-table(striped='', hover='', :items='types', :fields='fields')
</template>

<script>
export default {
    props: ['company_name', 'code'],
    data() {
      return {
        selected: null,
        fields: ['key', 'label', 'sortable'],
        types: [
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
    methods: {
      addTableRow() { 
        this.types.push(
          {
            key: '', 
            label: '',
            sortable: ''
            })
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
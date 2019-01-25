<template lang="pug">
  .wrapper(v-if="data")
    .animated.fadeIn
      b-card(
        header-tag="header"
        footer-tag="footer"
        )
        div(slot="header")
          i.fa.fa-align-justify
          strong {{title}}
        div
          b-row
            b-col
              b-pagination(
                size="md"
                v-bind:per-page="data.pages.per_page"
                v-bind:total-rows="data.pages.total_count"
                v-model="currentPage")
            b-col(cols=2)
              b-form-select(
                v-model="perPage"
                v-bind:options="perPages"
              )
          b-table(
            v-bind:items='data.records'
            v-bind:fields='fieldsModified'
            hover
            striped
            bordered
            small
            fixed
            xs
            )
            template(slot="table-colgroup")
              col(v-for="(field, index) in fieldsModified" v-bind:style="getColTagStyle(field)")
            template(slot="operations" slot-scope="data")
              router-link.btn.btn-sm.btn-primary(
                v-bind:to="{ name : name + '-id', params : { id: data.item.id }}"
              )
                i.fa.fa-edit
                | 編集
              | &nbsp;
              .btn.btn-sm.btn-danger
                i.fa.fa-trash
                | 削除
</template>

<script>
export default {
  data(){
    return {
      currentPage: null,
      data: null,
      perPages: [10, 20, 50, 100, 200],
      perPage: 10
    }
  },
  props: {
    title: {
      type: String,
      required: true,
      default: () => null
    },
    name: {
      type: String,
      required: true,
      default: () => null
    },
    fields: {
      type: Array,
      required: true,
      default: () => []
    },
    canEdit: {
      type: Boolean,
      required: false,
      default: () => false
    }
  },
  watch: {
    currentPage: function(newPage){
      this.retriveData()
    },
    perPage: function(newPerPage){
      this.retriveData()
    }
  },
  computed: {
    fieldsModified() {
      let result = []
      if (this.canEdit){
        result = result.concat([{
          key: 'operations',
          label: '',
          width: 122
        }])
      }
      result = result.concat(this.fields)
      return result
    }
  },
  mounted() {
    this.currentPage = 1
  },
  methods: {
    getColTagStyle(field) {
      let style = {}
      if (field.width) {
        style['width'] = field.width + 'px'
      }
      return style
    },
    async retriveData() {
      this.data = await this.$axios.$get(`/v1/${this.name}`, {params: {page: this.currentPage, per: this.perPage}})
    }
  }
}
</script>
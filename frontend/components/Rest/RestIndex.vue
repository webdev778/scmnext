<template lang="pug">
  .wrapper(v-if="data")
    .animated.fadeIn
      b-card(
        v-if="$slots['search']"
        header-tag="header"
        footer-tag="footer"
        )
        div(slot="header")
          i.fa.fa-align-justify
          strong {{title}}検索条件
        b-form
          slot(name='search')
          b-button(
            v-on:click.prevent.stop="retriveData"
            variant="primary"
            type="submit"
          )
            | 検索
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
                v-bind:limit=20
                v-bind:per-page="data.pages.per_page"
                v-bind:total-rows="data.pages.total_count"
                v-model="currentPage")
            b-col
              b-badge
                | 総件数: {{data.pages.total_count}}
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
            small
            fixed
            xs
            )
            template(v-for="(field, index) in fieldsModified" v-bind:slot="'HEAD_' + field.key" slot-scope="data")
              span(v-on:click="sortField(field.key)")
                | {{field.label}}
                template(v-if="sort.name == field.key")
                  i.fa.fa-sort-up(v-if="sort.dir == 'asc'")
                  i.fa.fa-sort-down(v-if="sort.dir == 'desc'")
            template(slot="table-colgroup")
              col(v-for="(field, index) in fieldsModified" v-bind:style="getColTagStyle(field)")
            template(slot="HEAD_operations" slot-scope="data")
              template(v-if="canEdit")
                router-link.btn.btn-sm.btn-primary(
                  v-bind:to="{ name : formRouteName, params: {id: 'new'}}"
                )
                  i.fa.fa-plus
                  | 新規
            template(slot="operations" slot-scope="data")
              template(v-if="canEdit")
                router-link.btn.btn-sm.btn-primary(
                  v-bind:to="{ name : formRouteName, params : { id: data.item.id }}"
                )
                  i.fa.fa-edit
                  | 編集
                | &nbsp;
                .btn.btn-sm.btn-danger(v-on:click="deleteItem(data.item.id)")
                  i.fa.fa-trash
                  | 削除
              template(v-else)
                router-link.btn.btn-sm.btn-primary(
                  v-bind:to="{ name : formRouteName, params : { id: data.item.id }}"
                )
                  i.fa.fa-eye
                  | 表示
</template>

<script>
export default {
  data(){
    return {
      currentPage: null,
      data: null,
      perPages: [10, 20, 50, 100, 200],
      perPage: 10,
      sort: {
        name: null,
        dir: 'asc'
      },
      defaultWidth: {
        operations: 122,
        id: 50,
        created_at: 180,
        updated_at: 180
      }
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
    query: {
      type: Object,
      required: false,
      default: () => null
    },
    canEdit: {
      type: Boolean,
      required: false,
      default: () => true
    },
    listOnly: {
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
      if (!this.listOnly){
        result = result.concat([{
          key: 'operations',
          label: ''
        }])
      }
      result = result.concat(this.fields).map(field=>{
        if (!field['width'] && this.defaultWidth[field.key]){
          field['width'] = this.defaultWidth[field.key]
        }
        return field
      })
      return result
    },
    formRouteName() {
      return this.$store.$router.currentRoute.name + '-id'
    }
  },
  mounted() {
    console.log(this.$store.$router.currentRoute)
    if (this.listOnly && this.canEdit){
      throw new Error("一覧のみで編集可能にすることはできません。")
    }
    console.log(this)
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
    sortField(key) {
      if (this.sort.name != key) {
        this.sort.name = key
        this.sort.dir = 'asc'
      } else {
        this.sort.dir = this.sort.dir == 'asc' ? 'desc' : 'asc'
      }
      this.retriveData()
    },
    async deleteItem(id) {
      await this.$axios.$delete(`/v1/${this.name}/${id}`)
      this.retriveData()
    },
    async retriveData() {
      let params = {page: this.currentPage, per: this.perPage}
      // 検索条件が指定されていた場合は検索条件をセットする
      if (this.query){
        Object.keys(this.query).forEach (key=>{
          params[`q[${key}]`] = this.query[key]
        })
      }
      // ソートが指定されていた場合はソートをセットする
      if (this.sort.name){
        params["q[s]"] = `${this.sort.name.replace('.', '_')} ${this.sort.dir}`
      }
      this.data = await this.$axios.$get(`/v1/${this.name}`, {params: params})
    }
  }
}
</script>
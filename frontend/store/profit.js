export const state = () => ({
  dataTypes: [
    {value: 'preliminary', text: '速報値'},
    {value: 'fixed', text: '確定値'}
  ],
  listTableFields: [
    { key: "amount_actual", label: "需要<br>電力<br>使用量", variant: 'align-right', formatter: "decimal" , thStyle: "width: 80px" },
    { key: "amount_planned", label: "需要<br>計画値", variant: 'align-right', formatter: "decimal", thStyle: "width: 80px" },
    { key: "amount_loss", label: "需要<br>損失量", variant: 'align-right', formatter: "decimal", thStyle: "width: 80px"},
    { key: "amount_imbalance", label: "需要<br>インバランス", variant: 'align-right', formatter: "decimal", thStyle: "width: 80px" },
    { key: "sales_basic_charge", label: "売上<br>基本料金", variant: 'align-right', formatter: "currency", thStyle: "width: 80px"  },
    { key: "sales_meter_rate_charge", label: "売上<br>従量料金", variant: 'align-right', formatter: "currency", thStyle: "width: 80px"   },
    { key: "sales_fuel_cost_adjustment", label: "売上<br>燃料調整費", variant: 'align-right', formatter: "currency", thStyle: "width: 80px"  },
    { key: "sales_cost_adjustment", label: "売上<br>その他調整費", variant: 'align-right', formatter: "currency", thStyle: "width: 80px"  },
    { key: "sales_total", label: "売上<br>合計", variant: 'align-right', formatter: "currency", thStyle: "width: 80px"  },
    { key: "sales_kw_unit_price", label: "売上<br>kw単価", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "usage_jbu", label: "供給<br>JBU", variant: 'align-right', formatter: "decimal", thStyle: "width: 80px" },
    { key: "usage_jepx_spot", label: "供給<br>JEPXスポット", variant: 'align-right', formatter: "decimal", thStyle: "width: 80px" },
    { key: "usage_jepx_1hour", label: "供給<br>一時間前", variant: 'align-right', formatter: "decimal", thStyle: "width: 80px" },
    { key: "usage_fit", label: "供給<br>FIT", variant: 'align-right', formatter: "decimal", thStyle: "width: 80px" },
    { key: "usage_matching", label: "供給<br>相対", variant: 'align-right', formatter: "decimal", thStyle: "width: 80px" },
    { key: "supply_jbu_basic_charge", label: "仕入<br>JBU基本料金", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_jbu_meter_rate_charge", label: "仕入<br>JBU従量料金", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_jbu_fuel_cost_adjustment", label: "仕入<br>JBU燃料調整費", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_jepx_spot", label: "仕入<br>JEPXスポット", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_jepx_1hour", label: "仕入<br>JEPX一時間前", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_fit", label: "仕入<br>FIT", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_matching", label: "仕入<br>相対", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_imbalance", label: "仕入<br>インバランス", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_wheeler_fundamental_charge", label: "仕入<br>託送基本料金", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_wheeler_mater_rate_charge", label: "仕入<br>託送従量料金", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_total", label: "仕入<br>合計", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "supply_kw_unit_price", label: "仕入<br>kw単価", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "profit_value", label: "売上総利益", variant: 'align-right', formatter: "currency", thStyle: "width: 80px" },
    { key: "profit_rate", label: "利益率", variant: 'align-right', formatter: "percent", thStyle: "width: 80px" },
    { key: "load_factor", label: "負荷率", variant: 'align-right', formatter: "percent", thStyle: "width: 80px" }
  ],
  extraFields: {
    facility_group_id: [
      { key: "links", label: "詳細", thStyle: "width: 50px;"},
      { key: "facility_group_id", label: "ID", thStyle: "width: 50px;"},
      { key: "facility_group_name", label: "名称", thStyle: "width: 400px;", tdClass: "td-text"}
    ],
    date: [
      { key: "links", label: "詳細", thStyle: "width: 50px;"},
      { key: "date", label: "日付", thStyle: "width: 100px"},
    ],
    time_index_id: [
      { key: "links", label: "詳細", thStyle: "width: 50px;"},
      { key: "time_index_id", label: "コマ", thStyle: "width: 50px;"}
    ]
  }
})

export const getters = {
  // API用のURLを生成する
  getApiUrl: (state, getters) => (format, dataType, bgMemberId, query)=> {
    let queryString = getters.buildQueryString(query, 'rails')
    let url = `/v1/profits/${dataType}/bg_members/${bgMemberId}.${format}?${queryString}`
    return url
  },
  // 詳細画面用のpathを生成する
  getDetailPath: (state, getters) => (dataType, bgMemberId, query, data)=> {
    let detailQuery = {}
    switch (getters.detectQueryType(query)){
      case "selectDateRangeGroupByFacilityGroupId":
        detailQuery['date_from'] = query.date_from
        detailQuery['date_to'] = query.date_to
        detailQuery['facility_group_id'] = data.item.facility_group_id
        detailQuery['group_by_unit'] = 'date'
        break
      case "selectDateRangeAndFacilityGroupIdGroupByDate":
        detailQuery['date'] = data.item.date
        detailQuery['facility_group_id'] = query.facility_group_id
        detailQuery['group_by_unit'] = 'time_index_id'
        break
      case "selectDateAndFacilityGroupIdGroupByTimeIndexId":
        // nothing to do(no detail page)
        break
      case "selectDateRangeGroupByDate":
        detailQuery['date'] = data.item.date
        detailQuery['group_by_unit'] = 'time_index_id'
        break
      case "selectDateGroupByTimeIndexId":
          detailQuery['date'] = query.date
          detailQuery['time_index_id'] = data.item.time_index_id
          detailQuery['group_by_unit'] = 'facility_group_id'
        break
      case "selectTimeIndexIdGroupByFacilityGroupId":
          // nothing to do(no detail page)
        break
      default:
        throw new Error("unknown query type")
    }
    let queryString = getters.buildQueryString(detailQuery, 'nuxt')
    if (queryString==''){
      // パラメータが取得できない場合は最下層のページになるので詳細画面へのリンクは無し
      return false
    }
    return `/profits/summary/${dataType}/bg_members/${bgMemberId}?${queryString}`
  },
  // 検索条件からリストの種別を特定する
  // 1. 日付範囲指定、施設別
  // 2. 日付範囲、施設指定、日別
  // 3. 日付・施設指定、コマ別
  // 4. 日付範囲指定、日別
  // 5. 日付指定、コマ別
  // 6. コマ指定、施設別
  // のいずれか
  detectQueryType: (state, getters) => (query) => {
    if (query.date_from && query.date_to && query.group_by_unit == 'facility_group_id') {
      return "selectDateRangeGroupByFacilityGroupId"
    } else if (query.date_from && query.date_to && query.facility_group_id && query.group_by_unit == 'date') {
      return "selectDateRangeAndFacilityGroupIdGroupByDate"
    } else if (query.date && query.facility_group_id && query.group_by_unit == 'time_index_id') {
      return "selectDateAndFacilityGroupIdGroupByTimeIndexId"
    } else if (query.date_from && query.date_to && query.group_by_unit == 'date') {
      return "selectDateRangeGroupByDate"
    } else if (query.date && query.group_by_unit == 'time_index_id') {
      return "selectDateGroupByTimeIndexId"
    } else if (query.time_index_id && query.group_by_unit == 'facility_group_id') {
      return "selectTimeIndexIdGroupByFacilityGroupId"
    } else {
      throw new Error("can'not detect query type")
    }
  },
  // Queryパラメータ用の文字列をハッシュから生成する
  // (valueがArrayの場合の扱いがnuxtとrailsで違うのでそれぞれに合わせて生成する)
  buildQueryString: () => (queryHash, type) => {
    let arraySuffix = null
    switch (type){
      case 'nuxt':
        arraySuffix = ''
        break
      case 'rails':
        arraySuffix = '[]'
        break
      default:
        throw new Error(`unknown query type=${type}`)
    }
    let queryPairs = Object.keys(queryHash).reduce( (params, key)=>{
      let value = queryHash[key]
      if (Array.isArray(value)){
        value.forEach( v=>{
          params.push(`${key}${arraySuffix}=${v}`)
        })
      } else {
        params.push(`${key}=${value}`)
      }
      return params
    }, [])
    return queryPairs.join('&')
  },
  // フィールド定義を返す
  fields: (state, getters)=> (type)=>{
    if (!type){
      return []
    }
    return state.extraFields[type].concat(state.listTableFields)
  },
  headerSlotNames: (state, getters) => (type)=>{
    return getters.fields(type).map( item=>{
      return `HEAD_${item.key}`
    })
  }
}

export const actions = {
  nuxtServerInit({ commit }, { req }) {
    let auth = null
    if (req.headers.cookie) {
      const parsed = cookieparser.parse(req.headers.cookie)
      console.log(parsed)
      try {
        auth = JSON.parse(parsed.auth)
        commit('setAuth', auth)
      } catch (err) {
        console.log(err)
        // No valid cookie found
      }
    }
  }
}

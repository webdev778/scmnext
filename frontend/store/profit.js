export const state = () => ({
  dataTypes: [
    {value: 'preliminary', text: '速報値'},
    {value: 'fixed', text: '確定値'}
  ],
  listTableFields: [
    { key: "amount_actual", label: "需要<br>電力使用量", variant: 'align-right', formatter: "formatNumber" },
    { key: "amount_planned", label: "需要<br>計画値", variant: 'align-right', formatter: "formatNumber"  },
    { key: "amount_loss", label: "需要<br>損失量", variant: 'align-right', formatter: "formatNumber"  },
    { key: "amount_imbalance", label: "需要<br>インバランス", variant: 'align-right', formatter: "formatNumber"  },
    { key: "sales_basic_charge", label: "売上<br>基本料金", variant: 'align-right', formatter: "formatNumber" },
    { key: "sales_meter_rate_charge", label: "売上<br>従量料金", variant: 'align-right', formatter: "formatNumber"  },
    { key: "sales_fuel_cost_adjustment", label: "売上<br>燃料調整費", variant: 'align-right', formatter: "formatNumber"  },
    { key: "sales_cost_adjustment", label: "売上<br>その他調整費", variant: 'align-right', formatter: "formatNumber"  },
    { key: "sales_total", label: "売上<br>合計", variant: 'align-right', formatter: "formatNumber"  },
    { key: "sales_kw_unit_price", label: "売上<br>kw単価", variant: 'align-right', formatter: "formatNumber"  },
    { key: "usage_jbu", label: "供給<br>JBU", variant: 'align-right', formatter: "formatNumber"  },
    { key: "usage_jepx_spot", label: "供給<br>JEPXスポット", variant: 'align-right', formatter: "formatNumber"  },
    { key: "usage_jepx_1hour", label: "供給<br>一時間前", variant: 'align-right', formatter: "formatNumber"  },
    { key: "usage_fit", label: "供給<br>FIT", variant: 'align-right', formatter: "formatNumber"  },
    { key: "usage_matching", label: "供給<br>相対", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_jbu_basic_charge", label: "仕入<br>JBU基本料金", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_jbu_meter_rate_charge", label: "仕入<br>JBU従量料金", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_jbu_fuel_cost_adjustment", label: "仕入<br>JBU燃料調整費", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_jepx_spot", label: "仕入<br>JEPXスポット", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_jepx_1hour", label: "仕入<br>JEPX一時間前", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_fit", label: "仕入<br>FIT", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_matching", label: "仕入<br>相対", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_imbalance", label: "仕入<br>インバランス", variant: 'align-right', formatter: "formatNumber"  },
    { key: "supply_wheeler_fundamental_charge", label: "仕入<br>託送基本料金", variant: 'align-right', formatter: "formatNumber" },
    { key: "supply_wheeler_mater_rate_charge", label: "仕入<br>託送従量料金", variant: 'align-right', formatter: "formatNumber" },
    { key: "supply_total", label: "仕入<br>合計", variant: 'align-right', formatter: "formatNumber" },
    { key: "supply_kw_unit_price", label: "仕入<br>kw単価", variant: 'align-right', formatter: "formatNumber" },
    { key: "profit_value", label: "売上総利益", variant: 'align-right', formatter: "formatNumber" },
    { key: "profit_rate", label: "利益率", variant: 'align-right', formatter: "formatNumber" },
    { key: "load_factor", label: "負荷率", variant: 'align-right', formatter: "formatNumber" }
  ],
  extraFields: {
    facility_group: [
      { key: "links", label: "日付別詳細" },
      { key: "facility_group_id", label: "ID" },
      { key: "facility_group_name", label: "名称" }
    ],
    date: [
      { key: "links", label: "時間別詳細" },
      { key: "date", label: "日付" },
    ],
    time_index_id: [
      { key: "time_index_id", label: "コマ" }
    ]
  }
})

export const getters = {
  fields: (state, getters)=> (type)=>{
    return state.extraFields[type].concat(state.listTableFields)
  },
  headerSlotNames: (state, getters) => (type)=>{
    return getters.fields(type).map( item=>{
      return `HEAD_${item.key}`
    })
  }
}

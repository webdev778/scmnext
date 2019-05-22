export default {
  items: [
    {
      title: true,
      name: 'メインメニュー',
      class: '',
      wrapper: {
        element: '',
        attributes: {}
      }
    },
    {
      name: '損益計算',
      icon: 'icon-puzzle',
      url: '/base',
      children: [
        {
          name: '同時同量監視',
          url: '/profits/balancings',
        },
        {
          name: '施設グループ別損益',
          url: '/profits/summary',
        }
      ]
    },
    {
      name: '託送データ連携',
      icon: 'icon-puzzle',
      url: '/base',
      children: [
        {
          name: 'ダウンロード設定',
          url: '/dlt/settings',
        },
        {
          name: 'ダウンロードファイル',
          url: '/dlt/files',
        },
        {
          name: '確定使用量ヘッダ',
          url: '/dlt/usage_fixed_headers',
        },
        {
          name: '不整合供給地点特定番号',
          url: '/dlt/invalid_supply_points',
        }
      ]
    },
    {
      name: '広域データ連携',
      icon: 'icon-puzzle',
      url: '/base',
      children: [
        {
          name: '翌日需要調達計画',
          url: '/occto/plans',
        }
      ]
    },
    {
      title: true,
      name: '管理者用',
      class: '',
      wrapper: {
        element: '',
        attributes: {}
      }
    },
    {
      name: 'マスタ',
      icon: 'icon-puzzle',
      url: '/base',
      children: [
        {
          name: 'PPS',
          url: '/masters/companies',
        },
        {
          name: 'バランシンググループ',
          url: '/masters/balancing_groups',
        },
        {
          name: 'BGメンバー',
          url: '/masters/bg_members',
        },
        {
          name: '施設グループ',
          url: '/masters/facility_groups',
        },
        {
          name: '需要家',
          url: '/masters/consumers',
        },
        {
          name: '施設',
          url: '/masters/facilities',
        },
        {
          name: '施設別割引',
          url: '/masters/discounts_for_facilities',
        },
        {
          name: '契約',
          url: '/masters/contracts',
        },
        {
          name: '契約アイテム',
          url: '/masters/contract_items',
        },
        {
          name: '契約アイテムグループ',
          url: '/masters/contract_item_groups',
        },
        {
          name: '契約・契約アイテム別従量料金',
          url: '/masters/contract_meter_rates',
        },
        {
          name: '供給エリア',
          url: '/masters/districts',
        },
        {
          name: 'エリア別損失率',
          url: '/masters/district_loss_rates',
        },
        {
          name: '燃料調整費',
          url: '/masters/fuel_cost_adjustments',
        },
        {
          name: '託送料金',
          url: '/masters/wheeler_charges',
        },
        {
          name: '常時バックアップ電源契約',
          url: '/masters/jbu_contracts',
        },
        {
          name: 'リソース',
          url: '/masters/resources',
        },
        {
          name: '時間枠',
          url: '/masters/time_indices',
        },
        {
          name: '電圧種別',
          url: '/masters/voltage_types',
        },
        {
          name: 'ユーザー',
          url: '/masters/users',
        },
        {
          name: '休日',
          url: '/masters/holidays',
        }
      ]
    },
    {
      name: 'JEPXデータ連携',
      icon: 'icon-puzzle',
      url: '/base',
      children: [
        {
          name: 'インバランスβ',
          url: '/jepx/imbalance_betas',
        },
        {
          name: 'スポット市場取引結果',
          url: '/jepx/spot_trades',
        }
      ]
    },

    // {
    //   name: 'Dashboard',
    //   url: '/dashboard',
    //   icon: 'icon-speedometer',
    //   badge: {
    //     variant: 'primary',
    //     text: 'NEW'
    //   }
    // },
    // {
    //   title: true,
    //   name: 'Theme',
    //   class: '',
    //   wrapper: {
    //     element: '',
    //     attributes: {}
    //   }
    // },
    // {
    //   name: 'Colors',
    //   url: '/theme/colors',
    //   icon: 'icon-drop'
    // },
    // {
    //   name: 'Typography',
    //   url: '/theme/typography',
    //   icon: 'icon-pencil'
    // },
    // {
    //   title: true,
    //   name: 'Components',
    //   class: '',
    //   wrapper: {
    //     element: '',
    //     attributes: {}
    //   }
    // },
    // {
    //   name: 'Base',
    //   url: '/base',
    //   icon: 'icon-puzzle',
    //   children: [
    //     {
    //       name: 'Breadcrumbs',
    //       url: '/base/breadcrumbs',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Cards',
    //       url: '/base/cards',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Carousels',
    //       url: '/base/carousels',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Collapses',
    //       url: '/base/collapses',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Forms',
    //       url: '/base/forms',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Jumbotrons',
    //       url: '/base/jumbotrons',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'List Groups',
    //       url: '/base/list-groups',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Navs',
    //       url: '/base/navs',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Paginations',
    //       url: '/base/paginations',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Popovers',
    //       url: '/base/popovers',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Progress Bars',
    //       url: '/base/progress-bars',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Switches',
    //       url: '/base/switches',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Tables',
    //       url: '/base/tables',
    //       icon: 'icon-puzzle'
    //     },
    //     {
    //       name: 'Tooltips',
    //       url: '/base/tooltips',
    //       icon: 'icon-puzzle'
    //     }
    //   ]
    // },
    // {
    //   name: 'Buttons',
    //   url: '/buttons',
    //   icon: 'icon-cursor',
    //   children: [
    //     {
    //       name: 'Standard Buttons',
    //       url: '/buttons/standard-buttons',
    //       icon: 'icon-cursor'
    //     },
    //     {
    //       name: 'Button Groups',
    //       url: '/buttons/button-groups',
    //       icon: 'icon-cursor'
    //     },
    //     {
    //       name: 'Dropdowns',
    //       url: '/buttons/dropdowns',
    //       icon: 'icon-cursor'
    //     },
    //     {
    //       name: 'Social Buttons',
    //       url: '/buttons/social-buttons',
    //       icon: 'icon-cursor'
    //     }
    //   ]
    // },
    // {
    //   name: 'Icons',
    //   url: '/icons',
    //   icon: 'icon-star',
    //   children: [
    //     {
    //       name: 'Flags',
    //       url: '/icons/flags',
    //       icon: 'icon-star',
    //       badge: {
    //         variant: 'success',
    //         text: 'NEW'
    //       }
    //     },
    //     {
    //       name: 'Font Awesome',
    //       url: '/icons/font-awesome',
    //       icon: 'icon-star',
    //       badge: {
    //         variant: 'secondary',
    //         text: '4.7'
    //       }
    //     },
    //     {
    //       name: 'Simple Line Icons',
    //       url: '/icons/simple-line-icons',
    //       icon: 'icon-star'
    //     }
    //   ]
    // },
    // {
    //   name: 'Charts',
    //   url: '/charts',
    //   icon: 'icon-pie-chart'
    // },
    // {
    //   name: 'Notifications',
    //   url: '/notifications',
    //   icon: 'icon-bell',
    //   children: [
    //     {
    //       name: 'Alerts',
    //       url: '/notifications/alerts',
    //       icon: 'icon-bell'
    //     },
    //     {
    //       name: 'Badges',
    //       url: '/notifications/badges',
    //       icon: 'icon-bell'
    //     },
    //     {
    //       name: 'Modals',
    //       url: '/notifications/modals',
    //       icon: 'icon-bell'
    //     }
    //   ]
    // },
    // {
    //   name: 'Widgets',
    //   url: '/widgets',
    //   icon: 'icon-calculator',
    //   badge: {
    //     variant: 'primary',
    //     text: 'NEW'
    //   }
    // },
    // {
    //   divider: true
    // },
    // {
    //   title: true,
    //   name: 'Extras'
    // },
    // {
    //   name: 'Pages',
    //   url: '/pages',
    //   icon: 'icon-star',
    //   children: [
    //     {
    //       name: 'Login',
    //       url: '/pages/login',
    //       icon: 'icon-star'
    //     },
    //     {
    //       name: 'Register',
    //       url: '/pages/register',
    //       icon: 'icon-star'
    //     },
    //     {
    //       name: 'Error 404',
    //       url: '/pages/404',
    //       icon: 'icon-star'
    //     },
    //     {
    //       name: 'Error 500',
    //       url: '/pages/500',
    //       icon: 'icon-star'
    //     }
    //   ]
    // },
    // {
    //   name: 'Download CoreUI',
    //   url: 'http://coreui.io/vue/',
    //   icon: 'icon-cloud-download',
    //   class: 'mt-auto',
    //   variant: 'success'
    // },
    // {
    //   name: 'Try CoreUI PRO',
    //   url: 'http://coreui.io/pro/vue/',
    //   icon: 'icon-layers',
    //   variant: 'danger'
    // }
  ]
}

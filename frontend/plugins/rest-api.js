export default function ({ app, $axios }, inject) {
  let formatResult = (result, options) => {
    if (options && options['format'] && options['format'] == 'options'){
      result = Object.keys(result).map(key=>{
        return { text: result[key], value: key }
      })
      if (options && options['emptyValue']){
        result.unshift({ text: options['emptyValue'], value: null})
      }
    } else {
      if (options && options['emptyValue']){
        result[null] = options['emptyValue']
      }
    }
    return result
  }
  inject('restApi', {
    //
    // APIを使用し対象のモデルから指定されたIDのデータを取得する
    //
    // @param modelName [String] 対象のモデルクラス
    // @param id [Integer] 取得するモデルのID
    // @return 結果セット(Differd Object)
    //
    index: (modelName, params) => {
      return $axios.get(`/v1/${modelName}`, params)
      .then( response => {
        return response.data
      })
    },
    //
    // APIを使用し対象のモデルにデータを保存する
    // (idの有無で登録/更新をする)
    // @param modelName [String] 対象のモデルクラス
    // @param values [Object] 登録内容
    // @return 結果セット(Differd Object)
    //
    save: (modelName, values) => {
      if (!values.id) {
        return this.create(modelName, values)
      } else {
        return this.update(modelName, values.id, values)
      }
    },
    //
    // APIを使用し対象のモデルにデータを登録する
    //
    // @param modelName [String] 対象のモデルクラス
    // @param values [Object] 登録内容
    // @return 結果セット(Differd Object)
    //
    create: (modelName, values) => {
      return $axios.post(`/v1/${modelName}`, values)
      .then( response => {
        return response.data
      })
    },
    //
    // APIを使用し対象のモデルにデータを更新する
    //
    // @param modelName [String] 対象のモデルクラス
    // @param id [Integer] 更新するモデルのID
    // @param values [Object] 更新内容
    // @return 結果セット(Differd Object)
    //
    update: (modelName, id, values) => {
      return $axios.patch(`/v1/${modelName}/${id}`, values)
      .then( response => {
        return response.data
      })
    },
    //
    // APIを使用し対象のモデルの指定されたIDのデータを削除する
    //
    // @param modelName [String] 対象のモデルクラス
    // @param id [Integer] 削除するモデルのID
    // @return 結果セット(Differd Object)
    //
    delete: (id) => {
      return $axios.delete(`/v1/${modelName}/${id}`, values)
      .then( response => {
        return response.data
      })
    },
    //
    // APIを使用し対象のモデルから指定されたIDのデータを取得する
    //
    // @param modelName [String] 対象のモデルクラス
    // @param id [Integer] 取得するモデルのID
    // @return 結果セット(Differd Object)
    //
    show: (modelName, id) => {
      return $axios.get(`/v1/${modelName}/${id}`)
      .then( response => {
        return response.data
      })
    },
    //
    // APIを使用し対象のモデルからid/名前リストを取得する
    //
    // @param modelName [String] 対象のモデルクラス
    // @param param [Object] パラメータ
    // @param format [String] map or options(未指定時はmap)
    // @return 結果セットまたはそれをoptions型の配列に変換したもの
    //
    list: (modelName, params, options) => {
      return $axios.get(`/v1/${modelName}/list`, {params: params})
      .then( response => {
        return formatResult(response.data, options)
      })
    },
    //
    // APIを使用し対象のモデルから指定された名前の列挙型の値をすべて取得する
    //
    // @param modelName [String] 対象のモデルクラス
    // @param fieldName [String] 列挙型の名前
    // @param options [Object]
    //   以下の文字列をkeyとして指定可能
    //   format: map or options(未指定時はmap)
    //   emptyValue: 指定された場合は、keyが空文字""の場合のラベルとして使用する。リストの場合はリストの最初に作成する
    // @return 結果セットまたはそれをoptions型の配列に変換したもの
    //
    enums: (modelName, fieldName, options) => {
      return $axios.get(`/v1/${modelName}/enums/${fieldName}`)
      .then( response => {
        return formatResult(response.data, options)
      })
    }
  })
}

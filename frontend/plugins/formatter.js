export default function ( ctx, inject) {
  let formatUnlessNull = (value, formatterFunc) => {
    if (!value) {
      return null
    } else {
      return formatterFunc(value)
    }
  }
  const formatter = {
    currency: (value) => {
      return formatUnlessNull(value, (value)=>{
        let formatter = new Intl.NumberFormat('ja-JP')
        return formatter.format(Number(value).toFixed(0))
      })
    },
    integer: (value) => {
      return formatUnlessNull(value, (value)=>{
        return Number(value).toFixed(0)
      })
    },
    decimal: (value) => {
      return formatUnlessNull(value, (value)=>{
        return Number(value).toFixed(2)
      })
    },
    percent: (value) => {
      return formatUnlessNull(value, (value)=>{
        return Number(value).toFixed(2) + "%"
      })
    }
  }
  ctx.$formatter = formatter
  inject('formatter', formatter)
}

export default function ({ store, redirect }) {
  console.log("middleware")
  if (!store.state.auth) {
    console.log(store.state)
    return redirect('/session/new')
  }
}

export default function ({ store, redirect }) {
  console.log("middleware not")
  if (store.state.auth) {
    return redirect('/')
  }
}

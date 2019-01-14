export default function ({store, route}) {
  const loginPath = '/session/new'
  if (!store.getters.isLoggedIn && route.path != loginPath ){
    store.$router.push(loginPath)
  }
}

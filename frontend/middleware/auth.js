export default function ({store, route, redirect}) {
  const loginPath = '/session/new'
  if (!store.getters.isLoggedIn && route.path != loginPath ){
    redirect(loginPath)
  }
}

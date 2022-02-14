import Vue from 'vue'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify'
import { createProvider } from './vue-apollo'

Vue.prototype.$eventHub = new Vue()

Vue.config.productionTip = false

import VueTimeago from 'vue-timeago'
Vue.use(VueTimeago, { locale: 'en' })

import VueTooltip from 'v-tooltip'
Vue.use(VueTooltip)

import VueMatomo from 'vue-matomo'

Vue.use(VueMatomo, {
  host: 'https://speckle.matomo.cloud',
  siteId: 2,
  userId: localStorage.getItem('suuid')
})

export const bus = new Vue()

new Vue({
  router,
  vuetify,
  apolloProvider: createProvider(),
  render: (h) => h(App)
}).$mount('#app')

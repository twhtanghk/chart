import { createApp } from 'vue'
import App from './App.vue'
import router from './plugins/router.coffee'

createApp(App).use(router).mount('#app')

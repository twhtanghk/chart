import { createApp } from 'vue'
import App from './App.vue'
import {createWebHashHistory, createRouter} from 'vue-router'

var routes = [ {path: '/:type/:id', component: App} ]
var router = createRouter({history: createWebHashHistory(), routes: routes})
var app = createApp(App).use(router)
router.isReady().then(() => app.mount('#app'))

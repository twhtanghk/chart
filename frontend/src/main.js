import { createApp } from 'vue'
import App from './App.vue'
import candle from './candle.vue'
import breadth from './breadth.vue'
import {createWebHashHistory, createRouter} from 'vue-router'

var routes = [ 
  { path: '/breadth', component: breadth },
  { path: '/:type/:id/:granularity?', component: candle }
]
var router = createRouter({history: createWebHashHistory(), routes: routes})
createApp(App).use(router).mount('#app')

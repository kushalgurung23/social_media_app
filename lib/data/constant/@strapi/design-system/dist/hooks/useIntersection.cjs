"use strict";Object.defineProperty(exports,Symbol.toStringTag,{value:"Module"});const I=require("react"),d=require("@strapi/ui-primitives"),f=(t,s,{selectorToWatch:n,skipWhen:e=!1})=>{const r=d.useCallbackRef(s);I.useEffect(()=>{if(e||!t.current)return;const u={root:t.current,rootMargin:"0px"},g=v=>{v.forEach(o=>{o.isIntersecting&&t.current&&t.current.scrollHeight>t.current.clientHeight&&r(o)})},i=new IntersectionObserver(g,u),c=t.current.querySelector(n);return c&&i.observe(c),()=>{i.disconnect()}},[e,r,n,t])};exports.useIntersection=f;

"use strict";Object.defineProperty(exports,Symbol.toStringTag,{value:"Module"});const o=require("react/jsx-runtime"),l=require("react"),u=require("./PaginationContext.cjs"),d=require("../../Box/Box.cjs"),x=require("../../Flex/Flex.cjs");function g(e){if(e&&e.__esModule)return e;const n=Object.create(null,{[Symbol.toStringTag]:{value:"Module"}});if(e){for(const t in e)if(t!=="default"){const r=Object.getOwnPropertyDescriptor(e,t);Object.defineProperty(n,t,r.get?r:{enumerable:!0,get:()=>e[t]})}}return n.default=e,Object.freeze(n)}const i=g(l),f=({children:e,label:n="Pagination",activePage:t,pageCount:r})=>{const a=i.useMemo(()=>({activePage:t,pageCount:r}),[t,r]);return o.jsx(u.PaginationContext.Provider,{value:a,children:o.jsx(d.Box,{"aria-label":n,as:"nav",children:o.jsx(x.Flex,{as:"ol",gap:1,children:i.Children.map(e,(c,s)=>o.jsx("li",{children:c},s))})})})};exports.Pagination=f;

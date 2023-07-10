"use strict";Object.defineProperty(exports,Symbol.toStringTag,{value:"Module"});const e=require("react/jsx-runtime"),u=require("react"),x=require("./MainNavContext.cjs"),g=require("../Divider/Divider.cjs"),r=require("../Flex/Flex.cjs"),l=require("../Box/Box.cjs"),p=require("../VisuallyHidden/VisuallyHidden.cjs"),h=require("../Typography/Typography.cjs"),m=n=>n&&n.__esModule?n:{default:n},o=m(u),j=({label:n,children:a,spacing:d=2,horizontal:t=!1,...c})=>x.useMainNav()?e.jsxs(r.Flex,{direction:"column",alignItems:"stretch",gap:2,children:[e.jsxs(l.Box,{paddingTop:1,paddingBottom:1,background:"neutral0",hasRadius:!0,as:"span",children:[e.jsx(g.Divider,{}),e.jsx(p.VisuallyHidden,{children:e.jsx("span",{children:n})})]}),e.jsx(r.Flex,{as:"ul",gap:d,direction:t?"row":"column",alignItems:t?"center":"stretch",...c,children:o.default.Children.map(a,(i,s)=>e.jsx("li",{children:i},s))})]}):e.jsxs(r.Flex,{direction:"column",alignItems:"stretch",gap:2,children:[e.jsx(l.Box,{paddingTop:1,paddingBottom:1,background:"neutral0",paddingRight:3,paddingLeft:3,hasRadius:!0,as:"span",children:e.jsx(h.Typography,{variant:"sigma",textColor:"neutral600",children:n})}),e.jsx(r.Flex,{as:"ul",gap:d,direction:t?"row":"column",alignItems:t?"center":"stretch",...c,children:o.default.Children.map(a,(i,s)=>e.jsx("li",{children:i},s))})]});exports.NavSection=j;

(self.webpackChunk_strapi_admin=self.webpackChunk_strapi_admin||[]).push([[8155],{96594:function(E,h,t){"use strict";t.r(h),t.d(h,{default:function(){return ze}});var e=t(32735),u=t(96709),l=t(27649),x=t(82055),y=t(41415),T=t(17e3),Z=t(23866),v=t(19565),R=t(66456),k=t(92802),j=t(67879),Q=t(20108),i=t(15062),n=t(55433);function w(a,r){const o=(0,i.oR)();(0,e.useEffect)(()=>{o.injectReducer(a,r)},[o,a,r])}var s=t(61937);function S({status:a,data:r}){return{type:s.QM,payload:{status:a,workflows:r}}}function K(a){return{type:s.x4,payload:{stageId:a}}}function F(a={}){return{type:s.Ot,payload:a}}function I(a,r){return{type:s.Nj,payload:{stageId:a,...r}}}function B(a,r){return{type:s.$k,payload:{newIndex:r,oldIndex:a}}}var c=t(87933),P=t(49372),C=t(16899),X=t(60216),f=t.n(X),L=t(8471);const re=(0,L.ZP)(c.k)`
  svg path {
    fill: ${({theme:a})=>a.colors.neutral600};
  }
`;function oe({name:a}){return e.createElement(c.k,{background:"primary100",borderStyle:"dashed",borderColor:"primary600",borderWidth:"1px",gap:3,hasRadius:!0,padding:3,shadow:"tableShadow",width:(0,v.Q1)(300)},e.createElement(re,{alignItems:"center",background:"neutral200",borderRadius:"50%",height:6,justifyContent:"center",width:6},e.createElement(C.Z,{width:`${8/16}rem`})),e.createElement(P.Z,{fontWeight:"bold"},a))}oe.propTypes={name:f().string.isRequired};var W=t(72850),ne=t(86308);const Y=(0,L.ZP)(ne.Z)`
  > circle {
    fill: ${({theme:a})=>a.colors.neutral150};
  }
  > path {
    fill: ${({theme:a})=>a.colors.neutral600};
  }
`,ce=(0,L.ZP)(W.x)`
  border-radius: 26px;

  svg {
    height: ${({theme:a})=>a.spaces[6]};
    width: ${({theme:a})=>a.spaces[6]};

    > path {
      fill: ${({theme:a})=>a.colors.neutral600};
    }
  }

  &:hover {
    color: ${({theme:a})=>a.colors.primary600} !important;
    ${P.Z} {
      color: ${({theme:a})=>a.colors.primary600} !important;
    }

    ${Y} {
      > circle {
        fill: ${({theme:a})=>a.colors.primary600};
      }
      > path {
        fill: ${({theme:a})=>a.colors.neutral100};
      }
    }
  }

  &:active {
    ${P.Z} {
      color: ${({theme:a})=>a.colors.primary600};
    }

    ${Y} {
      > circle {
        fill: ${({theme:a})=>a.colors.primary600};
      }
      > path {
        fill: ${({theme:a})=>a.colors.neutral100};
      }
    }
  }
`;function se({children:a,...r}){return e.createElement(ce,{as:"button",background:"neutral0",border:"neutral150",paddingBottom:3,paddingLeft:4,paddingRight:4,paddingTop:3,shadow:"filterShadow",...r},e.createElement(c.k,{gap:2},e.createElement(Y,{"aria-hidden":!0}),e.createElement(P.Z,{variant:"pi",fontWeight:"bold",textColor:"neutral500"},a)))}se.propTypes={children:f().node.isRequired};var ue=t(3685),le=t(83828),ie=t(61762),J=t(50563),ke=t(89966),Ce=t(15335),ve=t(5803),be=t(10369),we=t(77035),De=t(4038),$e=t(47081),We=t(51968),Re=t(56327),Pe=t(51375),ge=t(54504);const Te=(0,ge.s)();function je(){return e.createElement(W.x,{background:"primary100",borderStyle:"dashed",borderColor:"primary600",borderWidth:"1px",display:"block",hasRadius:!0,padding:6,shadow:"tableShadow"})}function ye({id:a,index:r,canDelete:o,canReorder:b,isOpen:p=!1,stagesCount:m}){const d=g=>`${g+1} of ${m}`,M=g=>{z(D({id:"dnd.grab-item",defaultMessage:"{item}, grabbed. Current position in list: {position}. Press up and down arrow to change position, Spacebar to drop, Escape to cancel."},{item:$.value,position:d(g)}))},U=g=>{z(D({id:"dnd.drop-item",defaultMessage:"{item}, dropped. Final position in list: {position}."},{item:$.value,position:d(g)}))},pe=()=>{z(D({id:"dnd.cancel-item",defaultMessage:"{item}, dropped. Re-order cancelled."},{item:$.value}))},N=(g,ae)=>{z(D({id:"dnd.reorder",defaultMessage:"{item}, moved. New position in list: {position}."},{item:$.value,position:d(g)})),G(B(ae,g))},[de,z]=e.useState(null),{formatMessage:D}=(0,j.Z)(),{trackUsage:_}=(0,v.rS)(),G=(0,i.I0)(),[V,fe]=e.useState(p),[$,he]=(0,k.U$)(`stages.${r}.name`),[O,ee]=(0,k.U$)(`stages.${r}.color`),[{handlerId:A,isDragging:te,handleKeyDown:H},Ge,Ve,He,Se]=(0,Re.Y9)(b,{index:r,item:{name:$.value},onGrabItem:M,onDropItem:U,onMoveItem:N,onCancel:pe,type:s.uL.STAGE}),Qe=(0,Pe.FE)(Ge,Ve),Xe=Te.map(({hex:g,name:ae})=>({value:g,label:D({id:"Settings.review-workflows.stage.color.name",defaultMessage:"{name}"},{name:ae}),color:g}));e.useEffect(()=>{Se((0,We.rX)(),{captureDraggingState:!1})},[Se,r]);const{themeColorName:Ye}=O.value?(0,ge.k)(O.value):{};return e.createElement(W.x,{ref:Qe},de&&e.createElement(ue.T,{"aria-live":"assertive"},de),te?e.createElement(je,null):e.createElement(le.U,{size:"S",variant:"primary",onToggle:()=>{fe(!V),V||_("willEditStage")},expanded:V,shadow:"tableShadow"},e.createElement(ie.B,{title:$.value,togglePosition:"left",action:e.createElement(c.k,null,o&&e.createElement(J.h,{background:"transparent",icon:e.createElement(De.Z,null),label:D({id:"Settings.review-workflows.stage.delete",defaultMessage:"Delete stage"}),noBorder:!0,onClick:()=>G(K(a))}),e.createElement(J.h,{background:"transparent",forwardedAs:"div",role:"button",noBorder:!0,tabIndex:0,"data-handler-id":A,ref:He,label:D({id:"Settings.review-workflows.stage.drag",defaultMessage:"Drag"}),onClick:g=>g.stopPropagation(),onKeyDown:H},e.createElement($e.Z,null)))}),e.createElement(ke.v,{padding:6,background:"neutral0",hasRadius:!0},e.createElement(Ce.r,{gap:4},e.createElement(ve.P,{col:6},e.createElement(be.o,{...$,id:$.name,label:D({id:"Settings.review-workflows.stage.name.label",defaultMessage:"Stage name"}),error:he.error??!1,onChange:g=>{$.onChange(g),G(I(a,{name:g.target.value}))},required:!0})),e.createElement(ve.P,{col:6},e.createElement(we.q4,{error:ee?.error??!1,id:O.name,required:!0,label:D({id:"content-manager.reviewWorkflows.stage.color",defaultMessage:"Color"}),onChange:g=>{O.onChange({target:{value:g}}),G(I(a,{color:g}))},value:O.value.toUpperCase(),startIcon:e.createElement(c.k,{as:"span",height:2,background:O.value,borderColor:Ye==="neutral0"?"neutral150":"transparent",hasRadius:!0,shrink:0,width:2})},Xe.map(({value:g,label:ae,color:Me})=>{const{themeColorName:Je}=(0,ge.k)(Me);return e.createElement(we.ag,{value:g,key:g,startIcon:e.createElement(c.k,{as:"span",height:2,background:Me,borderColor:Je==="neutral0"?"neutral150":"transparent",hasRadius:!0,shrink:0,width:2})},ae)})))))))}ye.propTypes=f().shape({id:f().number.isRequired,color:f().string.isRequired,canDelete:f().bool.isRequired,canReorder:f().bool.isRequired,stagesCount:f().number.isRequired}).isRequired;const Ie=(0,L.ZP)(W.x)`
  position: relative;
`,Ae=(0,L.ZP)(W.x)`
  left: 50%;
  position: absolute;
  top: 0;
  transform: translateX(-50%);
`;function me({stages:a}){const{formatMessage:r}=(0,j.Z)(),o=(0,i.I0)(),{trackUsage:b}=(0,v.rS)();return e.createElement(c.k,{direction:"column",gap:6,width:"100%"},e.createElement(Ie,{spacing:4,width:"100%"},e.createElement(Ae,{background:"neutral200",height:"100%",width:2,zIndex:1}),e.createElement(c.k,{direction:"column",alignItems:"stretch",gap:6,zIndex:2,position:"relative",as:"ol"},a.map((p,m)=>{const d=p?.id??p.__temp_key__;return e.createElement(W.x,{key:`stage-${d}`,as:"li"},e.createElement(ye,{id:d,index:m,canDelete:a.length>1,isOpen:!p.id,canReorder:a.length>1,stagesCount:a.length}))}))),e.createElement(c.k,{direction:"column",gap:6},e.createElement(se,{type:"button",onClick:()=>{o(F({name:""})),b("willCreateStage")}},r({id:"Settings.review-workflows.stage.add",defaultMessage:"Add new stage"}))))}me.defaultProps={stages:[]},me.propTypes={stages:f().arrayOf(f().shape({id:f().number,__temp_key__:f().number,name:f().string.isRequired}))};var Oe=t(67350),xe=t(97889),Ze=t(89793),Be=t.n(Ze);const Ee={status:"loading",serverState:{currentWorkflow:null,workflows:[]},clientState:{currentWorkflow:{data:null,isDirty:!1,hasDeletedServerStages:!1}}};function Le(a=Ee,r){return(0,xe.Uy)(a,o=>{const{payload:b}=r;switch(r.type){case s.QM:{const{status:p,workflows:m}=b;if(o.status=p,m?.length>0){let d=m[0];d={...d,stages:d.stages.map(M=>({...M,color:M?.color??s.FT}))},o.serverState.workflows=m,o.serverState.currentWorkflow=d,o.clientState.currentWorkflow.data=d,o.clientState.currentWorkflow.hasDeletedServerStages=!1}break}case s.x4:{const{stageId:p}=b,{currentWorkflow:m}=a.clientState;o.clientState.currentWorkflow.data.stages=m.data.stages.filter(d=>(d?.id??d.__temp_key__)!==p),m.hasDeletedServerStages||(o.clientState.currentWorkflow.hasDeletedServerStages=!!a.serverState.currentWorkflow.stages.find(d=>d.id===p));break}case s.Ot:{const{currentWorkflow:p}=a.clientState;p.data||(o.clientState.currentWorkflow.data={stages:[]});const m=Ue(o.clientState.currentWorkflow.data.stages);o.clientState.currentWorkflow.data.stages.push({...b,color:b?.color??s.FT,__temp_key__:m});break}case s.Nj:{const{currentWorkflow:p}=a.clientState,{stageId:m,...d}=b;o.clientState.currentWorkflow.data.stages=p.data.stages.map(M=>(M.id??M.__temp_key__)===m?{...M,...d}:M);break}case s.$k:{const{currentWorkflow:{data:{stages:p}}}=a.clientState,{newIndex:m,oldIndex:d}=b;if(m>=0&&m<p.length){const M=p[d];let U=[...p];U.splice(d,1),U.splice(m,0,M),o.clientState.currentWorkflow.data.stages=U}break}default:break}a.clientState.currentWorkflow.data&&(o.clientState.currentWorkflow.isDirty=!Be()((0,xe.Vk)(o.clientState.currentWorkflow).data,o.serverState.currentWorkflow))})}const Ue=(a=[])=>{const r=a.map(o=>o.id??o.__temp_key__);return Math.max(...r,-1)+1};var q=t(24346);function Ke({formatMessage:a}){return q.Ry({stages:q.IX().of(q.Ry().shape({name:q.Z_().required(a({id:"Settings.review-workflows.validation.stage.name",defaultMessage:"Name is required"})).max(255,a({id:"Settings.review-workflows.validation.stage.max-length",defaultMessage:"Name can not be longer than 255 characters"})),color:q.Z_().required(a({id:"Settings.review-workflows.validation.stage.color",defaultMessage:"Color is required"})).matches(/^#(?:[0-9a-fA-F]{3}){1,2}$/i)}))})}function Fe({type:a,item:r}){switch(a){case s.uL.STAGE:return e.createElement(oe,{...r});default:return null}}function Ne(){const{trackUsage:a}=(0,v.rS)(),{formatMessage:r}=(0,j.Z)(),o=(0,i.I0)(),{put:b}=(0,v.kY)(),{formatAPIError:p}=(0,v.So)(),m=(0,v.lm)(),{workflows:d,status:M,refetch:U}=(0,Oe.n)(),{status:pe,clientState:{currentWorkflow:{data:N,isDirty:de,hasDeletedServerStages:z}}}=(0,i.v9)(A=>A?.[s.sN]??Ee),[D,_]=(0,e.useState)(!1),{mutateAsync:G,isLoading:V}=(0,Q.useMutation)(async({workflowId:A,stages:te})=>{const{data:{data:H}}=await b(`/admin/review-workflows/workflows/${A}/stages`,{data:te});return H},{onSuccess(){m({type:"success",message:{id:"notification.success.saved",defaultMessage:"Saved"}})}}),fe=async(A,te)=>{try{return await G({workflowId:A,stages:te})}catch(H){return m({type:"warning",message:p(H)}),null}},$=async()=>{await fe(N.id,N.stages),await U(),_(!1)},he=async()=>{await $()},O=()=>{_(A=>!A)},ee=(0,k.TA)({enableReinitialize:!0,initialValues:N,async onSubmit(){z?_(!0):$()},validationSchema:Ke({formatMessage:r}),validateOnChange:!1});return w(s.sN,Le),(0,e.useEffect)(()=>{o(S({status:M,data:d}))},[M,d,o]),(0,e.useEffect)(()=>{a("didViewWorkflow")},[]),e.createElement(u.A,null,e.createElement(v.SL,{name:r({id:"Settings.review-workflows.page.title",defaultMessage:"Review Workflows"})}),e.createElement(l.o,{tabIndex:-1},e.createElement(n.r,{renderItem:Fe}),e.createElement(k.Hy,{value:ee},e.createElement(k.l0,{onSubmit:ee.handleSubmit},e.createElement(x.T,{primaryAction:e.createElement(y.z,{startIcon:e.createElement(R.Z,null),type:"submit",size:"M",disabled:!de,loading:!D&&V},r({id:"global.save",defaultMessage:"Save"})),title:r({id:"Settings.review-workflows.page.title",defaultMessage:"Review Workflows"}),subtitle:r({id:"Settings.review-workflows.page.subtitle",defaultMessage:"{count, plural, one {# stage} other {# stages}}"},{count:N?.stages?.length??0})}),e.createElement(T.D,null,pe==="loading"&&e.createElement(Z.a,null,r({id:"Settings.review-workflows.page.isLoading",defaultMessage:"Workflow is loading"})),e.createElement(me,{stages:ee.values?.stages})))),e.createElement(v.QH,{bodyText:{id:"Settings.review-workflows.page.delete.confirm.body",defaultMessage:"All entries assigned to deleted stages will be moved to the previous stage. Are you sure you want to save?"},isConfirmButtonLoading:V,isOpen:D,onToggleDialog:O,onConfirm:he})))}var ze=Ne},51355:function(E,h,t){var e=t(94318),u=t(3387),l="[object Boolean]";function x(y){return y===!0||y===!1||u(y)&&e(y)==l}E.exports=x},95919:function(E,h,t){var e=t(80022);function u(l){return e(l)&&l!=+l}E.exports=u},80022:function(E,h,t){var e=t(94318),u=t(3387),l="[object Number]";function x(y){return typeof y=="number"||u(y)&&e(y)==l}E.exports=x},59578:function(E,h,t){var e=t(41119);function u(l){return e(l).toLowerCase()}E.exports=u},83828:function(E,h,t){"use strict";t.d(h,{U:function(){return Q},y:function(){return k}});var e=t(74512),u=t(32735),l=t(8471),x=t(91045),y=t(74971),T=t(49372),Z=t(87933),v=t(72850);const R=({theme:i,expanded:n,variant:w,disabled:s,error:S})=>S?`1px solid ${i.colors.danger600} !important`:s?`1px solid ${i.colors.neutral150}`:n?`1px solid ${i.colors.primary600}`:w==="primary"?`1px solid ${i.colors.neutral0}`:`1px solid ${i.colors.neutral100}`,k=(0,l.ZP)(T.Z)``,j=(0,l.ZP)(v.x)`
  border: ${R};

  &:hover:not([aria-disabled='true']) {
    border: 1px solid ${({theme:i})=>i.colors.primary600};

    ${k} {
      color: ${({theme:i,expanded:n})=>n?void 0:i.colors.primary700};
    }

    ${T.Z} {
      color: ${({theme:i,expanded:n})=>n?void 0:i.colors.primary600};
    }

    & > ${Z.k} {
      background: ${({theme:i})=>i.colors.primary100};
    }

    [data-strapi-dropdown='true'] {
      background: ${({theme:i})=>i.colors.primary200};
    }
  }
`,Q=({children:i,disabled:n=!1,error:w,expanded:s=!1,hasErrorMessage:S=!0,id:K,onToggle:F,toggle:I,size:B="M",variant:c="primary",shadow:P})=>{const C=(0,y.M)(K),X=u.useMemo(()=>({expanded:s,onToggle:F,toggle:I,id:C,size:B,variant:c,disabled:n}),[n,s,C,F,B,I,c]);return(0,e.jsxs)(x.S.Provider,{value:X,children:[(0,e.jsx)(j,{"data-strapi-expanded":s,disabled:n,"aria-disabled":n,expanded:s,hasRadius:!0,variant:c,error:w,shadow:P,children:i}),w&&S&&(0,e.jsx)(v.x,{paddingTop:1,children:(0,e.jsx)(T.Z,{variant:"pi",textColor:"danger600",children:w})})]})}},89966:function(E,h,t){"use strict";t.d(h,{v:function(){return x}});var e=t(74512),u=t(91045),l=t(72850);const x=({children:y,...T})=>{const{expanded:Z,id:v}=(0,u.A)();if(!Z)return null;const R=`accordion-content-${v}`,k=`accordion-label-${v}`,j=`accordion-desc-${v}`;return(0,e.jsx)(l.x,{role:"region",id:R,"aria-labelledby":k,"aria-describedby":j,...T,children:y})}},91045:function(E,h,t){"use strict";t.d(h,{A:function(){return l},S:function(){return u}});var e=t(32735);const u=(0,e.createContext)({disabled:!1,expanded:!1,id:"",size:"M",variant:"primary"}),l=()=>(0,e.useContext)(u)},61762:function(E,h,t){"use strict";t.d(h,{B:function(){return i}});var e=t(74512),u=t(16899),l=t(8471),x=t(83828),y=t(91045);const T=({expanded:n,disabled:w,variant:s})=>{let S="neutral100";return n?S="primary100":w?S="neutral150":s==="primary"&&(S="neutral0"),S};var Z=t(7563),v=t(99140),R=t(87933),k=t(49372);const j=(0,l.ZP)(Z.A)`
  text-align: left;

  // necessary to make the ellipsis prop work on the title
  > span {
    max-width: 100%;
  }

  svg {
    width: ${14/16}rem;
    height: ${14/16}rem;

    path {
      fill: ${({theme:n,expanded:w})=>w?n.colors.primary600:n.colors.neutral500};
    }
  }
`,Q=(0,l.ZP)(R.k)`
  min-height: ${({theme:n,size:w})=>n.sizes.accordions[w]};
  border-radius: ${({theme:n,expanded:w})=>w?`${n.borderRadius} ${n.borderRadius} 0 0`:n.borderRadius};

  &:hover {
    svg {
      path {
        fill: ${({theme:n})=>n.colors.primary600};
      }
    }
  }
`,i=({title:n,description:w,as:s="span",togglePosition:S="right",action:K,...F})=>{const{onToggle:I,toggle:B,expanded:c,id:P,size:C,variant:X,disabled:f}=(0,y.A)(),L=`accordion-content-${P}`,re=`accordion-label-${P}`,oe=`accordion-desc-${P}`,W=C==="M"?6:4,ne=C==="M"?W:W-2,Y=T({expanded:c,disabled:f,variant:X}),ce={as:s,fontWeight:C==="S"?"bold":void 0,id:re,textColor:c?"primary600":"neutral700",ellipsis:!0,variant:C==="M"?"delta":void 0},se=c?"primary600":"neutral600",ue=c?"primary200":"neutral200",le=C==="M"?`${32/16}rem`:`${24/16}rem`,ie=()=>{f||(B&&!I?(console.warn('Deprecation warning: Usage of "toggle" prop in Accordion component is deprecated. This is discouraged and will be removed in the next major release. Please use "onToggle" instead'),B()):I&&I())},J=(0,e.jsx)(R.k,{justifyContent:"center",borderRadius:"50%",height:le,width:le,transform:c?"rotate(180deg)":void 0,"data-strapi-dropdown":!0,"aria-hidden":!0,as:"span",background:ue,cursor:f?"not-allowed":"pointer",onClick:ie,shrink:0,children:(0,e.jsx)(v.J,{as:u.Z,width:C==="M"?`${11/16}rem`:`${8/16}rem`,color:c?"primary600":"neutral600"})});return(0,e.jsx)(Q,{paddingBottom:ne,paddingLeft:W,paddingRight:W,paddingTop:ne,background:Y,expanded:c,size:C,justifyContent:"space-between",cursor:f?"not-allowed":"",children:(0,e.jsxs)(R.k,{gap:3,flex:1,maxWidth:"100%",children:[S==="left"&&J,(0,e.jsx)(j,{onClick:ie,"aria-disabled":f,"aria-expanded":c,"aria-controls":L,"aria-labelledby":re,"data-strapi-accordion-toggle":!0,expanded:c,type:"button",flex:1,minWidth:0,...F,children:(0,e.jsxs)(e.Fragment,{children:[(0,e.jsx)(x.y,{...ce,children:n}),w&&(0,e.jsx)(k.Z,{as:"p",id:oe,textColor:se,children:w})]})}),S==="right"&&(0,e.jsxs)(R.k,{gap:3,children:[J,K]}),S==="left"&&K]})})}},47081:function(E,h,t){"use strict";t.d(h,{Z:function(){return l}});var e=t(74512);const u=x=>(0,e.jsxs)("svg",{xmlns:"http://www.w3.org/2000/svg",width:"1rem",height:"1rem",fill:"none",viewBox:"0 0 24 24",...x,children:[(0,e.jsx)("path",{fill:"#212134",d:"M16.563 5.587a2.503 2.503 0 1 0 0-5.007 2.503 2.503 0 0 0 0 5.007Z"}),(0,e.jsx)("path",{fill:"#212134",d:"M18.487 3.083c-.012.788-.487 1.513-1.229 1.797a1.954 1.954 0 0 1-2.184-.574A1.943 1.943 0 0 1 14.9 2.11c.4-.684 1.2-1.066 1.981-.927a1.954 1.954 0 0 1 1.606 1.9c.011.748 1.17.748 1.158 0A3.138 3.138 0 0 0 17.565.17c-1.176-.423-2.567-.03-3.36.933-.83 1.002-.968 2.45-.284 3.575.678 1.124 1.993 1.674 3.273 1.431 1.432-.272 2.428-1.593 2.451-3.019.012-.753-1.147-.753-1.158-.006ZM16.563 14.372a2.503 2.503 0 1 0 0-5.007 2.503 2.503 0 0 0 0 5.007Z"}),(0,e.jsx)("path",{fill:"#212134",d:"M18.487 11.867c-.012.789-.487 1.513-1.229 1.797a1.954 1.954 0 0 1-2.184-.574 1.943 1.943 0 0 1-.174-2.196c.4-.684 1.2-1.066 1.981-.927.928.156 1.588.968 1.606 1.9.011.748 1.17.748 1.158 0a3.138 3.138 0 0 0-2.08-2.914c-1.176-.423-2.567-.029-3.36.933-.83 1.002-.968 2.45-.284 3.575.678 1.124 1.993 1.675 3.273 1.431 1.432-.272 2.428-1.593 2.451-3.019.012-.753-1.147-.753-1.158-.005ZM16.563 23.392a2.503 2.503 0 1 0 0-5.006 2.503 2.503 0 0 0 0 5.006Z"}),(0,e.jsx)("path",{fill:"#212134",d:"M18.487 20.89c-.012.787-.487 1.512-1.229 1.796a1.954 1.954 0 0 1-2.184-.574 1.943 1.943 0 0 1-.174-2.196c.4-.684 1.2-1.066 1.981-.927.928.156 1.588.967 1.606 1.9.011.748 1.17.748 1.158 0a3.138 3.138 0 0 0-2.08-2.914c-1.176-.423-2.567-.03-3.36.933-.83 1.002-.968 2.45-.284 3.575.678 1.124 1.993 1.674 3.273 1.431 1.432-.272 2.428-1.593 2.451-3.019.012-.753-1.147-.753-1.158-.006ZM7.378 5.622a2.503 2.503 0 1 0 0-5.007 2.503 2.503 0 0 0 0 5.007Z"}),(0,e.jsx)("path",{fill:"#212134",d:"M9.302 3.119c-.011.788-.486 1.512-1.228 1.796a1.954 1.954 0 0 1-2.185-.574 1.943 1.943 0 0 1-.173-2.196c.4-.684 1.199-1.066 1.981-.927a1.943 1.943 0 0 1 1.605 1.9c.012.748 1.17.748 1.16 0A3.138 3.138 0 0 0 8.38.205c-1.176-.423-2.567-.029-3.36.933-.83 1.002-.968 2.45-.285 3.575.678 1.124 1.994 1.675 3.274 1.431 1.431-.272 2.428-1.593 2.451-3.019.012-.753-1.147-.753-1.159-.005ZM7.378 14.406a2.503 2.503 0 1 0 0-5.006 2.503 2.503 0 0 0 0 5.006Z"}),(0,e.jsx)("path",{fill:"#212134",d:"M9.302 11.902c-.011.788-.486 1.513-1.228 1.797a1.954 1.954 0 0 1-2.185-.574 1.943 1.943 0 0 1-.173-2.196c.4-.684 1.199-1.066 1.981-.927a1.943 1.943 0 0 1 1.605 1.9c.012.748 1.17.748 1.16 0A3.138 3.138 0 0 0 8.38 8.988c-1.176-.423-2.567-.03-3.36.933-.83 1.002-.968 2.45-.285 3.575.678 1.124 1.994 1.674 3.274 1.431 1.431-.272 2.428-1.593 2.451-3.019.012-.753-1.147-.753-1.159-.006ZM7.378 23.427a2.503 2.503 0 1 0 0-5.007 2.503 2.503 0 0 0 0 5.007Z"}),(0,e.jsx)("path",{fill:"#212134",d:"M9.302 20.924c-.011.788-.486 1.513-1.228 1.797a1.954 1.954 0 0 1-2.185-.574 1.943 1.943 0 0 1-.173-2.196c.4-.684 1.199-1.066 1.981-.927.933.156 1.594.967 1.605 1.9.012.748 1.17.748 1.16 0A3.139 3.139 0 0 0 8.38 18.01c-1.176-.423-2.567-.03-3.36.933-.83 1.002-.968 2.45-.285 3.569.678 1.124 1.994 1.675 3.274 1.431 1.431-.272 2.428-1.593 2.451-3.019.012-.747-1.147-.747-1.159 0Z"})]}),l=u},86308:function(E,h,t){"use strict";t.d(h,{Z:function(){return l}});var e=t(74512);const u=x=>(0,e.jsxs)("svg",{xmlns:"http://www.w3.org/2000/svg",width:"1rem",height:"1rem",fill:"none",viewBox:"0 0 24 24",...x,children:[(0,e.jsx)("circle",{cx:12,cy:12,r:12,fill:"#212134"}),(0,e.jsx)("path",{fill:"#F6F6F9",d:"M17 12.569c0 .124-.1.224-.225.224h-3.981v3.982c0 .124-.101.225-.226.225h-1.136a.225.225 0 0 1-.226-.225v-3.981H7.226A.225.225 0 0 1 7 12.567v-1.136c0-.125.1-.226.225-.226h3.982V7.226c0-.124.1-.225.224-.225h1.138c.124 0 .224.1.224.225v3.982h3.982c.124 0 .225.1.225.224v1.138Z"})]}),l=u}}]);

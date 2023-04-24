<div id="app">
  <h2>Nested Templates</h2> 

<table border="1">
 <thead>	
  <tr>
   <th>Day</th>
   <th>Hour</th>
   <th>Minutes</th> 
  </tr>
 </thead>
<tbody>
 <template v-for="(d, dIndx) in tbData.day">
   <template v-for="(hr, hIndx) in d.hour">
     <!--totalMin: {{d.totalMin}} - indx: {{indx}}-->
   <tr v-for="(m, mIndx) in hr.min">
    <td v-if="hIndx == 0 && mIndx == 0" v-bind:rowspan="d.totalMin">
     Day {{dIndx+1}} ({{d.totalMin}}) - indx: {{hIndx}} - mIndx: {{mIndx}} -{{hr.min.length}}
    </td>
    <td v-if="mIndx == 0" v-bind:rowspan="hr.min.length">{{hr.h}} {{hIndx}}</td>
    <td>{{mIndx}} {{m}}</td>
   </tr>
   </template> 
  </template>
 
</tbody>
</table>
 
</div>
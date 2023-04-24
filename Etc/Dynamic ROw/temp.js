var vm = new Vue({
  el: "#app",
  data: {
    tbData: {
      "day": [
        { totalMin: 0, 
         hour: 
         [ { "h": "Item A", "min": ["a-1", "a-2", "a-3","a-4"] }, 
           { "h": "Item B", "min": ["b-1", "b-2"] }, 
           { "h": "Item C", "min": ["c-1", "c-2"] }
         ] 
        },
        { totalMin: 0, 
         hour: 
         [ { "h": "Item D", "min": ["d-1", "d-2"] }, 
           { "h": "Item E", "min": ["e-1", "e-2"] }, 
           { "h": "Item F", "min": ["f-1", "f-2"] }
         ] 
        },
        { totalMin: 0, 
         hour: 
         [ { "h": "Item G", "min": ["g-1", "g-2"] }, 
           { "h": "Item H", "min": ["h-1", "h-2"] },  
           { "h": "Item I", "min": ["i-1", "i-2"] }, 
         ] 
        }
      ]      
    }
  },
  mounted: function() {

      var d = this.tbData;
      console.log(d);
      
      for(j=0; j < d.day.length; j++){
        for(i=0; i < d.day[j].hour.length; i++){ 
          d.day[j]["totalMin"] += d.day[j].hour[i].min.length;    
       }  
     }
  }
})
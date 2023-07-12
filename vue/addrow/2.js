<template>
  <div id="app">
    <!-- Your template code here -->
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue';
import accounting from 'accounting';

// Filters
const currencyDisplay = (val) => {
  if (val > 0) {
    return accounting.formatMoney(val, "$", 2, ".", ",");
  }
};

// Directives
const sortable = {
  mounted(el, { modifiers }) {
    const options = {
      draggable: Object.keys(modifiers)[0]
    };

    const sortableInstance = Sortable.create(el, options);

    sortableInstance.option("onUpdate", (e) => {
      value.splice(e.newIndex, 0, value.splice(e.oldIndex, 1)[0]);
    });
  }
};

// Data
const rows = reactive([
  { qty: 5, description: "Something", price: 55.20, tax: 10 },
  { qty: 2, description: "Something else", price: 1255.20, tax: 20 },
]);
const total = computed(() => {
  let t = 0;
  rows.forEach((e) => {
    t += accounting.unformat(e.total, ",");
  });
  return t;
});
const taxtotal = computed(() => {
  let tt = 0;
  rows.forEach((e) => {
    tt += accounting.unformat(e.tax_amount, ",");
  });
  return tt;
});

// Methods
const addRow = (index) => {
  try {
    rows.splice(index + 1, 0, {});
  } catch (e) {
    console.log(e);
  }
};
const removeRow = (index) => {
  rows.splice(index, 1);
};
const getData = () => {
  $.ajax({
    context: this,
    type: "POST",
    data: {
      rows: rows,
      total: total,
      delivery: delivery,
      taxtotal: taxtotal,
      grandtotal: grandtotal,
    },
    url: "/api/data",
  });
};
</script>

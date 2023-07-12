import { createApp } from 'vue';
import accounting from 'accounting';

const app = createApp({
  data() {
    return {
      rows: [
        // initial data
        { qty: 5, description: "Something", price: 55.20, tax: 10 },
        { qty: 2, description: "Something else", price: 1255.20, tax: 20 },
      ],
      total: 0,
      grandtotal: 0,
      taxtotal: 0,
      delivery: 40,
    };
  },
  computed: {
    computedTotal() {
      let t = 0;
      this.rows.forEach((e) => {
        t += accounting.unformat(e.total, ",");
      });
      return t;
    },
    computedTaxTotal() {
      let tt = 0;
      this.rows.forEach((e) => {
        tt += accounting.unformat(e.tax_amount, ",");
      });
      return tt;
    },
  },
  methods: {
    addRow(index) {
      try {
        this.rows.splice(index + 1, 0, {});
      } catch (e) {
        console.log(e);
      }
    },
    removeRow(index) {
      this.rows.splice(index, 1);
    },
    getData() {
      fetch("/api/data", {
        method: "POST",
        body: JSON.stringify({
          rows: this.rows,
          total: this.total,
          delivery: this.delivery,
          taxtotal: this.taxtotal,
          grandtotal: this.grandtotal,
        }),
      });
    },
  },
});

app.config.globalProperties.$filters = {
  currencyDisplay(val) {
    if (val > 0) {
      return accounting.formatMoney(val, "$", 2, ".", ",");
    }
  },
};

app.directive('sortable', {
  mounted(el, binding) {
    const options = {
      draggable: Object.keys(binding.modifiers)[0],
      onUpdate: (e) => {
        binding.value.splice(e.newIndex, 0, binding.value.splice(e.oldIndex, 1)[0]);
      },
    };

    const sortable = Sortable.create(el, options);
    console.log('sortable bound!');

    binding.instance.onUpdate = (value) => {
      binding.value = value;
    };
  },
  updated(el, binding) {
    binding.instance.onUpdate(binding.value);
  },
});

app.mount('#app');

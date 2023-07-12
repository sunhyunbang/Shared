<template>
  <div class="panel-body" id="app">
    <table class="table table-hover">
      <thead>
        <tr>
          <th style="width: 20px;">No.</th>
          <th>Description</th>
          <th style="width: 80px;">Qty</th>
          <th style="width: 130px;" class="text-right">Price</th>
          <th style="width: 90px;">Tax</th>
          <th style="width: 130px;">Total</th>
          <th style="width: 130px;"></th>
        </tr>
      </thead>
      <tbody v-sortable.tr="rows">
        <tr v-for="(row, index) in rows" :key="index">
          <td>{{ index + 1 }}</td>
          <td><input class="form-control" v-model="row.description" /></td>
          <td><input class="form-control" v-model.number="row.qty" /></td>
          <td>
            <input
              class="form-control text-right"
              v-model.number="row.price"
              data-type="currency"
            />
          </td>
          <td>
            <select class="form-control" v-model.number="row.tax">
              <option value="0">0%</option>
              <option value="10">10%</option>
              <option value="20">20%</option>
            </select>
          </td>
          <td>
            <input
              class="form-control text-right"
              :value="calculateTotal(row)"
              v-model="row.total"
              readonly
            />
            <input
              type="hidden"
              :value="row.qty * row.price * row.tax / 100"
              v-model="row.tax_amount"
            />
          </td>
          <td>
            <button class="btn btn-primary btn-xs" @click="addRow(index)">add row</button>
            <button class="btn btn-danger btn-xs" @click="removeRow(index)">remove row</button>
          </td>
        </tr>
      </tbody>
      <tfoot>
        <tr>
          <td colspan="5" class="text-right">TAX</td>
          <td colspan="1" class="text-right">{{ taxtotal | currencyDisplay }}</td>
          <td></td>
        </tr>
        <tr>
          <td colspan="5" class="text-right">TOTAL</td>
          <td colspan="1" class="text-right">{{ total | currencyDisplay }}</td>
          <td></td>
        </tr>
        <tr>
          <td colspan="5" class="text-right">DELIVERY</td>
          <td colspan="1" class="text-right">
            <input class="form-control text-right" v-model.number="delivery" />
          </td>
          <td></td>
        </tr>
        <tr>
          <td colspan="5" class="text-right"><strong>GRANDTOTAL</strong></td>
          <td colspan="1" class="text-right"><strong>{{ grandtotal | currencyDisplay }}</strong></td>
          <td></td>
        </tr>
      </tfoot>
    </table>
    <button @click="getData()">SUBMIT DATA</button>
    <pre>{{ JSON.stringify($data) }}</pre>
  </div>
</template>

<script setup>
import { ref, computed, watch } from 'vue';
import Sortable from 'sortablejs';

const rows = ref([
  { qty: 5, description: 'Something', price: 55.20, tax: 10 },
  { qty: 2, description: 'Something else', price: 1255.20, tax: 20 },
]);

const total = computed(() => {
  return rows.value.reduce((acc, row) => acc + (row.total || 0), 0);
});

const taxtotal = computed(() => {
  return rows.value.reduce((acc, row) => acc + (row.tax_amount || 0), 0);
});

const delivery = ref(40);

const grandtotal = computed(() => {
  return total.value + delivery.value;
});

const calculateTotal = (row) => {
  if (row.qty && row.price) {
    return (row.qty * row.price).toFixed(2);
  }
  return '';
};

const addRow = (index) => {
  rows.value.splice(index + 1, 0, {});
};

const removeRow = (index) => {
  rows.value.splice(index, 1);
};

const getData = () => {
  const data = {
    rows: rows.value,
    total: total.value,
    delivery: delivery.value,
    taxtotal: taxtotal.value,
    grandtotal: grandtotal.value,
  };
  console.log(data);
  // Perform AJAX request with data
};

watch(rows, () => {
  // Reinitialize sortable when rows change
  Vue.nextTick(() => {
    const el = document.querySelector('.table tbody');
    Sortable.create(el, {
      draggable: 'tr',
      onUpdate: (evt) => {
        const movedRow = rows.value.splice(evt.oldIndex, 1)[0];
        rows.value.splice(evt.newIndex, 0, movedRow);
      },
    });
  });
});
</script>

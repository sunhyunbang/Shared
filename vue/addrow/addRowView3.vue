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
      <tbody v-sortable:draggable="rows">
        <tr v-for="(row, index) in rows" :key="index">
          <td>{{ index + 1 }}</td>
          <td>
            <input class="form-control" v-model="row.description" />
          </td>
          <td>
            <input class="form-control" v-model="row.qty" type="number" />
          </td>
          <td>
            <input
              class="form-control text-right"
              v-model="row.price"
              type="number"
              step="0.01"
            />
          </td>
          <td>
            <select class="form-control" v-model="row.tax">
              <option value="0">0%</option>
              <option value="10">10%</option>
              <option value="20">20%</option>
            </select>
          </td>
          <td>
            <input
              class="form-control text-right"
              :value="row.qty * row.price"
              readonly
            />
            <input
              type="hidden"
              :value="(row.qty * row.price * row.tax) / 100"
            />
          </td>
          <td>
            <button class="btn btn-primary btn-xs" @click="addRow(index)">
              add row
            </button>
            <button class="btn btn-danger btn-xs" @click="removeRow(index)">
              remove row
            </button>
          </td>
        </tr>
      </tbody>
      <tfoot>
        <tr>
          <td colspan="5" class="text-right">TAX</td>
          <td colspan="1" class="text-right">{{ computedTaxTotal }}</td>
          <td></td>
        </tr>
        <tr>
          <td colspan="5" class="text-right">TOTAL</td>
          <td colspan="1" class="text-right">{{ computedTotal }}</td>
          <td></td>
        </tr>
        <tr>
          <td colspan="5" class="text-right">DELIVERY</td>
          <td colspan="1" class="text-right">
            <input class="form-control text-right" v-model="delivery" type="number" />
          </td>
          <td></td>
        </tr>
        <tr>
          <td colspan="5" class="text-right"><strong>GRANDTOTAL</strong></td>
          <td colspan="1" class="text-right">
            <strong>{{ computedTotal + delivery }}</strong>
          </td>
          <td></td>
        </tr>
      </tfoot>
    </table>
    <button @click="getData()">SUBMIT DATA</button>
    <pre>{{ JSON.stringify($data) }}</pre>
  </div>
</template>

<script setup>
import { ref } from 'vue';
import Sortable from 'sortablejs';

const rows = ref([
  { qty: 5, description: 'Something', price: 55.20, tax: 10 },
  { qty: 2, description: 'Something else', price: 1255.20, tax: 20 },
]);
const total = ref(0);
const grandtotal = ref(0);
const taxtotal = ref(0);
const delivery = ref(40);

const computedTotal = computed(() => {
  return rows.value.reduce((acc, row) => acc + row.total, 0);
});

const computedTaxTotal = computed(() => {
  return rows.value.reduce((acc, row) => acc + row.tax_amount, 0);
});

const addRow = (index) => {
  rows.value.splice(index + 1, 0, {});
};

const removeRow = (index) => {
  rows.value.splice(index, 1);
};

const getData = () => {
  fetch('/api/data', {
    method: 'POST',
    body: JSON.stringify({
      rows: rows.value,
      total: total.value,
      delivery: delivery.value,
      taxtotal: taxtotal.value,
      grandtotal: grandtotal.value,
    }),
    headers: {
      'Content-Type': 'application/json',
    },
  });
};

const sortableOptions = {
  draggable: 'tr',
};

onMounted(() => {
  const sortable = Sortable.create($refs.table, sortableOptions);
  sortable.option('onUpdate', (e) => {
    const item = rows.value.splice(e.oldIndex, 1)[0];
    rows.value.splice(e.newIndex, 0, item);
  });
});
</script>

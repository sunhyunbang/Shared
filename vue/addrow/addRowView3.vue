<template>
  <div class="panel-body">
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
          <td>
            <input class="form-control" v-model="row.description" />
          </td>
          <td>
            <input class="form-control" v-model.number="row.qty" />
          </td>
          <td>
            <input class="form-control text-right" v-model.number="row.price" />
          </td>
          <td>
            <select class="form-control" v-model="row.tax">
              <option value="0">0%</option>
              <option value="10">10%</option>
              <option value="20">20%</option>
            </select>
          </td>
          <td>
            <input class="form-control text-right" :value="calculateTotal(row)" readonly />
            <input type="hidden" :value="calculateTaxAmount(row)" />
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
          <td colspan="1" class="text-right">{{ taxTotal }}</td>
          <td></td>
        </tr>
        <tr>
          <td colspan="5" class="text-right">TOTAL</td>
          <td colspan="1" class="text-right">{{ total }}</td>
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
          <td colspan="1" class="text-right"><strong>{{ grandTotal }}</strong></td>
          <td></td>
        </tr>
      </tfoot>
    </table>
    <button @click="getData()">SUBMIT DATA</button>
    <pre>{{ JSON.stringify(data, null, 2) }}</pre>
  </div>
</template>

<script>
import { ref, reactive, computed } from 'vue';
import Sortable from 'sortablejs';

export default {
  name: 'App',
  setup() {
    const rows = reactive([
      { qty: 5, description: 'Something', price: 55.20, tax: 10 },
      { qty: 2, description: 'Something else', price: 1255.20, tax: 20 },
    ]);

    const delivery = ref(40);

    const calculateTotal = (row) => {
      return (row.qty * row.price).toFixed(2);
    };

    const calculateTaxAmount = (row) => {
      return ((row.qty * row.price * row.tax) / 100).toFixed(2);
    };

    const total = computed(() => {
      return rows.reduce((acc, row) => acc + parseFloat(calculateTotal(row)), 0).toFixed(2);
    });

    const taxTotal = computed(() => {
      return rows.reduce((acc, row) => acc + parseFloat(calculateTaxAmount(row)), 0).toFixed(2);
    });

    const grandTotal = computed(() => {
      return (parseFloat(total.value) + parseFloat(delivery.value)).toFixed(2);
    });

    const addRow = (index) => {
      rows.splice(index + 1, 0, {});
    };

    const removeRow = (index) => {
      rows.splice(index, 1);
    };

    const getData = () => {
      const data = {
        rows,
        total: total.value,
        delivery: delivery.value,
        taxtotal: taxTotal.value,
        grandtotal: grandTotal.value,
      };
      // Perform AJAX request or further processing
      console.log(data);
    };

    const sortableOptions = {
      draggable: 'tr',
      onUpdate: (event) => {
        const movedItem = rows.splice(event.oldIndex, 1)[0];
        rows.splice(event.newIndex, 0, movedItem);
      },
    };

    const sortableRef = ref(null);

    const sortableInit = () => {
      if (sortableRef.value) {
        Sortable.create(sortableRef.value, sortableOptions);
      }
    };

    return {
      rows,
      delivery,
      total,
      taxTotal,
      grandTotal,
      addRow,
      removeRow,
      getData,
      calculateTotal,
      calculateTaxAmount,
      sortableRef,
      sortableInit,
    };
  },
  mounted() {
    this.sortableInit();
  },
};
</script>

<style>
/* Add your styles here */
</style>

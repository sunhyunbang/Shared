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
      <tbody>
        <tr v-for="(row, index) in rows" :key="index">
          <td>{{ index + 1 }}</td>
          <td>
            <input class="form-control" v-model="row.description" />
          </td>
          <td>
            <input class="form-control" v-model.number="row.qty" />
          </td>
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
              :value="row.qty * row.price"
              v-model.number="row.total"
              readonly
            />
            <input
              type="hidden"
              :value="row.qty * row.price * row.tax / 100"
              v-model.number="row.tax_amount"
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
            <input
              class="form-control text-right"
              v-model.number="delivery"
            />
          </td>
          <td></td>
        </tr>
        <tr>
          <td colspan="5" class="text-right"><strong>GRANDTOTAL</strong></td>
          <td colspan="1" class="text-right">
            <strong>{{ grandTotal }}</strong>
          </td>
          <td></td>
        </tr>
      </tfoot>
    </table>
    <button @click="submitData">SUBMIT DATA</button>
    <pre>{{ JSON.stringify(data) }}</pre>
  </div>
</template>

<script>
import { ref, computed } from 'vue';

export default {
  name: 'App',
  setup() {
    const rows = ref([
      { qty: 5, description: 'Something', price: 55.2, tax: 10 },
      { qty: 2, description: 'Something else', price: 1255.2, tax: 20 },
    ]);

    const total = computed(() => {
      return rows.value.reduce((acc, row) => {
        return acc + row.qty * row.price;
      }, 0);
    });

    const taxTotal = computed(() => {
      return rows.value.reduce((acc, row) => {
        return acc + (row.qty * row.price * row.tax) / 100;
      }, 0);
    });

    const delivery = ref(40);

    const grandTotal = computed(() => {
      return total.value + delivery.value;
    });

    const addRow = (index) => {
      rows.value.splice(index + 1, 0, {});
    };

    const removeRow = (index) => {
      rows.value.splice(index, 1);
    };

    const submitData = () => {
      const data = {
        rows: rows.value,
        total: total.value,
        delivery: delivery.value,
        taxTotal: taxTotal.value,
        grandTotal: grandTotal.value,
      };

      console.log(data);
      // Make the AJAX call or perform any necessary actions with the data
    };

    return {
      rows,
      total,
      taxTotal,
      delivery,
      grandTotal,
      addRow,
      removeRow,
      submitData,
    };
  },
};
</script>

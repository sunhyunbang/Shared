<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>Vue 3 App</title>
  <script src="https://unpkg.com/vue@next"></script>
  <script src="https://cdn.jsdelivr.net/npm/sortablejs@latest/Sortable.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/accounting@latest/accounting.min.js"></script>
</head>

<body>
  <div id="app">
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
      <tbody v-sortable:rows="rows">
        <tr v-for="(row, index) in rows" :key="index">
          <td>{{ index + 1 }}</td>
          <td><input class="form-control" v-model="row.description" /></td>
          <td><input class="form-control" v-model.number="row.qty" /></td>
          <td>
            <input class="form-control text-right" v-model.number="row.price" @input="calculateTotal(row)" />
          </td>
          <td>
            <select class="form-control" v-model.number="row.tax" @change="calculateTotal(row)">
              <option value="0">0%</option>
              <option value="10">10%</option>
              <option value="20">20%</option>
            </select>
          </td>
          <td>
            <input class="form-control text-right" :value="calculateRowTotal(row)" readonly />
            <input type="hidden" :value="calculateTaxAmount(row)" />
          </td>
          <td>
            <button class="btn btn-primary btn-xs" @click="addRow(index)">Add Row</button>
            <button class="btn btn-danger btn-xs" @click="removeRow(index)">Remove Row</button>
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
    <pre>{{ $data | json }}</pre>
  </div>

  <script>
    const { createApp, ref } = Vue;

    createApp({
      setup() {
        const rows = ref([
          { qty: 5, description: "Something", price: 55.20, tax: 10 },
          { qty: 2, description: "Something else", price: 1255.20, tax: 20 },
        ]);

        const total = ref(0);
        const grandTotal = ref(0);
        const taxTotal = ref(0);
        const delivery = ref(40);

        const addRow = (index) => {
          rows.splice(index + 1, 0, {});
        };

        const removeRow = (index) => {
          rows.splice(index, 1);
        };

        const calculateRowTotal = (row) => {
          const total = row.qty * row.price;
          const taxAmount = total * row.tax / 100;
          return accounting.formatMoney(total, "$", 2, ".", ",");
        };

        const calculateTaxAmount = (row) => {
          const total = row.qty * row.price;
          return accounting.formatMoney(total * row.tax / 100, "$", 2, ".", ",");
        };

        const calculateTotal = (row) => {
          total.value = rows.reduce((sum, current) => {
            return sum + current.qty * current.price;
          }, 0);
          taxTotal.value = rows.reduce((sum, current) => {
            return sum + (current.qty * current.price * current.tax) / 100;
          }, 0);
          grandTotal.value = total.value + delivery.value;
        };

        const getData = () => {
          const formattedRows = rows.map((row) => {
            return {
              qty: row.qty,
              description: row.description,
              price: row.price,
              tax: row.tax,
              total: row.qty * row.price,
              taxAmount: row.qty * row.price * row.tax / 100,
            };
          });

          const data = {
            rows: formattedRows,
            total: total.value,
            delivery: delivery.value,
            taxTotal: taxTotal.value,
            grandTotal: grandTotal.value,
          };

          console.log(data);

          // Send the data to the API using AJAX
        };

        return {
          rows,
          total,
          grandTotal,
          taxTotal,
          delivery,
          addRow,
          removeRow,
          calculateRowTotal,
          calculateTaxAmount,
          calculateTotal,
          getData,
        };
      },
    }).mount("#app");
  </script>
</body>

</html>

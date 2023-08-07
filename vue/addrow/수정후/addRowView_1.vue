
<!--  <draggable
      :list="items"
      :disabled="!enabled"
      class="list-group"
      ghost-class="ghost"
      @start="dragging = true"
      @end="dragging = false"
  >
    <template #item="{ element }">
      <v-row class="list-group-item bg-grey-lighten-4 rounded-0 pa-0" style="cursor: pointer">
        <v-col>
          {{ element.id }}
        </v-col>
        <v-col>
          {{ element.text }}
        </v-col>
      </v-row>
    </template>
  </draggable>-->


<template>
  <div class="panel-body" id="app">
    <table class="table table-hover">
      <thead>
      <tr>
        <th style="width: 20%;">No.</th>
        <th style="width: 80%;">Description</th>
        <th style="width: 130px;"></th>
      </tr>
      </thead>
      <tbody>
      <draggable
          :list="items"
          :disabled="!enabled"
          class="list-group"
          ghost-class="ghost"
          @start="dragging = true"
          @end="dragging = false"
      >
        <template #item="{ element , index }">
          <tr>
            <td><input class="form-control" v-model="element.id"/></td>
            <td><input class="form-control" v-model.number="element.text"/></td>
            <td>
              <button class="btn btn-primary btn-xs" @click="addRow(index)">add row</button>
              <button class="btn btn-danger btn-xs" @click="removeRow(index)">remove row</button>
            </td>
          </tr>
        </template>
      </draggable>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import draggable from "vue3-draggable-next";
import {ref} from "vue";


const items = ref([
  {id : 1 , text : 'Item 1'},
  {id : 2 , text : 'Item 2'},
  {id : 3 , text : 'Item 3'}
]);

let enabled = ref(true); // 드래그 사용 여부
let dragging = ref(false); // 드래그 여부

const addRow = (index) => {
  items.value.splice(index + 1, 0, {});
};

const removeRow = (index) => {
  items.value.splice(index, 1);
};
</script>

<style scoped>

</style>

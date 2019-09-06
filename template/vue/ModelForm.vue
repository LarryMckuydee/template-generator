<template>
    <div id="modelName">

        <! -- LabelName -->
        <div class="form-group">
                <label for="modelNameColumnName">LabelName</label>
                <input 
                        type="text" 
                        v-model="model_name.column_name" 
                        class="form-control" 
                         id="modelNameColumnName"
                />
        </div> 

        <!-- LabelName -->
        <div class="form-group">
                <label for="modelNameColumnName">LabelName</label>
                <select
                        id="modelNameColumnName"
                        class="form-control"
                        v-model="model_name.column_name"
                        v-if="refers.length > 0"
                >
                        <option v-for="{ id, name } in refers" :value="id">{{ name }}</option>
                </select>
        </div>

        <!-- LabelName -->
        <label>LabelName</label>
        <div class="form-check">
                <input class="form-check-input" type="radio" id="modelNameColumnName" value="radiovalue" v-model="model_name.column_name">
                <label class="form-check-label" for="modelNameColumnName">Radiovalue</label>
        </div>
        <br>
        <span>Picked: {{ model_name.column_name }}</span>

        <!-- LabelName -->
        <div class="form-check">
          <input class="form-check-input" type="checkbox" value="checkboxvalue" id="modelNameColumnName" v-model="model_name.column_name">
          <label class="form-check-label" for="modelNameColumnName">
                LabelName  
          </label>
        </div>

        <!-- LabelName -->
        <div class="form-group">
                <label for="modelNameColumnName">LabelName</label>
                <textarea v-model="model_name.column_name" class="form-control" rows="3" cols="30" placeholder="Write your labelName here..." id="modelNameColumnName"></textarea>
        </div>
    </div>
</template>
<script charset="utf-8">
import api from "../api/apifilename" 

export default {
    data() {
        return {
            model_name: {
                column_name: null,    
            },
            refers: [],
        }
    },

    methods: {
         onSubmit(event) {
             let config = {
                header: {
                    'Content-Type': 'application/json'
                }
             }

             let payload = {

             }

             api.update(this.$route.params.id, payload, config)
                 .then(response => {
                    console.log(response)
                 })
                 .catch(error => {
                    console.error(error)
                 })
         },
    },

    created() {
        api.find(this.$route.params.id).then(response => {
            this.model_name = response.data.data;
        });
    },
}
</script>
<style lang="scss" scoped>
$red: lighten(red, 30%);
$darkRed: darken($red, 50%);

.form-group label {
    display: block;
}

.alert {
    background: $red;
    color: $darkRed;
    padding: 1rem;
    margin-bottom: 1rem;
    width: 50%;
    border: 1px solid $darkRed;
    border-radius: 5px;
}
</style>

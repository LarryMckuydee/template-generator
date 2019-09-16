module Generator
    module Vue
        module Component
            # currently not support array input eg: countries[]
            extend self
            def generate(dir, args)
                # ruby main.rb scaffold Model column:type:form_type
                model, *args = args

                modelName = "#{model.camelize(:lower)}"
                model_name = "#{model.underscore}"
                
                route_filename = model.underscore.pluralize

                data =
                    File.read(
                        "#{Dir.getwd}/template/vue/ModelForm.stub"
                    )
                filename = "#{model.pluralize}Form.vue"

                replaced_data = data.gsub 'modelName', modelName
                replaced_data = replaced_data.gsub 'apifilename', route_filename
                replaced_data = replaced_data.gsub 'model_name', model_name

                body_content = ''
                payload_content = ''
                payload_content << "                _method: 'PUT',\n"
                model_content = "            #{model_name}: {\n"
                refers_content = ''

                args.each do |arg|
                    #split column:type:form_type
                    variable = arg.split ':'
                    column, column_type, form_type, *args = variable 

                    next if form_type.nil?

                    vue_form = VueForm.new
                    body_content.concat vue_form.assign_form_input(model, column, form_type, args)
                    body_content.concat "\n"
                    
                    payload_content.concat vue_form.assign_payload(model, column)
                    payload_content.concat "\n"

                    model_content.concat vue_form.assign_model(model, column, form_type, args)
                    model_content.concat "\n"
                    if form_type == "select"
                        refers_content.concat "            #{args[0]}: [],\n"
                    end
                end

                model_content.concat "            },"

                replaced_data = replaced_data.gsub 'BODYCONTENT', body_content
                replaced_data = replaced_data.gsub 'PAYLOAD', payload_content
                replaced_data = replaced_data.gsub 'MODELS', model_content
                replaced_data = replaced_data.gsub 'REFERS', refers_content

                open(dir + '/resources/js/components/' + filename, 'w') { |f|  
                    f.write replaced_data  
                }
                puts "Vue form generate complete. #{filename}"
            end

            def foo
                puts 'PascalCase'.underscore
            end

            class VueForm
                def assign_form_input(model, column, form_type, additional_args)
                    modelName = "#{model.camelize(:lower)}"
                    model_name = "#{model.underscore}"
                    columnName = "#{column.camelize(:lower)}"
                    column_name = "#{column.underscore}"
                    labelName = "#{column.underscore.split('_').collect {|c| c.capitalize}.join(' ')}"

                    case form_type
                    when "text"
                        FormInputType.text_input(model_name, modelName, column_name, columnName, labelName)
                    when "date"
                        FormInputType.date_input(model_name, modelName, column_name, columnName, labelName)
                    when "select"
                        # ruby main.rb scaffold Model column:type:form_type:refers
                        FormInputType.select(model_name, modelName, column_name, columnName, labelName, additional_args)
                    when "radio"
                        # ruby main.rb scaffold Model column:type:form_type:radio_value1,radio_label1:radio_value2,radio_label2
                        FormInputType.radio(model_name, modelName, column_name, columnName, labelName, additional_args)
                    when "checkbox"
                        # ruby main.rb scaffold Model column:type:form_type:checkbox_value1,checkbox_label1:checkbox_value2,checkbox_label2
                        FormInputType.checkbox(model_name, modelName, column_name, columnName, labelName, additional_args)
                    when "textarea"
                        # ruby main.rb scaffold Model column:type:form_type
                        FormInputType.textarea(model_name, modelName, column_name, columnName, labelName)
                    else
                        raise 'FormInputType keyed in is not supported.'
                    end
                end

                def assign_payload(model, column)
                    model_name = "#{model.underscore}"
                    column_name = "#{column.underscore}"

                    return "                #{column_name}: this.#{model_name}.#{column_name},"
                end

                def assign_model(model, column, form_type, additional_args)
                    modelName = "#{model.camelize(:lower)}"
                    model_name = "#{model.underscore}"
                    columnName = "#{column.camelize(:lower)}"
                    column_name = "#{column.underscore}"

                    return "                #{column_name}: null,"
                end

                class FormInputType
                    class << self
                    def text_input(model_name, modelName, column_name, columnName, labelName)
                        return <<-HTML
        <!-- #{labelName} -->
        <div class="form-group">
                <label for="#{modelName}#{columnName.camelize}">#{labelName}</label>
                <input 
                        type="text" 
                        v-model="#{model_name}.#{column_name}" 
                        class="form-control" 
                         id="#{modelName}#{columnName.camelize}"
                />
        </div> 
											HTML
                    end

                    def date_input(model_name, modelName, column_name, columnName, labelName)
                        return <<-HTML
        <!-- #{labelName} -->
        <div class="form-group">
                <label for="#{modelName}#{columnName.camelize}">#{labelName}</label>
                <input 
                        type="date" 
                        v-model="#{model_name}.#{column_name}" 
                        class="form-control" 
                         id="#{modelName}#{columnName.camelize}"
                />
        </div> 
											HTML
                    end

										def select(model_name, modelName, column_name, columnName, labelName, refers)
                        refers = refers[0]
											  return <<-HTML
        <!-- #{labelName} -->
        <div class="form-group">
                <label for="#{modelName}#{columnName.camelize}">#{labelName}</label>
                <select
                        id="#{modelName}#{columnName.camelize}"
                        class="form-control"
                        v-model="#{model_name}.#{column_name}"
                        v-if="#{refers}.length > 0"
                >
                        <option v-for="{ id, name } in #{refers}" :value="id">{{ name }}</option>
                </select>
        </div>
											  HTML
										end 

										def radio(model_name, modelName, column_name, columnName, labelName, values)

												data = <<-HTML
        <!-- #{labelName} -->
        <label>#{labelName}</label>
												HTML

                        values.each do |value|
                            get_value = value.split ','
                            radio_value = get_value[0]
                            radio_label = get_value[1]

                            data << <<-HTML
        <div class="form-check">
                <input class="form-check-input" type="radio" id="#{modelName}#{columnName.camelize}#{radio_label.camelize.delete(' ')}" value="#{radio_value}" v-model="#{model_name}.#{column_name}">
                <label class="form-check-label" for="#{modelName}#{columnName.camelize}#{radio_label.camelize.delete(' ')}">#{radio_label}</label>
        </div>
                            HTML
                        end

                        data << <<-HTML
        <br>
        <span>Picked: {{ #{model_name}.#{column_name} }}</span>
                        HTML

                        return data
										end

                    def checkbox(model_name, modelName, column_name, columnName, labelName, values)

                        data = <<-HTML
        <!-- #{labelName} -->
                        HTML

                        values.each do |value|
                            get_value = value.split ','
                            checkbox_value = get_value[0]
                            checkbox_label = get_value[1]

                            data << <<-HTML
        <div class="form-check">
          <input class="form-check-input" type="checkbox" value="#{checkbox_value}" id="#{modelName}#{columnName.camelize}#{checkbox_label.camelize.delete(' ')}" v-model="#{model_name}.#{column_name}">
          <label class="form-check-label" for="#{modelName}#{columnName.camelize}#{checkbox_label.camelize.delete(' ')}">
                #{checkbox_label}  
          </label>
        </div>
                            HTML
                        end

                        return data
                    end

                    def textarea(model_name, modelName, column_name, columnName, labelName)
                        return <<-HTML
        <!-- #{labelName} -->
        <div class="form-group">
                <label for="#{modelName}#{columnName.camelize}">#{labelName}</label>
                <textarea v-model="#{model_name}.#{column_name}" class="form-control" rows="3" cols="30" placeholder="Write your #{labelName} here..." id="#{modelName}#{columnName.camelize}"></textarea>
        </div>
                        HTML
                    end
                    end
                end
            end
        end
    end
end

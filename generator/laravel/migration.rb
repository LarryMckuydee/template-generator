module Generator
    module Laravel
        module Migration
            extend self
            def generate(args)
                # ruby main.rb scaffold Model column:type:form_type
                model, *args = args

                class_name = "Create#{model.pluralize}Table"
                table_name = model.underscore.pluralize

                data =
                    File.read(
                        "#{Dir.getwd}/template/laravel/migration/create_table.stub"
                    )
                filename =
                    "#{Time.now.strftime '%Y_%m_%d_%H%M%S'}_create_#{model
                        .underscore
                        .pluralize}_table.php"

                replaced_data = data.gsub 'ClassName', class_name
                replaced_data = replaced_data.gsub 'tablename', table_name

                input_up_variable = ''

                args.each do |arg|
                    #split column:type:form_type
                    variable = arg.split ':'
                    column_name = variable[0]
                    column_type = variable[1]
                    form_type = variable[2]

                    laravel_data_type = LaravelDataType.new
                    input_up_variable.concat laravel_data_type.assign_data_type(column_type, column_name)
                    input_up_variable.concat "\n            "
                end

                replaced_data = replaced_data.gsub 'input_up_variable', input_up_variable

                open(filename, 'w') { |f|  
                    f.write replaced_data  
                }
                puts "Laravel migration generate complete. #{filename}"
            end

            def foo
                puts 'PascalCase'.underscore
            end

            class LaravelDataType
                def assign_data_type(data_type = '', column_name = '')
                    return "$table->timestamps();" if column_name == '' and data_type == "timestamps"
                    return "$table->dropColumn('#{column_name}');" if data_type == "dropColumn"
                    return "$table->unsignedBigInteger('#{column_name}');" if data_type == "unsignedBigInteger"
                    return "$table->string('#{column_name}');" if data_type == "string"
                    return "$table->integer('#{column_name}');" if data_type == "integer"
                    return "$table->text('#{column_name}');" if data_type == "text"
                    return "$table->jsonb('#{column_name}');" if data_type == "jsonb"
                    return "$table->boolean('#{column_name}');" if data_type == "boolean"
                    return "$table->bigIncrements('#{column_name}');" if data_type == "bigIncrements"
                end
            end
        end
    end
end

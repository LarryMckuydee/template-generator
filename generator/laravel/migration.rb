module Generator
    module Laravel
        module Migration
            extend self
            def generate(dir, args)
                # ruby main.rb scaffold Model column:type,require_or_nullable:form_type
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
                    type_and_require = variable[1]
                    data_type, nullable = type_and_require.split ','

                    laravel_data_type = LaravelDataType.new
                    input_up_variable.concat laravel_data_type.assign_data_type(column_name, data_type, nullable)
                    input_up_variable.concat "\n            "
                end

                replaced_data = replaced_data.gsub 'input_up_variable', input_up_variable

                path = dir + '/database/migrations/' + filename

                can_replace = true
                if File.file?(path)
                    print "File #{path} is already exists, are you sure you want to replace them? ({y}es/{n}o)" 
                    can_replace = false if not ['yes','y'].include? STDIN.gets.rstrip 
                end

                if can_replace
                    open(path, 'w') { |f|  
                        f.write replaced_data  
                    }
                    puts "Laravel migration generate complete. #{filename}"
                else
                    puts "Laravel migration didn't generated."
                end
            end

            def foo
                puts 'PascalCase'.underscore
            end

            class LaravelDataType
                def assign_data_type(column_name = '', data_type = '', nullable = '')
                    line = ''
                    line << "$table->timestamps()" if column_name == '' and data_type == "timestamps"
                    line << "$table->dropColumn('#{column_name}')" if data_type == "dropColumn"
                    line << "$table->unsignedBigInteger('#{column_name}')" if data_type == "unsignedBigInteger"
                    line << "$table->string('#{column_name}')" if data_type == "string"
                    line << "$table->integer('#{column_name}')" if data_type == "integer"
                    line << "$table->tinyInteger('#{column_name}')" if data_type == "tinyInteger"
                    line << "$table->text('#{column_name}')" if data_type == "text"
                    line << "$table->dateTime('#{column_name}')" if data_type == "dateTime"
                    line << "$table->jsonb('#{column_name}')" if data_type == "jsonb"
                    line << "$table->boolean('#{column_name}')" if data_type == "boolean"
                    line << "$table->decimal('#{column_name}', 6, 2)" if data_type == "decimal"
                    line << "$table->bigIncrements('#{column_name}')" if data_type == "bigIncrements"
                    line << "$table->morphs('#{column_name}')" if data_type == "morphs"
                    line << "$table->uuidMorphs('#{column_name}')" if data_type == "uuidMorphs"
                    line << "$table->uuid('#{column_name}')" if data_type == "uuid"
                    line << "->nullable()" if nullable == 'nullable'

                    raise "Data Type not supported. (#{data_type})" if line.blank?

                    return line << ';'
                end
            end
        end
    end
end

module Generator
    module Laravel
        module Controller
            extend self
            def generate(args)
                # ruby main.rb scaffold Model column:type,require_or_nullable:form_type
                model, *args = args

                class_name = "#{model.camelize}Controller"
                resource_class_name = "#{model.camelize}Resource"
                modelName = "#{model.camelize(:lower)}"
                model_name = "#{model.underscore}"

                data =
                    File.read(
                        "#{Dir.getwd}/template/laravel/controller/controller.stub"
                    )
                filename =
                    "#{model
                        .camelize}Controller.php"

                replaced_data = data.gsub 'ClassName', class_name
                replaced_data = replaced_data.gsub 'ResourceName', resource_class_name
                replaced_data = replaced_data.gsub 'ModelName', model
                replaced_data = replaced_data.gsub 'modelName', modelName

                validator_contents = ''

                args.each do |arg|
                    #split column:type:form_type
                    variable = arg.split ':'
                    column, type_and_require, form_type, *args = variable 
                    data_type, nullable = type_and_require.split ','

                    laravel_validator = LaravelValidator.new
                    validator_contents.concat laravel_validator.assign_validation(column, data_type, nullable)
                    validator_contents.concat "\n            "
                end

                replaced_data = replaced_data.gsub 'VALIDATOR_CONTENT', validator_contents

                open(filename, 'w') { |f|  
                    f.write replaced_data  
                }
                puts "Laravel controller generate complete. #{filename}"
            end

            def foo
                puts 'PascalCase'.underscore
            end

            class LaravelValidator
                def assign_validation(column_name = '', data_type = '', nullable = '')
                    required = 'required'
                    required = 'nullable' if nullable == 'nullable'
                    case
                    when data_type == "unsignedBigInteger"
                        return "'#{column_name}' => '#{required}|integer',"
                    when data_type == "string"
                        return "'#{column_name}' => '#{required}|string',"
                    when data_type == "integer"
                        return "'#{column_name}' => '#{required}|integer',"
                    when data_type == "text"
                        return "'#{column_name}' => '#{required}|string',"
                    when data_type == "boolean"
                        return "'#{column_name}' => '#{required}|boolean',"
                    when data_type == "bigIncrements"
                        return "'#{column_name}' => '#{required}|integer',"
                    else
                        raise "Validator not supported."
                    end
                end
            end
        end
    end
end
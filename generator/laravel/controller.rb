require_relative "laravel_validator"
module Generator
    module Laravel
        module Controller
            extend self
            def generate(dir, args)
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

                path = dir + '/app/Http/Controllers/Api/' + filename

                can_replace = true
                if File.file?(path)
                    print "File #{path} is already exists, are you sure you want to replace them? ({y}es/{n}o)" 
                    can_replace = false if not ['yes','y'].include? STDIN.gets.rstrip 
                end

                if can_replace
                    open(path, 'w') { |f|  
                        f.write replaced_data  
                    }
                    puts "Laravel controller generate complete. #{filename}"
                else
                    puts "Laravel controller didn't generated."
                end
            end

            def generate_repo(dir, args)
                # ruby main.rb scaffold Model column:type,require_or_nullable:form_type
                model, *args = args

                class_name = "#{model.camelize}Controller"
                resource_class_name = "#{model.camelize}Resource"
                modelName = "#{model.camelize(:lower)}"
                model_name = "#{model.underscore}"
								model_names = "#{model.underscore.pluralize}"

                data =
                    File.read(
                        "#{Dir.getwd}/template/laravel/controller/controller_repo.stub"
                    )
                filename =
                    "#{model
                        .camelize}Controller.php"

                replaced_data = data.gsub 'ClassName', class_name
                replaced_data = replaced_data.gsub 'ResourceName', resource_class_name
                replaced_data = replaced_data.gsub 'ModelName', model
                replaced_data = replaced_data.gsub 'modelName', modelName
                replaced_data = replaced_data.gsub 'model_names', model_names

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

                path = dir + '/app/Http/Controllers/Api/' + filename

                can_replace = true
                if File.file?(path)
                    print "File #{path} is already exists, are you sure you want to replace them? ({y}es/{n}o)" 
                    can_replace = false if not ['yes','y'].include? STDIN.gets.rstrip 
                end

                if can_replace
                    open(path, 'w') { |f|  
                        f.write replaced_data  
                    }
                    puts "Laravel controller generate complete. #{filename}"
                else
                    puts "Laravel controller didn't generated."
                end
            end

            def foo
                puts 'PascalCase'.underscore
            end

        end
    end
end

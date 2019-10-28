require_relative "./laravel_validator"
module Generator
    module Laravel
        module Repository
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
                        "#{Dir.getwd}/template/laravel/repository/repository.stub"
                    )
                filename =
                    "#{model
                        .camelize}Repository.php"

                replaced_data = data.gsub 'ClassName', class_name
                replaced_data = replaced_data.gsub 'ResourceName', resource_class_name
                replaced_data = replaced_data.gsub 'ModelName', model
                replaced_data = replaced_data.gsub 'modelName', modelName

                validator_contents = ''
                batch_validator_contents = ''

                args.each do |arg|
                    #split column:type:form_type
                    variable = arg.split ':'
                    column, type_and_require, form_type, *args = variable 
                    data_type, nullable = type_and_require.split ','

                    laravel_validator = LaravelValidator.new
                    validator_contents.concat laravel_validator.assign_validation(column, data_type, nullable)
                    validator_contents.concat "\n            "
                    
                    #batch
                    batch_validator_contents.concat laravel_validator.assign_batch_validation(column, data_type, nullable)
                    batch_validator_contents.concat "\n            "
                end
                
                #must put on top because replace validator content first will replace the identical for batch validator content and make it fail
                replaced_data = replaced_data.gsub 'BATCH_VALIDATOR_CONTENT', batch_validator_contents

                replaced_data = replaced_data.gsub 'VALIDATOR_CONTENT', validator_contents

                path = dir + '/app/Repositories/' + filename

                can_replace = true
                if File.file?(path)
                    print "File #{path} is already exists, are you sure you want to replace them? ({y}es/{n}o)" 
                    can_replace = false if not ['yes','y'].include? STDIN.gets.rstrip 
                end

                if can_replace
                    open(path, 'w') { |f|  
                        f.write replaced_data  
                    }
                    puts "Laravel repository generate complete. #{filename}"
                else
                    puts "Laravel repository didn't generated."
                end
            end

            def foo
                puts 'PascalCase'.underscore
            end

        end
    end
end

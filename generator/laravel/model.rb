module Generator
    module Laravel
        module Model
            extend self
            def generate(dir, args)
                # ruby main.rb scaffold Model column:type,require_or_nullable:form_type
                model, *args = args

                data =
                    File.read(
                        "#{Dir.getwd}/template/laravel/model/model.stub"
                    )
                filename = "#{model}.php"

                replaced_data = data.gsub 'ModelName', model

                fillable_contents = ''

                args.each do |arg|
                    #split column:type:form_type
                    variable = arg.split ':'
                    column, type_and_require, form_type, *args = variable 
                    data_type, nullable = type_and_require.split ','

                    fillable_contents.concat "'#{column}',"
                    fillable_contents.concat "\n            "
                end

                replaced_data = replaced_data.gsub 'FILLABLE_CONTENT', fillable_contents

                open(dir + '/app/' + filename, 'w') { |f|  
                    f.write replaced_data  
                }
                puts "Laravel model generate complete. #{filename}"
            end

            def foo
                puts 'PascalCase'.underscore
            end
        end
    end
end

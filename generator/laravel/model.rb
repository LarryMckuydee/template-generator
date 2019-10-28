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

                    next if data_type == "uuidMorphs" or data_type == "morphs"

                    fillable_contents.concat "'#{column}',"
                    fillable_contents.concat "\n            "
                end

                replaced_data = replaced_data.gsub 'FILLABLE_CONTENT', fillable_contents

                path = dir + '/app/' + filename 

                can_replace = true
                if File.file?(path)
                    print "File #{path} is already exists, are you sure you want to replace them? ({y}es/{n}o)" 
                    can_replace = false if not ['yes','y'].include? STDIN.gets.rstrip 
                end

                if can_replace
                    open(path, 'w') { |f|  
                        f.write replaced_data  
                    }
                    puts "Laravel model generate complete. #{filename}"
                else
                    puts "Laravel model didn't generated."
                end
            end

            def foo
                puts 'PascalCase'.underscore
            end
        end
    end
end

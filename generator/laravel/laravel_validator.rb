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
        when data_type == "tinyInteger"
            return "'#{column_name}' => '#{required}|integer',"
        when data_type == "text"
            return "'#{column_name}' => '#{required}|string',"
        when data_type == "dateTime"
            return "'#{column_name}' => '#{required}|date',"
        when data_type == "decimal"
            return "'#{column_name}' => '#{required}|numeric',"
        when data_type == "boolean"
            return "'#{column_name}' => '#{required}|boolean',"
        when data_type == "bigIncrements"
            return "'#{column_name}' => '#{required}|integer',"
        when data_type == "jsonb"
            return "'#{column_name}' => '#{required}|json',"
        when data_type == "uuidMorphs"
            return ""
        when data_type == "morphs"
            return ""
        when data_type == "uuid"
            return ""
        else
            raise "Validator not supported. (#{data_type})"
        end
    end

    def assign_batch_validation(column_name = '', data_type = '', nullable = '')
        required = 'required'
        required = 'nullable' if nullable == 'nullable'
        case
        when data_type == "unsignedBigInteger"
            return "'batch.*.#{column_name}' => '#{required}|integer',"
        when data_type == "string"
            return "'batch.*.#{column_name}' => '#{required}|string',"
        when data_type == "integer"
            return "'batch.*.#{column_name}' => '#{required}|integer',"
        when data_type == "tinyInteger"
            return "'batch.*.#{column_name}' => '#{required}|integer',"
        when data_type == "text"
            return "'batch.*.#{column_name}' => '#{required}|string',"
        when data_type == "dateTime"
            return "'batch.*.#{column_name}' => '#{required}|date',"
        when data_type == "decimal"
            return "'batch.*.#{column_name}' => '#{required}|numeric',"
        when data_type == "boolean"
            return "'batch.*.#{column_name}' => '#{required}|boolean',"
        when data_type == "bigIncrements"
            return "'batch.*.#{column_name}' => '#{required}|integer',"
        when data_type == "jsonb"
            return "'batch.*.#{column_name}' => '#{required}|json',"
        when data_type == "uuidMorphs"
            return ""
        when data_type == "morphs"
            return ""
        when data_type == "uuid"
            return ""
        else
            raise "Validator not supported. (#{data_type})"
        end
    end
end

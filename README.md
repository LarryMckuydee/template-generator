# Template Generator
A template generator that use to generate laravel and vue template.

## Prerequisite
ruby 2.6.3  
bundler  

## Installation
Install gem by running bundle  
```
bundle
```

## Command

Basic generation  
```
ruby main.rb scaffold Model column:type:form_type
```

With Radio Input  
just add argument below

```
ruby main.rb scaffold Model column:type:form_type:radio_value1,radio_label1:radio_value2,radio_label2
```

With Select Input
```
ruby main.rb scaffold Model column:type:form_type:refers
```

### Available Options

Database column type options:  

| Syntax | Column Type |
| ------ | ----------- |
| unsignedBigInteger | unsignedBigInteger |
| string | string |
| boolean | boolean |
| text | text |
| jsonb | jsonb |
| integer | integer |
| bigIncrements | bigIncrements |
| dateTime | dateTime |


Form input type options:

| Syntax | Input Type | Options | Options Explanation |
| ------ | ----------- | ------ | ------------------- |
| text | <input type="text"/> | | |
| select | <select /> | refers | use to refer to a collection as data for selections, eg: refers.length > 0 |
| radio | <input type="radio"/> | radio_value,radio_label | radio_value and radio_label are use to assign value and label for radio options, eg: <input type="radio" value="0" /> <label>False</label>, you can assign the options by adding form_type:0,False. It can be multiple value and label too, form_type:0,False:1,True  |
| checkbox | <input type="checkbox" /> | checkbox_value,checkbox_label | checkbox_value and checkbox_label are use to assign value and label for checkbox options, eg: <input type="checkbox" value="0" /> <label>False</label>, you can assign the options by adding form_type:0,False. It can be multiple value and label too, form_type:0,False:1,True  |
| textarea | <textarea /> | | |
| date | <input type="date"/> | | |


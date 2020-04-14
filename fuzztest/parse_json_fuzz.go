package fuzztest

import "github.com/buger/jsonparser"

func Fuzz(data []byte) int {

	path := []string {"a", "b", "c"}
	testJson := []byte(`{"test":"inpout"}`)
	
	values, err := jsonparser.Set(testJson, data, path...)

	if err != nil {
		if values != nil {
			panic("tree must be nil if there is an error")
		}
		return 0
	}

	val1, err1 := jsonparser.GetString(values, path...)
	if err1 != nil {
		if val1 != "" {
			panic(`str must be "" if there is an error`)
		}
		panic(err1)
	}

	jsonparser.EachKey(values, func(idx int, value []byte, valueType jsonparser.ValueType, err error) {
		switch idx {
		case 0 :
		      if string(value) != string(data) {
	                 panic(`value must be equal to data`)
		      }
		default:
		}
	}, path)
	
	return 1
}

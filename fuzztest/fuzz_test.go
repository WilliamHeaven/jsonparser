package fuzztest

import "github.com/buger/jsonparser"

func Fuzz(data []byte) int {

	path := []string {"a", "b", "c"}

	values, err := jsonparser.Set(data, data, path...)

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
		default:
			panic("Eachkey there is an error")
		}
	}, path)

	return 1
}

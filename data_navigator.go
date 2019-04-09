package main

import (
	"strconv"

	yaml "gopkg.in/yaml.v3"
)

func recursePath(value yaml.Node, path []string) (yaml.Node, error) {
	realValue := value
	if realValue.Kind == yaml.DocumentNode {
		realValue = *value.Content[0]
	}
	if len(path) > 0 {
		log.Debug("diving into %v", path[0])
		return recurse(realValue, path[0], path[1:])
	}
	return realValue, nil
}

func recurse(value yaml.Node, head string, tail []string) (yaml.Node, error) {
	switch value.Kind {
	case yaml.MappingNode:
		log.Debug("its a map with %v entries", len(value.Content)/2)
		for index, content := range value.Content {
			// value.Content is a concatenated array of key, value,
			// so keys are in the even indexes, values in odd.
			if index%2 == 1 || content.Value != head {
				continue
			}
			mapEntryValue := value.Content[index+1]
			return recursePath(*mapEntryValue, tail)
		}
		return yaml.Node{Kind: yaml.ScalarNode}, nil
	case yaml.SequenceNode:
		log.Debug("its a sequence of %v things!", len(value.Content))
		if head == "*" {
			var newNode = yaml.Node{Kind: yaml.SequenceNode, Style: value.Style}
			newNode.Content = make([]*yaml.Node, len(value.Content))

			for index, value := range value.Content {
				var nestedValue, err = recursePath(*value, tail)
				if err != nil {
					return yaml.Node{}, err
				}
				newNode.Content[index] = &nestedValue
			}
			return newNode, nil
		}
		var index, err = strconv.ParseInt(head, 10, 64) // nolint
		if err != nil {
			return yaml.Node{}, err
		}
		if index >= int64(len(value.Content)) {
			return yaml.Node{Kind: yaml.ScalarNode}, nil
		}

		return recursePath(*value.Content[index], tail)
	default:
		return value, nil
	}

}

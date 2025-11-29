extends Node

var input_enabled: bool = true
var locked: bool = false

func set_input_enabled(): input_enabled = true if not locked else input_enabled
func set_input_disabled(): input_enabled = false if not locked else input_enabled
func lock(): locked = true
func unlock(): locked = false

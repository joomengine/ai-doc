def guid: type=="string" and test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
(if $entity=="snippet_type" then "src/snippet_type/" else "src/" end) as $prefix |
type=="object" and all(to_entries[]; .key as $key | .value as $item |
	($key|guid) and ($item|type=="object") and $item.guid==$key and
	($item.name|type=="string" and length>0) and $item.path==($prefix+$key) and
	$item.settings==($prefix+$key+"/item.json") and
	(if $entity=="snippet_type" then true else ($item|has("desc")) and ($item.desc|type=="string" or .==null) end)
)

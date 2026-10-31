def nonempty: type=="string" and length>0;
def portable_path: nonempty and (startswith("/")|not) and (contains("\\")|not) and (test("[[:cntrl:]]|^[A-Za-z]:")|not) and (split("/")|all(.!="." and .!=".." and .!=""));
def uuid: type=="string" and test("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$");
def rows: if type=="array" then .[] elif type=="object" then .[] else empty end;
def structured($m):
  if .==null or .=="" then true
  elif ($m.type=="subform" or ($m|has("fields"))) then
    (type=="array" or type=="object") and all(rows; type=="object" and
      (if ($m.fields|type)=="object" then . as $row | all($m.fields|to_entries[]; . as $f | if $row|has($f.key) then ($row[$f.key]|structured($f.value)) else true end) else true end))
  elif (["text","textarea","editor","integer","number","radio","checkbox","email","url","calendar","password"]|index($m.type)!=null) or $m.store=="base64" then
    type!="object" and type!="array"
  else true end;
def dependency:
  . as $d | type=="object" and (.key|nonempty) and (.value|nonempty) and (.entity|nonempty) and (.table|nonempty) and
  if .entity=="file" or .entity=="folder" then
    .table=="file_system" and (.value|portable_path) and (["custom","compiler","image","images","full"]|index($d.target)!=null) and (.key|test("^[0-9a-f]{8}-[0-9a-f]{4}-5[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}(\\.[a-z0-9]+)?$")) and (.pointer==(.key|gsub("\\.";"--"))) and (has("direction")|not)
  else (.direction=="in" or .direction=="out") and .table==("#__componentbuilder_"+.entity) end;
. as $item | $contract[0] as $c |
type=="object" and
([keys[]]|all(. as $key | $key=="@dependencies" or ($c.fields|has($key)))) and
(.[$c.config.guid_field]|nonempty) and
([$c.fields|keys[]|select($item[.]!=null)]|length>1) and
(if $c.identity_kind=="guid" or $c.identity_kind=="parent_guid" then (.[$c.config.guid_field]|uuid) else true end) and
all($c.fields|to_entries[]; . as $field |
  if $item|has($field.key) then
    ($item[$field.key]|type) as $type |
    ($field.value.static_json_types|index($type)!=null) and
    ($item[$field.key]|structured($field.value.table_metadata)) and
    (if $c.entity=="field" and $field.key=="xml" then ($item[$field.key]==null or ($item[$field.key]|type)=="string") else true end)
  else true end) and
(if has("@dependencies") then (."@dependencies"|type=="array" and all(.[];dependency) and (length==([.[]|tojson]|unique|length))) else true end)

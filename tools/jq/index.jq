def uuid: type == "string" and test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
type == "object" and all(to_entries[];
	.key as $guid | .value as $v |
	($guid|uuid) and ($v|type=="object") and
	$v.guid == $guid and ($v.name|type=="string" and length>0) and
	(["class","abstract class","final class","interface","trait"]|index($v.type)!=null) and
	($v.namespace|type=="string" and length>0) and
	$v.path == ("src/"+$guid) and
	$v.settings == ("src/"+$guid+"/settings.json") and
	$v.power == ("src/"+$guid+"/code.power") and
	$v.code == ("src/"+$guid+"/code.php") and
	$v.spk == ("Super---"+($guid|gsub("-";"_"))+"---Power")
)

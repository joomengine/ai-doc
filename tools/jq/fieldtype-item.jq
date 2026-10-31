def guid: type=="string" and test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
def flag: .==0 or .==1 or .=="0" or .=="1";
def optional_flag($key): if has($key) then .[$key]|flag else true end;
def choice($allowed): (type=="string" or type=="number") and (tostring as $value|$allowed|index($value)!=null);
def properties:
	(type=="array" or type=="object") and length>0 and
	all(.[]; type=="object" and (.name|type=="string" and length>0) and
		(.example|type=="string") and (.description|type=="string") and
		optional_flag("adjustable") and optional_flag("mandatory") and optional_flag("translatable")) and
	([.[].name]|length==(unique|length)) and ([.[]|select(.name=="type")]|length==1);
type=="object" and (.guid|guid) and (.name|type=="string" and length>0) and
	(.description|type=="string") and (.short_description|type=="string") and
	(.has_defaults|flag) and (.store|choice(["0","1","2","3","5","6"])) and
	(.null_switch|.=="NULL" or .=="NOT NULL" or .=="") and
	(.indexes|choice(["","0","1","2"])) and
	(.datatype|choice(["","CHAR","VARCHAR","TEXT","MEDIUMTEXT","LONGTEXT","BLOB","TINYBLOB","MEDIUMBLOB","LONGBLOB","DATETIME","DATE","TIME","INT","TINYINT","BIGINT","FLOAT","DECIMAL","DOUBLE"])) and
	(.datadefault|choice(["","0","1","CURRENT_TIMESTAMP","DATETIME","Other"])) and
	(.datalenght|choice(["","1","7","10","11","36","50","64","100","255","1024","2048","Other"])) and
	(.datadefault_other|type=="string") and (.datalenght_other|type=="string") and
	(if (.has_defaults|tostring)=="1" and .datalenght=="Other" then (.datalenght_other|test("\\S")) else true end) and
	(.properties|properties)

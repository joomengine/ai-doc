# This deliberately validates the documented interchange profile, not every JCB rule.
def uuid: type == "string" and test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
def custom: . == -1 or . == "-1";
def blank: . == null or . == "";
def rows: if type=="array" or type=="object" then .[] else empty end;
def selection: blank or ((type=="array" or type=="object") and all(rows; type=="object"));
def references: blank or (type=="array" and all(.[]; uuid or custom));
def text_or_null: type=="string" or .==null;
def identifier: type=="string" and test("^[a-zA-Z_][a-zA-Z0-9_]*$");
def relative_path: type=="string" and test("^[A-Za-z0-9_.-]+(/[A-Za-z0-9_.-]+)*$") and (split("/")|all(.[]; .!="." and .!=".."));
type=="object" and (.guid|uuid) and
	(.name|type=="string" and test("^[a-zA-Z_][a-zA-Z0-9_]*$")) and
	(.namespace|type=="string" and (split("\\")|length)>=2) and
	(.namespace|gsub("\\[\\[\\[[A-Za-z_][A-Za-z0-9_]*\\]\\]\\]";"Placeholder")|split("\\")|all(.[]; split(".")|all(.[]; identifier))) and
	(.power_version|type=="string" and length>0) and
	(.system_name|type=="string" and length>0) and
	((.namespace|split("\\")|last|split(".")|last)==.name) and
	(.description|text_or_null) and (.head|text_or_null) and (.licensing_template|text_or_null) and
	(["class","abstract class","final class","interface","trait"]|index($settings_type)!=null) and
	(.extends|blank or uuid or custom) and
	(.implements|references) and (.extendsinterfaces|references) and
	(.use_selection|selection) and (.load_selection|selection) and
	all(.use_selection|rows; (.use|uuid) and (.as|identifier)) and
	all(.load_selection|rows; .load|uuid) and
	(.composer|blank or type=="array" or type=="object") and
	all(.composer|rows; type=="object" and (.access_point|relative_path) and (.namespace|type=="array" or type=="object") and all(.namespace|rows; type=="object" and (.use|type=="string" and length>0))) and
	(.add_head|. == 0 or . == 1 or . == "0" or . == "1") and
	(.add_licensing_template|. == 1 or . == 2 or . == "1" or . == "2") and
	(if (.add_licensing_template==2 or .add_licensing_template=="2") then (.licensing_template|type=="string" and length>0) else true end) and
	(if (.extends|custom) then (.extends_custom|type=="string" and length>0) else true end) and
	(if any(.implements[]?; custom) then (.implements_custom|type=="string" and length>0) else true end) and
	(if any(.extendsinterfaces[]?; custom) then (.extendsinterfaces_custom|type=="string" and length>0) else true end)

def meaningful: .!=null and .!="" and .!=0 and .!="0" and .!= -1 and .!="-1";
def values: if type=="array" then .[] elif type=="object" then .[] else . end;
def fieldlinks($m; $path):
  . as $value |
  (if ($m.link|type)=="object" and $m.link.type==1 then
    $value|values|select(meaningful)|{entity:$m.link.entity,key:$m.link.key,value:.,origin:$path,kind:"table_link"}
   else empty end),
  (if ($m.fields|type)=="object" and ($value|type)=="array" or (($m.fields|type)=="object" and ($value|type)=="object") then
    $value|to_entries[]|. as $row|select(.value|type=="object")|
    $m.fields|to_entries[]|. as $sub|$row.value[$sub.key]|fieldlinks($sub.value; $path+"."+($row.key|tostring)+"."+$sub.key)
   else empty end);
. as $item | $contract[0] as $c |
(($item."@dependencies" // [])[]|. + {origin:"@dependencies",kind:"declared"}),
($c.fields|to_entries[]|. as $field|$item[$field.key]|fieldlinks($field.value.table_metadata;$field.key))

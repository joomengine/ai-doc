def guid: type=="string" and test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
def nonempty: type=="string" and length>0;
. as $item |
type=="object" and (.guid|guid) and (.name|nonempty) and
	all(.url,.heading,.contributor_email,.contributor_name,.contributor_website,.contributor_company,.snippet,.usage,.description; type=="string") and
	(.url|test("^https?://[^/@\\s?#]+(?:[/?#][^\\s]*)?$")) and (.heading|length>0) and
	(.snippet|length>0) and (.type|guid) and (.library|guid) and
	(."@dependencies"|type=="array") and
	(."@dependencies"|length==2) and
	all(."@dependencies"[]; type=="object" and (.key|nonempty) and (.value|nonempty) and (.entity|nonempty) and (.table|nonempty) and (.direction|.=="out" or .=="in")) and
	([."@dependencies"[]|select(.entity=="snippet_type")]|length==1 and all(.[]; .key=="guid" and .value==$item.type and .table=="#__componentbuilder_snippet_type" and .direction=="out")) and
	([."@dependencies"[]|select(.entity=="library")]|length==1 and all(.[]; .key=="guid" and .value==$item.library and .table=="#__componentbuilder_library" and .direction=="out"))

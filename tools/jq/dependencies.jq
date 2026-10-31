def uuid: type=="string" and test("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$");
[.extends, .implements[]?, .extendsinterfaces[]?, .use_selection[]?.use, .load_selection[]?.load] | map(select(uuid)) | unique[]

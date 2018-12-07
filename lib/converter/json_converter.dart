dynamic optJSON(Map<String, dynamic> json, String key) {
  if (json.containsKey(key)) {
    return json[key];
  }
  return null;
}

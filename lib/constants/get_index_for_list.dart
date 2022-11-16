getIndexForList(int i, List list) {
  return i % list.length;
}
getItemFromList(int i, List list) {
  return list[i % list.length];
}

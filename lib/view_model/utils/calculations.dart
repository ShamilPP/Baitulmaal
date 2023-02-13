List<int> getMeekathList() {
  int meekathStartYear = 2021;
  int meekathLastYear = DateTime.now().year;
  List<int> allMeekath = [];
  for (int i = meekathStartYear; i <= meekathLastYear; i++) {
    allMeekath.add(i);
  }
  return allMeekath;
}

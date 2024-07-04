class ApiEndPoint {
  static const baseUrl = 'http://universities.hipolabs.com/';
  static const beersResource = 'beers';
  static const universityList =
      '${baseUrl}search?country=India&page={PAGE}&limit={LIMIT}';
  // 'page={PAGE}'
  // '&per_page={LIMIT}';
}

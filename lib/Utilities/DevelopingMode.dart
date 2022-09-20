class DevelopingOptions extends Iterable<bool>{
  static bool deleteOnInit = false;

  @override
  Iterator<bool> get iterator => [deleteOnInit].iterator;
}
import 'dart:math';

void main() {
  var rng = new Random();
  var l = new List.generate(12, (_) => rng.nextInt(100));
  print(l);
}

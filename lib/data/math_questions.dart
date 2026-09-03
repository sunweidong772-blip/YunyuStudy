import 'dart:math';

class MathQuestion {
  final String question;
  final String answer;
  final List<String> options;
  final String explanation;

  MathQuestion({required this.question, required this.answer, required this.options, required this.explanation});
}

class MathGenerator {
  static final Random _random = Random();

  static List<MathQuestion> generateQuestions(int grade, int count) {
    List<MathQuestion> questions = [];
    for (int i = 0; i < count; i++) {
      questions.add(_generateByGrade(grade));
    }
    return questions;
  }

  static MathQuestion _generateByGrade(int grade) {
    switch (grade) {
      case 1: return _grade1();
      case 2: return _grade2();
      case 3: return _grade3();
      case 4: return _grade4();
      case 5: return _grade5();
      case 6: return _grade6();
      default: return _grade3();
    }
  }

  static MathQuestion _grade1() {
    int a = _random.nextInt(10) + 1;
    int b = _random.nextInt(10) + 1;
    bool isAdd = _random.nextBool();
    if (!isAdd && a < b) { int t = a; a = b; b = t; }
    int answer = isAdd ? a + b : a - b;
    String q = '$a ${isAdd ? '+' : '-'} $b = ?';
    return MathQuestion(question: q, answer: '$answer', options: _makeOptions(answer), explanation: '$a ${isAdd ? '加' : '减'} $b 等于 $answer');
  }

  static MathQuestion _grade2() {
    int type = _random.nextInt(3);
    if (type == 0) {
      int a = _random.nextInt(50) + 10;
      int b = _random.nextInt(50) + 10;
      bool isAdd = _random.nextBool();
      if (!isAdd && a < b) { int t = a; a = b; b = t; }
      int answer = isAdd ? a + b : a - b;
      return MathQuestion(question: '$a ${isAdd ? '+' : '-'} $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '${isAdd ? '加法' : '减法'}运算：$a ${isAdd ? '+' : '-'} $b = $answer');
    } else if (type == 1) {
      int a = _random.nextInt(9) + 2;
      int b = _random.nextInt(9) + 2;
      int answer = a * b;
      return MathQuestion(question: '$a × $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '乘法口诀：$a × $b = $answer');
    } else {
      int b = _random.nextInt(9) + 2;
      int answer = _random.nextInt(9) + 2;
      int a = b * answer;
      return MathQuestion(question: '$a ÷ $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '除法运算：$a ÷ $b = $answer');
    }
  }

  static MathQuestion _grade3() {
    int type = _random.nextInt(3);
    if (type == 0) {
      int a = _random.nextInt(200) + 100;
      int b = _random.nextInt(200) + 100;
      bool isAdd = _random.nextBool();
      if (!isAdd && a < b) { int t = a; a = b; b = t; }
      int answer = isAdd ? a + b : a - b;
      return MathQuestion(question: '$a ${isAdd ? '+' : '-'} $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '三位数${isAdd ? '加法' : '减法'}：$a ${isAdd ? '+' : '-'} $b = $answer');
    } else if (type == 1) {
      int a = _random.nextInt(90) + 10;
      int b = _random.nextInt(9) + 2;
      int answer = a * b;
      return MathQuestion(question: '$a × $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '两位数乘一位数：$a × $b = $answer');
    } else {
      int a = _random.nextInt(12) + 1;
      int b = _random.nextInt(12) + 1;
      int answer = a * b;
      return MathQuestion(question: '$a × $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '乘法运算：$a × $b = $answer');
    }
  }

  static MathQuestion _grade4() {
    int type = _random.nextInt(3);
    if (type == 0) {
      int a = _random.nextInt(900) + 100;
      int b = _random.nextInt(90) + 10;
      int answer = a * b;
      return MathQuestion(question: '$a × $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '三位数乘两位数：$a × $b = $answer');
    } else if (type == 1) {
      int b = _random.nextInt(20) + 5;
      int answer = _random.nextInt(50) + 10;
      int a = b * answer;
      return MathQuestion(question: '$a ÷ $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '除法运算：$a ÷ $b = $answer');
    } else {
      int num = _random.nextInt(50) + 10;
      int answer = num * num;
      return MathQuestion(question: '$num 的平方 = ?', answer: '$answer', options: _makeOptions(answer), explanation: '$num × $num = $answer');
    }
  }

  static MathQuestion _grade5() {
    int type = _random.nextInt(3);
    if (type == 0) {
      int aNum = _random.nextInt(9) + 1;
      int aDen = _random.nextInt(9) + 2;
      int bNum = _random.nextInt(9) + 1;
      int bDen = _random.nextInt(9) + 2;
      int answerNum = aNum * bDen + bNum * aDen;
      int answerDen = aDen * bDen;
      return MathQuestion(question: '$aNum/$aDen + $bNum/$bDen = ?', answer: '$answerNum/$answerDen', options: _makeFractionOptions(answerNum, answerDen), explanation: '通分后相加：分母为$answerDen，分子为$answerNum');
    } else if (type == 1) {
      double a = (_random.nextInt(90) + 10) / 10;
      double b = (_random.nextInt(90) + 10) / 10;
      double answer = a * b;
      return MathQuestion(question: '${a.toStringAsFixed(1)} × ${b.toStringAsFixed(1)} = ?', answer: answer.toStringAsFixed(2), options: _makeDecimalOptions(answer), explanation: '小数乘法：${a.toStringAsFixed(1)} × ${b.toStringAsFixed(1)} = ${answer.toStringAsFixed(2)}');
    } else {
      int r = _random.nextInt(10) + 2;
      double answer = 3.14 * r * r;
      return MathQuestion(question: '半径为$r的圆面积 = ?（π取3.14）', answer: answer.toStringAsFixed(2), options: _makeDecimalOptions(answer), explanation: '圆面积公式 S=πr² = 3.14 × $r × $r = ${answer.toStringAsFixed(2)}');
    }
  }

  static MathQuestion _grade6() {
    int type = _random.nextInt(3);
    if (type == 0) {
      int a = _random.nextInt(80) + 20;
      int b = _random.nextInt(80) + 20;
      int answer = a * b ~/ 100;
      return MathQuestion(question: '$a% × $b = ?', answer: '$answer', options: _makeOptions(answer), explanation: '百分数运算：${a}% × $b = $answer');
    } else if (type == 1) {
      int a = _random.nextInt(5) + 2;
      int b = _random.nextInt(5) + 2;
      int c = _random.nextInt(5) + 2;
      int answer = a * b * c;
      return MathQuestion(question: '长$a、宽$b、高$c的长方体体积 = ?', answer: '$answer', options: _makeOptions(answer), explanation: '长方体体积 V=长×宽×高 = $a × $b × $c = $answer');
    } else {
      int x = _random.nextInt(20) + 1;
      int a = _random.nextInt(10) + 2;
      int b = _random.nextInt(20) + 5;
      int c = a * x + b;
      return MathQuestion(question: '解方程：${a}x + $b = $c，x = ?', answer: '$x', options: _makeOptions(x), explanation: '移项得 ${a}x = ${c - b}，x = ${(c - b) ~/ a} = $x');
    }
  }

  static List<String> _makeOptions(int answer) {
    Set<int> opts = {answer};
    while (opts.length < 4) {
      int offset = _random.nextInt(20) - 10;
      int wrong = answer + offset;
      if (wrong != answer && wrong >= 0) opts.add(wrong);
    }
    List<String> result = opts.map((e) => '$e').toList();
    result.shuffle();
    return result;
  }

  static List<String> _makeFractionOptions(int num, int den) {
    Set<String> opts = {'$num/$den'};
    while (opts.length < 4) {
      int n = num + _random.nextInt(10) - 5;
      int d = den + _random.nextInt(10) - 5;
      if (n > 0 && d > 0) opts.add('$n/$d');
    }
    List<String> result = opts.toList();
    result.shuffle();
    return result;
  }

  static List<String> _makeDecimalOptions(double answer) {
    Set<String> opts = {answer.toStringAsFixed(2)};
    while (opts.length < 4) {
      double offset = (_random.nextInt(200) - 100) / 10;
      String wrong = (answer + offset).toStringAsFixed(2);
      if (double.parse(wrong) > 0) opts.add(wrong);
    }
    List<String> result = opts.toList();
    result.shuffle();
    return result;
  }
}

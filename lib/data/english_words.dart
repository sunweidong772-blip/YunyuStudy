class EnglishWord {
  final String word;
  final String phonetic;
  final String meaning;
  final String example;
  final String exampleTranslation;

  EnglishWord({required this.word, required this.phonetic, required this.meaning, required this.example, required this.exampleTranslation});
}

class EnglishData {
  static final Map<int, List<EnglishWord>> wordsByGrade = {
    1: [
      EnglishWord(word: 'apple', phonetic: '/ˈæpl/', meaning: '苹果', example: 'I eat an apple every day.', exampleTranslation: '我每天吃一个苹果。'),
      EnglishWord(word: 'banana', phonetic: '/bəˈnɑːnə/', meaning: '香蕉', example: 'The banana is yellow.', exampleTranslation: '香蕉是黄色的。'),
      EnglishWord(word: 'cat', phonetic: '/kæt/', meaning: '猫', example: 'The cat is sleeping.', exampleTranslation: '猫在睡觉。'),
      EnglishWord(word: 'dog', phonetic: '/dɒɡ/', meaning: '狗', example: 'My dog is cute.', exampleTranslation: '我的狗很可爱。'),
      EnglishWord(word: 'egg', phonetic: '/eɡ/', meaning: '鸡蛋', example: 'I have an egg for breakfast.', exampleTranslation: '我早餐吃一个鸡蛋。'),
      EnglishWord(word: 'fish', phonetic: '/fɪʃ/', meaning: '鱼', example: 'The fish swims fast.', exampleTranslation: '鱼游得很快。'),
      EnglishWord(word: 'girl', phonetic: '/ɡɜːl/', meaning: '女孩', example: 'The girl is happy.', exampleTranslation: '女孩很开心。'),
      EnglishWord(word: 'hand', phonetic: '/hænd/', meaning: '手', example: 'Wash your hands.', exampleTranslation: '洗你的手。'),
      EnglishWord(word: 'ice', phonetic: '/aɪs/', meaning: '冰', example: 'The ice is cold.', exampleTranslation: '冰很冷。'),
      EnglishWord(word: 'juice', phonetic: '/dʒuːs/', meaning: '果汁', example: 'I like orange juice.', exampleTranslation: '我喜欢橙汁。'),
    ],
    2: [
      EnglishWord(word: 'book', phonetic: '/bʊk/', meaning: '书', example: 'This book is interesting.', exampleTranslation: '这本书很有趣。'),
      EnglishWord(word: 'pen', phonetic: '/pen/', meaning: '钢笔', example: 'I have a red pen.', exampleTranslation: '我有一支红色的钢笔。'),
      EnglishWord(word: 'pencil', phonetic: '/ˈpensl/', meaning: '铅笔', example: 'Use a pencil to write.', exampleTranslation: '用铅笔写字。'),
      EnglishWord(word: 'ruler', phonetic: '/ˈruːlə/', meaning: '尺子', example: 'My ruler is 20cm long.', exampleTranslation: '我的尺子20厘米长。'),
      EnglishWord(word: 'eraser', phonetic: '/ɪˈreɪzə/', meaning: '橡皮', example: 'I need an eraser.', exampleTranslation: '我需要一块橡皮。'),
      EnglishWord(word: 'bag', phonetic: '/bæɡ/', meaning: '书包', example: 'My bag is heavy.', exampleTranslation: '我的书包很重。'),
      EnglishWord(word: 'desk', phonetic: '/desk/', meaning: '书桌', example: 'The desk is clean.', exampleTranslation: '书桌很干净。'),
      EnglishWord(word: 'chair', phonetic: '/tʃeə/', meaning: '椅子', example: 'Sit on the chair.', exampleTranslation: '坐在椅子上。'),
      EnglishWord(word: 'teacher', phonetic: '/ˈtiːtʃə/', meaning: '老师', example: 'My teacher is kind.', exampleTranslation: '我的老师很和蔼。'),
      EnglishWord(word: 'student', phonetic: '/ˈstjuːdnt/', meaning: '学生', example: 'I am a student.', exampleTranslation: '我是一名学生。'),
    ],
    3: [
      EnglishWord(word: 'family', phonetic: '/ˈfæməli/', meaning: '家庭', example: 'I love my family.', exampleTranslation: '我爱我的家庭。'),
      EnglishWord(word: 'father', phonetic: '/ˈfɑːðə/', meaning: '父亲', example: 'My father is tall.', exampleTranslation: '我的父亲很高。'),
      EnglishWord(word: 'mother', phonetic: '/ˈmʌðə/', meaning: '母亲', example: 'My mother is beautiful.', exampleTranslation: '我的母亲很漂亮。'),
      EnglishWord(word: 'brother', phonetic: '/ˈbrʌðə/', meaning: '兄弟', example: 'I have one brother.', exampleTranslation: '我有一个兄弟。'),
      EnglishWord(word: 'sister', phonetic: '/ˈsɪstə/', meaning: '姐妹', example: 'My sister is younger.', exampleTranslation: '我的妹妹更小。'),
      EnglishWord(word: 'friend', phonetic: '/frend/', meaning: '朋友', example: 'She is my best friend.', exampleTranslation: '她是我最好的朋友。'),
      EnglishWord(word: 'happy', phonetic: '/ˈhæpi/', meaning: '快乐的', example: 'I am very happy today.', exampleTranslation: '我今天很快乐。'),
      EnglishWord(word: 'sad', phonetic: '/sæd/', meaning: '伤心的', example: 'He looks sad.', exampleTranslation: '他看起来很伤心。'),
      EnglishWord(word: 'beautiful', phonetic: '/ˈbjuːtɪfl/', meaning: '美丽的', example: 'The flower is beautiful.', exampleTranslation: '花很美丽。'),
      EnglishWord(word: 'strong', phonetic: '/strɒŋ/', meaning: '强壮的', example: 'He is very strong.', exampleTranslation: '他很强壮。'),
    ],
    4: [
      EnglishWord(word: 'weather', phonetic: '/ˈweðə/', meaning: '天气', example: 'The weather is nice today.', exampleTranslation: '今天天气很好。'),
      EnglishWord(word: 'sunny', phonetic: '/ˈsʌni/', meaning: '晴朗的', example: 'It is a sunny day.', exampleTranslation: '今天是晴天。'),
      EnglishWord(word: 'rainy', phonetic: '/ˈreɪni/', meaning: '下雨的', example: 'Take an umbrella, it is rainy.', exampleTranslation: '带把伞，下雨了。'),
      EnglishWord(word: 'cloudy', phonetic: '/ˈklaʊdi/', meaning: '多云的', example: 'Tomorrow will be cloudy.', exampleTranslation: '明天多云。'),
      EnglishWord(word: 'windy', phonetic: '/ˈwɪndi/', meaning: '有风的', example: 'It is very windy today.', exampleTranslation: '今天风很大。'),
      EnglishWord(word: 'snowy', phonetic: '/ˈsnəʊi/', meaning: '下雪的', example: 'I love snowy days.', exampleTranslation: '我喜欢下雪天。'),
      EnglishWord(word: 'spring', phonetic: '/sprɪŋ/', meaning: '春天', example: 'Flowers bloom in spring.', exampleTranslation: '春天花开。'),
      EnglishWord(word: 'summer', phonetic: '/ˈsʌmə/', meaning: '夏天', example: 'Summer is hot.', exampleTranslation: '夏天很热。'),
      EnglishWord(word: 'autumn', phonetic: '/ˈɔːtəm/', meaning: '秋天', example: 'Leaves fall in autumn.', exampleTranslation: '秋天落叶。'),
      EnglishWord(word: 'winter', phonetic: '/ˈwɪntə/', meaning: '冬天', example: 'Winter is cold.', exampleTranslation: '冬天很冷。'),
    ],
    5: [
      EnglishWord(word: 'hospital', phonetic: '/ˈhɒspɪtl/', meaning: '医院', example: 'The hospital is near my home.', exampleTranslation: '医院在我家附近。'),
      EnglishWord(word: 'library', phonetic: '/ˈlaɪbrəri/', meaning: '图书馆', example: 'I study in the library.', exampleTranslation: '我在图书馆学习。'),
      EnglishWord(word: 'museum', phonetic: '/mjuˈziːəm/', meaning: '博物馆', example: 'We visited the museum.', exampleTranslation: '我们参观了博物馆。'),
      EnglishWord(word: 'restaurant', phonetic: '/ˈrestrɒnt/', meaning: '餐厅', example: 'Let us eat at the restaurant.', exampleTranslation: '我们去餐厅吃饭吧。'),
      EnglishWord(word: 'supermarket', phonetic: '/ˈsuːpəmɑːkɪt/', meaning: '超市', example: 'I buy food at the supermarket.', exampleTranslation: '我在超市买食物。'),
      EnglishWord(word: 'cinema', phonetic: '/ˈsɪnəmə/', meaning: '电影院', example: 'We watched a movie at the cinema.', exampleTranslation: '我们在电影院看了电影。'),
      EnglishWord(word: 'airport', phonetic: '/ˈeəpɔːt/', meaning: '机场', example: 'The plane arrives at the airport.', exampleTranslation: '飞机到达机场。'),
      EnglishWord(word: 'station', phonetic: '/ˈsteɪʃn/', meaning: '车站', example: 'Wait for me at the station.', exampleTranslation: '在车站等我。'),
      EnglishWord(word: 'bridge', phonetic: '/brɪdʒ/', meaning: '桥', example: 'The bridge is very long.', exampleTranslation: '这座桥很长。'),
      EnglishWord(word: 'building', phonetic: '/ˈbɪldɪŋ/', meaning: '建筑物', example: 'This building has 20 floors.', exampleTranslation: '这栋楼有20层。'),
    ],
    6: [
      EnglishWord(word: 'environment', phonetic: '/ɪnˈvaɪrənmənt/', meaning: '环境', example: 'We should protect the environment.', exampleTranslation: '我们应该保护环境。'),
      EnglishWord(word: 'pollution', phonetic: '/pəˈluːʃn/', meaning: '污染', example: 'Air pollution is a big problem.', exampleTranslation: '空气污染是个大问题。'),
      EnglishWord(word: 'recycle', phonetic: '/ˌriːˈsaɪkl/', meaning: '回收利用', example: 'We should recycle paper.', exampleTranslation: '我们应该回收纸张。'),
      EnglishWord(word: 'energy', phonetic: '/ˈenədʒi/', meaning: '能源', example: 'Solar energy is clean.', exampleTranslation: '太阳能是清洁能源。'),
      EnglishWord(word: 'technology', phonetic: '/tekˈnɒlədʒi/', meaning: '技术', example: 'Technology changes our lives.', exampleTranslation: '技术改变我们的生活。'),
      EnglishWord(word: 'computer', phonetic: '/kəmˈpjuːtə/', meaning: '电脑', example: 'I use a computer every day.', exampleTranslation: '我每天用电脑。'),
      EnglishWord(word: 'internet', phonetic: '/ˈɪntənet/', meaning: '互联网', example: 'The internet connects people.', exampleTranslation: '互联网连接人们。'),
      EnglishWord(word: 'robot', phonetic: '/ˈrəʊbɒt/', meaning: '机器人', example: 'Robots can help people.', exampleTranslation: '机器人可以帮助人们。'),
      EnglishWord(word: 'science', phonetic: '/ˈsaɪəns/', meaning: '科学', example: 'I love science class.', exampleTranslation: '我喜欢科学课。'),
      EnglishWord(word: 'experiment', phonetic: '/ɪkˈsperɪmənt/', meaning: '实验', example: 'We did a science experiment.', exampleTranslation: '我们做了一个科学实验。'),
    ],
  };

  static List<EnglishWord> getWordsByGrade(int grade) {
    return wordsByGrade[grade] ?? wordsByGrade[3]!;
  }
}

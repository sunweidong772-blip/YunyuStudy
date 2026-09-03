class EnglishEssay {
  final String title;
  final String titleCn;
  final int grade;
  final String wordCount;
  final String content;
  final String translation;
  final String outline;

  EnglishEssay({required this.title, required this.titleCn, required this.grade, required this.wordCount, required this.content, required this.translation, required this.outline});
}

class EnglishEssayData {
  static final List<EnglishEssay> essays = [
    // 三年级
    EnglishEssay(
      title: 'My Family',
      titleCn: '我的家庭',
      grade: 3,
      wordCount: '50词',
      content: 'I have a happy family. There are three people in my family: my father, my mother and me. My father is a doctor. He is tall and strong. My mother is a teacher. She is kind and beautiful. I am a student. I love my family very much.',
      translation: '我有一个幸福的家庭。我家有三口人：爸爸、妈妈和我。我的爸爸是一名医生，他又高又壮。我的妈妈是一名老师，她既善良又美丽。我是一名学生。我非常爱我的家庭。',
      outline: '1. 开头：介绍家庭有几口人\n2. 中间：分别介绍爸爸、妈妈的职业和外貌\n3. 结尾：表达对家庭的爱',
    ),
    EnglishEssay(
      title: 'My Best Friend',
      titleCn: '我最好的朋友',
      grade: 3,
      wordCount: '50词',
      content: 'My best friend is Lily. She is a nice girl. She has long hair and big eyes. She likes reading books and drawing pictures. We go to school together every day. We often play games after class. I am very happy to have her as my friend.',
      translation: '我最好的朋友是莉莉。她是一个好女孩。她有长长的头发和大大的眼睛。她喜欢看书和画画。我们每天一起上学。我们经常课后一起玩游戏。我很高兴有她这样的朋友。',
      outline: '1. 开头：介绍最好的朋友是谁\n2. 中间：描述朋友的外貌、爱好，以及一起做的事\n3. 结尾：表达有这个朋友很开心',
    ),
    // 四年级
    EnglishEssay(
      title: 'My Favorite Season',
      titleCn: '我最喜欢的季节',
      grade: 4,
      wordCount: '70词',
      content: 'There are four seasons in a year: spring, summer, autumn and winter. My favorite season is spring. In spring, the weather is warm and sunny. Trees turn green and flowers bloom everywhere. Birds sing in the trees. I can fly kites with my friends in the park. I also like to go hiking with my family. Spring is a beautiful season.',
      translation: '一年有四个季节：春天、夏天、秋天和冬天。我最喜欢的季节是春天。春天，天气温暖晴朗。树木变绿了，到处都开满了花。鸟儿在树上唱歌。我可以和朋友们在公园放风筝。我也喜欢和家人一起去远足。春天是一个美丽的季节。',
      outline: '1. 开头：介绍一年有四季，点明最喜欢春天\n2. 中间：描述春天的天气、景色，以及春天可以做的活动\n3. 结尾：总结春天很美丽',
    ),
    EnglishEssay(
      title: 'A Happy Day',
      titleCn: '快乐的一天',
      grade: 4,
      wordCount: '70词',
      content: 'Last Sunday, I had a very happy day. In the morning, I went to the zoo with my parents. We saw many animals, like pandas, tigers and elephants. The pandas were so cute! In the afternoon, we had a picnic in the park. My mother made delicious sandwiches. In the evening, we watched a movie together. What a happy day it was!',
      translation: '上个星期天，我度过了非常快乐的一天。早上，我和爸爸妈妈去了动物园。我们看到了很多动物，比如熊猫、老虎和大象。熊猫太可爱了！下午，我们在公园野餐。妈妈做了美味的三明治。晚上，我们一起看了电影。多么快乐的一天啊！',
      outline: '1. 开头：点明时间和事件\n2. 中间：按时间顺序描述早上、下午、晚上做的事\n3. 结尾：感叹这是快乐的一天',
    ),
    // 五年级
    EnglishEssay(
      title: 'My Dream',
      titleCn: '我的梦想',
      grade: 5,
      wordCount: '80词',
      content: 'Everyone has a dream. My dream is to become a scientist when I grow up. I want to be a scientist because I am very interested in science. I like doing experiments and discovering new things. To make my dream come true, I must study hard at school. I should read more science books and learn from my teachers. I believe that if I work hard, my dream will come true one day.',
      translation: '每个人都有梦想。我的梦想是长大后成为一名科学家。我想成为科学家是因为我对科学非常感兴趣。我喜欢做实验和发现新事物。为了实现我的梦想，我必须在学校努力学习。我应该多读科学书籍，向老师学习。我相信只要我努力，我的梦想总有一天会实现。',
      outline: '1. 开头：每个人都有梦想，点明自己的梦想\n2. 中间：说明为什么有这个梦想，以及如何实现\n3. 结尾：表达信心，相信梦想会实现',
    ),
    EnglishEssay(
      title: 'How to Keep Healthy',
      titleCn: '如何保持健康',
      grade: 5,
      wordCount: '80词',
      content: 'Health is very important to everyone. Here are some ways to keep healthy. First, we should eat healthy food. We need to eat more vegetables and fruits, and less junk food. Second, we should exercise every day. We can run, swim or play ball games. Third, we should sleep at least eight hours every night. Finally, we should keep a happy mood. If we follow these rules, we will be healthy and happy.',
      translation: '健康对每个人都很重要。这里有一些保持健康的方法。首先，我们应该吃健康的食物。我们需要多吃蔬菜和水果，少吃垃圾食品。其次，我们应该每天锻炼。我们可以跑步、游泳或打球。第三，我们每晚应该至少睡八个小时。最后，我们应该保持愉快的心情。如果我们遵循这些规则，我们就会健康快乐。',
      outline: '1. 开头：健康很重要，引出保持健康的方法\n2. 中间：用First/Second/Third/Finally分点说明方法\n3. 结尾：总结遵循这些方法就会健康',
    ),
    // 六年级
    EnglishEssay(
      title: 'My School Life',
      titleCn: '我的校园生活',
      grade: 6,
      wordCount: '100词',
      content: 'My school life is very interesting and colorful. I go to school from Monday to Friday. We have many subjects, such as Chinese, math, English, science and PE. My favorite subject is English because it is very useful. After class, I often play basketball with my classmates. We also have many interesting activities, like the sports meeting and the art festival. I have made many good friends at school. We study together and play together. I enjoy my school life very much.',
      translation: '我的校园生活非常有趣和丰富多彩。我从周一到周五上学。我们有很多科目，比如语文、数学、英语、科学和体育。我最喜欢的科目是英语，因为它非常有用。课后，我经常和同学们打篮球。我们还有很多有趣的活动，比如运动会和艺术节。我在学校交了很多好朋友。我们一起学习，一起玩耍。我非常享受我的校园生活。',
      outline: '1. 开头：总述校园生活丰富多彩\n2. 中间：介绍学习的科目、最喜欢的科目、课后活动、学校活动、朋友\n3. 结尾：表达对校园生活的喜爱',
    ),
    EnglishEssay(
      title: 'Protecting the Environment',
      titleCn: '保护环境',
      grade: 6,
      wordCount: '100词',
      content: 'The environment is very important to us. However, pollution is becoming more and more serious. We should do something to protect the environment. First, we should plant more trees to make the air clean. Second, we should save water and electricity. We can turn off the lights when we leave a room. Third, we should use reusable bags instead of plastic bags. Fourth, we should sort the rubbish and recycle useful things. Everyone should do their part to protect the environment. If we all work together, our world will become more beautiful.',
      translation: '环境对我们非常重要。然而，污染正变得越来越严重。我们应该做些事情来保护环境。首先，我们应该种更多的树来净化空气。其次，我们应该节约用水和用电。离开房间时可以关灯。第三，我们应该使用可重复使用的袋子而不是塑料袋。第四，我们应该垃圾分类，回收有用的东西。每个人都应该尽自己的一份力来保护环境。如果我们一起努力，我们的世界会变得更加美丽。',
      outline: '1. 开头：环境重要，但污染严重，引出要保护环境\n2. 中间：用First/Second/Third/Fourth分点说明具体做法\n3. 结尾：呼吁大家一起努力，世界会更美丽',
    ),
  ];

  static List<EnglishEssay> getEssaysByGrade(int grade) {
    return essays.where((e) => e.grade == grade).toList();
  }
}

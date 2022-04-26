import 'package:flutter/material.dart';
import 'package:triqui/iu/theme/color.dart';
import 'package:triqui/utils/game_logic.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  String lastValue = "X";
  bool gameOver = false;
  int turn = 0;
  String result = "";
  List<int> scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];

  newGame() {
    game.board = Game.initGameBoard();
    lastValue = "X";
    gameOver = false;
    turn = 0;
    result = "";
    scoreboard = [0, 0, 0, 0, 0, 0, 0, 0];
  }

  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
  }

  @override
  Widget build(BuildContext context) {
    double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Es turno para: $lastValue".toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 38,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
          SizedBox(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
              crossAxisCount: Game.boardlenth ~/ 3,
              padding: const EdgeInsets.all(16.0),
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              children: List.generate(Game.boardlenth, (index) {
                return InkWell(
                  onTap: gameOver
                      ? null
                      : () {
                          if (game.board![index] == "") {
                            setState(() {
                              game.board![index] = lastValue;
                              turn++;
                              gameOver = game.winnercheck(
                                  lastValue, index, scoreboard, 3);
                              if (gameOver) {
                                result = "$lastValue es el ganador";
                              } else if (!gameOver && turn == 9) {
                                result = "Empate";
                              }
                              if (lastValue == "X") {
                                lastValue = "O";
                              } else {
                                lastValue = "X";
                              }
                            });
                          }
                        },
                  child: Container(
                    width: Game.blocSize,
                    height: Game.blocSize,
                    decoration: BoxDecoration(
                      color: MainColor.secondaryColor,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Center(
                      child: Text(
                        game.board![index],
                        style: TextStyle(
                          color: game.board![index] == "X"
                              ? Colors.blue[700]
                              : Colors.redAccent[700],
                          fontSize: 64.0,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Text(
            result,
            style: const TextStyle(color: Colors.white, fontSize: 30.0),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                newGame();
              });
            },
            icon: const Icon(Icons.replay),
            label: const Text("Repetir el juego"),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 30), //You can use EdgeInsets like above
            child: const Text(
              "Creado por: Jose Torres",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

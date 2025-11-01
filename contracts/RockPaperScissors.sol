// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RockPaperScissors {
    enum Move { Rock, Paper, Scissors }
    enum Result { Win, Lose, Draw }

    struct Game {
        address player;
        Move playerMove;
        Move computerMove;
        Result result;
    }

    Game[] public games;

    event GamePlayed(address indexed player, Move playerMove, Move computerMove, Result result);

    // Người chơi chọn: 0 = Rock, 1 = Paper, 2 = Scissors
    function play(uint8 _playerMove) external returns (Result) {
        require(_playerMove <= 2, "Invalid move");

        uint8 computerMove = uint8(uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 3);

        Result result = determineWinner(_playerMove, computerMove);

        // Lưu lịch sử
        games.push(Game({
            player: msg.sender,
            playerMove: Move(_playerMove),
            computerMove: Move(computerMove),
            result: result
        }));

        emit GamePlayed(msg.sender, Move(_playerMove), Move(computerMove), result);

        return result;
    }

    function determineWinner(uint8 _player, uint8 _computer) internal pure returns (Result) {
        if (_player == _computer) return Result.Draw;
        if (
            (_player == 0 && _computer == 2) ||
            (_player == 1 && _computer == 0) ||
            (_player == 2 && _computer == 1)
        ) {
            return Result.Win;
        } else {
            return Result.Lose;
        }
    }

    function getLastGame(address _player) external view returns (Move, Move, Result) {
        for (uint i = games.length; i > 0; i--) {
            if (games[i - 1].player == _player) {
                Game memory g = games[i - 1];
                return (g.playerMove, g.computerMove, g.result);
            }
        }
        revert("No game found");
    }
}

// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint256 private seed;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    /*
     * Este é um endereço => uint mapping, o que significa que eu posso associar o endereço com um número!
     * Neste caso, armazenarei o endereço com o últimoo horário que o usuário tchauzinhou.
     */
    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("Contrato construido!");
        /*
         * Define a semente inicial
         */
        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        /*
         * Precisamos garantir que o valor corrente de timestamp é ao menos 15 minutos maior que o último timestamp armazenado
         */
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Deve aguardar 30 segundos antes de mandar um tchauzinho novamente."
        );

        /*
         * Atualiza o timestamp atual do usuário
         */
        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s tchauzinhou!", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        /*
         * Gera uma nova semente para o próximo usuário que acenar
         */
        seed = (block.difficulty + block.timestamp + seed) % 100;

        if (seed <= 50) {
            console.log("%s venceu!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Tentando sacar mais dinheiro que o contrato possui."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Falhou em sacar dinheiro do contrato.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        return totalWaves;
    }
}

// pragma solidity ^0.8.0;

// import "hardhat/console.sol";

// contract WavePortal { 
//     uint256 totalWaves;
//     /*
//      * Um pouco de mágica, use o Google para entender o que são eventos em Solidity!
//      */
//     event NewWave(address indexed from, uint256 timestamp, string message);

//       /*
//      * Crio um struct Wave.
//      * Um struct é basicamente um tipo de dados customizado onde nós podemos customizar o que queremos armazenar dentro dele
//      */
//     struct Wave {
//         address waver; // Endereço do usuário que deu tchauzinho
//         string message; // Mensagem que o usuário envio
//         uint256 timestamp; // Data/hora de quando o usuário tchauzinhou.
//     }

//      /*
//      * Declara a variável waves que permite armazenar um array de structs.
//      * Isto que me permite armazenar todos os tchauzinhos que qualquer um tenha me enviado!
//      */
//      Wave[] waves;

//     constructor() {
//         console.log("EU SOU UM CONTRATO INTELIGENTE. POG.");
//     }

//     /*
//      * Você notará que eu mudei um pouco a função de tchauzinho e agora requer uma string chamada _message. Esta é a mensagem que o nosso usuário enviou pelo frontend!
//      */

//     function wave(string memory _message) public {
//         totalWaves += 1;
//         console.log("%s deu tchauzinho!", msg.sender);

//          /*
//          * Aqui é onde eu efetivamenet armazeno o tchauzinho no array.
//          */
//          waves.push(Wave(msg.sender, _message, block.timestamp));

//          /*
//          * Eu adicionei algo novo aqui. Use o Google para tentar entender o que é e depois me conte o que aprendeu em #general-chill-chat
//          */
//          emit NewWave(msg.sender, block.timestamp, _message);

//          uint256 prizeAmount = 0.0001 ether;
//          require(
//              prizeAmount <= address(this).balance,
//              "Tentando sacar mais dinheiro que o contrato possui."
//          );
//          (bool success,) = (msg.sender).call{value: prizeAmount}("");
//          require(success, "Falhou em sacar dinheiro do contrato.");

//     }

//     /*
//      * Adicionei uma função getAllWaves que retornará os tchauzinhos.
//      * Isso permitirá recuperar os tchauzinhos a partir do nosso site!
//      */
//      function getAllWaves() public view returns (Wave[] memory) {
//         return waves;
//     }

//     function getTotalWaves() public view returns (uint256) {
//         // Opcional: Adicione esta linha se você quer ver o contrato imprimir o valor!
//         // Também imprimirá em run.js.
//          console.log("Temos %d tchauzinhos no total!", totalWaves);
//         return totalWaves;
//     }
// }
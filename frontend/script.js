const CONTRACT_ADDRESS = "0x3ea21c67cA5Ad71d39d2240643b268D3F31E7D4C";
const ABI = [
  {
    "inputs":[{"internalType":"uint8","name":"_playerMove","type":"uint8"}],
    "name":"play",
    "outputs":[{"internalType":"enum RockPaperScissors.Result","name":"","type":"uint8"}],
    "stateMutability":"nonpayable",
    "type":"function"
  }
];

let provider, signer, contract;

async function connectWallet() {
  if (window.ethereum) {
    await ethereum.request({ method: "eth_requestAccounts" });
    provider = new ethers.providers.Web3Provider(window.ethereum);
    signer = provider.getSigner();
    contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
    document.getElementById("connectButton").style.display = "none";
    document.getElementById("gameArea").style.display = "block";
  } else {
    alert("MetaMask not found! Please install it.");
  }
}

async function play(move) {
  try {
    const tx = await contract.play(move);
    document.getElementById("result").innerText = "Playing...";
    await tx.wait();
    document.getElementById("result").innerText = "✅ Game played! Check your transaction.";
  } catch (err) {
    console.error(err);
    alert("❌ Transaction failed!");
  }
}

document.getElementById("connectButton").addEventListener("click", connectWallet);

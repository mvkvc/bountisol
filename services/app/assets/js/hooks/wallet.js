// import { Header, Payload, SIWS } from "@web3auth/sign-in-with-solana";

export const Wallet = {
    mounted() {
      window.addEventListener(`phx:test-wallet-hook`, (e) => {
        this.pushEventTo("#wallet", "test-wallet-hook", {})
      })
    }
};

export default Wallet;

// function createSolanaMessage(address, statement, nonce) {
//     const header = new Header();
//     header.t = "sip99";
//     const payload = new Payload();
//     payload.domain = domain;
//     payload.uri = origin;
//     payload.address = address;
//     payload.statement = statement;
//     payload.nonce = nonce
//     payload.version = "1";
//     payload.chainId = "1";
//     message = new SIWS({
//       header,
//       payload,
//     });

//     return message.prepareMessage();
// }

// function connectWallet() {
//     try {
//       window.solana.connect().then((resp) => {
//         // Successful connection
//         // Get the publicKey (string)
//         publicKey = resp.publicKey.toString();
//       });
//     } catch (error) {
//       console.log("User rejected the request." + error);
//     }
//   };

// async function signInWithSolana() {
//     const message = createSolanaMessage(publicKey, "Sign in with Solana to the app.");
//     const encodedMessage = new TextEncoder().encode(message);
//     const signedMessage = await window.solana.request({
//       method: "signMessage",
//       params: {
//         message: encodedMessage,
//         display: "text",
//       },
//     });
//     document.getElementById("postSignIn").style = "display:block";
//     document.getElementById("signature").value = signedMessage.signature;
//     document.getElementById("publicKey").value = signedMessage.publicKey;
//   }

// async function verifySignature() {
//     const signatureString = document.getElementById("signature").value;
//     const publicKey = document.getElementById("publicKey").value;
//     const signature = {
//       t: "sip99",
//       s: signatureString,
//     };
//     const payload = message.payload;
//     payload.address = publicKey;
//     const resp = await message.verify({ payload, signature });
//     if (resp.success == true) {
//       swal("Success", "Signature Verified", "success");
//     } else {
//       swal("Error", resp.error.type, "error");
//     }
//   }

// import {ethers} from "ethers";

// const web3Provider = new ethers.providers.Web3Provider(window.ethereum)

// export const Wallet = {
//     mounted() {
//         let signer = web3Provider.getSigner()

//         window.addEventListener('load', async () => {
//             console.log("load")
//             web3Provider.listAccounts().then((accounts) => {
//                 if (accounts.length > 0) {
//                     signer = web3Provider.getSigner();
//                     signer.getAddress().then((address) => {
//                         this.pushEvent("account-check", {connected: true, current_wallet_address: address})
//                     });
//                 }
//                 else {
//                     this.pushEvent("account-check", {connected: false, current_wallet_address: null})
//                 }
//             })
//         })

//         window.addEventListener(`phx:has-wallet`, (e) => {
//             let has_wallet = false
//             if (window.ethereum) {
//                 has_wallet = true
//             }
//             console.log("has_wallet", has_wallet)
//             this.pushEvent("has-wallet", {has_wallet: has_wallet})
//         })

//         window.addEventListener(`phx:get-current-wallet`, (e) => {
//             console.log("phx:get-current-wallet")
//             signer.getAddress().then((address) => {
//                 const message = `You are signing this message to sign in with Akashi. Nonce: ${e.detail.nonce}`
//                 signer.signMessage(message).then((signature) => {
//                     this.pushEvent("verify-signature", {public_address: address, signature: signature})

//                     return;
//                 })
//             })
//         })

//         window.addEventListener(`phx:connect-wallet`, (e) => {
//             console.log("phx:connect-wallet")
//             web3Provider.provider.request({method: 'eth_requestAccounts'}).then((accounts) => {
//               if (accounts.length > 0) {
//                 signer.getAddress().then((address) => {
//                     this.pushEvent("wallet-connected", {public_address: address})
//                 });
//               }
//             }, (error) => console.log(error))
//         })
//     },
// }
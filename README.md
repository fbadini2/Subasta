# Subasta

Smart contract written for the Ethereum blockchain, implementing an online public auction.

This contract implements a simple yet complete auction using Solidity. It supports multiple bids, automatic time extension, commission management, refunds, and more.

## Main features

- Auction with adjustable time limit.
- Each new offer extends the remaining time by 10 minutes.
- Record of all offers and bidders.
- Refund to unsuccessful bidders with a 2% commission.
- Events to notify users in real time.
- Secure access through modifiers (`onlyOwner`, `activeAuction`, etc.).
- Function for the owner to withdraw accumulated commissions.

---

## Use of Remix

1. Open [Remix](https://remix.ethereum.org)
2. Create an Auction.sol file and paste the contract.
3. Compile it using version `^0.8.0`.
4. Deploy the contract from the "Deploy & Run" tab:
   - Enter initial duration (in seconds) as a parameter.
5. Simulate different bidders using the available accounts.
6. Call `endAuction()` to end the auction and distribute funds.
7. Each losing bidder can call `withdraw()` to receive their money.


## License

This project is published under the MIT License. You may freely use, modify, or distribute this agreement, providing proper credit is given to the original author.

---

## Autor

Developed for educational and experimental purposes by Fabián Badini

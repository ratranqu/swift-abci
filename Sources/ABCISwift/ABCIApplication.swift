//===----------------------------------------------------------------------===//
//
// This source file is part of the ABCISwift open source project
//
// Copyright (c) 2019 ABCISwift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of ABCISwift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import Foundation

/// ABCI apps should comply to the following protocol
public protocol ABCIApplication {
    
    /// Called only once usually at genesis or when blockheight == 0
    /// see info()

    /// - Parameter time: The time of initialisation.
    /// - Parameter chainId: The unique identifier of the chain.
    /// - Parameter consensusParams: Starting Consensus Parameters.
    /// - Parameter updates: Array of Validator Updates.
    /// - Parameter appStateBytes: Initial application state.
    /// - Returns: The message sent with the command.
    func initChain(_ time: Date, _ chainId: String, _ consensusParams: ConsensusParams, _ updates: [ValidatorUpdate], _ appStateBytes: Data) -> ResponseInitChain

    /// Called by ABCI when the app first starts. A stateful application
    /// should alway return the last blockhash and blockheight to prevent Tendermint
    /// replaying from the beginning. If blockheight == 0, Tendermint will call init_chain
    /// - Parameter version: The message to echo.
    /// - Parameter blockVersion: The message to echo.
    /// - Parameter p2pVersion: The message to echo.
    /// - Returns: The message sent with the command.
    func info(_ version: String, _ blockVersion: UInt64, _ p2pVersion: UInt64) -> ResponseInfo

    /// Echos the provided message through the Redis instance.
    ///
    /// - Parameter message: The message to echo.
    /// - Returns: The message sent with the command.
    func echo(_ message: String) -> ResponseEcho
    
    /// Flushes the server.
    /// Usually sent after every message.
    func flush()
    
    /// Can be used to set key value pairs in storage. Not always used.
    ///
    /// - Parameter key:
    /// - Parameter value:
    /// - Returns:
    func setOption(_ key: String, _ value: String) -> ResponseSetOption
    
    /// Process the tx and apply state changes.
    /// This is called via the consensus connection.
    /// A non-zero response code implies an error and will reject the tx
    ///
    /// - Parameter tx:
    /// - Returns:
    func deliverTx(_ tx: Data) -> ResponseDeliverTx

    /// Use to validate incoming transactions.  If Result.ok is returned,
    /// the Tx will be added to Tendermint's mempool for consideration in a block.
    /// A non-zero response code implies an error and will reject the tx
    ///
    /// - Parameter tx: Data: The request transaction bytes
    /// - Parameter  chktxt: CheckTxType: What type of `CheckTx` request is this? At present, there are two possible values: `CheckTx_Unchecked` (the default, which says that a full check is required), and `CheckTx_Checked` (when the mempool is initiating a normal recheck of a transaction).
    /// - Returns:
    func checkTx(_ tx: Data, _ chktxt: CheckTxType) -> ResponseCheckTx
    
    /// This is commonly used to query the state of the application.
    /// A non-zero 'code' in the response is used to indicate and error.
    ///
    /// - Parameter q:
    /// - Returns:
    func query(_ q: Query) -> ResponseQuery
    
    /// Called during the consensus process.  The overall flow is:
    /// begin_block()
    /// for each tx:
    ///    deliver_tx(tx)
    ///    end_block()
    /// commit()
    ///
    /// - Parameter hash:
    /// - Parameter header:
    /// - Parameter lastCommitInfo:
    /// - Parameter byzantineValidators:
    /// - Returns:
    func beginBlock(_ hash: Data, _ header: Header, _ lastCommitInfo: LastCommitInfo, _ byzantineValidators: [Evidence]) -> ResponseBeginBlock
    
    /// Called at the end of processing. If this is a stateful application
    /// you can use the height from here to record the last_block_height
    /// Consensus parameters update
    ///
    /// - Parameter height:
    /// - Returns:
    func endBlock(_ height: Int64) -> ResponseEndBlock
    
    /// Called to get the result of processing transactions.  If this is a
    /// stateful application using a Merkle Tree, this method should return
    /// the root hash of the Merkle Tree in the Result data field
    ///
    /// - Returns:
    func commit() -> ResponseCommit
}

extension ABCIApplication {
    /// Flush default implementation.
    public func flush() {}
}

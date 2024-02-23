// Sources flattened with hardhat v2.20.1 https://hardhat.org

// SPDX-License-Identifier: MIT

// File contracts/tokens/IERC404.sol

// Original license: SPDX_License_Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC404 {
    /**
     * @dev Emitted when `amount` token is transferred from `from` to `to`.
     */
    event ERC20Transfer(address indexed from, address indexed to, uint256 amount);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `amount` token.
     */
    event ERC20Approval(address indexed owner, address indexed spender, uint256 amount);

    /**
     * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
     */
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
     */
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);

    /**
     * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
     */
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    /**
     * @dev Returns the number of tokens in ``owner``'s account.
     */
    function balanceOf(address owner) external view returns (uint256 balance);

    /**
     * @dev Returns the owner of the `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Returns the account approved for `amountOrId` token.
     *
     * Requirements:
     *
     * - `amountOrId` must exist.
     */
    function getApproved(uint256 amountOrId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);

    /**
     * @dev Gives permission to `to` to transfer `amountOrId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `amountOrId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 amountOrId) external;

    /**
     * @dev Approve or remove `operator` as an operator for the caller.
     * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
     *
     * Requirements:
     *
     * - The `operator` cannot be the caller.
     *
     * Emits an {ApprovalForAll} event.
     */
    function setApprovalForAll(address operator, bool _approved) external;

    /**
     * @dev Safely transfers `amountOrId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `amountOrId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 amountOrId
    ) external;

    /**
     * @dev Safely transfers `amountOrId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `amountOrId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 amountOrId,
        bytes calldata data
    ) external;

    /**
     * @dev Transfers `amountOrId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `amountOrId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amountOrId
    ) external;
}

/**
 * @title ERC721 token receiver interface
 * @dev Interface for any contract that wants to support safeTransfers
 * from ERC721 asset contracts.
 */
interface IERC721Receiver {
    /**
     * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
     * by `operator` from `from`, this function is called.
     *
     * It must return its Solidity selector to confirm the token transfer.
     * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
     *
     * The selector can be obtained in Solidity with `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
}

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among others, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize, which returns 0 for contracts in
        // construction, since the code is only stored at the end of the
        // constructor execution.

        uint256 size;
        assembly {
            size := extcodesize(account)
        }
        return size > 0;
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason, it is bubbled up by this
     * function (like regular Solidity function calls).
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     *
     * _Available since v3.1._
     */
    function functionCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return functionCall(target, data, "Address: low-level call failed");
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
     * `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        return
            functionCallWithValue(
                target,
                data,
                value,
                "Address: low-level call with value failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
     * with `errorMessage` as a fallback revert reason when `target` reverts.
     *
     * _Available since v3.1._
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(
            address(this).balance >= value,
            "Address: insufficient balance for call"
        );
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data)
        internal
        view
        returns (bytes memory)
    {
        return
            functionStaticCall(
                target,
                data,
                "Address: low-level static call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal view returns (bytes memory) {
        require(isContract(target), "Address: static call to non-contract");

        (bool success, bytes memory returndata) = target.staticcall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data)
        internal
        returns (bytes memory)
    {
        return
            functionDelegateCall(
                target,
                data,
                "Address: low-level delegate call failed"
            );
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(
        address target,
        bytes memory data,
        string memory errorMessage
    ) internal returns (bytes memory) {
        require(isContract(target), "Address: delegate call to non-contract");

        (bool success, bytes memory returndata) = target.delegatecall(data);
        return _verifyCallResult(success, returndata, errorMessage);
    }

    function _verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) private pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}

abstract contract ERC404 is IERC404, Ownable {
  using Address for address;

  /// @dev Token _name
  string private _name;

  /// @dev Token _symbol
  string private _symbol;

  /// @dev Decimals for fractional representation
  uint8 private immutable _decimals;

  /// @dev Total supply in fractionalized representation
  uint256 private immutable _totalSupply;

  /// @dev Balance of user in fractional representation
  mapping(address => uint256) private _balanceOf;

  /// @dev Allowance of user in fractional representation
  mapping(address => mapping(address => uint256)) private _allowance;

  /// @dev Approval in native representaion
  mapping(uint256 => address) private _getApproved;

  /// @dev Approval for all in native representation
  mapping(address => mapping(address => bool)) private _isApprovedForAll;

  /// @dev Current mint counter, monotonically increasing to ensure accurate ownership
  uint256 private _minted;

  /// @dev Addresses whitelisted from minting / burning for gas savings (pairs, routers, etc)
  mapping(address => bool) private _whitelist;

  /// @dev Owner of id in native representation
  mapping(uint256 => address) private _ownerOf;

  /// @dev Array of owned ids in native representation
  mapping(address => uint256[]) private _owned;

  /// @dev Tracks indices for the _owned mapping
  mapping(uint256 => uint256) private _ownedIndex;

  constructor(
    string memory name_,
    string memory symbol_,
    uint8 decimals_,
    uint256 _totalNativeSupply,
    address _receiver
  ) {
    _name = name_;
    _symbol = symbol_;
    _decimals = decimals_;
    _totalSupply = _totalNativeSupply * (10 ** decimals_);
    _balanceOf[_receiver] = _totalNativeSupply * (10 ** decimals_);
  }

  /**
    * @dev Name.
    */
  function name() public view virtual returns (string memory) {
  return _name;
  }

  /**
    * @dev Symbol.
    */
  function symbol() public view virtual returns (string memory) {
    return _symbol;
  }

  /**
    * @dev See decimals.
    */
  function decimals() public view virtual returns (uint8) {
    return _decimals;
  }

  /**
    * @dev TotalSupply.
    */
  function totalSupply() public view virtual returns (uint256) {
    return _totalSupply;
  }

  /**
    * @dev Minted.
    */
  function minted() public view virtual returns (uint256) {
    return _minted;
  }

  /**
    * @dev Whitelist.
    */
  function whitelist(address user) public view virtual returns (bool) {
    return _whitelist[user];
  }

  /**
    * @dev See {IERC404-balanceOf}.
    */
  function balanceOf(address owner) public view virtual override returns (uint256) {
    return _balanceOf[owner];
  }

  /// @notice Function to find owner of a given native token
  function ownerOf(uint256 tokenId) public view virtual override returns (address) {
    address owner = _ownerOf[tokenId];
    require(owner != address(0), "ERC404: owner query for nonexistent token");
    return owner;
  }

  /**
    * @dev See {IERC404-allowance}.
    */
  function allowance(address owner, address spender) public view virtual override returns (uint256) {
    return _allowance[owner][spender];
  }

  /**
    * @dev See {IERC404-getApproved}.
    */
  function getApproved(uint256 amountOrId) public view virtual override returns (address) {
    return _getApproved[amountOrId];
  }

  /**
    * @dev See {IERC404-isApprovedForAll}.
    */
  function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
    return _isApprovedForAll[owner][operator];
  }

  /// @notice tokenURI must be implemented by child contract
  function tokenURI(uint256 id) public view virtual returns (string memory);

  /// @notice Initialization function to set pairs / etc
  ///         saving gas by avoiding mint / burn on unnecessary targets
  function setWhitelist(address target, bool state) public onlyOwner {
    _whitelist[target] = state;
  }

  /// @notice Function for token approvals
  /// @dev This function assumes id / native if amount less than or equal to current max id
  function approve(
    address spender,
    uint256 amountOrId
  ) public virtual override {
    if (amountOrId <= _minted && amountOrId > 0) {
      address owner = _ownerOf[amountOrId];

      require(spender != owner, "ERC404: approval to current owner");
      require(
        _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
        "ERC404: approve caller is not owner nor approved for all"
      );

      _getApproved[amountOrId] = spender;

      emit Approval(owner, spender, amountOrId);
    } else {
      _allowance[msg.sender][spender] = amountOrId;

      emit ERC20Approval(msg.sender, spender, amountOrId);
    }
  }

  /// @notice Function native approvals
  function setApprovalForAll(address operator, bool approved) public virtual override {
    _setApprovalForAll(operator, approved);
  }

  /// @notice Function for mixed transfers
  /// @dev This function assumes id / native if amount less than or equal to current max id
  function transferFrom(
    address from,
    address to,
    uint256 amountOrId
  ) public virtual override {
    if (amountOrId <= _minted) {
      require(_isApprovedOrOwner(_msgSender(), amountOrId), "ERC404: transfer caller is not owner nor approved");

      _balanceOf[from] -= _getUnit();

      unchecked {
        _balanceOf[to] += _getUnit();
      }

      _ownerOf[amountOrId] = to;
      delete _getApproved[amountOrId];

      // update _owned for sender
      uint256 updatedId = _owned[from][_owned[from].length - 1];
      _owned[from][_ownedIndex[amountOrId]] = updatedId;
      // pop
      _owned[from].pop();
      // update index for the moved id
      _ownedIndex[updatedId] = _ownedIndex[amountOrId];
      // push token to to owned
      _owned[to].push(amountOrId);
      // update index for to owned
      _ownedIndex[amountOrId] = _owned[to].length - 1;

      emit Transfer(from, to, amountOrId);
      emit ERC20Transfer(from, to, _getUnit());
    } else {
      uint256 allowed = _allowance[from][_msgSender()];

      if (allowed != type(uint256).max)
        _allowance[from][_msgSender()] = allowed - amountOrId;

      _transfer(from, to, amountOrId);
    }
  }

  /// @notice Function for fractional transfers
  function transfer(
    address to,
    uint256 amount
  ) public virtual returns (bool) {
    return _transfer(_msgSender(), to, amount);
  }

  /// @notice Function for native transfers with contract support
  function safeTransferFrom(
    address from,
    address to,
    uint256 id
  ) public virtual override {
    transferFrom(from, to, id);

    require(_checkOnERC721Received(from, to, id, ""), "ERC404: transfer to non ERC721Receiver implementer");
  }

  /// @notice Function for native transfers with contract support and callback data
  function safeTransferFrom(
    address from,
    address to,
    uint256 id,
    bytes calldata data
  ) public virtual override {
    transferFrom(from, to, id);

    require(_checkOnERC721Received(from, to, id, data), "ERC404: transfer to non ERC721Receiver implementer");
  }

  function _setApprovalForAll(address operator, bool approved) internal virtual {
    _isApprovedForAll[msg.sender][operator] = approved;

    emit ApprovalForAll(msg.sender, operator, approved);
  }

  function _isApprovedOrOwner(address spender, uint256 amountOrId) internal view virtual returns (bool) {
    address owner = _ownerOf[amountOrId];
    return (spender == owner || isApprovedForAll(owner, spender) || getApproved(amountOrId) == spender);
  }

  /**
    * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
    * The call is not executed if the target address is not a contract.
    *
    * @param from address representing the previous owner of the given token ID
    * @param to target address that will receive the tokens
    * @param tokenId uint256 ID of the token to be transferred
    * @param _data bytes optional data to send along with the call
    * @return bool whether the call correctly returned the expected magic value
    */
  function _checkOnERC721Received(
    address from,
    address to,
    uint256 tokenId,
    bytes memory _data
  ) private returns (bool) {
    if (to.isContract()) {
      try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
        return retval == IERC721Receiver.onERC721Received.selector;
      } catch (bytes memory reason) {
        if (reason.length == 0) {
          revert("ERC404: transfer to non ERC721Receiver implementer");
        } else {
          assembly {
            revert(add(32, reason), mload(reason))
          }
        }
      }
    } else {
      return true;
    }
  }

  /// @notice Internal function for fractional transfers
  function _transfer(
    address from,
    address to,
    uint256 amount
  ) internal returns (bool) {
    uint256 unit = _getUnit();
    uint256 balanceBeforeSender = _balanceOf[from];
    uint256 balanceBeforeReceiver = _balanceOf[to];

    _balanceOf[from] -= amount;

    unchecked {
      _balanceOf[to] += amount;
    }

    // Skip burn for certain addresses to save gas
    if (!_whitelist[from]) {
      uint256 tokens_to_burn = (balanceBeforeSender / unit) -
        (_balanceOf[from] / unit);
      for (uint256 i = 0; i < tokens_to_burn; i++) {
        _burn(from);
      }
    }

    // Skip minting for certain addresses to save gas
    if (!_whitelist[to]) {
      uint256 tokens_to_mint = (_balanceOf[to] / unit) -
        (balanceBeforeReceiver / unit);
      for (uint256 i = 0; i < tokens_to_mint; i++) {
        _mint(to);
      }
    }

    emit ERC20Transfer(from, to, amount);
    return true;
  }

  // Internal utility logic
  function _getUnit() internal view returns (uint256) {
    return 10 ** _decimals;
  }

  function _mint(address to) internal virtual {
    require(to != address(0), "ERC404: mint to the zero address");
    unchecked {
      _minted++;
    }

    uint256 id = _minted;
    require(_ownerOf[id] == address(0), "ERC404: token already minted");
    
    _ownerOf[id] = to;
    _owned[to].push(id);
    _ownedIndex[id] = _owned[to].length - 1;

    emit Transfer(address(0), to, id);
  }

  function _burn(address from) internal virtual {
    require(from != address(0), "ERC404: burn from the zero address");

    uint256 id = _owned[from][_owned[from].length - 1];
    _owned[from].pop();
    delete _ownedIndex[id];
    delete _ownerOf[id];
    delete _getApproved[id];

    emit Transfer(from, address(0), id);
  }
}


// File contracts/utils/Strings.sol

// Original license: SPDX_License_Identifier: MIT

pragma solidity ^0.8.0;

/**
 * @dev String operations.
 */
library Strings {
    /**
     * @dev Converts a `uint256` to its ASCII `string` representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        uint256 index = digits - 1;
        temp = value;
        while (temp != 0) {
            buffer[index--] = bytes1(uint8(48 + temp % 10));
            temp /= 10;
        }
        return string(buffer);
    }
}

contract Token is ERC404 {
  string public baseTokenURI;

  event BaseTokenURIChanged(string baseTokenURI);

  constructor(
    string memory name,
    string memory symbol,
    uint8 decimals,
    uint256 totalSupply,
    address receiver
  ) ERC404(name, symbol, decimals, totalSupply, receiver) {}

  function tokenURI(uint256 id) public view override returns (string memory) {
    return
      string(
        abi.encodePacked(baseTokenURI, Strings.toString(id), ".json")
      );
  }

  function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
    baseTokenURI = _baseTokenURI;
    emit BaseTokenURIChanged(_baseTokenURI);
  }
}

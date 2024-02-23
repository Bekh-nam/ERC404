// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./IERC404.sol";
import "./IERC721Receiver.sol";
import "../utils/Ownable.sol";
import "../utils/Address.sol";

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


// File @openzeppelin/contracts/utils/introspection/IERC165.sol@v4.7.3

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC165 standard, as defined in the
 * https://eips.ethereum.org/EIPS/eip-165[EIP].
 *
 * Implementers can declare support of contract interfaces, which can then be
 * queried by others ({ERC165Checker}).
 *
 * For an implementation, see {ERC165}.
 */
interface IERC165 {
    /**
     * @dev Returns true if this contract implements the interface defined by
     * `interfaceId`. See the corresponding
     * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
     * to learn more about how these ids are created.
     *
     * This function call must use less than 30 000 gas.
     */
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC721/IERC721.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)

pragma solidity ^0.8.0;

/**
 * @dev Required interface of an ERC721 compliant contract.
 */
interface IERC721 is IERC165 {
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

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    /**
     * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
     * are aware of the ERC721 protocol to prevent tokens from being forever locked.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must exist and be owned by `from`.
     * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
     * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
     *
     * Emits a {Transfer} event.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Transfers `tokenId` token from `from` to `to`.
     *
     * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
     *
     * Requirements:
     *
     * - `from` cannot be the zero address.
     * - `to` cannot be the zero address.
     * - `tokenId` token must be owned by `from`.
     * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    /**
     * @dev Gives permission to `to` to transfer `tokenId` token to another account.
     * The approval is cleared when the token is transferred.
     *
     * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
     *
     * Requirements:
     *
     * - The caller must own the token or be an approved operator.
     * - `tokenId` must exist.
     *
     * Emits an {Approval} event.
     */
    function approve(address to, uint256 tokenId) external;

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
     * @dev Returns the account approved for `tokenId` token.
     *
     * Requirements:
     *
     * - `tokenId` must exist.
     */
    function getApproved(uint256 tokenId) external view returns (address operator);

    /**
     * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
     *
     * See {setApprovalForAll}
     */
    function isApprovedForAll(address owner, address operator) external view returns (bool);
}


// File @openzeppelin/contracts/token/ERC20/IERC20.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}


// File @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol@v4.7.3


// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)

pragma solidity ^0.8.0;

/**
 * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
 * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
 *
 * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
 * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
 * need to send a transaction, and thus is not required to hold Ether at all.
 */
interface IERC20Permit {
    /**
     * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
     * given ``owner``'s signed approval.
     *
     * IMPORTANT: The same issues {IERC20-approve} has related to transaction
     * ordering also apply here.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `deadline` must be a timestamp in the future.
     * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
     * over the EIP712-formatted function arguments.
     * - the signature must use ``owner``'s current nonce (see {nonces}).
     *
     * For more information on the signature format, see the
     * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
     * section].
     */
    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    /**
     * @dev Returns the current nonce for `owner`. This value must be
     * included whenever a signature is generated for {permit}.
     *
     * Every successful call to {permit} increases ``owner``'s nonce by one. This
     * prevents a signature from being used multiple times.
     */
    function nonces(address owner) external view returns (uint256);

    /**
     * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
     */
    // solhint-disable-next-line func-name-mixedcase
    function DOMAIN_SEPARATOR() external view returns (bytes32);
}


// File @openzeppelin/contracts/utils/Address.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.7.0) (utils/Address.sol)

pragma solidity ^0.8.1;

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
     *
     * [IMPORTANT]
     * ====
     * You shouldn't rely on `isContract` to protect against flash loan attacks!
     *
     * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
     * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
     * constructor.
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // This method relies on extcodesize/address.code.length, which returns 0
        // for contracts in construction, since the code is only stored at the end
        // of the constructor execution.

        return account.code.length > 0;
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
        require(address(this).balance >= amount, "Address: insufficient balance");

        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Address: unable to send value, recipient may have reverted");
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
    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
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
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
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
        require(address(this).balance >= value, "Address: insufficient balance for call");
        require(isContract(target), "Address: call to non-contract");

        (bool success, bytes memory returndata) = target.call{value: value}(data);
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     *
     * _Available since v3.3._
     */
    function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
        return functionStaticCall(target, data, "Address: low-level static call failed");
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
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     *
     * _Available since v3.4._
     */
    function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
        return functionDelegateCall(target, data, "Address: low-level delegate call failed");
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
        return verifyCallResult(success, returndata, errorMessage);
    }

    /**
     * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
     * revert reason using the provided one.
     *
     * _Available since v4.3._
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata,
        string memory errorMessage
    ) internal pure returns (bytes memory) {
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly
                /// @solidity memory-safe-assembly
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


// File @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/utils/SafeERC20.sol)

pragma solidity ^0.8.0;



/**
 * @title SafeERC20
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20 {
    using Address for address;

    function safeTransfer(
        IERC20 token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
    }

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        require(
            (value == 0) || (token.allowance(address(this), spender) == 0),
            "SafeERC20: approve from non-zero to non-zero allowance"
        );
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
    }

    function safeIncreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
    }

    function safeDecreaseAllowance(
        IERC20 token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
        }
    }

    function safePermit(
        IERC20Permit token,
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) internal {
        uint256 nonceBefore = token.nonces(owner);
        token.permit(owner, spender, value, deadline, v, r, s);
        uint256 nonceAfter = token.nonces(owner);
        require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(IERC20 token, bytes memory data) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
        if (returndata.length > 0) {
            // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }
}


// File @openzeppelin/contracts/utils/structs/EnumerableSet.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableSet.sol)

pragma solidity ^0.8.0;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
 *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 *  In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        return _values(set._inner);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}


// File @openzeppelin/contracts/utils/Context.sol@v4.7.3


// OpenZeppelin Contracts v4.4.1 (utils/Context.sol)

pragma solidity ^0.8.0;

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
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.6.0) (token/ERC721/IERC721Receiver.sol)

pragma solidity ^0.8.0;

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


// File @openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol@v4.7.3


// OpenZeppelin Contracts v4.4.1 (token/ERC721/utils/ERC721Holder.sol)

pragma solidity ^0.8.0;

/**
 * @dev Implementation of the {IERC721Receiver} interface.
 *
 * Accepts all token transfers.
 * Make sure the contract is able to use its token with {IERC721-safeTransferFrom}, {IERC721-approve} or {IERC721-setApprovalForAll}.
 */
contract ERC721Holder is IERC721Receiver {
    /**
     * @dev See {IERC721Receiver-onERC721Received}.
     *
     * Always returns `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)

pragma solidity ^0.8.0;

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
    constructor() {
        _transferOwnership(_msgSender());
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File @openzeppelin/contracts/security/ReentrancyGuard.sol@v4.7.3


// OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        // On the first call to nonReentrant, _notEntered will be true
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;

        _;

        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }
}


// File @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)

pragma solidity ^0.8.0;

/**
 * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
 * @dev See https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721Enumerable is IERC721 {
    /**
     * @dev Returns the total amount of tokens stored by the contract.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
     * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
     */
    function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);

    /**
     * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
     * Use along with {totalSupply} to enumerate all tokens.
     */
    function tokenByIndex(uint256 index) external view returns (uint256);
}


// File @openzeppelin/contracts/utils/structs/EnumerableMap.sol@v4.7.3


// OpenZeppelin Contracts (last updated v4.7.0) (utils/structs/EnumerableMap.sol)

pragma solidity ^0.8.0;

/**
 * @dev Library for managing an enumerable variant of Solidity's
 * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
 * type.
 *
 * Maps have the following properties:
 *
 * - Entries are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Entries are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableMap for EnumerableMap.UintToAddressMap;
 *
 *     // Declare a set state variable
 *     EnumerableMap.UintToAddressMap private myMap;
 * }
 * ```
 *
 * The following map types are supported:
 *
 * - `uint256 -> address` (`UintToAddressMap`) since v3.0.0
 * - `address -> uint256` (`AddressToUintMap`) since v4.6.0
 * - `bytes32 -> bytes32` (`Bytes32ToBytes32`) since v4.6.0
 * - `uint256 -> uint256` (`UintToUintMap`) since v4.7.0
 * - `bytes32 -> uint256` (`Bytes32ToUintMap`) since v4.7.0
 *
 * [WARNING]
 * ====
 *  Trying to delete such a structure from storage will likely result in data corruption, rendering the structure unusable.
 *  See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 *  In order to clean an EnumerableMap, you can either remove all elements one by one or create a fresh instance using an array of EnumerableMap.
 * ====
 */
library EnumerableMap {
    using EnumerableSet for EnumerableSet.Bytes32Set;

    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Map type with
    // bytes32 keys and values.
    // The Map implementation uses private functions, and user-facing
    // implementations (such as Uint256ToAddressMap) are just wrappers around
    // the underlying Map.
    // This means that we can only create new EnumerableMaps for types that fit
    // in bytes32.

    struct Bytes32ToBytes32Map {
        // Storage of keys
        EnumerableSet.Bytes32Set _keys;
        mapping(bytes32 => bytes32) _values;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function set(
        Bytes32ToBytes32Map storage map,
        bytes32 key,
        bytes32 value
    ) internal returns (bool) {
        map._values[key] = value;
        return map._keys.add(key);
    }

    /**
     * @dev Removes a key-value pair from a map. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function remove(Bytes32ToBytes32Map storage map, bytes32 key) internal returns (bool) {
        delete map._values[key];
        return map._keys.remove(key);
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool) {
        return map._keys.contains(key);
    }

    /**
     * @dev Returns the number of key-value pairs in the map. O(1).
     */
    function length(Bytes32ToBytes32Map storage map) internal view returns (uint256) {
        return map._keys.length();
    }

    /**
     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
     *
     * Note that there are no guarantees on the ordering of entries inside the
     * array, and it may change when more entries are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32ToBytes32Map storage map, uint256 index) internal view returns (bytes32, bytes32) {
        bytes32 key = map._keys.at(index);
        return (key, map._values[key]);
    }

    /**
     * @dev Tries to returns the value associated with `key`.  O(1).
     * Does not revert if `key` is not in the map.
     */
    function tryGet(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bool, bytes32) {
        bytes32 value = map._values[key];
        if (value == bytes32(0)) {
            return (contains(map, key), bytes32(0));
        } else {
            return (true, value);
        }
    }

    /**
     * @dev Returns the value associated with `key`.  O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(Bytes32ToBytes32Map storage map, bytes32 key) internal view returns (bytes32) {
        bytes32 value = map._values[key];
        require(value != 0 || contains(map, key), "EnumerableMap: nonexistent key");
        return value;
    }

    /**
     * @dev Same as {_get}, with a custom error message when `key` is not in the map.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {_tryGet}.
     */
    function get(
        Bytes32ToBytes32Map storage map,
        bytes32 key,
        string memory errorMessage
    ) internal view returns (bytes32) {
        bytes32 value = map._values[key];
        require(value != 0 || contains(map, key), errorMessage);
        return value;
    }

    // UintToUintMap

    struct UintToUintMap {
        Bytes32ToBytes32Map _inner;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function set(
        UintToUintMap storage map,
        uint256 key,
        uint256 value
    ) internal returns (bool) {
        return set(map._inner, bytes32(key), bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function remove(UintToUintMap storage map, uint256 key) internal returns (bool) {
        return remove(map._inner, bytes32(key));
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(UintToUintMap storage map, uint256 key) internal view returns (bool) {
        return contains(map._inner, bytes32(key));
    }

    /**
     * @dev Returns the number of elements in the map. O(1).
     */
    function length(UintToUintMap storage map) internal view returns (uint256) {
        return length(map._inner);
    }

    /**
     * @dev Returns the element stored at position `index` in the set. O(1).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintToUintMap storage map, uint256 index) internal view returns (uint256, uint256) {
        (bytes32 key, bytes32 value) = at(map._inner, index);
        return (uint256(key), uint256(value));
    }

    /**
     * @dev Tries to returns the value associated with `key`.  O(1).
     * Does not revert if `key` is not in the map.
     */
    function tryGet(UintToUintMap storage map, uint256 key) internal view returns (bool, uint256) {
        (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
        return (success, uint256(value));
    }

    /**
     * @dev Returns the value associated with `key`.  O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(UintToUintMap storage map, uint256 key) internal view returns (uint256) {
        return uint256(get(map._inner, bytes32(key)));
    }

    /**
     * @dev Same as {get}, with a custom error message when `key` is not in the map.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryGet}.
     */
    function get(
        UintToUintMap storage map,
        uint256 key,
        string memory errorMessage
    ) internal view returns (uint256) {
        return uint256(get(map._inner, bytes32(key), errorMessage));
    }

    // UintToAddressMap

    struct UintToAddressMap {
        Bytes32ToBytes32Map _inner;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function set(
        UintToAddressMap storage map,
        uint256 key,
        address value
    ) internal returns (bool) {
        return set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
        return remove(map._inner, bytes32(key));
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
        return contains(map._inner, bytes32(key));
    }

    /**
     * @dev Returns the number of elements in the map. O(1).
     */
    function length(UintToAddressMap storage map) internal view returns (uint256) {
        return length(map._inner);
    }

    /**
     * @dev Returns the element stored at position `index` in the set. O(1).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
        (bytes32 key, bytes32 value) = at(map._inner, index);
        return (uint256(key), address(uint160(uint256(value))));
    }

    /**
     * @dev Tries to returns the value associated with `key`.  O(1).
     * Does not revert if `key` is not in the map.
     *
     * _Available since v3.4._
     */
    function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
        (bool success, bytes32 value) = tryGet(map._inner, bytes32(key));
        return (success, address(uint160(uint256(value))));
    }

    /**
     * @dev Returns the value associated with `key`.  O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
        return address(uint160(uint256(get(map._inner, bytes32(key)))));
    }

    /**
     * @dev Same as {get}, with a custom error message when `key` is not in the map.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryGet}.
     */
    function get(
        UintToAddressMap storage map,
        uint256 key,
        string memory errorMessage
    ) internal view returns (address) {
        return address(uint160(uint256(get(map._inner, bytes32(key), errorMessage))));
    }

    // AddressToUintMap

    struct AddressToUintMap {
        Bytes32ToBytes32Map _inner;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function set(
        AddressToUintMap storage map,
        address key,
        uint256 value
    ) internal returns (bool) {
        return set(map._inner, bytes32(uint256(uint160(key))), bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function remove(AddressToUintMap storage map, address key) internal returns (bool) {
        return remove(map._inner, bytes32(uint256(uint160(key))));
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(AddressToUintMap storage map, address key) internal view returns (bool) {
        return contains(map._inner, bytes32(uint256(uint160(key))));
    }

    /**
     * @dev Returns the number of elements in the map. O(1).
     */
    function length(AddressToUintMap storage map) internal view returns (uint256) {
        return length(map._inner);
    }

    /**
     * @dev Returns the element stored at position `index` in the set. O(1).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressToUintMap storage map, uint256 index) internal view returns (address, uint256) {
        (bytes32 key, bytes32 value) = at(map._inner, index);
        return (address(uint160(uint256(key))), uint256(value));
    }

    /**
     * @dev Tries to returns the value associated with `key`.  O(1).
     * Does not revert if `key` is not in the map.
     */
    function tryGet(AddressToUintMap storage map, address key) internal view returns (bool, uint256) {
        (bool success, bytes32 value) = tryGet(map._inner, bytes32(uint256(uint160(key))));
        return (success, uint256(value));
    }

    /**
     * @dev Returns the value associated with `key`.  O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(AddressToUintMap storage map, address key) internal view returns (uint256) {
        return uint256(get(map._inner, bytes32(uint256(uint160(key)))));
    }

    /**
     * @dev Same as {get}, with a custom error message when `key` is not in the map.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryGet}.
     */
    function get(
        AddressToUintMap storage map,
        address key,
        string memory errorMessage
    ) internal view returns (uint256) {
        return uint256(get(map._inner, bytes32(uint256(uint160(key))), errorMessage));
    }

    // Bytes32ToUintMap

    struct Bytes32ToUintMap {
        Bytes32ToBytes32Map _inner;
    }

    /**
     * @dev Adds a key-value pair to a map, or updates the value for an existing
     * key. O(1).
     *
     * Returns true if the key was added to the map, that is if it was not
     * already present.
     */
    function set(
        Bytes32ToUintMap storage map,
        bytes32 key,
        uint256 value
    ) internal returns (bool) {
        return set(map._inner, key, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the key was removed from the map, that is if it was present.
     */
    function remove(Bytes32ToUintMap storage map, bytes32 key) internal returns (bool) {
        return remove(map._inner, key);
    }

    /**
     * @dev Returns true if the key is in the map. O(1).
     */
    function contains(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool) {
        return contains(map._inner, key);
    }

    /**
     * @dev Returns the number of elements in the map. O(1).
     */
    function length(Bytes32ToUintMap storage map) internal view returns (uint256) {
        return length(map._inner);
    }

    /**
     * @dev Returns the element stored at position `index` in the set. O(1).
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32ToUintMap storage map, uint256 index) internal view returns (bytes32, uint256) {
        (bytes32 key, bytes32 value) = at(map._inner, index);
        return (key, uint256(value));
    }

    /**
     * @dev Tries to returns the value associated with `key`.  O(1).
     * Does not revert if `key` is not in the map.
     */
    function tryGet(Bytes32ToUintMap storage map, bytes32 key) internal view returns (bool, uint256) {
        (bool success, bytes32 value) = tryGet(map._inner, key);
        return (success, uint256(value));
    }

    /**
     * @dev Returns the value associated with `key`.  O(1).
     *
     * Requirements:
     *
     * - `key` must be in the map.
     */
    function get(Bytes32ToUintMap storage map, bytes32 key) internal view returns (uint256) {
        return uint256(get(map._inner, key));
    }

    /**
     * @dev Same as {get}, with a custom error message when `key` is not in the map.
     *
     * CAUTION: This function is deprecated because it requires allocating memory for the error
     * message unnecessarily. For custom revert reasons use {tryGet}.
     */
    function get(
        Bytes32ToUintMap storage map,
        bytes32 key,
        string memory errorMessage
    ) internal view returns (uint256) {
        return uint256(get(map._inner, key, errorMessage));
    }
}


// File contracts/INexusNFTWeight.sol


pragma solidity ^0.8.16;

interface INexusNFTWeight {
    function nexusNFTWeight(uint256 tokenId)
        external
        view
        returns (uint256 weight);
}


// File contracts/Staking.sol



pragma solidity ^0.8.16;
contract NexusNFTMultiStaking is Ownable, ReentrancyGuard, ERC721Holder {
    using EnumerableSet for EnumerableSet.UintSet;
    using EnumerableMap for EnumerableMap.AddressToUintMap;
    using SafeERC20 for IERC20;

    event OnTokenLock(
        address indexed owner,
        uint256 amount,
        uint256 unlockTime,
        uint8 lockMode
    );

    event OnTokenUnlock(address user);

    event OnLockWithdrawal(address user, uint256 amount, uint8 mode);

    event OnLockAmountIncreased(address user, uint256 amount);

    event OnLockDurationIncreased(address user, uint256 newUnlockTime);

    uint256 public PRECISION_FACTOR = 10**8;

    address public constant deadAddress =
        0x000000000000000000000000000000000000dEaD;

    address public immutable nexusToken;

    uint256[] public LOCK_TIME_MULTIPLIER = [10, 15, 70, 150, 310];

    uint256[] public LOCK_TIME_DURATION = [
        0,
        30 days,
        90 days,
        180 days,
        365 days
    ];

    address public immutable nexusNFT;

    uint256 public minNexusAmount = 1111 * 10**18;

    uint256 public minNexusCollateralAmount = 100 * 10**18;

    uint256 private constant PERCENT_FACTOR = 1e4;

    address public nexusWeight;

    struct TokenLock {
        uint256 totalWeight;
        uint256 unlockTime;
        uint256 nftWeight;
        uint256 lockedAmount; // How many staked tokens the user has provided,
        uint256 lockMode; // duration
        uint256 nexusLock;
    }

    struct Reward {
        address token;
        uint256 amount;
    }

    address public distributor;

    modifier onlyDistributorOrOwner() {
        require(
            msg.sender == distributor || msg.sender == owner(),
            "caller is not distributor or owner"
        );
        _;
    }

    mapping(address => TokenLock) public userLocks;

    mapping(address => EnumerableSet.UintSet) private userNFTBalances;

    uint256 public totalPoolWeight;

    uint256 public totalnexusLocked;

    uint256 public totalNFTWeight;

    bool public enableEmergency;

    uint256[] public nexusAmountForLock = new uint256[](5);

    EnumerableMap.AddressToUintMap private accRewardPerWeight;

    EnumerableMap.AddressToUintMap private totalReward;

    mapping(address => EnumerableMap.AddressToUintMap) private userDebtRewards;

    mapping(address => EnumerableMap.AddressToUintMap) private userTotalReward;

    EnumerableSet.UintSet private rewardHistoryTimes;

    mapping(uint256 => Reward) private rewardHistory;

    receive() external payable {}

    fallback() external payable {}

    constructor(address _nexusToken, address _nexusNFT, address _nexusWeight) {
        require(_nexusWeight != address(0), "wrong weighter");
        require(_nexusToken != address(0), "wrong weighter");
        nexusToken = _nexusToken;
        nexusWeight = _nexusWeight;
        nexusNFT = _nexusNFT;
    }

    function totalStakedNFTCount() public view returns (uint256 tokenCount) {
        tokenCount = IERC721Enumerable(nexusNFT).balanceOf(address(this));
    }

    function totalStakedNFT() external view returns (uint256[] memory) {
        uint256 tokenCount = IERC721Enumerable(nexusNFT).balanceOf(
            address(this)
        );
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 index;
            for (index = 0; index < tokenCount; index++) {
                result[index] = IERC721Enumerable(nexusNFT)
                    .tokenOfOwnerByIndex(address(this), index);
            }
            return result;
        }
    }

    function userWalletNFT(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = IERC721Enumerable(nexusNFT).balanceOf(_owner);
        if (tokenCount == 0) {
            // Return an empty array
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 index;
            for (index = 0; index < tokenCount; index++) {
                result[index] = IERC721Enumerable(nexusNFT)
                    .tokenOfOwnerByIndex(_owner, index);
            }
            return result;
        }
    }

    function userStakedNFT(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        return userNFTBalances[_owner].values();
    }

    function userStakedNFTCount(address _owner) public view returns (uint256) {
        return userNFTBalances[_owner].length();
    }

    function isStaked(address account, uint256 tokenId)
        public
        view
        returns (bool)
    {
        return userNFTBalances[account].contains(tokenId);
    }

    function distributeReward(address token, uint256 _amount)
        public
        payable
        onlyDistributorOrOwner
    {
        require(_amount > 0, "zero reward");

        if (token != address(0)) {
            uint256 beforeBalance = IERC20(token).balanceOf(address(this));

            IERC20(token).safeTransferFrom(
                address(msg.sender),
                address(this),
                _amount
            );

            uint256 afterBalance = IERC20(token).balanceOf(address(this));

            _amount = afterBalance - beforeBalance;
        } else {
            _amount = msg.value;
        }

        if (totalPoolWeight > 0) {
            (, uint256 lastValue) = accRewardPerWeight.tryGet(token);

            uint256 newValue = lastValue +
                (_amount * PRECISION_FACTOR) /
                totalPoolWeight;
            accRewardPerWeight.set(token, newValue);
        }

        (, uint256 lastTotalValue) = totalReward.tryGet(token);
        uint256 newTotalValue = lastTotalValue + _amount;
        totalReward.set(token, newTotalValue);

        rewardHistoryTimes.add(block.timestamp);

        rewardHistory[block.timestamp] = Reward({
            token: token,
            amount: _amount
        });
    }

    function backToPool(address token, uint256 _amount) private {
        if (totalPoolWeight > 0) {
            (, uint256 lastValue) = accRewardPerWeight.tryGet(token);
            uint256 newValue = lastValue +
                (_amount * PRECISION_FACTOR) /
                totalPoolWeight;
            accRewardPerWeight.set(token, newValue);
        }

        (, uint256 lastTotalValue) = totalReward.tryGet(token);
        uint256 newTotalValue = lastTotalValue + _amount;
        totalReward.set(token, newTotalValue);

        rewardHistoryTimes.add(block.timestamp);

        rewardHistory[block.timestamp] = Reward({
            token: token,
            amount: _amount
        });
    }

    function distributedUserTotalReward(address user)
        external
        view
        returns (Reward[] memory rewards)
    {
        uint256 rewardCount = userTotalReward[user].length();

        rewards = new Reward[](rewardCount);

        for (uint256 i; i < rewardCount; ) {
            (address token, uint256 distributed) = userTotalReward[user].at(i);
            rewards[i] = Reward({token: token, amount: distributed});

            unchecked {
                i++;
            }
        }
    }

    function distributedTotalReward()
        external
        view
        returns (Reward[] memory rewards)
    {
        uint256 rewardCount = totalReward.length();

        rewards = new Reward[](rewardCount);

        for (uint256 i; i < rewardCount; ) {
            (address token, uint256 distributed) = totalReward.at(i);
            rewards[i] = Reward({token: token, amount: distributed});

            unchecked {
                i++;
            }
        }
    }

    function updateDebt() private {
        TokenLock storage lock = userLocks[msg.sender];

        if (lock.totalWeight > 0) {
            uint256 rewardCount = accRewardPerWeight.length();

            for (uint256 i; i < rewardCount; ) {
                (address token, uint256 acc) = accRewardPerWeight.at(i);

                uint256 newDebt = (lock.totalWeight * acc) / PRECISION_FACTOR;

                userDebtRewards[msg.sender].set(token, newDebt);

                unchecked {
                    i++;
                }
            }
        }
    }

    function pendingRewards(address user)
        external
        view
        returns (Reward[] memory rewards)
    {
        TokenLock memory lock = userLocks[user];

        if (lock.totalWeight > 0) {
            uint256 rewardCount = accRewardPerWeight.length();

            rewards = new Reward[](rewardCount);

            for (uint256 i; i < rewardCount; ) {
                (address token, uint256 acc) = accRewardPerWeight.at(i);

                (, uint256 debtReward) = userDebtRewards[user].tryGet(token);

                uint256 reward = (lock.totalWeight * acc) /
                    PRECISION_FACTOR -
                    debtReward;

                rewards[i] = Reward({token: token, amount: reward});

                unchecked {
                    i++;
                }
            }
        }
    }

    function harvest() public {
        TokenLock storage lock = userLocks[msg.sender];

        if (lock.totalWeight > 0) {
            uint256 rewardCount = accRewardPerWeight.length();

            for (uint256 i; i < rewardCount; ) {
                (address token, uint256 acc) = accRewardPerWeight.at(i);
                (, uint256 debtReward) = userDebtRewards[msg.sender].tryGet(
                    token
                );

                uint256 reward = (lock.totalWeight * acc) /
                    PRECISION_FACTOR -
                    debtReward;

                if (reward > 0) {
                    if (token == address(0)) {
                        transferETH(msg.sender, reward);
                    } else {
                        IERC20(token).safeTransfer(msg.sender, reward);
                    }

                    (, uint256 lastTotalValue) = userTotalReward[msg.sender]
                        .tryGet(token);
                    uint256 newTotalValue = lastTotalValue + reward;
                    userTotalReward[msg.sender].set(token, newTotalValue);
                }

                uint256 newDebt = (lock.totalWeight * acc) / PRECISION_FACTOR;

                userDebtRewards[msg.sender].set(token, newDebt);

                unchecked {
                    i++;
                }
            }
        }

        if (lock.unlockTime < block.timestamp && lock.lockMode > 0) {
            uint256 reducedWeight = ((lock.lockedAmount + lock.nftWeight) *
                (LOCK_TIME_MULTIPLIER[lock.lockMode] -
                    LOCK_TIME_MULTIPLIER[0])) / 10;

            totalPoolWeight -= reducedWeight;

            nexusAmountForLock[lock.lockMode] -= lock.lockedAmount;

            nexusAmountForLock[0] += lock.lockedAmount;

            lock.totalWeight -= reducedWeight;

            lock.lockMode = 0;
        }
    }

    function rewardBackToPool() private {
        TokenLock storage lock = userLocks[msg.sender];

        if (lock.totalWeight > 0) {
            uint256 rewardCount = accRewardPerWeight.length();

            for (uint256 i; i < rewardCount; ) {
                (address token, uint256 acc) = accRewardPerWeight.at(i);
                (, uint256 debtReward) = userDebtRewards[msg.sender].tryGet(
                    token
                );

                uint256 reward = (lock.totalWeight * acc) /
                    PRECISION_FACTOR -
                    debtReward;

                if (reward > 0) {
                    if (totalPoolWeight > 0) {
                        (, uint256 lastValue) = accRewardPerWeight.tryGet(
                            token
                        );

                        uint256 newValue = lastValue +
                            (reward * PRECISION_FACTOR) /
                            totalPoolWeight;
                        accRewardPerWeight.set(token, newValue);
                    }

                    (, uint256 lastTotalValue) = totalReward.tryGet(token);
                    uint256 newTotalValue = lastTotalValue + reward;
                    totalReward.set(token, newTotalValue);

                    rewardHistoryTimes.add(block.timestamp + i);

                    rewardHistory[block.timestamp + i] = Reward({
                        token: token,
                        amount: reward
                    });
                }

                uint256 newDebt = (lock.totalWeight * acc) / PRECISION_FACTOR;

                userDebtRewards[msg.sender].set(token, newDebt);

                unchecked {
                    i++;
                }
            }
        }
    }

    function depositNexusBar(uint256 amount) private {
        require(amount > 0, "zero amount");

        require(
            IERC20(nexusToken).balanceOf(msg.sender) >= amount,
            "small nexusToken balance to stake"
        );

        require(
            IERC20(nexusToken).allowance(msg.sender, address(this)) >= amount,
            "small nexusToken allowance to stake"
        );

        uint256 beforeBalance = IERC20(nexusToken).balanceOf(address(this));

        IERC20(nexusToken).safeTransferFrom(
            address(msg.sender),
            address(this),
            amount
        );

        uint256 afterBalance = IERC20(nexusToken).balanceOf(address(this));

        amount = afterBalance - beforeBalance;

        TokenLock storage lock = userLocks[msg.sender];

        lock.nexusLock += amount;

        totalnexusLocked += amount;
    }

    function withdrawNexusBar(uint256 amount) private {
        require(amount > 0, "zero amount");


        TokenLock storage lock = userLocks[msg.sender];

        // require(lock.nexusLock >= amount, "small lock amount");

        uint8 mode = 0;

        if (block.timestamp < lock.unlockTime) {
            mode = 1;
        }

        uint256 tokenFee = (amount * 50 * mode) / 100;

        uint256 amountWithdraw = amount - tokenFee;

        IERC20(nexusToken).safeTransfer(msg.sender, amountWithdraw);

        if (mode == 1) {
            uint256 burnAmount = (tokenFee * 50) / 100;

            IERC20(nexusToken).safeTransfer(deadAddress, burnAmount);

            backToPool(nexusToken, tokenFee - burnAmount);
        }

        lock.nexusLock -= amount;

        totalnexusLocked -= amount;
    }

    function batchNFTStake(uint256[] calldata tokenIds) public nonReentrant {
        require(
            IERC721(nexusNFT).isApprovedForAll(_msgSender(), address(this)),
            "Not approve nft to staker address"
        );

        uint256 count = tokenIds.length;

        require(count > 0, "zero stake nft");

        TokenLock storage lock = userLocks[msg.sender];

        if (lock.lockMode != 0) {
            if (lock.lockedAmount > 0) {
                require(lock.lockedAmount >= minNexusAmount, "small nexus staked");
                depositNexusBar(minNexusCollateralAmount * count);
            }
        }

        uint256 newWeight = lock.nftWeight;

        uint256 addedWeight = 0;

        for (uint256 i = 0; i < count; ) {
            uint256 tokenId = tokenIds[i];

            require(
                IERC721(nexusNFT).ownerOf(tokenId) == _msgSender(),
                "wrong owner"
            );

            IERC721(nexusNFT).safeTransferFrom(
                _msgSender(),
                address(this),
                tokenId
            );

            userNFTBalances[_msgSender()].add(tokenId);

            uint256 nexusNFTWeight = INexusNFTWeight(nexusWeight)
                .nexusNFTWeight(tokenId) * 10**18;
            newWeight += nexusNFTWeight;

            // addedWeight +=
            //     (nexusNFTWeight * LOCK_TIME_MULTIPLIER[lock.lockMode]) /
            //     10;

            if (lock.lockedAmount > 0) {
                addedWeight +=
                    (nexusNFTWeight * LOCK_TIME_MULTIPLIER[lock.lockMode]) /
                    10;
            } else {
                addedWeight += nexusNFTWeight;
            }

            unchecked {
                i++;
            }
        }

        harvest();

        lock.nftWeight = newWeight;

        lock.totalWeight = addedWeight + lock.totalWeight;

        totalPoolWeight += addedWeight;
        updateDebt();
    }

    function NFTStake(uint256 tokenId) public nonReentrant {
        require(
            IERC721(nexusNFT).ownerOf(tokenId) == _msgSender(),
            "wrong owner"
        );

        require(
            IERC721(nexusNFT).isApprovedForAll(_msgSender(), address(this)) ||
                IERC721(nexusNFT).getApproved(tokenId) == address(this),
            "not approved"
        );

        TokenLock storage lock = userLocks[msg.sender];

        if (lock.lockMode != 0) {
            if (lock.lockedAmount > 0) {
                require(lock.lockedAmount >= minNexusAmount, "small nexus staked");
                depositNexusBar(minNexusCollateralAmount);
            }
        }

        IERC721(nexusNFT).safeTransferFrom(
            _msgSender(),
            address(this),
            tokenId
        );

        harvest();

        userNFTBalances[_msgSender()].add(tokenId);

        uint256 oldWeight = lock.nftWeight;
        uint256 nexusNFTWeight = INexusNFTWeight(nexusWeight)
            .nexusNFTWeight(tokenId) * 10**18;
        uint256 newWeight = oldWeight + nexusNFTWeight;

        lock.nftWeight = newWeight;
        uint256 addedWeight;
        if (lock.lockedAmount > 0) {
            addedWeight =
                (nexusNFTWeight * LOCK_TIME_MULTIPLIER[lock.lockMode]) /
                10;
        } else {
            addedWeight = nexusNFTWeight;
        }
        lock.totalWeight += addedWeight;
        totalPoolWeight += addedWeight;
        updateDebt();
    }

    function NFTWithdraw(uint256 tokenId) public nonReentrant {
        require(isStaked(_msgSender(), tokenId), "Not staked this nft");

        IERC721(nexusNFT).safeTransferFrom(
            address(this),
            _msgSender(),
            tokenId
        );

        TokenLock storage lock = userLocks[msg.sender];

        if (lock.nexusLock >= minNexusCollateralAmount) {
            withdrawNexusBar(minNexusCollateralAmount);
        }else if(lock.nexusLock > 0){
            withdrawNexusBar(lock.nexusLock);
        }

        userNFTBalances[_msgSender()].remove(tokenId);

        harvest();

        uint256 oldWeight = lock.nftWeight;

        uint256 nexusNFTWeight = INexusNFTWeight(nexusWeight)
            .nexusNFTWeight(tokenId) * 10**18;

        uint256 newWeight = oldWeight - nexusNFTWeight;

        lock.nftWeight = newWeight;

        uint256 reduceddWeight;

        //  (nexusNFTWeight *
        //     LOCK_TIME_MULTIPLIER[lock.lockMode]) / 10;

        if (lock.lockedAmount > 0) {
            reduceddWeight =
                (nexusNFTWeight * LOCK_TIME_MULTIPLIER[lock.lockMode]) /
                10;
        } else {
            reduceddWeight = nexusNFTWeight;
        }

        lock.totalWeight -= reduceddWeight;
        totalPoolWeight -= reduceddWeight;

        updateDebt();

        if (lock.lockedAmount == 0) {
            if (userStakedNFTCount(msg.sender) == 0) {
                delete userLocks[msg.sender];
            }
            emit OnTokenUnlock(msg.sender);
        }
    }

    function batchNFTWithdraw(uint256[] calldata tokenIds) public nonReentrant {
        uint256 count = tokenIds.length;

        require(count > 0, "zero stake nft");

        TokenLock storage lock = userLocks[msg.sender];

        uint256 newWeight = lock.nftWeight;

        uint256 reduceddWeight = 0;

        for (uint256 i = 0; i < count; ) {
            uint256 tokenId = tokenIds[i];

            require(isStaked(_msgSender(), tokenId), "Not staked this nft");

            IERC721(nexusNFT).safeTransferFrom(
                address(this),
                _msgSender(),
                tokenId
            );

            userNFTBalances[_msgSender()].remove(tokenId);

            uint256 nexusNFTWeight = INexusNFTWeight(nexusWeight)
                .nexusNFTWeight(tokenId) * 10**18;

            newWeight -= nexusNFTWeight;

            // reduceddWeight +=
            //     (nexusNFTWeight * LOCK_TIME_MULTIPLIER[lock.lockMode]) /
            //     10;

            if (lock.lockedAmount > 0) {
                reduceddWeight +=
                    (nexusNFTWeight * LOCK_TIME_MULTIPLIER[lock.lockMode]) /
                    10;
            } else {
                reduceddWeight += nexusNFTWeight;
            }

            unchecked {
                i++;
            }
        }

        harvest();

        if (lock.nexusLock >= minNexusCollateralAmount * count) {
            withdrawNexusBar(minNexusCollateralAmount * count);
        }else if(lock.nexusLock > 0){
            withdrawNexusBar(lock.nexusLock);
        }

        lock.nftWeight = newWeight;

        lock.totalWeight -= reduceddWeight;
        totalPoolWeight -= reduceddWeight;

        updateDebt();

        if (lock.lockedAmount == 0) {
            if (userStakedNFTCount(msg.sender) == 0) {
                delete userLocks[msg.sender];
            }
            emit OnTokenUnlock(msg.sender);
        }
    }

    function calculateUserNFTWeight(address _account)
        public
        view
        returns (uint256 weight)
    {
        uint256 tokenCount = userNFTBalances[_account].length();
        if (tokenCount == 0) {
            return 0;
        } else {
            uint256[] memory staked = userStakedNFT(_account);
            uint256 i;
            for (i; i < tokenCount; ) {
                weight +=
                    INexusNFTWeight(nexusWeight).nexusNFTWeight(staked[i]) *
                    10**18;
                unchecked {
                    i++;
                }
            }
        }
    }

    /**
     * @notice locks nexus token until specified time
     * @param amount amount of tokens to lock
     * @param lockMode unix time in seconds after that tokens can be withdrawn
     */
    function deposit(uint256 amount, uint8 lockMode)
        external
        payable
        nonReentrant
    {
        require(amount > 0, "ZERO AMOUNT");

        require(
            IERC20(nexusToken).balanceOf(msg.sender) >= amount,
            "small NEXUS balance to stake"
        );

        require(
            IERC20(nexusToken).allowance(msg.sender, address(this)) >= amount,
            "small NEXUS allowance to stake"
        );

        require(lockMode >= 0 && lockMode < 5, "Invalid lock mode");

        TokenLock storage lock = userLocks[msg.sender];

        require(lock.lockedAmount == 0, "already deposit");

        uint256 beforeBalance = IERC20(nexusToken).balanceOf(address(this));

        IERC20(nexusToken).safeTransferFrom(
            address(msg.sender),
            address(this),
            amount
        );

        uint256 afterBalance = IERC20(nexusToken).balanceOf(address(this));

        amount = afterBalance - beforeBalance;

        uint256 unlockTime = block.timestamp + LOCK_TIME_DURATION[lockMode];

        uint256 addeddWeight = (amount * LOCK_TIME_MULTIPLIER[lockMode]) / 10;

        if (lock.nftWeight > 0) {
            addeddWeight +=
                (lock.nftWeight * (LOCK_TIME_MULTIPLIER[lockMode] - 10)) /
                10;

            if (lockMode > 0) {

                require(amount >= minNexusAmount, "small nexus amount for nft");

                uint256 count = userStakedNFTCount(msg.sender);

                if (count > 0 && minNexusCollateralAmount * count > lock.nexusLock) {
                    depositNexusBar(
                        minNexusCollateralAmount * count - lock.nexusLock
                    );
                }
            }
        }

        harvest();

        totalPoolWeight += addeddWeight;

        nexusAmountForLock[lockMode] += amount;

        lock.totalWeight += addeddWeight;
        lock.lockedAmount += amount;

        if(lock.unlockTime < unlockTime){
            lock.unlockTime = unlockTime;
        }
       
        lock.lockMode = lockMode;
        updateDebt();

        emit OnTokenLock(msg.sender, amount, unlockTime, lockMode);
    }

    function extendLockTime(uint256 lockMode) external nonReentrant {
        require(lockMode > 0 && lockMode < 5, "Invalid lock mode");

        TokenLock storage lock = userLocks[msg.sender];

        require(lock.lockedAmount > 0, "no lock");

        require(lock.lockMode < lockMode, "NOT INCREASING UNLOCK TIME");

        uint256 count = userStakedNFTCount(msg.sender);

        if (count > 0) {
            if (lock.nexusLock == 0) {
                depositNexusBar(minNexusCollateralAmount * count);
            }
            require(lock.lockedAmount >= minNexusAmount, "small nexus staked");
        }

        uint256 unlockTime = lock.unlockTime +
            LOCK_TIME_DURATION[lockMode] -
            LOCK_TIME_DURATION[lock.lockMode];

        uint256 addeddWeight = ((lock.lockedAmount + lock.nftWeight) *
            (LOCK_TIME_MULTIPLIER[lockMode] -
                LOCK_TIME_MULTIPLIER[lock.lockMode])) / 10;

        harvest();

        totalPoolWeight += addeddWeight;

        nexusAmountForLock[lock.lockMode] -= lock.lockedAmount;

        nexusAmountForLock[lockMode] += lock.lockedAmount;

        lock.totalWeight += addeddWeight;

        lock.lockMode = lockMode;

        lock.unlockTime = unlockTime;

        updateDebt();

        emit OnLockDurationIncreased(msg.sender, unlockTime);
    }

    function shortenLockTime(uint256 lockMode) internal  {
        require(lockMode >= 0 && lockMode < 5, "Invalid lock mode");

        TokenLock storage lock = userLocks[msg.sender];

        require(lock.lockMode > lockMode, "NOT DECREASING UNLOCK TIME");

        require(lock.unlockTime < block.timestamp, "original lock duration");

        uint256 unlockTime = block.timestamp + LOCK_TIME_DURATION[lockMode];

        uint256 reducedWeight = ((lock.lockedAmount + lock.nftWeight) *
            (LOCK_TIME_MULTIPLIER[lock.lockMode] -
                LOCK_TIME_MULTIPLIER[lockMode])) / 10;

        totalPoolWeight -= reducedWeight;

        nexusAmountForLock[lock.lockMode] -= lock.lockedAmount;

        nexusAmountForLock[lockMode] += lock.lockedAmount;

        lock.totalWeight -= reducedWeight;

        lock.lockMode = lockMode;

        lock.unlockTime = unlockTime;

        updateDebt();
    }

    /**
     * @notice add tokens to an existing lock
     * @param amount tokens amount to add
     */
    function increaseLockAmount(uint256 amount) external payable nonReentrant {
        require(amount > 0, "ZERO AMOUNT");

        TokenLock storage lock = userLocks[msg.sender];

        require(lock.lockedAmount > 0, "no original lock");

        uint256 beforeBalance = IERC20(nexusToken).balanceOf(address(this));

        IERC20(nexusToken).safeTransferFrom(
            address(msg.sender),
            address(this),
            amount
        );

        uint256 afterBalance = IERC20(nexusToken).balanceOf(address(this));

        amount = afterBalance - beforeBalance;

        harvest();

        uint256 addeddWeight = ((amount) *
            LOCK_TIME_MULTIPLIER[lock.lockMode]) / 10;

        totalPoolWeight += addeddWeight;

        nexusAmountForLock[lock.lockMode] += amount;

        lock.totalWeight += addeddWeight;
        lock.lockedAmount += amount;

        updateDebt();

        emit OnLockAmountIncreased(msg.sender, amount);
    }

    /**
     * @notice withdraw specified amount of tokens from lock. Current time must be greater than unlock time
     * @param amount amount of tokens to withdraw
     */
    function withdraw(uint256 amount) public nonReentrant {
        TokenLock storage lock = userLocks[msg.sender];

        require(lock.lockedAmount >= amount, "more withdraw");

        require(amount > 0, "zero amount");

        uint8 mode = 0;

        if (block.timestamp < lock.unlockTime) {
            mode = 1;
            rewardBackToPool();
        } else {
            harvest();
        }

        uint256 tokenFee = (amount * 50 * mode) / 100;

        uint256 amountWithdraw = amount - tokenFee;

        if (amountWithdraw > 0) {
            IERC20(nexusToken).safeTransfer(msg.sender, amountWithdraw);
        }

        if (mode == 1) {
            uint256 burnAmount = (tokenFee * 5) / 10;
            IERC20(nexusToken).safeTransfer(deadAddress, burnAmount);
            backToPool(nexusToken, tokenFee - burnAmount);
        }

        nexusAmountForLock[lock.lockMode] -= amount;

        lock.lockedAmount -= amount;

        if (lock.lockedAmount == 0) {
            totalPoolWeight =
                totalPoolWeight +
                lock.nftWeight -
                lock.totalWeight;

            if (userStakedNFTCount(msg.sender) == 0) {
                delete userLocks[msg.sender];
            } else {
                // lock.lockMode = 0;
                lock.totalWeight = lock.nftWeight;
            }
        } else {
            uint256 reducedWeight = (amount *
                LOCK_TIME_MULTIPLIER[lock.lockMode]) / 10;

            totalPoolWeight -= reducedWeight;

            lock.totalWeight -= reducedWeight;
        }

        updateDebt();

        if (lock.lockedAmount == 0) {
            emit OnTokenUnlock(msg.sender);
        } else {
            emit OnLockWithdrawal(msg.sender, amount, mode);
        }
    }

    function transferETH(address recipient, uint256 amount) private {
        (bool res, ) = payable(recipient).call{value: amount}("");
        require(res, "ETH TRANSFER FAILED");
    }

    function totalNexusLocked() public view returns (uint256 amount) {
        for (uint256 i; i < nexusAmountForLock.length; ) {
            amount += nexusAmountForLock[i];
            unchecked {
                i++;
            }
        }
    }

    function setNexusWeight(address _nexusWeight) external onlyOwner {
        require(_nexusWeight != address(0), "wrong address");
        nexusWeight = _nexusWeight;
    }

    function setMinNexusCollateral(uint256 _min) external onlyOwner {
        minNexusCollateralAmount = _min;
    }

    function setMinNexusAmount(uint256 _min) external onlyOwner {
        minNexusAmount = _min;
    }

    function setEmergency(bool _flag) external onlyOwner {
        enableEmergency = _flag;
    }

    function setDistributor(address _distributor) external onlyOwner {
        distributor = _distributor;
    }

    function emergencyWithdraw() public nonReentrant {
        require(enableEmergency, "not emergency feature");

        // TokenLock storage lock = userLocks[msg.sender];

        uint256[] memory staked = userStakedNFT(msg.sender);

        uint256 count = staked.length;

        for (uint256 i = 0; i < count; ) {
            uint256 tokenId = staked[i];

            IERC721(nexusNFT).safeTransferFrom(
                address(this),
                _msgSender(),
                tokenId
            );

            userNFTBalances[_msgSender()].remove(tokenId);

            unchecked {
                i++;
            }
        }
    }

    function getGlobalStatus()
        external
        view
        returns (
            uint256 poolSize,
            uint256 nexusAmount,
            uint256 nftCount,
            uint256 NexusCollateralAmount
        )
    {
        poolSize = totalPoolWeight;
        nexusAmount = totalNexusLocked();
        nftCount = totalStakedNFTCount();
        NexusCollateralAmount = totalnexusLocked;
    }

    function getRewardHistory()
        external
        view
        returns (uint256[] memory times, Reward[] memory rewards)
    {
        uint256 rewardCount = rewardHistoryTimes.length();
        times = new uint256[](rewardCount);
        rewards = new Reward[](rewardCount);

        for (uint256 i; i < rewardCount; ) {
            uint256 rewardTime = rewardHistoryTimes.at(i);
            rewards[i] = rewardHistory[rewardTime];
            times[i] = rewardTime;

            unchecked {
                i++;
            }
        }
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}

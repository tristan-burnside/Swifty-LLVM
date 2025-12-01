internal import llvmc

public enum CastOperation: Hashable, Sendable {
  /// The `trunc` instruction.
  case trunc
  /// The `zext` instruction.
  case zext
  /// The `sext` instruction.
  case sext
  /// The `fpToUI` instruction.
  case fpToUI
  /// The `fpToSI` instruction.
  case fpToSI
  /// The `uiToFP` instruction.
  case uiToFP
  /// The `siToFP` instruction.
  case siToFP
  /// The `fpTrunc` instruction.
  case fpTrunc
  /// The `fpext` instruction.
  case fpext
  /// The `ptrToInt` instruction.
  case ptrToInt
  /// The `intToPtr` instruction.
  case intToPtr
  /// The `bitCast` instruction.
  case bitCast
  /// The `addrSpaceCast` instruction.
  case addrSpaceCast

  var llvm: LLVMOpcode {
    switch self {
    case .trunc:
      LLVMTrunc
    case .zext:
      LLVMZExt
    case .sext:
      LLVMSExt
    case .fpToUI:
      LLVMFPToUI
    case .fpToSI:
      LLVMFPToSI
    case .uiToFP:
      LLVMUIToFP
    case .siToFP:
      LLVMSIToFP
    case .fpTrunc:
      LLVMFPTrunc
    case .fpext:
      LLVMFPExt
    case .ptrToInt:
      LLVMPtrToInt
    case .intToPtr:
      LLVMIntToPtr
    case .bitCast:
      LLVMBitCast
    case .addrSpaceCast:
      LLVMAddrSpaceCast
    }
  }
}

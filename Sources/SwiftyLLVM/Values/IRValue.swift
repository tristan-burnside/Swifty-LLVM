internal import llvmc

/// A value in LLVM IR.
public protocol IRValue: CustomStringConvertible, Sendable {

  /// A handle to the LLVM object wrapped by this instance.
  var llvm: ValueRef { get }

}

extension IRValue {

  /// A string representation of the value.
  public var description: String {
    guard let s = LLVMPrintValueToString(llvm.raw) else { return "" }
    defer { LLVMDisposeMessage(s) }
    return String(cString: s)
  }

  /// The LLVM IR type of this value.
  public var type: IRType {
    let type = AnyType(LLVMTypeOf(llvm.raw)!)
    switch LLVMGetTypeKind(type.llvm.raw) {
    case LLVMHalfTypeKind: return FloatingPointType(type)!
    case LLVMVoidTypeKind: return VoidType(type)!
    case LLVMHalfTypeKind: return FloatingPointType(type)!     /**< 16 bit floating point type */
    case LLVMFloatTypeKind: return FloatingPointType(type)!     /**< 32 bit floating point type */
    case LLVMDoubleTypeKind: return FloatingPointType(type)!    /**< 64 bit floating point type */
    case LLVMX86_FP80TypeKind: return FloatingPointType(type)!  /**< 80 bit floating point type (X87) */
    case LLVMFP128TypeKind: return FloatingPointType(type)!  /**< 128 bit floating point type (112-bit mantissa)*/
    case LLVMPPC_FP128TypeKind: return FloatingPointType(type)!  /**< 128 bit floating point type (two 64-bits) */
    case LLVMLabelTypeKind: return type     /**< Labels */
    case LLVMIntegerTypeKind: return IntegerType(type.llvm.raw)   /**< Arbitrary bit width integers */
    case LLVMFunctionTypeKind: return FunctionType(type)!  /**< Functions */
    case LLVMStructTypeKind: return StructType(type)!   /**< Structures */
    case LLVMArrayTypeKind: return ArrayType(type)!    /**< Arrays */
    case LLVMPointerTypeKind: return PointerType(type)!  /**< Pointers */
    default: return type
    }
  }

  /// The name of this value.
  public var name: String {
    get {
      String(from: llvm.raw, readingWith: LLVMGetValueName2(_:_:)) ?? ""
    }
    set {
      LLVMSetValueName2(llvm.raw, newValue, newValue.count)
    }
  }

  /// `true` iff this value is the `null` instance of its type.
  public var isNull: Bool { LLVMIsNull(llvm.raw) != 0 }

  /// `true` iff this value is constant.
  public var isConstant: Bool { LLVMIsConstant(llvm.raw) != 0 }

  /// `true` iff this value is a terminator instruction.
  public var isTerminator: Bool { LLVMIsATerminatorInst(llvm.raw) != nil }

  /// Returns `true` iff `lhs` is equal to `rhs`.
  public static func == <R: IRValue>(lhs: Self, rhs: R) -> Bool {
    lhs.llvm == rhs.llvm
  }

  /// Returns `true` iff `lhs` is equal to `rhs`.
  public static func == (lhs: IRValue, rhs: Self) -> Bool {
    lhs.llvm == rhs.llvm
  }

  /// Returns `true` iff `lhs` is equal to `rhs`.
  public static func == (lhs: Self, rhs: IRValue) -> Bool {
    lhs.llvm == rhs.llvm
  }

  /// Returns `true` iff `lhs` is not equal to `rhs`.
  public static func != (lhs: IRValue, rhs: Self) -> Bool {
    lhs.llvm != rhs.llvm
  }

  /// Returns `true` iff `lhs` is not equal to `rhs`.
  public static func != (lhs: Self, rhs: IRValue) -> Bool {
    lhs.llvm != rhs.llvm
  }

}

/// Returns `true` iff `lhs` is equal to `rhs`.
public func == (lhs: IRValue, rhs: IRValue) -> Bool {
  lhs.llvm == rhs.llvm
}

/// Returns `true` iff `lhs` is not equal to `rhs`.
public func != (lhs: IRValue, rhs: IRValue) -> Bool {
  lhs.llvm != rhs.llvm
}

internal import llvmc

/// An pointer type in LLVM IR.
public struct PointerType: IRType {

  /// A handle to the LLVM object wrapped by this instance.
  public let llvm: TypeRef

  /// The type referenced by this pointer
  /// if nil, the pointer is opaque
  public let pointee: IRType?
  
  /// Creates an instance wrapping `llvm`.
  private init(_ llvm: LLVMTypeRef, wrapping p: IRType? = nil) {
    self.llvm = .init(llvm)
    self.pointee = p
  }

  /// Creates an instance with `t`, failing iff `t` isn't a pointer type.
  public init?(_ t: IRType, wrapping p: IRType? = nil) {
    if LLVMGetTypeKind(t.llvm.raw) == LLVMPointerTypeKind {
      self.llvm = t.llvm
      self.pointee = p
    } else {
      return nil
    }
  }

  /// Creates an opaque pointer type in address space `s` in `module`.
  public init(inAddressSpace s: AddressSpace = .default, pointee: IRType? = nil, in module: inout Module) {
    self.init(LLVMPointerTypeInContext(module.context, s.llvm))
  }

  /// The address space of the pointer.
  public var addressSpace: AddressSpace { .init(LLVMGetPointerAddressSpace(llvm.raw)) }

}

import Std.Math.PI;
import Std.Arrays.Unzipped;
import Std.Diagnostics.DumpMachine;
import Std.Convert.ResultArrayAsInt;
import Std.Diagnostics.Fact;

function RequiredQubits() : Int { 4 }

/// Encodes the state from the first two qubits into the full four-qubit register,
/// assuming the third and fourth qubits are in the |0> state.
operation Encode(qs : Qubit[]) : Unit is Adj {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    H(qs[3]);
    CNOT(qs[3], qs[2]);
    CNOT(qs[3], qs[1]);
    CNOT(qs[3], qs[0]);
    CNOT(qs[0], qs[2]);
    CNOT(qs[1], qs[2]);
}

/// Checks the state of the qubits and returns an integer representing a syndrom.
/// Since the 4-2-2 code can only detect arbitrary single-qubit errors, any non-zero
/// syndrome indicates an error in the logical qubit state.
operation Check(qs : Qubit[]) : Int {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    use aux = Qubit[2];
    ApplyToEach(CNOT(aux[0], _), qs);
    ApplyToEach(CZ(aux[1], _), qs);
    ResultArrayAsInt(MResetEachZ(aux))
}

/// Prepares a register of qubits in the ground state |0000> into the logical state |00>.
/// This is slighlty more efficient than using the Encode operation, and uses a fifth auxiliary qubit
/// internally to verify the preparation. An non-zero result indicates an error in the preparation.
operation PrepZZ(qs : Qubit[]) : Result {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    use aux = Qubit();
    H(qs[3]);
    within {
        CNOT(qs[3], aux);
    } apply {
        CNOT(qs[3], qs[0]);
        CNOT(qs[3], qs[1]);
        CNOT(qs[3], qs[2]);
    }
    MResetZ(aux)
}

/// Prepares a register of qubits in the ground state |0000> into the logical state |+0>.
/// This is slighlty more efficient than using the Encode operation, and uses two auxiliary qubits
/// internally to verify the preparation. An non-zero result indicates an error in the preparation.
operation PrepXZ(qs : Qubit[]) : Int {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    use aux = Qubit[2];
    H(qs[0]);
    H(qs[3]);
    within {
        CNOT(qs[3], aux[0]);
        CNOT(qs[0], aux[1]);
    } apply {
        CNOT(qs[3], qs[1]);
        CNOT(qs[0], qs[2]);
    }
    ResultArrayAsInt(MResetEachZ(aux))
}

/// Prepares a register of qubits in the ground state |0000> into the logical state |0+>.
/// This is slighlty more efficient than using the Encode operation, and uses a two auxiliary qubits
/// internally to verify the preparation. An non-zero result indicates an error in the preparation.
operation PrepZX(qs : Qubit[]) : Int {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    use aux = Qubit[2];
    H(qs[1]);
    H(qs[3]);
    within {
        CNOT(qs[3], aux[0]);
        CNOT(qs[1], aux[1]);
    } apply {
        CNOT(qs[3], qs[0]);
        CNOT(qs[1], qs[2]);
    }
    ResultArrayAsInt(MResetEachZ(aux))
}

/// Applies a logical Pauli-X gate to the first qubit of the encoded state.
operation XI(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    X(qs[0]);
    X(qs[2]);
}

/// Applies a logical Pauli-X gate to the second qubit of the encoded state.
operation IX(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    X(qs[1]);
    X(qs[2]);
}

/// Applies a logical Pauli-X gate to both qubits of the encoded state.
operation XX(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    X(qs[0]);
    X(qs[1]);
}

/// Applies a logical Pauli-Z gate to the first qubit of the encoded state.
operation ZI(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    Z(qs[1]);
    Z(qs[2]);
}

/// Applies a logical Pauli-Z gate to the second qubit of the encoded state.
operation IZ(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    Z(qs[1]);
    Z(qs[3]);
}

/// Applies a logical Pauli-Z gate to both qubits of the encoded state.
operation ZZ(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    Z(qs[0]);
    Z(qs[1]);
}

/// Applies a logical Hadamard gate to both qubits of the encoded state.
operation HH(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    ApplyToEach(H, qs);
    Relabel([qs[0], qs[1]], [qs[1], qs[0]]);
}

/// Applies a logical SWAP gate to the two qubits of the encoded state.
operation SWAP01(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    Relabel([qs[0], qs[1]], [qs[1], qs[0]]);
}

/// Applies a logical CNOT gate between the two qubits of the encoded state,
/// using the first qubit as the control and the second as the target.
operation CX01(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    Relabel([qs[1], qs[2]], [qs[2], qs[1]]);
}

/// Applies a logical CNOT gate between the two qubits of the encoded state,
/// using the second qubit as the control and the first as the target.
operation CX10(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    Relabel([qs[0], qs[2]], [qs[2], qs[0]]);
}

/// Applies a logical CZ gate between the two qubits of the encoded state.
operation CZ01(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    S(qs[0]);
    Adjoint S(qs[2]);
    Adjoint S(qs[3]);
    S(qs[1]);
}

/// Applies a non-fault-tolerant Rz gate to each of the two qubits of the encoded state,
/// using the first angle for the first qubit and the second angle for the second qubit.
/// Returns an integer representing an ancilla measurement that indicates any detected errors
/// in the logical state before the logical Rz gates are applied.
operation RzRz(theta0 : Double, theta1 : Double, qs : Qubit[]) : Int {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    within {
        Adjoint Encode(qs);
    } apply {
        Rz(theta0, qs[0]);
        Rz(theta1, qs[1]);
        ResultArrayAsInt(MResetEachZ(qs[2...]))
    }
}

/// Applies a transversal CNOT operation between two blocks of encoded qubits, using
/// the first block as the control and the second block as the target.
operation CXCX(qs0 : Qubit[], qs1 : Qubit[]) : Unit {
    Fact(Length(qs0) == RequiredQubits(), "Incorrect number of qubits.");
    Fact(Length(qs1) == RequiredQubits(), "Incorrect number of qubits.");

    CNOT(qs0[0], qs1[0]);
    CNOT(qs0[1], qs1[1]);
    CNOT(qs0[2], qs1[2]);
    CNOT(qs0[3], qs1[3]);
}

/// Performs the logical measurement of the encoded two qubit state in the Z basis.
/// The mapping is as follows:
/// |0000> or |1111> -> |00>
/// |0110> or |1001> -> |01>
/// |0101> or |1010> -> |10>
/// |0011> or |1100> -> |11>
/// Any other state indicates a logical error.
operation MeasureZZ(qs : Qubit[]) : Result[] {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    MResetEachZ(qs)
}

@Config(Unrestricted)
function DecodeMeasurement(res : Result[]) : Result[] {
    Fact(Length(res) == RequiredQubits(), "Incorrect number of results for decoding.");

    // Map the results back to the logical qubit states.
    if res == [Zero, Zero, Zero, Zero] or res == [One, One, One, One] {
        [Zero, Zero]
    } elif res == [Zero, One, One, Zero] or res == [One, Zero, Zero, One] {
        [Zero, One]
    } elif res == [Zero, One, Zero, One] or res == [One, Zero, One, Zero] {
        [One, Zero]
    } elif res == [Zero, Zero, One, One] or res == [One, One, Zero, Zero] {
        [One, One]
    } else {
        // Any other result indicates a logical error.
        fail $"Invalid measurement result for 4-2-2 code: {res}";
    }
}

@Config(Unrestricted)
@Test()
operation VerifyPrepZZWithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [Zero, Zero], "MeasureZZ should return [Zero, Zero] for a valid noiseless preparation.");
}

@Config(Unrestricted)
@Test()
operation VerifyPrepZZWithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [Zero, Zero, Zero, Zero], "Qubits should be in the |0000> state after encoding.");
}

@Config(Unrestricted)
@Test()
operation VerifyPrepXZWithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepXZ(qs) == 0, "PrepXZ should return 0 for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    Adjoint Encode(qs);
    H(qs[0]);
    Fact(MResetEachZ(qs) == [Zero, Zero, Zero, Zero], "Qubits should be in the |0000> state after encoding.");
}

@Config(Unrestricted)
@Test()
operation VerifyPrepZXWithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZX(qs) == 0, "PrepXZ should return 0 for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    Adjoint Encode(qs);
    H(qs[1]);
    Fact(MResetEachZ(qs) == [Zero, Zero, Zero, Zero], "Qubits should be in the |0000> state after encoding.");
}

@Config(Unrestricted)
@Test()
operation VerifyXIWithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    XI(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying XI.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [One, Zero], "MeasureZZ should return [One, Zero] after applying XI.");
}

@Config(Unrestricted)
@Test()
operation Verify_XI_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    XI(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying XI.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [One, Zero, Zero, Zero], "Qubits should be in the |1000> state after applying XI.");
}

@Config(Unrestricted)
@Test()
operation Verify_IX_WithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    IX(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying IX.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [Zero, One], "MeasureZZ should return [Zero, One] after applying IX.");
}

@Config(Unrestricted)
@Test()
operation Verify_IX_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    IX(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying IX.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [Zero, One, Zero, Zero], "Qubits should be in the |0100> state after applying IX.");
}

@Config(Unrestricted)
@Test()
operation Verify_XX_WithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    XX(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying XX.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [One, One], "MeasureZZ should return [One, One] after applying XX.");
}

@Config(Unrestricted)
@Test()
operation Verify_XX_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    XX(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying XX.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [One, One, Zero, Zero], "Qubits should be in the |1100> state after applying XX.");
}

@Config(Unrestricted)
@Test()
operation Verify_HH_ZI_HH_WithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    ZI(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying ZI.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH again.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [One, Zero], "MeasureZZ should return [One, Zero] after applying ZI.");
}

@Config(Unrestricted)
@Test()
operation Verify_HH_ZI_HH_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    ZI(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying IZ.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH again.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [One, Zero, Zero, Zero], "Qubits should be in the |1000> state after applying ZI.");
}

@Config(Unrestricted)
@Test()
operation Verify_HH_IZ_HH_WithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    IZ(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying ZI.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH again.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [Zero, One], "MeasureZZ should return [Zero, One] after applying IZ.");
}

@Config(Unrestricted)
@Test()
operation Verify_HH_IZ_HH_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    IZ(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying IZ.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH again.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [Zero, One, Zero, Zero], "Qubits should be in the |0100> state after applying IZ.");
}

@Config(Unrestricted)
@Test()
operation Verify_HH_ZZ_HH_WithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    ZZ(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying ZZ.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH again.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [One, One], "MeasureZZ should return [One, One] after applying ZZ.");
}

@Config(Unrestricted)
@Test()
operation Verify_HH_ZZ_HH_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    ZZ(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying ZZ.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH again.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [One, One, Zero, Zero], "Qubits should be in the |1100> state after applying ZZ.");
}

@Config(Unrestricted)
@Test()
operation Verify_HH_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    Adjoint Encode(qs);
    H(qs[0]);
    H(qs[1]);
    Fact(MResetEachZ(qs) == [Zero, Zero, Zero, Zero], "Qubits should be in the |0000> state after applying HH.");
}

@Config(Unrestricted)
@Test()
operation Verify_CX01_WithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    XI(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying XI.");
    CX01(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying CX01.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [One, One], "MeasureZZ should return [One, One] after applying CX01.");
}

@Config(Unrestricted)
@Test()
operation Verify_CX01_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    XI(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying XI.");
    CX01(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying CX01.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [One, One, Zero, Zero], "Qubits should be in the |1100> state after applying CX01.");
}

@Config(Unrestricted)
@Test()
operation Verify_CX10_WithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    IX(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying IX.");
    CX10(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying CX10.");
    let res = MeasureZZ(qs);
    Fact(DecodeMeasurement(res) == [One, One], "MeasureZZ should return [One, One] after applying CX10.");
}

@Config(Unrestricted)
@Test()
operation Verify_CX10_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    IX(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying IX.");
    CX10(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying CX10.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [One, One, Zero, Zero], "Qubits should be in the |1100> state after applying CX10.");
}

@Config(Unrestricted)
@Test()
operation Verify_CZ01_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    X(qs[0]);
    H(qs[1]);
    Encode(qs);
    // Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    CZ01(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying CZ01.");
    Adjoint Encode(qs);
    H(qs[1]);
    Fact(MResetEachZ(qs) == [One, One, Zero, Zero], "Qubits should be in the |1100> state after applying CZ01.");
}

@Config(Unrestricted)
@Test()
operation Verify_RzRz_WithLogicalMeasurement() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    let res = RzRz(PI(), PI(), qs);
    Fact(res == 0, "RzRz should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH again.");
    let measurement = MeasureZZ(qs);
    Fact(DecodeMeasurement(measurement) == [One, One], "MeasureZZ should return [One, One] after applying RzRz.");
}

@Config(Unrestricted)
@Test()
operation Verify_RzRz_WithDecoding() : Unit {
    use qs = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs) == 0, "Check should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH.");
    let res = RzRz(PI(), PI(), qs);
    Fact(res == 0, "RzRz should return 0 for a valid noiseless preparation.");
    HH(qs);
    Fact(Check(qs) == 0, "Check should return 0 after applying HH again.");
    Adjoint Encode(qs);
    Fact(MResetEachZ(qs) == [One, One, Zero, Zero], "Qubits should be in the |1100> state after applying RzRz.");
}

@Config(Unrestricted)
@Test()
operation Verify_CXCX_WithLogicalMeasurement() : Unit {
    use qs0 = Qubit[RequiredQubits()];
    use qs1 = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs0) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(PrepZZ(qs1) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs0) == 0, "Check should return 0 for a valid noiseless preparation.");
    Fact(Check(qs1) == 0, "Check should return 0 for a valid noiseless preparation.");
    XX(qs0);
    Fact(Check(qs0) == 0, "Check should return 0 after applying XX to qs0.");
    CXCX(qs0, qs1);
    Fact(Check(qs0) == 0, "Check should return 0 after applying CXCX.");
    Fact(Check(qs1) == 0, "Check should return 0 after applying CXCX.");
    let res0 = MeasureZZ(qs0);
    let res1 = MeasureZZ(qs1);
    Fact(DecodeMeasurement(res0) == [One, One], "MeasureZZ on qs0 should return [One, One] after applying CXCX.");
    Fact(DecodeMeasurement(res1) == [One, One], "MeasureZZ on qs1 should return [One, One] after applying CXCX.");
}

@Config(Unrestricted)
@Test()
operation Verify_CXCX_WithDecoding() : Unit {
    use qs0 = Qubit[RequiredQubits()];
    use qs1 = Qubit[RequiredQubits()];
    Fact(PrepZZ(qs0) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(PrepZZ(qs1) == Zero, "PrepZZ should return Zero for a valid noiseless preparation.");
    Fact(Check(qs0) == 0, "Check should return 0 for a valid noiseless preparation.");
    Fact(Check(qs1) == 0, "Check should return 0 for a valid noiseless preparation.");
    XX(qs0);
    Fact(Check(qs0) == 0, "Check should return 0 after applying XX to qs0.");
    CXCX(qs0, qs1);
    Fact(Check(qs0) == 0, "Check should return 0 after applying CXCX.");
    Fact(Check(qs1) == 0, "Check should return 0 after applying CXCX.");
    Adjoint Encode(qs0);
    Adjoint Encode(qs1);
    Fact(MResetEachZ(qs0) == [One, One, Zero, Zero], "Qubits in qs0 should be in the |1100> state after applying CXCX.");
    Fact(MResetEachZ(qs1) == [One, One, Zero, Zero], "Qubits in qs1 should be in the |1100> state after applying CXCX.");
}

operation TestPhysical() : Result[] {
    import Std.Diagnostics.*;
    ConfigurePauliNoise(DepolarizingNoise(0.003));
    use qs = Qubit[2];
    H(qs[0]);
    CNOT(qs[0], qs[1]);
    MResetEachZ(qs)
}

operation TestLogical() : Result[] {
    import Std.Diagnostics.*;
    ConfigurePauliNoise(DepolarizingNoise(0.003));
    use qs = Qubit[RequiredQubits()];
    Fact(PrepXZ(qs) == 0, "");
    CX01(qs);
    DecodeMeasurement(MeasureZZ(qs))
}

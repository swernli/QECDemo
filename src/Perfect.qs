import Std.Convert.BoolArrayAsInt;
import Std.Arrays.ForEach;
import Std.Diagnostics.Fact;

function RequiredQubits() : Int { 5 }

operation Encode(qs : Qubit[]) : Unit is Adj {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    CNOT(qs[0], qs[2]);
    H(qs[0]);
    H(qs[1]);
    CNOT(qs[0], qs[3]);
    CNOT(qs[1], qs[0]);
    CNOT(qs[0], qs[2]);
    CNOT(qs[1], qs[4]);
    H(qs[1]);
    H(qs[0]);
    CNOT(qs[1], qs[3]);
    CNOT(qs[0], qs[4]);
}

operation Correct(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    let generators = [
        [PauliX, PauliZ, PauliZ, PauliX, PauliI],
        [PauliI, PauliX, PauliZ, PauliZ, PauliX],
        [PauliX, PauliI, PauliX, PauliZ, PauliZ],
        [PauliZ, PauliX, PauliI, PauliX, PauliZ]
    ];

    let syndrome = [
        Measure(generators[0], qs) == One,
        Measure(generators[1], qs) == Zero,
        Measure(generators[2], qs) == Zero,
        Measure(generators[3], qs) == One
    ];
    let corrections = [
        (1, X),
        (4, Z),
        (2, X),
        (2, Z),
        (0, Z),
        (3, X),
        (2, Y),
        (0, X),
        (3, Z),
        (1, Z),
        (1, Y),
        (4, X),
        (0, Y),
        (4, Y),
        (3, Y),
    ];
    let idx = BoolArrayAsInt(syndrome) - 1;
    if idx >= 0 {
        let (i, op) = corrections[idx];
        op(qs[i]);
    }
}

export RequiredQubits, Encode, Correct;

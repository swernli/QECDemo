import Std.Convert.BoolArrayAsInt;
import Std.Diagnostics.Fact;

function RequiredQubits() : Int { 5 }

operation Encode(qs : Qubit[]) : Unit is Adj {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    // "Optimization of Clifford Circuits," V. Kliuchnikov and D. Maslov,
    // https://arxiv.org/abs/1305.0810, Figure 4b
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

@Config(Unrestricted)
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
        (PauliX, 1),
        (PauliZ, 4),
        (PauliX, 2),
        (PauliZ, 2),
        (PauliZ, 0),
        (PauliX, 3),
        (PauliY, 2),
        (PauliX, 0),
        (PauliZ, 3),
        (PauliZ, 1),
        (PauliY, 1),
        (PauliX, 4),
        (PauliY, 0),
        (PauliY, 4),
        (PauliY, 3)
    ];
    let idx = BoolArrayAsInt(syndrome) - 1;
    if idx >= 0 {
        let (p, i) = corrections[idx];
        ApplyP(p, qs[i]);
    }
}

export RequiredQubits, Encode, Correct;

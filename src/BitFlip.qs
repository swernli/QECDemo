import Std.Diagnostics.Fact;

function RequiredQubits() : Int { 3 }

operation Encode(qs : Qubit[]) : Unit is Adj {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    CNOT(qs[0], qs[1]);
    CNOT(qs[0], qs[2]);
}

operation Correct(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    let m1 = Measure([PauliZ, PauliZ], qs[0..1]);
    let m2 = Measure([PauliZ, PauliZ], qs[1..2]);

    if m1 == One {
        if m2 == One {
            X(qs[1]);
        } else {
            X(qs[0]);
        }
    } elif m2 == One {
        X(qs[2]);
    }
}

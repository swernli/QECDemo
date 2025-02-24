import Std.Diagnostics.Fact;

function RequiredQubits() : Int { 9 }

operation Encode(qs : Qubit[]) : Unit is Adj {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    BitFlip.Encode(qs[0..3...]);
    for q in qs[0..3...] {
        H(q);
    }
    BitFlip.Encode(qs[0..2]);
    BitFlip.Encode(qs[3..5]);
    BitFlip.Encode(qs[6..8]);
}

@Config(Unrestricted)
operation Correct(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    operation DetectXError(qs : Qubit[]) : Int {
        let m1 = Measure([PauliZ, PauliZ], qs[0..1]);
        let m2 = Measure([PauliZ, PauliZ], qs[1..2]);

        if m1 == One and m2 == Zero {
            return 0;
        } elif m1 == One and m2 == One {
            return 1;
        } elif m1 == Zero and m2 == One {
            return 2;
        } else {
            return -1;
        }
    }

    let zErr = {
        let r0 = Measure([PauliX, PauliX, PauliX, PauliX, PauliX, PauliX], qs[0..5]);
        let r1 = Measure([PauliX, PauliX, PauliX, PauliX, PauliX, PauliX], qs[3..8]);
        if r0 == One {
            if r1 == One {
                1
            } else {
                0
            }
        } else {
            if r1 == One {
                2
            } else {
                -1
            }
        }
    };

    let xErr0 = DetectXError(qs[0..2]);
    let xErr1 = DetectXError(qs[3..5]);
    let xErr2 = DetectXError(qs[6..8]);

    let op = if zErr == -1 { X } else { Y };
    if xErr0 != -1 {
        op(qs[xErr0]);
    } elif xErr1 != -1 {
        op(qs[xErr1 + 3]);
    } elif xErr2 != -1 {
        op(qs[xErr2 + 6]);
    } elif zErr != -1 {
        Z(qs[0 + (zErr * 3)]);
        Z(qs[1 + (zErr * 3)]);
        Z(qs[2 + (zErr * 3)]);
    }
}

export RequiredQubits, Encode, Correct;

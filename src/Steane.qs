import Std.Convert.ResultArrayAsInt;
import Std.Arrays.ForEach;
import Std.Diagnostics.Fact;

function RequiredQubits() : Int { 7 }

operation Encode(qs : Qubit[]) : Unit is Adj {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    H(qs[1]);
    H(qs[3]);
    H(qs[6]);
    CNOT(qs[0], qs[5]);
    CNOT(qs[6], qs[2]);
    CNOT(qs[6], qs[4]);
    CNOT(qs[2], qs[0]);
    CNOT(qs[3], qs[5]);
    CNOT(qs[1], qs[5]);
    CNOT(qs[5], qs[6]);
    CNOT(qs[3], qs[4]);
    CNOT(qs[1], qs[2]);
}

operation Correct(qs : Qubit[]) : Unit {
    Fact(Length(qs) == RequiredQubits(), "Incorrect number of qubits.");

    let xGenerators = [
        [PauliX, PauliI, PauliX, PauliI, PauliX, PauliI, PauliX],
        [PauliI, PauliX, PauliX, PauliI, PauliI, PauliX, PauliX],
        [PauliI, PauliI, PauliI, PauliX, PauliX, PauliX, PauliX]
    ];
    let zGenerators = [
        [PauliZ, PauliI, PauliZ, PauliI, PauliZ, PauliI, PauliZ],
        [PauliI, PauliZ, PauliZ, PauliI, PauliI, PauliZ, PauliZ],
        [PauliI, PauliI, PauliI, PauliZ, PauliZ, PauliZ, PauliZ]
    ];

    let xSyndrome = ForEach(Measure(_, qs), xGenerators);
    let zSyndrome = ForEach(Measure(_, qs), zGenerators);

    let zCorrectionIdx = ResultArrayAsInt(xSyndrome) - 1;
    let xCorrectionIdx = ResultArrayAsInt(zSyndrome) - 1;

    if zCorrectionIdx >= 0 {
        Z(qs[zCorrectionIdx]);
    }
    if xCorrectionIdx >= 0 {
        X(qs[xCorrectionIdx]);
    }
}

export RequiredQubits, Encode, Correct;

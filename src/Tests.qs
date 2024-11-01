import Std.Diagnostics.Fact;
import Std.Diagnostics.CheckAllZero;

operation Main() : Unit {
    VerifyBitFlip();
    VerifyPhaseFlip();
}

operation VerifyBitFlip() : Unit {
    import BitFlip.*;

    {
        use qs = Qubit[RequiredQubits()];
        use aux = Qubit();
        within {
            H(aux);
            CNOT(aux, qs[0]);
            Encode(qs);
        } apply {
            // No errors.
            Correct(qs);
        }

        Fact(CheckAllZero(qs + [aux]), $"All Qubits should be returned to the |0⟩ state, failed on 'no error' case.");
    }

    for i in 0..RequiredQubits() - 1 {
        use qs = Qubit[RequiredQubits()];
        use aux = Qubit();
        within {
            H(aux);
            CNOT(aux, qs[0]);
            Encode(qs);
        } apply {
            X(qs[i]);
            Correct(qs);
        }

        Fact(CheckAllZero(qs + [aux]), $"All Qubits should be returned to the |0⟩ state, failed on bit flip for idx {i}");
    }
}

operation VerifyPhaseFlip() : Unit {
    import PhaseFlip.*;

    {
        use qs = Qubit[RequiredQubits()];
        use aux = Qubit();
        within {
            H(aux);
            CNOT(aux, qs[0]);
            Encode(qs);
        } apply {
            // No errors.
            Correct(qs);
        }

        Fact(CheckAllZero(qs + [aux]), $"All Qubits should be returned to the |0⟩ state, failed on 'no error' case.");
    }

    for i in 0..RequiredQubits() - 1 {
        use qs = Qubit[RequiredQubits()];
        use aux = Qubit();
        within {
            H(aux);
            CNOT(aux, qs[0]);
            Encode(qs);
        } apply {
            Z(qs[i]);
            Correct(qs);
        }

        Fact(CheckAllZero(qs + [aux]), $"All Qubits should be returned to the |0⟩ state, failed on phase flip for idx {i}");
    }
}
import Std.Diagnostics.Fact;

@Config(Unrestricted)
import Std.Diagnostics.CheckAllZero;

@Config(Unrestricted)
operation Main() : String {
    VerifyBitFlip();
    VerifyPhaseFlip();
    VerifyShor();
    VerifySteane();
    VerifyPerfect();
    
    "All tests passed!"
}

@Config(Unrestricted)
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

@Config(Unrestricted)
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

@Config(Unrestricted)
operation VerifyShor() : Unit {
    import Shor.*;

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

    for err in [X, Y, Z] {
        for i in 0..RequiredQubits() - 1 {
            use qs = Qubit[RequiredQubits()];
            use aux = Qubit();
            within {
                H(aux);
                CNOT(aux, qs[0]);
                Encode(qs);
            } apply {
                err(qs[i]);
                Correct(qs);
            }

            Fact(CheckAllZero(qs + [aux]), $"All Qubits should be returned to the |0⟩ state, failed for idx {i}");
        }
    }
}

@Config(Unrestricted)
operation VerifySteane() : Unit {
    import Steane.*;

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

    for err in [X, Y, Z] {
        for i in 0..RequiredQubits() - 1 {
            use qs = Qubit[RequiredQubits()];
            use aux = Qubit();
            within {
                H(aux);
                CNOT(aux, qs[0]);
                Encode(qs);
            } apply {
                err(qs[i]);
                Correct(qs);
            }

            Fact(CheckAllZero(qs + [aux]), $"All Qubits should be returned to the |0⟩ state, failed for idx {i}");
        }
    }
}

@Config(Unrestricted)
operation VerifyPerfect() : Unit {
    import Perfect.*;

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

    for err in [X, Y, Z] {
        for i in 0..RequiredQubits() - 1 {
            use qs = Qubit[RequiredQubits()];
            use aux = Qubit();
            within {
                H(aux);
                CNOT(aux, qs[0]);
                Encode(qs);
            } apply {
                err(qs[i]);
                Correct(qs);
            }

            Fact(CheckAllZero(qs + [aux]), $"All Qubits should be returned to the |0⟩ state, failed for idx {i}");
        }
    }
}

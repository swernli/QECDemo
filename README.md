# QECDemo

A demonstration of quantum error correcting codes implemented in Q#. For more information on Q# itself, check out the [Introduction to Q#](https://learn.microsoft.com/en-us/azure/quantum/qsharp-overview).

This repository is implemented as a Q# library to allow others to import and experiment with these error correcting codes. To depend on this library from your own Q# project, add the following dependencies snippet to your qsharp.json project:

```json
  "dependencies": {
    "QECDemo": {
      "github": {
        "owner": "swernli",
        "repo": "QECDemo",
        "ref": "9b84b1201c7733830517e8ed5450c7a0feef9aa5"
      }
    }
  }

```

## Implemented Error Correction Codes

- BitFlip.qs: The bit flip code that can detect and correct a single Pauli-X error on any one of three qubits.
- PhaseFlip.qs: The phase flip code that can detect and correct a single Pauli-Z error on any one of three qubits.
- Shor.qs: The 9 qubit code discovered by Dr. Peter Shor that can detect and correct any single qubit error.
- Steane.qs: The 7 qubit code discovered by Dr. Andrew Steane that can detect and correct any single qubit error.
- Perfect.qs: The 5 qubit "Perfect" code, also known as the Laflamme code, which is the smallest code for detecting and correcting arbitrary single qubit errors.
- Tests.qs: A Test file that verifies the codes behave as expected and can correct Pauli-X, -Y, and/or -Z error on a single qubit.

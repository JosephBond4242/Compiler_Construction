import subprocess

def run_scanner(input_text):
    """Runs the scanner with given input and captures output."""
    process = subprocess.Popen(
        ["../obj/scanner"],  # Adjust this path if needed
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        text=True
    )
    
    stdout, stderr = process.communicate(input_text)

    if stderr:
        print("Scanner Error:", stderr)
    
    return stdout.strip()  # Remove leading/trailing whitespace


def main():
    """Test cases for the scanner."""
    test_cases = [
        (
            "int int\nint\nint\nint int int",  # Test case 0 input
            """<KEYWORD, int> : (1:1)
<KEYWORD, int> : (1:5)
<KEYWORD, int> : (2:1)
<KEYWORD, int> : (3:1)
<KEYWORD, int> : (4:1)
<KEYWORD, int> : (4:5)
<KEYWORD, int> : (4:9)"""
        ),
        (
            "int int\nIntmain",  # Test case 1 input
            """<KEYWORD, int> : (1:1)
<KEYWORD, int> : (1:5)
<ID, intmain> : (2:1)"""
        ),
        (
            '" This \\" is\\ an \t ok \n string"\nprintf("Hello world! \t \n \\ \b ");',  # Test case 2 input
            """<STRING, " This " is\ an ok
string"> : (1:1)
<ID, printf> : (2:1)
<PUNCTUATION, (> : (2:7)
<ERROR, Unrecognized escape character in String> : (2:32)
<PUNCTUATION, )> : (2:35)
<PUNCTUATION, ;> : (2:36)"""
        )
    ]

    for i, (input_text, expected_output) in enumerate(test_cases):
        print(f"Running Test Case {i}:")
        print("-" * 20)
        print("Input:\n", input_text)
        print("\nExpected Output:\n", expected_output)
        
        output = run_scanner(input_text)

        print("\nActual Output:\n", output)
        print("-" * 40)

        if output == expected_output:
            print(f" Test Case {i} Passed\n")
        else:
            print(f" Test Case {i} Failed\n")

if __name__ == "__main__":
    main()
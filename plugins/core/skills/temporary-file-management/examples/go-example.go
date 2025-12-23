package main

import (
	"fmt"
	"io/ioutil"
	"os"
	"path/filepath"
)

// Example 1: Using ioutil.TempFile
func example1() {
	fmt.Println("✓ Example 1: Basic temporary file")

	// Create temporary file
	tempFile, err := ioutil.TempFile("", "example-*.txt")
	if err != nil {
		panic(err)
	}
	defer os.Remove(tempFile.Name())

	fmt.Printf("  Created: %s\n", tempFile.Name())

	// Write data
	if _, err := tempFile.WriteString("Sample data\nLine 1\nLine 2\n"); err != nil {
		panic(err)
	}
	tempFile.Close()

	// Read data back
	data, err := ioutil.ReadFile(tempFile.Name())
	if err != nil {
		panic(err)
	}
	fmt.Printf("  Content: %s\n", string(data[:30]))
	fmt.Println("  Cleaned up\n")
}

// Example 2: Using ioutil.TempDir
func example2() {
	fmt.Println("✓ Example 2: Temporary directory")

	// Create temporary directory
	tempDir, err := ioutil.TempDir("", "example-dir-*")
	if err != nil {
		panic(err)
	}
	defer os.RemoveAll(tempDir)

	fmt.Printf("  Created: %s\n", tempDir)

	// Create multiple files
	for i := 0; i < 3; i++ {
		filePath := filepath.Join(tempDir, fmt.Sprintf("file%d.txt", i))
		content := fmt.Sprintf("File %d content\n", i)
		if err := ioutil.WriteFile(filePath, []byte(content), 0644); err != nil {
			panic(err)
		}
	}

	// List files
	files, err := ioutil.ReadDir(tempDir)
	if err != nil {
		panic(err)
	}

	fmt.Printf("  Files created: ")
	for _, f := range files {
		fmt.Printf("%s ", f.Name())
	}
	fmt.Println()
	fmt.Println("  Cleaned up\n")
}

// Example 3: With explicit cleanup control
func example3() {
	fmt.Println("✓ Example 3: Manual cleanup control")

	tempFile, err := ioutil.TempFile("", "manual-*.txt")
	if err != nil {
		panic(err)
	}
	tempPath := tempFile.Name()

	fmt.Printf("  Created: %s\n", tempPath)

	// Write and close
	tempFile.WriteString("Manual cleanup example\n")
	tempFile.Close()

	// Use the file
	data, _ := ioutil.ReadFile(tempPath)
	fmt.Printf("  Content: %s", string(data))

	// Manual cleanup
	os.Remove(tempPath)
	fmt.Println("  Manually cleaned up\n")
}

// Example 4: Safer cleanup with error handling
func example4() {
	fmt.Println("✓ Example 4: Error-safe cleanup")

	tempFile, err := ioutil.TempFile("", "safe-*.txt")
	if err != nil {
		panic(err)
	}
	defer func() {
		if err := os.Remove(tempFile.Name()); err != nil && !os.IsNotExist(err) {
			fmt.Printf("  Warning: cleanup failed: %v\n", err)
		}
	}()

	fmt.Printf("  Created: %s\n", tempFile.Name())

	// Write data
	if _, err := tempFile.WriteString("Error-safe cleanup\n"); err != nil {
		panic(err)
	}
	tempFile.Close()

	// Read and process
	data, _ := ioutil.ReadFile(tempFile.Name())
	fmt.Printf("  Content: %s", string(data))
	fmt.Println("  Cleaned up with error handling\n")
}

// Example 5: Checking available space
func example5() {
	fmt.Println("✓ Example 5: Check temp space before use")

	tempDir, err := ioutil.TempDir("", "space-check-*")
	if err != nil {
		panic(err)
	}
	defer os.RemoveAll(tempDir)

	fmt.Printf("  Temp directory: %s\n", tempDir)

	// In production, you might check disk space here
	// For this example, we just create and use it
	testFile := filepath.Join(tempDir, "test.txt")
	largeContent := make([]byte, 1024*1024) // 1MB

	if err := ioutil.WriteFile(testFile, largeContent, 0644); err != nil {
		fmt.Printf("  Error creating file: %v\n", err)
	} else {
		fmt.Println("  Successfully created 1MB test file")
	}
	fmt.Println("  Cleaned up\n")
}

func main() {
	fmt.Println("Temporary File Management Examples (Go)\n")

	example1()
	example2()
	example3()
	example4()
	example5()

	fmt.Println("✓ All examples completed")
}

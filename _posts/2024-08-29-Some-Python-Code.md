---
title: "Some Python Code"
date: 2024-08-29
---

Here we look at an example block of Python code to see how it comes out:
```python
"""
Unless an exception occurs, automatically delete the file when the ScopedFile object goes out of scope.
Python's __del__() method handles normal cleanup and a context manager handles exceptions.
The __del__() method is automatically called when the object is garbage collected
(typically when it goes out of scope), and it will delete the file only if the object leaves
the scope without encountering an exception.
"""
from pathlib import Path
from typing import Union, List, Set


class ScopedFile:
    def __init__(self, file_name: str, dir_path: Path = Path()):
        self.file_name = file_name
        self.dir_path = dir_path  # Defaults to current directory
        self.file_path = self.dir_path / self.file_name
        self.file_path.write_text('', encoding='utf-8')
        # Track whether the scope exits normally
        self._normal_exit = True

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        # If an exception occurred, set _abnormal_exit to True
        if exc_type is not None:
            self._normal_exit = False
        # Return False to propagate exceptions
        return False

    def __del__(self):
        # Delete the file if we exit the scope without an exception
        if self._normal_exit and self.file_path.exists():
            try:
                self.file_path.unlink()
            except Exception as e:
                print(f"Failed to delete {self.file_path}: {e}")


class SetFile(ScopedFile):
    def __init__(self, file_name: str, dir_path: Path = Path()):
        super().__init__(file_name, dir_path)
        self._data = set()

    def add(self, item: str):
        """Add an item to the set and write the set to the file."""
        self._data.add(item)
        self._write_to_file()

    def add_collection(self, collection: Union[List[str], Set[str]]):
        """Add all items from a list or set to self._data and write the set to the file."""
        if not isinstance(collection, (list, set)):
            raise TypeError("Argument must be a list or set")

        self._data.update(collection)
        self._write_to_file()

    def remove(self, item: str):
        """Remove an item from the set and write the set to the file."""
        if item in self._data:
            self._data.remove(item)
            self._write_to_file()

    def _write_to_file(self):
        """Write the set to the file, one item per line."""
        with self.file_path.open('w', encoding='utf-8') as f:
            for item in sorted(self._data):
                f.write(f"{item}\n")

    def __enter__(self):
        return self

    def __exit__(self, exc_type, exc_value, traceback):
        # Delegate to the parent class's __exit__ method
        super().__exit__(exc_type, exc_value, traceback)
```
And that was my Python example...

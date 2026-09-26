#!/usr/bin/env python3
"""Validate JSON with comments and trailing commas using Python's JSON parser."""

import json
import pathlib
import sys


def mask_comments(source: str) -> str:
    result = list(source)
    position = 0
    in_string = False
    escaped = False

    while position < len(source):
        char = source[position]
        following = source[position + 1] if position + 1 < len(source) else ""

        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            position += 1
            continue

        if char == '"':
            in_string = True
        elif char == "/" and following == "/":
            end = source.find("\n", position)
            if end == -1:
                end = len(source)
            result[position:end] = " " * (end - position)
            position = end
            continue
        elif char == "/" and following == "*":
            end = source.find("*/", position + 2)
            if end == -1:
                raise ValueError("unterminated block comment")
            end += 2
            for index in range(position, end):
                if source[index] != "\n":
                    result[index] = " "
            position = end
            continue
        position += 1

    return "".join(result)


def mask_trailing_commas(source: str) -> str:
    result = list(source)
    in_string = False
    escaped = False

    for position, char in enumerate(source):
        if in_string:
            if escaped:
                escaped = False
            elif char == "\\":
                escaped = True
            elif char == '"':
                in_string = False
            continue

        if char == '"':
            in_string = True
        elif char == ",":
            next_position = position + 1
            while next_position < len(source) and source[next_position].isspace():
                next_position += 1
            if next_position < len(source) and source[next_position] in "}]":
                result[position] = " "

    return "".join(result)


def main() -> int:
    path = pathlib.Path(sys.argv[1])
    try:
        source = path.read_text(encoding="utf-8")
        json.loads(mask_trailing_commas(mask_comments(source)))
    except (OSError, UnicodeError, ValueError) as error:
        print(f"{path}: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())

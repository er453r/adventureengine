# Adventure Engine

A plot scripting format inspired by Ink and Kni

## Design principles

- New plot forks begin with non-zero multiples of `>`
- Each plot branch should end with an empty line

## Requirements 

    apt install pandoc texlive-latex-base texlive-fonts-recommended
  
## Script to PDF

    pandoc test.md -o test.pdf
    
To use dense blockquotes
    
    pandoc -f markdown-blank_before_blockquote test.md -o test.htm
    pandoc -f markdown-blank_before_blockquote test.md -o test.pdf
    
## Pandoc markdown

https://pandoc.org/MANUAL.html#block-quotations

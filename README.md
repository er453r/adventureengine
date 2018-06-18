# Adventure Engine

## Requirements 

    apt install pandoc texlive-latex-base texlive-fonts-recommended
  
## Script to PDF

    pandoc test.md -o test.pdf
    
To use dense blockquotes
    
    pandoc -f markdown-blank_before_blockquote test.md -o test.htm
    pandoc -f markdown-blank_before_blockquote test.md -o test.pdf
    
## Pandoc markdown

https://pandoc.org/MANUAL.html#block-quotations


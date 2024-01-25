# docgen

Documentation generator by Taya

## Usage
  
```bash
$ docgen <input> <output>
```

It will take all markdown files in the input directory, and generate html files in the output directory.

Markdown files will be put into a template, which is defined at `template.html` in the input directory.
In the template it will replace `{{content}}` with the markdown content.

Any other files will just be copied to the output directory.
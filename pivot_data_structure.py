#!/usr/bin/env python

"""
Produce output like the following from nested lists of data.
Permit pivoting.

\begin{ncolumn}{5}
$\bullet$ Python
 &$\bullet$ Scala
 &$\bullet$ HTML5
 &$\bullet$ Angular
 &$\bullet$ RDF*\\

$\bullet$ Javascript
 &$\bullet$ ObjC
 &$\bullet$ CSS
 &$\bullet$ React
 &$\bullet$ OWL\\

$\bullet$ Java
 &$\bullet$ Nim
 &$\bullet$ SVG
 &$\bullet$ Selenium
 &$\bullet$ OKBC\\

$\bullet$ Coffeescript
 &$\bullet$ C
 &$\bullet$ XML
 &$\bullet$ DocBook
 &$\bullet$ N3\\

$\bullet$ Postscript
 &$\bullet$ AWK
 &$\bullet$ JSON
 &$\bullet$ SGML
 &$\bullet$ TriG\\

$\bullet$ SQL
 &$\bullet$ Scheme
 &$\bullet$ jQuery/UI
 &$\bullet$ \LaTeX
 &$\bullet$ TMAPI\\

$\bullet$ Bash
 &$\bullet$ Smalltalk
 &$\bullet$ D3
 &$\bullet$ Markdown
 &$\bullet$ CTM\\

$\bullet$ Perl
 &$\bullet$ LISP
 &$\bullet$ $<${\tt canvas}$>$
 &$\bullet$ Make
 &$\bullet$ LTM\\

\end{ncolumn}"""

header = "\\begin{ncolumn}{%(num_col)s}\n"
footer = "\\end{ncolumn}\n"
cell   = "$\\bullet$ %(cell_val)s"
cell_delim = "\n &"
column_after = "\\\\\n\n"

things = """
Python,  Javascript, Typescript, Coffeescript, Postscript, SQL, Bash, Perl
Java, C, AWK, ObjC, Scheme, Smalltalk, LISP, Nim
HTML5, CSS, SVG, XML, JSON, jQuery/UI, D3, $<${\\tt canvas}$>$
Angular, React, Selenium, DocBook, SGML, \LaTeX, Markdown, Make
RDF*, OWL, OKBC, N3, TriG, TMAPI, CTM, LTM
"""

old_things = """
VRML, RIB, RPG/400, Mappa, MARC, Erlang
"""


def read_em(things):
    out = []
    for line in things.split("\n"):
        outline = []
        line = line.strip()
        if not line:
            continue
        #print line
        for term in line.split(','):
            term = term.strip()
            if not term:
                continue
            outline.append(term)
        out.append(outline)
        outline = []
    return out

def format_as_bullet_table(matrix):
    num_col = len(matrix[0])
    out = header % locals()
    for line in matrix:
        outline = []
        for cell_val in line:
            outline.append(cell % locals())
        out = out + cell_delim.join(outline) + column_after
    out = out + footer
    return out

def pivot(matrix,noop = False):
    """
    >>> pivot([[1,2],[3,4]])
    [[1, 3], [2, 4]]
    >>> pivot([[1,2],[3,4]], noop=True)
    [[1, 2], [3, 4]]
    """
    if noop:
        return matrix
    out = []

    for line in matrix:

        if not out:
            idx = -1
            for cell in line:
                idx = idx + 1
                out.append([cell])
        else:
            idx = -1
            for cell in line:
                idx = idx + 1
                out[idx].append(cell)
    return out

if __name__ == "__main__":
    them = read_em(things)
    import doctest
    doctest.testmod()
    #print format_as_bullet_table(pivot(them,noop=True))
    #print "=" * 80
    print(format_as_bullet_table(pivot(them)))

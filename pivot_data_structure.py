#!/usr/bin/python

"""
Produce output like the following from nested lists of data.
Permit pivoting.

\begin{ncolumn}{5}
$\bullet$  Python
 &$\bullet$ Javascript
 &$\bullet$ ObjC
 &$\bullet$ Postscript 
 &$\bullet$ SQL\\

$\bullet$ Bash
 &$\bullet$ Java
 &$\bullet$ Scheme
 &$\bullet$ Smalltalk
 &$\bullet$ Erlang\\

$\bullet$ C
 &$\bullet$ Perl
 &$\bullet$ AWK 
 &$\bullet$ LISP
 &$\bullet$ RPG/400\\

$\bullet$ HTML5
 &$\bullet$ CSS
 &$\bullet$ SVG
 &$\bullet$ PhoneGap
 &$\bullet$ XML\\

$\bullet$ DocBook
 &$\bullet$ SGML
 &$\bullet$ \LaTeX
 &$\bullet$ CL 
 &$\bullet$ PAL\\

$\bullet$ TMAPI
 &$\bullet$ Mappa
 &$\bullet$ OWL
 &$\bullet$ OKBC
 &$\bullet$ VRML\\

\end{ncolumn}
"""

header = "\\begin{ncolumn}{%(num_col)s}\n"
footer = "\\end{ncolumn}\n"
cell   = "$\\bullet$ %(cell_val)s"
cell_delim = "\n &"
column_after = "\\\\\n\n"

things = """
Python,  Javascript, Coffeescript, ObjC, Postscript, SQL, Bash, Java
Scheme,  Smalltalk, Erlang, C, Perl, AWK, LISP, RPG/400
HTML5, CSS, SVG, PhoneGap, XML
DocBook, SGML, \LaTeX, CL, NodeJS
TMAPI, Mappa, OWL, OKBC, WebMachine
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
    print format_as_bullet_table(pivot(them,noop=True))
    print "=" * 80
    print format_as_bullet_table(pivot(them))

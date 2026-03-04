project('espresso', 'c',
  version: '0.0.0',
  default_options: ['c_std=c99', 'warning_level=2'],
)

src = files(
  'espresso/cofactor.c',
  'espresso/cols.c',
  'espresso/compl.c',
  'espresso/contain.c',
  'espresso/cubestr.c',
  'espresso/cvrin.c',
  'espresso/cvrm.c',
  'espresso/cvrmisc.c',
  'espresso/cvrout.c',
  'espresso/dominate.c',
  'espresso/espresso.c',
  'espresso/essen.c',
  'espresso/expand.c',
  'espresso/gasp.c',
  'espresso/gimpel.c',
  'espresso/globals.c',
  'espresso/indep.c',
  'espresso/irred.c',
  'espresso/main.c',
  'espresso/matrix.c',
  'espresso/mincov.c',
  'espresso/part.c',
  'espresso/reduce.c',
  'espresso/rows.c',
  'espresso/set.c',
  'espresso/setc.c',
  'espresso/sminterf.c',
  'espresso/solution.c',
  'espresso/sparse.c',
  'espresso/unate.c',
)

espresso_exe = executable('espresso', src, install: true)

# Man page (optional)
build_doc_opt = get_option('build_doc')
asciidoctor = find_program('asciidoctor', required: build_doc_opt.enabled())
if not build_doc_opt.disabled() and asciidoctor.found()
  man1 = custom_target('espresso.1',
    input: 'doc/espresso.adoc',
    output: 'espresso.1',
    command: [asciidoctor, '-b', 'manpage', '-o', '@OUTPUT@', '@INPUT@'],
    install: true,
    install_dir: get_option('mandir') / 'man1',
  )
endif

# Test cases: run espresso with each PLA file from examples/
pla_list = [
  'examples/al2', 'examples/alcom', 'examples/alu1', 'examples/alu2', 'examples/alu3',
  'examples/amd', 'examples/apla', 'examples/b10', 'examples/b2', 'examples/b3',
  'examples/b4', 'examples/b7', 'examples/bc0', 'examples/bca', 'examples/bcb',
  'examples/bcc', 'examples/bcd', 'examples/br1', 'examples/br2', 'examples/check',
  'examples/check1', 'examples/check2', 'examples/chkn', 'examples/clpl', 'examples/dc1',
  'examples/dc2', 'examples/dekoder', 'examples/dist', 'examples/dk17', 'examples/dk27',
  'examples/dk48', 'examples/ex7', 'examples/exep', 'examples/exp', 'examples/exps',
  'examples/f51m', 'examples/gary', 'examples/in0', 'examples/in1', 'examples/in2',
  'examples/in3', 'examples/in4', 'examples/in5', 'examples/in6', 'examples/in7',
  'examples/intb', 'examples/lin.rom', 'examples/luc', 'examples/m1', 'examples/m2',
  'examples/m3', 'examples/m4', 'examples/mark1', 'examples/max1024', 'examples/max128',
  'examples/max46', 'examples/max512', 'examples/mlp4', 'examples/mp2d', 'examples/mytest',
  'examples/mytest2', 'examples/mytest3', 'examples/newapla', 'examples/newapla1',
  'examples/newapla2', 'examples/newbyte', 'examples/newcond', 'examples/newcpla1',
  'examples/newcpla2', 'examples/newcwp', 'examples/newill', 'examples/newtag',
  'examples/newtpla', 'examples/newtpla1', 'examples/newtpla2', 'examples/newxcpla1',
  'examples/opa', 'examples/p82', 'examples/pope.rom', 'examples/prom1', 'examples/prom2',
  'examples/risc', 'examples/root', 'examples/ryy6', 'examples/sex', 'examples/sqn',
  'examples/sqr6', 'examples/t1', 'examples/t2', 'examples/t3', 'examples/t4',
  'examples/tcheck', 'examples/tms', 'examples/vg2', 'examples/vtx1', 'examples/wim',
  'examples/x1dn', 'examples/x6dn', 'examples/x9dn',
  'hard_examples/ex1010', 'hard_examples/ex4', 'hard_examples/ibm', 'hard_examples/jbp',
  'hard_examples/mainpla', 'hard_examples/misg', 'hard_examples/mish', 'hard_examples/misj',
  'hard_examples/pdc', 'hard_examples/shift', 'hard_examples/signet', 'hard_examples/soar.pla',
  'hard_examples/test2', 'hard_examples/test3', 'hard_examples/ti', 'hard_examples/ts10',
  'hard_examples/x2dn', 'hard_examples/x7dn', 'hard_examples/xparc',
  'tlex/5xp1.pla', 'tlex/9sym.pla', 'tlex/alu4.pla', 'tlex/apex1.pla', 'tlex/apex2.pla',
  'tlex/apex3.pla', 'tlex/apex4.pla', 'tlex/apex5.pla', 'tlex/b12.pla', 'tlex/bw.pla',
  'tlex/clip.pla', 'tlex/con1.pla', 'tlex/cordic.pla', 'tlex/cps.pla', 'tlex/duke2.pla',
  'tlex/e64.pla', 'tlex/ex5.pla', 'tlex/inc.pla', 'tlex/misex1.pla', 'tlex/misex2.pla',
  'tlex/misex3c.pla', 'tlex/misex3.pla', 'tlex/rd53.pla', 'tlex/rd73.pla', 'tlex/rd84.pla',
  'tlex/sao2.pla', 'tlex/seq.pla', 'tlex/spla.pla', 'tlex/squar5.pla', 'tlex/t481.pla',
  'tlex/table3.pla', 'tlex/table5.pla', 'tlex/vg2.pla', 'tlex/xor5.pla', 'tlex/Z5xp1.pla',
  'tlex/Z9sym.pla',
]
sh = find_program('sh')
foreach pla : pla_list
  inp = join_paths(meson.source_root(), 'examples', pla)
  test('run_@0@'.format(pla.replace('/', '_').replace('.', '_')),
    sh,
    args: ['-c', '@0@ < "@1@"'.format(espresso_exe.full_path(), inp)],
    workdir: meson.current_build_dir(),
    timeout: 10,
  )
endforeach

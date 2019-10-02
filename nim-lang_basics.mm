<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1498676106065" ID="ID_1746153854" MODIFIED="1498682677707" TEXT="nim">
<node CREATED="1498682608078" ID="ID_170898337" MODIFIED="1510425898538" POSITION="right" TEXT="templating">
<node CREATED="1500414628494" ID="ID_1426719416" MODIFIED="1500414639258" TEXT="untyped">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    Because templates with not

    <p>
      <tt class="docutils literal">untyped</tt>&#160;(that is typed) arguments expand later, when types of actual arguments are known; they could not be called otherwise. And templates with only <tt class="docutils literal">untyped</tt>&#160;arguments don't depend on types of actual arguments on call site (because of no type check) and can be expanded immediately, what <tt class="docutils literal">{.immediate.}</tt>&#160;stands for.
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1498682612309" ID="ID_220621999" MODIFIED="1510425900689" POSITION="right" TEXT="macros">
<node CREATED="1503226113322" ID="ID_1806158304" MODIFIED="1503226118651" TEXT="term rewriting macros"/>
<node CREATED="1510425913812" ID="ID_1631006464" MODIFIED="1510425925679" TEXT="dsl_example">
<node CREATED="1510425928485" ID="ID_1167082728" MODIFIED="1510425977891" TEXT="">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre class="listing" style="color: rgb(245, 245, 245); margin-top: 0px; margin-right: 0px; margin-bottom: 10pt; margin-left: 0px; padding-top: 15px; padding-bottom: 15px; padding-right: 10px; padding-left: 10px; font-size: 10pt; font-style: normal; line-height: 14pt; background-position: 0, 0,; background-image: null; background-repeat: repeat; background-attachment: scroll; font-family: DejaVu Sans Mono, monospace; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px"><font color="rgb(67, 168, 207)"><b>import</b></font> macros
<font color="rgb(67, 168, 207)"><b>from</b></font> strutils <font color="rgb(67, 168, 207)"><b>import</b></font> `<b>%</b>`
<font color="rgb(67, 168, 207)"><b>macro</b></font> <font color="rgb(67, 168, 207)"><b>Enum</b></font><b>*</b>(typeName, body) : untyped <b>=</b>
    <font color="rgb(67, 168, 207)"><b>let</b></font> enumVar <b>=</b> newIdentNode(<font color="rgb(133, 77, 106)"><b>&quot;e&quot;</b></font>)
    <font color="rgb(67, 168, 207)"><b>let</b></font> strVar <b>=</b> newIdentNode(<font color="rgb(133, 77, 106)"><b>&quot;s&quot;</b></font>)
    
    <font color="rgb(67, 168, 207)"><b>var</b></font> caseConverterStatement <b>=</b> nnkCaseStmt<b>.</b>newTree(
        strVar
    )
    
    <font color="rgb(67, 168, 207)"><b>let</b></font> converterDecl <b>=</b> nnkConverterDef<b>.</b>newTree(
        newIdentNode(<font color="rgb(133, 77, 106)"><b>&quot;to&quot;</b></font> <b>&amp;</b> <b>$</b>typename<b>.</b>ident),
        newEmptyNode(),
        newEmptyNode(),
        nnkFormalParams<b>.</b>newTree(
            typename,
            nnkIdentDefs<b>.</b>newTree(
                strVar,
                newIdentNode(<font color="rgb(133, 77, 106)"><b>&quot;string&quot;</b></font>),
                newEmptyNode()
            )
        ),
        newEmptyNode(),
        newEmptyNode(),
        nnkstmtList<b>.</b>newTree(
            caseConverterStatement
        )
    )
    
    <font color="rgb(67, 168, 207)"><b>let</b></font> converterRaise <b>=</b> nnkElse<b>.</b>newTree(
        nnkstmtList<b>.</b>newTree(
            nnkRaiseStmt<b>.</b>newTree(
                nnkCall<b>.</b>newTree(
                    newIdentNode(<font color="rgb(133, 77, 106)"><b>&quot;newException&quot;</b></font>),
                    newIdentNode(<font color="rgb(133, 77, 106)"><b>&quot;ValueError&quot;</b></font>),
                    nnkInfix<b>.</b>newTree(
                        bindSym(<font color="rgb(133, 77, 106)"><b>&quot;%&quot;</b></font>),
                        newStrLitNode(<font color="rgb(133, 77, 106)"><b>&quot;could not convert string '$#' to &quot;</b></font> <b>&amp;</b> <b>$</b>typename<b>.</b>ident),
                        nnkBracket<b>.</b>newTree(
                            strVar
                        )
                    )
                )
            )
        )
    )
    <font color="rgb(67, 168, 207)"><b>let</b></font> makeConverterBranch <b>=</b> <font color="rgb(67, 168, 207)"><b>proc</b></font>(typeName, enumName : NimNode, enumStr <b>=</b> newEmptyNode()) : NimNode <b>=</b>
        nnkOfbranch<b>.</b>newtree(
            <font color="rgb(67, 168, 207)"><b>if</b></font> enumStr<b>.</b>kind() <b>==</b> nnkStrLit: enumStr  <font color="rgb(67, 168, 207)"><b>else</b></font>: newStrLitNode(<b>$</b>enumName<b>.</b>ident),
            nnkstmtList<b>.</b>newTree(
                nnkReturnStmt<b>.</b>newTree(
                    nnkDotExpr<b>.</b>newTree(
                        typeName,
                        enumName
                    )
                )
            )
        )
    
    
    <font color="rgb(67, 168, 207)"><b>let</b></font> makeDollarBranch <b>=</b> <font color="rgb(67, 168, 207)"><b>proc</b></font>(typeName, enumName : NimNode, enumStr <b>=</b> newEmptyNode()) : NimNode <b>=</b>
        nnkOfbranch<b>.</b>newtree(
            nnkDotExpr<b>.</b>newTree(
                typename,
                enumName
            ),
            nnkstmtList<b>.</b>newTree(
                <font color="rgb(67, 168, 207)"><b>if</b></font> enumStr<b>.</b>kind() <b>==</b> nnkStrLit: enumStr  <font color="rgb(67, 168, 207)"><b>else</b></font>: newStrLitNode(<b>$</b>enumName<b>.</b>ident)
            )
        )
    <font color="rgb(67, 168, 207)"><b>var</b></font> caseDollarStatement <b>=</b> nnkCaseStmt<b>.</b>newTree(
        enumVar
    )
    <font color="rgb(67, 168, 207)"><b>let</b></font> dollarDecl <b>=</b> nnkProcDef<b>.</b>newTree(
        nnkAccQuoted<b>.</b>newTree(
            newIdentNode(<font color="rgb(133, 77, 106)"><b>&quot;$&quot;</b></font>),
        ),
        newEmptyNode(),
        newEmptyNode(),
        nnkFormalParams<b>.</b>newTree(
            newIdentNode(<font color="rgb(133, 77, 106)"><b>&quot;string&quot;</b></font>),
            nnkIdentDefs<b>.</b>newtree(
                enumVar,
                typeName,
                newEmptyNode()
            )
        ),
        newEmptyNode(),
        newEmptyNode(),
        nnkstmtList<b>.</b>newTree(
            caseDollarStatement
        )
    )
    
    <font color="rgb(67, 168, 207)"><b>var</b></font> enumNames <b>=</b> nnkEnumTy<b>.</b>newTree(newEmptyNode())
    <font color="rgb(67, 168, 207)"><b>let</b></font> enumDecl <b>=</b> nnkTypeSection<b>.</b>newtree(
        nnkTypeDef<b>.</b>newtree(
            typeName, newEmptyNode(), enumNames
        )
    )
    <font color="rgb(67, 168, 207)"><b>for</b></font> child <font color="rgb(67, 168, 207)"><b>in</b></font> body:
        <font color="rgb(67, 168, 207)"><b>case</b></font> child<b>.</b>kind:
            <font color="rgb(67, 168, 207)"><b>of</b></font> nnkIdent:
                enumNames<b>.</b>add(child)
                caseDollarStatement<b>.</b>add(makeDollarBranch(typeName, child))
                caseConverterStatement<b>.</b>add(makeConverterBranch(typeName,child))
            <font color="rgb(67, 168, 207)"><b>of</b></font> nnkAsgn:
                enumNames<b>.</b>add(child[<font color="rgb(138, 182, 71)">0</font>])
                caseDollarStatement<b>.</b>add(makeDollarBranch(typeName, child[<font color="rgb(138, 182, 71)">0</font>], child[<font color="rgb(138, 182, 71)">1</font>]))
                caseConverterStatement<b>.</b>add(makeConverterBranch(typeName,child[<font color="rgb(138, 182, 71)">0</font>], child[<font color="rgb(138, 182, 71)">1</font>]))
            <font color="rgb(67, 168, 207)"><b>else</b></font>:
                <font color="rgb(67, 168, 207)"><b>discard</b></font>
    caseConverterStatement<b>.</b>add(converterRaise)
    result <b>=</b> nnkstmtList<b>.</b>newTree(
        enumDecl,
        dollarDecl,
        converterDecl
    )

<font color="rgb(109, 109, 109)"><i>################# Usage #########################</i></font>

<font color="rgb(67, 168, 207)"><b>Enum</b></font>(Roles):
    user; manager
    catering <b>=</b> <font color="rgb(133, 77, 106)"><b>&quot;whatever&quot;</b></font>
    sysadmin

<font color="rgb(67, 168, 207)"><b>block</b></font>:
    <font color="rgb(67, 168, 207)"><b>let</b></font> user <b>=</b> Roles<b>.</b>user
    <font color="rgb(67, 168, 207)"><b>let</b></font> manager <b>=</b> Roles<b>.</b>manager
    <font color="rgb(67, 168, 207)"><b>let</b></font> catering <b>=</b> Roles<b>.</b>catering
    
    echo user
    echo manager
    echo catering
    
    <font color="rgb(67, 168, 207)"><b>var</b></font> u <b>=</b> Roles(<font color="rgb(133, 77, 106)"><b>&quot;user&quot;</b></font>)
    echo u <b>==</b> Roles<b>.</b>user</pre>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1510171019387" ID="ID_740645296" MODIFIED="1510171019387" POSITION="left" TEXT=""/>
<node CREATED="1498682629243" ID="ID_811153036" MODIFIED="1510171058596" POSITION="left" TEXT="configuration">
<node CREATED="1498685470754" ID="ID_1965818521" MODIFIED="1498685479107" TEXT="package_manager">
<node CREATED="1498682638146" ID="ID_8043120" MODIFIED="1498682640975" TEXT="nimble">
<node CREATED="1510171071784" ID="ID_1732643198" MODIFIED="1510171078494" TEXT="build_tool"/>
</node>
</node>
<node CREATED="1505368313753" ID="ID_255458616" MODIFIED="1505368356663" TEXT="testing">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      snippet from forum:
    </p>
    <p>
      
    </p>
    <p>
      task test, &quot;Runs the test suite&quot;:
    </p>
    <p>
      &#160;&#160;configForTests()
    </p>
    <p>
      &#160;&#160;var dir_list = listDirs(&quot;test&quot;)
    </p>
    <p>
      &#160;&#160;dir_list.add(&quot;test&quot;)
    </p>
    <p>
      &#160;&#160;keepItIf(dir_list, it != &quot;test/nimcache&quot;)
    </p>
    <p>
      &#160;&#160;for dir in dir_list:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;for file in listFiles(dir):
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var (_, _, ext) = splitFile(file)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if ext == &quot;.nim&quot;:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;echo &quot;running ---- &quot; &amp; file
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;exec r&quot;nim c -r &quot; &amp; file
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1510171043161" ID="ID_1945294755" MODIFIED="1510171066080" TEXT="nimscript">
<node CREATED="1510171083721" ID="ID_1257192253" MODIFIED="1510171092751" TEXT="scripting build_tool">
<node CREATED="1510171098272" ID="ID_692533908" MODIFIED="1510171101690" TEXT="examples"/>
</node>
</node>
</node>
<node CREATED="1498682710411" ID="ID_548533439" MODIFIED="1498682713449" POSITION="left" TEXT="IO"/>
<node CREATED="1498683974763" ID="ID_370723415" MODIFIED="1510171284672" POSITION="right" TEXT="configuration">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      search-path of the nim.cfg file:
    </p>
  </body>
</html></richcontent>
<node CREATED="1498683984547" ID="ID_573116534" MODIFIED="1498683990294" TEXT="nim_cfg"/>
</node>
<node CREATED="1498684080370" ID="ID_1289210672" MODIFIED="1510171276447" POSITION="left" TEXT="language_features">
<node CREATED="1498684093690" ID="ID_1513976322" MODIFIED="1498684096743" TEXT="overloading"/>
<node CREATED="1498684127847" ID="ID_244415361" MODIFIED="1570008536995" TEXT="closures">
<node CREATED="1505335704684" ID="ID_596239143" MODIFIED="1505335732365" TEXT="closure_iterator">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      from the manual:
    </p>
    <p>
      
    </p>
    <p>
      &#160;iterator count0(): int {.closure.} =
    </p>
    <p>
      &#160;&#160;yield 0
    </p>
    <p>
      
    </p>
    <p>
      iterator count2(): int {.closure.} =
    </p>
    <p>
      &#160;&#160;var x = 1
    </p>
    <p>
      &#160;&#160;yield x
    </p>
    <p>
      &#160;&#160;inc x
    </p>
    <p>
      &#160;&#160;yield x
    </p>
    <p>
      
    </p>
    <p>
      proc invoke(iter: iterator(): int {.closure.}) =
    </p>
    <p>
      &#160;&#160;for x in iter(): echo x
    </p>
    <p>
      
    </p>
    <p>
      invoke(count0)
    </p>
    <p>
      invoke(count2)
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1498684136461" ID="ID_1143638778" MODIFIED="1498684141022" TEXT="generics">
<node CREATED="1498684163145" ID="ID_1660996504" MODIFIED="1498684175969" TEXT="constraints">
<node CREATED="1503757829231" ID="ID_714376268" MODIFIED="1503757829231" TEXT=""/>
<node CREATED="1498684179113" ID="ID_548772856" MODIFIED="1503757871950" TEXT="concepts">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      concept doc https://nim-lang.org/docs/manual.html#generics-concepts
    </p>
  </body>
</html></richcontent>
<node CREATED="1503757789695" ID="ID_52386983" MODIFIED="1503757819306" TEXT="{.explain.} pragma for compiler output"/>
<node CREATED="1503757842742" ID="ID_1886245369" MODIFIED="1503757842742" TEXT=""/>
</node>
</node>
<node CREATED="1505250932662" ID="ID_1043319762" MODIFIED="1505321972358" TEXT="generic_procs">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      code provided by flyx (stackoverflow question on generic procs):
    </p>
    <p>
      
    </p>
    <pre style="margin-top: 0px; margin-right: 0px; margin-bottom: 0; margin-left: 0px; padding-top: 5px; padding-right: 5px; padding-bottom: 5px; padding-left: 5px; border-top-style: none; border-top-width: 0px; border-right-style: none; border-right-width: 0px; border-bottom-style: none; border-bottom-width: 0px; border-left-style: none; border-left-width: 0px; font-style: normal; font-weight: normal; font-size: 13px; line-height: inherit; font-family: Consolas, Menlo, Monaco, Lucida Console, Liberation Mono, DejaVu Sans Mono, Bitstream Vera Sans Mono, Courier New, monospace, sans-serif; vertical-align: baseline; background-color: rgb(239, 240, 241); color: rgb(36, 39, 41); letter-spacing: normal; text-align: left; text-indent: 0px; text-transform: none; word-spacing: 0px"><code style="margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; border-top-style: none; border-top-width: 0px; border-right-style: none; border-right-width: 0px; border-bottom-style: none; border-bottom-width: 0px; border-left-style: none; border-left-width: 0px; font-style: inherit; font-variant: inherit; font-weight: normal; font-size: 13px; line-height: inherit; font-family: Consolas, Menlo, Monaco, Lucida Console, Liberation Mono, DejaVu Sans Mono, Bitstream Vera Sans Mono, Courier New, monospace, sans-serif; vertical-align: baseline; background-color: rgb(239, 240, 241); white-space: inherit"><font size="13px" face="Consolas, Menlo, Monaco, Lucida Console, Liberation Mono, DejaVu Sans Mono, Bitstream Vera Sans Mono, Courier New, monospace, sans-serif">import tables

type
  Strategy*[T] = proc(t: T) {.gcsafe, locks: 0.}

proc fooStrategy[T](t: T) = echo &quot;foo&quot;
proc barStrategy[T](t: T) = echo &quot;bar&quot;

let strategies* = toTable[string, Strategy[int]]([
    (&quot;foo&quot;, fooStrategy[int]), (&quot;bar&quot;, barStrategy[int])
])</font></code></pre>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1498684097465" ID="ID_1975019705" MODIFIED="1498684100210" TEXT="procs"/>
<node CREATED="1541487742789" ID="ID_1478936303" MODIFIED="1541487829005" TEXT="tuples">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      tuple as container; tuple fields can be omitted
    </p>
    <p>
      let (x, _ , y) = procxy()
    </p>
  </body>
</html></richcontent>
<node CREATED="1541489236349" ID="ID_812096682" MODIFIED="1541489244817" TEXT="tuple_unpacking"/>
</node>
<node CREATED="1498684100737" ID="ID_368552159" MODIFIED="1498684102885" TEXT="objects">
<node CREATED="1504950278103" ID="ID_466848037" MODIFIED="1504950291785" TEXT="ref object construction">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre class="listing">var s = (ref Person)(age: 3, name: &quot;Burns&quot;)</pre>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1498684226137" ID="ID_1540563500" MODIFIED="1498684232665" TEXT="memory management">
<node CREATED="1498684236681" ID="ID_1701151496" MODIFIED="1541488047645" TEXT="GC">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      std gc is thread local, so each spawned thread owns it's one gc.
    </p>
    <p>
      due to that you should not pass references (tracked ptr's) to another thread. just pass
    </p>
    <p>
      ptr's or obj by copy only.
    </p>
    <p>
      
    </p>
    <p>
      possible gc-types:
    </p>
    <p>
      
    </p>
    <ul class="simple" style="margin-top: 0; margin-right: 0px; margin-bottom: 0; margin-left: 0; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; list-style: disc inside; color: rgb(41, 41, 41); font-family: -apple-system, system-ui, BlinkMacSystemFont, Segoe UI, Roboto, Helvetica Neue, sans-serif; font-size: 16px; font-style: normal; font-weight: 400; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px; background-color: rgb(255, 255, 255)">
      <li style="margin-top: 0">
        <tt class="docutils literal" style="font-family: SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace; font-size: 13.6px; line-height: 1.2; padding-top: 0; padding-bottom: 0; padding-right: 0; padding-left: 0; background-color: rgb(248,; background-position: 248, 248); background-image: null; background-repeat: repeat; background-attachment: scroll; color: rgb(41, 41, 41)"><font face="SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace" size="13.6px" color="rgb(41, 41, 41)">markAndSweep</font></tt>: Fastest, uses more RAM.
      </li>
      <li style="margin-top: 0">
        <tt class="docutils literal" style="font-family: SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace; font-size: 13.6px; line-height: 1.2; padding-top: 0; padding-bottom: 0; padding-right: 0; padding-left: 0; background-color: rgb(248,; background-position: 248, 248); background-image: null; background-repeat: repeat; background-attachment: scroll; color: rgb(41, 41, 41)"><font face="SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace" size="13.6px" color="rgb(41, 41, 41)">Boehm</font></tt>: Slowest, uses less RAM.
      </li>
      <li style="margin-top: 0">
        <tt class="docutils literal" style="font-family: SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace; font-size: 13.6px; line-height: 1.2; padding-top: 0; padding-bottom: 0; padding-right: 0; padding-left: 0; background-color: rgb(248,; background-position: 248, 248); background-image: null; background-repeat: repeat; background-attachment: scroll; color: rgb(41, 41, 41)"><font face="SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace" size="13.6px" color="rgb(41, 41, 41)">Go</font></tt>: Go lang like implementation.
      </li>
      <li style="margin-top: 0">
        <tt class="docutils literal" style="font-family: SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace; font-size: 13.6px; line-height: 1.2; padding-top: 0; padding-bottom: 0; padding-right: 0; padding-left: 0; background-color: rgb(248,; background-position: 248, 248); background-image: null; background-repeat: repeat; background-attachment: scroll; color: rgb(41, 41, 41)"><font face="SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace" size="13.6px" color="rgb(41, 41, 41)">Regions</font></tt>: Kinda slow-ish, works by regions of memory.
      </li>
      <li style="margin-top: 0">
        <tt class="docutils literal" style="font-family: SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace; font-size: 13.6px; line-height: 1.2; padding-top: 0; padding-bottom: 0; padding-right: 0; padding-left: 0; background-color: rgb(248,; background-position: 248, 248); background-image: null; background-repeat: repeat; background-attachment: scroll; color: rgb(41, 41, 41)"><font face="SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace" size="13.6px" color="rgb(41, 41, 41)">RefC</font></tt>: Reference counting, default.
      </li>
      <li style="margin-top: 0">
        <tt class="docutils literal" style="font-family: SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace; font-size: 13.6px; line-height: 1.2; padding-top: 0; padding-bottom: 0; padding-right: 0; padding-left: 0; background-color: rgb(248,; background-position: 248, 248); background-image: null; background-repeat: repeat; background-attachment: scroll; color: rgb(41, 41, 41)"><font face="SF Mono, Segoe UI Mono, Roboto Mono, Menlo, Courier, monospace" size="13.6px" color="rgb(41, 41, 41)">none</font></tt>: No GC.
      </li>
    </ul>
  </body>
</html></richcontent>
</node>
<node CREATED="1541487992239" ID="ID_1884200006" MODIFIED="1541488003303" TEXT="memory_regions"/>
</node>
<node CREATED="1500414772206" ID="ID_151205169" MODIFIED="1500414778148" TEXT="target_javascript"/>
<node CREATED="1500414966187" ID="ID_1820349094" MODIFIED="1500414967525" TEXT="asm"/>
<node CREATED="1503194380475" ID="ID_1411707158" MODIFIED="1510171132937" TEXT="memory_layout">
<node CREATED="1510171137112" ID="ID_1861501882" MODIFIED="1510171149978" TEXT="backend C/Cpp">
<node CREATED="1510171153576" ID="ID_1626517258" MODIFIED="1510171177299" TEXT="ptr vs ref "/>
<node CREATED="1510171177822" ID="ID_251259496" MODIFIED="1510171188657" TEXT="stack vs heap"/>
<node CREATED="1541488129459" ID="ID_834628631" MODIFIED="1541488138964" TEXT="include header_file"/>
<node CREATED="1541488141256" ID="ID_1558408842" MODIFIED="1541488146474" TEXT="conditional compilation"/>
</node>
</node>
<node CREATED="1503194764047" ID="ID_224617102" MODIFIED="1503194768985" TEXT="identifier mangling"/>
<node CREATED="1503226133026" ID="ID_1662866163" MODIFIED="1503226206370" TEXT="shallow vs deep_copy">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre class="listing">template `:=` (x: var seq[T]; v: seq[T]) =
    shallowCopy(x, v)

# used like this
var s0 = @[1,2,3]
let s1 = s0 # no copy is made since s1 cannot be modified
var s2 = s0 # a copy is made here (unless s0 was marked as shallow)
var s3: seq[int]
s3&#160;:=&#160;s0&#160;# custom template use shallowCopy

---------------------------------------------</pre>
    <div>
      <p>
        1. This is the result of copying from <tt class="docutils literal">arr</tt>&#160;to <tt class="docutils literal">result</tt>, not the actual return (<tt class="docutils literal">return x</tt>&#160;does an implicit <tt class="docutils literal">result = x</tt>). The following code avoids it:
      </p>
      <p>
        
      </p>
      <pre class="listing">proc foo(): seq[int] =
  result = @[1, 2, 3]
  echo cast[int](result[0].addr)

var arr = foo()
echo cast[int](arr[0].addr)</pre>
      <p>
        
      </p>
      <p>
        You can also avoid copying by using <tt class="docutils literal">let</tt>&#160;instead of <tt class="docutils literal">var</tt>&#160; (the copying is done to avoid aliasing). Passing a value to a procedure will also not copy it.
      </p>
      <p>
        2. There is a <tt class="docutils literal">shallowCopy</tt>&#160;that avoids the copying. Note that <tt class="docutils literal">shallowCopy</tt>&#160; is unsafe when the target is a global variable or managed heap location and the source is a constant. You can avoid the unsafety via using a version where the right-hand side must be mutable, e.g.:
      </p>
      <p>
        
      </p>
      <pre class="listing">proc `&lt;-`[T](lhs: var T, rhs: var T) {.noSideEffect, magic: &quot;ShallowCopy&quot;.}</pre>
      <p>
        
      </p>
      <p>
        3. If throughput is your concern, then manual memory management won't help you much per se. The primary cost of the the GC in Nim is the allocation/deallocation overhead (plus the write barrier, but you incur that only if you write a reference to a heap location or global variable), and you incur that in C/C++ also, unless you use custom allocation schemes. I know that Araq is also working on a region-based collector, which might alleviate the overhead (enabled via <tt class="docutils literal">--gc:stack</tt>, not sure how mature it is). Note that RAII in particular may not help you much; reference counting as in <tt class="docutils literal">std::shared_ptr</tt>&#160;has overhead than Nim's GC, and something like <tt class="docutils literal">std::unique_ptr</tt>&#160;is either not memory-safe or incurs significant overhead (C++ chose the memory-unsafe option). In order to have memory-safe move semantics without overhead, you need linear or affine types, which would be a significant increase in language complexity.
      </p>
    </div>
  </body>
</html></richcontent>
</node>
<node CREATED="1503226942492" ID="ID_149467381" MODIFIED="1505338160159" TEXT="runtime polymorphism">
<node CREATED="1503226955261" ID="ID_1327738977" MODIFIED="1503226967515" TEXT="interfaces">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    For interfaces that lead to runtime polymorphism a tuple of closures is equivalent:

    <pre class="listing">type
  ITest = tuple[
    setter: proc(v: int) {.closure.},
    getter1: proc(): int {.closure.},
    getter2: proc(): int {.closure.}]

proc getInterf(): ITest =
  var shared1, shared2: int
  
  return (setter: proc (x: int) =
            shared1 = x
            shared2 = x + 10,
          getter1: proc (): int = result = shared1,
          getter2: proc (): int = return shared2)

var i = getInterf()
i.setter(56)

echo i.getter1(), &quot; &quot;, i.getter2()</pre>
  </body>
</html></richcontent>
</node>
<node CREATED="1503226977252" ID="ID_1013577048" MODIFIED="1503227084382" TEXT="procvar vs closure">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      <strong>taken from: </strong>
    </p>
    <p>
      <strong>https://forum.nim-lang.org/t/278/2 </strong>
    </p>
    <p>
      
    </p>
    <p>
      <strong>procvar vs. closure:</strong>&#160;You usually don't need to explicitly annotate a procedure with <tt class="docutils literal">{.procvar.}</tt>, unless you're importing it from a different module; the compiler will tell you if you can't assign it to a procedure variable. The difference between procvar and a closure is basically that a procvar is a raw pointer to a procedure, while a closure is a pair (pointer to procedure, reference to environment). These need to be declared because they are fundamentally different types (pointer vs. pair of pointers).
    </p>
    <p>
      <strong>T(x) vs. cast[T](x):</strong>&#160;<tt class="docutils literal">T(x)</tt>&#160;is the safe version, <tt class="docutils literal">cast[T](x)</tt>&#160; is the unsafe version. <tt class="docutils literal">cast[T](x)</tt>&#160;will just reinterpret the underlying bitpattern, <tt class="docutils literal">T(x)</tt>&#160;is smart about converting types and only allows it where safe. It's like <tt class="docutils literal">(T)x</tt>&#160;vs. <tt class="docutils literal">reinterpret_cast&lt;T&gt;(x)</tt>&#160; in C++.
    </p>
    <p>
      <strong>proc vs. method references, parentheses or not:</strong>&#160;Both <tt class="docutils literal">ob.m</tt>&#160; and <tt class="docutils literal">ob.m()</tt>&#160;will call the method <tt class="docutils literal">m</tt>. To create a function that calls <tt class="docutils literal">ob.m</tt>, you have to use <tt class="docutils literal">proc() = ob.m</tt>&#160;or <tt class="docutils literal">proc = ob.m()</tt>&#160;(both of which are equivalent). Why is it different for procedures? It isn't actually any different: <tt class="docutils literal">m</tt>&#160;above would return a method reference. A hypothetical syntax <tt class="docutils literal">ob.m</tt>&#160;for what you were looking for would not return a method reference, but a binding of <tt class="docutils literal">m</tt>&#160; to <tt class="docutils literal">ob</tt>. There is no such thing as a method reference when one of the arguments is instantiated. You can either have a reference to the unbound method via <tt class="docutils literal">m</tt>&#160;or create a closure that gives you the binding via <tt class="docutils literal">proc() = ob.m</tt>.
    </p>
    <p>
      <strong>ref proc():</strong>&#160;A procedure reference is a constant; you cannot have a reference for it anymore than you can create a reference to the integer constant 1 or the floating point constant 3.14; if you declare a variable <tt class="docutils literal">var p: ref proc()</tt>&#160;then you have to instantiate it with <tt class="docutils literal">new p</tt>&#160;and assign to its contents with <tt class="docutils literal">p[] = AProc</tt>.
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1503227235112" ID="ID_30199492" MODIFIED="1504896369027" TEXT="pragmas">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      all pragmas are defined in&#160;&#160;compiler/pragmax.nim
    </p>
    <p>
      
    </p>
    <p>
      implementation specific pragmas:
    </p>
    <p>
      https://nim-lang.org/docs/manual.html#implementation-specific-pragmas-compile-pragma
    </p>
  </body>
</html></richcontent>
<node CREATED="1503240451971" ID="ID_1200421313" MODIFIED="1503760743745" TEXT="compiler/linker hints">
<node CREATED="1503758132675" ID="ID_777733734" MODIFIED="1503758341668" TEXT="noInit"/>
<node CREATED="1503758341987" ID="ID_1425595966" MODIFIED="1503758345256" TEXT="requiresInit"/>
<node CREATED="1503758345777" ID="ID_1963958646" MODIFIED="1503758355133" TEXT="deprecated"/>
<node CREATED="1503758355536" ID="ID_1110849851" MODIFIED="1503758357674" TEXT="noReturn"/>
<node CREATED="1503227246098" ID="ID_1438401102" MODIFIED="1503827883453" TEXT="{.push.} {}.pop.">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      compile time conditional symbols
    </p>
    <p>
      https://forum.nim-lang.org/t/797
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1503758149677" ID="ID_1236290839" MODIFIED="1510265161615" TEXT="semantic pragmas">
<node CREATED="1503758172619" ID="ID_1066771463" MODIFIED="1503758184027" TEXT="core_lang">
<node CREATED="1503761165614" ID="ID_816961283" MODIFIED="1503761172987" TEXT=".push."/>
<node CREATED="1503760773675" ID="ID_1945568971" MODIFIED="1503760947578" TEXT=".global.">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      global variable
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1503760782869" ID="ID_199240977" MODIFIED="1503760787138" TEXT=".discardable."/>
<node CREATED="1503760788029" ID="ID_1512067610" MODIFIED="1503760957156" TEXT="borrow">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      borrow code from overloaded proc
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1503760797985" ID="ID_1618717544" MODIFIED="1503760799820" TEXT="raises"/>
<node CREATED="1503760800282" ID="ID_327609674" MODIFIED="1503760814893" TEXT="tags"/>
<node CREATED="1503760815266" ID="ID_1311489620" MODIFIED="1503760818377" TEXT="compileTime"/>
<node CREATED="1503760818844" ID="ID_193935891" MODIFIED="1503760824153" TEXT="nosideEffect"/>
<node CREATED="1503760830866" ID="ID_17286683" MODIFIED="1503828766896" TEXT="magic">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      all magics are defined in /compiler/ast.nim
    </p>
    <p>
      
    </p>
    <p>
      the magics is code which is implemented
    </p>
    <p>
      by the compilerr
    </p>
    <p>
      
    </p>
    <p>
      codegen:
    </p>
    <p>
      ccgexpressions.nim
    </p>
    <p>
      jsgen.nim
    </p>
    <p>
      
    </p>
  </body>
</html></richcontent>
<node CREATED="1503828616370" ID="ID_411438730" MODIFIED="1503828616370" TEXT=""/>
</node>
<node CREATED="1503760986289" ID="ID_617238977" MODIFIED="1503761013658" TEXT="procvar">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      used to qualify a proc which can be passed to a procedural variable
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1503758184501" ID="ID_1750686748" MODIFIED="1503758185967" TEXT="oop">
<node CREATED="1503760872385" ID="ID_1496222570" MODIFIED="1503760874194" TEXT="final"/>
<node CREATED="1503760874502" ID="ID_133777498" MODIFIED="1503760881741" TEXT="base"/>
<node CREATED="1503760882339" ID="ID_1633349323" MODIFIED="1503760885876" TEXT="ineritable"/>
</node>
<node CREATED="1503758186391" ID="ID_393317778" MODIFIED="1503758188878" TEXT="concurrency">
<node CREATED="1503760850186" ID="ID_985133944" MODIFIED="1503760852254" TEXT="thread"/>
<node CREATED="1503760852691" ID="ID_719803775" MODIFIED="1503760854495" TEXT="threadvar"/>
<node CREATED="1503760854998" ID="ID_1909257964" MODIFIED="1503760857561" TEXT="guard"/>
<node CREATED="1503760858087" ID="ID_1392142154" MODIFIED="1503760859923" TEXT="locks"/>
</node>
<node CREATED="1503758189224" ID="ID_666824613" MODIFIED="1503758191173" TEXT="templating"/>
</node>
<node CREATED="1503758209276" ID="ID_1181983192" MODIFIED="1510265158506" TEXT="FFI">
<node CREATED="1503758215412" ID="ID_817779628" MODIFIED="1503758227660" TEXT="union"/>
<node CREATED="1503758228157" ID="ID_740891689" MODIFIED="1503758229662" TEXT="packed"/>
<node CREATED="1503758230061" ID="ID_878482805" MODIFIED="1503758232467" TEXT="exportC"/>
<node CREATED="1503758232867" ID="ID_441270847" MODIFIED="1503758234848" TEXT="importC"/>
<node CREATED="1503758235370" ID="ID_1802033152" MODIFIED="1503758250558" TEXT="importCpp"/>
<node CREATED="1503758253034" ID="ID_1997373390" MODIFIED="1503758261570" TEXT="importObjC"/>
<node CREATED="1510265179779" ID="ID_1004805257" MODIFIED="1510265188124" TEXT="call Nim from C">
<node CREATED="1510265215143" ID="ID_839818279" MODIFIED="1510265218036" TEXT="prereq"/>
</node>
<node CREATED="1510265188627" ID="ID_833117893" MODIFIED="1510265196343" TEXT="Call C from Nim">
<node CREATED="1510265222484" ID="ID_526099431" MODIFIED="1510265225305" TEXT="prereq"/>
</node>
</node>
<node CREATED="1503758275161" ID="ID_1675306281" MODIFIED="1510265172521" TEXT="debug">
<node CREATED="1503758281145" ID="ID_1236426659" MODIFIED="1503758291251" TEXT=".breakpoint."/>
<node CREATED="1503758291559" ID="ID_210869114" MODIFIED="1503758295796" TEXT=".watchpoint."/>
<node CREATED="1503758296324" ID="ID_582939960" MODIFIED="1503758306068" TEXT="debugger."/>
<node CREATED="1503758306508" ID="ID_269507514" MODIFIED="1503758309046" TEXT=".profiler"/>
</node>
</node>
<node CREATED="1503240456970" ID="ID_800207004" MODIFIED="1503240461706" TEXT="compilation">
<node CREATED="1503240464930" ID="ID_625695694" MODIFIED="1503240472459" TEXT="bind statement"/>
<node CREATED="1503240476236" ID="ID_85287690" MODIFIED="1503240479709" TEXT="mixin statement"/>
<node CREATED="1503840559336" ID="ID_1720373617" MODIFIED="1503840640118" TEXT="conditional symbols">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre class="listing">{.push warning[User]: off.}
when defined(foo):
    {.pop.}
    include fooImpl
    {.push warning[User]: off.}
else:
    {.pop.}
    include dummyImpl
    {.push warning[User]: off.}
{.pop.}</pre>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1503765299120" ID="ID_1807511022" MODIFIED="1505367955931" TEXT="parallel features">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      roof operator ^
    </p>
  </body>
</html></richcontent>
<node CREATED="1503765402126" ID="ID_633700912" MODIFIED="1505367997454" TEXT="high level api">
<node CREATED="1503765695075" ID="ID_1312519583" MODIFIED="1503765699423" TEXT="threadpool"/>
<node CREATED="1503765699767" ID="ID_1221969889" MODIFIED="1505379502186" TEXT="IPC">
<node CREATED="1505379480856" ID="ID_1456314411" MODIFIED="1505379522793" TEXT="channel">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      needs to reside in global memory?
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1505368000077" ID="ID_621469335" MODIFIED="1505368014608" TEXT="spawn"/>
</node>
<node CREATED="1503765407962" ID="ID_130098578" MODIFIED="1505368021335" TEXT="low level api">
<node CREATED="1505337590848" ID="ID_843261305" MODIFIED="1505367987738" TEXT="self_callback">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      future with self-callback.
    </p>
    <p>
      if anything is calling: future.complete(val) then the callback is executed
    </p>
    <p>
      
    </p>
    <p>
      proc all(s: seq[Future[Response]]): Future[void] =
    </p>
    <p>
      &#160;&#160;var retFuture = newFuture[void](&quot;all&quot;)
    </p>
    <p>
      &#160;&#160;var counter = len s
    </p>
    <p>
      &#160;&#160;for i in 0..len(s)-1:
    </p>
    <p>
      &#160;&#160;&#160;&#160;s[i].callback =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;proc () =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;counter.dec
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if counter == 0:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;retFuture.complete()
    </p>
    <p>
      &#160;&#160;result = retFuture
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1505374864883" ID="ID_609717095" MODIFIED="1505374877677" TEXT="guards &amp; locks">
<node CREATED="1505374881402" ID="ID_450298877" MODIFIED="1505374885283" TEXT="locklevel"/>
</node>
<node CREATED="1505375279318" ID="ID_1399628417" MODIFIED="1505375350108" TEXT="parallel server example">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      # compile with&#160; <font color="rgb(29, 29, 29)" face="Helvetica, Arial, sans-serif" size="17.3333px">-d:release and --gc:markandsweep</font>
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      import nativesockets
    </p>
    <p>
      import asyncdispatch
    </p>
    <p>
      import net
    </p>
    <p>
      
    </p>
    <p>
      const content = &quot;xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx&quot;
    </p>
    <p>
      const response = &quot;HTTP/1.1 200 OK\r\LContent-Length: &quot; &amp; $content.len &amp; &quot;\r\LConnection:keep-alive\r\L\r\L&quot; &amp; content
    </p>
    <p>
      
    </p>
    <p>
      proc Idle() {.async.} =
    </p>
    <p>
      &#160;&#160;&#160;&#160;while true:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;await sleepAsync(100)
    </p>
    <p>
      
    </p>
    <p>
      type
    </p>
    <p>
      &#160;&#160;&#160;&#160;MultiAsyncCore = ref object
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Workers: seq[Worker]
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Listener: Socket
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;Worker = ref object
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;SockChan: Channel[Socket]
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;FCore: MultiAsyncCore
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      proc NewMultiAsyncCore*(port: int, address = &quot;127.0.0.1&quot;): MultiAsyncCore =
    </p>
    <p>
      &#160;&#160;&#160;&#160;var fcb = MultiAsyncCore()
    </p>
    <p>
      &#160;&#160;&#160;&#160;fcb.Workers = @[]
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;fcb.Listener = newSocket()
    </p>
    <p>
      &#160;&#160;&#160;&#160;fcb.Listener.bindAddr(Port(port), address)
    </p>
    <p>
      &#160;&#160;&#160;&#160;fcb.Listener.listen()
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;&#160;&#160;#GC_unref(fcb)-
    </p>
    <p>
      &#160;&#160;&#160;&#160;#GC_unref(fcb.Listener)
    </p>
    <p>
      &#160;&#160;&#160;&#160;#GC_unref(fcb.Workers)
    </p>
    <p>
      &#160;&#160;&#160;&#160;return fcb
    </p>
    <p>
      
    </p>
    <p>
      proc NewWorker(fc: MultiAsyncCore): Worker =
    </p>
    <p>
      &#160;&#160;&#160;&#160;var wb = Worker()
    </p>
    <p>
      &#160;&#160;&#160;&#160;wb.SockChan.open()
    </p>
    <p>
      &#160;&#160;&#160;&#160;wb.FCore = fc
    </p>
    <p>
      &#160;&#160;&#160;&#160;#GC_unref(wb)
    </p>
    <p>
      &#160;&#160;&#160;&#160;return wb
    </p>
    <p>
      
    </p>
    <p>
      proc HandleSock(sock: AsyncFD) {.async.} =
    </p>
    <p>
      &#160;&#160;&#160;&#160;while true:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;let data = await sock.recv(1024)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if data.len != 0:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;discard sock.send(response)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;else:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;sock.closeSocket()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;break
    </p>
    <p>
      
    </p>
    <p>
      proc Run(worker: Worker) {.thread.} =
    </p>
    <p>
      &#160;&#160;&#160;&#160;discard Idle()
    </p>
    <p>
      &#160;&#160;&#160;&#160;while true:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;let sockTuple = worker.SockChan.tryRecv()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if sockTuple.dataAvailable:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;#GC_unref(sockTuple.msg)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var afd = sockTuple.msg.getFd.AsyncFD()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;register(afd)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;discard HandleSock(afd)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;else:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;poll(1)
    </p>
    <p>
      
    </p>
    <p>
      proc AddWorker*(fc: MultiAsyncCore, num=3) =
    </p>
    <p>
      &#160;&#160;&#160;&#160;var threads = newSeq[Thread[Worker]](num)
    </p>
    <p>
      &#160;&#160;&#160;&#160;for thread in threads.mitems:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var worker = NewWorker(fc)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;fc.Workers.add(worker)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;thread.createThread(Run, worker)
    </p>
    <p>
      
    </p>
    <p>
      proc Accept(fc: MultiAsyncCore, worker: Worker) =
    </p>
    <p>
      &#160;&#160;&#160;&#160;try:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;var client: Socket = newSocket()
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;accept(fc.Listener, client)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;#GC_unref(client)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;client.getFd().setBlocking(false)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;worker.SockChan.send(client)
    </p>
    <p>
      &#160;&#160;&#160;&#160;except:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;discard
    </p>
    <p>
      
    </p>
    <p>
      proc Run*(fc: MultiAsyncCore) =
    </p>
    <p>
      &#160;&#160;&#160;&#160;while true:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;for worker in fc.Workers:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;fc.Accept(worker)
    </p>
    <p>
      
    </p>
    <p>
      var fcv = NewMultiAsyncCore(80)
    </p>
    <p>
      fcv.AddWorker(3) # 1 thread per core minus the listener loop.
    </p>
    <p>
      fcv.Run()
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505377215713" ID="ID_67579752" MODIFIED="1505377573702" TEXT="gc">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      type EnforcedGcSafe = proc() {.gcsafe.}
    </p>
    <p>
      
    </p>
    <p>
      proc myproc =
    </p>
    <p>
      &#160;&#160;discard &quot;... access shared heap here...&quot;
    </p>
    <p>
      
    </p>
    <p>
      spawn cast[EnforcedGcSafe](myproc)
    </p>
  </body>
</html></richcontent>
<node CREATED="1505377222041" ID="ID_1446030941" MODIFIED="1505377227180" TEXT="protect"/>
<node CREATED="1505377227735" ID="ID_384872817" MODIFIED="1505377229737" TEXT="dispose"/>
</node>
</node>
<node CREATED="1504950847208" ID="ID_72459242" MODIFIED="1504950856879" TEXT="standard library">
<node CREATED="1504950860464" ID="ID_1045827628" MODIFIED="1504950890732" TEXT="associative_arrays">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      import strutils, tables
    </p>
    <p>
      
    </p>
    <p>
      var
    </p>
    <p>
      &#160;&#160;arr = split(&quot;Blue Blue Red Green&quot;, &quot; &quot;)&#160;&#160;&#160;&#160;&#160;# list of words
    </p>
    <p>
      &#160;&#160;uniqarr = initTable[string, int]()&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# array to hold unique words
    </p>
    <p>
      
    </p>
    <p>
      for i in arr:&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# unique the list
    </p>
    <p>
      &#160;&#160;uniqarr[i] = 1
    </p>
    <p>
      
    </p>
    <p>
      for j in pairs(uniqarr):&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# echo the list
    </p>
    <p>
      &#160;&#160;echo j
    </p>
  </body>
</html></richcontent>
<node CREATED="1505368027277" ID="ID_707877605" MODIFIED="1505368027277" TEXT=""/>
</node>
<node CREATED="1505368031117" ID="ID_1580609120" MODIFIED="1505368082059" TEXT="asynchttpClient">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      from the forum:
    </p>
    <p>
      
    </p>
    <p>
      import asyncdispatch,
    </p>
    <p>
      &#160;&#160;httpclient, strutils
    </p>
    <p>
      
    </p>
    <p>
      proc asyncGet(s: string): Future[Response] =
    </p>
    <p>
      &#160;&#160;var client = newAsyncHttpClient()
    </p>
    <p>
      &#160;&#160;var st = s.strip()
    </p>
    <p>
      &#160;&#160;if not s.startsWith(&quot;http&quot;):
    </p>
    <p>
      &#160;&#160;&#160;&#160;st = &quot;http&quot; &amp; &quot;://&quot; &amp; s
    </p>
    <p>
      &#160;&#160;result = client.get(st)
    </p>
    <p>
      
    </p>
    <p>
      proc all(s: seq[Future[Response]]): Future[void] =
    </p>
    <p>
      &#160;&#160;var retFuture = newFuture[void](&quot;all&quot;)
    </p>
    <p>
      &#160;&#160;var counter = len s
    </p>
    <p>
      &#160;&#160;for i in 0..len(s)-1:
    </p>
    <p>
      &#160;&#160;&#160;&#160;s[i].callback =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;proc () =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;counter.dec
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;if counter == 0:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;retFuture.complete()
    </p>
    <p>
      &#160;&#160;result = retFuture
    </p>
    <p>
      
    </p>
    <p>
      proc main() {.async.} =
    </p>
    <p>
      &#160;&#160;let paths = @[&quot;http://google.com&quot;,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&quot;http://127.0.0.1:8080/file&quot;,
    </p>
    <p>
      &#160;&#160;&#160;&#160;&quot;127.0.0.1:8080/form/321&quot;]
    </p>
    <p>
      &#160;&#160;const cnt = 100
    </p>
    <p>
      &#160;&#160;var rest = newSeq[Future[Response]](cnt)
    </p>
    <p>
      &#160;&#160;for i in 0..cnt-1:
    </p>
    <p>
      &#160;&#160;&#160;&#160;rest[i] = asyncGet(paths[0])
    </p>
    <p>
      &#160;&#160;await all(rest)
    </p>
    <p>
      &#160;&#160;for i in rest:
    </p>
    <p>
      &#160;&#160;&#160;&#160;echo i.read().body
    </p>
    <p>
      
    </p>
    <p>
      waitFor main()
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505376068790" ID="ID_92981468" MODIFIED="1505512698537" TEXT="IO-Operation (singlethread)">
<node CREATED="1505251523672" ID="ID_847416573" MODIFIED="1505253807372" TEXT="asyncdispatch">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      extracted from: https://github.com/nim-lang/Nim/issues/3568
    </p>
    <p>
      
    </p>
    <p>
      import asyncdispatch
    </p>
    <p>
      
    </p>
    <p>
      proc test[T](x: T): Future[T] {.async.} =
    </p>
    <p>
      &#160;&#160;result = x + 5
    </p>
    <p>
      
    </p>
    <p>
      proc test2[T](x: T): Future[T] =
    </p>
    <p>
      &#160;&#160;var retFuture = newFuture[T](&quot;test&quot;)
    </p>
    <p>
      &#160;&#160;iterator test2Iter(): FutureBase {.closure.} =
    </p>
    <p>
      &#160;&#160;&#160;&#160;{.push, warning[resultshadowed]: off.}
    </p>
    <p>
      &#160;&#160;&#160;&#160;var result: T
    </p>
    <p>
      &#160;&#160;&#160;&#160;{.pop.}
    </p>
    <p>
      &#160;&#160;&#160;&#160;result = x + 5
    </p>
    <p>
      &#160;&#160;&#160;&#160;complete(retFuture, result)
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;createCb(retFuture, test2Iter, &quot;test2&quot;)
    </p>
    <p>
      &#160;&#160;return retFuture
    </p>
    <p>
      
    </p>
    <p>
      asyncCheck test2(5)
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505254788789" ID="ID_491236316" MODIFIED="1505254801880" TEXT="yield,await and so on">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/nim-lang/Nim/issues/4170
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1505321904091" ID="ID_531990820" MODIFIED="1505321962895" TEXT="static procs">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      proc is instanciated for each static value
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;proc foo(N: static[int]): void =
    </p>
    <p>
      &#160;&#160;var a: array[N, int]
    </p>
    <p>
      &#160;&#160;echo N
    </p>
    <p>
      
    </p>
    <p>
      echo foo(19)
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505336456579" ID="ID_638019919" MODIFIED="1505336463166" TEXT="special_statements">
<node CREATED="1505336467060" ID="ID_1803210435" MODIFIED="1505336539126" TEXT="defer">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <h2 style="font-family: Helvetica Neue, HelveticaNeue, Raleway, Helvetica, Arial, sans-serif; font-weight: 600; line-height: 20px; color: rgb(102, 102, 102); font-size: 1.5em; margin-top: 0; font-style: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      <a class="toc-backref" id="exception-handling-defer-statement" href="https://nim-lang.org/docs/manual.html#exception-handling-defer-statement" style="color: rgb(68, 68, 68); text-decoration: none"><font color="rgb(68, 68, 68)" size="2">from the manual:</font></a>
    </h2>
    <h2 style="font-family: Helvetica Neue, HelveticaNeue, Raleway, Helvetica, Arial, sans-serif; font-weight: 600; line-height: 20px; color: rgb(102, 102, 102); font-size: 1.5em; margin-top: 0; font-style: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      <a class="toc-backref" id="exception-handling-defer-statement" href="https://nim-lang.org/docs/manual.html#exception-handling-defer-statement" style="color: rgb(68, 68, 68); text-decoration: none"><font color="rgb(68, 68, 68)" size="3">Defer statement</font></a>
    </h2>
    <p style="margin-top: 0px; margin-right: 0px; margin-bottom: 12px; margin-left: 0px; color: rgb(102, 102, 102); font-family: Helvetica Neue, HelveticaNeue, Raleway, Helvetica, Arial, sans-serif; font-size: 14px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      Instead of a&#160;<tt class="docutils literal"><font face="Source Code Pro, Monaco, Menlo, Consolas, Courier New, monospace"><b>try finally</b></font></tt>&#160;statement a&#160;<tt class="docutils literal"><font face="Source Code Pro, Monaco, Menlo, Consolas, Courier New, monospace"><b>defer</b></font></tt>&#160;statement can be used.
    </p>
    <p style="margin-top: 0px; margin-right: 0px; margin-bottom: 12px; margin-left: 0px; color: rgb(102, 102, 102); font-family: Helvetica Neue, HelveticaNeue, Raleway, Helvetica, Arial, sans-serif; font-size: 14px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      Any statements following the&#160;<tt class="docutils literal"><font face="Source Code Pro, Monaco, Menlo, Consolas, Courier New, monospace"><b>defer</b></font></tt>&#160;in the current block will be considered to be in an implicit try block:
    </p>
    <pre class="listing" style="font-family: Source Code Pro, Monaco, Menlo, Consolas, Courier New, monospace; padding-top: 9.5px; padding-right: 9.5px; padding-bottom: 9.5px; padding-left: 9.5px; font-weight: 500; font-size: 14px; color: rgb(68, 68, 68); display: inline-block; margin-top: 0; margin-bottom: 0; margin-right: 10px; margin-left: 10px; line-height: 20px; white-space: pre !important; font-style: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px"><b><font color="rgb(94, 143, 96)">var</font></b> <font color="rgb(59, 59, 59)">f</font> <font color="black">=</font> <font color="rgb(59, 59, 59)">open</font><font color="black">(</font><font color="rgb(164, 37, 91)">&quot;numbers.txt&quot;</font><font color="black">)</font>
<b><font color="rgb(94, 143, 96)">defer</font></b><font color="black">:</font> <font color="rgb(59, 59, 59)">close</font><font color="black">(</font><font color="rgb(59, 59, 59)">f</font><font color="black">)</font>
<font color="rgb(59, 59, 59)">f</font><font color="black">.</font><font color="rgb(59, 59, 59)">write</font> <font color="rgb(164, 37, 91)">&quot;abc&quot;</font>
<font color="rgb(59, 59, 59)">f</font><font color="black">.</font><font color="rgb(59, 59, 59)">write</font> <font color="rgb(164, 37, 91)">&quot;def&quot;</font></pre>
    <p style="margin-top: 0px; margin-right: 0px; margin-bottom: 12px; margin-left: 0px; color: rgb(102, 102, 102); font-family: Helvetica Neue, HelveticaNeue, Raleway, Helvetica, Arial, sans-serif; font-size: 14px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      Is rewritten to:
    </p>
    <pre class="listing" style="font-family: Source Code Pro, Monaco, Menlo, Consolas, Courier New, monospace; padding-top: 9.5px; padding-right: 9.5px; padding-bottom: 9.5px; padding-left: 9.5px; font-weight: 500; font-size: 14px; color: rgb(68, 68, 68); display: inline-block; margin-top: 0; margin-bottom: 0; margin-right: 10px; margin-left: 10px; line-height: 20px; white-space: pre !important; font-style: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px"><b><font color="rgb(94, 143, 96)">var</font></b> <font color="rgb(59, 59, 59)">f</font> <font color="black">=</font> <font color="rgb(59, 59, 59)">open</font><font color="black">(</font><font color="rgb(164, 37, 91)">&quot;numbers.txt&quot;</font><font color="black">)</font>
<b><font color="rgb(94, 143, 96)">try</font></b><font color="black">:</font>
  <font color="rgb(59, 59, 59)">f</font><font color="black">.</font><font color="rgb(59, 59, 59)">write</font> <font color="rgb(164, 37, 91)">&quot;abc&quot;</font>
  <font color="rgb(59, 59, 59)">f</font><font color="black">.</font><font color="rgb(59, 59, 59)">write</font> <font color="rgb(164, 37, 91)">&quot;def&quot;</font>
<b><font color="rgb(94, 143, 96)">finally</font></b><font color="black">:</font>
  <font color="rgb(59, 59, 59)">close</font><font color="black">(</font><font color="rgb(59, 59, 59)">f</font><font color="black">)</font></pre>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1505380807529" ID="ID_938091725" MODIFIED="1505380827908" TEXT="iterator">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      proc len[T](it : (iterator : T)) : Natural =
    </p>
    <p>
      &#160;&#160;for i in it():
    </p>
    <p>
      &#160;&#160;&#160;&#160;result += 1
    </p>
    <p>
      
    </p>
    <p>
      proc filter[T](it: (iterator : T), f: proc(x: T): bool): (iterator: T) =
    </p>
    <p>
      &#160;&#160;return iterator(): T =
    </p>
    <p>
      &#160;&#160;&#160;&#160;while (let x = it(); not finished(it)):
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;if f(x):
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;yield x
    </p>
    <p>
      
    </p>
    <p>
      proc simpleSeqIterator[T](s :seq[T]) : (iterator : T) =
    </p>
    <p>
      &#160;&#160;iterator it: T {.closure.} =
    </p>
    <p>
      &#160;&#160;&#160;&#160;for x in s:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;yield x
    </p>
    <p>
      &#160;&#160;return it
    </p>
    <p>
      
    </p>
    <p>
      let a = toSeq(1 .. 99)
    </p>
    <p>
      echo len(a)
    </p>
    <p>
      echo len(simpleSeqIterator(a))
    </p>
    <p>
      echo len(filter(simpleSeqIterator(a), proc(x : int) : bool = true))
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1498685330892" ID="ID_1601158635" MODIFIED="1541374645665" POSITION="right" TEXT="links">
<node CREATED="1498685336844" ID="ID_1455139713" MODIFIED="1498685348315" TEXT="awesome_nim">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/VPashkov/awesome-nim
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504950526467" ID="ID_1997549462" LINK="https://play.nim-lang.org" MODIFIED="1504950558551" TEXT="nim_playground"/>
<node CREATED="1504951250684" ID="ID_1675030161" MODIFIED="1504951514485" TEXT="travis_ci testing">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://blaxpirit.com/blog/22/advanced-uses-of-travis-ci-with-nim.html
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504951312179" ID="ID_1342698535" LINK="http://howistart.org/posts/nim/1/#testing" MODIFIED="1504951338739" TEXT="howIstart_nim">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      http://howistart.org/posts/nim/1/#testing
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504951530552" ID="ID_588245548" LINK="http://goran.krampe.se/2014/10/15/bootstrapping-nim/" MODIFIED="1504951555400" TEXT="bootstrapping">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      http://goran.krampe.se/2014/10/15/bootstrapping-nim/
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504951836108" ID="ID_1939201369" MODIFIED="1504951849701" TEXT="nim_manual">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://nim-lang.org/docs/manual.html
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1498685418643" ID="ID_1915962292" MODIFIED="1570007559652" POSITION="left" TEXT="get_nim">
<node CREATED="1498685425994" ID="ID_1961720815" MODIFIED="1498685428885" TEXT="nimchoose"/>
<node CREATED="1498685429509" ID="ID_636604526" MODIFIED="1498685437906" TEXT="build devel_branch"/>
</node>
<node CREATED="1500410411233" ID="ID_1546010563" MODIFIED="1541374651219" POSITION="right" TEXT="debugging">
<node CREATED="1500410418857" ID="ID_1563881452" MODIFIED="1500410460100" TEXT="example">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://hookrace.net/blog/what-makes-nim-practical/#debugging-nim
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1500498560398" ID="ID_1267228081" MODIFIED="1500498577222" TEXT="put breakpoints on procs/funcs not lines"/>
<node CREATED="1500410464368" ID="ID_370067258" MODIFIED="1500410537297" TEXT="--debugger:native ">
<node CREATED="1500498555454" ID="ID_366566827" MODIFIED="1500498555454" TEXT=""/>
</node>
</node>
<node CREATED="1500410622190" ID="ID_631081150" MODIFIED="1504950806872" POSITION="left" TEXT="FFI">
<node CREATED="1500410629190" ID="ID_381325285" MODIFIED="1510343824875" TEXT="C">
<node CREATED="1504990195191" ID="ID_1949199169" MODIFIED="1504990237266" TEXT="include_example">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      taken from:https://forum.nim-lang.org/t/2638
    </p>
    <p>
      
    </p>
    <p>
      Alright, I got it to work. The trick was three things:
    </p>
    <p>
      Change the emit to this:
    </p>
    <p>
      # Required before including the stb_image.h header
    </p>
    <p>
      {.emit: &quot;&quot;&quot;
    </p>
    <p>
      #define STB_IMAGE_IMPLEMENTATION
    </p>
    <p>
      #include &quot;stb_image.h&quot;
    </p>
    <p>
      &quot;&quot;&quot;.}
    </p>
    <p>
      Remove the &quot;header,&quot; pragma and add a &quot;noDecl&quot; one:
    </p>
    <p>
      # Internal Function
    </p>
    <p>
      proc stbi_load(filename: cstring; x, y, comp: var cint; req_comp: cint): cstring
    </p>
    <p>
      &#160;&#160;{.importc: &quot;stbi_load&quot;, noDecl.}
    </p>
    <p>
      
    </p>
    <p>
      Tell the compiler where to look for stb_image.h. In my case that file was right alongside stb_image.nim, so for me it was:
    </p>
    <p>
      --cincludes:.
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505068819113" ID="ID_1809830060" LINK="http://goran.krampe.se/2014/10/16/nim-wrapping-c/" MODIFIED="1505068935972" TEXT="wrapping_article">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      http://goran.krampe.se/2014/10/16/nim-wrapping-c/
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1503849023910" ID="ID_1945980543" MODIFIED="1503849033110" TEXT="manual c-header import"/>
</node>
<node CREATED="1500410631690" ID="ID_53269761" MODIFIED="1510098859054" TEXT="Cpp">
<node CREATED="1500410640302" ID="ID_1185658174" MODIFIED="1570008613602" TEXT="template_cpp_defined">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre class="listing">template cppDefinedMacro(def, body: untyped) =
  {.emit: &quot;CPP_DEFINED_MACRO(&quot;, def, &quot;) {&quot;, body, &quot;}&quot;.}

cppDefinedMacro &quot;yay&quot;:
  cpp_defined_function(param1)
  other_cpp_defined_function(param2, param3)</pre>
  </body>
</html>
</richcontent>
</node>
<node CREATED="1504974460545" ID="ID_882678999" MODIFIED="1504981281844" TEXT="cpp exceptions">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      from issue: https://github.com/nim-lang/Nim/issues/3571
    </p>
    <p>
      
    </p>
    <p>
      type
    </p>
    <p>
      &#160;&#160;FfiException* = object of Exception
    </p>
    <p>
      &#160;&#160;FfiUnknownException* = object of FfiException
    </p>
    <p>
      
    </p>
    <p>
      template tryCpp*(code: stmt): stmt {.immediate.} =
    </p>
    <p>
      &#160;&#160;{.emit: &quot;try {&quot;.}
    </p>
    <p>
      &#160;&#160;code
    </p>
    <p>
      &#160;&#160;{.emit: &quot;} catch (std::exception&amp; e) {&quot;.}
    </p>
    <p>
      &#160;&#160;var msg{.importcpp: &quot;msg&quot;.}: cstring
    </p>
    <p>
      &#160;&#160;{.emit: &quot;const char *`msg` = e.what();&quot;.}
    </p>
    <p>
      &#160;&#160;proc ex1(msg: cstring) =
    </p>
    <p>
      &#160;&#160;&#160;&#160;raise newException(FfiException, $msg)
    </p>
    <p>
      &#160;&#160;ex1(msg)
    </p>
    <p>
      &#160;&#160;{.emit: &quot;} catch (...) {&quot;.}
    </p>
    <p>
      &#160;&#160;raise newException(FfiUnknownException, &quot;&lt;UNKNOWN EXCEPTION&gt;&quot;)
    </p>
    <p>
      &#160;&#160;{.emit: &quot;}&quot;.}
    </p>
    <p>
      
    </p>
    <p>
      template tryCppGlobal*(code: stmt): stmt {.immediate.} =
    </p>
    <p>
      &#160;&#160;proc dummy() =
    </p>
    <p>
      &#160;&#160;&#160;&#160;tryCpp code
    </p>
    <p>
      &#160;&#160;dummy()
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504981299806" ID="ID_799289707" MODIFIED="1504981309576" TEXT="cpp vtables">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/nim-lang/Nim/wiki/Playing-with-CPP--VTABLE-from-Nim
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505031146282" ID="ID_875533612" MODIFIED="1505031180525" TEXT="custom_allocator?">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://forum.nim-lang.org/t/703/11
    </p>
  </body>
</html></richcontent>
<node CREATED="1505031262631" ID="ID_582318597" MODIFIED="1505031285878" TEXT="macro_snippet">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      import macros
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      proc ctor_impl(allocator: NimNode, prc: NimNode): auto {.compiletime.} =
    </p>
    <p>
      &#160;&#160;&#160;&#160;if prc[3][1][1].kind != nnkVarTy:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;error(&quot;Constructor must have var non-ref type as first parameter&quot;)
    </p>
    <p>
      &#160;&#160;&#160;&#160;if prc[3][0].kind != nnkEmpty:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;error(&quot;Constructor must not have return type&quot;)
    </p>
    <p>
      &#160;&#160;&#160;&#160;if $prc[0] != &quot;init&quot;:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;error(&quot;Constructor name must be `init`&quot;)
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;var type_identifier = prc[3][1][1][0]
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;var ctor = quote do:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;proc init(_: typedesc[`type_identifier`]): `type_identifier` =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;init(result)
    </p>
    <p>
      &#160;&#160;&#160;&#160;ctor = ctor[0]
    </p>
    <p>
      &#160;&#160;&#160;&#160;ctor[2] = prc[2]
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;# Extend ctor with parameters of constructor
    </p>
    <p>
      &#160;&#160;&#160;&#160;for i in 2 ..&lt; prc[3].len:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;ctor[3].add(prc[3][i])
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;# Passes ctor params to main init proc
    </p>
    <p>
      &#160;&#160;&#160;&#160;ctor[6][0][1] = new_ident_node(&quot;result&quot;)&#160;&#160;&#160;&#160;# otherwise result is taken from macro context. weird!
    </p>
    <p>
      &#160;&#160;&#160;&#160;for i in 2 ..&lt; prc[3].len:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;ctor[6][0].add(prc[3][i][0])
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;var allc = quote do:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;proc new(_: typedesc[`type_identifier`]): ref `type_identifier` =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;`allocator`(result)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;init(result[])
    </p>
    <p>
      &#160;&#160;&#160;&#160;allc = allc[0]
    </p>
    <p>
      &#160;&#160;&#160;&#160;allc[2] = prc[2]
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;# Extend allc with parameters of constructor
    </p>
    <p>
      &#160;&#160;&#160;&#160;for i in 2 ..&lt; prc[3].len:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;allc[3].add(prc[3][i])
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;# Passes allc params to main init proc
    </p>
    <p>
      &#160;&#160;&#160;&#160;allc[6][0][1] = new_ident_node(&quot;result&quot;)&#160;&#160;&#160;&#160;# otherwise result is taken from macro context. weird!
    </p>
    <p>
      &#160;&#160;&#160;&#160;allc[6][1][1][0] = new_ident_node(&quot;result&quot;)
    </p>
    <p>
      &#160;&#160;&#160;&#160;for i in 2 ..&lt; prc[3].len:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;allc[6][1].add(prc[3][i][0])
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;result = new_stmt_list(prc, ctor, allc)
    </p>
    <p>
      
    </p>
    <p>
      macro ctor_alloc(allocator: typed{nkProcDef}, prc: typed{nkProcDef}): auto {.immediate.} = ctor_impl(allocator, prc)
    </p>
    <p>
      macro ctor(&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;prc: typed{nkProcDef}): auto {.immediate.} = ctor_impl(new_ident_node(&quot;new&quot;), prc)
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      when is_main_module:
    </p>
    <p>
      &#160;&#160;&#160;&#160;type
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Foo = object
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;a: int
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;Bar = object
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;a: int
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;# proc init(self: var Foo, n: int) =
    </p>
    <p>
      &#160;&#160;&#160;&#160;#&#160;&#160;&#160;&#160;&#160;self.a = n
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;# proc init(_: typedesc[Foo], n: int): Foo =
    </p>
    <p>
      &#160;&#160;&#160;&#160;#&#160;&#160;&#160;&#160;&#160;init(result, n)
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;# proc new(_: typedesc[Foo], n: int): ref Foo =
    </p>
    <p>
      &#160;&#160;&#160;&#160;#&#160;&#160;&#160;&#160;&#160;new(result)
    </p>
    <p>
      &#160;&#160;&#160;&#160;#&#160;&#160;&#160;&#160;&#160;init(result[], n)
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;proc custom_new(res: var ref Foo) =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;echo &quot;allocating with custom allocator&quot;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;new(res)
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;proc init(self: var Foo, n: int) {.ctor_alloc: custom_new.} =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;self.a = n
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;proc init(self: var Bar, n: int) {.ctor.} =
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;self.a = n
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;var f: Foo
    </p>
    <p>
      &#160;&#160;&#160;&#160;f.init(1)&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# works
    </p>
    <p>
      &#160;&#160;&#160;&#160;echo f.repr
    </p>
    <p>
      &#160;&#160;&#160;&#160;echo Foo.init(2).repr&#160;&#160;&#160;&#160;# works
    </p>
    <p>
      &#160;&#160;&#160;&#160;echo Foo.new(3).repr&#160;&#160;&#160;&#160;&#160;# works
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1505066053106" ID="ID_1932645997" LINK="https://forum.nim-lang.org/t/1272" MODIFIED="1505066101421" TEXT="bloom_filter_example">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://forum.nim-lang.org/t/1272
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505066196521" ID="ID_1185788978" LINK="https://github.com/onionhammer/clibpp" MODIFIED="1505066222956" TEXT="mock_macro">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/onionhammer/clibpp
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1505066046820" ID="ID_1108196630" MODIFIED="1505066046820" TEXT=""/>
<node CREATED="1504981289837" ID="ID_822485196" MODIFIED="1504981289837" TEXT=""/>
<node CREATED="1504981285750" ID="ID_64712440" MODIFIED="1504981285750" TEXT=""/>
<node CREATED="1500414857924" ID="ID_1246466158" MODIFIED="1500414860767" TEXT="general">
<node CREATED="1500414865452" ID="ID_1519488548" MODIFIED="1500414878412" TEXT="moduleInit">
<node CREATED="1500414879731" ID="ID_184523650" MODIFIED="1500414879731" TEXT="setupForeignThreadGc()">
<node CREATED="1500414887036" ID="ID_298912424" MODIFIED="1500414887036" TEXT=""/>
</node>
<node CREATED="1500414893188" ID="ID_232044190" MODIFIED="1500414897755" TEXT="NimMain()"/>
</node>
<node CREATED="1500415007635" ID="ID_320704266" MODIFIED="1500415017560" TEXT="exporting functions"/>
<node CREATED="1500415018080" ID="ID_1522832256" MODIFIED="1500415021670" TEXT="importing functions"/>
</node>
<node CREATED="1504950806873" ID="ID_125961176" MODIFIED="1504950809767" TEXT="c2nim">
<node CREATED="1504950814801" ID="ID_1543278532" MODIFIED="1504950817128" TEXT="mangle"/>
<node CREATED="1504973073088" ID="ID_1806170513" MODIFIED="1504973083368" TEXT="example cpp_wrapper">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/3dicc/Urhonimo
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1500413999837" ID="ID_1028228071" MODIFIED="1510171297988" POSITION="right" TEXT="compiler">
<node CREATED="1500414009527" ID="ID_9891417" MODIFIED="1504890953131" TEXT="vcc">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre class="listing">nim c -cc:vcc my.nim

#example compiler config nim.cfg</pre>
    <pre class="listing">  # Configuration for the MS Visual Studio C/C++ compiler:
  vcc.exe = &quot;cl.exe&quot;
  vcc.linkerexe = &quot;cl.exe&quot;
  
  # set the options for specific platforms:
  vcc.options.always = &quot;/nologo /EHsc&quot;
  vcc.options.linker = &quot;/nologo /Zi /F33554432&quot; # set the stack size to 32 MiB
  
  vcc.options.debug = &quot;/Zi /FS /Od /GZ /Ge&quot;
  vcc.options.speed = &quot;/O2&quot;
  vcc.options.size = &quot;/O1&quot;</pre>
  </body>
</html></richcontent>
</node>
<node CREATED="1500414031886" ID="ID_656780176" MODIFIED="1500414036985" TEXT="cross_compile">
<node CREATED="1500414039990" ID="ID_1558188470" MODIFIED="1500414043431" TEXT="arm"/>
<node CREATED="1500414043899" ID="ID_1263132647" MODIFIED="1500414045339" TEXT="avr"/>
</node>
<node CREATED="1500414163533" ID="ID_559244936" MODIFIED="1500414166968" TEXT="mingw">
<node CREATED="1500414170052" ID="ID_1394028895" MODIFIED="1500414538819" TEXT="distros">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://nuwen.net/mingw.htm
    </p>
    <p>
      http://www.msys2.org/
    </p>
    <p>
      http://www.equation.com/servlet/equation.cmd?fa=fortran
    </p>
    <p>
      http://tdm-gcc.tdragon.net/quirks
    </p>
    <p>
      
    </p>
    <p>
      official
    </p>
    <p>
      https://sourceforge.net/projects/mingw-w64/files/Toolchains%20targetting%20Win64/Personal%20Builds/mingw-builds/
    </p>
  </body>
</html></richcontent>
<node CREATED="1500414357426" ID="ID_1707162646" MODIFIED="1500414357426" TEXT=""/>
</node>
</node>
</node>
<node CREATED="1500414368481" ID="ID_1314219756" MODIFIED="1500414371047" POSITION="left" TEXT="env">
<node CREATED="1500414374362" ID="ID_536466024" MODIFIED="1500414418834" TEXT="windows">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      dont use msvcrt.dll https://blogs.msdn.microsoft.com/oldnewthing/20140411-00/?p=1273
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1500414914188" ID="ID_167996414" MODIFIED="1500414918874" POSITION="right" TEXT="linking">
<node CREATED="1500414922124" ID="ID_579163213" MODIFIED="1500414924536" TEXT="dynamic">
<node CREATED="1500414929547" ID="ID_1686052538" MODIFIED="1500414929547" TEXT=""/>
</node>
<node CREATED="1500414933612" ID="ID_916400668" MODIFIED="1500414935372" TEXT="static"/>
</node>
<node CREATED="1503194455891" ID="ID_186288158" MODIFIED="1503194459758" POSITION="left" TEXT="unrelated">
<node CREATED="1503194463003" ID="ID_898675816" MODIFIED="1503194524906" TEXT="SIMD">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre><code>type HeapObject = ref object
    field1: int
    field2: string</code></pre>
    <p>
      If you want it stack allocated
    </p>
    <pre><code>type StackObject = object
    field1: int
    field2: string</code></pre>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1503194801831" ID="ID_946619280" MODIFIED="1570007504960" POSITION="right" TEXT="libraries/wrapper">
<node CREATED="1503194809831" ID="ID_1096087500" MODIFIED="1503194840026" TEXT="enet">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre></pre>
    <p>
      https://github.com/fowlmouth/nimrod-enet
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1503194867271" ID="ID_317126728" MODIFIED="1503194883324" TEXT="libsodium"/>
<node CREATED="1503194954158" ID="ID_703598563" MODIFIED="1503194957459" TEXT="nimgame2"/>
<node CREATED="1503194958138" ID="ID_1172349363" MODIFIED="1503194959699" TEXT="sdl2"/>
<node CREATED="1505029739321" ID="ID_218595447" LINK="https://github.com/3dicc/Urhonimo" MODIFIED="1505029788932" TEXT="urdho3h_wrapper">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/3dicc/Urhonimo
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505029823946" ID="ID_686431472" LINK="https://github.com/pragmagic/nimue4" MODIFIED="1505029860336" TEXT="unreal_engine4">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/pragmagic/nimue4
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505031050466" ID="ID_1244235492" LINK="https://github.com/pragmagic/nimue4/wiki/Pragmas" MODIFIED="1505031144594" TEXT="nimUe4Wiki">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/pragmagic/nimue4/wiki/Pragmas
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1503763826845" ID="ID_84627590" MODIFIED="1503848950208" POSITION="left" TEXT="effect_system">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre class="listing">#compile with --taintMode:on
echo&#160;&quot;your name: &quot;
var name: TaintedString = stdin.readline
# it is safe here to output the name without any input validation, so
# we simply convert `name` to string to make the compiler happy:
echo &quot;hi, &quot;, name.string</pre>
  </body>
</html></richcontent>
<node CREATED="1503763844494" ID="ID_763426283" MODIFIED="1503763852172" TEXT="writeIOEffect"/>
<node CREATED="1503763852732" ID="ID_1012500234" MODIFIED="1503763858318" TEXT="timeEffect"/>
<node CREATED="1503763858798" ID="ID_658338135" MODIFIED="1503763864214" TEXT="nosideEffect"/>
<node CREATED="1503763881700" ID="ID_1825451904" MODIFIED="1503763886918" TEXT="execIOEffect"/>
<node CREATED="1503763909782" ID="ID_830205992" MODIFIED="1503763914406" TEXT="gcSafety"/>
</node>
<node CREATED="1503848918849" ID="ID_1505701371" MODIFIED="1503848923328" POSITION="right" TEXT="taint_mode"/>
<node CREATED="1504894277031" ID="ID_1154632436" MODIFIED="1570007600773" POSITION="right" TEXT="snippets">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      mainly from forum.nim-lang.org
    </p>
  </body>
</html></richcontent>
<node CREATED="1504894285798" ID="ID_1353729844" MODIFIED="1504894314632" TEXT="makefile_rule">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      # work only on *nix
    </p>
    <pre class="listing">import strutils, macros

proc makeObjFile*(cfile: string, flags: string = &quot;&quot;): string {.compiletime.} =
  if not cfile.endsWith(&quot;.c&quot;):
    error &quot;C file does not end in .c&quot;
  let objfile = cfile[0..^3] &amp; &quot;.o&quot;
  let test = &quot;test &quot; &amp; cfile &amp; &quot; -ot &quot; &amp; objfile
  let compile = &quot;gcc -c -O2 &quot; &amp; flags &amp; &quot; &quot; &amp; cfile
  let redir = &quot; &gt;/dev/null 2&gt;/dev/null&quot;
  let cmd = &quot;(&quot; &amp; test &amp; &quot; || &quot; &amp; compile &amp; redir &amp; &quot;); echo $?&quot;
  let output = staticExec(cmd).strip
  let success = output == &quot;0&quot;
  if not success:
    error &quot;Command failed: &quot; &amp; compile
  result = objfile

{.link: makeObjFile(&quot;resource.c&quot;,
          flags=&quot;`pkg-config --libs --cflags gtk+-3.0`&quot;).}</pre>
  </body>
</html></richcontent>
</node>
<node CREATED="1504895187982" ID="ID_337721213" MODIFIED="1504895275018" TEXT="f.rawProc">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      obtain the address of the procedure?
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504895314357" ID="ID_1787361612" MODIFIED="1504895392574" TEXT="getSizeOfStructure">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      # import low level RTTI mechanism:
    </p>
    <p>
      include &quot;system/hti.nim&quot;
    </p>
    <p>
      include &quot;system/inclrt.nim&quot;
    </p>
    <p>
      
    </p>
    <p>
      type
    </p>
    <p>
      &#160;&#160;Cell = object ## duplicated from system/cellsets
    </p>
    <p>
      &#160;&#160;&#160;&#160;refcount: int # the refcount and some flags
    </p>
    <p>
      &#160;&#160;&#160;&#160;typ: PNimType
    </p>
    <p>
      
    </p>
    <p>
      proc getRtti(env: pointer): PNimType =
    </p>
    <p>
      &#160;&#160;let header = cast[ptr Cell](cast[int](env) -% sizeof(Cell))
    </p>
    <p>
      &#160;&#160;header.typ
    </p>
    <p>
      
    </p>
    <p>
      proc getSize(env: pointer): int = getRtti(env).size
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504895559553" ID="ID_1070047361" MODIFIED="1504895569212" TEXT="plugin mechanism">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      *nim plugin mechanism
    </p>
    <p>
      # plugin.nim
    </p>
    <p>
      
    </p>
    <p>
      var data = 0
    </p>
    <p>
      
    </p>
    <p>
      {.push dynlib exportc.}
    </p>
    <p>
      
    </p>
    <p>
      proc setup*(num:int) =
    </p>
    <p>
      &#160;&#160;data = num
    </p>
    <p>
      &#160;&#160;echo &quot;Plugin Setup!&quot;
    </p>
    <p>
      
    </p>
    <p>
      proc getData*: int = data
    </p>
    <p>
      
    </p>
    <p>
      {.pop.}
    </p>
    <p>
      # app.nim
    </p>
    <p>
      
    </p>
    <p>
      import dynlib
    </p>
    <p>
      
    </p>
    <p>
      type
    </p>
    <p>
      &#160;&#160;SetupProc = proc(num:int) {.nimcall.}
    </p>
    <p>
      &#160;&#160;GetDataProc = proc(): int {.nimcall.}
    </p>
    <p>
      
    </p>
    <p>
      proc testPlugin(path:string) =
    </p>
    <p>
      &#160;&#160;let lib = loadLib(path)
    </p>
    <p>
      &#160;&#160;if lib != nil:
    </p>
    <p>
      &#160;&#160;&#160;&#160;let setupAddr = lib.symAddr(&quot;setup&quot;)
    </p>
    <p>
      &#160;&#160;&#160;&#160;let getDataAddr = lib.symAddr(&quot;getData&quot;)
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;if setupAddr != nil and getDataAddr != nil:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;let setup = cast[SetupProc](setupAddr)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;let getData = cast[GetDataProc](getDataAddr)
    </p>
    <p>
      &#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;setup(123)
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;echo &quot;Plugin Data: &quot;, getData()
    </p>
    <p>
      &#160;&#160;&#160;
    </p>
    <p>
      &#160;&#160;&#160;&#160;unloadLib(lib)
    </p>
    <p>
      
    </p>
    <p>
      testPlugin(&quot;./libplugin.so&quot;) # unix path
    </p>
    <p>
      Compile &amp; Run:
    </p>
    <p>
      $ nim c --app:lib plugin
    </p>
    <p>
      $ nim c -r app
    </p>
    <p>
      
    </p>
    <p>
      Plugin Setup!
    </p>
    <p>
      Plugin Data: 123
    </p>
    <p>
      NOTE: This section in the Nim User-Guide mentions the need to generate and link against nimrtl.dll..
    </p>
    <p>
      not sure if that's necessary for all Nim-created DLLs to work without GC/Memory bugs or something specific to
    </p>
    <p>
      &#160;using the Nim compiler itself as a DLL... (my example compiles and runs fine.. but that doesn't say much).
    </p>
    <p>
      &#160;Some clarity from someone more informed would be nice.
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504895687111" ID="ID_996665310" MODIFIED="1504895814680" TEXT="move_optimization">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      proc main =
    </p>
    <p>
      &#160;&#160;var a = &quot;foo&quot;
    </p>
    <p>
      &#160;&#160;shallow a
    </p>
    <p>
      &#160;&#160;var b = a # Look, ma, no copy!
    </p>
    <p>
      
    </p>
    <p>
      # from manual
    </p>
    <p>
      proc `[]=`*(t: var Table, key: string, val: string) =
    </p>
    <p>
      &#160;&#160;## puts a (key, value)-pair into `t`. The semantics of string require
    </p>
    <p>
      &#160;&#160;## a copy here:
    </p>
    <p>
      &#160;&#160;let idx = findInsertionPosition(key)
    </p>
    <p>
      &#160;&#160;t[idx].key = key
    </p>
    <p>
      &#160;&#160;t[idx].val = val
    </p>
    <p>
      
    </p>
    <p>
      proc `[]=`*(t: var Table, key: string{call}, val: string{call}) =
    </p>
    <p>
      &#160;&#160;## puts a (key, value)-pair into `t`. Optimized version that knows that
    </p>
    <p>
      &#160;&#160;## the strings are unique and thus don't need to be copied:
    </p>
    <p>
      &#160;&#160;let idx = findInsertionPosition(key)
    </p>
    <p>
      &#160;&#160;shallowCopy t[idx].key, key
    </p>
    <p>
      &#160;&#160;shallowCopy t[idx].val, val
    </p>
    <p>
      
    </p>
    <p>
      var t: Table
    </p>
    <p>
      # overloading resolution ensures that the optimized []= is called here:
    </p>
    <p>
      t[f()] = g()
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504896110475" ID="ID_267737450" MODIFIED="1504896203762" TEXT="object_variant_vs_static_cond_fields">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      type
    </p>
    <p>
      &#160;&#160;NodeKind = enum&#160;&#160;# the different node types
    </p>
    <p>
      &#160;&#160;&#160;&#160;nkInt,&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# a leaf with an integer value
    </p>
    <p>
      &#160;&#160;&#160;&#160;nkFloat&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;# a leaf with a float value
    </p>
    <p>
      &#160;
    </p>
    <p>
      &#160;
    </p>
    <p>
      &#160;&#160;# Version 1 with object variant
    </p>
    <p>
      &#160;&#160;Node = ref NodeObj
    </p>
    <p>
      &#160;&#160;NodeObj = object
    </p>
    <p>
      &#160;&#160;&#160;&#160;case kind: NodeKind&#160;&#160;# the ``kind`` field is the discriminator
    </p>
    <p>
      &#160;&#160;&#160;&#160;of nkInt: intVal: int
    </p>
    <p>
      &#160;&#160;&#160;&#160;of nkFloat: floatVal: float
    </p>
    <p>
      &#160;
    </p>
    <p>
      &#160;&#160;# Version 2 with conditional fields
    </p>
    <p>
      &#160;&#160;Node2[NK] = ref NodeObj2[NK]
    </p>
    <p>
      &#160;&#160;NodeObj2[NK: static[NodeKind]] = object
    </p>
    <p>
      &#160;&#160;&#160;&#160;when NK == nkInt:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;intVal: int
    </p>
    <p>
      &#160;&#160;&#160;&#160;elif NK == nkFloat:
    </p>
    <p>
      &#160;&#160;&#160;&#160;&#160;&#160;floatVal: float
    </p>
    <p>
      
    </p>
    <p>
      # Compiles fine
    </p>
    <p>
      let a = @[NodeObj(kind: nkInt), NodeObj(kind: nkFloat)]
    </p>
    <p>
      # Doesn't compile
    </p>
    <p>
      let b = @[NodeObj2[nkInt](), NodeObj2[nkFloat]()]
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1504950429205" ID="ID_1463084071" MODIFIED="1504950597348" TEXT="templates">
<node CREATED="1504950435677" ID="ID_1905937430" MODIFIED="1504950635890" TEXT="top_level_check(scope)">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      template isTopLevel: bool =
    </p>
    <p>
      &#160;&#160;template ret = return
    </p>
    <p>
      &#160;&#160;not compiles(ret())
    </p>
    <p>
      
    </p>
    <p>
      #####################################3
    </p>
    <pre class="listing">template testScope =
  template ret = return
  when compiles(ret()): echo &quot;Function&quot;
  else:                 echo &quot;Wild West&quot;

proc test = testScope()

test()
testScope()</pre>
  </body>
</html></richcontent>
</node>
<node CREATED="1504950599235" ID="ID_671992133" MODIFIED="1504950602548" TEXT="scope_check"/>
</node>
<node CREATED="1504988503008" ID="ID_1786054365" MODIFIED="1504988549228" TEXT="smart_pointers">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      taken from: https://forum.nim-lang.org/t/725
    </p>
    <p>
      
    </p>
    <p>
      smartptr_demo.nim
    </p>
    <p>
      type
    </p>
    <p>
      &#160;&#160;Root {.pure, inheritable.} = object
    </p>
    <p>
      &#160;&#160;SmartPtr[T]&#160;&#160;= object of Root
    </p>
    <p>
      &#160;&#160;&#160;&#160;pointer: ptr T
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;TBaseObject {.pure, inheritable.} = object
    </p>
    <p>
      &#160;&#160;BaseObject = ref SmartPtr[TBaseObject]
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;TWidget = object of TBaseObject
    </p>
    <p>
      &#160;&#160;Widget = ref SmartPtr[TWidget]
    </p>
    <p>
      
    </p>
    <p>
      proc finalizer[T](x: ref SmartPtr[T]) =
    </p>
    <p>
      &#160;&#160;echo &quot;finalizer called&quot;
    </p>
    <p>
      &#160;&#160;free(x.pointer)
    </p>
    <p>
      &#160;&#160;# or for example:
    </p>
    <p>
      &#160;&#160;# g_object_unref(x.pointer)
    </p>
    <p>
      
    </p>
    <p>
      
    </p>
    <p>
      converter wrap[T](pointer: ptr T): ref SmartPtr[T] =
    </p>
    <p>
      &#160;&#160;## Wraps a regular pointer from C land into a ref SmartPtr.
    </p>
    <p>
      &#160;&#160;## The smart pointer can be passed around and is refcounted/GC'd
    </p>
    <p>
      &#160;&#160;## by nim.&#160;&#160;When it gets collected, the finalizer is run
    </p>
    <p>
      &#160;&#160;## and the C pointer is freed.
    </p>
    <p>
      &#160;&#160;echo &quot;created smart pointer&quot;
    </p>
    <p>
      &#160;&#160;new(result, finalizer)
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;result.pointer = pointer
    </p>
    <p>
      &#160;&#160;# here you would increase the C ref count, for example:
    </p>
    <p>
      &#160;&#160;# result.pointer = g_object_ref(pointer)
    </p>
    <p>
      
    </p>
    <p>
      converter unwrap[T](s: ref SmartPtr[T]): ptr T =
    </p>
    <p>
      &#160;&#160;## Returns a regular pointer from a smart pointer (ref SmartPtr).
    </p>
    <p>
      &#160;&#160;## This converter allows you to use smart pointers where
    </p>
    <p>
      &#160;&#160;## a C API function takes a regular pointer.
    </p>
    <p>
      &#160;&#160;return s.pointer
    </p>
    <p>
      
    </p>
    <p>
      ## example C function returning a pointer (that has to be freed later)
    </p>
    <p>
      proc get_widget_pointer(): ptr TWidget =
    </p>
    <p>
      &#160;&#160;echo &quot;C function get_widget_pointer called&quot;
    </p>
    <p>
      &#160;&#160;cast[ptr TWidget](alloc(sizeof(TWidget)))
    </p>
    <p>
      
    </p>
    <p>
      ## thin wrapper around the C API so we get smart pointers when doing `let x = getWidget()`
    </p>
    <p>
      ## once we acquire a `ref SmartPtr`, the underlying pointer will be freed correctly.
    </p>
    <p>
      proc getWidget(): Widget = get_widget_pointer()
    </p>
    <p>
      
    </p>
    <p>
      ## example C function. Note we can pass smart pointers as well, so we don't have to wrap this.
    </p>
    <p>
      proc woof(w: ptr TWidget) =
    </p>
    <p>
      &#160;&#160;echo &quot;C function woof called&quot;
    </p>
    <p>
      
    </p>
    <p>
      ## example C function on a base class
    </p>
    <p>
      ## we can call this also with a `ptr TWidget`:
    </p>
    <p>
      ##&#160;&#160;&#160;&#160;&#160;let pw: ptr TWidget = unwrap(widget)
    </p>
    <p>
      ##&#160;&#160;&#160;&#160;&#160;pw.boing()
    </p>
    <p>
      ## but to make this work also on `Widget` (smart pointer around TWidget),
    </p>
    <p>
      ## we need a bit more work (see below)
    </p>
    <p>
      proc boing(w: ptr TBaseObject) =
    </p>
    <p>
      &#160;&#160;echo &quot;C function boing called&quot;
    </p>
    <p>
      
    </p>
    <p>
      template declareSubclass(S: typedesc[TBaseObject], T: typedesc[TBaseObject]) =
    </p>
    <p>
      &#160;&#160;#converter castup(s: S): T = s
    </p>
    <p>
      &#160;&#160;converter unwrap(s: ref SmartPtr[S]): ptr T =
    </p>
    <p>
      &#160;&#160;&#160;&#160;return s.pointer
    </p>
    <p>
      
    </p>
    <p>
      # allow implicit conversion of Derived -&gt; ptr TBase,
    </p>
    <p>
      # which is missing otherwise.&#160;&#160;This also works if there
    </p>
    <p>
      # are classes inbetween TDervied and TBase.&#160;&#160;Just declareSubclass
    </p>
    <p>
      # for all immediate relationships.
    </p>
    <p>
      declareSubclass(TWidget, TBaseObject)
    </p>
    <p>
      
    </p>
    <p>
      # this is an error and should fail (needs the struct types T... as params)
    </p>
    <p>
      #declareSubclass(Widget, BaseObject)
    </p>
    <p>
      
    </p>
    <p>
      proc main() =
    </p>
    <p>
      &#160;&#160;let widget = getWidget()
    </p>
    <p>
      &#160;&#160;widget.woof()
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;# can convert to a base class
    </p>
    <p>
      &#160;&#160;let base: BaseObject = widget&#160;&#160;# OK
    </p>
    <p>
      &#160;&#160;# but this should not compile:
    </p>
    <p>
      &#160;&#160;# let wid2: Widget = base
    </p>
    <p>
      &#160;&#160;# -&gt; &quot;Error: type mismatch: got (BaseObject) but expected 'Widget'&quot;
    </p>
    <p>
      
    </p>
    <p>
      &#160;&#160;# can also call a &quot;method&quot; of the base class on the subclass
    </p>
    <p>
      &#160;&#160;widget.boing()
    </p>
    <p>
      &#160;&#160;# but not vice versa:
    </p>
    <p>
      &#160;&#160;# base.woof()
    </p>
    <p>
      &#160;&#160;# -&gt; &quot;Error: type mismatch: got (BaseObject)
    </p>
    <p>
      &#160;&#160;#&#160;&#160;&#160;&#160;&#160;but expected one of:
    </p>
    <p>
      &#160;&#160;#&#160;&#160;&#160;&#160;&#160;smartptr_demo.woof(w: ptr TWidget)&quot;
    </p>
    <p>
      
    </p>
    <p>
      main()
    </p>
    <p>
      
    </p>
    <p>
      GC_fullcollect()
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505486722882" ID="ID_694182231" MODIFIED="1505495385629" TEXT="hook ctrl-c in console">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      import os
    </p>
    <p>
      
    </p>
    <p>
      proc handler() {.noconv.} =
    </p>
    <p>
      &#160;&#160;echo &quot;Program has run for &quot;, formatFloat(epochTime() - t, precision = 0), &quot; seconds.&quot;
    </p>
    <p>
      &#160;&#160;quit 0
    </p>
    <p>
      
    </p>
    <p>
      setControlCHook(handler)
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1510663888781" ID="ID_1489319227" MODIFIED="1510663917941" TEXT="hex_dump">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      import strutils
    </p>
    <p>
      
    </p>
    <p>
      proc hexDump*[T](v: T): string =
    </p>
    <p>
      &#160;&#160;var s: seq[uint8] = @[]
    </p>
    <p>
      &#160;&#160;s.setLen(v.sizeof)
    </p>
    <p>
      &#160;&#160;copymem(addr(s[0]), v.unsafeAddr, v.sizeof)
    </p>
    <p>
      &#160;&#160;result = &quot;&quot;
    </p>
    <p>
      &#160;&#160;for i in s: result.add(i.toHex)
    </p>
    <p>
      
    </p>
    <p>
      var
    </p>
    <p>
      &#160;&#160;i: int64 = 123
    </p>
    <p>
      &#160;&#160;ui: uint64 = 123
    </p>
    <p>
      &#160;&#160;f: float = 123.45
    </p>
    <p>
      &#160;&#160;s = @[1, 2, 3, 4]
    </p>
    <p>
      &#160;&#160;t: tuple[a: int, b: string] = (1, &quot;123&quot;)
    </p>
    <p>
      &#160;&#160;set: set[uint8] = {1'u8..3'u8, 5'u8..6'u8}
    </p>
    <p>
      &#160;&#160;a: array[5, uint8] = [1'u8, 2, 3, 4, 5]
    </p>
    <p>
      
    </p>
    <p>
      echo i.hexDump
    </p>
    <p>
      echo ui.hexDump
    </p>
    <p>
      echo f.hexDump
    </p>
    <p>
      echo s.hexDump
    </p>
    <p>
      echo t.hexDump
    </p>
    <p>
      echo set.hexDump
    </p>
    <p>
      echo a.hexDump
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1504973062496" ID="ID_433409960" MODIFIED="1504973066325" POSITION="left" TEXT="wrapper"/>
<node CREATED="1504990357396" ID="ID_889813190" MODIFIED="1505486713354" POSITION="right" TEXT="unrelated">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      C vs CPP
    </p>
    <p>
      
    </p>
    <p>
      http://www.mathematik.uni-ulm.de/numerik/cpp/ws16/doc/cpp-lecture/stack-tutorial/example01/index.html
    </p>
  </body>
</html></richcontent>
<node CREATED="1505041424312" ID="ID_618006014" MODIFIED="1505041435397" TEXT="lock_free_article">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      http://preshing.com/20120515/memory-reordering-caught-in-the-act/
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505042044587" ID="ID_1576915136" LINK="http://pandas.pydata.org/" MODIFIED="1505042070885" TEXT="phython_data_analysis_library">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      http://pandas.pydata.org/
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505042238684" ID="ID_739031643" LINK="https://github.com/blog/1381-a-whole-new-code-search" MODIFIED="1505042260453" TEXT="github_code_search">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/blog/1381-a-whole-new-code-search
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505046510305" ID="ID_228658372" MODIFIED="1505046518322" TEXT="C++ basics">
<node CREATED="1505046523696" ID="ID_1406182214" MODIFIED="1505046538331" TEXT="move constructor">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://akrzemi1.wordpress.com/2011/08/11/move-constructor/
    </p>
  </body>
</html></richcontent>
<node CREATED="1505046532257" ID="ID_687092761" LINK="https://akrzemi1.wordpress.com/2011/08/11/move-constructor/" MODIFIED="1505046532257" TEXT="https://akrzemi1.wordpress.com/2011/08/11/move-constructor/"/>
</node>
</node>
<node CREATED="1505066103121" ID="ID_1248247562" LINK="http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/" MODIFIED="1505066152572" TEXT="gcc_cross_compiler">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      http://preshing.com/20141119/how-to-build-a-gcc-cross-compiler/
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505569995374" ID="ID_444913905" MODIFIED="1505569998894" TEXT="ffmpeg"/>
</node>
<node CREATED="1505042234705" ID="ID_1109143621" MODIFIED="1505068436132" POSITION="right" TEXT="nim_wiki">
<node CREATED="1505068439722" ID="ID_971782142" LINK="https://github.com/nim-lang/Nim/wiki/Whitespace-FAQ" MODIFIED="1505068455761" TEXT="whitespace_faq">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://github.com/nim-lang/Nim/wiki/Whitespace-FAQ
    </p>
  </body>
</html></richcontent>
</node>
</node>
<node CREATED="1505378728681" ID="ID_1578845124" MODIFIED="1505378768409" POSITION="left" TEXT="embedded">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p style="color: rgb(29, 29, 29); margin-top: 5pt; margin-bottom: 5pt; margin-right: 0pt; margin-left: 0pt; font-family: Helvetica, Arial, sans-serif; font-size: 17.3333px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      compiles with: --gc:stack
    </p>
    <p style="color: rgb(29, 29, 29); margin-top: 5pt; margin-bottom: 5pt; margin-right: 0pt; margin-left: 0pt; font-family: Helvetica, Arial, sans-serif; font-size: 17.3333px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      
    </p>
    <p style="color: rgb(29, 29, 29); margin-top: 5pt; margin-bottom: 5pt; margin-right: 0pt; margin-left: 0pt; font-family: Helvetica, Arial, sans-serif; font-size: 17.3333px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      var rx: MemRegion
    </p>
    <p style="color: rgb(29, 29, 29); margin-top: 5pt; margin-bottom: 5pt; margin-right: 0pt; margin-left: 0pt; font-family: Helvetica, Arial, sans-serif; font-size: 17.3333px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      
    </p>
    <p style="color: rgb(29, 29, 29); margin-top: 5pt; margin-bottom: 5pt; margin-right: 0pt; margin-left: 0pt; font-family: Helvetica, Arial, sans-serif; font-size: 17.3333px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      withRegion rx:
    </p>
    <p style="color: rgb(29, 29, 29); margin-top: 5pt; margin-bottom: 5pt; margin-right: 0pt; margin-left: 0pt; font-family: Helvetica, Arial, sans-serif; font-size: 17.3333px; font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; white-space: normal; word-spacing: 0px">
      &#160;&#160;discard 0
    </p>
  </body>
</html></richcontent>
<node CREATED="1510346155598" ID="ID_865339303" MODIFIED="1510346159131" TEXT="AVR">
<node CREATED="1510346161758" ID="ID_514640793" MODIFIED="1510346210043" TEXT="compileoptions">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <pre style="font-family: SFMono-Regular, Consolas, Liberation Mono, Menlo, Courier, monospace; font-size: 11.9px; margin-top: 0px; margin-bottom: 16px; padding-top: 16px; padding-right: 16px; padding-bottom: 16px; padding-left: 16px; line-height: 1.45; background-color: rgb(246, 248, 250); color: rgb(36, 41, 46); font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px"><code style="font-family: SFMono-Regular, Consolas, Liberation Mono, Menlo, Courier, monospace; font-size: 11.9px; padding-top: 0px; padding-right: 0px; padding-bottom: 0px; padding-left: 0px; margin-top: 0px; margin-right: 0px; margin-bottom: 0px; margin-left: 0px; background-image: null; background-repeat: repeat; background-attachment: scroll; background-position: null; white-space: pre; border-top-style: none; border-top-width: 0px; border-right-style: none; border-right-width: 0px; border-bottom-style: none; border-bottom-width: 0px; border-left-style: none; border-left-width: 0px; display: inline; line-height: inherit"><font face="SFMono-Regular, Consolas, Liberation Mono, Menlo, Courier, monospace" size="11.9px">avr.standalone.gcc.path = &quot;/usr/bin&quot; 
avr.standalone.gcc.exe = &quot;avr-gcc&quot; 
avr.standalone.gcc.linkerexe = &quot;avr-gcc&quot; 
passC = &quot;-Os&quot; 
passC = &quot;-DF_CPU=16000000UL&quot; 
passC = &quot;-mmcu=atmega168p&quot; 
passL = &quot;-mmcu=atmega168p&quot; 
cpu = &quot;avr&quot; 
gc = &quot;stack&quot; 
define = &quot;release&quot; 
deadCodeElim = &quot;on&quot; 
stackTrace = &quot;off&quot; 
lineTrace = &quot;off&quot; 
os:standalone 
boundChecks:on </font></code></pre>
    <p>
      <font color="rgb(36, 41, 46)" face="SFMono-Regular, Consolas, Liberation Mono, Menlo, Courier, monospace" size="11.9px">define = &quot;StandaloneHeapSize=8191&quot;</font>
    </p>
    <pre style="font-family: SFMono-Regular, Consolas, Liberation Mono, Menlo, Courier, monospace; font-size: 11.9px; margin-top: 0px; margin-bottom: 16px; padding-top: 16px; padding-right: 16px; padding-bottom: 16px; padding-left: 16px; line-height: 1.45; background-color: rgb(246, 248, 250); color: rgb(36, 41, 46); font-style: normal; font-weight: normal; letter-spacing: normal; text-align: start; text-indent: 0px; text-transform: none; word-spacing: 0px">see https://github.com/nim-lang/Nim/issues/6132

</pre>
  </body>
</html></richcontent>
</node>
</node>
</node>
<node CREATED="1505548817460" ID="ID_1543424229" MODIFIED="1570007661747" POSITION="left" TEXT="GPU">
<node CREATED="1505548829697" ID="ID_980066389" MODIFIED="1505548832345" TEXT="CUDA">
<node CREATED="1505548835112" ID="ID_1512440974" MODIFIED="1505548882680" TEXT="cuda_square">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      forum.nim-lang.org
    </p>
    <p>
      
    </p>
    <p>
      template squareCuda(bpg, tpb: int, y: var GpuArray, x: GpuArray) =
    </p>
    <p>
      &#160;&#160;## Compute the square of x and store it in y
    </p>
    <p>
      &#160;&#160;## bpg: BlocksPerGrid
    </p>
    <p>
      &#160;&#160;## tpb: ThreadsPerBlock
    </p>
    <p>
      &#160;&#160;## Output square&lt;&lt;&lt;bpg, tpb&gt;&gt;&gt;(y,x)
    </p>
    <p>
      &#160;&#160;{.emit: [&quot;&quot;&quot;square&lt;&lt;&lt;&quot;&quot;&quot;,bpg.cint,&quot;&quot;&quot;,&quot;&quot;&quot;,tpb.cint,&quot;&quot;&quot;&gt;&gt;&gt;(&quot;&quot;&quot;,y.data[],&quot;&quot;&quot;,&quot;&quot;&quot;,x.data[],&quot;&quot;&quot;);&quot;&quot;&quot;].}
    </p>
  </body>
</html></richcontent>
</node>
<node CREATED="1505548936548" ID="ID_1364619577" MODIFIED="1505548943437" TEXT="call_cuda">
<richcontent TYPE="NOTE"><html>
  <head>
    
  </head>
  <body>
    <p>
      https://gist.github.com/mratsim/dfbd944f64181727a97dffb30b8cbd0a
    </p>
  </body>
</html></richcontent>
</node>
</node>
</node>
</node>
</map>

# Extract-Jenkins-Raw-Log

## So, how to extract plain text log from Jenkins raw log file?

Digging into Jenkins source code, it gives the answer

https://github.com/jenkinsci/jenkins/blob/master/core/src/main/java/hudson/console/ConsoleNote.java

```java
 * {@link ConsoleNote}s are serialized and gzip compressed into a byte sequence and then embedded into the
 * console output text file, with a bit of preamble/postamble to allow tools to ignore them. In this way
 * {@link ConsoleNote} always sticks to a particular point in the console output.
```

Look further, the `AMBER` strings are defined. https://en.wikipedia.org/wiki/ANSI_escape_code

```java
    public static final String PREAMBLE_STR = "\u001B[8mha:";
    public static final String POSTAMBLE_STR = "\u001B[0m";
```

## An example

I copied the first line of a test pipeline build log of my local installed Jenkins

> Started by user <ESC>[8mha:////4H+H6gi+RzqRXgbuxDkiDNvJYq3pMCu17+YXxGOB+mHbAAAAlx+LCAAAAAAAAP9b85aBtbiIQTGjNKU4P08vOT+vOD8nVc83PyU1x6OyILUoJzMv2y+/JJUBAhiZGBgqihhk0NSjKDWzXb3RdlLBUSYGJk8GtpzUvPSSDB8G5tKinBIGIZ+sxLJE/ZzEvHT94JKizLx0a6BxUmjGOUNodHsLgAzWEgZu/dLi1CL9xJTczDwAj6GcLcAAAAA=<ESC>[0madmin

The line can be split to following parts,

| Part | Value |
|---|---|
| {A string} | Started by user |
| {PREAMBLE_STR} | \u001B[8mha: |
| {BASE64_STR} | ////4H+H6gi+RzqRXgbuxDkiDNvJYq3pMCu17+YXxGOB+mHbAAAAlx+LCAAAAAAAAP9b85aBtbiIQTGjNKU4P08vOT+vOD8nVc83PyU1x6OyILUoJzMv2y+/JJUBAhiZGBgqihhk0NSjKDWzXb3RdlLBUSYGJk8GtpzUvPSSDB8G5tKinBIGIZ+sxLJE/ZzEvHT94JKizLx0a6BxUmjGOUNodHsLgAzWEgZu/dLi1CL9xJTczDwAj6GcLcAAAAA= |
| {POSTAMBLE_STR} | \u001B[0m |
| {A string} | admin |

 - Convert the `{BASE64_STR}` to bytes
 
 - trim the first `40` bytes (https://github.com/LarrysGIT/Extract-Jenkins-Raw-Log/issues/1)
 
 - out put to a `.gz` file, or stream whatever preferred. use `gzip` method to extract the file

The extracted file, `file` command tells me it's `Java serialization data, version 5`, surely you can see plain text from it.

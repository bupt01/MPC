; ModuleID = 'fd_32.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-f128:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%struct.__fsid_t = type { [2 x i32] }
%struct.__va_list_tag = type { i32, i32, i8*, i8* }
%struct.dirent = type { i64, i64, i16, i8, [256 x i8] }
%struct.stat = type { i64, i64, i64, i32, i32, i32, i32, i64, i64, i64, i64, %struct.timespec, %struct.timespec, %struct.timespec, [3 x i64] }
%struct.statfs = type { i64, i64, i64, i64, i64, i64, i64, %struct.__fsid_t, i64, i64, i64, [4 x i64] }
%struct.timespec = type { i64, i64 }

@__getdents = alias i64 (i32, %struct.dirent*, i64)* @getdents

define i32 @open(i8* %pathname, i32 %flags, ...) nounwind {
entry:
  %ap = alloca [1 x %struct.__va_list_tag], align 8
  call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !174), !dbg !247
  call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !175), !dbg !247
  call void @llvm.dbg.value(metadata !248, i64 0, metadata !176), !dbg !249
  %0 = and i32 %flags, 64, !dbg !250
  %1 = icmp eq i32 %0, 0, !dbg !250
  br i1 %1, label %bb8, label %bb, !dbg !250

bb:                                               ; preds = %entry
  call void @llvm.dbg.declare(metadata !{[1 x %struct.__va_list_tag]* %ap}, metadata !178), !dbg !251
  %ap12 = bitcast [1 x %struct.__va_list_tag]* %ap to i8*, !dbg !252
  call void @llvm.va_start(i8* %ap12), !dbg !252
  %2 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 0, !dbg !253
  %3 = load i32* %2, align 8, !dbg !253
  %4 = icmp ugt i32 %3, 47, !dbg !253
  br i1 %4, label %bb4, label %bb3, !dbg !253

bb3:                                              ; preds = %bb
  %5 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 3, !dbg !253
  %6 = load i8** %5, align 8, !dbg !253
  %tmp = zext i32 %3 to i64
  %7 = ptrtoint i8* %6 to i64, !dbg !253
  %8 = add i64 %7, %tmp, !dbg !253
  %9 = inttoptr i64 %8 to i8*, !dbg !253
  %10 = add i32 %3, 8, !dbg !253
  store i32 %10, i32* %2, align 8, !dbg !253
  br label %bb5, !dbg !253

bb4:                                              ; preds = %bb
  %11 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 2, !dbg !253
  %12 = load i8** %11, align 8, !dbg !253
  %13 = getelementptr inbounds i8* %12, i64 8, !dbg !253
  store i8* %13, i8** %11, align 8, !dbg !253
  br label %bb5, !dbg !253

bb5:                                              ; preds = %bb4, %bb3
  %addr.25.0 = phi i8* [ %12, %bb4 ], [ %9, %bb3 ]
  %14 = bitcast i8* %addr.25.0 to i32*, !dbg !253
  %15 = load i32* %14, align 4, !dbg !253
  call void @llvm.dbg.value(metadata !{i32 %15}, i64 0, metadata !176), !dbg !253
  call void @llvm.va_end(i8* %ap12), !dbg !254
  br label %bb8, !dbg !254

bb8:                                              ; preds = %entry, %bb5
  %mode.0 = phi i32 [ %15, %bb5 ], [ 0, %entry ]
  %16 = call i32 @__fd_open(i8* %pathname, i32 %flags, i32 %mode.0) nounwind, !dbg !255
  ret i32 %16, !dbg !255
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define weak i32 @open64(i8* %pathname, i32 %flags, ...) nounwind {
entry:
  %ap = alloca [1 x %struct.__va_list_tag], align 8
  call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !154), !dbg !256
  call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !155), !dbg !256
  call void @llvm.dbg.value(metadata !248, i64 0, metadata !156), !dbg !257
  %0 = and i32 %flags, 64, !dbg !258
  %1 = icmp eq i32 %0, 0, !dbg !258
  br i1 %1, label %bb8, label %bb, !dbg !258

bb:                                               ; preds = %entry
  call void @llvm.dbg.declare(metadata !{[1 x %struct.__va_list_tag]* %ap}, metadata !159), !dbg !259
  %ap12 = bitcast [1 x %struct.__va_list_tag]* %ap to i8*, !dbg !260
  call void @llvm.va_start(i8* %ap12), !dbg !260
  %2 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 0, !dbg !261
  %3 = load i32* %2, align 8, !dbg !261
  %4 = icmp ugt i32 %3, 47, !dbg !261
  br i1 %4, label %bb4, label %bb3, !dbg !261

bb3:                                              ; preds = %bb
  %5 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 3, !dbg !261
  %6 = load i8** %5, align 8, !dbg !261
  %tmp = zext i32 %3 to i64
  %7 = ptrtoint i8* %6 to i64, !dbg !261
  %8 = add i64 %7, %tmp, !dbg !261
  %9 = inttoptr i64 %8 to i8*, !dbg !261
  %10 = add i32 %3, 8, !dbg !261
  store i32 %10, i32* %2, align 8, !dbg !261
  br label %bb5, !dbg !261

bb4:                                              ; preds = %bb
  %11 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 2, !dbg !261
  %12 = load i8** %11, align 8, !dbg !261
  %13 = getelementptr inbounds i8* %12, i64 8, !dbg !261
  store i8* %13, i8** %11, align 8, !dbg !261
  br label %bb5, !dbg !261

bb5:                                              ; preds = %bb4, %bb3
  %addr.32.0 = phi i8* [ %12, %bb4 ], [ %9, %bb3 ]
  %14 = bitcast i8* %addr.32.0 to i32*, !dbg !261
  %15 = load i32* %14, align 4, !dbg !261
  call void @llvm.dbg.value(metadata !{i32 %15}, i64 0, metadata !156), !dbg !261
  call void @llvm.va_end(i8* %ap12), !dbg !262
  br label %bb8, !dbg !262

bb8:                                              ; preds = %entry, %bb5
  %mode.0 = phi i32 [ %15, %bb5 ], [ 0, %entry ]
  %16 = call i32 @__fd_open(i8* %pathname, i32 %flags, i32 %mode.0) nounwind, !dbg !263
  ret i32 %16, !dbg !263
}

declare void @llvm.va_start(i8*) nounwind

declare void @llvm.va_end(i8*) nounwind

declare i32 @__fd_open(i8*, i32, i32)

define i64 @getdents(i32 %fd, %struct.dirent* %dirp, i64 %nbytes) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !180), !dbg !264
  tail call void @llvm.dbg.value(metadata !{%struct.dirent* %dirp}, i64 0, metadata !181), !dbg !264
  tail call void @llvm.dbg.value(metadata !{i64 %nbytes}, i64 0, metadata !182), !dbg !264
  tail call void @llvm.dbg.value(metadata !{%struct.dirent* %dirp}, i64 0, metadata !183), !dbg !265
  %0 = trunc i64 %nbytes to i32, !dbg !266
  %1 = tail call i32 @__fd_getdents(i32 %fd, %struct.dirent* %dirp, i32 %0) nounwind, !dbg !266
  %2 = sext i32 %1 to i64, !dbg !266
  tail call void @llvm.dbg.value(metadata !{i64 %2}, i64 0, metadata !194), !dbg !266
  %3 = icmp sgt i32 %1, 0, !dbg !267
  br i1 %3, label %bb, label %bb3, !dbg !267

bb:                                               ; preds = %entry
  %4 = bitcast %struct.dirent* %dirp to i8*, !dbg !268
  %5 = getelementptr inbounds i8* %4, i64 %2, !dbg !268
  %6 = bitcast i8* %5 to %struct.dirent*, !dbg !268
  tail call void @llvm.dbg.value(metadata !{%struct.dirent* %6}, i64 0, metadata !195), !dbg !268
  %7 = icmp ugt %struct.dirent* %6, %dirp, !dbg !269
  br i1 %7, label %bb1, label %bb3, !dbg !269

bb1:                                              ; preds = %bb, %bb1
  %dp64.05 = phi %struct.dirent* [ %13, %bb1 ], [ %dirp, %bb ]
  %8 = getelementptr inbounds %struct.dirent* %dp64.05, i64 0, i32 2, !dbg !270
  %9 = bitcast %struct.dirent* %dp64.05 to i8*, !dbg !271
  %10 = load i16* %8, align 8, !dbg !271
  %11 = zext i16 %10 to i64, !dbg !271
  %12 = getelementptr inbounds i8* %9, i64 %11, !dbg !271
  %13 = bitcast i8* %12 to %struct.dirent*, !dbg !271
  %14 = icmp ult i8* %12, %5, !dbg !269
  br i1 %14, label %bb1, label %bb3, !dbg !269

bb3:                                              ; preds = %bb, %bb1, %entry
  ret i64 %2, !dbg !272
}

declare i32 @__fd_getdents(i32, %struct.dirent*, i32)

define i32 @statfs(i8* %path, %struct.statfs* %buf32) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !200), !dbg !273
  tail call void @llvm.dbg.value(metadata !{%struct.statfs* %buf32}, i64 0, metadata !201), !dbg !273
  %0 = tail call i32 @__fd_statfs(i8* %path, %struct.statfs* %buf32) nounwind, !dbg !274
  ret i32 %0, !dbg !274
}

declare i32 @__fd_statfs(i8*, %struct.statfs*)

define i32 @ftruncate(i32 %fd, i64 %length) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !202), !dbg !276
  tail call void @llvm.dbg.value(metadata !{i64 %length}, i64 0, metadata !203), !dbg !276
  %0 = tail call i32 @__fd_ftruncate(i32 %fd, i64 %length) nounwind, !dbg !277
  ret i32 %0, !dbg !277
}

declare i32 @__fd_ftruncate(i32, i64)

define i32 @fstat(i32 %fd, %struct.stat* nocapture %buf) nounwind {
entry:
  %tmp = alloca %struct.stat, align 8
  call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !204), !dbg !279
  call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !205), !dbg !279
  call void @llvm.dbg.declare(metadata !{%struct.stat* %tmp}, metadata !206), !dbg !280
  %0 = call i32 @__fd_fstat(i32 %fd, %struct.stat* %tmp) nounwind, !dbg !281
  call void @llvm.dbg.value(metadata !{i32 %0}, i64 0, metadata !208), !dbg !281
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %tmp}, i64 0, metadata !152), !dbg !282
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !153), !dbg !282
  %1 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 0, !dbg !284
  %2 = load i64* %1, align 8, !dbg !284
  %3 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 0, !dbg !284
  store i64 %2, i64* %3, align 8, !dbg !284
  %4 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 1, !dbg !286
  %5 = load i64* %4, align 8, !dbg !286
  %6 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 1, !dbg !286
  store i64 %5, i64* %6, align 8, !dbg !286
  %7 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 3, !dbg !287
  %8 = load i32* %7, align 8, !dbg !287
  %9 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 3, !dbg !287
  store i32 %8, i32* %9, align 8, !dbg !287
  %10 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 2, !dbg !288
  %11 = load i64* %10, align 8, !dbg !288
  %12 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 2, !dbg !288
  store i64 %11, i64* %12, align 8, !dbg !288
  %13 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 4, !dbg !289
  %14 = load i32* %13, align 4, !dbg !289
  %15 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 4, !dbg !289
  store i32 %14, i32* %15, align 4, !dbg !289
  %16 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 5, !dbg !290
  %17 = load i32* %16, align 8, !dbg !290
  %18 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 5, !dbg !290
  store i32 %17, i32* %18, align 8, !dbg !290
  %19 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 7, !dbg !291
  %20 = load i64* %19, align 8, !dbg !291
  %21 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 7, !dbg !291
  store i64 %20, i64* %21, align 8, !dbg !291
  %22 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 8, !dbg !292
  %23 = load i64* %22, align 8, !dbg !292
  %24 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 8, !dbg !292
  store i64 %23, i64* %24, align 8, !dbg !292
  %25 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 0, !dbg !293
  %26 = load i64* %25, align 8, !dbg !293
  %27 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 0, !dbg !293
  store i64 %26, i64* %27, align 8, !dbg !293
  %28 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 0, !dbg !294
  %29 = load i64* %28, align 8, !dbg !294
  %30 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 0, !dbg !294
  store i64 %29, i64* %30, align 8, !dbg !294
  %31 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 0, !dbg !295
  %32 = load i64* %31, align 8, !dbg !295
  %33 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 0, !dbg !295
  store i64 %32, i64* %33, align 8, !dbg !295
  %34 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 9, !dbg !296
  %35 = load i64* %34, align 8, !dbg !296
  %36 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 9, !dbg !296
  store i64 %35, i64* %36, align 8, !dbg !296
  %37 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 10, !dbg !297
  %38 = load i64* %37, align 8, !dbg !297
  %39 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 10, !dbg !297
  store i64 %38, i64* %39, align 8, !dbg !297
  %40 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 1, !dbg !298
  %41 = load i64* %40, align 8, !dbg !298
  %42 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 1, !dbg !298
  store i64 %41, i64* %42, align 8, !dbg !298
  %43 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 1, !dbg !299
  %44 = load i64* %43, align 8, !dbg !299
  %45 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 1, !dbg !299
  store i64 %44, i64* %45, align 8, !dbg !299
  %46 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 1, !dbg !300
  %47 = load i64* %46, align 8, !dbg !300
  %48 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 1, !dbg !300
  store i64 %47, i64* %48, align 8, !dbg !300
  ret i32 %0, !dbg !301
}

declare i32 @__fd_fstat(i32, %struct.stat*)

define i32 @__fxstat(i32 %vers, i32 %fd, %struct.stat* nocapture %buf) nounwind {
entry:
  %tmp = alloca %struct.stat, align 8
  call void @llvm.dbg.value(metadata !{i32 %vers}, i64 0, metadata !209), !dbg !302
  call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !210), !dbg !302
  call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !211), !dbg !302
  call void @llvm.dbg.declare(metadata !{%struct.stat* %tmp}, metadata !212), !dbg !303
  %0 = call i32 @__fd_fstat(i32 %fd, %struct.stat* %tmp) nounwind, !dbg !304
  call void @llvm.dbg.value(metadata !{i32 %0}, i64 0, metadata !214), !dbg !304
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %tmp}, i64 0, metadata !152), !dbg !305
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !153), !dbg !305
  %1 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 0, !dbg !307
  %2 = load i64* %1, align 8, !dbg !307
  %3 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 0, !dbg !307
  store i64 %2, i64* %3, align 8, !dbg !307
  %4 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 1, !dbg !308
  %5 = load i64* %4, align 8, !dbg !308
  %6 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 1, !dbg !308
  store i64 %5, i64* %6, align 8, !dbg !308
  %7 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 3, !dbg !309
  %8 = load i32* %7, align 8, !dbg !309
  %9 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 3, !dbg !309
  store i32 %8, i32* %9, align 8, !dbg !309
  %10 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 2, !dbg !310
  %11 = load i64* %10, align 8, !dbg !310
  %12 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 2, !dbg !310
  store i64 %11, i64* %12, align 8, !dbg !310
  %13 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 4, !dbg !311
  %14 = load i32* %13, align 4, !dbg !311
  %15 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 4, !dbg !311
  store i32 %14, i32* %15, align 4, !dbg !311
  %16 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 5, !dbg !312
  %17 = load i32* %16, align 8, !dbg !312
  %18 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 5, !dbg !312
  store i32 %17, i32* %18, align 8, !dbg !312
  %19 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 7, !dbg !313
  %20 = load i64* %19, align 8, !dbg !313
  %21 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 7, !dbg !313
  store i64 %20, i64* %21, align 8, !dbg !313
  %22 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 8, !dbg !314
  %23 = load i64* %22, align 8, !dbg !314
  %24 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 8, !dbg !314
  store i64 %23, i64* %24, align 8, !dbg !314
  %25 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 0, !dbg !315
  %26 = load i64* %25, align 8, !dbg !315
  %27 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 0, !dbg !315
  store i64 %26, i64* %27, align 8, !dbg !315
  %28 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 0, !dbg !316
  %29 = load i64* %28, align 8, !dbg !316
  %30 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 0, !dbg !316
  store i64 %29, i64* %30, align 8, !dbg !316
  %31 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 0, !dbg !317
  %32 = load i64* %31, align 8, !dbg !317
  %33 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 0, !dbg !317
  store i64 %32, i64* %33, align 8, !dbg !317
  %34 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 9, !dbg !318
  %35 = load i64* %34, align 8, !dbg !318
  %36 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 9, !dbg !318
  store i64 %35, i64* %36, align 8, !dbg !318
  %37 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 10, !dbg !319
  %38 = load i64* %37, align 8, !dbg !319
  %39 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 10, !dbg !319
  store i64 %38, i64* %39, align 8, !dbg !319
  %40 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 1, !dbg !320
  %41 = load i64* %40, align 8, !dbg !320
  %42 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 1, !dbg !320
  store i64 %41, i64* %42, align 8, !dbg !320
  %43 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 1, !dbg !321
  %44 = load i64* %43, align 8, !dbg !321
  %45 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 1, !dbg !321
  store i64 %44, i64* %45, align 8, !dbg !321
  %46 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 1, !dbg !322
  %47 = load i64* %46, align 8, !dbg !322
  %48 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 1, !dbg !322
  store i64 %47, i64* %48, align 8, !dbg !322
  ret i32 %0, !dbg !323
}

define i32 @lstat(i8* %path, %struct.stat* nocapture %buf) nounwind {
entry:
  %tmp = alloca %struct.stat, align 8
  call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !215), !dbg !324
  call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !216), !dbg !324
  call void @llvm.dbg.declare(metadata !{%struct.stat* %tmp}, metadata !217), !dbg !325
  %0 = call i32 @__fd_lstat(i8* %path, %struct.stat* %tmp) nounwind, !dbg !326
  call void @llvm.dbg.value(metadata !{i32 %0}, i64 0, metadata !219), !dbg !326
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %tmp}, i64 0, metadata !152), !dbg !327
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !153), !dbg !327
  %1 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 0, !dbg !329
  %2 = load i64* %1, align 8, !dbg !329
  %3 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 0, !dbg !329
  store i64 %2, i64* %3, align 8, !dbg !329
  %4 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 1, !dbg !330
  %5 = load i64* %4, align 8, !dbg !330
  %6 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 1, !dbg !330
  store i64 %5, i64* %6, align 8, !dbg !330
  %7 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 3, !dbg !331
  %8 = load i32* %7, align 8, !dbg !331
  %9 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 3, !dbg !331
  store i32 %8, i32* %9, align 8, !dbg !331
  %10 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 2, !dbg !332
  %11 = load i64* %10, align 8, !dbg !332
  %12 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 2, !dbg !332
  store i64 %11, i64* %12, align 8, !dbg !332
  %13 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 4, !dbg !333
  %14 = load i32* %13, align 4, !dbg !333
  %15 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 4, !dbg !333
  store i32 %14, i32* %15, align 4, !dbg !333
  %16 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 5, !dbg !334
  %17 = load i32* %16, align 8, !dbg !334
  %18 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 5, !dbg !334
  store i32 %17, i32* %18, align 8, !dbg !334
  %19 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 7, !dbg !335
  %20 = load i64* %19, align 8, !dbg !335
  %21 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 7, !dbg !335
  store i64 %20, i64* %21, align 8, !dbg !335
  %22 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 8, !dbg !336
  %23 = load i64* %22, align 8, !dbg !336
  %24 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 8, !dbg !336
  store i64 %23, i64* %24, align 8, !dbg !336
  %25 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 0, !dbg !337
  %26 = load i64* %25, align 8, !dbg !337
  %27 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 0, !dbg !337
  store i64 %26, i64* %27, align 8, !dbg !337
  %28 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 0, !dbg !338
  %29 = load i64* %28, align 8, !dbg !338
  %30 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 0, !dbg !338
  store i64 %29, i64* %30, align 8, !dbg !338
  %31 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 0, !dbg !339
  %32 = load i64* %31, align 8, !dbg !339
  %33 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 0, !dbg !339
  store i64 %32, i64* %33, align 8, !dbg !339
  %34 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 9, !dbg !340
  %35 = load i64* %34, align 8, !dbg !340
  %36 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 9, !dbg !340
  store i64 %35, i64* %36, align 8, !dbg !340
  %37 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 10, !dbg !341
  %38 = load i64* %37, align 8, !dbg !341
  %39 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 10, !dbg !341
  store i64 %38, i64* %39, align 8, !dbg !341
  %40 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 1, !dbg !342
  %41 = load i64* %40, align 8, !dbg !342
  %42 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 1, !dbg !342
  store i64 %41, i64* %42, align 8, !dbg !342
  %43 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 1, !dbg !343
  %44 = load i64* %43, align 8, !dbg !343
  %45 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 1, !dbg !343
  store i64 %44, i64* %45, align 8, !dbg !343
  %46 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 1, !dbg !344
  %47 = load i64* %46, align 8, !dbg !344
  %48 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 1, !dbg !344
  store i64 %47, i64* %48, align 8, !dbg !344
  ret i32 %0, !dbg !345
}

declare i32 @__fd_lstat(i8*, %struct.stat*)

define i32 @__lxstat(i32 %vers, i8* %path, %struct.stat* nocapture %buf) nounwind {
entry:
  %tmp = alloca %struct.stat, align 8
  call void @llvm.dbg.value(metadata !{i32 %vers}, i64 0, metadata !220), !dbg !346
  call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !221), !dbg !346
  call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !222), !dbg !346
  call void @llvm.dbg.declare(metadata !{%struct.stat* %tmp}, metadata !223), !dbg !347
  %0 = call i32 @__fd_lstat(i8* %path, %struct.stat* %tmp) nounwind, !dbg !348
  call void @llvm.dbg.value(metadata !{i32 %0}, i64 0, metadata !225), !dbg !348
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %tmp}, i64 0, metadata !152), !dbg !349
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !153), !dbg !349
  %1 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 0, !dbg !351
  %2 = load i64* %1, align 8, !dbg !351
  %3 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 0, !dbg !351
  store i64 %2, i64* %3, align 8, !dbg !351
  %4 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 1, !dbg !352
  %5 = load i64* %4, align 8, !dbg !352
  %6 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 1, !dbg !352
  store i64 %5, i64* %6, align 8, !dbg !352
  %7 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 3, !dbg !353
  %8 = load i32* %7, align 8, !dbg !353
  %9 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 3, !dbg !353
  store i32 %8, i32* %9, align 8, !dbg !353
  %10 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 2, !dbg !354
  %11 = load i64* %10, align 8, !dbg !354
  %12 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 2, !dbg !354
  store i64 %11, i64* %12, align 8, !dbg !354
  %13 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 4, !dbg !355
  %14 = load i32* %13, align 4, !dbg !355
  %15 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 4, !dbg !355
  store i32 %14, i32* %15, align 4, !dbg !355
  %16 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 5, !dbg !356
  %17 = load i32* %16, align 8, !dbg !356
  %18 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 5, !dbg !356
  store i32 %17, i32* %18, align 8, !dbg !356
  %19 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 7, !dbg !357
  %20 = load i64* %19, align 8, !dbg !357
  %21 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 7, !dbg !357
  store i64 %20, i64* %21, align 8, !dbg !357
  %22 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 8, !dbg !358
  %23 = load i64* %22, align 8, !dbg !358
  %24 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 8, !dbg !358
  store i64 %23, i64* %24, align 8, !dbg !358
  %25 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 0, !dbg !359
  %26 = load i64* %25, align 8, !dbg !359
  %27 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 0, !dbg !359
  store i64 %26, i64* %27, align 8, !dbg !359
  %28 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 0, !dbg !360
  %29 = load i64* %28, align 8, !dbg !360
  %30 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 0, !dbg !360
  store i64 %29, i64* %30, align 8, !dbg !360
  %31 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 0, !dbg !361
  %32 = load i64* %31, align 8, !dbg !361
  %33 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 0, !dbg !361
  store i64 %32, i64* %33, align 8, !dbg !361
  %34 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 9, !dbg !362
  %35 = load i64* %34, align 8, !dbg !362
  %36 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 9, !dbg !362
  store i64 %35, i64* %36, align 8, !dbg !362
  %37 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 10, !dbg !363
  %38 = load i64* %37, align 8, !dbg !363
  %39 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 10, !dbg !363
  store i64 %38, i64* %39, align 8, !dbg !363
  %40 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 1, !dbg !364
  %41 = load i64* %40, align 8, !dbg !364
  %42 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 1, !dbg !364
  store i64 %41, i64* %42, align 8, !dbg !364
  %43 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 1, !dbg !365
  %44 = load i64* %43, align 8, !dbg !365
  %45 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 1, !dbg !365
  store i64 %44, i64* %45, align 8, !dbg !365
  %46 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 1, !dbg !366
  %47 = load i64* %46, align 8, !dbg !366
  %48 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 1, !dbg !366
  store i64 %47, i64* %48, align 8, !dbg !366
  ret i32 %0, !dbg !367
}

define i32 @stat(i8* %path, %struct.stat* nocapture %buf) nounwind {
entry:
  %tmp = alloca %struct.stat, align 8
  call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !226), !dbg !368
  call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !227), !dbg !368
  call void @llvm.dbg.declare(metadata !{%struct.stat* %tmp}, metadata !228), !dbg !369
  %0 = call i32 @__fd_stat(i8* %path, %struct.stat* %tmp) nounwind, !dbg !370
  call void @llvm.dbg.value(metadata !{i32 %0}, i64 0, metadata !230), !dbg !370
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %tmp}, i64 0, metadata !152), !dbg !371
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !153), !dbg !371
  %1 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 0, !dbg !373
  %2 = load i64* %1, align 8, !dbg !373
  %3 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 0, !dbg !373
  store i64 %2, i64* %3, align 8, !dbg !373
  %4 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 1, !dbg !374
  %5 = load i64* %4, align 8, !dbg !374
  %6 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 1, !dbg !374
  store i64 %5, i64* %6, align 8, !dbg !374
  %7 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 3, !dbg !375
  %8 = load i32* %7, align 8, !dbg !375
  %9 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 3, !dbg !375
  store i32 %8, i32* %9, align 8, !dbg !375
  %10 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 2, !dbg !376
  %11 = load i64* %10, align 8, !dbg !376
  %12 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 2, !dbg !376
  store i64 %11, i64* %12, align 8, !dbg !376
  %13 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 4, !dbg !377
  %14 = load i32* %13, align 4, !dbg !377
  %15 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 4, !dbg !377
  store i32 %14, i32* %15, align 4, !dbg !377
  %16 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 5, !dbg !378
  %17 = load i32* %16, align 8, !dbg !378
  %18 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 5, !dbg !378
  store i32 %17, i32* %18, align 8, !dbg !378
  %19 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 7, !dbg !379
  %20 = load i64* %19, align 8, !dbg !379
  %21 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 7, !dbg !379
  store i64 %20, i64* %21, align 8, !dbg !379
  %22 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 8, !dbg !380
  %23 = load i64* %22, align 8, !dbg !380
  %24 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 8, !dbg !380
  store i64 %23, i64* %24, align 8, !dbg !380
  %25 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 0, !dbg !381
  %26 = load i64* %25, align 8, !dbg !381
  %27 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 0, !dbg !381
  store i64 %26, i64* %27, align 8, !dbg !381
  %28 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 0, !dbg !382
  %29 = load i64* %28, align 8, !dbg !382
  %30 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 0, !dbg !382
  store i64 %29, i64* %30, align 8, !dbg !382
  %31 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 0, !dbg !383
  %32 = load i64* %31, align 8, !dbg !383
  %33 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 0, !dbg !383
  store i64 %32, i64* %33, align 8, !dbg !383
  %34 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 9, !dbg !384
  %35 = load i64* %34, align 8, !dbg !384
  %36 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 9, !dbg !384
  store i64 %35, i64* %36, align 8, !dbg !384
  %37 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 10, !dbg !385
  %38 = load i64* %37, align 8, !dbg !385
  %39 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 10, !dbg !385
  store i64 %38, i64* %39, align 8, !dbg !385
  %40 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 1, !dbg !386
  %41 = load i64* %40, align 8, !dbg !386
  %42 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 1, !dbg !386
  store i64 %41, i64* %42, align 8, !dbg !386
  %43 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 1, !dbg !387
  %44 = load i64* %43, align 8, !dbg !387
  %45 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 1, !dbg !387
  store i64 %44, i64* %45, align 8, !dbg !387
  %46 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 1, !dbg !388
  %47 = load i64* %46, align 8, !dbg !388
  %48 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 1, !dbg !388
  store i64 %47, i64* %48, align 8, !dbg !388
  ret i32 %0, !dbg !389
}

declare i32 @__fd_stat(i8*, %struct.stat*)

define i32 @__xstat(i32 %vers, i8* %path, %struct.stat* nocapture %buf) nounwind {
entry:
  %tmp = alloca %struct.stat, align 8
  call void @llvm.dbg.value(metadata !{i32 %vers}, i64 0, metadata !231), !dbg !390
  call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !232), !dbg !390
  call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !233), !dbg !390
  call void @llvm.dbg.declare(metadata !{%struct.stat* %tmp}, metadata !234), !dbg !391
  %0 = call i32 @__fd_stat(i8* %path, %struct.stat* %tmp) nounwind, !dbg !392
  call void @llvm.dbg.value(metadata !{i32 %0}, i64 0, metadata !236), !dbg !392
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %tmp}, i64 0, metadata !152), !dbg !393
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !153), !dbg !393
  %1 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 0, !dbg !395
  %2 = load i64* %1, align 8, !dbg !395
  %3 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 0, !dbg !395
  store i64 %2, i64* %3, align 8, !dbg !395
  %4 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 1, !dbg !396
  %5 = load i64* %4, align 8, !dbg !396
  %6 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 1, !dbg !396
  store i64 %5, i64* %6, align 8, !dbg !396
  %7 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 3, !dbg !397
  %8 = load i32* %7, align 8, !dbg !397
  %9 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 3, !dbg !397
  store i32 %8, i32* %9, align 8, !dbg !397
  %10 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 2, !dbg !398
  %11 = load i64* %10, align 8, !dbg !398
  %12 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 2, !dbg !398
  store i64 %11, i64* %12, align 8, !dbg !398
  %13 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 4, !dbg !399
  %14 = load i32* %13, align 4, !dbg !399
  %15 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 4, !dbg !399
  store i32 %14, i32* %15, align 4, !dbg !399
  %16 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 5, !dbg !400
  %17 = load i32* %16, align 8, !dbg !400
  %18 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 5, !dbg !400
  store i32 %17, i32* %18, align 8, !dbg !400
  %19 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 7, !dbg !401
  %20 = load i64* %19, align 8, !dbg !401
  %21 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 7, !dbg !401
  store i64 %20, i64* %21, align 8, !dbg !401
  %22 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 8, !dbg !402
  %23 = load i64* %22, align 8, !dbg !402
  %24 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 8, !dbg !402
  store i64 %23, i64* %24, align 8, !dbg !402
  %25 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 0, !dbg !403
  %26 = load i64* %25, align 8, !dbg !403
  %27 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 0, !dbg !403
  store i64 %26, i64* %27, align 8, !dbg !403
  %28 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 0, !dbg !404
  %29 = load i64* %28, align 8, !dbg !404
  %30 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 0, !dbg !404
  store i64 %29, i64* %30, align 8, !dbg !404
  %31 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 0, !dbg !405
  %32 = load i64* %31, align 8, !dbg !405
  %33 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 0, !dbg !405
  store i64 %32, i64* %33, align 8, !dbg !405
  %34 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 9, !dbg !406
  %35 = load i64* %34, align 8, !dbg !406
  %36 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 9, !dbg !406
  store i64 %35, i64* %36, align 8, !dbg !406
  %37 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 10, !dbg !407
  %38 = load i64* %37, align 8, !dbg !407
  %39 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 10, !dbg !407
  store i64 %38, i64* %39, align 8, !dbg !407
  %40 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 11, i32 1, !dbg !408
  %41 = load i64* %40, align 8, !dbg !408
  %42 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 11, i32 1, !dbg !408
  store i64 %41, i64* %42, align 8, !dbg !408
  %43 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 12, i32 1, !dbg !409
  %44 = load i64* %43, align 8, !dbg !409
  %45 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 12, i32 1, !dbg !409
  store i64 %44, i64* %45, align 8, !dbg !409
  %46 = getelementptr inbounds %struct.stat* %tmp, i64 0, i32 13, i32 1, !dbg !410
  %47 = load i64* %46, align 8, !dbg !410
  %48 = getelementptr inbounds %struct.stat* %buf, i64 0, i32 13, i32 1, !dbg !410
  store i64 %47, i64* %48, align 8, !dbg !410
  ret i32 %0, !dbg !411
}

define i64 @lseek(i32 %fd, i64 %off, i32 %whence) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !237), !dbg !412
  tail call void @llvm.dbg.value(metadata !{i64 %off}, i64 0, metadata !238), !dbg !412
  tail call void @llvm.dbg.value(metadata !{i32 %whence}, i64 0, metadata !239), !dbg !412
  %0 = tail call i64 @__fd_lseek(i32 %fd, i64 %off, i32 %whence) nounwind, !dbg !413
  ret i64 %0, !dbg !413
}

declare i64 @__fd_lseek(i32, i64, i32)

define i32 @openat(i32 %fd, i8* %pathname, i32 %flags, ...) nounwind {
entry:
  %ap = alloca [1 x %struct.__va_list_tag], align 8
  call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !240), !dbg !415
  call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !241), !dbg !415
  call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !242), !dbg !415
  call void @llvm.dbg.value(metadata !248, i64 0, metadata !243), !dbg !416
  %0 = and i32 %flags, 64, !dbg !417
  %1 = icmp eq i32 %0, 0, !dbg !417
  br i1 %1, label %bb8, label %bb, !dbg !417

bb:                                               ; preds = %entry
  call void @llvm.dbg.declare(metadata !{[1 x %struct.__va_list_tag]* %ap}, metadata !245), !dbg !418
  %ap12 = bitcast [1 x %struct.__va_list_tag]* %ap to i8*, !dbg !419
  call void @llvm.va_start(i8* %ap12), !dbg !419
  %2 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 0, !dbg !420
  %3 = load i32* %2, align 8, !dbg !420
  %4 = icmp ugt i32 %3, 47, !dbg !420
  br i1 %4, label %bb4, label %bb3, !dbg !420

bb3:                                              ; preds = %bb
  %5 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 3, !dbg !420
  %6 = load i8** %5, align 8, !dbg !420
  %tmp = zext i32 %3 to i64
  %7 = ptrtoint i8* %6 to i64, !dbg !420
  %8 = add i64 %7, %tmp, !dbg !420
  %9 = inttoptr i64 %8 to i8*, !dbg !420
  %10 = add i32 %3, 8, !dbg !420
  store i32 %10, i32* %2, align 8, !dbg !420
  br label %bb5, !dbg !420

bb4:                                              ; preds = %bb
  %11 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 2, !dbg !420
  %12 = load i8** %11, align 8, !dbg !420
  %13 = getelementptr inbounds i8* %12, i64 8, !dbg !420
  store i8* %13, i8** %11, align 8, !dbg !420
  br label %bb5, !dbg !420

bb5:                                              ; preds = %bb4, %bb3
  %addr.27.0 = phi i8* [ %12, %bb4 ], [ %9, %bb3 ]
  %14 = bitcast i8* %addr.27.0 to i32*, !dbg !420
  %15 = load i32* %14, align 4, !dbg !420
  call void @llvm.dbg.value(metadata !{i32 %15}, i64 0, metadata !243), !dbg !420
  call void @llvm.va_end(i8* %ap12), !dbg !421
  br label %bb8, !dbg !421

bb8:                                              ; preds = %entry, %bb5
  %mode.0 = phi i32 [ %15, %bb5 ], [ 0, %entry ]
  %16 = call i32 @__fd_openat(i32 %fd, i8* %pathname, i32 %flags, i32 %mode.0) nounwind, !dbg !422
  ret i32 %16, !dbg !422
}

declare i32 @__fd_openat(i32, i8*, i32, i32)

!llvm.dbg.sp = !{!0, !69, !75, !76, !96, !128, !132, !135, !138, !141, !144, !145, !146, !149}
!llvm.dbg.lv.__stat64_to_stat = !{!152, !153}
!llvm.dbg.lv.open64 = !{!154, !155, !156, !159}
!llvm.dbg.lv.open = !{!174, !175, !176, !178}
!llvm.dbg.lv.getdents = !{!180, !181, !182, !183, !194, !195, !197, !199}
!llvm.dbg.lv.statfs = !{!200, !201}
!llvm.dbg.lv.ftruncate = !{!202, !203}
!llvm.dbg.lv.fstat = !{!204, !205, !206, !208}
!llvm.dbg.lv.__fxstat = !{!209, !210, !211, !212, !214}
!llvm.dbg.lv.lstat = !{!215, !216, !217, !219}
!llvm.dbg.lv.__lxstat = !{!220, !221, !222, !223, !225}
!llvm.dbg.lv.stat = !{!226, !227, !228, !230}
!llvm.dbg.lv.__xstat = !{!231, !232, !233, !234, !236}
!llvm.dbg.lv.lseek = !{!237, !238, !239}
!llvm.dbg.lv.openat = !{!240, !241, !242, !243, !245}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__stat64_to_stat", metadata !"__stat64_to_stat", metadata !"", metadata !1, i32 41, metadata !3, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"fd_32.c", metadata !"/home/qiu/QTools/klee/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"fd_32.c", metadata !"/home/qiu/QTools/klee/runtime/POSIX/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{null, metadata !5, metadata !49}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !6} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589843, metadata !1, metadata !"stat64", metadata !7, i32 23, i64 1152, i64 64, i64 0, i32 0, null, metadata !8, i32 0, null} ; [ DW_TAG_structure_type ]
!7 = metadata !{i32 589865, metadata !"fd.h", metadata !"/home/qiu/QTools/klee/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!8 = metadata !{metadata !9, metadata !14, metadata !16, metadata !18, metadata !21, metadata !23, metadata !25, metadata !27, metadata !28, metadata !31, metadata !33, metadata !35, metadata !43, metadata !44, metadata !45}
!9 = metadata !{i32 589837, metadata !6, metadata !"st_dev", metadata !10, i32 121, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ]
!10 = metadata !{i32 589865, metadata !"stat.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!11 = metadata !{i32 589846, metadata !12, metadata !"__dev_t", metadata !12, i32 125, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!12 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!13 = metadata !{i32 589860, metadata !1, metadata !"long unsigned int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!14 = metadata !{i32 589837, metadata !6, metadata !"st_ino", metadata !10, i32 123, i64 64, i64 64, i64 64, i32 0, metadata !15} ; [ DW_TAG_member ]
!15 = metadata !{i32 589846, metadata !12, metadata !"__ino64_t", metadata !12, i32 129, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!16 = metadata !{i32 589837, metadata !6, metadata !"st_nlink", metadata !10, i32 124, i64 64, i64 64, i64 128, i32 0, metadata !17} ; [ DW_TAG_member ]
!17 = metadata !{i32 589846, metadata !12, metadata !"__nlink_t", metadata !12, i32 131, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!18 = metadata !{i32 589837, metadata !6, metadata !"st_mode", metadata !10, i32 125, i64 32, i64 32, i64 192, i32 0, metadata !19} ; [ DW_TAG_member ]
!19 = metadata !{i32 589846, metadata !12, metadata !"__mode_t", metadata !12, i32 130, i64 0, i64 0, i64 0, i32 0, metadata !20} ; [ DW_TAG_typedef ]
!20 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!21 = metadata !{i32 589837, metadata !6, metadata !"st_uid", metadata !10, i32 132, i64 32, i64 32, i64 224, i32 0, metadata !22} ; [ DW_TAG_member ]
!22 = metadata !{i32 589846, metadata !12, metadata !"__uid_t", metadata !12, i32 126, i64 0, i64 0, i64 0, i32 0, metadata !20} ; [ DW_TAG_typedef ]
!23 = metadata !{i32 589837, metadata !6, metadata !"st_gid", metadata !10, i32 133, i64 32, i64 32, i64 256, i32 0, metadata !24} ; [ DW_TAG_member ]
!24 = metadata !{i32 589846, metadata !12, metadata !"__gid_t", metadata !12, i32 127, i64 0, i64 0, i64 0, i32 0, metadata !20} ; [ DW_TAG_typedef ]
!25 = metadata !{i32 589837, metadata !6, metadata !"__pad0", metadata !10, i32 135, i64 32, i64 32, i64 288, i32 0, metadata !26} ; [ DW_TAG_member ]
!26 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!27 = metadata !{i32 589837, metadata !6, metadata !"st_rdev", metadata !10, i32 136, i64 64, i64 64, i64 320, i32 0, metadata !11} ; [ DW_TAG_member ]
!28 = metadata !{i32 589837, metadata !6, metadata !"st_size", metadata !10, i32 137, i64 64, i64 64, i64 384, i32 0, metadata !29} ; [ DW_TAG_member ]
!29 = metadata !{i32 589846, metadata !12, metadata !"__off_t", metadata !12, i32 132, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!30 = metadata !{i32 589860, metadata !1, metadata !"long int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!31 = metadata !{i32 589837, metadata !6, metadata !"st_blksize", metadata !10, i32 143, i64 64, i64 64, i64 448, i32 0, metadata !32} ; [ DW_TAG_member ]
!32 = metadata !{i32 589846, metadata !12, metadata !"__blksize_t", metadata !12, i32 158, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!33 = metadata !{i32 589837, metadata !6, metadata !"st_blocks", metadata !10, i32 144, i64 64, i64 64, i64 512, i32 0, metadata !34} ; [ DW_TAG_member ]
!34 = metadata !{i32 589846, metadata !12, metadata !"__blkcnt64_t", metadata !12, i32 162, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!35 = metadata !{i32 589837, metadata !6, metadata !"st_atim", metadata !10, i32 152, i64 128, i64 64, i64 576, i32 0, metadata !36} ; [ DW_TAG_member ]
!36 = metadata !{i32 589843, metadata !1, metadata !"timespec", metadata !37, i32 121, i64 128, i64 64, i64 0, i32 0, null, metadata !38, i32 0, null} ; [ DW_TAG_structure_type ]
!37 = metadata !{i32 589865, metadata !"time.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!38 = metadata !{metadata !39, metadata !41}
!39 = metadata !{i32 589837, metadata !36, metadata !"tv_sec", metadata !37, i32 122, i64 64, i64 64, i64 0, i32 0, metadata !40} ; [ DW_TAG_member ]
!40 = metadata !{i32 589846, metadata !12, metadata !"__time_t", metadata !12, i32 140, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!41 = metadata !{i32 589837, metadata !36, metadata !"tv_nsec", metadata !37, i32 123, i64 64, i64 64, i64 64, i32 0, metadata !42} ; [ DW_TAG_member ]
!42 = metadata !{i32 589846, metadata !12, metadata !"__syscall_slong_t", metadata !12, i32 177, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!43 = metadata !{i32 589837, metadata !6, metadata !"st_mtim", metadata !10, i32 153, i64 128, i64 64, i64 704, i32 0, metadata !36} ; [ DW_TAG_member ]
!44 = metadata !{i32 589837, metadata !6, metadata !"st_ctim", metadata !10, i32 154, i64 128, i64 64, i64 832, i32 0, metadata !36} ; [ DW_TAG_member ]
!45 = metadata !{i32 589837, metadata !6, metadata !"__glibc_reserved", metadata !10, i32 164, i64 192, i64 64, i64 960, i32 0, metadata !46} ; [ DW_TAG_member ]
!46 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 192, i64 64, i64 0, i32 0, metadata !42, metadata !47, i32 0, null} ; [ DW_TAG_array_type ]
!47 = metadata !{metadata !48}
!48 = metadata !{i32 589857, i64 0, i64 2}        ; [ DW_TAG_subrange_type ]
!49 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !50} ; [ DW_TAG_pointer_type ]
!50 = metadata !{i32 589843, metadata !1, metadata !"stat", metadata !10, i32 47, i64 1152, i64 64, i64 0, i32 0, null, metadata !51, i32 0, null} ; [ DW_TAG_structure_type ]
!51 = metadata !{metadata !52, metadata !53, metadata !55, metadata !56, metadata !57, metadata !58, metadata !59, metadata !60, metadata !61, metadata !62, metadata !63, metadata !65, metadata !66, metadata !67, metadata !68}
!52 = metadata !{i32 589837, metadata !50, metadata !"st_dev", metadata !10, i32 48, i64 64, i64 64, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ]
!53 = metadata !{i32 589837, metadata !50, metadata !"st_ino", metadata !10, i32 53, i64 64, i64 64, i64 64, i32 0, metadata !54} ; [ DW_TAG_member ]
!54 = metadata !{i32 589846, metadata !12, metadata !"__ino_t", metadata !12, i32 128, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!55 = metadata !{i32 589837, metadata !50, metadata !"st_nlink", metadata !10, i32 61, i64 64, i64 64, i64 128, i32 0, metadata !17} ; [ DW_TAG_member ]
!56 = metadata !{i32 589837, metadata !50, metadata !"st_mode", metadata !10, i32 62, i64 32, i64 32, i64 192, i32 0, metadata !19} ; [ DW_TAG_member ]
!57 = metadata !{i32 589837, metadata !50, metadata !"st_uid", metadata !10, i32 64, i64 32, i64 32, i64 224, i32 0, metadata !22} ; [ DW_TAG_member ]
!58 = metadata !{i32 589837, metadata !50, metadata !"st_gid", metadata !10, i32 65, i64 32, i64 32, i64 256, i32 0, metadata !24} ; [ DW_TAG_member ]
!59 = metadata !{i32 589837, metadata !50, metadata !"__pad0", metadata !10, i32 67, i64 32, i64 32, i64 288, i32 0, metadata !26} ; [ DW_TAG_member ]
!60 = metadata !{i32 589837, metadata !50, metadata !"st_rdev", metadata !10, i32 69, i64 64, i64 64, i64 320, i32 0, metadata !11} ; [ DW_TAG_member ]
!61 = metadata !{i32 589837, metadata !50, metadata !"st_size", metadata !10, i32 74, i64 64, i64 64, i64 384, i32 0, metadata !29} ; [ DW_TAG_member ]
!62 = metadata !{i32 589837, metadata !50, metadata !"st_blksize", metadata !10, i32 78, i64 64, i64 64, i64 448, i32 0, metadata !32} ; [ DW_TAG_member ]
!63 = metadata !{i32 589837, metadata !50, metadata !"st_blocks", metadata !10, i32 80, i64 64, i64 64, i64 512, i32 0, metadata !64} ; [ DW_TAG_member ]
!64 = metadata !{i32 589846, metadata !12, metadata !"__blkcnt_t", metadata !12, i32 159, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!65 = metadata !{i32 589837, metadata !50, metadata !"st_atim", metadata !10, i32 91, i64 128, i64 64, i64 576, i32 0, metadata !36} ; [ DW_TAG_member ]
!66 = metadata !{i32 589837, metadata !50, metadata !"st_mtim", metadata !10, i32 92, i64 128, i64 64, i64 704, i32 0, metadata !36} ; [ DW_TAG_member ]
!67 = metadata !{i32 589837, metadata !50, metadata !"st_ctim", metadata !10, i32 93, i64 128, i64 64, i64 832, i32 0, metadata !36} ; [ DW_TAG_member ]
!68 = metadata !{i32 589837, metadata !50, metadata !"__glibc_reserved", metadata !10, i32 106, i64 192, i64 64, i64 960, i32 0, metadata !46} ; [ DW_TAG_member ]
!69 = metadata !{i32 589870, i32 0, metadata !1, metadata !"open64", metadata !"open64", metadata !"open64", metadata !1, i32 194, metadata !70, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, ...)* @open64} ; [ DW_TAG_subprogram ]
!70 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !71, i32 0, null} ; [ DW_TAG_subroutine_type ]
!71 = metadata !{metadata !26, metadata !72, metadata !26}
!72 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !73} ; [ DW_TAG_pointer_type ]
!73 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !74} ; [ DW_TAG_const_type ]
!74 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!75 = metadata !{i32 589870, i32 0, metadata !1, metadata !"open", metadata !"open", metadata !"open", metadata !1, i32 65, metadata !70, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, ...)* @open} ; [ DW_TAG_subprogram ]
!76 = metadata !{i32 589870, i32 0, metadata !1, metadata !"getdents", metadata !"getdents", metadata !"getdents", metadata !1, i32 168, metadata !77, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i32, %struct.dirent*, i64)* @getdents} ; [ DW_TAG_subprogram ]
!77 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !78, i32 0, null} ; [ DW_TAG_subroutine_type ]
!78 = metadata !{metadata !79, metadata !26, metadata !81, metadata !95}
!79 = metadata !{i32 589846, metadata !80, metadata !"ssize_t", metadata !80, i32 115, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!80 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/x86_64-linux-gnu/sys", metadata !2} ; [ DW_TAG_file_type ]
!81 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !82} ; [ DW_TAG_pointer_type ]
!82 = metadata !{i32 589843, metadata !1, metadata !"dirent", metadata !83, i32 23, i64 2240, i64 64, i64 0, i32 0, null, metadata !84, i32 0, null} ; [ DW_TAG_structure_type ]
!83 = metadata !{i32 589865, metadata !"dirent.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!84 = metadata !{metadata !85, metadata !86, metadata !87, metadata !89, metadata !91}
!85 = metadata !{i32 589837, metadata !82, metadata !"d_ino", metadata !83, i32 25, i64 64, i64 64, i64 0, i32 0, metadata !54} ; [ DW_TAG_member ]
!86 = metadata !{i32 589837, metadata !82, metadata !"d_off", metadata !83, i32 26, i64 64, i64 64, i64 64, i32 0, metadata !29} ; [ DW_TAG_member ]
!87 = metadata !{i32 589837, metadata !82, metadata !"d_reclen", metadata !83, i32 31, i64 16, i64 16, i64 128, i32 0, metadata !88} ; [ DW_TAG_member ]
!88 = metadata !{i32 589860, metadata !1, metadata !"short unsigned int", metadata !1, i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!89 = metadata !{i32 589837, metadata !82, metadata !"d_type", metadata !83, i32 32, i64 8, i64 8, i64 144, i32 0, metadata !90} ; [ DW_TAG_member ]
!90 = metadata !{i32 589860, metadata !1, metadata !"unsigned char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!91 = metadata !{i32 589837, metadata !82, metadata !"d_name", metadata !83, i32 33, i64 2048, i64 8, i64 152, i32 0, metadata !92} ; [ DW_TAG_member ]
!92 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 2048, i64 8, i64 0, i32 0, metadata !74, metadata !93, i32 0, null} ; [ DW_TAG_array_type ]
!93 = metadata !{metadata !94}
!94 = metadata !{i32 589857, i64 0, i64 255}      ; [ DW_TAG_subrange_type ]
!95 = metadata !{i32 589846, metadata !80, metadata !"size_t", metadata !80, i32 150, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!96 = metadata !{i32 589870, i32 0, metadata !1, metadata !"statfs", metadata !"statfs", metadata !"statfs", metadata !1, i32 143, metadata !97, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.statfs*)* @statfs} ; [ DW_TAG_subprogram ]
!97 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !98, i32 0, null} ; [ DW_TAG_subroutine_type ]
!98 = metadata !{metadata !26, metadata !72, metadata !99}
!99 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !100} ; [ DW_TAG_pointer_type ]
!100 = metadata !{i32 589843, metadata !1, metadata !"statfs", metadata !101, i32 25, i64 960, i64 64, i64 0, i32 0, null, metadata !102, i32 0, null} ; [ DW_TAG_structure_type ]
!101 = metadata !{i32 589865, metadata !"statfs.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!102 = metadata !{metadata !103, metadata !105, metadata !106, metadata !108, metadata !109, metadata !110, metadata !112, metadata !113, metadata !121, metadata !122, metadata !123, metadata !124}
!103 = metadata !{i32 589837, metadata !100, metadata !"f_type", metadata !101, i32 26, i64 64, i64 64, i64 0, i32 0, metadata !104} ; [ DW_TAG_member ]
!104 = metadata !{i32 589846, metadata !12, metadata !"__fsword_t", metadata !12, i32 172, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!105 = metadata !{i32 589837, metadata !100, metadata !"f_bsize", metadata !101, i32 27, i64 64, i64 64, i64 64, i32 0, metadata !104} ; [ DW_TAG_member ]
!106 = metadata !{i32 589837, metadata !100, metadata !"f_blocks", metadata !101, i32 29, i64 64, i64 64, i64 128, i32 0, metadata !107} ; [ DW_TAG_member ]
!107 = metadata !{i32 589846, metadata !12, metadata !"__fsblkcnt_t", metadata !12, i32 163, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!108 = metadata !{i32 589837, metadata !100, metadata !"f_bfree", metadata !101, i32 30, i64 64, i64 64, i64 192, i32 0, metadata !107} ; [ DW_TAG_member ]
!109 = metadata !{i32 589837, metadata !100, metadata !"f_bavail", metadata !101, i32 31, i64 64, i64 64, i64 256, i32 0, metadata !107} ; [ DW_TAG_member ]
!110 = metadata !{i32 589837, metadata !100, metadata !"f_files", metadata !101, i32 32, i64 64, i64 64, i64 320, i32 0, metadata !111} ; [ DW_TAG_member ]
!111 = metadata !{i32 589846, metadata !12, metadata !"__fsfilcnt_t", metadata !12, i32 167, i64 0, i64 0, i64 0, i32 0, metadata !13} ; [ DW_TAG_typedef ]
!112 = metadata !{i32 589837, metadata !100, metadata !"f_ffree", metadata !101, i32 33, i64 64, i64 64, i64 384, i32 0, metadata !111} ; [ DW_TAG_member ]
!113 = metadata !{i32 589837, metadata !100, metadata !"f_fsid", metadata !101, i32 41, i64 64, i64 32, i64 448, i32 0, metadata !114} ; [ DW_TAG_member ]
!114 = metadata !{i32 589846, metadata !12, metadata !"__fsid_t", metadata !12, i32 135, i64 0, i64 0, i64 0, i32 0, metadata !115} ; [ DW_TAG_typedef ]
!115 = metadata !{i32 589843, metadata !1, metadata !"", metadata !12, i32 134, i64 64, i64 32, i64 0, i32 0, null, metadata !116, i32 0, null} ; [ DW_TAG_structure_type ]
!116 = metadata !{metadata !117}
!117 = metadata !{i32 589837, metadata !115, metadata !"__val", metadata !12, i32 134, i64 64, i64 32, i64 0, i32 0, metadata !118} ; [ DW_TAG_member ]
!118 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 32, i64 0, i32 0, metadata !26, metadata !119, i32 0, null} ; [ DW_TAG_array_type ]
!119 = metadata !{metadata !120}
!120 = metadata !{i32 589857, i64 0, i64 1}       ; [ DW_TAG_subrange_type ]
!121 = metadata !{i32 589837, metadata !100, metadata !"f_namelen", metadata !101, i32 42, i64 64, i64 64, i64 512, i32 0, metadata !104} ; [ DW_TAG_member ]
!122 = metadata !{i32 589837, metadata !100, metadata !"f_frsize", metadata !101, i32 43, i64 64, i64 64, i64 576, i32 0, metadata !104} ; [ DW_TAG_member ]
!123 = metadata !{i32 589837, metadata !100, metadata !"f_flags", metadata !101, i32 44, i64 64, i64 64, i64 640, i32 0, metadata !104} ; [ DW_TAG_member ]
!124 = metadata !{i32 589837, metadata !100, metadata !"f_spare", metadata !101, i32 45, i64 256, i64 64, i64 704, i32 0, metadata !125} ; [ DW_TAG_member ]
!125 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 256, i64 64, i64 0, i32 0, metadata !104, metadata !126, i32 0, null} ; [ DW_TAG_array_type ]
!126 = metadata !{metadata !127}
!127 = metadata !{i32 589857, i64 0, i64 3}       ; [ DW_TAG_subrange_type ]
!128 = metadata !{i32 589870, i32 0, metadata !1, metadata !"ftruncate", metadata !"ftruncate", metadata !"ftruncate", metadata !1, i32 139, metadata !129, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i64)* @ftruncate} ; [ DW_TAG_subprogram ]
!129 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !130, i32 0, null} ; [ DW_TAG_subroutine_type ]
!130 = metadata !{metadata !26, metadata !26, metadata !131}
!131 = metadata !{i32 589846, metadata !80, metadata !"off_t", metadata !80, i32 93, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!132 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fstat", metadata !"fstat", metadata !"fstat", metadata !1, i32 132, metadata !133, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.stat*)* @fstat} ; [ DW_TAG_subprogram ]
!133 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !134, i32 0, null} ; [ DW_TAG_subroutine_type ]
!134 = metadata !{metadata !26, metadata !26, metadata !49}
!135 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fxstat", metadata !"__fxstat", metadata !"__fxstat", metadata !1, i32 125, metadata !136, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, %struct.stat*)* @__fxstat} ; [ DW_TAG_subprogram ]
!136 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !137, i32 0, null} ; [ DW_TAG_subroutine_type ]
!137 = metadata !{metadata !26, metadata !26, metadata !26, metadata !49}
!138 = metadata !{i32 589870, i32 0, metadata !1, metadata !"lstat", metadata !"lstat", metadata !"lstat", metadata !1, i32 118, metadata !139, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.stat*)* @lstat} ; [ DW_TAG_subprogram ]
!139 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !140, i32 0, null} ; [ DW_TAG_subroutine_type ]
!140 = metadata !{metadata !26, metadata !72, metadata !49}
!141 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__lxstat", metadata !"__lxstat", metadata !"__lxstat", metadata !1, i32 111, metadata !142, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, %struct.stat*)* @__lxstat} ; [ DW_TAG_subprogram ]
!142 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !143, i32 0, null} ; [ DW_TAG_subroutine_type ]
!143 = metadata !{metadata !26, metadata !26, metadata !72, metadata !49}
!144 = metadata !{i32 589870, i32 0, metadata !1, metadata !"stat", metadata !"stat", metadata !"stat", metadata !1, i32 104, metadata !139, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.stat*)* @stat} ; [ DW_TAG_subprogram ]
!145 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__xstat", metadata !"__xstat", metadata !"__xstat", metadata !1, i32 97, metadata !142, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, %struct.stat*)* @__xstat} ; [ DW_TAG_subprogram ]
!146 = metadata !{i32 589870, i32 0, metadata !1, metadata !"lseek", metadata !"lseek", metadata !"lseek", metadata !1, i32 93, metadata !147, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i32, i64, i32)* @lseek} ; [ DW_TAG_subprogram ]
!147 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !148, i32 0, null} ; [ DW_TAG_subroutine_type ]
!148 = metadata !{metadata !131, metadata !26, metadata !131, metadata !26}
!149 = metadata !{i32 589870, i32 0, metadata !1, metadata !"openat", metadata !"openat", metadata !"openat", metadata !1, i32 79, metadata !150, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, i32, ...)* @openat} ; [ DW_TAG_subprogram ]
!150 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !151, i32 0, null} ; [ DW_TAG_subroutine_type ]
!151 = metadata !{metadata !26, metadata !26, metadata !72, metadata !26}
!152 = metadata !{i32 590081, metadata !0, metadata !"a", metadata !1, i32 41, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!153 = metadata !{i32 590081, metadata !0, metadata !"b", metadata !1, i32 41, metadata !49, i32 0} ; [ DW_TAG_arg_variable ]
!154 = metadata !{i32 590081, metadata !69, metadata !"pathname", metadata !1, i32 194, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!155 = metadata !{i32 590081, metadata !69, metadata !"flags", metadata !1, i32 194, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!156 = metadata !{i32 590080, metadata !157, metadata !"mode", metadata !1, i32 195, metadata !158, i32 0} ; [ DW_TAG_auto_variable ]
!157 = metadata !{i32 589835, metadata !69, i32 194, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!158 = metadata !{i32 589846, metadata !80, metadata !"mode_t", metadata !80, i32 75, i64 0, i64 0, i64 0, i32 0, metadata !20} ; [ DW_TAG_typedef ]
!159 = metadata !{i32 590080, metadata !160, metadata !"ap", metadata !1, i32 199, metadata !161, i32 0} ; [ DW_TAG_auto_variable ]
!160 = metadata !{i32 589835, metadata !157, i32 200, i32 0, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!161 = metadata !{i32 589846, metadata !162, metadata !"va_list", metadata !162, i32 110, i64 0, i64 0, i64 0, i32 0, metadata !163} ; [ DW_TAG_typedef ]
!162 = metadata !{i32 589865, metadata !"stdio.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!163 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 192, i64 64, i64 0, i32 0, metadata !164, metadata !172, i32 0, null} ; [ DW_TAG_array_type ]
!164 = metadata !{i32 589843, metadata !1, metadata !"__va_list_tag", metadata !165, i32 0, i64 192, i64 64, i64 0, i32 0, null, metadata !166, i32 0, null} ; [ DW_TAG_structure_type ]
!165 = metadata !{i32 589865, metadata !"<built-in>", metadata !"/home/qiu/QTools/klee/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!166 = metadata !{metadata !167, metadata !168, metadata !169, metadata !171}
!167 = metadata !{i32 589837, metadata !164, metadata !"gp_offset", metadata !165, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !20} ; [ DW_TAG_member ]
!168 = metadata !{i32 589837, metadata !164, metadata !"fp_offset", metadata !165, i32 0, i64 32, i64 32, i64 32, i32 0, metadata !20} ; [ DW_TAG_member ]
!169 = metadata !{i32 589837, metadata !164, metadata !"overflow_arg_area", metadata !165, i32 0, i64 64, i64 64, i64 64, i32 0, metadata !170} ; [ DW_TAG_member ]
!170 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!171 = metadata !{i32 589837, metadata !164, metadata !"reg_save_area", metadata !165, i32 0, i64 64, i64 64, i64 128, i32 0, metadata !170} ; [ DW_TAG_member ]
!172 = metadata !{metadata !173}
!173 = metadata !{i32 589857, i64 0, i64 0}       ; [ DW_TAG_subrange_type ]
!174 = metadata !{i32 590081, metadata !75, metadata !"pathname", metadata !1, i32 65, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!175 = metadata !{i32 590081, metadata !75, metadata !"flags", metadata !1, i32 65, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!176 = metadata !{i32 590080, metadata !177, metadata !"mode", metadata !1, i32 66, metadata !158, i32 0} ; [ DW_TAG_auto_variable ]
!177 = metadata !{i32 589835, metadata !75, i32 65, i32 0, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!178 = metadata !{i32 590080, metadata !179, metadata !"ap", metadata !1, i32 70, metadata !161, i32 0} ; [ DW_TAG_auto_variable ]
!179 = metadata !{i32 589835, metadata !177, i32 71, i32 0, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!180 = metadata !{i32 590081, metadata !76, metadata !"fd", metadata !1, i32 168, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!181 = metadata !{i32 590081, metadata !76, metadata !"dirp", metadata !1, i32 168, metadata !81, i32 0} ; [ DW_TAG_arg_variable ]
!182 = metadata !{i32 590081, metadata !76, metadata !"nbytes", metadata !1, i32 168, metadata !95, i32 0} ; [ DW_TAG_arg_variable ]
!183 = metadata !{i32 590080, metadata !184, metadata !"dp64", metadata !1, i32 169, metadata !185, i32 0} ; [ DW_TAG_auto_variable ]
!184 = metadata !{i32 589835, metadata !76, i32 168, i32 0, metadata !1, i32 5} ; [ DW_TAG_lexical_block ]
!185 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !186} ; [ DW_TAG_pointer_type ]
!186 = metadata !{i32 589843, metadata !1, metadata !"dirent64", metadata !83, i32 38, i64 2240, i64 64, i64 0, i32 0, null, metadata !187, i32 0, null} ; [ DW_TAG_structure_type ]
!187 = metadata !{metadata !188, metadata !189, metadata !191, metadata !192, metadata !193}
!188 = metadata !{i32 589837, metadata !186, metadata !"d_ino", metadata !83, i32 39, i64 64, i64 64, i64 0, i32 0, metadata !15} ; [ DW_TAG_member ]
!189 = metadata !{i32 589837, metadata !186, metadata !"d_off", metadata !83, i32 40, i64 64, i64 64, i64 64, i32 0, metadata !190} ; [ DW_TAG_member ]
!190 = metadata !{i32 589846, metadata !12, metadata !"__off64_t", metadata !12, i32 133, i64 0, i64 0, i64 0, i32 0, metadata !30} ; [ DW_TAG_typedef ]
!191 = metadata !{i32 589837, metadata !186, metadata !"d_reclen", metadata !83, i32 41, i64 16, i64 16, i64 128, i32 0, metadata !88} ; [ DW_TAG_member ]
!192 = metadata !{i32 589837, metadata !186, metadata !"d_type", metadata !83, i32 42, i64 8, i64 8, i64 144, i32 0, metadata !90} ; [ DW_TAG_member ]
!193 = metadata !{i32 589837, metadata !186, metadata !"d_name", metadata !83, i32 43, i64 2048, i64 8, i64 152, i32 0, metadata !92} ; [ DW_TAG_member ]
!194 = metadata !{i32 590080, metadata !184, metadata !"res", metadata !1, i32 170, metadata !79, i32 0} ; [ DW_TAG_auto_variable ]
!195 = metadata !{i32 590080, metadata !196, metadata !"end", metadata !1, i32 173, metadata !185, i32 0} ; [ DW_TAG_auto_variable ]
!196 = metadata !{i32 589835, metadata !184, i32 173, i32 0, metadata !1, i32 6} ; [ DW_TAG_lexical_block ]
!197 = metadata !{i32 590080, metadata !198, metadata !"dp", metadata !1, i32 175, metadata !81, i32 0} ; [ DW_TAG_auto_variable ]
!198 = metadata !{i32 589835, metadata !196, i32 175, i32 0, metadata !1, i32 7} ; [ DW_TAG_lexical_block ]
!199 = metadata !{i32 590080, metadata !198, metadata !"name_len", metadata !1, i32 176, metadata !95, i32 0} ; [ DW_TAG_auto_variable ]
!200 = metadata !{i32 590081, metadata !96, metadata !"path", metadata !1, i32 143, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!201 = metadata !{i32 590081, metadata !96, metadata !"buf32", metadata !1, i32 143, metadata !99, i32 0} ; [ DW_TAG_arg_variable ]
!202 = metadata !{i32 590081, metadata !128, metadata !"fd", metadata !1, i32 139, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!203 = metadata !{i32 590081, metadata !128, metadata !"length", metadata !1, i32 139, metadata !131, i32 0} ; [ DW_TAG_arg_variable ]
!204 = metadata !{i32 590081, metadata !132, metadata !"fd", metadata !1, i32 132, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!205 = metadata !{i32 590081, metadata !132, metadata !"buf", metadata !1, i32 132, metadata !49, i32 0} ; [ DW_TAG_arg_variable ]
!206 = metadata !{i32 590080, metadata !207, metadata !"tmp", metadata !1, i32 133, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!207 = metadata !{i32 589835, metadata !132, i32 132, i32 0, metadata !1, i32 10} ; [ DW_TAG_lexical_block ]
!208 = metadata !{i32 590080, metadata !207, metadata !"res", metadata !1, i32 134, metadata !26, i32 0} ; [ DW_TAG_auto_variable ]
!209 = metadata !{i32 590081, metadata !135, metadata !"vers", metadata !1, i32 125, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!210 = metadata !{i32 590081, metadata !135, metadata !"fd", metadata !1, i32 125, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!211 = metadata !{i32 590081, metadata !135, metadata !"buf", metadata !1, i32 125, metadata !49, i32 0} ; [ DW_TAG_arg_variable ]
!212 = metadata !{i32 590080, metadata !213, metadata !"tmp", metadata !1, i32 126, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!213 = metadata !{i32 589835, metadata !135, i32 125, i32 0, metadata !1, i32 11} ; [ DW_TAG_lexical_block ]
!214 = metadata !{i32 590080, metadata !213, metadata !"res", metadata !1, i32 127, metadata !26, i32 0} ; [ DW_TAG_auto_variable ]
!215 = metadata !{i32 590081, metadata !138, metadata !"path", metadata !1, i32 118, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!216 = metadata !{i32 590081, metadata !138, metadata !"buf", metadata !1, i32 118, metadata !49, i32 0} ; [ DW_TAG_arg_variable ]
!217 = metadata !{i32 590080, metadata !218, metadata !"tmp", metadata !1, i32 119, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!218 = metadata !{i32 589835, metadata !138, i32 118, i32 0, metadata !1, i32 12} ; [ DW_TAG_lexical_block ]
!219 = metadata !{i32 590080, metadata !218, metadata !"res", metadata !1, i32 120, metadata !26, i32 0} ; [ DW_TAG_auto_variable ]
!220 = metadata !{i32 590081, metadata !141, metadata !"vers", metadata !1, i32 111, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!221 = metadata !{i32 590081, metadata !141, metadata !"path", metadata !1, i32 111, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!222 = metadata !{i32 590081, metadata !141, metadata !"buf", metadata !1, i32 111, metadata !49, i32 0} ; [ DW_TAG_arg_variable ]
!223 = metadata !{i32 590080, metadata !224, metadata !"tmp", metadata !1, i32 112, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!224 = metadata !{i32 589835, metadata !141, i32 111, i32 0, metadata !1, i32 13} ; [ DW_TAG_lexical_block ]
!225 = metadata !{i32 590080, metadata !224, metadata !"res", metadata !1, i32 113, metadata !26, i32 0} ; [ DW_TAG_auto_variable ]
!226 = metadata !{i32 590081, metadata !144, metadata !"path", metadata !1, i32 104, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!227 = metadata !{i32 590081, metadata !144, metadata !"buf", metadata !1, i32 104, metadata !49, i32 0} ; [ DW_TAG_arg_variable ]
!228 = metadata !{i32 590080, metadata !229, metadata !"tmp", metadata !1, i32 105, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!229 = metadata !{i32 589835, metadata !144, i32 104, i32 0, metadata !1, i32 14} ; [ DW_TAG_lexical_block ]
!230 = metadata !{i32 590080, metadata !229, metadata !"res", metadata !1, i32 106, metadata !26, i32 0} ; [ DW_TAG_auto_variable ]
!231 = metadata !{i32 590081, metadata !145, metadata !"vers", metadata !1, i32 97, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!232 = metadata !{i32 590081, metadata !145, metadata !"path", metadata !1, i32 97, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!233 = metadata !{i32 590081, metadata !145, metadata !"buf", metadata !1, i32 97, metadata !49, i32 0} ; [ DW_TAG_arg_variable ]
!234 = metadata !{i32 590080, metadata !235, metadata !"tmp", metadata !1, i32 98, metadata !6, i32 0} ; [ DW_TAG_auto_variable ]
!235 = metadata !{i32 589835, metadata !145, i32 97, i32 0, metadata !1, i32 15} ; [ DW_TAG_lexical_block ]
!236 = metadata !{i32 590080, metadata !235, metadata !"res", metadata !1, i32 99, metadata !26, i32 0} ; [ DW_TAG_auto_variable ]
!237 = metadata !{i32 590081, metadata !146, metadata !"fd", metadata !1, i32 93, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!238 = metadata !{i32 590081, metadata !146, metadata !"off", metadata !1, i32 93, metadata !131, i32 0} ; [ DW_TAG_arg_variable ]
!239 = metadata !{i32 590081, metadata !146, metadata !"whence", metadata !1, i32 93, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!240 = metadata !{i32 590081, metadata !149, metadata !"fd", metadata !1, i32 79, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!241 = metadata !{i32 590081, metadata !149, metadata !"pathname", metadata !1, i32 79, metadata !72, i32 0} ; [ DW_TAG_arg_variable ]
!242 = metadata !{i32 590081, metadata !149, metadata !"flags", metadata !1, i32 79, metadata !26, i32 0} ; [ DW_TAG_arg_variable ]
!243 = metadata !{i32 590080, metadata !244, metadata !"mode", metadata !1, i32 80, metadata !158, i32 0} ; [ DW_TAG_auto_variable ]
!244 = metadata !{i32 589835, metadata !149, i32 79, i32 0, metadata !1, i32 17} ; [ DW_TAG_lexical_block ]
!245 = metadata !{i32 590080, metadata !246, metadata !"ap", metadata !1, i32 84, metadata !161, i32 0} ; [ DW_TAG_auto_variable ]
!246 = metadata !{i32 589835, metadata !244, i32 85, i32 0, metadata !1, i32 18} ; [ DW_TAG_lexical_block ]
!247 = metadata !{i32 65, i32 0, metadata !75, null}
!248 = metadata !{i32 0}
!249 = metadata !{i32 66, i32 0, metadata !177, null}
!250 = metadata !{i32 68, i32 0, metadata !177, null}
!251 = metadata !{i32 70, i32 0, metadata !179, null}
!252 = metadata !{i32 71, i32 0, metadata !179, null}
!253 = metadata !{i32 72, i32 0, metadata !179, null}
!254 = metadata !{i32 73, i32 0, metadata !179, null}
!255 = metadata !{i32 76, i32 0, metadata !177, null}
!256 = metadata !{i32 194, i32 0, metadata !69, null}
!257 = metadata !{i32 195, i32 0, metadata !157, null}
!258 = metadata !{i32 197, i32 0, metadata !157, null}
!259 = metadata !{i32 199, i32 0, metadata !160, null}
!260 = metadata !{i32 200, i32 0, metadata !160, null}
!261 = metadata !{i32 201, i32 0, metadata !160, null}
!262 = metadata !{i32 202, i32 0, metadata !160, null}
!263 = metadata !{i32 205, i32 0, metadata !157, null}
!264 = metadata !{i32 168, i32 0, metadata !76, null}
!265 = metadata !{i32 169, i32 0, metadata !184, null}
!266 = metadata !{i32 170, i32 0, metadata !184, null}
!267 = metadata !{i32 172, i32 0, metadata !184, null}
!268 = metadata !{i32 173, i32 0, metadata !196, null}
!269 = metadata !{i32 174, i32 0, metadata !196, null}
!270 = metadata !{i32 177, i32 0, metadata !198, null}
!271 = metadata !{i32 183, i32 0, metadata !198, null}
!272 = metadata !{i32 187, i32 0, metadata !184, null}
!273 = metadata !{i32 143, i32 0, metadata !96, null}
!274 = metadata !{i32 162, i32 0, metadata !275, null}
!275 = metadata !{i32 589835, metadata !96, i32 143, i32 0, metadata !1, i32 8} ; [ DW_TAG_lexical_block ]
!276 = metadata !{i32 139, i32 0, metadata !128, null}
!277 = metadata !{i32 140, i32 0, metadata !278, null}
!278 = metadata !{i32 589835, metadata !128, i32 139, i32 0, metadata !1, i32 9} ; [ DW_TAG_lexical_block ]
!279 = metadata !{i32 132, i32 0, metadata !132, null}
!280 = metadata !{i32 133, i32 0, metadata !207, null}
!281 = metadata !{i32 134, i32 0, metadata !207, null}
!282 = metadata !{i32 41, i32 0, metadata !0, metadata !283}
!283 = metadata !{i32 135, i32 0, metadata !207, null}
!284 = metadata !{i32 42, i32 0, metadata !285, metadata !283}
!285 = metadata !{i32 589835, metadata !0, i32 41, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!286 = metadata !{i32 43, i32 0, metadata !285, metadata !283}
!287 = metadata !{i32 44, i32 0, metadata !285, metadata !283}
!288 = metadata !{i32 45, i32 0, metadata !285, metadata !283}
!289 = metadata !{i32 46, i32 0, metadata !285, metadata !283}
!290 = metadata !{i32 47, i32 0, metadata !285, metadata !283}
!291 = metadata !{i32 48, i32 0, metadata !285, metadata !283}
!292 = metadata !{i32 49, i32 0, metadata !285, metadata !283}
!293 = metadata !{i32 50, i32 0, metadata !285, metadata !283}
!294 = metadata !{i32 51, i32 0, metadata !285, metadata !283}
!295 = metadata !{i32 52, i32 0, metadata !285, metadata !283}
!296 = metadata !{i32 53, i32 0, metadata !285, metadata !283}
!297 = metadata !{i32 54, i32 0, metadata !285, metadata !283}
!298 = metadata !{i32 56, i32 0, metadata !285, metadata !283}
!299 = metadata !{i32 57, i32 0, metadata !285, metadata !283}
!300 = metadata !{i32 58, i32 0, metadata !285, metadata !283}
!301 = metadata !{i32 136, i32 0, metadata !207, null}
!302 = metadata !{i32 125, i32 0, metadata !135, null}
!303 = metadata !{i32 126, i32 0, metadata !213, null}
!304 = metadata !{i32 127, i32 0, metadata !213, null}
!305 = metadata !{i32 41, i32 0, metadata !0, metadata !306}
!306 = metadata !{i32 128, i32 0, metadata !213, null}
!307 = metadata !{i32 42, i32 0, metadata !285, metadata !306}
!308 = metadata !{i32 43, i32 0, metadata !285, metadata !306}
!309 = metadata !{i32 44, i32 0, metadata !285, metadata !306}
!310 = metadata !{i32 45, i32 0, metadata !285, metadata !306}
!311 = metadata !{i32 46, i32 0, metadata !285, metadata !306}
!312 = metadata !{i32 47, i32 0, metadata !285, metadata !306}
!313 = metadata !{i32 48, i32 0, metadata !285, metadata !306}
!314 = metadata !{i32 49, i32 0, metadata !285, metadata !306}
!315 = metadata !{i32 50, i32 0, metadata !285, metadata !306}
!316 = metadata !{i32 51, i32 0, metadata !285, metadata !306}
!317 = metadata !{i32 52, i32 0, metadata !285, metadata !306}
!318 = metadata !{i32 53, i32 0, metadata !285, metadata !306}
!319 = metadata !{i32 54, i32 0, metadata !285, metadata !306}
!320 = metadata !{i32 56, i32 0, metadata !285, metadata !306}
!321 = metadata !{i32 57, i32 0, metadata !285, metadata !306}
!322 = metadata !{i32 58, i32 0, metadata !285, metadata !306}
!323 = metadata !{i32 129, i32 0, metadata !213, null}
!324 = metadata !{i32 118, i32 0, metadata !138, null}
!325 = metadata !{i32 119, i32 0, metadata !218, null}
!326 = metadata !{i32 120, i32 0, metadata !218, null}
!327 = metadata !{i32 41, i32 0, metadata !0, metadata !328}
!328 = metadata !{i32 121, i32 0, metadata !218, null}
!329 = metadata !{i32 42, i32 0, metadata !285, metadata !328}
!330 = metadata !{i32 43, i32 0, metadata !285, metadata !328}
!331 = metadata !{i32 44, i32 0, metadata !285, metadata !328}
!332 = metadata !{i32 45, i32 0, metadata !285, metadata !328}
!333 = metadata !{i32 46, i32 0, metadata !285, metadata !328}
!334 = metadata !{i32 47, i32 0, metadata !285, metadata !328}
!335 = metadata !{i32 48, i32 0, metadata !285, metadata !328}
!336 = metadata !{i32 49, i32 0, metadata !285, metadata !328}
!337 = metadata !{i32 50, i32 0, metadata !285, metadata !328}
!338 = metadata !{i32 51, i32 0, metadata !285, metadata !328}
!339 = metadata !{i32 52, i32 0, metadata !285, metadata !328}
!340 = metadata !{i32 53, i32 0, metadata !285, metadata !328}
!341 = metadata !{i32 54, i32 0, metadata !285, metadata !328}
!342 = metadata !{i32 56, i32 0, metadata !285, metadata !328}
!343 = metadata !{i32 57, i32 0, metadata !285, metadata !328}
!344 = metadata !{i32 58, i32 0, metadata !285, metadata !328}
!345 = metadata !{i32 122, i32 0, metadata !218, null}
!346 = metadata !{i32 111, i32 0, metadata !141, null}
!347 = metadata !{i32 112, i32 0, metadata !224, null}
!348 = metadata !{i32 113, i32 0, metadata !224, null}
!349 = metadata !{i32 41, i32 0, metadata !0, metadata !350}
!350 = metadata !{i32 114, i32 0, metadata !224, null}
!351 = metadata !{i32 42, i32 0, metadata !285, metadata !350}
!352 = metadata !{i32 43, i32 0, metadata !285, metadata !350}
!353 = metadata !{i32 44, i32 0, metadata !285, metadata !350}
!354 = metadata !{i32 45, i32 0, metadata !285, metadata !350}
!355 = metadata !{i32 46, i32 0, metadata !285, metadata !350}
!356 = metadata !{i32 47, i32 0, metadata !285, metadata !350}
!357 = metadata !{i32 48, i32 0, metadata !285, metadata !350}
!358 = metadata !{i32 49, i32 0, metadata !285, metadata !350}
!359 = metadata !{i32 50, i32 0, metadata !285, metadata !350}
!360 = metadata !{i32 51, i32 0, metadata !285, metadata !350}
!361 = metadata !{i32 52, i32 0, metadata !285, metadata !350}
!362 = metadata !{i32 53, i32 0, metadata !285, metadata !350}
!363 = metadata !{i32 54, i32 0, metadata !285, metadata !350}
!364 = metadata !{i32 56, i32 0, metadata !285, metadata !350}
!365 = metadata !{i32 57, i32 0, metadata !285, metadata !350}
!366 = metadata !{i32 58, i32 0, metadata !285, metadata !350}
!367 = metadata !{i32 115, i32 0, metadata !224, null}
!368 = metadata !{i32 104, i32 0, metadata !144, null}
!369 = metadata !{i32 105, i32 0, metadata !229, null}
!370 = metadata !{i32 106, i32 0, metadata !229, null}
!371 = metadata !{i32 41, i32 0, metadata !0, metadata !372}
!372 = metadata !{i32 107, i32 0, metadata !229, null}
!373 = metadata !{i32 42, i32 0, metadata !285, metadata !372}
!374 = metadata !{i32 43, i32 0, metadata !285, metadata !372}
!375 = metadata !{i32 44, i32 0, metadata !285, metadata !372}
!376 = metadata !{i32 45, i32 0, metadata !285, metadata !372}
!377 = metadata !{i32 46, i32 0, metadata !285, metadata !372}
!378 = metadata !{i32 47, i32 0, metadata !285, metadata !372}
!379 = metadata !{i32 48, i32 0, metadata !285, metadata !372}
!380 = metadata !{i32 49, i32 0, metadata !285, metadata !372}
!381 = metadata !{i32 50, i32 0, metadata !285, metadata !372}
!382 = metadata !{i32 51, i32 0, metadata !285, metadata !372}
!383 = metadata !{i32 52, i32 0, metadata !285, metadata !372}
!384 = metadata !{i32 53, i32 0, metadata !285, metadata !372}
!385 = metadata !{i32 54, i32 0, metadata !285, metadata !372}
!386 = metadata !{i32 56, i32 0, metadata !285, metadata !372}
!387 = metadata !{i32 57, i32 0, metadata !285, metadata !372}
!388 = metadata !{i32 58, i32 0, metadata !285, metadata !372}
!389 = metadata !{i32 108, i32 0, metadata !229, null}
!390 = metadata !{i32 97, i32 0, metadata !145, null}
!391 = metadata !{i32 98, i32 0, metadata !235, null}
!392 = metadata !{i32 99, i32 0, metadata !235, null}
!393 = metadata !{i32 41, i32 0, metadata !0, metadata !394}
!394 = metadata !{i32 100, i32 0, metadata !235, null}
!395 = metadata !{i32 42, i32 0, metadata !285, metadata !394}
!396 = metadata !{i32 43, i32 0, metadata !285, metadata !394}
!397 = metadata !{i32 44, i32 0, metadata !285, metadata !394}
!398 = metadata !{i32 45, i32 0, metadata !285, metadata !394}
!399 = metadata !{i32 46, i32 0, metadata !285, metadata !394}
!400 = metadata !{i32 47, i32 0, metadata !285, metadata !394}
!401 = metadata !{i32 48, i32 0, metadata !285, metadata !394}
!402 = metadata !{i32 49, i32 0, metadata !285, metadata !394}
!403 = metadata !{i32 50, i32 0, metadata !285, metadata !394}
!404 = metadata !{i32 51, i32 0, metadata !285, metadata !394}
!405 = metadata !{i32 52, i32 0, metadata !285, metadata !394}
!406 = metadata !{i32 53, i32 0, metadata !285, metadata !394}
!407 = metadata !{i32 54, i32 0, metadata !285, metadata !394}
!408 = metadata !{i32 56, i32 0, metadata !285, metadata !394}
!409 = metadata !{i32 57, i32 0, metadata !285, metadata !394}
!410 = metadata !{i32 58, i32 0, metadata !285, metadata !394}
!411 = metadata !{i32 101, i32 0, metadata !235, null}
!412 = metadata !{i32 93, i32 0, metadata !146, null}
!413 = metadata !{i32 94, i32 0, metadata !414, null}
!414 = metadata !{i32 589835, metadata !146, i32 93, i32 0, metadata !1, i32 16} ; [ DW_TAG_lexical_block ]
!415 = metadata !{i32 79, i32 0, metadata !149, null}
!416 = metadata !{i32 80, i32 0, metadata !244, null}
!417 = metadata !{i32 82, i32 0, metadata !244, null}
!418 = metadata !{i32 84, i32 0, metadata !246, null}
!419 = metadata !{i32 85, i32 0, metadata !246, null}
!420 = metadata !{i32 86, i32 0, metadata !246, null}
!421 = metadata !{i32 87, i32 0, metadata !246, null}
!422 = metadata !{i32 90, i32 0, metadata !244, null}

; ModuleID = 'fd.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-f128:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

%struct.__fsid_t = type { [2 x i32] }
%struct.__va_list_tag = type { i32, i32, i8*, i8* }
%struct.dirent64 = type { i64, i64, i16, i8, [256 x i8] }
%struct.exe_disk_file_t = type { i32, i8*, %struct.stat* }
%struct.exe_file_system_t = type { i32, %struct.exe_disk_file_t*, %struct.exe_disk_file_t*, i32, %struct.exe_disk_file_t*, i32, i32*, i32*, i32*, i32*, i32*, i32*, i32* }
%struct.exe_file_t = type { i32, i32, i64, %struct.exe_disk_file_t* }
%struct.exe_sym_env_t = type { [32 x %struct.exe_file_t], i32, i32, i32 }
%struct.fd_set = type { [16 x i64] }
%struct.stat = type { i64, i64, i64, i32, i32, i32, i32, i64, i64, i64, i64, %struct.timespec, %struct.timespec, %struct.timespec, [3 x i64] }
%struct.statfs = type { i64, i64, i64, i64, i64, i64, i64, %struct.__fsid_t, i64, i64, i64, [4 x i64] }
%struct.timespec = type { i64, i64 }

@__exe_fs = external unnamed_addr global %struct.exe_file_system_t
@__exe_env = external unnamed_addr global %struct.exe_sym_env_t
@.str = private unnamed_addr constant [18 x i8] c"ignoring (ENOENT)\00", align 1
@.str1 = private unnamed_addr constant [17 x i8] c"ignoring (EPERM)\00", align 1
@.str2 = private unnamed_addr constant [32 x i8] c"symbolic file, ignoring (EPERM)\00", align 8
@.str3 = private unnamed_addr constant [32 x i8] c"symbolic file, ignoring (EBADF)\00", align 8
@n_calls.5292 = internal unnamed_addr global i32 0
@.str4 = private unnamed_addr constant [30 x i8] c"symbolic file, ignoring (EIO)\00", align 1
@.str5 = private unnamed_addr constant [33 x i8] c"symbolic file, ignoring (ENOENT)\00", align 8
@n_calls.5868 = internal unnamed_addr global i32 0
@.str6 = private unnamed_addr constant [44 x i8] c"symbolic file descriptor, ignoring (ENOENT)\00", align 8
@n_calls.4900 = internal unnamed_addr global i32 0
@.str7 = private unnamed_addr constant [47 x i8] c"Undefined call to open(): O_EXCL w/o O_RDONLY\0A\00", align 8
@.str8 = private unnamed_addr constant [33 x i8] c"symbolic file, ignoring (EINVAL)\00", align 8
@.str9 = private unnamed_addr constant [41 x i8] c"(TCGETS) symbolic file, incomplete model\00", align 8
@.str10 = private unnamed_addr constant [42 x i8] c"(TCSETS) symbolic file, silently ignoring\00", align 8
@.str11 = private unnamed_addr constant [43 x i8] c"(TCSETSW) symbolic file, silently ignoring\00", align 8
@.str12 = private unnamed_addr constant [43 x i8] c"(TCSETSF) symbolic file, silently ignoring\00", align 8
@.str13 = private unnamed_addr constant [45 x i8] c"(TIOCGWINSZ) symbolic file, incomplete model\00", align 8
@.str14 = private unnamed_addr constant [46 x i8] c"(TIOCSWINSZ) symbolic file, ignoring (EINVAL)\00", align 8
@.str15 = private unnamed_addr constant [43 x i8] c"(FIONREAD) symbolic file, incomplete model\00", align 8
@.str16 = private unnamed_addr constant [44 x i8] c"(MTIOCGET) symbolic file, ignoring (EINVAL)\00", align 8
@.str17 = private unnamed_addr constant [18 x i8] c"s != (off64_t) -1\00", align 1
@.str18 = private unnamed_addr constant [5 x i8] c"fd.c\00", align 1
@__PRETTY_FUNCTION__.5329 = internal unnamed_addr constant [14 x i8] c"__fd_getdents\00"
@.str19 = private unnamed_addr constant [18 x i8] c"new_off == f->off\00", align 1
@__PRETTY_FUNCTION__.5053 = internal unnamed_addr constant [11 x i8] c"__fd_lseek\00"
@n_calls.4981 = internal unnamed_addr global i32 0
@.str20 = private unnamed_addr constant [7 x i8] c"r >= 0\00", align 1
@__PRETTY_FUNCTION__.4984 = internal unnamed_addr constant [6 x i8] c"write\00"
@.str21 = private unnamed_addr constant [2 x i8] c"0\00", align 1
@.str22 = private unnamed_addr constant [24 x i8] c"write() ignores bytes.\0A\00", align 1
@n_calls.4920 = internal unnamed_addr global i32 0
@.str23 = private unnamed_addr constant [12 x i8] c"f->off >= 0\00", align 1
@__PRETTY_FUNCTION__.4923 = internal unnamed_addr constant [5 x i8] c"read\00"
@n_calls.5199 = internal unnamed_addr global i32 0
@n_calls.5176 = internal unnamed_addr global i32 0

define i32 @access(i8* %pathname, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !401), !dbg !610
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !402), !dbg !610
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !269), !dbg !611
  %0 = load i8* %pathname, align 1, !dbg !613
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !613
  %1 = icmp eq i8 %0, 0, !dbg !614
  br i1 %1, label %bb1, label %bb.i, !dbg !614

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %pathname, i64 1, !dbg !614
  %3 = load i8* %2, align 1, !dbg !614
  %4 = icmp eq i8 %3, 0, !dbg !614
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !614

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !615
  %6 = sext i8 %0 to i32, !dbg !616
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !616
  %8 = add nsw i32 %7, 65, !dbg !616
  %9 = icmp eq i32 %6, %8, !dbg !616
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !616

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !617
  %11 = zext i32 %18 to i64, !dbg !617
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !617
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !619
  %13 = load %struct.stat** %12, align 8, !dbg !619
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !619
  %15 = load i64* %14, align 8, !dbg !619
  %16 = icmp eq i64 %15, 0, !dbg !619
  br i1 %16, label %bb1, label %__get_sym_file.exit, !dbg !619

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !615
  br label %bb8.i, !dbg !615

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !615
  br i1 %19, label %bb3.i, label %bb1, !dbg !615

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !617
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !403), !dbg !612
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !620
  br i1 %21, label %bb1, label %bb4, !dbg !620

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !356) nounwind, !dbg !621
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !346) nounwind, !dbg !623
  %22 = ptrtoint i8* %pathname to i64, !dbg !625
  %23 = tail call i64 @klee_get_valuel(i64 %22) nounwind, !dbg !625
  %24 = inttoptr i64 %23 to i8*, !dbg !625
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !347) nounwind, !dbg !625
  %25 = icmp eq i8* %24, %pathname, !dbg !626
  %26 = zext i1 %25 to i64, !dbg !626
  tail call void @klee_assume(i64 %26) nounwind, !dbg !626
  tail call void @llvm.dbg.value(metadata !{i8* %24}, i64 0, metadata !357) nounwind, !dbg !624
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !628
  br label %bb.i6, !dbg !628

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %24, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %27 = phi i32 [ 0, %bb1 ], [ %39, %bb6.i8 ]
  %tmp.i = add i32 %27, -1
  %28 = load i8* %sc.0.i, align 1, !dbg !629
  %29 = and i32 %tmp.i, %27, !dbg !630
  %30 = icmp eq i32 %29, 0, !dbg !630
  br i1 %30, label %bb1.i, label %bb5.i, !dbg !630

bb1.i:                                            ; preds = %bb.i6
  switch i8 %28, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %28}, i64 0, metadata !360) nounwind, !dbg !629
  store i8 0, i8* %sc.0.i, align 1, !dbg !631
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !631
  br label %__concretize_string.exit, !dbg !631

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !632
  %31 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !632
  br label %bb6.i8, !dbg !632

bb5.i:                                            ; preds = %bb.i6
  %32 = sext i8 %28 to i64, !dbg !633
  %33 = tail call i64 @klee_get_valuel(i64 %32) nounwind, !dbg !633
  %34 = trunc i64 %33 to i8, !dbg !633
  %35 = icmp eq i8 %34, %28, !dbg !634
  %36 = zext i1 %35 to i64, !dbg !634
  tail call void @klee_assume(i64 %36) nounwind, !dbg !634
  store i8 %34, i8* %sc.0.i, align 1, !dbg !635
  %37 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !635
  %38 = icmp eq i8 %34, 0, !dbg !636
  br i1 %38, label %__concretize_string.exit, label %bb6.i8, !dbg !636

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %31, %bb4.i7 ], [ %37, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %39 = add i32 %27, 1, !dbg !628
  br label %bb.i6, !dbg !628

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %40 = tail call i64 (i64, ...)* @syscall(i64 21, i8* %pathname, i32 %mode) nounwind, !dbg !622
  %41 = trunc i64 %40 to i32, !dbg !622
  tail call void @llvm.dbg.value(metadata !{i32 %41}, i64 0, metadata !405), !dbg !622
  %42 = icmp eq i32 %41, -1, !dbg !637
  br i1 %42, label %bb2, label %bb4, !dbg !637

bb2:                                              ; preds = %__concretize_string.exit
  %43 = tail call i32* @__errno_location() nounwind readnone, !dbg !638
  %44 = tail call i32 @klee_get_errno() nounwind, !dbg !638
  store i32 %44, i32* %43, align 4, !dbg !638
  br label %bb4, !dbg !638

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %__get_sym_file.exit
  %.0 = phi i32 [ 0, %__get_sym_file.exit ], [ -1, %bb2 ], [ %41, %__concretize_string.exit ]
  ret i32 %.0, !dbg !639
}

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

define i32 @umask(i32 %mask) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %mask}, i64 0, metadata !279), !dbg !640
  %0 = load i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i64 0, i32 1), align 8, !dbg !641
  tail call void @llvm.dbg.value(metadata !{i32 %0}, i64 0, metadata !280), !dbg !641
  %1 = and i32 %mask, 511, !dbg !642
  store i32 %1, i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i64 0, i32 1), align 8, !dbg !642
  ret i32 %0, !dbg !643
}

define i32 @chroot(i8* nocapture %path) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !288), !dbg !644
  %0 = load i8* %path, align 1, !dbg !645
  switch i8 %0, label %bb4 [
    i8 0, label %bb
    i8 47, label %bb2
  ]

bb:                                               ; preds = %entry
  %1 = tail call i32* @__errno_location() nounwind readnone, !dbg !647
  store i32 2, i32* %1, align 4, !dbg !647
  br label %bb5, !dbg !648

bb2:                                              ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !649
  %3 = load i8* %2, align 1, !dbg !649
  %4 = icmp eq i8 %3, 0, !dbg !649
  br i1 %4, label %bb5, label %bb4, !dbg !649

bb4:                                              ; preds = %entry, %bb2
  tail call void @klee_warning(i8* getelementptr inbounds ([18 x i8]* @.str, i64 0, i64 0)) nounwind, !dbg !650
  %5 = tail call i32* @__errno_location() nounwind readnone, !dbg !651
  store i32 2, i32* %5, align 4, !dbg !651
  br label %bb5, !dbg !652

bb5:                                              ; preds = %bb2, %bb4, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb4 ], [ 0, %bb2 ]
  ret i32 %.0, !dbg !648
}

declare i32* @__errno_location() nounwind readnone

declare void @klee_warning(i8*)

define i32 @unlinkat(i32 %dirfd, i8* nocapture %pathname, i32 %flags) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %dirfd}, i64 0, metadata !289), !dbg !653
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !290), !dbg !653
  tail call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !291), !dbg !653
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !269), !dbg !654
  %0 = load i8* %pathname, align 1, !dbg !656
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !656
  %1 = icmp eq i8 %0, 0, !dbg !657
  br i1 %1, label %bb5, label %bb.i, !dbg !657

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %pathname, i64 1, !dbg !657
  %3 = load i8* %2, align 1, !dbg !657
  %4 = icmp eq i8 %3, 0, !dbg !657
  br i1 %4, label %bb8.preheader.i, label %bb5, !dbg !657

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !658
  %6 = sext i8 %0 to i32, !dbg !659
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !659
  %8 = add nsw i32 %7, 65, !dbg !659
  %9 = icmp eq i32 %6, %8, !dbg !659
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !659

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !660
  %11 = zext i32 %18 to i64, !dbg !660
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !660
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !661
  %13 = load %struct.stat** %12, align 8, !dbg !661
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !661
  %15 = load i64* %14, align 8, !dbg !661
  %16 = icmp eq i64 %15, 0, !dbg !661
  br i1 %16, label %bb5, label %__get_sym_file.exit, !dbg !661

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !658
  br label %bb8.i, !dbg !658

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !658
  br i1 %19, label %bb3.i, label %bb5, !dbg !658

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !660
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !292), !dbg !655
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !662
  br i1 %21, label %bb5, label %bb, !dbg !662

bb:                                               ; preds = %__get_sym_file.exit
  %22 = getelementptr inbounds %struct.stat* %13, i64 0, i32 3, !dbg !663
  %23 = load i32* %22, align 8, !dbg !663
  %24 = and i32 %23, 61440, !dbg !663
  %25 = icmp eq i32 %24, 32768, !dbg !663
  br i1 %25, label %bb1, label %bb2, !dbg !663

bb1:                                              ; preds = %bb
  store i64 0, i64* %14, align 8, !dbg !664
  br label %bb6, !dbg !665

bb2:                                              ; preds = %bb
  %26 = icmp eq i32 %24, 16384, !dbg !666
  %27 = tail call i32* @__errno_location() nounwind readnone, !dbg !667
  br i1 %26, label %bb3, label %bb4, !dbg !666

bb3:                                              ; preds = %bb2
  store i32 21, i32* %27, align 4, !dbg !667
  br label %bb6, !dbg !668

bb4:                                              ; preds = %bb2
  store i32 1, i32* %27, align 4, !dbg !669
  br label %bb6, !dbg !670

bb5:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([17 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !671
  %28 = tail call i32* @__errno_location() nounwind readnone, !dbg !672
  store i32 1, i32* %28, align 4, !dbg !672
  br label %bb6, !dbg !673

bb6:                                              ; preds = %bb5, %bb4, %bb3, %bb1
  %.0 = phi i32 [ 0, %bb1 ], [ -1, %bb3 ], [ -1, %bb4 ], [ -1, %bb5 ]
  ret i32 %.0, !dbg !665
}

define i32 @unlink(i8* nocapture %pathname) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !294), !dbg !674
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !269), !dbg !675
  %0 = load i8* %pathname, align 1, !dbg !677
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !677
  %1 = icmp eq i8 %0, 0, !dbg !678
  br i1 %1, label %bb5, label %bb.i, !dbg !678

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %pathname, i64 1, !dbg !678
  %3 = load i8* %2, align 1, !dbg !678
  %4 = icmp eq i8 %3, 0, !dbg !678
  br i1 %4, label %bb8.preheader.i, label %bb5, !dbg !678

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !679
  %6 = sext i8 %0 to i32, !dbg !680
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !680
  %8 = add nsw i32 %7, 65, !dbg !680
  %9 = icmp eq i32 %6, %8, !dbg !680
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !680

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !681
  %11 = zext i32 %18 to i64, !dbg !681
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !681
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !682
  %13 = load %struct.stat** %12, align 8, !dbg !682
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !682
  %15 = load i64* %14, align 8, !dbg !682
  %16 = icmp eq i64 %15, 0, !dbg !682
  br i1 %16, label %bb5, label %__get_sym_file.exit, !dbg !682

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !679
  br label %bb8.i, !dbg !679

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !679
  br i1 %19, label %bb3.i, label %bb5, !dbg !679

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !681
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !295), !dbg !676
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !683
  br i1 %21, label %bb5, label %bb, !dbg !683

bb:                                               ; preds = %__get_sym_file.exit
  %22 = getelementptr inbounds %struct.stat* %13, i64 0, i32 3, !dbg !684
  %23 = load i32* %22, align 8, !dbg !684
  %24 = and i32 %23, 61440, !dbg !684
  %25 = icmp eq i32 %24, 32768, !dbg !684
  br i1 %25, label %bb1, label %bb2, !dbg !684

bb1:                                              ; preds = %bb
  store i64 0, i64* %14, align 8, !dbg !685
  br label %bb6, !dbg !686

bb2:                                              ; preds = %bb
  %26 = icmp eq i32 %24, 16384, !dbg !687
  %27 = tail call i32* @__errno_location() nounwind readnone, !dbg !688
  br i1 %26, label %bb3, label %bb4, !dbg !687

bb3:                                              ; preds = %bb2
  store i32 21, i32* %27, align 4, !dbg !688
  br label %bb6, !dbg !689

bb4:                                              ; preds = %bb2
  store i32 1, i32* %27, align 4, !dbg !690
  br label %bb6, !dbg !691

bb5:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([17 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !692
  %28 = tail call i32* @__errno_location() nounwind readnone, !dbg !693
  store i32 1, i32* %28, align 4, !dbg !693
  br label %bb6, !dbg !694

bb6:                                              ; preds = %bb5, %bb4, %bb3, %bb1
  %.0 = phi i32 [ 0, %bb1 ], [ -1, %bb3 ], [ -1, %bb4 ], [ -1, %bb5 ]
  ret i32 %.0, !dbg !686
}

define i32 @rmdir(i8* nocapture %pathname) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !297), !dbg !695
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !269), !dbg !696
  %0 = load i8* %pathname, align 1, !dbg !698
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !698
  %1 = icmp eq i8 %0, 0, !dbg !699
  br i1 %1, label %bb3, label %bb.i, !dbg !699

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %pathname, i64 1, !dbg !699
  %3 = load i8* %2, align 1, !dbg !699
  %4 = icmp eq i8 %3, 0, !dbg !699
  br i1 %4, label %bb8.preheader.i, label %bb3, !dbg !699

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !700
  %6 = sext i8 %0 to i32, !dbg !701
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !701
  %8 = add nsw i32 %7, 65, !dbg !701
  %9 = icmp eq i32 %6, %8, !dbg !701
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !701

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !702
  %11 = zext i32 %18 to i64, !dbg !702
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !702
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !703
  %13 = load %struct.stat** %12, align 8, !dbg !703
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !703
  %15 = load i64* %14, align 8, !dbg !703
  %16 = icmp eq i64 %15, 0, !dbg !703
  br i1 %16, label %bb3, label %__get_sym_file.exit, !dbg !703

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !700
  br label %bb8.i, !dbg !700

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !700
  br i1 %19, label %bb3.i, label %bb3, !dbg !700

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !702
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !298), !dbg !697
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !704
  br i1 %21, label %bb3, label %bb, !dbg !704

bb:                                               ; preds = %__get_sym_file.exit
  %22 = getelementptr inbounds %struct.stat* %13, i64 0, i32 3, !dbg !705
  %23 = load i32* %22, align 8, !dbg !705
  %24 = and i32 %23, 61440, !dbg !705
  %25 = icmp eq i32 %24, 16384, !dbg !705
  br i1 %25, label %bb1, label %bb2, !dbg !705

bb1:                                              ; preds = %bb
  store i64 0, i64* %14, align 8, !dbg !706
  br label %bb4, !dbg !707

bb2:                                              ; preds = %bb
  %26 = tail call i32* @__errno_location() nounwind readnone, !dbg !708
  store i32 20, i32* %26, align 4, !dbg !708
  br label %bb4, !dbg !709

bb3:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([17 x i8]* @.str1, i64 0, i64 0)) nounwind, !dbg !710
  %27 = tail call i32* @__errno_location() nounwind readnone, !dbg !711
  store i32 1, i32* %27, align 4, !dbg !711
  br label %bb4, !dbg !712

bb4:                                              ; preds = %bb3, %bb2, %bb1
  %.0 = phi i32 [ 0, %bb1 ], [ -1, %bb2 ], [ -1, %bb3 ]
  ret i32 %.0, !dbg !707
}

define i64 @readlink(i8* %path, i8* %buf, i64 %bufsize) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !303), !dbg !713
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !304), !dbg !713
  tail call void @llvm.dbg.value(metadata !{i64 %bufsize}, i64 0, metadata !305), !dbg !713
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !714
  %0 = load i8* %path, align 1, !dbg !716
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !716
  %1 = icmp eq i8 %0, 0, !dbg !717
  br i1 %1, label %bb12, label %bb.i, !dbg !717

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !717
  %3 = load i8* %2, align 1, !dbg !717
  %4 = icmp eq i8 %3, 0, !dbg !717
  br i1 %4, label %bb8.preheader.i, label %bb12, !dbg !717

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !718
  %6 = sext i8 %0 to i32, !dbg !719
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !719
  %8 = add nsw i32 %7, 65, !dbg !719
  %9 = icmp eq i32 %6, %8, !dbg !719
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !719

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !720
  %11 = zext i32 %18 to i64, !dbg !720
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !720
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !721
  %13 = load %struct.stat** %12, align 8, !dbg !721
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !721
  %15 = load i64* %14, align 8, !dbg !721
  %16 = icmp eq i64 %15, 0, !dbg !721
  br i1 %16, label %bb12, label %__get_sym_file.exit, !dbg !721

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !718
  br label %bb8.i, !dbg !718

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !718
  br i1 %19, label %bb3.i, label %bb12, !dbg !718

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !720
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !306), !dbg !715
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !722
  br i1 %21, label %bb12, label %bb, !dbg !722

bb:                                               ; preds = %__get_sym_file.exit
  %22 = getelementptr inbounds %struct.stat* %13, i64 0, i32 3, !dbg !723
  %23 = load i32* %22, align 8, !dbg !723
  %24 = and i32 %23, 61440, !dbg !723
  %25 = icmp eq i32 %24, 40960, !dbg !723
  br i1 %25, label %bb1, label %bb11, !dbg !723

bb1:                                              ; preds = %bb
  store i8 %0, i8* %buf, align 1, !dbg !724
  %26 = icmp ugt i64 %bufsize, 1, !dbg !725
  br i1 %26, label %bb3, label %bb9, !dbg !725

bb3:                                              ; preds = %bb1
  %27 = getelementptr inbounds i8* %buf, i64 1, !dbg !725
  store i8 46, i8* %27, align 1, !dbg !725
  %28 = icmp ugt i64 %bufsize, 2, !dbg !726
  br i1 %28, label %bb5, label %bb9, !dbg !726

bb5:                                              ; preds = %bb3
  %29 = getelementptr inbounds i8* %buf, i64 2, !dbg !726
  store i8 108, i8* %29, align 1, !dbg !726
  %30 = icmp ugt i64 %bufsize, 3, !dbg !727
  br i1 %30, label %bb7, label %bb9, !dbg !727

bb7:                                              ; preds = %bb5
  %31 = getelementptr inbounds i8* %buf, i64 3, !dbg !727
  store i8 110, i8* %31, align 1, !dbg !727
  %32 = icmp ugt i64 %bufsize, 4, !dbg !728
  br i1 %32, label %bb8, label %bb9, !dbg !728

bb8:                                              ; preds = %bb7
  %33 = getelementptr inbounds i8* %buf, i64 4, !dbg !728
  store i8 107, i8* %33, align 1, !dbg !728
  br label %bb9, !dbg !728

bb9:                                              ; preds = %bb3, %bb1, %bb5, %bb8, %bb7
  %34 = icmp ugt i64 %bufsize, 5, !dbg !729
  %min = select i1 %34, i64 5, i64 %bufsize, !dbg !729
  br label %bb15, !dbg !729

bb11:                                             ; preds = %bb
  %35 = tail call i32* @__errno_location() nounwind readnone, !dbg !730
  store i32 22, i32* %35, align 4, !dbg !730
  br label %bb15, !dbg !731

bb12:                                             ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  %36 = tail call i64 (i64, ...)* @syscall(i64 89, i8* %path, i8* %buf, i64 %bufsize) nounwind, !dbg !732
  %37 = trunc i64 %36 to i32, !dbg !732
  tail call void @llvm.dbg.value(metadata !{i32 %37}, i64 0, metadata !308), !dbg !732
  %38 = icmp eq i32 %37, -1, !dbg !733
  br i1 %38, label %bb13, label %bb14, !dbg !733

bb13:                                             ; preds = %bb12
  %39 = tail call i32* @__errno_location() nounwind readnone, !dbg !734
  %40 = tail call i32 @klee_get_errno() nounwind, !dbg !734
  store i32 %40, i32* %39, align 4, !dbg !734
  br label %bb14, !dbg !734

bb14:                                             ; preds = %bb13, %bb12
  %41 = sext i32 %37 to i64, !dbg !735
  br label %bb15, !dbg !735

bb15:                                             ; preds = %bb14, %bb11, %bb9
  %.0 = phi i64 [ %min, %bb9 ], [ -1, %bb11 ], [ %41, %bb14 ]
  ret i64 %.0, !dbg !729
}

declare i64 @syscall(i64, ...) nounwind

declare i32 @klee_get_errno()

define i32 @fsync(i32 %fd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !310), !dbg !736
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !737
  %0 = icmp ult i32 %fd, 32, !dbg !739
  br i1 %0, label %bb.i, label %bb, !dbg !739

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !740
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !740
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !741
  %3 = load i32* %2, align 4, !dbg !741
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !741
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !741

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !740
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !311), !dbg !738
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !742
  br i1 %6, label %bb, label %bb1, !dbg !742

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !743
  store i32 9, i32* %7, align 4, !dbg !743
  br label %bb6, !dbg !744

bb1:                                              ; preds = %__get_file.exit
  %8 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !745
  %9 = load %struct.exe_disk_file_t** %8, align 8, !dbg !745
  %10 = icmp eq %struct.exe_disk_file_t* %9, null, !dbg !745
  br i1 %10, label %bb3, label %bb6, !dbg !745

bb3:                                              ; preds = %bb1
  %11 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !746
  %12 = load i32* %11, align 8, !dbg !746
  %13 = tail call i64 (i64, ...)* @syscall(i64 74, i32 %12) nounwind, !dbg !746
  %14 = trunc i64 %13 to i32, !dbg !746
  tail call void @llvm.dbg.value(metadata !{i32 %14}, i64 0, metadata !313), !dbg !746
  %15 = icmp eq i32 %14, -1, !dbg !747
  br i1 %15, label %bb4, label %bb6, !dbg !747

bb4:                                              ; preds = %bb3
  %16 = tail call i32* @__errno_location() nounwind readnone, !dbg !748
  %17 = tail call i32 @klee_get_errno() nounwind, !dbg !748
  store i32 %17, i32* %16, align 4, !dbg !748
  br label %bb6, !dbg !748

bb6:                                              ; preds = %bb3, %bb4, %bb1, %bb
  %.0 = phi i32 [ -1, %bb ], [ 0, %bb1 ], [ -1, %bb4 ], [ %14, %bb3 ]
  ret i32 %.0, !dbg !744
}

define i32 @fstatfs(i32 %fd, %struct.statfs* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !315), !dbg !749
  tail call void @llvm.dbg.value(metadata !{%struct.statfs* %buf}, i64 0, metadata !316), !dbg !749
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !750
  %0 = icmp ult i32 %fd, 32, !dbg !752
  br i1 %0, label %bb.i, label %bb, !dbg !752

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !753
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !753
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !754
  %3 = load i32* %2, align 4, !dbg !754
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !754
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !754

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !753
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !317), !dbg !751
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !755
  br i1 %6, label %bb, label %bb1, !dbg !755

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !756
  store i32 9, i32* %7, align 4, !dbg !756
  br label %bb6, !dbg !757

bb1:                                              ; preds = %__get_file.exit
  %8 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !758
  %9 = load %struct.exe_disk_file_t** %8, align 8, !dbg !758
  %10 = icmp eq %struct.exe_disk_file_t* %9, null, !dbg !758
  br i1 %10, label %bb3, label %bb2, !dbg !758

bb2:                                              ; preds = %bb1
  tail call void @klee_warning(i8* getelementptr inbounds ([32 x i8]* @.str3, i64 0, i64 0)) nounwind, !dbg !759
  %11 = tail call i32* @__errno_location() nounwind readnone, !dbg !760
  store i32 9, i32* %11, align 4, !dbg !760
  br label %bb6, !dbg !761

bb3:                                              ; preds = %bb1
  %12 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !762
  %13 = load i32* %12, align 8, !dbg !762
  %14 = tail call i64 (i64, ...)* @syscall(i64 138, i32 %13, %struct.statfs* %buf) nounwind, !dbg !762
  %15 = trunc i64 %14 to i32, !dbg !762
  tail call void @llvm.dbg.value(metadata !{i32 %15}, i64 0, metadata !319), !dbg !762
  %16 = icmp eq i32 %15, -1, !dbg !763
  br i1 %16, label %bb4, label %bb6, !dbg !763

bb4:                                              ; preds = %bb3
  %17 = tail call i32* @__errno_location() nounwind readnone, !dbg !764
  %18 = tail call i32 @klee_get_errno() nounwind, !dbg !764
  store i32 %18, i32* %17, align 4, !dbg !764
  br label %bb6, !dbg !764

bb6:                                              ; preds = %bb3, %bb4, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ -1, %bb4 ], [ %15, %bb3 ]
  ret i32 %.0, !dbg !757
}

define i32 @__fd_ftruncate(i32 %fd, i64 %length) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !321), !dbg !765
  tail call void @llvm.dbg.value(metadata !{i64 %length}, i64 0, metadata !322), !dbg !765
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !766
  %0 = icmp ult i32 %fd, 32, !dbg !768
  br i1 %0, label %bb.i, label %__get_file.exit.thread, !dbg !768

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !769
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !769
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !770
  %3 = load i32* %2, align 4, !dbg !770
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !770
  br i1 %toBool.i, label %__get_file.exit.thread, label %__get_file.exit, !dbg !770

__get_file.exit.thread:                           ; preds = %bb.i, %entry
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %7}, i64 0, metadata !323), !dbg !767
  %5 = load i32* @n_calls.5292, align 4, !dbg !771
  %6 = add nsw i32 %5, 1, !dbg !771
  store i32 %6, i32* @n_calls.5292, align 4, !dbg !771
  br label %bb

__get_file.exit:                                  ; preds = %bb.i
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !769
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %7}, i64 0, metadata !323), !dbg !767
  %8 = load i32* @n_calls.5292, align 4, !dbg !771
  %9 = add nsw i32 %8, 1, !dbg !771
  store i32 %9, i32* @n_calls.5292, align 4, !dbg !771
  %10 = icmp eq %struct.exe_file_t* %7, null, !dbg !772
  br i1 %10, label %bb, label %bb1, !dbg !772

bb:                                               ; preds = %__get_file.exit.thread, %__get_file.exit
  %11 = tail call i32* @__errno_location() nounwind readnone, !dbg !773
  store i32 9, i32* %11, align 4, !dbg !773
  br label %bb9, !dbg !774

bb1:                                              ; preds = %__get_file.exit
  %12 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !775
  %13 = icmp eq i32 %12, 0, !dbg !775
  br i1 %13, label %bb4, label %bb2, !dbg !775

bb2:                                              ; preds = %bb1
  %14 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 9), align 8, !dbg !775
  %15 = load i32* %14, align 4, !dbg !775
  %16 = icmp eq i32 %15, %9, !dbg !775
  br i1 %16, label %bb3, label %bb4, !dbg !775

bb3:                                              ; preds = %bb2
  %17 = add i32 %12, -1, !dbg !776
  store i32 %17, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !776
  %18 = tail call i32* @__errno_location() nounwind readnone, !dbg !777
  store i32 5, i32* %18, align 4, !dbg !777
  br label %bb9, !dbg !778

bb4:                                              ; preds = %bb1, %bb2
  %19 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !779
  %20 = load %struct.exe_disk_file_t** %19, align 8, !dbg !779
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !779
  br i1 %21, label %bb6, label %bb5, !dbg !779

bb5:                                              ; preds = %bb4
  tail call void @klee_warning(i8* getelementptr inbounds ([30 x i8]* @.str4, i64 0, i64 0)) nounwind, !dbg !780
  %22 = tail call i32* @__errno_location() nounwind readnone, !dbg !781
  store i32 5, i32* %22, align 4, !dbg !781
  br label %bb9, !dbg !782

bb6:                                              ; preds = %bb4
  %23 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !783
  %24 = load i32* %23, align 8, !dbg !783
  %25 = tail call i64 (i64, ...)* @syscall(i64 77, i32 %24, i64 %length) nounwind, !dbg !783
  %26 = trunc i64 %25 to i32, !dbg !783
  tail call void @llvm.dbg.value(metadata !{i32 %26}, i64 0, metadata !325), !dbg !783
  %27 = icmp eq i32 %26, -1, !dbg !784
  br i1 %27, label %bb7, label %bb9, !dbg !784

bb7:                                              ; preds = %bb6
  %28 = tail call i32* @__errno_location() nounwind readnone, !dbg !785
  %29 = tail call i32 @klee_get_errno() nounwind, !dbg !785
  store i32 %29, i32* %28, align 4, !dbg !785
  br label %bb9, !dbg !785

bb9:                                              ; preds = %bb6, %bb7, %bb5, %bb3, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb3 ], [ -1, %bb5 ], [ -1, %bb7 ], [ %26, %bb6 ]
  ret i32 %.0, !dbg !774
}

define i32 @fchown(i32 %fd, i32 %owner, i32 %group) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !334), !dbg !786
  tail call void @llvm.dbg.value(metadata !{i32 %owner}, i64 0, metadata !335), !dbg !786
  tail call void @llvm.dbg.value(metadata !{i32 %group}, i64 0, metadata !336), !dbg !786
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !787
  %0 = icmp ult i32 %fd, 32, !dbg !789
  br i1 %0, label %bb.i, label %bb, !dbg !789

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !790
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !790
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !791
  %3 = load i32* %2, align 4, !dbg !791
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !791
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !791

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !790
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !337), !dbg !788
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !792
  br i1 %6, label %bb, label %bb1, !dbg !792

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !793
  store i32 9, i32* %7, align 4, !dbg !793
  br label %bb6, !dbg !794

bb1:                                              ; preds = %__get_file.exit
  %8 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !795
  %9 = load %struct.exe_disk_file_t** %8, align 8, !dbg !795
  %10 = icmp eq %struct.exe_disk_file_t* %9, null, !dbg !795
  br i1 %10, label %bb3, label %bb2, !dbg !795

bb2:                                              ; preds = %bb1
  tail call void @llvm.dbg.value(metadata !796, i64 0, metadata !300) nounwind, !dbg !797
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !301) nounwind, !dbg !797
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !302) nounwind, !dbg !797
  tail call void @klee_warning(i8* getelementptr inbounds ([32 x i8]* @.str2, i64 0, i64 0)) nounwind, !dbg !799
  %11 = tail call i32* @__errno_location() nounwind readnone, !dbg !801
  store i32 1, i32* %11, align 4, !dbg !801
  br label %bb6, !dbg !798

bb3:                                              ; preds = %bb1
  %12 = tail call i64 (i64, ...)* @syscall(i64 93, i32 %fd, i32 %owner, i32 %group) nounwind, !dbg !802
  %13 = trunc i64 %12 to i32, !dbg !802
  tail call void @llvm.dbg.value(metadata !{i32 %13}, i64 0, metadata !339), !dbg !802
  %14 = icmp eq i32 %13, -1, !dbg !803
  br i1 %14, label %bb4, label %bb6, !dbg !803

bb4:                                              ; preds = %bb3
  %15 = tail call i32* @__errno_location() nounwind readnone, !dbg !804
  %16 = tail call i32 @klee_get_errno() nounwind, !dbg !804
  store i32 %16, i32* %15, align 4, !dbg !804
  br label %bb6, !dbg !804

bb6:                                              ; preds = %bb3, %bb4, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ -1, %bb4 ], [ %13, %bb3 ]
  ret i32 %.0, !dbg !794
}

define i32 @fchdir(i32 %fd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !341), !dbg !805
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !806
  %0 = icmp ult i32 %fd, 32, !dbg !808
  br i1 %0, label %bb.i, label %bb, !dbg !808

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !809
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !809
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !810
  %3 = load i32* %2, align 4, !dbg !810
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !810
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !810

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !809
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !342), !dbg !807
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !811
  br i1 %6, label %bb, label %bb1, !dbg !811

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !812
  store i32 9, i32* %7, align 4, !dbg !812
  br label %bb6, !dbg !813

bb1:                                              ; preds = %__get_file.exit
  %8 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !814
  %9 = load %struct.exe_disk_file_t** %8, align 8, !dbg !814
  %10 = icmp eq %struct.exe_disk_file_t* %9, null, !dbg !814
  br i1 %10, label %bb3, label %bb2, !dbg !814

bb2:                                              ; preds = %bb1
  tail call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0)) nounwind, !dbg !815
  %11 = tail call i32* @__errno_location() nounwind readnone, !dbg !816
  store i32 2, i32* %11, align 4, !dbg !816
  br label %bb6, !dbg !817

bb3:                                              ; preds = %bb1
  %12 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !818
  %13 = load i32* %12, align 8, !dbg !818
  %14 = tail call i64 (i64, ...)* @syscall(i64 81, i32 %13) nounwind, !dbg !818
  %15 = trunc i64 %14 to i32, !dbg !818
  tail call void @llvm.dbg.value(metadata !{i32 %15}, i64 0, metadata !344), !dbg !818
  %16 = icmp eq i32 %15, -1, !dbg !819
  br i1 %16, label %bb4, label %bb6, !dbg !819

bb4:                                              ; preds = %bb3
  %17 = tail call i32* @__errno_location() nounwind readnone, !dbg !820
  %18 = tail call i32 @klee_get_errno() nounwind, !dbg !820
  store i32 %18, i32* %17, align 4, !dbg !820
  br label %bb6, !dbg !820

bb6:                                              ; preds = %bb3, %bb4, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ -1, %bb4 ], [ %15, %bb3 ]
  ret i32 %.0, !dbg !813
}

declare i64 @klee_get_valuel(i64)

declare void @klee_assume(i64)

define i8* @getcwd(i8* %buf, i64 %size) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !352), !dbg !821
  tail call void @llvm.dbg.value(metadata !{i64 %size}, i64 0, metadata !353), !dbg !821
  %0 = load i32* @n_calls.5868, align 4, !dbg !822
  %1 = add nsw i32 %0, 1, !dbg !822
  store i32 %1, i32* @n_calls.5868, align 4, !dbg !822
  %2 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !823
  %3 = icmp eq i32 %2, 0, !dbg !823
  br i1 %3, label %bb2, label %bb, !dbg !823

bb:                                               ; preds = %entry
  %4 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 10), align 8, !dbg !823
  %5 = load i32* %4, align 4, !dbg !823
  %6 = icmp eq i32 %5, %1, !dbg !823
  br i1 %6, label %bb1, label %bb2, !dbg !823

bb1:                                              ; preds = %bb
  %7 = add i32 %2, -1, !dbg !824
  store i32 %7, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !824
  %8 = tail call i32* @__errno_location() nounwind readnone, !dbg !825
  store i32 34, i32* %8, align 4, !dbg !825
  br label %bb9, !dbg !826

bb2:                                              ; preds = %entry, %bb
  %9 = icmp eq i8* %buf, null, !dbg !827
  br i1 %9, label %bb3, label %bb6, !dbg !827

bb3:                                              ; preds = %bb2
  %10 = icmp eq i64 %size, 0, !dbg !828
  tail call void @llvm.dbg.value(metadata !829, i64 0, metadata !353), !dbg !830
  %size_addr.0 = select i1 %10, i64 1024, i64 %size
  %11 = tail call noalias i8* @malloc(i64 %size_addr.0) nounwind, !dbg !831
  tail call void @llvm.dbg.value(metadata !{i8* %11}, i64 0, metadata !352), !dbg !831
  br label %bb6, !dbg !831

bb6:                                              ; preds = %bb3, %bb2
  %size_addr.1 = phi i64 [ %size_addr.0, %bb3 ], [ %size, %bb2 ]
  %buf_addr.0 = phi i8* [ %11, %bb3 ], [ %buf, %bb2 ]
  tail call void @llvm.dbg.value(metadata !{i8* %buf_addr.0}, i64 0, metadata !346) nounwind, !dbg !832
  %12 = ptrtoint i8* %buf_addr.0 to i64, !dbg !834
  %13 = tail call i64 @klee_get_valuel(i64 %12) nounwind, !dbg !834
  %14 = inttoptr i64 %13 to i8*, !dbg !834
  tail call void @llvm.dbg.value(metadata !{i8* %14}, i64 0, metadata !347) nounwind, !dbg !834
  %15 = icmp eq i8* %14, %buf_addr.0, !dbg !835
  %16 = zext i1 %15 to i64, !dbg !835
  tail call void @klee_assume(i64 %16) nounwind, !dbg !835
  tail call void @llvm.dbg.value(metadata !{i8* %14}, i64 0, metadata !352), !dbg !833
  tail call void @llvm.dbg.value(metadata !{i64 %size_addr.1}, i64 0, metadata !349) nounwind, !dbg !836
  %17 = tail call i64 @klee_get_valuel(i64 %size_addr.1) nounwind, !dbg !838
  tail call void @llvm.dbg.value(metadata !{i64 %17}, i64 0, metadata !350) nounwind, !dbg !838
  %18 = icmp eq i64 %17, %size_addr.1, !dbg !839
  %19 = zext i1 %18 to i64, !dbg !839
  tail call void @klee_assume(i64 %19) nounwind, !dbg !839
  tail call void @llvm.dbg.value(metadata !{i64 %17}, i64 0, metadata !353), !dbg !837
  tail call void @klee_check_memory_access(i8* %14, i64 %17) nounwind, !dbg !840
  %20 = tail call i64 (i64, ...)* @syscall(i64 79, i8* %14, i64 %17) nounwind, !dbg !841
  %21 = trunc i64 %20 to i32, !dbg !841
  tail call void @llvm.dbg.value(metadata !{i32 %21}, i64 0, metadata !354), !dbg !841
  %22 = icmp eq i32 %21, -1, !dbg !842
  br i1 %22, label %bb7, label %bb9, !dbg !842

bb7:                                              ; preds = %bb6
  %23 = tail call i32* @__errno_location() nounwind readnone, !dbg !843
  %24 = tail call i32 @klee_get_errno() nounwind, !dbg !843
  store i32 %24, i32* %23, align 4, !dbg !843
  br label %bb9, !dbg !844

bb9:                                              ; preds = %bb6, %bb7, %bb1
  %.0 = phi i8* [ null, %bb1 ], [ null, %bb7 ], [ %14, %bb6 ]
  ret i8* %.0, !dbg !826
}

declare noalias i8* @malloc(i64) nounwind

declare void @klee_check_memory_access(i8*, i64)

define i32 @__fd_statfs(i8* %path, %struct.statfs* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !364), !dbg !845
  tail call void @llvm.dbg.value(metadata !{%struct.statfs* %buf}, i64 0, metadata !365), !dbg !845
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !846
  %0 = load i8* %path, align 1, !dbg !848
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !848
  %1 = icmp eq i8 %0, 0, !dbg !849
  br i1 %1, label %bb1, label %bb.i, !dbg !849

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !849
  %3 = load i8* %2, align 1, !dbg !849
  %4 = icmp eq i8 %3, 0, !dbg !849
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !849

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !850
  %6 = sext i8 %0 to i32, !dbg !851
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !851
  %8 = add nsw i32 %7, 65, !dbg !851
  %9 = icmp eq i32 %6, %8, !dbg !851
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !851

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !852
  %11 = zext i32 %18 to i64, !dbg !852
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !852
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !853
  %13 = load %struct.stat** %12, align 8, !dbg !853
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !853
  %15 = load i64* %14, align 8, !dbg !853
  %16 = icmp eq i64 %15, 0, !dbg !853
  br i1 %16, label %bb1, label %__get_sym_file.exit, !dbg !853

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !850
  br label %bb8.i, !dbg !850

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !850
  br i1 %19, label %bb3.i, label %bb1, !dbg !850

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !852
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !366), !dbg !847
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !854
  br i1 %21, label %bb1, label %bb, !dbg !854

bb:                                               ; preds = %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0)) nounwind, !dbg !855
  %22 = tail call i32* @__errno_location() nounwind readnone, !dbg !856
  store i32 2, i32* %22, align 4, !dbg !856
  br label %bb4, !dbg !857

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !858
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !860
  %23 = ptrtoint i8* %path to i64, !dbg !862
  %24 = tail call i64 @klee_get_valuel(i64 %23) nounwind, !dbg !862
  %25 = inttoptr i64 %24 to i8*, !dbg !862
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !347) nounwind, !dbg !862
  %26 = icmp eq i8* %25, %path, !dbg !863
  %27 = zext i1 %26 to i64, !dbg !863
  tail call void @klee_assume(i64 %27) nounwind, !dbg !863
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !357) nounwind, !dbg !861
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !864
  br label %bb.i6, !dbg !864

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %25, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %28 = phi i32 [ 0, %bb1 ], [ %40, %bb6.i8 ]
  %tmp.i = add i32 %28, -1
  %29 = load i8* %sc.0.i, align 1, !dbg !865
  %30 = and i32 %tmp.i, %28, !dbg !866
  %31 = icmp eq i32 %30, 0, !dbg !866
  br i1 %31, label %bb1.i, label %bb5.i, !dbg !866

bb1.i:                                            ; preds = %bb.i6
  switch i8 %29, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %29}, i64 0, metadata !360) nounwind, !dbg !865
  store i8 0, i8* %sc.0.i, align 1, !dbg !867
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !867
  br label %__concretize_string.exit, !dbg !867

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !868
  %32 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !868
  br label %bb6.i8, !dbg !868

bb5.i:                                            ; preds = %bb.i6
  %33 = sext i8 %29 to i64, !dbg !869
  %34 = tail call i64 @klee_get_valuel(i64 %33) nounwind, !dbg !869
  %35 = trunc i64 %34 to i8, !dbg !869
  %36 = icmp eq i8 %35, %29, !dbg !870
  %37 = zext i1 %36 to i64, !dbg !870
  tail call void @klee_assume(i64 %37) nounwind, !dbg !870
  store i8 %35, i8* %sc.0.i, align 1, !dbg !871
  %38 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !871
  %39 = icmp eq i8 %35, 0, !dbg !872
  br i1 %39, label %__concretize_string.exit, label %bb6.i8, !dbg !872

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %32, %bb4.i7 ], [ %38, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %40 = add i32 %28, 1, !dbg !864
  br label %bb.i6, !dbg !864

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %41 = tail call i64 (i64, ...)* @syscall(i64 137, i8* %path, %struct.statfs* %buf) nounwind, !dbg !859
  %42 = trunc i64 %41 to i32, !dbg !859
  tail call void @llvm.dbg.value(metadata !{i32 %42}, i64 0, metadata !368), !dbg !859
  %43 = icmp eq i32 %42, -1, !dbg !873
  br i1 %43, label %bb2, label %bb4, !dbg !873

bb2:                                              ; preds = %__concretize_string.exit
  %44 = tail call i32* @__errno_location() nounwind readnone, !dbg !874
  %45 = tail call i32 @klee_get_errno() nounwind, !dbg !874
  store i32 %45, i32* %44, align 4, !dbg !874
  br label %bb4, !dbg !874

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ %42, %__concretize_string.exit ]
  ret i32 %.0, !dbg !857
}

define i32 @lchown(i8* %path, i32 %owner, i32 %group) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !370), !dbg !875
  tail call void @llvm.dbg.value(metadata !{i32 %owner}, i64 0, metadata !371), !dbg !875
  tail call void @llvm.dbg.value(metadata !{i32 %group}, i64 0, metadata !372), !dbg !875
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !876
  %0 = load i8* %path, align 1, !dbg !878
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !878
  %1 = icmp eq i8 %0, 0, !dbg !879
  br i1 %1, label %bb1, label %bb.i, !dbg !879

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !879
  %3 = load i8* %2, align 1, !dbg !879
  %4 = icmp eq i8 %3, 0, !dbg !879
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !879

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !880
  %6 = sext i8 %0 to i32, !dbg !881
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !881
  %8 = add nsw i32 %7, 65, !dbg !881
  %9 = icmp eq i32 %6, %8, !dbg !881
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !881

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !882
  %11 = zext i32 %18 to i64, !dbg !882
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !882
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !883
  %13 = load %struct.stat** %12, align 8, !dbg !883
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !883
  %15 = load i64* %14, align 8, !dbg !883
  %16 = icmp eq i64 %15, 0, !dbg !883
  br i1 %16, label %bb1, label %__get_sym_file.exit, !dbg !883

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !880
  br label %bb8.i, !dbg !880

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !880
  br i1 %19, label %bb3.i, label %bb1, !dbg !880

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !882
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !373), !dbg !877
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !884
  br i1 %21, label %bb1, label %bb, !dbg !884

bb:                                               ; preds = %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !796, i64 0, metadata !300) nounwind, !dbg !885
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !301) nounwind, !dbg !885
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !302) nounwind, !dbg !885
  tail call void @klee_warning(i8* getelementptr inbounds ([32 x i8]* @.str2, i64 0, i64 0)) nounwind, !dbg !887
  %22 = tail call i32* @__errno_location() nounwind readnone, !dbg !888
  store i32 1, i32* %22, align 4, !dbg !888
  br label %bb4, !dbg !886

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !889
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !891
  %23 = ptrtoint i8* %path to i64, !dbg !893
  %24 = tail call i64 @klee_get_valuel(i64 %23) nounwind, !dbg !893
  %25 = inttoptr i64 %24 to i8*, !dbg !893
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !347) nounwind, !dbg !893
  %26 = icmp eq i8* %25, %path, !dbg !894
  %27 = zext i1 %26 to i64, !dbg !894
  tail call void @klee_assume(i64 %27) nounwind, !dbg !894
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !357) nounwind, !dbg !892
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !895
  br label %bb.i6, !dbg !895

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %25, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %28 = phi i32 [ 0, %bb1 ], [ %40, %bb6.i8 ]
  %tmp.i = add i32 %28, -1
  %29 = load i8* %sc.0.i, align 1, !dbg !896
  %30 = and i32 %tmp.i, %28, !dbg !897
  %31 = icmp eq i32 %30, 0, !dbg !897
  br i1 %31, label %bb1.i, label %bb5.i, !dbg !897

bb1.i:                                            ; preds = %bb.i6
  switch i8 %29, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %29}, i64 0, metadata !360) nounwind, !dbg !896
  store i8 0, i8* %sc.0.i, align 1, !dbg !898
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !898
  br label %__concretize_string.exit, !dbg !898

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !899
  %32 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !899
  br label %bb6.i8, !dbg !899

bb5.i:                                            ; preds = %bb.i6
  %33 = sext i8 %29 to i64, !dbg !900
  %34 = tail call i64 @klee_get_valuel(i64 %33) nounwind, !dbg !900
  %35 = trunc i64 %34 to i8, !dbg !900
  %36 = icmp eq i8 %35, %29, !dbg !901
  %37 = zext i1 %36 to i64, !dbg !901
  tail call void @klee_assume(i64 %37) nounwind, !dbg !901
  store i8 %35, i8* %sc.0.i, align 1, !dbg !902
  %38 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !902
  %39 = icmp eq i8 %35, 0, !dbg !903
  br i1 %39, label %__concretize_string.exit, label %bb6.i8, !dbg !903

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %32, %bb4.i7 ], [ %38, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %40 = add i32 %28, 1, !dbg !895
  br label %bb.i6, !dbg !895

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %41 = tail call i64 (i64, ...)* @syscall(i64 92, i8* %path, i32 %owner, i32 %group) nounwind, !dbg !890
  %42 = trunc i64 %41 to i32, !dbg !890
  tail call void @llvm.dbg.value(metadata !{i32 %42}, i64 0, metadata !375), !dbg !890
  %43 = icmp eq i32 %42, -1, !dbg !904
  br i1 %43, label %bb2, label %bb4, !dbg !904

bb2:                                              ; preds = %__concretize_string.exit
  %44 = tail call i32* @__errno_location() nounwind readnone, !dbg !905
  %45 = tail call i32 @klee_get_errno() nounwind, !dbg !905
  store i32 %45, i32* %44, align 4, !dbg !905
  br label %bb4, !dbg !905

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ %42, %__concretize_string.exit ]
  ret i32 %.0, !dbg !886
}

define i32 @chown(i8* %path, i32 %owner, i32 %group) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !377), !dbg !906
  tail call void @llvm.dbg.value(metadata !{i32 %owner}, i64 0, metadata !378), !dbg !906
  tail call void @llvm.dbg.value(metadata !{i32 %group}, i64 0, metadata !379), !dbg !906
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !907
  %0 = load i8* %path, align 1, !dbg !909
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !909
  %1 = icmp eq i8 %0, 0, !dbg !910
  br i1 %1, label %bb1, label %bb.i, !dbg !910

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !910
  %3 = load i8* %2, align 1, !dbg !910
  %4 = icmp eq i8 %3, 0, !dbg !910
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !910

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !911
  %6 = sext i8 %0 to i32, !dbg !912
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !912
  %8 = add nsw i32 %7, 65, !dbg !912
  %9 = icmp eq i32 %6, %8, !dbg !912
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !912

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !913
  %11 = zext i32 %18 to i64, !dbg !913
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !913
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !914
  %13 = load %struct.stat** %12, align 8, !dbg !914
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !914
  %15 = load i64* %14, align 8, !dbg !914
  %16 = icmp eq i64 %15, 0, !dbg !914
  br i1 %16, label %bb1, label %__get_sym_file.exit, !dbg !914

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !911
  br label %bb8.i, !dbg !911

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !911
  br i1 %19, label %bb3.i, label %bb1, !dbg !911

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !913
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !380), !dbg !908
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !915
  br i1 %21, label %bb1, label %bb, !dbg !915

bb:                                               ; preds = %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !796, i64 0, metadata !300) nounwind, !dbg !916
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !301) nounwind, !dbg !916
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !302) nounwind, !dbg !916
  tail call void @klee_warning(i8* getelementptr inbounds ([32 x i8]* @.str2, i64 0, i64 0)) nounwind, !dbg !918
  %22 = tail call i32* @__errno_location() nounwind readnone, !dbg !919
  store i32 1, i32* %22, align 4, !dbg !919
  br label %bb4, !dbg !917

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !920
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !922
  %23 = ptrtoint i8* %path to i64, !dbg !924
  %24 = tail call i64 @klee_get_valuel(i64 %23) nounwind, !dbg !924
  %25 = inttoptr i64 %24 to i8*, !dbg !924
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !347) nounwind, !dbg !924
  %26 = icmp eq i8* %25, %path, !dbg !925
  %27 = zext i1 %26 to i64, !dbg !925
  tail call void @klee_assume(i64 %27) nounwind, !dbg !925
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !357) nounwind, !dbg !923
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !926
  br label %bb.i6, !dbg !926

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %25, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %28 = phi i32 [ 0, %bb1 ], [ %40, %bb6.i8 ]
  %tmp.i = add i32 %28, -1
  %29 = load i8* %sc.0.i, align 1, !dbg !927
  %30 = and i32 %tmp.i, %28, !dbg !928
  %31 = icmp eq i32 %30, 0, !dbg !928
  br i1 %31, label %bb1.i, label %bb5.i, !dbg !928

bb1.i:                                            ; preds = %bb.i6
  switch i8 %29, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %29}, i64 0, metadata !360) nounwind, !dbg !927
  store i8 0, i8* %sc.0.i, align 1, !dbg !929
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !929
  br label %__concretize_string.exit, !dbg !929

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !930
  %32 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !930
  br label %bb6.i8, !dbg !930

bb5.i:                                            ; preds = %bb.i6
  %33 = sext i8 %29 to i64, !dbg !931
  %34 = tail call i64 @klee_get_valuel(i64 %33) nounwind, !dbg !931
  %35 = trunc i64 %34 to i8, !dbg !931
  %36 = icmp eq i8 %35, %29, !dbg !932
  %37 = zext i1 %36 to i64, !dbg !932
  tail call void @klee_assume(i64 %37) nounwind, !dbg !932
  store i8 %35, i8* %sc.0.i, align 1, !dbg !933
  %38 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !933
  %39 = icmp eq i8 %35, 0, !dbg !934
  br i1 %39, label %__concretize_string.exit, label %bb6.i8, !dbg !934

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %32, %bb4.i7 ], [ %38, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %40 = add i32 %28, 1, !dbg !926
  br label %bb.i6, !dbg !926

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %41 = tail call i64 (i64, ...)* @syscall(i64 92, i8* %path, i32 %owner, i32 %group) nounwind, !dbg !921
  %42 = trunc i64 %41 to i32, !dbg !921
  tail call void @llvm.dbg.value(metadata !{i32 %42}, i64 0, metadata !382), !dbg !921
  %43 = icmp eq i32 %42, -1, !dbg !935
  br i1 %43, label %bb2, label %bb4, !dbg !935

bb2:                                              ; preds = %__concretize_string.exit
  %44 = tail call i32* @__errno_location() nounwind readnone, !dbg !936
  %45 = tail call i32 @klee_get_errno() nounwind, !dbg !936
  store i32 %45, i32* %44, align 4, !dbg !936
  br label %bb4, !dbg !936

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ %42, %__concretize_string.exit ]
  ret i32 %.0, !dbg !917
}

define i32 @chdir(i8* %path) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !384), !dbg !937
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !938
  %0 = load i8* %path, align 1, !dbg !940
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !940
  %1 = icmp eq i8 %0, 0, !dbg !941
  br i1 %1, label %bb1, label %bb.i, !dbg !941

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !941
  %3 = load i8* %2, align 1, !dbg !941
  %4 = icmp eq i8 %3, 0, !dbg !941
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !941

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !942
  %6 = sext i8 %0 to i32, !dbg !943
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !943
  %8 = add nsw i32 %7, 65, !dbg !943
  %9 = icmp eq i32 %6, %8, !dbg !943
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !943

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !944
  %11 = zext i32 %18 to i64, !dbg !944
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !944
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !945
  %13 = load %struct.stat** %12, align 8, !dbg !945
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !945
  %15 = load i64* %14, align 8, !dbg !945
  %16 = icmp eq i64 %15, 0, !dbg !945
  br i1 %16, label %bb1, label %__get_sym_file.exit, !dbg !945

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !942
  br label %bb8.i, !dbg !942

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !942
  br i1 %19, label %bb3.i, label %bb1, !dbg !942

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !944
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !385), !dbg !939
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !946
  br i1 %21, label %bb1, label %bb, !dbg !946

bb:                                               ; preds = %__get_sym_file.exit
  tail call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str5, i64 0, i64 0)) nounwind, !dbg !947
  %22 = tail call i32* @__errno_location() nounwind readnone, !dbg !948
  store i32 2, i32* %22, align 4, !dbg !948
  br label %bb4, !dbg !949

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !950
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !952
  %23 = ptrtoint i8* %path to i64, !dbg !954
  %24 = tail call i64 @klee_get_valuel(i64 %23) nounwind, !dbg !954
  %25 = inttoptr i64 %24 to i8*, !dbg !954
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !347) nounwind, !dbg !954
  %26 = icmp eq i8* %25, %path, !dbg !955
  %27 = zext i1 %26 to i64, !dbg !955
  tail call void @klee_assume(i64 %27) nounwind, !dbg !955
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !357) nounwind, !dbg !953
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !956
  br label %bb.i6, !dbg !956

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %25, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %28 = phi i32 [ 0, %bb1 ], [ %40, %bb6.i8 ]
  %tmp.i = add i32 %28, -1
  %29 = load i8* %sc.0.i, align 1, !dbg !957
  %30 = and i32 %tmp.i, %28, !dbg !958
  %31 = icmp eq i32 %30, 0, !dbg !958
  br i1 %31, label %bb1.i, label %bb5.i, !dbg !958

bb1.i:                                            ; preds = %bb.i6
  switch i8 %29, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %29}, i64 0, metadata !360) nounwind, !dbg !957
  store i8 0, i8* %sc.0.i, align 1, !dbg !959
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !959
  br label %__concretize_string.exit, !dbg !959

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !960
  %32 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !960
  br label %bb6.i8, !dbg !960

bb5.i:                                            ; preds = %bb.i6
  %33 = sext i8 %29 to i64, !dbg !961
  %34 = tail call i64 @klee_get_valuel(i64 %33) nounwind, !dbg !961
  %35 = trunc i64 %34 to i8, !dbg !961
  %36 = icmp eq i8 %35, %29, !dbg !962
  %37 = zext i1 %36 to i64, !dbg !962
  tail call void @klee_assume(i64 %37) nounwind, !dbg !962
  store i8 %35, i8* %sc.0.i, align 1, !dbg !963
  %38 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !963
  %39 = icmp eq i8 %35, 0, !dbg !964
  br i1 %39, label %__concretize_string.exit, label %bb6.i8, !dbg !964

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %32, %bb4.i7 ], [ %38, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %40 = add i32 %28, 1, !dbg !956
  br label %bb.i6, !dbg !956

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %41 = tail call i64 (i64, ...)* @syscall(i64 80, i8* %path) nounwind, !dbg !951
  %42 = trunc i64 %41 to i32, !dbg !951
  tail call void @llvm.dbg.value(metadata !{i32 %42}, i64 0, metadata !387), !dbg !951
  %43 = icmp eq i32 %42, -1, !dbg !965
  br i1 %43, label %bb2, label %bb4, !dbg !965

bb2:                                              ; preds = %__concretize_string.exit
  %44 = tail call i32* @__errno_location() nounwind readnone, !dbg !966
  %45 = tail call i32 @klee_get_errno() nounwind, !dbg !966
  store i32 %45, i32* %44, align 4, !dbg !966
  br label %bb4, !dbg !966

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ %42, %__concretize_string.exit ]
  ret i32 %.0, !dbg !949
}

define i32 @utimes(i8* %path, %struct.timespec* %times) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !389), !dbg !967
  tail call void @llvm.dbg.value(metadata !{%struct.timespec* %times}, i64 0, metadata !390), !dbg !967
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !968
  %0 = load i8* %path, align 1, !dbg !970
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !970
  %1 = icmp eq i8 %0, 0, !dbg !971
  br i1 %1, label %bb1, label %bb.i, !dbg !971

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !971
  %3 = load i8* %2, align 1, !dbg !971
  %4 = icmp eq i8 %3, 0, !dbg !971
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !971

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !972
  %6 = sext i8 %0 to i32, !dbg !973
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !973
  %8 = add nsw i32 %7, 65, !dbg !973
  %9 = icmp eq i32 %6, %8, !dbg !973
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !973

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !974
  %11 = zext i32 %18 to i64, !dbg !974
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !974
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !975
  %13 = load %struct.stat** %12, align 8, !dbg !975
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !975
  %15 = load i64* %14, align 8, !dbg !975
  %16 = icmp eq i64 %15, 0, !dbg !975
  br i1 %16, label %bb1, label %__get_sym_file.exit, !dbg !975

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !972
  br label %bb8.i, !dbg !972

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !972
  br i1 %19, label %bb3.i, label %bb1, !dbg !972

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !974
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !391), !dbg !969
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !976
  br i1 %21, label %bb1, label %bb, !dbg !976

bb:                                               ; preds = %__get_sym_file.exit
  %22 = getelementptr inbounds %struct.timespec* %times, i64 0, i32 0, !dbg !977
  %23 = load i64* %22, align 8, !dbg !977
  %24 = getelementptr inbounds %struct.stat* %13, i64 0, i32 11, i32 0, !dbg !977
  store i64 %23, i64* %24, align 8, !dbg !977
  %25 = load %struct.stat** %12, align 8, !dbg !978
  %26 = getelementptr inbounds %struct.timespec* %times, i64 1, i32 0, !dbg !978
  %27 = load i64* %26, align 8, !dbg !978
  %28 = getelementptr inbounds %struct.stat* %25, i64 0, i32 12, i32 0, !dbg !978
  store i64 %27, i64* %28, align 8, !dbg !978
  %29 = load %struct.stat** %12, align 8, !dbg !979
  %30 = load i64* %22, align 8, !dbg !979
  %31 = mul nsw i64 %30, 1000000000, !dbg !979
  %32 = getelementptr inbounds %struct.stat* %29, i64 0, i32 11, i32 1, !dbg !979
  store i64 %31, i64* %32, align 8, !dbg !979
  %33 = load %struct.stat** %12, align 8, !dbg !980
  %34 = load i64* %26, align 8, !dbg !980
  %35 = mul nsw i64 %34, 1000000000, !dbg !980
  %36 = getelementptr inbounds %struct.stat* %33, i64 0, i32 12, i32 1, !dbg !980
  store i64 %35, i64* %36, align 8, !dbg !980
  br label %bb4, !dbg !981

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !982
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !984
  %37 = ptrtoint i8* %path to i64, !dbg !986
  %38 = tail call i64 @klee_get_valuel(i64 %37) nounwind, !dbg !986
  %39 = inttoptr i64 %38 to i8*, !dbg !986
  tail call void @llvm.dbg.value(metadata !{i8* %39}, i64 0, metadata !347) nounwind, !dbg !986
  %40 = icmp eq i8* %39, %path, !dbg !987
  %41 = zext i1 %40 to i64, !dbg !987
  tail call void @klee_assume(i64 %41) nounwind, !dbg !987
  tail call void @llvm.dbg.value(metadata !{i8* %39}, i64 0, metadata !357) nounwind, !dbg !985
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !988
  br label %bb.i6, !dbg !988

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %39, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %42 = phi i32 [ 0, %bb1 ], [ %54, %bb6.i8 ]
  %tmp.i = add i32 %42, -1
  %43 = load i8* %sc.0.i, align 1, !dbg !989
  %44 = and i32 %tmp.i, %42, !dbg !990
  %45 = icmp eq i32 %44, 0, !dbg !990
  br i1 %45, label %bb1.i, label %bb5.i, !dbg !990

bb1.i:                                            ; preds = %bb.i6
  switch i8 %43, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %43}, i64 0, metadata !360) nounwind, !dbg !989
  store i8 0, i8* %sc.0.i, align 1, !dbg !991
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !991
  br label %__concretize_string.exit, !dbg !991

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !992
  %46 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !992
  br label %bb6.i8, !dbg !992

bb5.i:                                            ; preds = %bb.i6
  %47 = sext i8 %43 to i64, !dbg !993
  %48 = tail call i64 @klee_get_valuel(i64 %47) nounwind, !dbg !993
  %49 = trunc i64 %48 to i8, !dbg !993
  %50 = icmp eq i8 %49, %43, !dbg !994
  %51 = zext i1 %50 to i64, !dbg !994
  tail call void @klee_assume(i64 %51) nounwind, !dbg !994
  store i8 %49, i8* %sc.0.i, align 1, !dbg !995
  %52 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !995
  %53 = icmp eq i8 %49, 0, !dbg !996
  br i1 %53, label %__concretize_string.exit, label %bb6.i8, !dbg !996

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %46, %bb4.i7 ], [ %52, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %54 = add i32 %42, 1, !dbg !988
  br label %bb.i6, !dbg !988

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %55 = tail call i64 (i64, ...)* @syscall(i64 235, i8* %path, %struct.timespec* %times) nounwind, !dbg !983
  %56 = trunc i64 %55 to i32, !dbg !983
  tail call void @llvm.dbg.value(metadata !{i32 %56}, i64 0, metadata !393), !dbg !983
  %57 = icmp eq i32 %56, -1, !dbg !997
  br i1 %57, label %bb2, label %bb4, !dbg !997

bb2:                                              ; preds = %__concretize_string.exit
  %58 = tail call i32* @__errno_location() nounwind readnone, !dbg !998
  %59 = tail call i32 @klee_get_errno() nounwind, !dbg !998
  store i32 %59, i32* %58, align 4, !dbg !998
  br label %bb4, !dbg !998

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ 0, %bb ], [ -1, %bb2 ], [ %56, %__concretize_string.exit ]
  ret i32 %.0, !dbg !981
}

define i32 @futimesat(i32 %fd, i8* %path, %struct.timespec* %times) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !394), !dbg !999
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !395), !dbg !999
  tail call void @llvm.dbg.value(metadata !{%struct.timespec* %times}, i64 0, metadata !396), !dbg !999
  %0 = icmp eq i32 %fd, -100, !dbg !1000
  br i1 %0, label %bb5, label %bb, !dbg !1000

bb:                                               ; preds = %entry
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1001
  %1 = icmp ult i32 %fd, 32, !dbg !1003
  br i1 %1, label %bb.i, label %bb1, !dbg !1003

bb.i:                                             ; preds = %bb
  %2 = sext i32 %fd to i64, !dbg !1004
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1004
  %3 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 1, !dbg !1005
  %4 = load i32* %3, align 4, !dbg !1005
  %5 = and i32 %4, 1
  %toBool.i = icmp eq i32 %5, 0, !dbg !1005
  br i1 %toBool.i, label %bb1, label %__get_file.exit, !dbg !1005

__get_file.exit:                                  ; preds = %bb.i
  %6 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, !dbg !1004
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %6}, i64 0, metadata !399), !dbg !1002
  %7 = icmp eq %struct.exe_file_t* %6, null, !dbg !1006
  br i1 %7, label %bb1, label %bb2, !dbg !1006

bb1:                                              ; preds = %bb, %bb.i, %__get_file.exit
  %8 = tail call i32* @__errno_location() nounwind readnone, !dbg !1007
  store i32 9, i32* %8, align 4, !dbg !1007
  br label %bb13, !dbg !1008

bb2:                                              ; preds = %__get_file.exit
  %9 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 3, !dbg !1009
  %10 = load %struct.exe_disk_file_t** %9, align 8, !dbg !1009
  %11 = icmp eq %struct.exe_disk_file_t* %10, null, !dbg !1009
  br i1 %11, label %bb4, label %bb3, !dbg !1009

bb3:                                              ; preds = %bb2
  tail call void @klee_warning(i8* getelementptr inbounds ([44 x i8]* @.str6, i64 0, i64 0)) nounwind, !dbg !1010
  %12 = tail call i32* @__errno_location() nounwind readnone, !dbg !1011
  store i32 2, i32* %12, align 4, !dbg !1011
  br label %bb13, !dbg !1012

bb4:                                              ; preds = %bb2
  %13 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 0, !dbg !1013
  %14 = load i32* %13, align 8, !dbg !1013
  tail call void @llvm.dbg.value(metadata !{i32 %14}, i64 0, metadata !394), !dbg !1013
  %phitmp = sext i32 %14 to i64
  br label %bb5, !dbg !1013

bb5:                                              ; preds = %entry, %bb4
  %fd_addr.0 = phi i64 [ %phitmp, %bb4 ], [ -100, %entry ]
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !1014
  %15 = load i8* %path, align 1, !dbg !1016
  tail call void @llvm.dbg.value(metadata !{i8 %15}, i64 0, metadata !270), !dbg !1016
  %16 = icmp eq i8 %15, 0, !dbg !1017
  br i1 %16, label %bb7, label %bb.i17, !dbg !1017

bb.i17:                                           ; preds = %bb5
  %17 = getelementptr inbounds i8* %path, i64 1, !dbg !1017
  %18 = load i8* %17, align 1, !dbg !1017
  %19 = icmp eq i8 %18, 0, !dbg !1017
  br i1 %19, label %bb8.preheader.i, label %bb7, !dbg !1017

bb8.preheader.i:                                  ; preds = %bb.i17
  %20 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1018
  %21 = sext i8 %15 to i32, !dbg !1019
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %33, 24
  %22 = ashr exact i32 %sext.i, 24, !dbg !1019
  %23 = add nsw i32 %22, 65, !dbg !1019
  %24 = icmp eq i32 %21, %23, !dbg !1019
  br i1 %24, label %bb4.i18, label %bb7.i, !dbg !1019

bb4.i18:                                          ; preds = %bb3.i
  %25 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !1020
  %26 = zext i32 %33 to i64, !dbg !1020
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !1020
  %27 = getelementptr inbounds %struct.exe_disk_file_t* %25, i64 %26, i32 2, !dbg !1021
  %28 = load %struct.stat** %27, align 8, !dbg !1021
  %29 = getelementptr inbounds %struct.stat* %28, i64 0, i32 1, !dbg !1021
  %30 = load i64* %29, align 8, !dbg !1021
  %31 = icmp eq i64 %30, 0, !dbg !1021
  br i1 %31, label %bb7, label %__get_sym_file.exit, !dbg !1021

bb7.i:                                            ; preds = %bb3.i
  %32 = add i32 %33, 1, !dbg !1018
  br label %bb8.i, !dbg !1018

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %33 = phi i32 [ %32, %bb7.i ], [ 0, %bb8.preheader.i ]
  %34 = icmp ugt i32 %20, %33, !dbg !1018
  br i1 %34, label %bb3.i, label %bb7, !dbg !1018

__get_sym_file.exit:                              ; preds = %bb4.i18
  %35 = getelementptr inbounds %struct.exe_disk_file_t* %25, i64 %26, !dbg !1020
  %36 = icmp eq %struct.exe_disk_file_t* %35, null, !dbg !1015
  br i1 %36, label %bb7, label %bb6, !dbg !1015

bb6:                                              ; preds = %__get_sym_file.exit
  %37 = tail call i32 @utimes(i8* %path, %struct.timespec* %times) nounwind, !dbg !1022
  br label %bb13, !dbg !1022

bb7:                                              ; preds = %bb8.i, %bb4.i18, %bb5, %bb.i17, %__get_sym_file.exit
  %38 = icmp eq i8* %path, null, !dbg !1023
  br i1 %38, label %bb10, label %bb8, !dbg !1023

bb8:                                              ; preds = %bb7
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !1024
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !1025
  %39 = ptrtoint i8* %path to i64, !dbg !1027
  %40 = tail call i64 @klee_get_valuel(i64 %39) nounwind, !dbg !1027
  %41 = inttoptr i64 %40 to i8*, !dbg !1027
  tail call void @llvm.dbg.value(metadata !{i8* %41}, i64 0, metadata !347) nounwind, !dbg !1027
  %42 = icmp eq i8* %41, %path, !dbg !1028
  %43 = zext i1 %42 to i64, !dbg !1028
  tail call void @klee_assume(i64 %43) nounwind, !dbg !1028
  tail call void @llvm.dbg.value(metadata !{i8* %41}, i64 0, metadata !357) nounwind, !dbg !1026
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !1029
  br label %bb.i15, !dbg !1029

bb.i15:                                           ; preds = %bb6.i, %bb8
  %sc.0.i = phi i8* [ %41, %bb8 ], [ %sc.1.i, %bb6.i ]
  %44 = phi i32 [ 0, %bb8 ], [ %56, %bb6.i ]
  %tmp.i = add i32 %44, -1
  %45 = load i8* %sc.0.i, align 1, !dbg !1030
  %46 = and i32 %tmp.i, %44, !dbg !1031
  %47 = icmp eq i32 %46, 0, !dbg !1031
  br i1 %47, label %bb1.i16, label %bb5.i, !dbg !1031

bb1.i16:                                          ; preds = %bb.i15
  switch i8 %45, label %bb6.i [
    i8 0, label %bb2.i
    i8 47, label %bb4.i
  ]

bb2.i:                                            ; preds = %bb1.i16
  tail call void @llvm.dbg.value(metadata !{i8 %45}, i64 0, metadata !360) nounwind, !dbg !1030
  store i8 0, i8* %sc.0.i, align 1, !dbg !1032
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !1032
  br label %bb10, !dbg !1032

bb4.i:                                            ; preds = %bb1.i16
  store i8 47, i8* %sc.0.i, align 1, !dbg !1033
  %48 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1033
  br label %bb6.i, !dbg !1033

bb5.i:                                            ; preds = %bb.i15
  %49 = sext i8 %45 to i64, !dbg !1034
  %50 = tail call i64 @klee_get_valuel(i64 %49) nounwind, !dbg !1034
  %51 = trunc i64 %50 to i8, !dbg !1034
  %52 = icmp eq i8 %51, %45, !dbg !1035
  %53 = zext i1 %52 to i64, !dbg !1035
  tail call void @klee_assume(i64 %53) nounwind, !dbg !1035
  store i8 %51, i8* %sc.0.i, align 1, !dbg !1036
  %54 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1036
  %55 = icmp eq i8 %51, 0, !dbg !1037
  br i1 %55, label %bb10, label %bb6.i, !dbg !1037

bb6.i:                                            ; preds = %bb5.i, %bb4.i, %bb1.i16
  %sc.1.i = phi i8* [ %48, %bb4.i ], [ %54, %bb5.i ], [ %sc.0.i, %bb1.i16 ]
  %56 = add i32 %44, 1, !dbg !1029
  br label %bb.i15, !dbg !1029

bb10:                                             ; preds = %bb5.i, %bb2.i, %bb7
  %iftmp.31.0 = phi i8* [ null, %bb7 ], [ %path, %bb2.i ], [ %path, %bb5.i ]
  %57 = tail call i64 (i64, ...)* @syscall(i64 261, i64 %fd_addr.0, i8* %iftmp.31.0, %struct.timespec* %times) nounwind, !dbg !1023
  %58 = trunc i64 %57 to i32, !dbg !1023
  tail call void @llvm.dbg.value(metadata !{i32 %58}, i64 0, metadata !397), !dbg !1023
  %59 = icmp eq i32 %58, -1, !dbg !1038
  br i1 %59, label %bb11, label %bb13, !dbg !1038

bb11:                                             ; preds = %bb10
  %60 = tail call i32* @__errno_location() nounwind readnone, !dbg !1039
  %61 = tail call i32 @klee_get_errno() nounwind, !dbg !1039
  store i32 %61, i32* %60, align 4, !dbg !1039
  br label %bb13, !dbg !1039

bb13:                                             ; preds = %bb10, %bb11, %bb6, %bb3, %bb1
  %.0 = phi i32 [ -1, %bb1 ], [ -1, %bb3 ], [ %37, %bb6 ], [ -1, %bb11 ], [ %58, %bb10 ]
  ret i32 %.0, !dbg !1008
}

define i32 @select(i32 %nfds, %struct.fd_set* %read, %struct.fd_set* %write, %struct.fd_set* %except, %struct.timespec* nocapture %timeout) nounwind {
entry:
  %in_read = alloca %struct.fd_set, align 8
  %in_write = alloca %struct.fd_set, align 8
  %in_except = alloca %struct.fd_set, align 8
  %os_read = alloca %struct.fd_set, align 8
  %os_write = alloca %struct.fd_set, align 8
  %os_except = alloca %struct.fd_set, align 8
  %tv = alloca %struct.timespec, align 8
  call void @llvm.dbg.value(metadata !{i32 %nfds}, i64 0, metadata !407), !dbg !1040
  call void @llvm.dbg.value(metadata !{%struct.fd_set* %read}, i64 0, metadata !408), !dbg !1040
  call void @llvm.dbg.value(metadata !{%struct.fd_set* %write}, i64 0, metadata !409), !dbg !1040
  call void @llvm.dbg.value(metadata !{%struct.fd_set* %except}, i64 0, metadata !410), !dbg !1041
  call void @llvm.dbg.value(metadata !{%struct.timespec* %timeout}, i64 0, metadata !411), !dbg !1041
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %in_read}, metadata !412), !dbg !1042
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %in_write}, metadata !414), !dbg !1042
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %in_except}, metadata !415), !dbg !1042
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %os_read}, metadata !416), !dbg !1042
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %os_write}, metadata !417), !dbg !1042
  call void @llvm.dbg.declare(metadata !{%struct.fd_set* %os_except}, metadata !418), !dbg !1042
  call void @llvm.dbg.value(metadata !627, i64 0, metadata !420), !dbg !1043
  call void @llvm.dbg.value(metadata !627, i64 0, metadata !421), !dbg !1043
  %0 = icmp eq %struct.fd_set* %read, null, !dbg !1044
  %in_read3 = bitcast %struct.fd_set* %in_read to i8*, !dbg !1045
  br i1 %0, label %bb2, label %bb, !dbg !1044

bb:                                               ; preds = %entry
  %1 = bitcast %struct.fd_set* %read to i8*, !dbg !1046
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %in_read3, i8* %1, i64 128, i32 8, i1 false), !dbg !1046
  call void @llvm.memset.p0i8.i64(i8* %1, i8 0, i64 128, i32 8, i1 false), !dbg !1047
  br label %bb4, !dbg !1047

bb2:                                              ; preds = %entry
  call void @llvm.memset.p0i8.i64(i8* %in_read3, i8 0, i64 128, i32 8, i1 false), !dbg !1045
  br label %bb4, !dbg !1045

bb4:                                              ; preds = %bb2, %bb
  %2 = icmp eq %struct.fd_set* %write, null, !dbg !1048
  %in_write8 = bitcast %struct.fd_set* %in_write to i8*, !dbg !1049
  br i1 %2, label %bb7, label %bb5, !dbg !1048

bb5:                                              ; preds = %bb4
  %3 = bitcast %struct.fd_set* %write to i8*, !dbg !1050
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %in_write8, i8* %3, i64 128, i32 8, i1 false), !dbg !1050
  call void @llvm.memset.p0i8.i64(i8* %3, i8 0, i64 128, i32 8, i1 false), !dbg !1051
  br label %bb9, !dbg !1051

bb7:                                              ; preds = %bb4
  call void @llvm.memset.p0i8.i64(i8* %in_write8, i8 0, i64 128, i32 8, i1 false), !dbg !1049
  br label %bb9, !dbg !1049

bb9:                                              ; preds = %bb7, %bb5
  %4 = icmp eq %struct.fd_set* %except, null, !dbg !1052
  %in_except13 = bitcast %struct.fd_set* %in_except to i8*, !dbg !1053
  br i1 %4, label %bb12, label %bb10, !dbg !1052

bb10:                                             ; preds = %bb9
  %5 = bitcast %struct.fd_set* %except to i8*, !dbg !1054
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %in_except13, i8* %5, i64 128, i32 8, i1 false), !dbg !1054
  call void @llvm.memset.p0i8.i64(i8* %5, i8 0, i64 128, i32 8, i1 false), !dbg !1055
  br label %bb14, !dbg !1055

bb12:                                             ; preds = %bb9
  call void @llvm.memset.p0i8.i64(i8* %in_except13, i8 0, i64 128, i32 8, i1 false), !dbg !1053
  br label %bb14, !dbg !1053

bb14:                                             ; preds = %bb12, %bb10
  %os_read15 = bitcast %struct.fd_set* %os_read to i8*, !dbg !1056
  call void @llvm.memset.p0i8.i64(i8* %os_read15, i8 0, i64 128, i32 8, i1 false), !dbg !1056
  %os_write16 = bitcast %struct.fd_set* %os_write to i8*, !dbg !1057
  call void @llvm.memset.p0i8.i64(i8* %os_write16, i8 0, i64 128, i32 8, i1 false), !dbg !1057
  %os_except17 = bitcast %struct.fd_set* %os_except to i8*, !dbg !1058
  call void @llvm.memset.p0i8.i64(i8* %os_except17, i8 0, i64 128, i32 8, i1 false), !dbg !1058
  call void @llvm.dbg.value(metadata !627, i64 0, metadata !419), !dbg !1059
  br label %bb40, !dbg !1059

bb18:                                             ; preds = %bb40
  %6 = sdiv i32 %i.0, 64, !dbg !1060
  %7 = sext i32 %6 to i64, !dbg !1060
  %8 = getelementptr inbounds %struct.fd_set* %in_read, i64 0, i32 0, i64 %7, !dbg !1060
  %9 = load i64* %8, align 8, !dbg !1060
  %10 = and i32 %i.0, 63
  %11 = shl i32 1, %10, !dbg !1060
  %12 = sext i32 %11 to i64, !dbg !1060
  %13 = and i64 %9, %12, !dbg !1060
  %14 = icmp eq i64 %13, 0, !dbg !1060
  br i1 %14, label %bb19, label %bb21, !dbg !1060

bb19:                                             ; preds = %bb18
  %15 = getelementptr inbounds %struct.fd_set* %in_write, i64 0, i32 0, i64 %7, !dbg !1060
  %16 = load i64* %15, align 8, !dbg !1060
  %17 = and i64 %16, %12, !dbg !1060
  %18 = icmp eq i64 %17, 0, !dbg !1060
  br i1 %18, label %bb20, label %bb21, !dbg !1060

bb20:                                             ; preds = %bb19
  %19 = getelementptr inbounds %struct.fd_set* %in_except, i64 0, i32 0, i64 %7, !dbg !1060
  %20 = load i64* %19, align 8, !dbg !1060
  %21 = and i64 %20, %12, !dbg !1060
  %22 = icmp eq i64 %21, 0, !dbg !1060
  br i1 %22, label %bb39, label %bb21, !dbg !1060

bb21:                                             ; preds = %bb20, %bb19, %bb18
  %23 = icmp ult i32 %i.0, 32, !dbg !1061
  br i1 %23, label %bb.i, label %bb22, !dbg !1061

bb.i:                                             ; preds = %bb21
  %24 = load i32* %scevgep83, align 4, !dbg !1063
  %25 = and i32 %24, 1
  %toBool.i = icmp eq i32 %25, 0, !dbg !1063
  %26 = icmp eq %struct.exe_file_t* %scevgep80, null, !dbg !1064
  %or.cond = or i1 %toBool.i, %26
  br i1 %or.cond, label %bb22, label %bb23, !dbg !1063

bb22:                                             ; preds = %bb21, %bb.i
  tail call void @llvm.dbg.value(metadata !1065, i64 0, metadata !275), !dbg !1066
  %27 = call i32* @__errno_location() nounwind readnone, !dbg !1067
  store i32 9, i32* %27, align 4, !dbg !1067
  br label %bb61, !dbg !1068

bb23:                                             ; preds = %bb.i
  %28 = load %struct.exe_disk_file_t** %scevgep82, align 8, !dbg !1069
  %29 = icmp eq %struct.exe_disk_file_t* %28, null, !dbg !1069
  %30 = icmp ne i64 %13, 0, !dbg !1070
  br i1 %29, label %bb31, label %bb24, !dbg !1069

bb24:                                             ; preds = %bb23
  br i1 %30, label %bb25, label %bb26, !dbg !1070

bb25:                                             ; preds = %bb24
  %31 = getelementptr inbounds %struct.fd_set* %read, i64 0, i32 0, i64 %7, !dbg !1070
  %32 = load i64* %31, align 8, !dbg !1070
  %33 = or i64 %32, %12, !dbg !1070
  store i64 %33, i64* %31, align 8, !dbg !1070
  br label %bb26, !dbg !1070

bb26:                                             ; preds = %bb24, %bb25
  %34 = getelementptr inbounds %struct.fd_set* %in_write, i64 0, i32 0, i64 %7, !dbg !1071
  %35 = load i64* %34, align 8, !dbg !1071
  %36 = and i64 %35, %12, !dbg !1071
  %37 = icmp eq i64 %36, 0, !dbg !1071
  br i1 %37, label %bb28, label %bb27, !dbg !1071

bb27:                                             ; preds = %bb26
  %38 = getelementptr inbounds %struct.fd_set* %write, i64 0, i32 0, i64 %7, !dbg !1071
  %39 = load i64* %38, align 8, !dbg !1071
  %40 = or i64 %39, %12, !dbg !1071
  store i64 %40, i64* %38, align 8, !dbg !1071
  br label %bb28, !dbg !1071

bb28:                                             ; preds = %bb26, %bb27
  %41 = getelementptr inbounds %struct.fd_set* %in_except, i64 0, i32 0, i64 %7, !dbg !1072
  %42 = load i64* %41, align 8, !dbg !1072
  %43 = and i64 %42, %12, !dbg !1072
  %44 = icmp eq i64 %43, 0, !dbg !1072
  br i1 %44, label %bb30, label %bb29, !dbg !1072

bb29:                                             ; preds = %bb28
  %45 = getelementptr inbounds %struct.fd_set* %except, i64 0, i32 0, i64 %7, !dbg !1072
  %46 = load i64* %45, align 8, !dbg !1072
  %47 = or i64 %46, %12, !dbg !1072
  store i64 %47, i64* %45, align 8, !dbg !1072
  br label %bb30, !dbg !1072

bb30:                                             ; preds = %bb28, %bb29
  %48 = add nsw i32 %count.1, 1, !dbg !1073
  br label %bb39, !dbg !1073

bb31:                                             ; preds = %bb23
  br i1 %30, label %bb32, label %bb33, !dbg !1074

bb32:                                             ; preds = %bb31
  %49 = load i32* %scevgep8081, align 8, !dbg !1074
  %50 = sdiv i32 %49, 64, !dbg !1074
  %51 = sext i32 %50 to i64, !dbg !1074
  %52 = getelementptr inbounds %struct.fd_set* %os_read, i64 0, i32 0, i64 %51, !dbg !1074
  %53 = load i64* %52, align 8, !dbg !1074
  %54 = and i32 %49, 63
  %55 = shl i32 1, %54, !dbg !1074
  %56 = sext i32 %55 to i64, !dbg !1074
  %57 = or i64 %56, %53, !dbg !1074
  store i64 %57, i64* %52, align 8, !dbg !1074
  br label %bb33, !dbg !1074

bb33:                                             ; preds = %bb31, %bb32
  %58 = getelementptr inbounds %struct.fd_set* %in_write, i64 0, i32 0, i64 %7, !dbg !1075
  %59 = load i64* %58, align 8, !dbg !1075
  %60 = and i64 %59, %12, !dbg !1075
  %61 = icmp eq i64 %60, 0, !dbg !1075
  br i1 %61, label %bb35, label %bb34, !dbg !1075

bb34:                                             ; preds = %bb33
  %62 = load i32* %scevgep8081, align 8, !dbg !1075
  %63 = sdiv i32 %62, 64, !dbg !1075
  %64 = sext i32 %63 to i64, !dbg !1075
  %65 = getelementptr inbounds %struct.fd_set* %os_write, i64 0, i32 0, i64 %64, !dbg !1075
  %66 = load i64* %65, align 8, !dbg !1075
  %67 = and i32 %62, 63
  %68 = shl i32 1, %67, !dbg !1075
  %69 = sext i32 %68 to i64, !dbg !1075
  %70 = or i64 %69, %66, !dbg !1075
  store i64 %70, i64* %65, align 8, !dbg !1075
  br label %bb35, !dbg !1075

bb35:                                             ; preds = %bb33, %bb34
  %71 = getelementptr inbounds %struct.fd_set* %in_except, i64 0, i32 0, i64 %7, !dbg !1076
  %72 = load i64* %71, align 8, !dbg !1076
  %73 = and i64 %72, %12, !dbg !1076
  %74 = icmp eq i64 %73, 0, !dbg !1076
  %.pre = load i32* %scevgep8081, align 8
  br i1 %74, label %bb37, label %bb36, !dbg !1076

bb36:                                             ; preds = %bb35
  %75 = sdiv i32 %.pre, 64, !dbg !1076
  %76 = sext i32 %75 to i64, !dbg !1076
  %77 = getelementptr inbounds %struct.fd_set* %os_except, i64 0, i32 0, i64 %76, !dbg !1076
  %78 = load i64* %77, align 8, !dbg !1076
  %79 = and i32 %.pre, 63
  %80 = shl i32 1, %79, !dbg !1076
  %81 = sext i32 %80 to i64, !dbg !1076
  %82 = or i64 %81, %78, !dbg !1076
  store i64 %82, i64* %77, align 8, !dbg !1076
  br label %bb37, !dbg !1076

bb37:                                             ; preds = %bb35, %bb36
  %83 = add nsw i32 %.pre, 1, !dbg !1077
  %84 = icmp slt i32 %.pre, %os_nfds.1, !dbg !1077
  %os_nfds.1. = select i1 %84, i32 %os_nfds.1, i32 %83
  br label %bb39

bb39:                                             ; preds = %bb37, %bb20, %bb30
  %count.0 = phi i32 [ %48, %bb30 ], [ %count.1, %bb20 ], [ %count.1, %bb37 ]
  %os_nfds.0 = phi i32 [ %os_nfds.1, %bb30 ], [ %os_nfds.1, %bb20 ], [ %os_nfds.1., %bb37 ]
  %indvar.next78 = add i64 %indvar77, 1
  br label %bb40, !dbg !1059

bb40:                                             ; preds = %bb39, %bb14
  %indvar77 = phi i64 [ %indvar.next78, %bb39 ], [ 0, %bb14 ]
  %count.1 = phi i32 [ %count.0, %bb39 ], [ 0, %bb14 ]
  %os_nfds.1 = phi i32 [ %os_nfds.0, %bb39 ], [ 0, %bb14 ]
  %i.0 = trunc i64 %indvar77 to i32
  %scevgep80 = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar77
  %scevgep8081 = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar77, i32 0
  %scevgep82 = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar77, i32 3
  %scevgep83 = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar77, i32 1
  %85 = icmp slt i32 %i.0, %nfds, !dbg !1059
  br i1 %85, label %bb18, label %bb41, !dbg !1059

bb41:                                             ; preds = %bb40
  %86 = icmp sgt i32 %os_nfds.1, 0, !dbg !1078
  br i1 %86, label %bb42, label %bb61, !dbg !1078

bb42:                                             ; preds = %bb41
  call void @llvm.dbg.declare(metadata !{%struct.timespec* %tv}, metadata !424), !dbg !1079
  %87 = getelementptr inbounds %struct.timespec* %tv, i64 0, i32 0, !dbg !1079
  store i64 0, i64* %87, align 8, !dbg !1079
  %88 = getelementptr inbounds %struct.timespec* %tv, i64 0, i32 1, !dbg !1079
  store i64 0, i64* %88, align 8, !dbg !1079
  %89 = call i64 (i64, ...)* @syscall(i64 23, i32 %os_nfds.1, %struct.fd_set* %os_read, %struct.fd_set* %os_write, %struct.fd_set* %os_except, %struct.timespec* %tv) nounwind, !dbg !1080
  %90 = trunc i64 %89 to i32, !dbg !1080
  call void @llvm.dbg.value(metadata !{i32 %90}, i64 0, metadata !426), !dbg !1080
  %91 = icmp eq i32 %90, -1, !dbg !1081
  br i1 %91, label %bb43, label %bb45, !dbg !1081

bb43:                                             ; preds = %bb42
  %92 = icmp eq i32 %count.1, 0, !dbg !1082
  br i1 %92, label %bb44, label %bb61, !dbg !1082

bb44:                                             ; preds = %bb43
  %93 = call i32* @__errno_location() nounwind readnone, !dbg !1083
  %94 = call i32 @klee_get_errno() nounwind, !dbg !1083
  store i32 %94, i32* %93, align 4, !dbg !1083
  br label %bb61, !dbg !1084

bb45:                                             ; preds = %bb42
  %95 = add nsw i32 %90, %count.1, !dbg !1085
  call void @llvm.dbg.value(metadata !{i32 %95}, i64 0, metadata !420), !dbg !1085
  call void @llvm.dbg.value(metadata !627, i64 0, metadata !419), !dbg !1086
  %96 = icmp sgt i32 %nfds, 0, !dbg !1086
  br i1 %96, label %bb46.lr.ph, label %bb61, !dbg !1086

bb46.lr.ph:                                       ; preds = %bb45
  %tmp = zext i32 %nfds to i64
  br label %bb46

bb46:                                             ; preds = %bb58, %bb46.lr.ph
  %indvar = phi i64 [ 0, %bb46.lr.ph ], [ %indvar.next, %bb58 ]
  %i.168 = trunc i64 %indvar to i32
  %scevgep = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar
  %scevgep72 = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar, i32 0
  %scevgep73 = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar, i32 3
  %97 = icmp ult i32 %i.168, 32, !dbg !1087
  br i1 %97, label %bb.i64, label %bb58, !dbg !1087

bb.i64:                                           ; preds = %bb46
  %scevgep74 = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar, i32 1
  %98 = load i32* %scevgep74, align 4, !dbg !1089
  %99 = and i32 %98, 1
  %toBool.i63 = icmp eq i32 %99, 0, !dbg !1089
  %100 = icmp eq %struct.exe_file_t* %scevgep, null, !dbg !1090
  %or.cond84 = or i1 %toBool.i63, %100
  br i1 %or.cond84, label %bb58, label %bb48, !dbg !1089

bb48:                                             ; preds = %bb.i64
  %101 = load %struct.exe_disk_file_t** %scevgep73, align 8, !dbg !1090
  %102 = icmp eq %struct.exe_disk_file_t* %101, null, !dbg !1090
  br i1 %102, label %bb49, label %bb58, !dbg !1090

bb49:                                             ; preds = %bb48
  br i1 %0, label %bb52, label %bb50, !dbg !1091

bb50:                                             ; preds = %bb49
  %103 = load i32* %scevgep72, align 8, !dbg !1091
  %104 = sdiv i32 %103, 64, !dbg !1091
  %105 = sext i32 %104 to i64, !dbg !1091
  %106 = getelementptr inbounds %struct.fd_set* %os_read, i64 0, i32 0, i64 %105, !dbg !1091
  %107 = load i64* %106, align 8, !dbg !1091
  %108 = and i32 %103, 63
  %109 = shl i32 1, %108, !dbg !1091
  %110 = sext i32 %109 to i64, !dbg !1091
  %111 = and i64 %110, %107, !dbg !1091
  %112 = icmp eq i64 %111, 0, !dbg !1091
  br i1 %112, label %bb52, label %bb51, !dbg !1091

bb51:                                             ; preds = %bb50
  %113 = sdiv i32 %i.168, 64, !dbg !1091
  %114 = sext i32 %113 to i64, !dbg !1091
  %115 = getelementptr inbounds %struct.fd_set* %read, i64 0, i32 0, i64 %114, !dbg !1091
  %116 = load i64* %115, align 8, !dbg !1091
  %117 = and i32 %i.168, 63
  %118 = shl i32 1, %117, !dbg !1091
  %119 = sext i32 %118 to i64, !dbg !1091
  %120 = or i64 %116, %119, !dbg !1091
  store i64 %120, i64* %115, align 8, !dbg !1091
  br label %bb52, !dbg !1091

bb52:                                             ; preds = %bb50, %bb49, %bb51
  br i1 %2, label %bb55, label %bb53, !dbg !1092

bb53:                                             ; preds = %bb52
  %121 = load i32* %scevgep72, align 8, !dbg !1092
  %122 = sdiv i32 %121, 64, !dbg !1092
  %123 = sext i32 %122 to i64, !dbg !1092
  %124 = getelementptr inbounds %struct.fd_set* %os_write, i64 0, i32 0, i64 %123, !dbg !1092
  %125 = load i64* %124, align 8, !dbg !1092
  %126 = and i32 %121, 63
  %127 = shl i32 1, %126, !dbg !1092
  %128 = sext i32 %127 to i64, !dbg !1092
  %129 = and i64 %128, %125, !dbg !1092
  %130 = icmp eq i64 %129, 0, !dbg !1092
  br i1 %130, label %bb55, label %bb54, !dbg !1092

bb54:                                             ; preds = %bb53
  %131 = sdiv i32 %i.168, 64, !dbg !1092
  %132 = sext i32 %131 to i64, !dbg !1092
  %133 = getelementptr inbounds %struct.fd_set* %write, i64 0, i32 0, i64 %132, !dbg !1092
  %134 = load i64* %133, align 8, !dbg !1092
  %135 = and i32 %i.168, 63
  %136 = shl i32 1, %135, !dbg !1092
  %137 = sext i32 %136 to i64, !dbg !1092
  %138 = or i64 %134, %137, !dbg !1092
  store i64 %138, i64* %133, align 8, !dbg !1092
  br label %bb55, !dbg !1092

bb55:                                             ; preds = %bb53, %bb52, %bb54
  br i1 %4, label %bb58, label %bb56, !dbg !1093

bb56:                                             ; preds = %bb55
  %139 = load i32* %scevgep72, align 8, !dbg !1093
  %140 = sdiv i32 %139, 64, !dbg !1093
  %141 = sext i32 %140 to i64, !dbg !1093
  %142 = getelementptr inbounds %struct.fd_set* %os_except, i64 0, i32 0, i64 %141, !dbg !1093
  %143 = load i64* %142, align 8, !dbg !1093
  %144 = and i32 %139, 63
  %145 = shl i32 1, %144, !dbg !1093
  %146 = sext i32 %145 to i64, !dbg !1093
  %147 = and i64 %146, %143, !dbg !1093
  %148 = icmp eq i64 %147, 0, !dbg !1093
  br i1 %148, label %bb58, label %bb57, !dbg !1093

bb57:                                             ; preds = %bb56
  %149 = sdiv i32 %i.168, 64, !dbg !1093
  %150 = sext i32 %149 to i64, !dbg !1093
  %151 = getelementptr inbounds %struct.fd_set* %except, i64 0, i32 0, i64 %150, !dbg !1093
  %152 = load i64* %151, align 8, !dbg !1093
  %153 = and i32 %i.168, 63
  %154 = shl i32 1, %153, !dbg !1093
  %155 = sext i32 %154 to i64, !dbg !1093
  %156 = or i64 %152, %155, !dbg !1093
  store i64 %156, i64* %151, align 8, !dbg !1093
  br label %bb58, !dbg !1093

bb58:                                             ; preds = %bb46, %bb.i64, %bb56, %bb55, %bb57, %bb48
  %indvar.next = add i64 %indvar, 1
  %exitcond = icmp eq i64 %indvar.next, %tmp
  br i1 %exitcond, label %bb61, label %bb46, !dbg !1086

bb61:                                             ; preds = %bb45, %bb58, %bb41, %bb43, %bb44, %bb22
  %.0 = phi i32 [ -1, %bb22 ], [ -1, %bb44 ], [ %count.1, %bb43 ], [ %count.1, %bb41 ], [ %95, %bb58 ], [ %95, %bb45 ]
  ret i32 %.0, !dbg !1068
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i32, i1) nounwind

declare void @llvm.memset.p0i8.i64(i8* nocapture, i8, i64, i32, i1) nounwind

define i32 @close(i32 %fd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !429), !dbg !1094
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !432), !dbg !1095
  %0 = load i32* @n_calls.4900, align 4, !dbg !1096
  %1 = add nsw i32 %0, 1, !dbg !1096
  store i32 %1, i32* @n_calls.4900, align 4, !dbg !1096
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1097
  %2 = icmp ult i32 %fd, 32, !dbg !1099
  br i1 %2, label %bb.i, label %bb, !dbg !1099

bb.i:                                             ; preds = %entry
  %3 = sext i32 %fd to i64, !dbg !1100
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1100
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, i32 1, !dbg !1101
  %5 = load i32* %4, align 4, !dbg !1101
  %6 = and i32 %5, 1
  %toBool.i = icmp eq i32 %6, 0, !dbg !1101
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1101

__get_file.exit:                                  ; preds = %bb.i
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, !dbg !1100
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %7}, i64 0, metadata !430), !dbg !1098
  %8 = icmp eq %struct.exe_file_t* %7, null, !dbg !1102
  br i1 %8, label %bb, label %bb1, !dbg !1102

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %9 = tail call i32* @__errno_location() nounwind readnone, !dbg !1103
  store i32 9, i32* %9, align 4, !dbg !1103
  br label %bb5, !dbg !1104

bb1:                                              ; preds = %__get_file.exit
  %10 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1105
  %11 = icmp eq i32 %10, 0, !dbg !1105
  br i1 %11, label %bb4, label %bb2, !dbg !1105

bb2:                                              ; preds = %bb1
  %12 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 8), align 8, !dbg !1105
  %13 = load i32* %12, align 4, !dbg !1105
  %14 = icmp eq i32 %13, %1, !dbg !1105
  br i1 %14, label %bb3, label %bb4, !dbg !1105

bb3:                                              ; preds = %bb2
  %15 = add i32 %10, -1, !dbg !1106
  store i32 %15, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1106
  %16 = tail call i32* @__errno_location() nounwind readnone, !dbg !1107
  store i32 5, i32* %16, align 4, !dbg !1107
  br label %bb5, !dbg !1108

bb4:                                              ; preds = %bb1, %bb2
  %17 = bitcast %struct.exe_file_t* %7 to i8*, !dbg !1109
  tail call void @llvm.memset.p0i8.i64(i8* %17, i8 0, i64 24, i32 8, i1 false), !dbg !1109
  br label %bb5, !dbg !1110

bb5:                                              ; preds = %bb4, %bb3, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb3 ], [ 0, %bb4 ]
  ret i32 %.0, !dbg !1104
}

define i32 @dup2(i32 %oldfd, i32 %newfd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %oldfd}, i64 0, metadata !433), !dbg !1111
  tail call void @llvm.dbg.value(metadata !{i32 %newfd}, i64 0, metadata !434), !dbg !1111
  tail call void @llvm.dbg.value(metadata !{i32 %oldfd}, i64 0, metadata !275), !dbg !1112
  %0 = icmp ult i32 %oldfd, 32, !dbg !1114
  br i1 %0, label %bb.i, label %bb, !dbg !1114

bb.i:                                             ; preds = %entry
  %1 = sext i32 %oldfd to i64, !dbg !1115
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1115
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !1116
  %3 = load i32* %2, align 4, !dbg !1116
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !1116
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1116

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !1115
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !435), !dbg !1113
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !1117
  %7 = icmp ugt i32 %newfd, 31, !dbg !1117
  %8 = or i1 %6, %7, !dbg !1117
  br i1 %8, label %bb, label %bb3, !dbg !1117

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %9 = tail call i32* @__errno_location() nounwind readnone, !dbg !1118
  store i32 9, i32* %9, align 4, !dbg !1118
  br label %bb7, !dbg !1119

bb3:                                              ; preds = %__get_file.exit
  %10 = sext i32 %newfd to i64, !dbg !1120
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !437), !dbg !1120
  %11 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %10, i32 1, !dbg !1121
  %12 = load i32* %11, align 4, !dbg !1121
  %13 = and i32 %12, 1
  %toBool4 = icmp eq i32 %13, 0, !dbg !1121
  br i1 %toBool4, label %bb6, label %bb5, !dbg !1121

bb5:                                              ; preds = %bb3
  tail call void @llvm.dbg.value(metadata !{i32 %newfd}, i64 0, metadata !429) nounwind, !dbg !1122
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !432) nounwind, !dbg !1123
  %14 = load i32* @n_calls.4900, align 4, !dbg !1124
  %15 = add nsw i32 %14, 1, !dbg !1124
  store i32 %15, i32* @n_calls.4900, align 4, !dbg !1124
  tail call void @llvm.dbg.value(metadata !{i32 %newfd}, i64 0, metadata !275) nounwind, !dbg !1125
  %16 = icmp ult i32 %newfd, 32, !dbg !1127
  br i1 %16, label %__get_file.exit.i, label %bb.i9, !dbg !1127

__get_file.exit.i:                                ; preds = %bb5
  %17 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %10, !dbg !1128
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %17}, i64 0, metadata !430) nounwind, !dbg !1126
  %18 = icmp eq %struct.exe_file_t* %17, null, !dbg !1129
  br i1 %18, label %bb.i9, label %bb1.i10, !dbg !1129

bb.i9:                                            ; preds = %__get_file.exit.i, %bb5
  %19 = tail call i32* @__errno_location() nounwind readnone, !dbg !1130
  store i32 9, i32* %19, align 4, !dbg !1130
  br label %bb6, !dbg !1131

bb1.i10:                                          ; preds = %__get_file.exit.i
  %20 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1132
  %21 = icmp eq i32 %20, 0, !dbg !1132
  br i1 %21, label %bb4.i, label %bb2.i, !dbg !1132

bb2.i:                                            ; preds = %bb1.i10
  %22 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 8), align 8, !dbg !1132
  %23 = load i32* %22, align 4, !dbg !1132
  %24 = icmp eq i32 %23, %15, !dbg !1132
  br i1 %24, label %bb3.i, label %bb4.i, !dbg !1132

bb3.i:                                            ; preds = %bb2.i
  %25 = add i32 %20, -1, !dbg !1133
  store i32 %25, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1133
  %26 = tail call i32* @__errno_location() nounwind readnone, !dbg !1134
  store i32 5, i32* %26, align 4, !dbg !1134
  br label %bb6, !dbg !1135

bb4.i:                                            ; preds = %bb2.i, %bb1.i10
  %27 = bitcast %struct.exe_file_t* %17 to i8*, !dbg !1136
  tail call void @llvm.memset.p0i8.i64(i8* %27, i8 0, i64 24, i32 8, i1 false) nounwind, !dbg !1136
  br label %bb6, !dbg !1137

bb6:                                              ; preds = %bb4.i, %bb3.i, %bb.i9, %bb3
  %28 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %10, i32 0, !dbg !1138
  %29 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !1138
  %30 = load i32* %29, align 8, !dbg !1138
  store i32 %30, i32* %28, align 8, !dbg !1138
  %31 = load i32* %2, align 4, !dbg !1138
  %32 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %10, i32 2, !dbg !1138
  %33 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 2, !dbg !1138
  %34 = load i64* %33, align 8, !dbg !1138
  store i64 %34, i64* %32, align 8, !dbg !1138
  %35 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %10, i32 3, !dbg !1138
  %36 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !1138
  %37 = load %struct.exe_disk_file_t** %36, align 8, !dbg !1138
  store %struct.exe_disk_file_t* %37, %struct.exe_disk_file_t** %35, align 8, !dbg !1138
  %38 = and i32 %31, -3, !dbg !1139
  store i32 %38, i32* %11, align 4, !dbg !1139
  br label %bb7, !dbg !1140

bb7:                                              ; preds = %bb6, %bb
  %.0 = phi i32 [ -1, %bb ], [ %newfd, %bb6 ]
  ret i32 %.0, !dbg !1119
}

define i32 @dup(i32 %oldfd) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %oldfd}, i64 0, metadata !439), !dbg !1141
  tail call void @llvm.dbg.value(metadata !{i32 %oldfd}, i64 0, metadata !275), !dbg !1142
  %0 = icmp ult i32 %oldfd, 32, !dbg !1144
  br i1 %0, label %bb.i, label %bb, !dbg !1144

bb.i:                                             ; preds = %entry
  %1 = sext i32 %oldfd to i64, !dbg !1145
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1145
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !1146
  %3 = load i32* %2, align 4, !dbg !1146
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !1146
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1146

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !1145
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !440), !dbg !1143
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !1147
  br i1 %6, label %bb, label %bb4, !dbg !1147

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !1148
  store i32 9, i32* %7, align 4, !dbg !1148
  br label %bb8, !dbg !1149

bb2:                                              ; preds = %bb4
  %scevgep = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar, i32 1
  %8 = load i32* %scevgep, align 4, !dbg !1150
  %9 = and i32 %8, 1, !dbg !1150
  %10 = icmp eq i32 %9, 0, !dbg !1150
  br i1 %10, label %bb7, label %bb3, !dbg !1150

bb3:                                              ; preds = %bb2
  %indvar.next = add i64 %indvar, 1
  br label %bb4, !dbg !1151

bb4:                                              ; preds = %__get_file.exit, %bb3
  %indvar = phi i64 [ %indvar.next, %bb3 ], [ 0, %__get_file.exit ]
  %fd.0 = trunc i64 %indvar to i32
  %11 = icmp slt i32 %fd.0, 32, !dbg !1151
  br i1 %11, label %bb2, label %bb5, !dbg !1151

bb5:                                              ; preds = %bb4
  %12 = icmp eq i32 %fd.0, 32, !dbg !1152
  br i1 %12, label %bb6, label %bb7, !dbg !1152

bb6:                                              ; preds = %bb5
  %13 = tail call i32* @__errno_location() nounwind readnone, !dbg !1153
  store i32 24, i32* %13, align 4, !dbg !1153
  br label %bb8, !dbg !1154

bb7:                                              ; preds = %bb2, %bb5
  %14 = tail call i32 @dup2(i32 %oldfd, i32 %fd.0) nounwind, !dbg !1155
  br label %bb8, !dbg !1155

bb8:                                              ; preds = %bb7, %bb6, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb6 ], [ %14, %bb7 ]
  ret i32 %.0, !dbg !1149
}

define i32 @__fd_open(i8* %pathname, i32 %flags, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !444), !dbg !1156
  tail call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !445), !dbg !1156
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !446), !dbg !1156
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !450), !dbg !1157
  br label %bb2, !dbg !1157

bb:                                               ; preds = %bb2
  %scevgep = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar, i32 1
  %0 = load i32* %scevgep, align 4, !dbg !1158
  %1 = and i32 %0, 1, !dbg !1158
  %2 = icmp eq i32 %1, 0, !dbg !1158
  br i1 %2, label %bb5, label %bb1, !dbg !1158

bb1:                                              ; preds = %bb
  %indvar.next = add i64 %indvar, 1
  br label %bb2, !dbg !1157

bb2:                                              ; preds = %bb1, %entry
  %indvar = phi i64 [ %indvar.next, %bb1 ], [ 0, %entry ]
  %fd.0 = trunc i64 %indvar to i32
  %3 = icmp slt i32 %fd.0, 32, !dbg !1157
  br i1 %3, label %bb, label %bb3, !dbg !1157

bb3:                                              ; preds = %bb2
  %4 = icmp eq i32 %fd.0, 32, !dbg !1159
  br i1 %4, label %bb4, label %bb5, !dbg !1159

bb4:                                              ; preds = %bb3
  %5 = tail call i32* @__errno_location() nounwind readnone, !dbg !1160
  store i32 24, i32* %5, align 4, !dbg !1160
  br label %bb25, !dbg !1161

bb5:                                              ; preds = %bb, %bb3
  %6 = sext i32 %fd.0 to i64, !dbg !1162
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, !dbg !1162
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %7}, i64 0, metadata !449), !dbg !1162
  %8 = bitcast %struct.exe_file_t* %7 to i8*, !dbg !1163
  tail call void @llvm.memset.p0i8.i64(i8* %8, i8 0, i64 24, i32 8, i1 false), !dbg !1163
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !269), !dbg !1164
  %9 = load i8* %pathname, align 1, !dbg !1166
  tail call void @llvm.dbg.value(metadata !{i8 %9}, i64 0, metadata !270), !dbg !1166
  %10 = icmp eq i8 %9, 0, !dbg !1167
  br i1 %10, label %bb16, label %bb.i, !dbg !1167

bb.i:                                             ; preds = %bb5
  %11 = getelementptr inbounds i8* %pathname, i64 1, !dbg !1167
  %12 = load i8* %11, align 1, !dbg !1167
  %13 = icmp eq i8 %12, 0, !dbg !1167
  br i1 %13, label %bb8.preheader.i, label %bb16, !dbg !1167

bb8.preheader.i:                                  ; preds = %bb.i
  %14 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1168
  %15 = sext i8 %9 to i32, !dbg !1169
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %27, 24
  %16 = ashr exact i32 %sext.i, 24, !dbg !1169
  %17 = add nsw i32 %16, 65, !dbg !1169
  %18 = icmp eq i32 %15, %17, !dbg !1169
  br i1 %18, label %bb4.i, label %bb7.i, !dbg !1169

bb4.i:                                            ; preds = %bb3.i
  %19 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !1170
  %20 = zext i32 %27 to i64, !dbg !1170
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !1170
  %21 = getelementptr inbounds %struct.exe_disk_file_t* %19, i64 %20, i32 2, !dbg !1171
  %22 = load %struct.stat** %21, align 8, !dbg !1171
  %23 = getelementptr inbounds %struct.stat* %22, i64 0, i32 1, !dbg !1171
  %24 = load i64* %23, align 8, !dbg !1171
  %25 = icmp eq i64 %24, 0, !dbg !1171
  br i1 %25, label %bb16, label %__get_sym_file.exit, !dbg !1171

bb7.i:                                            ; preds = %bb3.i
  %26 = add i32 %27, 1, !dbg !1168
  br label %bb8.i, !dbg !1168

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %27 = phi i32 [ %26, %bb7.i ], [ 0, %bb8.preheader.i ]
  %28 = icmp ugt i32 %14, %27, !dbg !1168
  br i1 %28, label %bb3.i, label %bb16, !dbg !1168

__get_sym_file.exit:                              ; preds = %bb4.i
  %29 = getelementptr inbounds %struct.exe_disk_file_t* %19, i64 %20, !dbg !1170
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %29}, i64 0, metadata !447), !dbg !1165
  %30 = icmp eq %struct.exe_disk_file_t* %29, null, !dbg !1172
  br i1 %30, label %bb16, label %bb6, !dbg !1172

bb6:                                              ; preds = %__get_sym_file.exit
  %31 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 3, !dbg !1173
  store %struct.exe_disk_file_t* %29, %struct.exe_disk_file_t** %31, align 8, !dbg !1173
  %32 = and i32 %flags, 192
  switch i32 %32, label %bb12 [
    i32 192, label %bb8
    i32 128, label %bb11
  ]

bb8:                                              ; preds = %bb6
  %33 = tail call i32* @__errno_location() nounwind readnone, !dbg !1174
  store i32 17, i32* %33, align 4, !dbg !1174
  br label %bb25, !dbg !1175

bb11:                                             ; preds = %bb6
  tail call void @klee_warning(i8* getelementptr inbounds ([47 x i8]* @.str7, i64 0, i64 0)) nounwind, !dbg !1176
  %34 = tail call i32* @__errno_location() nounwind readnone, !dbg !1177
  store i32 13, i32* %34, align 4, !dbg !1177
  br label %bb25, !dbg !1178

bb12:                                             ; preds = %bb6
  %35 = load %struct.stat** %21, align 8, !dbg !1179
  tail call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !282), !dbg !1180
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %35}, i64 0, metadata !283), !dbg !1180
  %36 = getelementptr inbounds %struct.stat* %35, i64 0, i32 3, !dbg !1181
  %37 = load i32* %36, align 8, !dbg !1181
  tail call void @llvm.dbg.value(metadata !{i32 %37}, i64 0, metadata !287), !dbg !1181
  %38 = and i32 %flags, 2, !dbg !1182
  %39 = icmp eq i32 %38, 0, !dbg !1182
  %40 = and i32 %flags, 3
  %41 = icmp eq i32 %40, 0
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !284), !dbg !1183
  br i1 %39, label %bb9.i, label %bb7.i34, !dbg !1184

bb7.i34:                                          ; preds = %bb12
  %42 = and i32 %37, 292, !dbg !1184
  %43 = icmp eq i32 %42, 0, !dbg !1184
  br i1 %43, label %bb9.i, label %bb13, !dbg !1184

bb9.i:                                            ; preds = %bb7.i34, %bb12
  br i1 %41, label %bb14, label %bb10.i, !dbg !1185

bb10.i:                                           ; preds = %bb9.i
  %44 = and i32 %37, 146, !dbg !1185
  %45 = icmp eq i32 %44, 0, !dbg !1185
  br i1 %45, label %bb13, label %bb14, !dbg !1185

bb13:                                             ; preds = %bb7.i34, %bb10.i
  %46 = tail call i32* @__errno_location() nounwind readnone, !dbg !1186
  store i32 13, i32* %46, align 4, !dbg !1186
  br label %bb25, !dbg !1187

bb14:                                             ; preds = %bb10.i, %bb9.i
  %47 = and i32 %37, -512, !dbg !1188
  %48 = load i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i64 0, i32 1), align 8, !dbg !1188
  %not = xor i32 %48, -1, !dbg !1188
  %49 = and i32 %not, %mode, !dbg !1188
  %50 = or i32 %49, %47, !dbg !1188
  store i32 %50, i32* %36, align 8, !dbg !1188
  br label %bb19, !dbg !1188

bb16:                                             ; preds = %bb8.i, %bb4.i, %bb5, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !356) nounwind, !dbg !1189
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !346) nounwind, !dbg !1191
  %51 = ptrtoint i8* %pathname to i64, !dbg !1193
  %52 = tail call i64 @klee_get_valuel(i64 %51) nounwind, !dbg !1193
  %53 = inttoptr i64 %52 to i8*, !dbg !1193
  tail call void @llvm.dbg.value(metadata !{i8* %53}, i64 0, metadata !347) nounwind, !dbg !1193
  %54 = icmp eq i8* %53, %pathname, !dbg !1194
  %55 = zext i1 %54 to i64, !dbg !1194
  tail call void @klee_assume(i64 %55) nounwind, !dbg !1194
  tail call void @llvm.dbg.value(metadata !{i8* %53}, i64 0, metadata !357) nounwind, !dbg !1192
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !1195
  br label %bb.i30, !dbg !1195

bb.i30:                                           ; preds = %bb6.i32, %bb16
  %sc.0.i = phi i8* [ %53, %bb16 ], [ %sc.1.i, %bb6.i32 ]
  %56 = phi i32 [ 0, %bb16 ], [ %68, %bb6.i32 ]
  %tmp.i = add i32 %56, -1
  %57 = load i8* %sc.0.i, align 1, !dbg !1196
  %58 = and i32 %tmp.i, %56, !dbg !1197
  %59 = icmp eq i32 %58, 0, !dbg !1197
  br i1 %59, label %bb1.i, label %bb5.i, !dbg !1197

bb1.i:                                            ; preds = %bb.i30
  switch i8 %57, label %bb6.i32 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i31
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %57}, i64 0, metadata !360) nounwind, !dbg !1196
  store i8 0, i8* %sc.0.i, align 1, !dbg !1198
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !1198
  br label %__concretize_string.exit, !dbg !1198

bb4.i31:                                          ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !1199
  %60 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1199
  br label %bb6.i32, !dbg !1199

bb5.i:                                            ; preds = %bb.i30
  %61 = sext i8 %57 to i64, !dbg !1200
  %62 = tail call i64 @klee_get_valuel(i64 %61) nounwind, !dbg !1200
  %63 = trunc i64 %62 to i8, !dbg !1200
  %64 = icmp eq i8 %63, %57, !dbg !1201
  %65 = zext i1 %64 to i64, !dbg !1201
  tail call void @klee_assume(i64 %65) nounwind, !dbg !1201
  store i8 %63, i8* %sc.0.i, align 1, !dbg !1202
  %66 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1202
  %67 = icmp eq i8 %63, 0, !dbg !1203
  br i1 %67, label %__concretize_string.exit, label %bb6.i32, !dbg !1203

bb6.i32:                                          ; preds = %bb5.i, %bb4.i31, %bb1.i
  %sc.1.i = phi i8* [ %60, %bb4.i31 ], [ %66, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %68 = add i32 %56, 1, !dbg !1195
  br label %bb.i30, !dbg !1195

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %69 = tail call i64 (i64, ...)* @syscall(i64 2, i8* %pathname, i32 %flags, i32 %mode) nounwind, !dbg !1190
  %70 = trunc i64 %69 to i32, !dbg !1190
  tail call void @llvm.dbg.value(metadata !{i32 %70}, i64 0, metadata !451), !dbg !1190
  %71 = icmp eq i32 %70, -1, !dbg !1204
  br i1 %71, label %bb17, label %bb18, !dbg !1204

bb17:                                             ; preds = %__concretize_string.exit
  %72 = tail call i32* @__errno_location() nounwind readnone, !dbg !1205
  %73 = tail call i32 @klee_get_errno() nounwind, !dbg !1205
  store i32 %73, i32* %72, align 4, !dbg !1205
  br label %bb25, !dbg !1206

bb18:                                             ; preds = %__concretize_string.exit
  %74 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 0, !dbg !1207
  store i32 %70, i32* %74, align 8, !dbg !1207
  %.pre = and i32 %flags, 3, !dbg !1208
  br label %bb19, !dbg !1207

bb19:                                             ; preds = %bb18, %bb14
  %.pre-phi = phi i32 [ %.pre, %bb18 ], [ %40, %bb14 ]
  %75 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 1, !dbg !1209
  store i32 1, i32* %75, align 4, !dbg !1209
  switch i32 %.pre-phi, label %bb23 [
    i32 0, label %bb20
    i32 1, label %bb22
  ]

bb20:                                             ; preds = %bb19
  store i32 5, i32* %75, align 4, !dbg !1210
  br label %bb25, !dbg !1210

bb22:                                             ; preds = %bb19
  store i32 9, i32* %75, align 4, !dbg !1211
  br label %bb25, !dbg !1211

bb23:                                             ; preds = %bb19
  store i32 13, i32* %75, align 4, !dbg !1212
  br label %bb25, !dbg !1212

bb25:                                             ; preds = %bb20, %bb22, %bb23, %bb17, %bb13, %bb11, %bb8, %bb4
  %.0 = phi i32 [ -1, %bb4 ], [ -1, %bb8 ], [ -1, %bb11 ], [ -1, %bb13 ], [ -1, %bb17 ], [ %fd.0, %bb23 ], [ %fd.0, %bb22 ], [ %fd.0, %bb20 ]
  ret i32 %.0, !dbg !1161
}

define i32 @__fd_openat(i32 %basefd, i8* %pathname, i32 %flags, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %basefd}, i64 0, metadata !453), !dbg !1213
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !454), !dbg !1213
  tail call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !455), !dbg !1213
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !456), !dbg !1213
  %0 = icmp eq i32 %basefd, -100, !dbg !1214
  br i1 %0, label %bb5, label %bb, !dbg !1214

bb:                                               ; preds = %entry
  tail call void @llvm.dbg.value(metadata !{i32 %basefd}, i64 0, metadata !275), !dbg !1215
  %1 = icmp ult i32 %basefd, 32, !dbg !1217
  br i1 %1, label %bb.i, label %bb1, !dbg !1217

bb.i:                                             ; preds = %bb
  %2 = sext i32 %basefd to i64, !dbg !1218
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1218
  %3 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 1, !dbg !1219
  %4 = load i32* %3, align 4, !dbg !1219
  %5 = and i32 %4, 1
  %toBool.i = icmp eq i32 %5, 0, !dbg !1219
  br i1 %toBool.i, label %bb1, label %__get_file.exit, !dbg !1219

__get_file.exit:                                  ; preds = %bb.i
  %6 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, !dbg !1218
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %6}, i64 0, metadata !461), !dbg !1216
  %7 = icmp eq %struct.exe_file_t* %6, null, !dbg !1220
  br i1 %7, label %bb1, label %bb2, !dbg !1220

bb1:                                              ; preds = %bb, %bb.i, %__get_file.exit
  %8 = tail call i32* @__errno_location() nounwind readnone, !dbg !1221
  store i32 9, i32* %8, align 4, !dbg !1221
  br label %bb21, !dbg !1222

bb2:                                              ; preds = %__get_file.exit
  %9 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 3, !dbg !1223
  %10 = load %struct.exe_disk_file_t** %9, align 8, !dbg !1223
  %11 = icmp eq %struct.exe_disk_file_t* %10, null, !dbg !1223
  br i1 %11, label %bb4, label %bb3, !dbg !1223

bb3:                                              ; preds = %bb2
  tail call void @klee_warning(i8* getelementptr inbounds ([44 x i8]* @.str6, i64 0, i64 0)) nounwind, !dbg !1224
  %12 = tail call i32* @__errno_location() nounwind readnone, !dbg !1225
  store i32 2, i32* %12, align 4, !dbg !1225
  br label %bb21, !dbg !1226

bb4:                                              ; preds = %bb2
  %13 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 0, !dbg !1227
  %14 = load i32* %13, align 8, !dbg !1227
  tail call void @llvm.dbg.value(metadata !{i32 %14}, i64 0, metadata !453), !dbg !1227
  %phitmp = sext i32 %14 to i64
  br label %bb5, !dbg !1227

bb5:                                              ; preds = %entry, %bb4
  %basefd_addr.0 = phi i64 [ %phitmp, %bb4 ], [ -100, %entry ]
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !269), !dbg !1228
  %15 = load i8* %pathname, align 1, !dbg !1230
  tail call void @llvm.dbg.value(metadata !{i8 %15}, i64 0, metadata !270), !dbg !1230
  %16 = icmp eq i8 %15, 0, !dbg !1231
  br i1 %16, label %bb10, label %bb.i25, !dbg !1231

bb.i25:                                           ; preds = %bb5
  %17 = getelementptr inbounds i8* %pathname, i64 1, !dbg !1231
  %18 = load i8* %17, align 1, !dbg !1231
  %19 = icmp eq i8 %18, 0, !dbg !1231
  br i1 %19, label %bb8.preheader.i, label %bb10, !dbg !1231

bb8.preheader.i:                                  ; preds = %bb.i25
  %20 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1232
  %21 = sext i8 %15 to i32, !dbg !1233
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %33, 24
  %22 = ashr exact i32 %sext.i, 24, !dbg !1233
  %23 = add nsw i32 %22, 65, !dbg !1233
  %24 = icmp eq i32 %21, %23, !dbg !1233
  br i1 %24, label %bb4.i26, label %bb7.i, !dbg !1233

bb4.i26:                                          ; preds = %bb3.i
  %25 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !1234
  %26 = zext i32 %33 to i64, !dbg !1234
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !1234
  %27 = getelementptr inbounds %struct.exe_disk_file_t* %25, i64 %26, i32 2, !dbg !1235
  %28 = load %struct.stat** %27, align 8, !dbg !1235
  %29 = getelementptr inbounds %struct.stat* %28, i64 0, i32 1, !dbg !1235
  %30 = load i64* %29, align 8, !dbg !1235
  %31 = icmp eq i64 %30, 0, !dbg !1235
  br i1 %31, label %bb10, label %__get_sym_file.exit, !dbg !1235

bb7.i:                                            ; preds = %bb3.i
  %32 = add i32 %33, 1, !dbg !1232
  br label %bb8.i, !dbg !1232

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %33 = phi i32 [ %32, %bb7.i ], [ 0, %bb8.preheader.i ]
  %34 = icmp ugt i32 %20, %33, !dbg !1232
  br i1 %34, label %bb3.i, label %bb10, !dbg !1232

__get_sym_file.exit:                              ; preds = %bb4.i26
  %35 = getelementptr inbounds %struct.exe_disk_file_t* %25, i64 %26, !dbg !1234
  %36 = icmp eq %struct.exe_disk_file_t* %35, null, !dbg !1229
  br i1 %36, label %bb10, label %bb6, !dbg !1229

bb6:                                              ; preds = %__get_sym_file.exit
  %37 = tail call i32 @__fd_open(i8* %pathname, i32 %flags, i32 %mode) nounwind, !dbg !1236
  br label %bb21, !dbg !1236

bb8:                                              ; preds = %bb10
  %scevgep = getelementptr %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %indvar, i32 1
  %38 = load i32* %scevgep, align 4, !dbg !1237
  %39 = and i32 %38, 1, !dbg !1237
  %40 = icmp eq i32 %39, 0, !dbg !1237
  br i1 %40, label %bb13, label %bb9, !dbg !1237

bb9:                                              ; preds = %bb8
  %indvar.next = add i64 %indvar, 1
  br label %bb10, !dbg !1238

bb10:                                             ; preds = %bb4.i26, %bb5, %bb.i25, %__get_sym_file.exit, %bb8.i, %bb9
  %indvar = phi i64 [ %indvar.next, %bb9 ], [ 0, %bb8.i ], [ 0, %__get_sym_file.exit ], [ 0, %bb.i25 ], [ 0, %bb5 ], [ 0, %bb4.i26 ]
  %fd.0 = trunc i64 %indvar to i32
  %41 = icmp slt i32 %fd.0, 32, !dbg !1238
  br i1 %41, label %bb8, label %bb11, !dbg !1238

bb11:                                             ; preds = %bb10
  %42 = icmp eq i32 %fd.0, 32, !dbg !1239
  br i1 %42, label %bb12, label %bb13, !dbg !1239

bb12:                                             ; preds = %bb11
  %43 = tail call i32* @__errno_location() nounwind readnone, !dbg !1240
  store i32 24, i32* %43, align 4, !dbg !1240
  br label %bb21, !dbg !1241

bb13:                                             ; preds = %bb8, %bb11
  %44 = sext i32 %fd.0 to i64, !dbg !1242
  %45 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %44, !dbg !1242
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %45}, i64 0, metadata !457), !dbg !1242
  %46 = bitcast %struct.exe_file_t* %45 to i8*, !dbg !1243
  tail call void @llvm.memset.p0i8.i64(i8* %46, i8 0, i64 24, i32 8, i1 false), !dbg !1243
  %47 = sext i32 %flags to i64, !dbg !1244
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !356) nounwind, !dbg !1245
  tail call void @llvm.dbg.value(metadata !{i8* %pathname}, i64 0, metadata !346) nounwind, !dbg !1246
  %48 = ptrtoint i8* %pathname to i64, !dbg !1248
  %49 = tail call i64 @klee_get_valuel(i64 %48) nounwind, !dbg !1248
  %50 = inttoptr i64 %49 to i8*, !dbg !1248
  tail call void @llvm.dbg.value(metadata !{i8* %50}, i64 0, metadata !347) nounwind, !dbg !1248
  %51 = icmp eq i8* %50, %pathname, !dbg !1249
  %52 = zext i1 %51 to i64, !dbg !1249
  tail call void @klee_assume(i64 %52) nounwind, !dbg !1249
  tail call void @llvm.dbg.value(metadata !{i8* %50}, i64 0, metadata !357) nounwind, !dbg !1247
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !1250
  br label %bb.i23, !dbg !1250

bb.i23:                                           ; preds = %bb6.i, %bb13
  %sc.0.i = phi i8* [ %50, %bb13 ], [ %sc.1.i, %bb6.i ]
  %53 = phi i32 [ 0, %bb13 ], [ %65, %bb6.i ]
  %tmp.i = add i32 %53, -1
  %54 = load i8* %sc.0.i, align 1, !dbg !1251
  %55 = and i32 %tmp.i, %53, !dbg !1252
  %56 = icmp eq i32 %55, 0, !dbg !1252
  br i1 %56, label %bb1.i24, label %bb5.i, !dbg !1252

bb1.i24:                                          ; preds = %bb.i23
  switch i8 %54, label %bb6.i [
    i8 0, label %bb2.i
    i8 47, label %bb4.i
  ]

bb2.i:                                            ; preds = %bb1.i24
  tail call void @llvm.dbg.value(metadata !{i8 %54}, i64 0, metadata !360) nounwind, !dbg !1251
  store i8 0, i8* %sc.0.i, align 1, !dbg !1253
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !1253
  br label %__concretize_string.exit, !dbg !1253

bb4.i:                                            ; preds = %bb1.i24
  store i8 47, i8* %sc.0.i, align 1, !dbg !1254
  %57 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1254
  br label %bb6.i, !dbg !1254

bb5.i:                                            ; preds = %bb.i23
  %58 = sext i8 %54 to i64, !dbg !1255
  %59 = tail call i64 @klee_get_valuel(i64 %58) nounwind, !dbg !1255
  %60 = trunc i64 %59 to i8, !dbg !1255
  %61 = icmp eq i8 %60, %54, !dbg !1256
  %62 = zext i1 %61 to i64, !dbg !1256
  tail call void @klee_assume(i64 %62) nounwind, !dbg !1256
  store i8 %60, i8* %sc.0.i, align 1, !dbg !1257
  %63 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1257
  %64 = icmp eq i8 %60, 0, !dbg !1258
  br i1 %64, label %__concretize_string.exit, label %bb6.i, !dbg !1258

bb6.i:                                            ; preds = %bb5.i, %bb4.i, %bb1.i24
  %sc.1.i = phi i8* [ %57, %bb4.i ], [ %63, %bb5.i ], [ %sc.0.i, %bb1.i24 ]
  %65 = add i32 %53, 1, !dbg !1250
  br label %bb.i23, !dbg !1250

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %66 = tail call i64 (i64, ...)* @syscall(i64 257, i64 %basefd_addr.0, i8* %pathname, i64 %47, i32 %mode) nounwind, !dbg !1244
  %67 = trunc i64 %66 to i32, !dbg !1244
  tail call void @llvm.dbg.value(metadata !{i32 %67}, i64 0, metadata !460), !dbg !1244
  %68 = icmp eq i32 %67, -1, !dbg !1259
  br i1 %68, label %bb14, label %bb15, !dbg !1259

bb14:                                             ; preds = %__concretize_string.exit
  %69 = tail call i32* @__errno_location() nounwind readnone, !dbg !1260
  %70 = tail call i32 @klee_get_errno() nounwind, !dbg !1260
  store i32 %70, i32* %69, align 4, !dbg !1260
  br label %bb21, !dbg !1261

bb15:                                             ; preds = %__concretize_string.exit
  %71 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %44, i32 0, !dbg !1262
  store i32 %67, i32* %71, align 8, !dbg !1262
  %72 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %44, i32 1, !dbg !1263
  store i32 1, i32* %72, align 4, !dbg !1263
  %73 = and i32 %flags, 3, !dbg !1264
  switch i32 %73, label %bb19 [
    i32 0, label %bb16
    i32 1, label %bb18
  ]

bb16:                                             ; preds = %bb15
  store i32 5, i32* %72, align 4, !dbg !1265
  br label %bb21, !dbg !1265

bb18:                                             ; preds = %bb15
  store i32 9, i32* %72, align 4, !dbg !1266
  br label %bb21, !dbg !1266

bb19:                                             ; preds = %bb15
  store i32 13, i32* %72, align 4, !dbg !1267
  br label %bb21, !dbg !1267

bb21:                                             ; preds = %bb16, %bb18, %bb19, %bb14, %bb12, %bb6, %bb3, %bb1
  %.0 = phi i32 [ -1, %bb1 ], [ -1, %bb3 ], [ %37, %bb6 ], [ -1, %bb12 ], [ -1, %bb14 ], [ %fd.0, %bb19 ], [ %fd.0, %bb18 ], [ %fd.0, %bb16 ]
  ret i32 %.0, !dbg !1222
}

define i32 @fcntl(i32 %fd, i32 %cmd, ...) nounwind {
entry:
  %ap = alloca [1 x %struct.__va_list_tag], align 8
  call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !463), !dbg !1268
  call void @llvm.dbg.value(metadata !{i32 %cmd}, i64 0, metadata !464), !dbg !1268
  call void @llvm.dbg.declare(metadata !{[1 x %struct.__va_list_tag]* %ap}, metadata !467), !dbg !1269
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1270
  %0 = icmp ult i32 %fd, 32, !dbg !1272
  br i1 %0, label %bb.i, label %bb, !dbg !1272

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !1273
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1273
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !1274
  %3 = load i32* %2, align 4, !dbg !1274
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !1274
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1274

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !1273
  call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !465), !dbg !1271
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !1275
  br i1 %6, label %bb, label %bb1, !dbg !1275

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = call i32* @__errno_location() nounwind readnone, !dbg !1276
  store i32 9, i32* %7, align 4, !dbg !1276
  br label %bb35, !dbg !1277

bb1:                                              ; preds = %__get_file.exit
  switch i32 %cmd, label %bb8 [
    i32 3, label %bb21
    i32 1, label %bb21
    i32 11, label %bb21
    i32 9, label %bb21
  ]

bb8:                                              ; preds = %bb1
  %cmd.off = add i32 %cmd, -1025
  %8 = icmp ult i32 %cmd.off, 2
  br i1 %8, label %bb21, label %bb13, !dbg !1278

bb13:                                             ; preds = %bb8
  %ap1415 = bitcast [1 x %struct.__va_list_tag]* %ap to i8*, !dbg !1279
  call void @llvm.va_start(i8* %ap1415), !dbg !1279
  %9 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 0, !dbg !1280
  %10 = load i32* %9, align 8, !dbg !1280
  %11 = icmp ugt i32 %10, 47, !dbg !1280
  br i1 %11, label %bb17, label %bb16, !dbg !1280

bb16:                                             ; preds = %bb13
  %12 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 3, !dbg !1280
  %13 = load i8** %12, align 8, !dbg !1280
  %tmp = zext i32 %10 to i64
  %14 = ptrtoint i8* %13 to i64, !dbg !1280
  %15 = add i64 %14, %tmp, !dbg !1280
  %16 = inttoptr i64 %15 to i8*, !dbg !1280
  %17 = add i32 %10, 8, !dbg !1280
  store i32 %17, i32* %9, align 8, !dbg !1280
  br label %bb18, !dbg !1280

bb17:                                             ; preds = %bb13
  %18 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 2, !dbg !1280
  %19 = load i8** %18, align 8, !dbg !1280
  %20 = getelementptr inbounds i8* %19, i64 8, !dbg !1280
  store i8* %20, i8** %18, align 8, !dbg !1280
  br label %bb18, !dbg !1280

bb18:                                             ; preds = %bb17, %bb16
  %addr.50.0 = phi i8* [ %19, %bb17 ], [ %16, %bb16 ]
  %21 = bitcast i8* %addr.50.0 to i32*, !dbg !1280
  %22 = load i32* %21, align 4, !dbg !1280
  call void @llvm.dbg.value(metadata !{i32 %22}, i64 0, metadata !480), !dbg !1280
  call void @llvm.va_end(i8* %ap1415), !dbg !1281
  br label %bb21, !dbg !1281

bb21:                                             ; preds = %bb1, %bb1, %bb1, %bb1, %bb8, %bb18
  %arg.0 = phi i32 [ %22, %bb18 ], [ 0, %bb1 ], [ 0, %bb1 ], [ 0, %bb8 ], [ 0, %bb1 ], [ 0, %bb1 ]
  %23 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !1282
  %24 = load %struct.exe_disk_file_t** %23, align 8, !dbg !1282
  %25 = icmp eq %struct.exe_disk_file_t* %24, null, !dbg !1282
  br i1 %25, label %bb32, label %bb22, !dbg !1282

bb22:                                             ; preds = %bb21
  switch i32 %cmd, label %bb31 [
    i32 1, label %bb23
    i32 2, label %bb26
    i32 3, label %bb35
  ], !dbg !1283

bb23:                                             ; preds = %bb22
  call void @llvm.dbg.value(metadata !627, i64 0, metadata !481), !dbg !1284
  %26 = load i32* %2, align 4, !dbg !1285
  call void @llvm.dbg.value(metadata !1286, i64 0, metadata !481), !dbg !1287
  %27 = lshr i32 %26, 1
  %.lobit = and i32 %27, 1
  br label %bb35

bb26:                                             ; preds = %bb22
  %28 = load i32* %2, align 4, !dbg !1288
  %29 = and i32 %28, -3, !dbg !1288
  store i32 %29, i32* %2, align 4, !dbg !1288
  %30 = and i32 %arg.0, 1
  %toBool27 = icmp eq i32 %30, 0, !dbg !1289
  br i1 %toBool27, label %bb35, label %bb28, !dbg !1289

bb28:                                             ; preds = %bb26
  %31 = or i32 %28, 2, !dbg !1290
  store i32 %31, i32* %2, align 4, !dbg !1290
  br label %bb35, !dbg !1290

bb31:                                             ; preds = %bb22
  call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str8, i64 0, i64 0)) nounwind, !dbg !1291
  %32 = call i32* @__errno_location() nounwind readnone, !dbg !1292
  store i32 22, i32* %32, align 4, !dbg !1292
  br label %bb35, !dbg !1293

bb32:                                             ; preds = %bb21
  %33 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !1294
  %34 = load i32* %33, align 8, !dbg !1294
  %35 = call i64 (i64, ...)* @syscall(i64 72, i32 %34, i32 %cmd, i32 %arg.0) nounwind, !dbg !1294
  %36 = trunc i64 %35 to i32, !dbg !1294
  call void @llvm.dbg.value(metadata !{i32 %36}, i64 0, metadata !483), !dbg !1294
  %37 = icmp eq i32 %36, -1, !dbg !1295
  br i1 %37, label %bb33, label %bb35, !dbg !1295

bb33:                                             ; preds = %bb32
  %38 = call i32* @__errno_location() nounwind readnone, !dbg !1296
  %39 = call i32 @klee_get_errno() nounwind, !dbg !1296
  store i32 %39, i32* %38, align 4, !dbg !1296
  br label %bb35, !dbg !1296

bb35:                                             ; preds = %bb32, %bb33, %bb22, %bb28, %bb26, %bb23, %bb31, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb31 ], [ %.lobit, %bb23 ], [ 0, %bb26 ], [ 0, %bb28 ], [ 0, %bb22 ], [ -1, %bb33 ], [ %36, %bb32 ]
  ret i32 %.0, !dbg !1277
}

declare void @llvm.va_start(i8*) nounwind

declare void @llvm.va_end(i8*) nounwind

define i32 @ioctl(i32 %fd, i64 %request, ...) nounwind {
entry:
  %ap = alloca [1 x %struct.__va_list_tag], align 8
  call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !485), !dbg !1297
  call void @llvm.dbg.value(metadata !{i64 %request}, i64 0, metadata !486), !dbg !1297
  call void @llvm.dbg.declare(metadata !{[1 x %struct.__va_list_tag]* %ap}, metadata !489), !dbg !1298
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1299
  %0 = icmp ult i32 %fd, 32, !dbg !1301
  br i1 %0, label %bb.i, label %bb, !dbg !1301

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !1302
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1302
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !1303
  %3 = load i32* %2, align 4, !dbg !1303
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !1303
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1303

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !1302
  call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !487), !dbg !1300
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !1304
  br i1 %6, label %bb, label %bb1, !dbg !1304

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = call i32* @__errno_location() nounwind readnone, !dbg !1305
  store i32 9, i32* %7, align 4, !dbg !1305
  br label %bb39, !dbg !1306

bb1:                                              ; preds = %__get_file.exit
  %ap23 = bitcast [1 x %struct.__va_list_tag]* %ap to i8*, !dbg !1307
  call void @llvm.va_start(i8* %ap23), !dbg !1307
  %8 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 0, !dbg !1308
  %9 = load i32* %8, align 8, !dbg !1308
  %10 = icmp ugt i32 %9, 47, !dbg !1308
  br i1 %10, label %bb5, label %bb4, !dbg !1308

bb4:                                              ; preds = %bb1
  %11 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 3, !dbg !1308
  %12 = load i8** %11, align 8, !dbg !1308
  %tmp = zext i32 %9 to i64
  %13 = ptrtoint i8* %12 to i64, !dbg !1308
  %14 = add i64 %13, %tmp, !dbg !1308
  %15 = inttoptr i64 %14 to i8*, !dbg !1308
  %16 = add i32 %9, 8, !dbg !1308
  store i32 %16, i32* %8, align 8, !dbg !1308
  br label %bb6, !dbg !1308

bb5:                                              ; preds = %bb1
  %17 = getelementptr inbounds [1 x %struct.__va_list_tag]* %ap, i64 0, i64 0, i32 2, !dbg !1308
  %18 = load i8** %17, align 8, !dbg !1308
  %19 = getelementptr inbounds i8* %18, i64 8, !dbg !1308
  store i8* %19, i8** %17, align 8, !dbg !1308
  br label %bb6, !dbg !1308

bb6:                                              ; preds = %bb5, %bb4
  %addr.48.0 = phi i8* [ %18, %bb5 ], [ %15, %bb4 ]
  %20 = bitcast i8* %addr.48.0 to i8**, !dbg !1308
  %21 = load i8** %20, align 8, !dbg !1308
  call void @llvm.dbg.value(metadata !{i8* %21}, i64 0, metadata !490), !dbg !1308
  call void @llvm.va_end(i8* %ap23), !dbg !1309
  %22 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !1310
  %23 = load %struct.exe_disk_file_t** %22, align 8, !dbg !1310
  %24 = icmp eq %struct.exe_disk_file_t* %23, null, !dbg !1310
  br i1 %24, label %bb36, label %bb9, !dbg !1310

bb9:                                              ; preds = %bb6
  %25 = getelementptr inbounds %struct.exe_disk_file_t* %23, i64 0, i32 2, !dbg !1311
  %26 = load %struct.stat** %25, align 8, !dbg !1311
  call void @llvm.dbg.value(metadata !{%struct.stat* %26}, i64 0, metadata !491), !dbg !1311
  switch i64 %request, label %bb35 [
    i64 21505, label %bb10
    i64 21506, label %bb13
    i64 21507, label %bb16
    i64 21508, label %bb19
    i64 21523, label %bb22
    i64 21524, label %bb25
    i64 21531, label %bb28
    i64 2150657282, label %bb34
  ], !dbg !1312

bb10:                                             ; preds = %bb9
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !493), !dbg !1313
  call void @klee_warning_once(i8* getelementptr inbounds ([41 x i8]* @.str9, i64 0, i64 0)) nounwind, !dbg !1314
  %27 = getelementptr inbounds %struct.stat* %26, i64 0, i32 3, !dbg !1315
  %28 = load i32* %27, align 8, !dbg !1315
  %29 = and i32 %28, 61440, !dbg !1315
  %30 = icmp eq i32 %29, 8192, !dbg !1315
  br i1 %30, label %bb11, label %bb12, !dbg !1315

bb11:                                             ; preds = %bb10
  %31 = bitcast i8* %21 to i32*, !dbg !1316
  store i32 27906, i32* %31, align 4, !dbg !1316
  %32 = getelementptr inbounds i8* %21, i64 4
  %33 = bitcast i8* %32 to i32*, !dbg !1317
  store i32 5, i32* %33, align 4, !dbg !1317
  %34 = getelementptr inbounds i8* %21, i64 8
  %35 = bitcast i8* %34 to i32*, !dbg !1318
  store i32 1215, i32* %35, align 4, !dbg !1318
  %36 = getelementptr inbounds i8* %21, i64 12
  %37 = bitcast i8* %36 to i32*, !dbg !1319
  store i32 35287, i32* %37, align 4, !dbg !1319
  %38 = getelementptr inbounds i8* %21, i64 16
  store i8 0, i8* %38, align 4, !dbg !1320
  %39 = getelementptr inbounds i8* %21, i64 17
  store i8 3, i8* %39, align 1, !dbg !1321
  %40 = getelementptr inbounds i8* %21, i64 18, !dbg !1322
  store i8 28, i8* %40, align 1, !dbg !1322
  %41 = getelementptr inbounds i8* %21, i64 19, !dbg !1323
  store i8 127, i8* %41, align 1, !dbg !1323
  %42 = getelementptr inbounds i8* %21, i64 20, !dbg !1324
  store i8 21, i8* %42, align 1, !dbg !1324
  %43 = getelementptr inbounds i8* %21, i64 21, !dbg !1325
  store i8 4, i8* %43, align 1, !dbg !1325
  %44 = getelementptr inbounds i8* %21, i64 22, !dbg !1326
  store i8 0, i8* %44, align 1, !dbg !1326
  %45 = getelementptr inbounds i8* %21, i64 23, !dbg !1327
  store i8 1, i8* %45, align 1, !dbg !1327
  %46 = getelementptr inbounds i8* %21, i64 24, !dbg !1328
  store i8 -1, i8* %46, align 1, !dbg !1328
  %47 = getelementptr inbounds i8* %21, i64 25, !dbg !1329
  store i8 17, i8* %47, align 1, !dbg !1329
  %48 = getelementptr inbounds i8* %21, i64 26, !dbg !1330
  store i8 19, i8* %48, align 1, !dbg !1330
  %49 = getelementptr inbounds i8* %21, i64 27, !dbg !1331
  store i8 26, i8* %49, align 1, !dbg !1331
  %50 = getelementptr inbounds i8* %21, i64 28, !dbg !1332
  store i8 -1, i8* %50, align 1, !dbg !1332
  %51 = getelementptr inbounds i8* %21, i64 29, !dbg !1333
  store i8 18, i8* %51, align 1, !dbg !1333
  %52 = getelementptr inbounds i8* %21, i64 30, !dbg !1334
  store i8 15, i8* %52, align 1, !dbg !1334
  %53 = getelementptr inbounds i8* %21, i64 31, !dbg !1335
  store i8 23, i8* %53, align 1, !dbg !1335
  %54 = getelementptr inbounds i8* %21, i64 32, !dbg !1336
  store i8 22, i8* %54, align 1, !dbg !1336
  %55 = getelementptr inbounds i8* %21, i64 33, !dbg !1337
  store i8 -1, i8* %55, align 1, !dbg !1337
  %56 = getelementptr inbounds i8* %21, i64 34, !dbg !1338
  store i8 0, i8* %56, align 1, !dbg !1338
  %57 = getelementptr inbounds i8* %21, i64 35, !dbg !1339
  store i8 0, i8* %57, align 1, !dbg !1339
  br label %bb39, !dbg !1340

bb12:                                             ; preds = %bb10
  %58 = call i32* @__errno_location() nounwind readnone, !dbg !1341
  store i32 25, i32* %58, align 4, !dbg !1341
  br label %bb39, !dbg !1342

bb13:                                             ; preds = %bb9
  call void @klee_warning_once(i8* getelementptr inbounds ([42 x i8]* @.str10, i64 0, i64 0)) nounwind, !dbg !1343
  %59 = getelementptr inbounds %struct.stat* %26, i64 0, i32 3, !dbg !1344
  %60 = load i32* %59, align 8, !dbg !1344
  %61 = and i32 %60, 61440, !dbg !1344
  %62 = icmp eq i32 %61, 8192, !dbg !1344
  br i1 %62, label %bb39, label %bb15, !dbg !1344

bb15:                                             ; preds = %bb13
  %63 = call i32* @__errno_location() nounwind readnone, !dbg !1345
  store i32 25, i32* %63, align 4, !dbg !1345
  br label %bb39, !dbg !1346

bb16:                                             ; preds = %bb9
  call void @klee_warning_once(i8* getelementptr inbounds ([43 x i8]* @.str11, i64 0, i64 0)) nounwind, !dbg !1347
  %64 = icmp eq i32 %fd, 0, !dbg !1348
  br i1 %64, label %bb39, label %bb18, !dbg !1348

bb18:                                             ; preds = %bb16
  %65 = call i32* @__errno_location() nounwind readnone, !dbg !1349
  store i32 25, i32* %65, align 4, !dbg !1349
  br label %bb39, !dbg !1350

bb19:                                             ; preds = %bb9
  call void @klee_warning_once(i8* getelementptr inbounds ([43 x i8]* @.str12, i64 0, i64 0)) nounwind, !dbg !1351
  %66 = getelementptr inbounds %struct.stat* %26, i64 0, i32 3, !dbg !1352
  %67 = load i32* %66, align 8, !dbg !1352
  %68 = and i32 %67, 61440, !dbg !1352
  %69 = icmp eq i32 %68, 8192, !dbg !1352
  br i1 %69, label %bb39, label %bb21, !dbg !1352

bb21:                                             ; preds = %bb19
  %70 = call i32* @__errno_location() nounwind readnone, !dbg !1353
  store i32 25, i32* %70, align 4, !dbg !1353
  br label %bb39, !dbg !1354

bb22:                                             ; preds = %bb9
  call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !513), !dbg !1355
  %71 = bitcast i8* %21 to i16*, !dbg !1356
  store i16 24, i16* %71, align 2, !dbg !1356
  %72 = getelementptr inbounds i8* %21, i64 2
  %73 = bitcast i8* %72 to i16*, !dbg !1357
  store i16 80, i16* %73, align 2, !dbg !1357
  call void @klee_warning_once(i8* getelementptr inbounds ([45 x i8]* @.str13, i64 0, i64 0)) nounwind, !dbg !1358
  %74 = getelementptr inbounds %struct.stat* %26, i64 0, i32 3, !dbg !1359
  %75 = load i32* %74, align 8, !dbg !1359
  %76 = and i32 %75, 61440, !dbg !1359
  %77 = icmp eq i32 %76, 8192, !dbg !1359
  br i1 %77, label %bb39, label %bb24, !dbg !1359

bb24:                                             ; preds = %bb22
  %78 = call i32* @__errno_location() nounwind readnone, !dbg !1360
  store i32 25, i32* %78, align 4, !dbg !1360
  br label %bb39, !dbg !1361

bb25:                                             ; preds = %bb9
  call void @klee_warning_once(i8* getelementptr inbounds ([46 x i8]* @.str14, i64 0, i64 0)) nounwind, !dbg !1362
  %79 = getelementptr inbounds %struct.stat* %26, i64 0, i32 3, !dbg !1363
  %80 = load i32* %79, align 8, !dbg !1363
  %81 = and i32 %80, 61440, !dbg !1363
  %82 = icmp eq i32 %81, 8192, !dbg !1363
  %83 = call i32* @__errno_location() nounwind readnone, !dbg !1364
  br i1 %82, label %bb26, label %bb27, !dbg !1363

bb26:                                             ; preds = %bb25
  store i32 22, i32* %83, align 4, !dbg !1364
  br label %bb39, !dbg !1365

bb27:                                             ; preds = %bb25
  store i32 25, i32* %83, align 4, !dbg !1366
  br label %bb39, !dbg !1367

bb28:                                             ; preds = %bb9
  %84 = bitcast i8* %21 to i32*, !dbg !1368
  call void @llvm.dbg.value(metadata !{i32* %84}, i64 0, metadata !523), !dbg !1368
  call void @klee_warning_once(i8* getelementptr inbounds ([43 x i8]* @.str15, i64 0, i64 0)) nounwind, !dbg !1369
  %85 = getelementptr inbounds %struct.stat* %26, i64 0, i32 3, !dbg !1370
  %86 = load i32* %85, align 8, !dbg !1370
  %87 = and i32 %86, 61440, !dbg !1370
  %88 = icmp eq i32 %87, 8192, !dbg !1370
  br i1 %88, label %bb29, label %bb33, !dbg !1370

bb29:                                             ; preds = %bb28
  %89 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 2, !dbg !1371
  %90 = load i64* %89, align 8, !dbg !1371
  %91 = load %struct.exe_disk_file_t** %22, align 8, !dbg !1371
  %92 = getelementptr inbounds %struct.exe_disk_file_t* %91, i64 0, i32 0, !dbg !1371
  %93 = load i32* %92, align 8, !dbg !1371
  %94 = zext i32 %93 to i64, !dbg !1371
  %95 = icmp slt i64 %90, %94, !dbg !1371
  br i1 %95, label %bb30, label %bb32, !dbg !1371

bb30:                                             ; preds = %bb29
  %96 = trunc i64 %90 to i32, !dbg !1372
  %97 = sub i32 %93, %96, !dbg !1372
  br label %bb32, !dbg !1372

bb32:                                             ; preds = %bb29, %bb30
  %storemerge = phi i32 [ %97, %bb30 ], [ 0, %bb29 ]
  store i32 %storemerge, i32* %84, align 4
  br label %bb39, !dbg !1373

bb33:                                             ; preds = %bb28
  %98 = call i32* @__errno_location() nounwind readnone, !dbg !1374
  store i32 25, i32* %98, align 4, !dbg !1374
  br label %bb39, !dbg !1375

bb34:                                             ; preds = %bb9
  call void @klee_warning(i8* getelementptr inbounds ([44 x i8]* @.str16, i64 0, i64 0)) nounwind, !dbg !1376
  %99 = call i32* @__errno_location() nounwind readnone, !dbg !1377
  store i32 22, i32* %99, align 4, !dbg !1377
  br label %bb39, !dbg !1378

bb35:                                             ; preds = %bb9
  call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str8, i64 0, i64 0)) nounwind, !dbg !1379
  %100 = call i32* @__errno_location() nounwind readnone, !dbg !1380
  store i32 22, i32* %100, align 4, !dbg !1380
  br label %bb39, !dbg !1381

bb36:                                             ; preds = %bb6
  %101 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !1382
  %102 = load i32* %101, align 8, !dbg !1382
  %103 = call i64 (i64, ...)* @syscall(i64 16, i32 %102, i64 %request, i8* %21) nounwind, !dbg !1382
  %104 = trunc i64 %103 to i32, !dbg !1382
  call void @llvm.dbg.value(metadata !{i32 %104}, i64 0, metadata !526), !dbg !1382
  %105 = icmp eq i32 %104, -1, !dbg !1383
  br i1 %105, label %bb37, label %bb39, !dbg !1383

bb37:                                             ; preds = %bb36
  %106 = call i32* @__errno_location() nounwind readnone, !dbg !1384
  %107 = call i32 @klee_get_errno() nounwind, !dbg !1384
  store i32 %107, i32* %106, align 4, !dbg !1384
  br label %bb39, !dbg !1384

bb39:                                             ; preds = %bb36, %bb37, %bb22, %bb19, %bb16, %bb13, %bb35, %bb34, %bb33, %bb32, %bb27, %bb26, %bb24, %bb21, %bb18, %bb15, %bb12, %bb11, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb35 ], [ -1, %bb34 ], [ 0, %bb32 ], [ -1, %bb33 ], [ -1, %bb26 ], [ -1, %bb27 ], [ -1, %bb24 ], [ -1, %bb21 ], [ -1, %bb18 ], [ -1, %bb15 ], [ 0, %bb11 ], [ -1, %bb12 ], [ 0, %bb13 ], [ 0, %bb16 ], [ 0, %bb19 ], [ 0, %bb22 ], [ -1, %bb37 ], [ %104, %bb36 ]
  ret i32 %.0, !dbg !1306
}

declare void @klee_warning_once(i8*)

define i32 @__fd_getdents(i32 %fd, %struct.dirent64* %dirp, i32 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !528), !dbg !1385
  tail call void @llvm.dbg.value(metadata !{%struct.dirent64* %dirp}, i64 0, metadata !529), !dbg !1385
  tail call void @llvm.dbg.value(metadata !{i32 %count}, i64 0, metadata !530), !dbg !1385
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1386
  %0 = icmp ult i32 %fd, 32, !dbg !1388
  br i1 %0, label %bb.i, label %bb, !dbg !1388

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !1389
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1389
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !1390
  %3 = load i32* %2, align 4, !dbg !1390
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !1390
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1390

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !1389
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !531), !dbg !1387
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !1391
  br i1 %6, label %bb, label %bb1, !dbg !1391

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !1392
  store i32 9, i32* %7, align 4, !dbg !1392
  br label %bb19, !dbg !1393

bb1:                                              ; preds = %__get_file.exit
  %8 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !1394
  %9 = load %struct.exe_disk_file_t** %8, align 8, !dbg !1394
  %10 = icmp eq %struct.exe_disk_file_t* %9, null, !dbg !1394
  br i1 %10, label %bb3, label %bb2, !dbg !1394

bb2:                                              ; preds = %bb1
  tail call void @klee_warning(i8* getelementptr inbounds ([33 x i8]* @.str8, i64 0, i64 0)) nounwind, !dbg !1395
  %11 = tail call i32* @__errno_location() nounwind readnone, !dbg !1396
  store i32 22, i32* %11, align 4, !dbg !1396
  br label %bb19, !dbg !1397

bb3:                                              ; preds = %bb1
  %12 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 2, !dbg !1398
  %13 = load i64* %12, align 8, !dbg !1398
  %14 = icmp ult i64 %13, 4096, !dbg !1398
  br i1 %14, label %bb4, label %bb11, !dbg !1398

bb4:                                              ; preds = %bb3
  tail call void @llvm.dbg.value(metadata !1399, i64 0, metadata !536), !dbg !1400
  %15 = udiv i64 %13, 280, !dbg !1401
  tail call void @llvm.dbg.value(metadata !{i64 %15}, i64 0, metadata !533), !dbg !1401
  %16 = mul i64 %15, 280, !dbg !1402
  %17 = icmp eq i64 %16, %13, !dbg !1402
  br i1 %17, label %bb5, label %bb6, !dbg !1402

bb5:                                              ; preds = %bb4
  %18 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1402
  %19 = zext i32 %18 to i64, !dbg !1402
  %20 = icmp ult i64 %19, %15, !dbg !1402
  br i1 %20, label %bb6, label %bb8.preheader, !dbg !1402

bb8.preheader:                                    ; preds = %bb5
  %21 = icmp ugt i64 %19, %15, !dbg !1403
  br i1 %21, label %bb7.lr.ph, label %bb9, !dbg !1403

bb7.lr.ph:                                        ; preds = %bb8.preheader
  %tmp39 = add i64 %15, 65
  %tmp48 = add i64 %16, 280
  %tmp50 = add i64 %15, 1
  br label %bb7

bb6:                                              ; preds = %bb4, %bb5
  %22 = tail call i32* @__errno_location() nounwind readnone, !dbg !1404
  store i32 22, i32* %22, align 4, !dbg !1404
  br label %bb19, !dbg !1405

bb7:                                              ; preds = %bb7.lr.ph, %bb7
  %indvar = phi i64 [ 0, %bb7.lr.ph ], [ %indvar.next, %bb7 ]
  %bytes.025 = phi i64 [ 0, %bb7.lr.ph ], [ %32, %bb7 ]
  %scevgep29 = getelementptr inbounds %struct.dirent64* %dirp, i64 %indvar, i32 0
  %scevgep30 = getelementptr %struct.dirent64* %dirp, i64 %indvar, i32 2
  %scevgep31 = getelementptr %struct.dirent64* %dirp, i64 %indvar, i32 3
  %scevgep32 = getelementptr %struct.dirent64* %dirp, i64 %indvar, i32 1
  %scevgep35 = getelementptr %struct.dirent64* %dirp, i64 %indvar, i32 4, i64 0
  %scevgep36 = getelementptr %struct.dirent64* %dirp, i64 %indvar, i32 4, i64 1
  %tmp41 = add i64 %tmp39, %indvar
  %tmp42 = trunc i64 %tmp41 to i8
  %tmp43 = add i64 %15, %indvar
  %tmp46 = mul i64 %indvar, 280
  %tmp49 = add i64 %tmp48, %tmp46
  %tmp51 = add i64 %tmp50, %indvar
  %23 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !1406
  %scevgep45 = getelementptr %struct.exe_disk_file_t* %23, i64 %tmp43, i32 2
  %24 = load %struct.stat** %scevgep45, align 8, !dbg !1407
  %25 = getelementptr inbounds %struct.stat* %24, i64 0, i32 1, !dbg !1407
  %26 = load i64* %25, align 8, !dbg !1407
  store i64 %26, i64* %scevgep29, align 8, !dbg !1407
  store i16 280, i16* %scevgep30, align 8, !dbg !1408
  %27 = load %struct.stat** %scevgep45, align 8, !dbg !1409
  %28 = getelementptr inbounds %struct.stat* %27, i64 0, i32 3, !dbg !1409
  %29 = load i32* %28, align 8, !dbg !1409
  %30 = lshr i32 %29, 12
  %.tr = trunc i32 %30 to i8
  %31 = and i8 %.tr, 15, !dbg !1409
  store i8 %31, i8* %scevgep31, align 2, !dbg !1409
  store i8 %tmp42, i8* %scevgep35, align 1, !dbg !1410
  store i8 0, i8* %scevgep36, align 1, !dbg !1411
  store i64 %tmp49, i64* %scevgep32, align 8, !dbg !1412
  %32 = add nsw i64 %bytes.025, 280, !dbg !1413
  %33 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1403
  %34 = zext i32 %33 to i64, !dbg !1403
  %35 = icmp sgt i64 %34, %tmp51, !dbg !1403
  %indvar.next = add i64 %indvar, 1
  br i1 %35, label %bb7, label %bb8.bb9_crit_edge, !dbg !1403

bb8.bb9_crit_edge:                                ; preds = %bb7
  %scevgep34 = getelementptr %struct.dirent64* %dirp, i64 %indvar.next
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !537), !dbg !1406
  tail call void @llvm.dbg.value(metadata !{i64 %32}, i64 0, metadata !536), !dbg !1413
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !529), !dbg !1414
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !533), !dbg !1403
  br label %bb9

bb9:                                              ; preds = %bb8.bb9_crit_edge, %bb8.preheader
  %dirp_addr.0.lcssa = phi %struct.dirent64* [ %scevgep34, %bb8.bb9_crit_edge ], [ %dirp, %bb8.preheader ]
  %bytes.0.lcssa = phi i64 [ %32, %bb8.bb9_crit_edge ], [ 0, %bb8.preheader ]
  %36 = icmp ugt i32 %count, 4096, !dbg !1415
  %37 = zext i32 %count to i64
  %38 = select i1 %36, i64 4096, i64 %37, !dbg !1415
  tail call void @llvm.dbg.value(metadata !{i64 %38}, i64 0, metadata !535), !dbg !1415
  %39 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i64 0, i32 0, !dbg !1416
  store i64 0, i64* %39, align 8, !dbg !1416
  %40 = trunc i64 %38 to i16, !dbg !1417
  %41 = trunc i64 %bytes.0.lcssa to i16, !dbg !1417
  %42 = sub i16 %40, %41, !dbg !1417
  %43 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i64 0, i32 2, !dbg !1417
  store i16 %42, i16* %43, align 8, !dbg !1417
  %44 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i64 0, i32 3, !dbg !1418
  store i8 0, i8* %44, align 2, !dbg !1418
  %45 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i64 0, i32 4, i64 0, !dbg !1419
  store i8 0, i8* %45, align 1, !dbg !1419
  %46 = getelementptr inbounds %struct.dirent64* %dirp_addr.0.lcssa, i64 0, i32 1, !dbg !1420
  store i64 4096, i64* %46, align 8, !dbg !1420
  %47 = zext i16 %42 to i64, !dbg !1421
  %48 = add nsw i64 %47, %bytes.0.lcssa, !dbg !1421
  tail call void @llvm.dbg.value(metadata !{i64 %48}, i64 0, metadata !536), !dbg !1421
  store i64 %38, i64* %12, align 8, !dbg !1422
  %49 = trunc i64 %48 to i32, !dbg !1423
  br label %bb19, !dbg !1423

bb11:                                             ; preds = %bb3
  %50 = add nsw i64 %13, -4096, !dbg !1424
  tail call void @llvm.dbg.value(metadata !{i64 %50}, i64 0, metadata !539), !dbg !1424
  tail call void @llvm.dbg.value(metadata !1399, i64 0, metadata !542), !dbg !1425
  %51 = zext i32 %count to i64, !dbg !1426
  %52 = bitcast %struct.dirent64* %dirp to i8*, !dbg !1426
  tail call void @llvm.memset.p0i8.i64(i8* %52, i8 0, i64 %51, i32 8, i1 false), !dbg !1426
  %53 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !1427
  %54 = load i32* %53, align 8, !dbg !1427
  %55 = tail call i64 (i64, ...)* @syscall(i64 8, i32 %54, i64 %50, i32 0) nounwind, !dbg !1427
  tail call void @llvm.dbg.value(metadata !{i64 %55}, i64 0, metadata !542), !dbg !1427
  %56 = icmp eq i64 %55, -1, !dbg !1428
  br i1 %56, label %bb12, label %bb13, !dbg !1428

bb12:                                             ; preds = %bb11
  tail call void @__assert_fail(i8* getelementptr inbounds ([18 x i8]* @.str17, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str18, i64 0, i64 0), i32 875, i8* getelementptr inbounds ([14 x i8]* @__PRETTY_FUNCTION__.5329, i64 0, i64 0)) noreturn nounwind, !dbg !1428
  unreachable, !dbg !1428

bb13:                                             ; preds = %bb11
  %57 = load i32* %53, align 8, !dbg !1429
  %58 = tail call i64 (i64, ...)* @syscall(i64 217, i32 %57, %struct.dirent64* %dirp, i32 %count) nounwind, !dbg !1429
  %59 = trunc i64 %58 to i32, !dbg !1429
  tail call void @llvm.dbg.value(metadata !{i32 %59}, i64 0, metadata !541), !dbg !1429
  %60 = icmp eq i32 %59, -1, !dbg !1430
  br i1 %60, label %bb14, label %bb15, !dbg !1430

bb14:                                             ; preds = %bb13
  %61 = tail call i32* @__errno_location() nounwind readnone, !dbg !1431
  %62 = tail call i32 @klee_get_errno() nounwind, !dbg !1431
  store i32 %62, i32* %61, align 4, !dbg !1431
  br label %bb19, !dbg !1431

bb15:                                             ; preds = %bb13
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !543), !dbg !1432
  %63 = load i32* %53, align 8, !dbg !1433
  %64 = tail call i64 (i64, ...)* @syscall(i64 8, i32 %63, i32 0, i32 1) nounwind, !dbg !1433
  %65 = add nsw i64 %64, 4096, !dbg !1433
  store i64 %65, i64* %12, align 8, !dbg !1433
  %66 = icmp sgt i32 %59, 0, !dbg !1434
  br i1 %66, label %bb16, label %bb19, !dbg !1434

bb16:                                             ; preds = %bb15, %bb16
  %pos.023 = phi i32 [ %76, %bb16 ], [ 0, %bb15 ]
  %67 = sext i32 %pos.023 to i64, !dbg !1435
  %.sum = add i64 %67, 8
  %68 = getelementptr inbounds i8* %52, i64 %.sum
  %69 = bitcast i8* %68 to i64*, !dbg !1436
  %70 = load i64* %69, align 8, !dbg !1436
  %71 = add nsw i64 %70, 4096, !dbg !1436
  store i64 %71, i64* %69, align 8, !dbg !1436
  %.sum22 = add i64 %67, 16
  %72 = getelementptr inbounds i8* %52, i64 %.sum22
  %73 = bitcast i8* %72 to i16*, !dbg !1437
  %74 = load i16* %73, align 8, !dbg !1437
  %75 = zext i16 %74 to i32, !dbg !1437
  %76 = add nsw i32 %75, %pos.023, !dbg !1437
  %77 = icmp slt i32 %76, %59, !dbg !1434
  br i1 %77, label %bb16, label %bb19, !dbg !1434

bb19:                                             ; preds = %bb15, %bb16, %bb14, %bb9, %bb6, %bb2, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb2 ], [ -1, %bb6 ], [ %49, %bb9 ], [ -1, %bb14 ], [ %59, %bb16 ], [ %59, %bb15 ]
  ret i32 %.0, !dbg !1393
}

declare void @__assert_fail(i8*, i8*, i32, i8*) noreturn nounwind

define i64 @__fd_lseek(i32 %fd, i64 %offset, i32 %whence) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !547), !dbg !1438
  tail call void @llvm.dbg.value(metadata !{i64 %offset}, i64 0, metadata !548), !dbg !1438
  tail call void @llvm.dbg.value(metadata !{i32 %whence}, i64 0, metadata !549), !dbg !1438
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1439
  %0 = icmp ult i32 %fd, 32, !dbg !1441
  br i1 %0, label %bb.i, label %bb, !dbg !1441

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !1442
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1442
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !1443
  %3 = load i32* %2, align 4, !dbg !1443
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !1443
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1443

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !1442
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !552), !dbg !1440
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !1444
  br i1 %6, label %bb, label %bb1, !dbg !1444

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !1445
  store i32 9, i32* %7, align 4, !dbg !1445
  br label %bb19, !dbg !1446

bb1:                                              ; preds = %__get_file.exit
  %8 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !1447
  %9 = load %struct.exe_disk_file_t** %8, align 8, !dbg !1447
  %10 = icmp eq %struct.exe_disk_file_t* %9, null, !dbg !1447
  br i1 %10, label %bb2, label %bb11, !dbg !1447

bb2:                                              ; preds = %bb1
  %11 = icmp eq i32 %whence, 0, !dbg !1448
  br i1 %11, label %bb3, label %bb4, !dbg !1448

bb3:                                              ; preds = %bb2
  %12 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !1449
  %13 = load i32* %12, align 8, !dbg !1449
  %14 = tail call i64 (i64, ...)* @syscall(i64 8, i32 %13, i64 %offset, i32 0) nounwind, !dbg !1449
  tail call void @llvm.dbg.value(metadata !{i64 %14}, i64 0, metadata !550), !dbg !1449
  br label %bb8, !dbg !1449

bb4:                                              ; preds = %bb2
  %15 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 2, !dbg !1450
  %16 = load i64* %15, align 8, !dbg !1450
  %17 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !1450
  %18 = load i32* %17, align 8, !dbg !1450
  %19 = tail call i64 (i64, ...)* @syscall(i64 8, i32 %18, i64 %16, i32 0) nounwind, !dbg !1450
  tail call void @llvm.dbg.value(metadata !{i64 %19}, i64 0, metadata !550), !dbg !1450
  %20 = icmp eq i64 %19, -1, !dbg !1451
  br i1 %20, label %bb9, label %bb5, !dbg !1451

bb5:                                              ; preds = %bb4
  %21 = load i64* %15, align 8, !dbg !1452
  %22 = icmp eq i64 %21, %19, !dbg !1452
  br i1 %22, label %bb7, label %bb6, !dbg !1452

bb6:                                              ; preds = %bb5
  tail call void @__assert_fail(i8* getelementptr inbounds ([18 x i8]* @.str19, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str18, i64 0, i64 0), i32 499, i8* getelementptr inbounds ([11 x i8]* @__PRETTY_FUNCTION__.5053, i64 0, i64 0)) noreturn nounwind, !dbg !1452
  unreachable, !dbg !1452

bb7:                                              ; preds = %bb5
  %23 = load i32* %17, align 8, !dbg !1453
  %24 = tail call i64 (i64, ...)* @syscall(i64 8, i32 %23, i64 %offset, i32 %whence) nounwind, !dbg !1453
  tail call void @llvm.dbg.value(metadata !{i64 %24}, i64 0, metadata !550), !dbg !1453
  br label %bb8, !dbg !1453

bb8:                                              ; preds = %bb7, %bb3
  %new_off.0 = phi i64 [ %14, %bb3 ], [ %24, %bb7 ]
  %25 = icmp eq i64 %new_off.0, -1, !dbg !1454
  br i1 %25, label %bb9, label %bb10, !dbg !1454

bb9:                                              ; preds = %bb4, %bb8
  %26 = tail call i32* @__errno_location() nounwind readnone, !dbg !1455
  %27 = tail call i32 @klee_get_errno() nounwind, !dbg !1455
  store i32 %27, i32* %26, align 4, !dbg !1455
  br label %bb19, !dbg !1456

bb10:                                             ; preds = %bb8
  %28 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 2, !dbg !1457
  store i64 %new_off.0, i64* %28, align 8, !dbg !1457
  br label %bb19, !dbg !1458

bb11:                                             ; preds = %bb1
  switch i32 %whence, label %bb15 [
    i32 0, label %bb16
    i32 1, label %bb13
    i32 2, label %bb14
  ], !dbg !1459

bb13:                                             ; preds = %bb11
  %29 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 2, !dbg !1460
  %30 = load i64* %29, align 8, !dbg !1460
  %31 = add nsw i64 %30, %offset, !dbg !1460
  tail call void @llvm.dbg.value(metadata !{i64 %31}, i64 0, metadata !550), !dbg !1460
  br label %bb16, !dbg !1460

bb14:                                             ; preds = %bb11
  %32 = getelementptr inbounds %struct.exe_disk_file_t* %9, i64 0, i32 0, !dbg !1461
  %33 = load i32* %32, align 8, !dbg !1461
  %34 = zext i32 %33 to i64, !dbg !1461
  %35 = add nsw i64 %34, %offset, !dbg !1461
  tail call void @llvm.dbg.value(metadata !{i64 %35}, i64 0, metadata !550), !dbg !1461
  br label %bb16, !dbg !1461

bb15:                                             ; preds = %bb11
  %36 = tail call i32* @__errno_location() nounwind readnone, !dbg !1462
  store i32 22, i32* %36, align 4, !dbg !1462
  br label %bb19, !dbg !1463

bb16:                                             ; preds = %bb11, %bb14, %bb13
  %new_off.1 = phi i64 [ %35, %bb14 ], [ %31, %bb13 ], [ %offset, %bb11 ]
  %37 = icmp slt i64 %new_off.1, 0, !dbg !1464
  br i1 %37, label %bb17, label %bb18, !dbg !1464

bb17:                                             ; preds = %bb16
  %38 = tail call i32* @__errno_location() nounwind readnone, !dbg !1465
  store i32 22, i32* %38, align 4, !dbg !1465
  br label %bb19, !dbg !1466

bb18:                                             ; preds = %bb16
  %39 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 2, !dbg !1467
  store i64 %new_off.1, i64* %39, align 8, !dbg !1467
  br label %bb19, !dbg !1468

bb19:                                             ; preds = %bb18, %bb17, %bb15, %bb10, %bb9, %bb
  %.0 = phi i64 [ -1, %bb ], [ -1, %bb9 ], [ %new_off.0, %bb10 ], [ -1, %bb15 ], [ -1, %bb17 ], [ %new_off.1, %bb18 ]
  ret i64 %.0, !dbg !1446
}

define i32 @__fd_fstat(i32 %fd, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !553), !dbg !1469
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !554), !dbg !1469
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1470
  %0 = icmp ult i32 %fd, 32, !dbg !1472
  br i1 %0, label %bb.i, label %bb, !dbg !1472

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !1473
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1473
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !1474
  %3 = load i32* %2, align 4, !dbg !1474
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !1474
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1474

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !1473
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !555), !dbg !1471
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !1475
  br i1 %6, label %bb, label %bb1, !dbg !1475

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !1476
  store i32 9, i32* %7, align 4, !dbg !1476
  br label %bb6, !dbg !1477

bb1:                                              ; preds = %__get_file.exit
  %8 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !1478
  %9 = load %struct.exe_disk_file_t** %8, align 8, !dbg !1478
  %10 = icmp eq %struct.exe_disk_file_t* %9, null, !dbg !1478
  br i1 %10, label %bb2, label %bb5, !dbg !1478

bb2:                                              ; preds = %bb1
  %11 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !1479
  %12 = load i32* %11, align 8, !dbg !1479
  %13 = tail call i64 (i64, ...)* @syscall(i64 5, i32 %12, %struct.stat* %buf) nounwind, !dbg !1479
  %14 = trunc i64 %13 to i32, !dbg !1479
  tail call void @llvm.dbg.value(metadata !{i32 %14}, i64 0, metadata !557), !dbg !1479
  %15 = icmp eq i32 %14, -1, !dbg !1480
  br i1 %15, label %bb3, label %bb6, !dbg !1480

bb3:                                              ; preds = %bb2
  %16 = tail call i32* @__errno_location() nounwind readnone, !dbg !1481
  %17 = tail call i32 @klee_get_errno() nounwind, !dbg !1481
  store i32 %17, i32* %16, align 4, !dbg !1481
  br label %bb6, !dbg !1481

bb5:                                              ; preds = %bb1
  %18 = getelementptr inbounds %struct.exe_disk_file_t* %9, i64 0, i32 2, !dbg !1482
  %19 = load %struct.stat** %18, align 8, !dbg !1482
  %20 = bitcast %struct.stat* %buf to i8*, !dbg !1482
  %21 = bitcast %struct.stat* %19 to i8*, !dbg !1482
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %20, i8* %21, i64 144, i32 8, i1 false), !dbg !1482
  br label %bb6, !dbg !1483

bb6:                                              ; preds = %bb2, %bb3, %bb5, %bb
  %.0 = phi i32 [ -1, %bb ], [ 0, %bb5 ], [ -1, %bb3 ], [ %14, %bb2 ]
  ret i32 %.0, !dbg !1477
}

define i32 @__fd_lstat(i8* %path, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !559), !dbg !1484
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !560), !dbg !1484
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !1485
  %0 = load i8* %path, align 1, !dbg !1487
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !1487
  %1 = icmp eq i8 %0, 0, !dbg !1488
  br i1 %1, label %bb1, label %bb.i, !dbg !1488

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !1488
  %3 = load i8* %2, align 1, !dbg !1488
  %4 = icmp eq i8 %3, 0, !dbg !1488
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !1488

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1489
  %6 = sext i8 %0 to i32, !dbg !1490
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !1490
  %8 = add nsw i32 %7, 65, !dbg !1490
  %9 = icmp eq i32 %6, %8, !dbg !1490
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !1490

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !1491
  %11 = zext i32 %18 to i64, !dbg !1491
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !1491
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !1492
  %13 = load %struct.stat** %12, align 8, !dbg !1492
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !1492
  %15 = load i64* %14, align 8, !dbg !1492
  %16 = icmp eq i64 %15, 0, !dbg !1492
  br i1 %16, label %bb1, label %__get_sym_file.exit, !dbg !1492

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !1489
  br label %bb8.i, !dbg !1489

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !1489
  br i1 %19, label %bb3.i, label %bb1, !dbg !1489

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !1491
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !561), !dbg !1486
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !1493
  br i1 %21, label %bb1, label %bb, !dbg !1493

bb:                                               ; preds = %__get_sym_file.exit
  %22 = bitcast %struct.stat* %buf to i8*, !dbg !1494
  %23 = bitcast %struct.stat* %13 to i8*, !dbg !1494
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %22, i8* %23, i64 144, i32 8, i1 false), !dbg !1494
  br label %bb4, !dbg !1495

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !1496
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !1498
  %24 = ptrtoint i8* %path to i64, !dbg !1500
  %25 = tail call i64 @klee_get_valuel(i64 %24) nounwind, !dbg !1500
  %26 = inttoptr i64 %25 to i8*, !dbg !1500
  tail call void @llvm.dbg.value(metadata !{i8* %26}, i64 0, metadata !347) nounwind, !dbg !1500
  %27 = icmp eq i8* %26, %path, !dbg !1501
  %28 = zext i1 %27 to i64, !dbg !1501
  tail call void @klee_assume(i64 %28) nounwind, !dbg !1501
  tail call void @llvm.dbg.value(metadata !{i8* %26}, i64 0, metadata !357) nounwind, !dbg !1499
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !1502
  br label %bb.i6, !dbg !1502

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %26, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %29 = phi i32 [ 0, %bb1 ], [ %41, %bb6.i8 ]
  %tmp.i = add i32 %29, -1
  %30 = load i8* %sc.0.i, align 1, !dbg !1503
  %31 = and i32 %tmp.i, %29, !dbg !1504
  %32 = icmp eq i32 %31, 0, !dbg !1504
  br i1 %32, label %bb1.i, label %bb5.i, !dbg !1504

bb1.i:                                            ; preds = %bb.i6
  switch i8 %30, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %30}, i64 0, metadata !360) nounwind, !dbg !1503
  store i8 0, i8* %sc.0.i, align 1, !dbg !1505
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !1505
  br label %__concretize_string.exit, !dbg !1505

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !1506
  %33 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1506
  br label %bb6.i8, !dbg !1506

bb5.i:                                            ; preds = %bb.i6
  %34 = sext i8 %30 to i64, !dbg !1507
  %35 = tail call i64 @klee_get_valuel(i64 %34) nounwind, !dbg !1507
  %36 = trunc i64 %35 to i8, !dbg !1507
  %37 = icmp eq i8 %36, %30, !dbg !1508
  %38 = zext i1 %37 to i64, !dbg !1508
  tail call void @klee_assume(i64 %38) nounwind, !dbg !1508
  store i8 %36, i8* %sc.0.i, align 1, !dbg !1509
  %39 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1509
  %40 = icmp eq i8 %36, 0, !dbg !1510
  br i1 %40, label %__concretize_string.exit, label %bb6.i8, !dbg !1510

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %33, %bb4.i7 ], [ %39, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %41 = add i32 %29, 1, !dbg !1502
  br label %bb.i6, !dbg !1502

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %42 = tail call i64 (i64, ...)* @syscall(i64 6, i8* %path, %struct.stat* %buf) nounwind, !dbg !1497
  %43 = trunc i64 %42 to i32, !dbg !1497
  tail call void @llvm.dbg.value(metadata !{i32 %43}, i64 0, metadata !563), !dbg !1497
  %44 = icmp eq i32 %43, -1, !dbg !1511
  br i1 %44, label %bb2, label %bb4, !dbg !1511

bb2:                                              ; preds = %__concretize_string.exit
  %45 = tail call i32* @__errno_location() nounwind readnone, !dbg !1512
  %46 = tail call i32 @klee_get_errno() nounwind, !dbg !1512
  store i32 %46, i32* %45, align 4, !dbg !1512
  br label %bb4, !dbg !1512

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ 0, %bb ], [ -1, %bb2 ], [ %43, %__concretize_string.exit ]
  ret i32 %.0, !dbg !1495
}

define i32 @fstatat(i32 %fd, i8* %path, %struct.stat* %buf, i32 %flags) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !565), !dbg !1513
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !566), !dbg !1513
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !567), !dbg !1513
  tail call void @llvm.dbg.value(metadata !{i32 %flags}, i64 0, metadata !568), !dbg !1513
  %0 = icmp eq i32 %fd, -100, !dbg !1514
  br i1 %0, label %bb5, label %bb, !dbg !1514

bb:                                               ; preds = %entry
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1515
  %1 = icmp ult i32 %fd, 32, !dbg !1517
  br i1 %1, label %bb.i, label %bb1, !dbg !1517

bb.i:                                             ; preds = %bb
  %2 = sext i32 %fd to i64, !dbg !1518
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1518
  %3 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 1, !dbg !1519
  %4 = load i32* %3, align 4, !dbg !1519
  %5 = and i32 %4, 1
  %toBool.i = icmp eq i32 %5, 0, !dbg !1519
  br i1 %toBool.i, label %bb1, label %__get_file.exit, !dbg !1519

__get_file.exit:                                  ; preds = %bb.i
  %6 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, !dbg !1518
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %6}, i64 0, metadata !572), !dbg !1516
  %7 = icmp eq %struct.exe_file_t* %6, null, !dbg !1520
  br i1 %7, label %bb1, label %bb2, !dbg !1520

bb1:                                              ; preds = %bb, %bb.i, %__get_file.exit
  %8 = tail call i32* @__errno_location() nounwind readnone, !dbg !1521
  store i32 9, i32* %8, align 4, !dbg !1521
  br label %bb13, !dbg !1522

bb2:                                              ; preds = %__get_file.exit
  %9 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 3, !dbg !1523
  %10 = load %struct.exe_disk_file_t** %9, align 8, !dbg !1523
  %11 = icmp eq %struct.exe_disk_file_t* %10, null, !dbg !1523
  br i1 %11, label %bb4, label %bb3, !dbg !1523

bb3:                                              ; preds = %bb2
  tail call void @klee_warning(i8* getelementptr inbounds ([44 x i8]* @.str6, i64 0, i64 0)) nounwind, !dbg !1524
  %12 = tail call i32* @__errno_location() nounwind readnone, !dbg !1525
  store i32 2, i32* %12, align 4, !dbg !1525
  br label %bb13, !dbg !1526

bb4:                                              ; preds = %bb2
  %13 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %2, i32 0, !dbg !1527
  %14 = load i32* %13, align 8, !dbg !1527
  tail call void @llvm.dbg.value(metadata !{i32 %14}, i64 0, metadata !565), !dbg !1527
  %phitmp = sext i32 %14 to i64
  br label %bb5, !dbg !1527

bb5:                                              ; preds = %entry, %bb4
  %fd_addr.0 = phi i64 [ %phitmp, %bb4 ], [ -100, %entry ]
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !1528
  %15 = load i8* %path, align 1, !dbg !1530
  tail call void @llvm.dbg.value(metadata !{i8 %15}, i64 0, metadata !270), !dbg !1530
  %16 = icmp eq i8 %15, 0, !dbg !1531
  br i1 %16, label %bb7, label %bb.i17, !dbg !1531

bb.i17:                                           ; preds = %bb5
  %17 = getelementptr inbounds i8* %path, i64 1, !dbg !1531
  %18 = load i8* %17, align 1, !dbg !1531
  %19 = icmp eq i8 %18, 0, !dbg !1531
  br i1 %19, label %bb8.preheader.i, label %bb7, !dbg !1531

bb8.preheader.i:                                  ; preds = %bb.i17
  %20 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1532
  %21 = sext i8 %15 to i32, !dbg !1533
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %33, 24
  %22 = ashr exact i32 %sext.i, 24, !dbg !1533
  %23 = add nsw i32 %22, 65, !dbg !1533
  %24 = icmp eq i32 %21, %23, !dbg !1533
  br i1 %24, label %bb4.i18, label %bb7.i, !dbg !1533

bb4.i18:                                          ; preds = %bb3.i
  %25 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !1534
  %26 = zext i32 %33 to i64, !dbg !1534
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !1534
  %27 = getelementptr inbounds %struct.exe_disk_file_t* %25, i64 %26, i32 2, !dbg !1535
  %28 = load %struct.stat** %27, align 8, !dbg !1535
  %29 = getelementptr inbounds %struct.stat* %28, i64 0, i32 1, !dbg !1535
  %30 = load i64* %29, align 8, !dbg !1535
  %31 = icmp eq i64 %30, 0, !dbg !1535
  br i1 %31, label %bb7, label %__get_sym_file.exit, !dbg !1535

bb7.i:                                            ; preds = %bb3.i
  %32 = add i32 %33, 1, !dbg !1532
  br label %bb8.i, !dbg !1532

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %33 = phi i32 [ %32, %bb7.i ], [ 0, %bb8.preheader.i ]
  %34 = icmp ugt i32 %20, %33, !dbg !1532
  br i1 %34, label %bb3.i, label %bb7, !dbg !1532

__get_sym_file.exit:                              ; preds = %bb4.i18
  %35 = getelementptr inbounds %struct.exe_disk_file_t* %25, i64 %26, !dbg !1534
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %35}, i64 0, metadata !569), !dbg !1529
  %36 = icmp eq %struct.exe_disk_file_t* %35, null, !dbg !1536
  br i1 %36, label %bb7, label %bb6, !dbg !1536

bb6:                                              ; preds = %__get_sym_file.exit
  %37 = bitcast %struct.stat* %buf to i8*, !dbg !1537
  %38 = bitcast %struct.stat* %28 to i8*, !dbg !1537
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %37, i8* %38, i64 144, i32 8, i1 false), !dbg !1537
  br label %bb13, !dbg !1538

bb7:                                              ; preds = %bb8.i, %bb4.i18, %bb5, %bb.i17, %__get_sym_file.exit
  %39 = sext i32 %flags to i64, !dbg !1539
  %40 = icmp eq i8* %path, null, !dbg !1539
  br i1 %40, label %bb10, label %bb8, !dbg !1539

bb8:                                              ; preds = %bb7
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !1540
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !1541
  %41 = ptrtoint i8* %path to i64, !dbg !1543
  %42 = tail call i64 @klee_get_valuel(i64 %41) nounwind, !dbg !1543
  %43 = inttoptr i64 %42 to i8*, !dbg !1543
  tail call void @llvm.dbg.value(metadata !{i8* %43}, i64 0, metadata !347) nounwind, !dbg !1543
  %44 = icmp eq i8* %43, %path, !dbg !1544
  %45 = zext i1 %44 to i64, !dbg !1544
  tail call void @klee_assume(i64 %45) nounwind, !dbg !1544
  tail call void @llvm.dbg.value(metadata !{i8* %43}, i64 0, metadata !357) nounwind, !dbg !1542
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !1545
  br label %bb.i15, !dbg !1545

bb.i15:                                           ; preds = %bb6.i, %bb8
  %sc.0.i = phi i8* [ %43, %bb8 ], [ %sc.1.i, %bb6.i ]
  %46 = phi i32 [ 0, %bb8 ], [ %58, %bb6.i ]
  %tmp.i = add i32 %46, -1
  %47 = load i8* %sc.0.i, align 1, !dbg !1546
  %48 = and i32 %tmp.i, %46, !dbg !1547
  %49 = icmp eq i32 %48, 0, !dbg !1547
  br i1 %49, label %bb1.i16, label %bb5.i, !dbg !1547

bb1.i16:                                          ; preds = %bb.i15
  switch i8 %47, label %bb6.i [
    i8 0, label %bb2.i
    i8 47, label %bb4.i
  ]

bb2.i:                                            ; preds = %bb1.i16
  tail call void @llvm.dbg.value(metadata !{i8 %47}, i64 0, metadata !360) nounwind, !dbg !1546
  store i8 0, i8* %sc.0.i, align 1, !dbg !1548
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !1548
  br label %bb10, !dbg !1548

bb4.i:                                            ; preds = %bb1.i16
  store i8 47, i8* %sc.0.i, align 1, !dbg !1549
  %50 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1549
  br label %bb6.i, !dbg !1549

bb5.i:                                            ; preds = %bb.i15
  %51 = sext i8 %47 to i64, !dbg !1550
  %52 = tail call i64 @klee_get_valuel(i64 %51) nounwind, !dbg !1550
  %53 = trunc i64 %52 to i8, !dbg !1550
  %54 = icmp eq i8 %53, %47, !dbg !1551
  %55 = zext i1 %54 to i64, !dbg !1551
  tail call void @klee_assume(i64 %55) nounwind, !dbg !1551
  store i8 %53, i8* %sc.0.i, align 1, !dbg !1552
  %56 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1552
  %57 = icmp eq i8 %53, 0, !dbg !1553
  br i1 %57, label %bb10, label %bb6.i, !dbg !1553

bb6.i:                                            ; preds = %bb5.i, %bb4.i, %bb1.i16
  %sc.1.i = phi i8* [ %50, %bb4.i ], [ %56, %bb5.i ], [ %sc.0.i, %bb1.i16 ]
  %58 = add i32 %46, 1, !dbg !1545
  br label %bb.i15, !dbg !1545

bb10:                                             ; preds = %bb5.i, %bb2.i, %bb7
  %iftmp.38.0 = phi i8* [ null, %bb7 ], [ %path, %bb2.i ], [ %path, %bb5.i ]
  %59 = tail call i64 (i64, ...)* @syscall(i64 262, i64 %fd_addr.0, i8* %iftmp.38.0, %struct.stat* %buf, i64 %39) nounwind, !dbg !1539
  %60 = trunc i64 %59 to i32, !dbg !1539
  tail call void @llvm.dbg.value(metadata !{i32 %60}, i64 0, metadata !571), !dbg !1539
  %61 = icmp eq i32 %60, -1, !dbg !1554
  br i1 %61, label %bb11, label %bb13, !dbg !1554

bb11:                                             ; preds = %bb10
  %62 = tail call i32* @__errno_location() nounwind readnone, !dbg !1555
  %63 = tail call i32 @klee_get_errno() nounwind, !dbg !1555
  store i32 %63, i32* %62, align 4, !dbg !1555
  br label %bb13, !dbg !1555

bb13:                                             ; preds = %bb10, %bb11, %bb6, %bb3, %bb1
  %.0 = phi i32 [ -1, %bb1 ], [ -1, %bb3 ], [ 0, %bb6 ], [ -1, %bb11 ], [ %60, %bb10 ]
  ret i32 %.0, !dbg !1522
}

define i32 @__fd_stat(i8* %path, %struct.stat* %buf) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !574), !dbg !1556
  tail call void @llvm.dbg.value(metadata !{%struct.stat* %buf}, i64 0, metadata !575), !dbg !1556
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !1557
  %0 = load i8* %path, align 1, !dbg !1559
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !1559
  %1 = icmp eq i8 %0, 0, !dbg !1560
  br i1 %1, label %bb1, label %bb.i, !dbg !1560

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !1560
  %3 = load i8* %2, align 1, !dbg !1560
  %4 = icmp eq i8 %3, 0, !dbg !1560
  br i1 %4, label %bb8.preheader.i, label %bb1, !dbg !1560

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1561
  %6 = sext i8 %0 to i32, !dbg !1562
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %18, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !1562
  %8 = add nsw i32 %7, 65, !dbg !1562
  %9 = icmp eq i32 %6, %8, !dbg !1562
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !1562

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !1563
  %11 = zext i32 %18 to i64, !dbg !1563
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !1563
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !1564
  %13 = load %struct.stat** %12, align 8, !dbg !1564
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !1564
  %15 = load i64* %14, align 8, !dbg !1564
  %16 = icmp eq i64 %15, 0, !dbg !1564
  br i1 %16, label %bb1, label %__get_sym_file.exit, !dbg !1564

bb7.i:                                            ; preds = %bb3.i
  %17 = add i32 %18, 1, !dbg !1561
  br label %bb8.i, !dbg !1561

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %18 = phi i32 [ %17, %bb7.i ], [ 0, %bb8.preheader.i ]
  %19 = icmp ugt i32 %5, %18, !dbg !1561
  br i1 %19, label %bb3.i, label %bb1, !dbg !1561

__get_sym_file.exit:                              ; preds = %bb4.i
  %20 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !1563
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %20}, i64 0, metadata !576), !dbg !1558
  %21 = icmp eq %struct.exe_disk_file_t* %20, null, !dbg !1565
  br i1 %21, label %bb1, label %bb, !dbg !1565

bb:                                               ; preds = %__get_sym_file.exit
  %22 = bitcast %struct.stat* %buf to i8*, !dbg !1566
  %23 = bitcast %struct.stat* %13 to i8*, !dbg !1566
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %22, i8* %23, i64 144, i32 8, i1 false), !dbg !1566
  br label %bb4, !dbg !1567

bb1:                                              ; preds = %bb8.i, %bb4.i, %entry, %bb.i, %__get_sym_file.exit
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !1568
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !1570
  %24 = ptrtoint i8* %path to i64, !dbg !1572
  %25 = tail call i64 @klee_get_valuel(i64 %24) nounwind, !dbg !1572
  %26 = inttoptr i64 %25 to i8*, !dbg !1572
  tail call void @llvm.dbg.value(metadata !{i8* %26}, i64 0, metadata !347) nounwind, !dbg !1572
  %27 = icmp eq i8* %26, %path, !dbg !1573
  %28 = zext i1 %27 to i64, !dbg !1573
  tail call void @klee_assume(i64 %28) nounwind, !dbg !1573
  tail call void @llvm.dbg.value(metadata !{i8* %26}, i64 0, metadata !357) nounwind, !dbg !1571
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !1574
  br label %bb.i6, !dbg !1574

bb.i6:                                            ; preds = %bb6.i8, %bb1
  %sc.0.i = phi i8* [ %26, %bb1 ], [ %sc.1.i, %bb6.i8 ]
  %29 = phi i32 [ 0, %bb1 ], [ %41, %bb6.i8 ]
  %tmp.i = add i32 %29, -1
  %30 = load i8* %sc.0.i, align 1, !dbg !1575
  %31 = and i32 %tmp.i, %29, !dbg !1576
  %32 = icmp eq i32 %31, 0, !dbg !1576
  br i1 %32, label %bb1.i, label %bb5.i, !dbg !1576

bb1.i:                                            ; preds = %bb.i6
  switch i8 %30, label %bb6.i8 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i7
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %30}, i64 0, metadata !360) nounwind, !dbg !1575
  store i8 0, i8* %sc.0.i, align 1, !dbg !1577
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !1577
  br label %__concretize_string.exit, !dbg !1577

bb4.i7:                                           ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !1578
  %33 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1578
  br label %bb6.i8, !dbg !1578

bb5.i:                                            ; preds = %bb.i6
  %34 = sext i8 %30 to i64, !dbg !1579
  %35 = tail call i64 @klee_get_valuel(i64 %34) nounwind, !dbg !1579
  %36 = trunc i64 %35 to i8, !dbg !1579
  %37 = icmp eq i8 %36, %30, !dbg !1580
  %38 = zext i1 %37 to i64, !dbg !1580
  tail call void @klee_assume(i64 %38) nounwind, !dbg !1580
  store i8 %36, i8* %sc.0.i, align 1, !dbg !1581
  %39 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1581
  %40 = icmp eq i8 %36, 0, !dbg !1582
  br i1 %40, label %__concretize_string.exit, label %bb6.i8, !dbg !1582

bb6.i8:                                           ; preds = %bb5.i, %bb4.i7, %bb1.i
  %sc.1.i = phi i8* [ %33, %bb4.i7 ], [ %39, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %41 = add i32 %29, 1, !dbg !1574
  br label %bb.i6, !dbg !1574

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %42 = tail call i64 (i64, ...)* @syscall(i64 4, i8* %path, %struct.stat* %buf) nounwind, !dbg !1569
  %43 = trunc i64 %42 to i32, !dbg !1569
  tail call void @llvm.dbg.value(metadata !{i32 %43}, i64 0, metadata !578), !dbg !1569
  %44 = icmp eq i32 %43, -1, !dbg !1583
  br i1 %44, label %bb2, label %bb4, !dbg !1583

bb2:                                              ; preds = %__concretize_string.exit
  %45 = tail call i32* @__errno_location() nounwind readnone, !dbg !1584
  %46 = tail call i32 @klee_get_errno() nounwind, !dbg !1584
  store i32 %46, i32* %45, align 4, !dbg !1584
  br label %bb4, !dbg !1584

bb4:                                              ; preds = %__concretize_string.exit, %bb2, %bb
  %.0 = phi i32 [ 0, %bb ], [ -1, %bb2 ], [ %43, %__concretize_string.exit ]
  ret i32 %.0, !dbg !1567
}

define i64 @write(i32 %fd, i8* %buf, i64 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !580), !dbg !1585
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !581), !dbg !1585
  tail call void @llvm.dbg.value(metadata !{i64 %count}, i64 0, metadata !582), !dbg !1585
  %0 = load i32* @n_calls.4981, align 4, !dbg !1586
  %1 = add nsw i32 %0, 1, !dbg !1586
  store i32 %1, i32* @n_calls.4981, align 4, !dbg !1586
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1587
  %2 = icmp ult i32 %fd, 32, !dbg !1589
  br i1 %2, label %bb.i, label %bb, !dbg !1589

bb.i:                                             ; preds = %entry
  %3 = sext i32 %fd to i64, !dbg !1590
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1590
  %4 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, i32 1, !dbg !1591
  %5 = load i32* %4, align 4, !dbg !1591
  %6 = and i32 %5, 1
  %toBool.i = icmp eq i32 %6, 0, !dbg !1591
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1591

__get_file.exit:                                  ; preds = %bb.i
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, !dbg !1590
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %7}, i64 0, metadata !583), !dbg !1588
  %8 = icmp eq %struct.exe_file_t* %7, null, !dbg !1592
  br i1 %8, label %bb, label %bb1, !dbg !1592

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %9 = tail call i32* @__errno_location() nounwind readnone, !dbg !1593
  store i32 9, i32* %9, align 4, !dbg !1593
  br label %bb28, !dbg !1594

bb1:                                              ; preds = %__get_file.exit
  %10 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1595
  %11 = icmp eq i32 %10, 0, !dbg !1595
  br i1 %11, label %bb4, label %bb2, !dbg !1595

bb2:                                              ; preds = %bb1
  %12 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 7), align 8, !dbg !1595
  %13 = load i32* %12, align 4, !dbg !1595
  %14 = icmp eq i32 %13, %1, !dbg !1595
  br i1 %14, label %bb3, label %bb4, !dbg !1595

bb3:                                              ; preds = %bb2
  %15 = add i32 %10, -1, !dbg !1596
  store i32 %15, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1596
  %16 = tail call i32* @__errno_location() nounwind readnone, !dbg !1597
  store i32 5, i32* %16, align 4, !dbg !1597
  br label %bb28, !dbg !1598

bb4:                                              ; preds = %bb1, %bb2
  %17 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, i32 3, !dbg !1599
  %18 = load %struct.exe_disk_file_t** %17, align 8, !dbg !1599
  %19 = icmp eq %struct.exe_disk_file_t* %18, null, !dbg !1599
  br i1 %19, label %bb5, label %bb15, !dbg !1599

bb5:                                              ; preds = %bb4
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !346) nounwind, !dbg !1600
  %20 = ptrtoint i8* %buf to i64, !dbg !1602
  %21 = tail call i64 @klee_get_valuel(i64 %20) nounwind, !dbg !1602
  %22 = inttoptr i64 %21 to i8*, !dbg !1602
  tail call void @llvm.dbg.value(metadata !{i8* %22}, i64 0, metadata !347) nounwind, !dbg !1602
  %23 = icmp eq i8* %22, %buf, !dbg !1603
  %24 = zext i1 %23 to i64, !dbg !1603
  tail call void @klee_assume(i64 %24) nounwind, !dbg !1603
  tail call void @llvm.dbg.value(metadata !{i8* %22}, i64 0, metadata !581), !dbg !1601
  tail call void @llvm.dbg.value(metadata !{i64 %count}, i64 0, metadata !349) nounwind, !dbg !1604
  %25 = tail call i64 @klee_get_valuel(i64 %count) nounwind, !dbg !1606
  tail call void @llvm.dbg.value(metadata !{i64 %25}, i64 0, metadata !350) nounwind, !dbg !1606
  %26 = icmp eq i64 %25, %count, !dbg !1607
  %27 = zext i1 %26 to i64, !dbg !1607
  tail call void @klee_assume(i64 %27) nounwind, !dbg !1607
  tail call void @llvm.dbg.value(metadata !{i64 %25}, i64 0, metadata !582), !dbg !1605
  tail call void @klee_check_memory_access(i8* %22, i64 %25) nounwind, !dbg !1608
  %28 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, i32 0, !dbg !1609
  %29 = load i32* %28, align 8, !dbg !1609
  %30 = add i32 %29, -1, !dbg !1609
  %31 = icmp ult i32 %30, 2, !dbg !1609
  br i1 %31, label %bb6, label %bb7, !dbg !1609

bb6:                                              ; preds = %bb5
  %32 = tail call i64 (i64, ...)* @syscall(i64 1, i32 %29, i8* %22, i64 %25) nounwind, !dbg !1610
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !585), !dbg !1610
  br label %bb8, !dbg !1610

bb7:                                              ; preds = %bb5
  %33 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, i32 2, !dbg !1611
  %34 = load i64* %33, align 8, !dbg !1611
  %35 = tail call i64 (i64, ...)* @syscall(i64 18, i32 %29, i8* %22, i64 %25, i64 %34) nounwind, !dbg !1611
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !585), !dbg !1611
  br label %bb8, !dbg !1611

bb8:                                              ; preds = %bb7, %bb6
  %r.0.in = phi i64 [ %32, %bb6 ], [ %35, %bb7 ]
  %r.0 = trunc i64 %r.0.in to i32
  %36 = icmp eq i32 %r.0, -1, !dbg !1612
  br i1 %36, label %bb9, label %bb10, !dbg !1612

bb9:                                              ; preds = %bb8
  %37 = tail call i32* @__errno_location() nounwind readnone, !dbg !1613
  %38 = tail call i32 @klee_get_errno() nounwind, !dbg !1613
  store i32 %38, i32* %37, align 4, !dbg !1613
  br label %bb28, !dbg !1614

bb10:                                             ; preds = %bb8
  %39 = icmp slt i32 %r.0, 0, !dbg !1615
  br i1 %39, label %bb11, label %bb12, !dbg !1615

bb11:                                             ; preds = %bb10
  tail call void @__assert_fail(i8* getelementptr inbounds ([7 x i8]* @.str20, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str18, i64 0, i64 0), i32 440, i8* getelementptr inbounds ([6 x i8]* @__PRETTY_FUNCTION__.4984, i64 0, i64 0)) noreturn nounwind, !dbg !1615
  unreachable, !dbg !1615

bb12:                                             ; preds = %bb10
  %40 = load i32* %28, align 8, !dbg !1616
  %41 = add i32 %40, -1, !dbg !1616
  %42 = icmp ugt i32 %41, 1, !dbg !1616
  br i1 %42, label %bb13, label %bb12.bb14_crit_edge, !dbg !1616

bb12.bb14_crit_edge:                              ; preds = %bb12
  %.pre = sext i32 %r.0 to i64, !dbg !1617
  br label %bb28

bb13:                                             ; preds = %bb12
  %43 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, i32 2, !dbg !1618
  %44 = load i64* %43, align 8, !dbg !1618
  %45 = sext i32 %r.0 to i64, !dbg !1618
  %46 = add nsw i64 %44, %45, !dbg !1618
  store i64 %46, i64* %43, align 8, !dbg !1618
  br label %bb28, !dbg !1618

bb15:                                             ; preds = %bb4
  tail call void @llvm.dbg.value(metadata !1399, i64 0, metadata !587), !dbg !1619
  %47 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %3, i32 2, !dbg !1620
  %48 = load i64* %47, align 8, !dbg !1620
  %49 = add i64 %48, %count, !dbg !1620
  %50 = getelementptr inbounds %struct.exe_disk_file_t* %18, i64 0, i32 0, !dbg !1620
  %51 = load i32* %50, align 8, !dbg !1620
  %52 = zext i32 %51 to i64, !dbg !1620
  %53 = icmp ugt i64 %49, %52, !dbg !1620
  br i1 %53, label %bb17, label %bb21, !dbg !1620

bb17:                                             ; preds = %bb15
  %54 = load i32* getelementptr inbounds (%struct.exe_sym_env_t* @__exe_env, i64 0, i32 3), align 8, !dbg !1621
  %55 = icmp eq i32 %54, 0, !dbg !1621
  br i1 %55, label %bb19, label %bb18, !dbg !1621

bb18:                                             ; preds = %bb17
  tail call void @__assert_fail(i8* getelementptr inbounds ([2 x i8]* @.str21, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str18, i64 0, i64 0), i32 453, i8* getelementptr inbounds ([6 x i8]* @__PRETTY_FUNCTION__.4984, i64 0, i64 0)) noreturn nounwind, !dbg !1622
  unreachable, !dbg !1622

bb19:                                             ; preds = %bb17
  %56 = icmp slt i64 %48, %52, !dbg !1623
  br i1 %56, label %bb20, label %bb23, !dbg !1623

bb20:                                             ; preds = %bb19
  %57 = sub nsw i64 %52, %48, !dbg !1624
  tail call void @llvm.dbg.value(metadata !{i64 %57}, i64 0, metadata !587), !dbg !1624
  br label %bb21, !dbg !1624

bb21:                                             ; preds = %bb15, %bb20
  %actual_count.0 = phi i64 [ %57, %bb20 ], [ %count, %bb15 ]
  %58 = icmp eq i64 %actual_count.0, 0, !dbg !1625
  br i1 %58, label %bb23, label %bb22, !dbg !1625

bb22:                                             ; preds = %bb21
  %59 = getelementptr inbounds %struct.exe_disk_file_t* %18, i64 0, i32 1, !dbg !1626
  %60 = load i8** %59, align 8, !dbg !1626
  %61 = getelementptr inbounds i8* %60, i64 %48, !dbg !1626
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %61, i8* %buf, i64 %actual_count.0, i32 1, i1 false), !dbg !1626
  br label %bb23, !dbg !1626

bb23:                                             ; preds = %bb19, %bb21, %bb22
  %actual_count.030 = phi i64 [ 0, %bb21 ], [ %actual_count.0, %bb22 ], [ 0, %bb19 ]
  %62 = icmp eq i64 %actual_count.030, %count, !dbg !1627
  br i1 %62, label %bb25, label %bb24, !dbg !1627

bb24:                                             ; preds = %bb23
  tail call void @klee_warning(i8* getelementptr inbounds ([24 x i8]* @.str22, i64 0, i64 0)) nounwind, !dbg !1628
  br label %bb25, !dbg !1628

bb25:                                             ; preds = %bb23, %bb24
  %63 = load %struct.exe_disk_file_t** %17, align 8, !dbg !1629
  %64 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 2), align 8, !dbg !1629
  %65 = icmp eq %struct.exe_disk_file_t* %63, %64, !dbg !1629
  br i1 %65, label %bb26, label %bb27, !dbg !1629

bb26:                                             ; preds = %bb25
  %66 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 3), align 8, !dbg !1630
  %67 = trunc i64 %actual_count.030 to i32, !dbg !1630
  %68 = add i32 %66, %67, !dbg !1630
  store i32 %68, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 3), align 8, !dbg !1630
  br label %bb27, !dbg !1630

bb27:                                             ; preds = %bb25, %bb26
  %69 = load i64* %47, align 8, !dbg !1631
  %70 = add i64 %69, %count, !dbg !1631
  store i64 %70, i64* %47, align 8, !dbg !1631
  br label %bb28, !dbg !1632

bb28:                                             ; preds = %bb13, %bb12.bb14_crit_edge, %bb27, %bb9, %bb3, %bb
  %.0 = phi i64 [ -1, %bb ], [ -1, %bb3 ], [ -1, %bb9 ], [ %count, %bb27 ], [ %.pre, %bb12.bb14_crit_edge ], [ %45, %bb13 ]
  ret i64 %.0, !dbg !1594
}

define i64 @read(i32 %fd, i8* %buf, i64 %count) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !589), !dbg !1633
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !590), !dbg !1633
  tail call void @llvm.dbg.value(metadata !{i64 %count}, i64 0, metadata !591), !dbg !1633
  %0 = load i32* @n_calls.4920, align 4, !dbg !1634
  %1 = add nsw i32 %0, 1, !dbg !1634
  store i32 %1, i32* @n_calls.4920, align 4, !dbg !1634
  %2 = icmp eq i64 %count, 0, !dbg !1635
  br i1 %2, label %bb24, label %bb1, !dbg !1635

bb1:                                              ; preds = %entry
  %3 = icmp eq i8* %buf, null, !dbg !1636
  br i1 %3, label %bb2, label %bb3, !dbg !1636

bb2:                                              ; preds = %bb1
  %4 = tail call i32* @__errno_location() nounwind readnone, !dbg !1637
  store i32 14, i32* %4, align 4, !dbg !1637
  br label %bb24, !dbg !1638

bb3:                                              ; preds = %bb1
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1639
  %5 = icmp ult i32 %fd, 32, !dbg !1641
  br i1 %5, label %bb.i, label %bb4, !dbg !1641

bb.i:                                             ; preds = %bb3
  %6 = sext i32 %fd to i64, !dbg !1642
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1642
  %7 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 1, !dbg !1643
  %8 = load i32* %7, align 4, !dbg !1643
  %9 = and i32 %8, 1
  %toBool.i = icmp eq i32 %9, 0, !dbg !1643
  br i1 %toBool.i, label %bb4, label %__get_file.exit, !dbg !1643

__get_file.exit:                                  ; preds = %bb.i
  %10 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, !dbg !1642
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %10}, i64 0, metadata !592), !dbg !1640
  %11 = icmp eq %struct.exe_file_t* %10, null, !dbg !1644
  br i1 %11, label %bb4, label %bb5, !dbg !1644

bb4:                                              ; preds = %bb3, %bb.i, %__get_file.exit
  %12 = tail call i32* @__errno_location() nounwind readnone, !dbg !1645
  store i32 9, i32* %12, align 4, !dbg !1645
  br label %bb24, !dbg !1646

bb5:                                              ; preds = %__get_file.exit
  %13 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1647
  %14 = icmp eq i32 %13, 0, !dbg !1647
  br i1 %14, label %bb8, label %bb6, !dbg !1647

bb6:                                              ; preds = %bb5
  %15 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 6), align 8, !dbg !1647
  %16 = load i32* %15, align 4, !dbg !1647
  %17 = icmp eq i32 %16, %1, !dbg !1647
  br i1 %17, label %bb7, label %bb8, !dbg !1647

bb7:                                              ; preds = %bb6
  %18 = add i32 %13, -1, !dbg !1648
  store i32 %18, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1648
  %19 = tail call i32* @__errno_location() nounwind readnone, !dbg !1649
  store i32 5, i32* %19, align 4, !dbg !1649
  br label %bb24, !dbg !1650

bb8:                                              ; preds = %bb5, %bb6
  %20 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 3, !dbg !1651
  %21 = load %struct.exe_disk_file_t** %20, align 8, !dbg !1651
  %22 = icmp eq %struct.exe_disk_file_t* %21, null, !dbg !1651
  br i1 %22, label %bb9, label %bb17, !dbg !1651

bb9:                                              ; preds = %bb8
  tail call void @llvm.dbg.value(metadata !{i8* %buf}, i64 0, metadata !346) nounwind, !dbg !1652
  %23 = ptrtoint i8* %buf to i64, !dbg !1654
  %24 = tail call i64 @klee_get_valuel(i64 %23) nounwind, !dbg !1654
  %25 = inttoptr i64 %24 to i8*, !dbg !1654
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !347) nounwind, !dbg !1654
  %26 = icmp eq i8* %25, %buf, !dbg !1655
  %27 = zext i1 %26 to i64, !dbg !1655
  tail call void @klee_assume(i64 %27) nounwind, !dbg !1655
  tail call void @llvm.dbg.value(metadata !{i8* %25}, i64 0, metadata !590), !dbg !1653
  tail call void @llvm.dbg.value(metadata !{i64 %count}, i64 0, metadata !349) nounwind, !dbg !1656
  %28 = tail call i64 @klee_get_valuel(i64 %count) nounwind, !dbg !1658
  tail call void @llvm.dbg.value(metadata !{i64 %28}, i64 0, metadata !350) nounwind, !dbg !1658
  %29 = icmp eq i64 %28, %count, !dbg !1659
  %30 = zext i1 %29 to i64, !dbg !1659
  tail call void @klee_assume(i64 %30) nounwind, !dbg !1659
  tail call void @llvm.dbg.value(metadata !{i64 %28}, i64 0, metadata !591), !dbg !1657
  tail call void @klee_check_memory_access(i8* %25, i64 %28) nounwind, !dbg !1660
  %31 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 0, !dbg !1661
  %32 = load i32* %31, align 8, !dbg !1661
  %33 = icmp eq i32 %32, 0, !dbg !1661
  br i1 %33, label %bb10, label %bb11, !dbg !1661

bb10:                                             ; preds = %bb9
  %34 = tail call i64 (i64, ...)* @syscall(i64 0, i32 %32, i8* %25, i64 %28) nounwind, !dbg !1662
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !594), !dbg !1662
  br label %bb12, !dbg !1662

bb11:                                             ; preds = %bb9
  %35 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 2, !dbg !1663
  %36 = load i64* %35, align 8, !dbg !1663
  %37 = tail call i64 (i64, ...)* @syscall(i64 17, i32 %32, i8* %25, i64 %28, i64 %36) nounwind, !dbg !1663
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !594), !dbg !1663
  br label %bb12, !dbg !1663

bb12:                                             ; preds = %bb11, %bb10
  %r.0.in = phi i64 [ %34, %bb10 ], [ %37, %bb11 ]
  %r.0 = trunc i64 %r.0.in to i32
  %38 = icmp eq i32 %r.0, -1, !dbg !1664
  br i1 %38, label %bb13, label %bb14, !dbg !1664

bb13:                                             ; preds = %bb12
  %39 = tail call i32* @__errno_location() nounwind readnone, !dbg !1665
  %40 = tail call i32 @klee_get_errno() nounwind, !dbg !1665
  store i32 %40, i32* %39, align 4, !dbg !1665
  br label %bb24, !dbg !1666

bb14:                                             ; preds = %bb12
  %41 = load i32* %31, align 8, !dbg !1667
  %42 = icmp eq i32 %41, 0, !dbg !1667
  br i1 %42, label %bb14.bb16_crit_edge, label %bb15, !dbg !1667

bb14.bb16_crit_edge:                              ; preds = %bb14
  %.pre = sext i32 %r.0 to i64, !dbg !1668
  br label %bb24

bb15:                                             ; preds = %bb14
  %43 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 2, !dbg !1669
  %44 = load i64* %43, align 8, !dbg !1669
  %45 = sext i32 %r.0 to i64, !dbg !1669
  %46 = add nsw i64 %44, %45, !dbg !1669
  store i64 %46, i64* %43, align 8, !dbg !1669
  br label %bb24, !dbg !1669

bb17:                                             ; preds = %bb8
  %47 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %6, i32 2, !dbg !1670
  %48 = load i64* %47, align 8, !dbg !1670
  %49 = icmp slt i64 %48, 0, !dbg !1670
  br i1 %49, label %bb18, label %bb19, !dbg !1670

bb18:                                             ; preds = %bb17
  tail call void @__assert_fail(i8* getelementptr inbounds ([12 x i8]* @.str23, i64 0, i64 0), i8* getelementptr inbounds ([5 x i8]* @.str18, i64 0, i64 0), i32 386, i8* getelementptr inbounds ([5 x i8]* @__PRETTY_FUNCTION__.4923, i64 0, i64 0)) noreturn nounwind, !dbg !1670
  unreachable, !dbg !1670

bb19:                                             ; preds = %bb17
  %50 = getelementptr inbounds %struct.exe_disk_file_t* %21, i64 0, i32 0, !dbg !1671
  %51 = load i32* %50, align 8, !dbg !1671
  %52 = zext i32 %51 to i64, !dbg !1671
  %53 = icmp slt i64 %52, %48, !dbg !1671
  br i1 %53, label %bb24, label %bb21, !dbg !1671

bb21:                                             ; preds = %bb19
  %54 = add i64 %48, %count, !dbg !1672
  %55 = sub nsw i64 %52, %48, !dbg !1673
  %56 = icmp ugt i64 %54, %52, !dbg !1672
  %.count = select i1 %56, i64 %55, i64 %count
  %57 = getelementptr inbounds %struct.exe_disk_file_t* %21, i64 0, i32 1, !dbg !1674
  %58 = load i8** %57, align 8, !dbg !1674
  %59 = getelementptr inbounds i8* %58, i64 %48, !dbg !1674
  tail call void @llvm.memcpy.p0i8.p0i8.i64(i8* %buf, i8* %59, i64 %.count, i32 1, i1 false), !dbg !1674
  %60 = load i64* %47, align 8, !dbg !1675
  %61 = add i64 %60, %.count, !dbg !1675
  store i64 %61, i64* %47, align 8, !dbg !1675
  br label %bb24, !dbg !1676

bb24:                                             ; preds = %bb15, %bb14.bb16_crit_edge, %bb19, %entry, %bb21, %bb13, %bb7, %bb4, %bb2
  %.0 = phi i64 [ -1, %bb2 ], [ -1, %bb4 ], [ -1, %bb7 ], [ -1, %bb13 ], [ %.count, %bb21 ], [ 0, %entry ], [ 0, %bb19 ], [ %.pre, %bb14.bb16_crit_edge ], [ %45, %bb15 ]
  ret i64 %.0, !dbg !1677
}

declare i32 @geteuid() nounwind

declare i32 @getgid() nounwind

define i32 @fchmod(i32 %fd, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !598), !dbg !1678
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !599), !dbg !1678
  tail call void @llvm.dbg.value(metadata !{i32 %fd}, i64 0, metadata !275), !dbg !1679
  %0 = icmp ult i32 %fd, 32, !dbg !1681
  br i1 %0, label %bb.i, label %bb, !dbg !1681

bb.i:                                             ; preds = %entry
  %1 = sext i32 %fd to i64, !dbg !1682
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !276), !dbg !1682
  %2 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 1, !dbg !1683
  %3 = load i32* %2, align 4, !dbg !1683
  %4 = and i32 %3, 1
  %toBool.i = icmp eq i32 %4, 0, !dbg !1683
  br i1 %toBool.i, label %bb, label %__get_file.exit, !dbg !1683

__get_file.exit:                                  ; preds = %bb.i
  %5 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, !dbg !1682
  tail call void @llvm.dbg.value(metadata !{%struct.exe_file_t* %5}, i64 0, metadata !600), !dbg !1680
  %6 = icmp eq %struct.exe_file_t* %5, null, !dbg !1684
  br i1 %6, label %bb, label %bb1, !dbg !1684

bb:                                               ; preds = %entry, %bb.i, %__get_file.exit
  %7 = tail call i32* @__errno_location() nounwind readnone, !dbg !1685
  store i32 9, i32* %7, align 4, !dbg !1685
  br label %bb9, !dbg !1686

bb1:                                              ; preds = %__get_file.exit
  %8 = load i32* @n_calls.5199, align 4, !dbg !1687
  %9 = add nsw i32 %8, 1, !dbg !1687
  store i32 %9, i32* @n_calls.5199, align 4, !dbg !1687
  %10 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1688
  %11 = icmp eq i32 %10, 0, !dbg !1688
  br i1 %11, label %bb4, label %bb2, !dbg !1688

bb2:                                              ; preds = %bb1
  %12 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 12), align 8, !dbg !1688
  %13 = load i32* %12, align 4, !dbg !1688
  %14 = icmp eq i32 %13, %9, !dbg !1688
  br i1 %14, label %bb3, label %bb4, !dbg !1688

bb3:                                              ; preds = %bb2
  %15 = add i32 %10, -1, !dbg !1689
  store i32 %15, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1689
  %16 = tail call i32* @__errno_location() nounwind readnone, !dbg !1690
  store i32 5, i32* %16, align 4, !dbg !1690
  br label %bb9, !dbg !1691

bb4:                                              ; preds = %bb1, %bb2
  %17 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 3, !dbg !1692
  %18 = load %struct.exe_disk_file_t** %17, align 8, !dbg !1692
  %19 = icmp eq %struct.exe_disk_file_t* %18, null, !dbg !1692
  br i1 %19, label %bb6, label %bb5, !dbg !1692

bb5:                                              ; preds = %bb4
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %18}, i64 0, metadata !596) nounwind, !dbg !1693
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !597) nounwind, !dbg !1693
  %20 = tail call i32 @geteuid() nounwind, !dbg !1695
  %21 = getelementptr inbounds %struct.exe_disk_file_t* %18, i64 0, i32 2, !dbg !1695
  %22 = load %struct.stat** %21, align 8, !dbg !1695
  %23 = getelementptr inbounds %struct.stat* %22, i64 0, i32 4, !dbg !1695
  %24 = load i32* %23, align 4, !dbg !1695
  %25 = icmp eq i32 %20, %24, !dbg !1695
  br i1 %25, label %bb.i11, label %bb3.i, !dbg !1695

bb.i11:                                           ; preds = %bb5
  %26 = tail call i32 @getgid() nounwind, !dbg !1697
  %27 = load %struct.stat** %21, align 8, !dbg !1697
  %28 = getelementptr inbounds %struct.stat* %27, i64 0, i32 5, !dbg !1697
  %29 = load i32* %28, align 8, !dbg !1697
  %30 = and i32 %mode, 3071, !dbg !1698
  %31 = icmp eq i32 %26, %29, !dbg !1697
  %mode..i = select i1 %31, i32 %mode, i32 %30
  %32 = getelementptr inbounds %struct.stat* %27, i64 0, i32 3, !dbg !1699
  %33 = load i32* %32, align 8, !dbg !1699
  %34 = and i32 %33, -4096, !dbg !1699
  %35 = and i32 %mode..i, 4095, !dbg !1699
  %36 = or i32 %35, %34, !dbg !1699
  store i32 %36, i32* %32, align 8, !dbg !1699
  br label %bb9, !dbg !1700

bb3.i:                                            ; preds = %bb5
  %37 = tail call i32* @__errno_location() nounwind readnone, !dbg !1701
  store i32 1, i32* %37, align 4, !dbg !1701
  br label %bb9, !dbg !1702

bb6:                                              ; preds = %bb4
  %38 = getelementptr inbounds %struct.exe_sym_env_t* @__exe_env, i64 0, i32 0, i64 %1, i32 0, !dbg !1703
  %39 = load i32* %38, align 8, !dbg !1703
  %40 = tail call i64 (i64, ...)* @syscall(i64 91, i32 %39, i32 %mode) nounwind, !dbg !1703
  %41 = trunc i64 %40 to i32, !dbg !1703
  tail call void @llvm.dbg.value(metadata !{i32 %41}, i64 0, metadata !602), !dbg !1703
  %42 = icmp eq i32 %41, -1, !dbg !1704
  br i1 %42, label %bb7, label %bb9, !dbg !1704

bb7:                                              ; preds = %bb6
  %43 = tail call i32* @__errno_location() nounwind readnone, !dbg !1705
  %44 = tail call i32 @klee_get_errno() nounwind, !dbg !1705
  store i32 %44, i32* %43, align 4, !dbg !1705
  br label %bb9, !dbg !1705

bb9:                                              ; preds = %bb3.i, %bb.i11, %bb6, %bb7, %bb3, %bb
  %.0 = phi i32 [ -1, %bb ], [ -1, %bb3 ], [ -1, %bb7 ], [ %41, %bb6 ], [ 0, %bb.i11 ], [ -1, %bb3.i ]
  ret i32 %.0, !dbg !1686
}

define i32 @chmod(i8* %path, i32 %mode) nounwind {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !604), !dbg !1706
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !605), !dbg !1706
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !269), !dbg !1707
  %0 = load i8* %path, align 1, !dbg !1709
  tail call void @llvm.dbg.value(metadata !{i8 %0}, i64 0, metadata !270), !dbg !1709
  %1 = icmp eq i8 %0, 0, !dbg !1710
  br i1 %1, label %__get_sym_file.exit, label %bb.i, !dbg !1710

bb.i:                                             ; preds = %entry
  %2 = getelementptr inbounds i8* %path, i64 1, !dbg !1710
  %3 = load i8* %2, align 1, !dbg !1710
  %4 = icmp eq i8 %3, 0, !dbg !1710
  br i1 %4, label %bb8.preheader.i, label %__get_sym_file.exit, !dbg !1710

bb8.preheader.i:                                  ; preds = %bb.i
  %5 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 0), align 8, !dbg !1711
  %6 = sext i8 %0 to i32, !dbg !1712
  br label %bb8.i

bb3.i:                                            ; preds = %bb8.i
  %sext.i = shl i32 %19, 24
  %7 = ashr exact i32 %sext.i, 24, !dbg !1712
  %8 = add nsw i32 %7, 65, !dbg !1712
  %9 = icmp eq i32 %6, %8, !dbg !1712
  br i1 %9, label %bb4.i, label %bb7.i, !dbg !1712

bb4.i:                                            ; preds = %bb3.i
  %10 = load %struct.exe_disk_file_t** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 4), align 8, !dbg !1713
  %11 = zext i32 %19 to i64, !dbg !1713
  tail call void @llvm.dbg.value(metadata !618, i64 0, metadata !273), !dbg !1713
  %12 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, i32 2, !dbg !1714
  %13 = load %struct.stat** %12, align 8, !dbg !1714
  %14 = getelementptr inbounds %struct.stat* %13, i64 0, i32 1, !dbg !1714
  %15 = load i64* %14, align 8, !dbg !1714
  %16 = icmp eq i64 %15, 0, !dbg !1714
  br i1 %16, label %__get_sym_file.exit, label %bb6.i, !dbg !1714

bb6.i:                                            ; preds = %bb4.i
  %17 = getelementptr inbounds %struct.exe_disk_file_t* %10, i64 %11, !dbg !1713
  br label %__get_sym_file.exit, !dbg !1715

bb7.i:                                            ; preds = %bb3.i
  %18 = add i32 %19, 1, !dbg !1711
  br label %bb8.i, !dbg !1711

bb8.i:                                            ; preds = %bb7.i, %bb8.preheader.i
  %19 = phi i32 [ %18, %bb7.i ], [ 0, %bb8.preheader.i ]
  %20 = icmp ugt i32 %5, %19, !dbg !1711
  br i1 %20, label %bb3.i, label %__get_sym_file.exit, !dbg !1711

__get_sym_file.exit:                              ; preds = %bb8.i, %entry, %bb.i, %bb4.i, %bb6.i
  %.0.i = phi %struct.exe_disk_file_t* [ %17, %bb6.i ], [ null, %bb.i ], [ null, %entry ], [ null, %bb4.i ], [ null, %bb8.i ]
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %.0.i}, i64 0, metadata !606), !dbg !1708
  %21 = load i32* @n_calls.5176, align 4, !dbg !1716
  %22 = add nsw i32 %21, 1, !dbg !1716
  store i32 %22, i32* @n_calls.5176, align 4, !dbg !1716
  %23 = load i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1717
  %24 = icmp eq i32 %23, 0, !dbg !1717
  br i1 %24, label %bb2, label %bb, !dbg !1717

bb:                                               ; preds = %__get_sym_file.exit
  %25 = load i32** getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 11), align 8, !dbg !1717
  %26 = load i32* %25, align 4, !dbg !1717
  %27 = icmp eq i32 %26, %22, !dbg !1717
  br i1 %27, label %bb1, label %bb2, !dbg !1717

bb1:                                              ; preds = %bb
  %28 = add i32 %23, -1, !dbg !1718
  store i32 %28, i32* getelementptr inbounds (%struct.exe_file_system_t* @__exe_fs, i64 0, i32 5), align 8, !dbg !1718
  %29 = tail call i32* @__errno_location() nounwind readnone, !dbg !1719
  store i32 5, i32* %29, align 4, !dbg !1719
  br label %bb7, !dbg !1720

bb2:                                              ; preds = %__get_sym_file.exit, %bb
  %30 = icmp eq %struct.exe_disk_file_t* %.0.i, null, !dbg !1721
  br i1 %30, label %bb4, label %bb3, !dbg !1721

bb3:                                              ; preds = %bb2
  tail call void @llvm.dbg.value(metadata !{%struct.exe_disk_file_t* %.0.i}, i64 0, metadata !596) nounwind, !dbg !1722
  tail call void @llvm.dbg.value(metadata !{i32 %mode}, i64 0, metadata !597) nounwind, !dbg !1722
  %31 = tail call i32 @geteuid() nounwind, !dbg !1724
  %32 = getelementptr inbounds %struct.exe_disk_file_t* %.0.i, i64 0, i32 2, !dbg !1724
  %33 = load %struct.stat** %32, align 8, !dbg !1724
  %34 = getelementptr inbounds %struct.stat* %33, i64 0, i32 4, !dbg !1724
  %35 = load i32* %34, align 4, !dbg !1724
  %36 = icmp eq i32 %31, %35, !dbg !1724
  br i1 %36, label %bb.i13, label %bb3.i14, !dbg !1724

bb.i13:                                           ; preds = %bb3
  %37 = tail call i32 @getgid() nounwind, !dbg !1725
  %38 = load %struct.stat** %32, align 8, !dbg !1725
  %39 = getelementptr inbounds %struct.stat* %38, i64 0, i32 5, !dbg !1725
  %40 = load i32* %39, align 8, !dbg !1725
  %41 = and i32 %mode, 3071, !dbg !1726
  %42 = icmp eq i32 %37, %40, !dbg !1725
  %mode..i = select i1 %42, i32 %mode, i32 %41
  %43 = getelementptr inbounds %struct.stat* %38, i64 0, i32 3, !dbg !1727
  %44 = load i32* %43, align 8, !dbg !1727
  %45 = and i32 %44, -4096, !dbg !1727
  %46 = and i32 %mode..i, 4095, !dbg !1727
  %47 = or i32 %46, %45, !dbg !1727
  store i32 %47, i32* %43, align 8, !dbg !1727
  br label %bb7, !dbg !1728

bb3.i14:                                          ; preds = %bb3
  %48 = tail call i32* @__errno_location() nounwind readnone, !dbg !1729
  store i32 1, i32* %48, align 4, !dbg !1729
  br label %bb7, !dbg !1730

bb4:                                              ; preds = %bb2
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !356) nounwind, !dbg !1731
  tail call void @llvm.dbg.value(metadata !{i8* %path}, i64 0, metadata !346) nounwind, !dbg !1733
  %49 = ptrtoint i8* %path to i64, !dbg !1735
  %50 = tail call i64 @klee_get_valuel(i64 %49) nounwind, !dbg !1735
  %51 = inttoptr i64 %50 to i8*, !dbg !1735
  tail call void @llvm.dbg.value(metadata !{i8* %51}, i64 0, metadata !347) nounwind, !dbg !1735
  %52 = icmp eq i8* %51, %path, !dbg !1736
  %53 = zext i1 %52 to i64, !dbg !1736
  tail call void @klee_assume(i64 %53) nounwind, !dbg !1736
  tail call void @llvm.dbg.value(metadata !{i8* %51}, i64 0, metadata !357) nounwind, !dbg !1734
  tail call void @llvm.dbg.value(metadata !627, i64 0, metadata !359) nounwind, !dbg !1737
  br label %bb.i9, !dbg !1737

bb.i9:                                            ; preds = %bb6.i11, %bb4
  %sc.0.i = phi i8* [ %51, %bb4 ], [ %sc.1.i, %bb6.i11 ]
  %54 = phi i32 [ 0, %bb4 ], [ %66, %bb6.i11 ]
  %tmp.i = add i32 %54, -1
  %55 = load i8* %sc.0.i, align 1, !dbg !1738
  %56 = and i32 %tmp.i, %54, !dbg !1739
  %57 = icmp eq i32 %56, 0, !dbg !1739
  br i1 %57, label %bb1.i, label %bb5.i, !dbg !1739

bb1.i:                                            ; preds = %bb.i9
  switch i8 %55, label %bb6.i11 [
    i8 0, label %bb2.i
    i8 47, label %bb4.i10
  ]

bb2.i:                                            ; preds = %bb1.i
  tail call void @llvm.dbg.value(metadata !{i8 %55}, i64 0, metadata !360) nounwind, !dbg !1738
  store i8 0, i8* %sc.0.i, align 1, !dbg !1740
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !357) nounwind, !dbg !1740
  br label %__concretize_string.exit, !dbg !1740

bb4.i10:                                          ; preds = %bb1.i
  store i8 47, i8* %sc.0.i, align 1, !dbg !1741
  %58 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1741
  br label %bb6.i11, !dbg !1741

bb5.i:                                            ; preds = %bb.i9
  %59 = sext i8 %55 to i64, !dbg !1742
  %60 = tail call i64 @klee_get_valuel(i64 %59) nounwind, !dbg !1742
  %61 = trunc i64 %60 to i8, !dbg !1742
  %62 = icmp eq i8 %61, %55, !dbg !1743
  %63 = zext i1 %62 to i64, !dbg !1743
  tail call void @klee_assume(i64 %63) nounwind, !dbg !1743
  store i8 %61, i8* %sc.0.i, align 1, !dbg !1744
  %64 = getelementptr inbounds i8* %sc.0.i, i64 1, !dbg !1744
  %65 = icmp eq i8 %61, 0, !dbg !1745
  br i1 %65, label %__concretize_string.exit, label %bb6.i11, !dbg !1745

bb6.i11:                                          ; preds = %bb5.i, %bb4.i10, %bb1.i
  %sc.1.i = phi i8* [ %58, %bb4.i10 ], [ %64, %bb5.i ], [ %sc.0.i, %bb1.i ]
  %66 = add i32 %54, 1, !dbg !1737
  br label %bb.i9, !dbg !1737

__concretize_string.exit:                         ; preds = %bb5.i, %bb2.i
  %67 = tail call i64 (i64, ...)* @syscall(i64 90, i8* %path, i32 %mode) nounwind, !dbg !1732
  %68 = trunc i64 %67 to i32, !dbg !1732
  tail call void @llvm.dbg.value(metadata !{i32 %68}, i64 0, metadata !608), !dbg !1732
  %69 = icmp eq i32 %68, -1, !dbg !1746
  br i1 %69, label %bb5, label %bb7, !dbg !1746

bb5:                                              ; preds = %__concretize_string.exit
  %70 = tail call i32* @__errno_location() nounwind readnone, !dbg !1747
  %71 = tail call i32 @klee_get_errno() nounwind, !dbg !1747
  store i32 %71, i32* %70, align 4, !dbg !1747
  br label %bb7, !dbg !1747

bb7:                                              ; preds = %bb3.i14, %bb.i13, %__concretize_string.exit, %bb5, %bb1
  %.0 = phi i32 [ -1, %bb1 ], [ -1, %bb5 ], [ %68, %__concretize_string.exit ], [ 0, %bb.i13 ], [ -1, %bb3.i14 ]
  ret i32 %.0, !dbg !1720
}

!llvm.dbg.sp = !{!0, !60, !73, !77, !80, !83, !86, !87, !88, !93, !98, !101, !133, !136, !139, !140, !144, !147, !150, !153, !156, !159, !160, !161, !172, !175, !178, !192, !193, !196, !197, !200, !203, !204, !207, !225, !228, !229, !232, !255, !256, !259, !260, !263, !266}
!llvm.dbg.lv.__get_sym_file = !{!269, !270, !272, !273}
!llvm.dbg.lv.__get_file = !{!275, !276}
!llvm.dbg.lv.umask = !{!279, !280}
!llvm.dbg.lv.has_permission = !{!282, !283, !284, !286, !287}
!llvm.dbg.lv.chroot = !{!288}
!llvm.dbg.lv.unlinkat = !{!289, !290, !291, !292}
!llvm.dbg.lv.unlink = !{!294, !295}
!llvm.dbg.lv.rmdir = !{!297, !298}
!llvm.dbg.lv.__df_chown = !{!300, !301, !302}
!llvm.dbg.lv.readlink = !{!303, !304, !305, !306, !308}
!llvm.dbg.lv.fsync = !{!310, !311, !313}
!llvm.dbg.lv.fstatfs = !{!315, !316, !317, !319}
!llvm.dbg.lv.__fd_ftruncate = !{!321, !322, !323, !325}
!llvm.dbg.gv = !{!327, !328, !329, !330, !331, !332, !333}
!llvm.dbg.lv.fchown = !{!334, !335, !336, !337, !339}
!llvm.dbg.lv.fchdir = !{!341, !342, !344}
!llvm.dbg.lv.__concretize_ptr = !{!346, !347}
!llvm.dbg.lv.__concretize_size = !{!349, !350}
!llvm.dbg.lv.getcwd = !{!352, !353, !354}
!llvm.dbg.lv.__concretize_string = !{!356, !357, !359, !360, !362}
!llvm.dbg.lv.__fd_statfs = !{!364, !365, !366, !368}
!llvm.dbg.lv.lchown = !{!370, !371, !372, !373, !375}
!llvm.dbg.lv.chown = !{!377, !378, !379, !380, !382}
!llvm.dbg.lv.chdir = !{!384, !385, !387}
!llvm.dbg.lv.utimes = !{!389, !390, !391, !393}
!llvm.dbg.lv.futimesat = !{!394, !395, !396, !397, !399}
!llvm.dbg.lv.access = !{!401, !402, !403, !405}
!llvm.dbg.lv.select = !{!407, !408, !409, !410, !411, !412, !414, !415, !416, !417, !418, !419, !420, !421, !422, !424, !426, !427}
!llvm.dbg.lv.close = !{!429, !430, !432}
!llvm.dbg.lv.dup2 = !{!433, !434, !435, !437}
!llvm.dbg.lv.dup = !{!439, !440, !442}
!llvm.dbg.lv.__fd_open = !{!444, !445, !446, !447, !449, !450, !451}
!llvm.dbg.lv.__fd_openat = !{!453, !454, !455, !456, !457, !459, !460, !461}
!llvm.dbg.lv.fcntl = !{!463, !464, !465, !467, !480, !481, !483}
!llvm.dbg.lv.ioctl = !{!485, !486, !487, !489, !490, !491, !493, !513, !523, !526}
!llvm.dbg.lv.__fd_getdents = !{!528, !529, !530, !531, !533, !535, !536, !537, !539, !541, !542, !543, !545}
!llvm.dbg.lv.__fd_lseek = !{!547, !548, !549, !550, !552}
!llvm.dbg.lv.__fd_fstat = !{!553, !554, !555, !557}
!llvm.dbg.lv.__fd_lstat = !{!559, !560, !561, !563}
!llvm.dbg.lv.fstatat = !{!565, !566, !567, !568, !569, !571, !572}
!llvm.dbg.lv.__fd_stat = !{!574, !575, !576, !578}
!llvm.dbg.lv.write = !{!580, !581, !582, !583, !585, !587}
!llvm.dbg.lv.read = !{!589, !590, !591, !592, !594}
!llvm.dbg.lv.__df_chmod = !{!596, !597}
!llvm.dbg.lv.fchmod = !{!598, !599, !600, !602}
!llvm.dbg.lv.chmod = !{!604, !605, !606, !608}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__get_sym_file", metadata !"__get_sym_file", metadata !"", metadata !1, i32 39, metadata !3, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"fd.c", metadata !"/home/qiu/QTools/klee/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"fd.c", metadata !"/home/qiu/QTools/klee/runtime/POSIX/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !58}
!5 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !6} ; [ DW_TAG_pointer_type ]
!6 = metadata !{i32 589846, metadata !7, metadata !"exe_disk_file_t", metadata !7, i32 26, i64 0, i64 0, i64 0, i32 0, metadata !8} ; [ DW_TAG_typedef ]
!7 = metadata !{i32 589865, metadata !"fd.h", metadata !"/home/qiu/QTools/klee/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!8 = metadata !{i32 589843, metadata !1, metadata !"", metadata !7, i32 20, i64 192, i64 64, i64 0, i32 0, null, metadata !9, i32 0, null} ; [ DW_TAG_structure_type ]
!9 = metadata !{metadata !10, metadata !12, metadata !15}
!10 = metadata !{i32 589837, metadata !8, metadata !"size", metadata !7, i32 21, i64 32, i64 32, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ]
!11 = metadata !{i32 589860, metadata !1, metadata !"unsigned int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!12 = metadata !{i32 589837, metadata !8, metadata !"contents", metadata !7, i32 22, i64 64, i64 64, i64 64, i32 0, metadata !13} ; [ DW_TAG_member ]
!13 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !14} ; [ DW_TAG_pointer_type ]
!14 = metadata !{i32 589860, metadata !1, metadata !"char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 6} ; [ DW_TAG_base_type ]
!15 = metadata !{i32 589837, metadata !8, metadata !"stat", metadata !7, i32 23, i64 64, i64 64, i64 128, i32 0, metadata !16} ; [ DW_TAG_member ]
!16 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !17} ; [ DW_TAG_pointer_type ]
!17 = metadata !{i32 589843, metadata !1, metadata !"stat64", metadata !7, i32 23, i64 1152, i64 64, i64 0, i32 0, null, metadata !18, i32 0, null} ; [ DW_TAG_structure_type ]
!18 = metadata !{metadata !19, metadata !24, metadata !26, metadata !28, metadata !30, metadata !32, metadata !34, metadata !36, metadata !37, metadata !40, metadata !42, metadata !44, metadata !52, metadata !53, metadata !54}
!19 = metadata !{i32 589837, metadata !17, metadata !"st_dev", metadata !20, i32 121, i64 64, i64 64, i64 0, i32 0, metadata !21} ; [ DW_TAG_member ]
!20 = metadata !{i32 589865, metadata !"stat.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!21 = metadata !{i32 589846, metadata !22, metadata !"__dev_t", metadata !22, i32 125, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!22 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!23 = metadata !{i32 589860, metadata !1, metadata !"long unsigned int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!24 = metadata !{i32 589837, metadata !17, metadata !"st_ino", metadata !20, i32 123, i64 64, i64 64, i64 64, i32 0, metadata !25} ; [ DW_TAG_member ]
!25 = metadata !{i32 589846, metadata !22, metadata !"__ino64_t", metadata !22, i32 129, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!26 = metadata !{i32 589837, metadata !17, metadata !"st_nlink", metadata !20, i32 124, i64 64, i64 64, i64 128, i32 0, metadata !27} ; [ DW_TAG_member ]
!27 = metadata !{i32 589846, metadata !22, metadata !"__nlink_t", metadata !22, i32 131, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!28 = metadata !{i32 589837, metadata !17, metadata !"st_mode", metadata !20, i32 125, i64 32, i64 32, i64 192, i32 0, metadata !29} ; [ DW_TAG_member ]
!29 = metadata !{i32 589846, metadata !22, metadata !"__mode_t", metadata !22, i32 130, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!30 = metadata !{i32 589837, metadata !17, metadata !"st_uid", metadata !20, i32 132, i64 32, i64 32, i64 224, i32 0, metadata !31} ; [ DW_TAG_member ]
!31 = metadata !{i32 589846, metadata !22, metadata !"__uid_t", metadata !22, i32 126, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!32 = metadata !{i32 589837, metadata !17, metadata !"st_gid", metadata !20, i32 133, i64 32, i64 32, i64 256, i32 0, metadata !33} ; [ DW_TAG_member ]
!33 = metadata !{i32 589846, metadata !22, metadata !"__gid_t", metadata !22, i32 127, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!34 = metadata !{i32 589837, metadata !17, metadata !"__pad0", metadata !20, i32 135, i64 32, i64 32, i64 288, i32 0, metadata !35} ; [ DW_TAG_member ]
!35 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!36 = metadata !{i32 589837, metadata !17, metadata !"st_rdev", metadata !20, i32 136, i64 64, i64 64, i64 320, i32 0, metadata !21} ; [ DW_TAG_member ]
!37 = metadata !{i32 589837, metadata !17, metadata !"st_size", metadata !20, i32 137, i64 64, i64 64, i64 384, i32 0, metadata !38} ; [ DW_TAG_member ]
!38 = metadata !{i32 589846, metadata !22, metadata !"__off_t", metadata !22, i32 132, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!39 = metadata !{i32 589860, metadata !1, metadata !"long int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!40 = metadata !{i32 589837, metadata !17, metadata !"st_blksize", metadata !20, i32 143, i64 64, i64 64, i64 448, i32 0, metadata !41} ; [ DW_TAG_member ]
!41 = metadata !{i32 589846, metadata !22, metadata !"__blksize_t", metadata !22, i32 158, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!42 = metadata !{i32 589837, metadata !17, metadata !"st_blocks", metadata !20, i32 144, i64 64, i64 64, i64 512, i32 0, metadata !43} ; [ DW_TAG_member ]
!43 = metadata !{i32 589846, metadata !22, metadata !"__blkcnt64_t", metadata !22, i32 162, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!44 = metadata !{i32 589837, metadata !17, metadata !"st_atim", metadata !20, i32 152, i64 128, i64 64, i64 576, i32 0, metadata !45} ; [ DW_TAG_member ]
!45 = metadata !{i32 589843, metadata !1, metadata !"timespec", metadata !46, i32 121, i64 128, i64 64, i64 0, i32 0, null, metadata !47, i32 0, null} ; [ DW_TAG_structure_type ]
!46 = metadata !{i32 589865, metadata !"time.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!47 = metadata !{metadata !48, metadata !50}
!48 = metadata !{i32 589837, metadata !45, metadata !"tv_sec", metadata !46, i32 122, i64 64, i64 64, i64 0, i32 0, metadata !49} ; [ DW_TAG_member ]
!49 = metadata !{i32 589846, metadata !22, metadata !"__time_t", metadata !22, i32 140, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!50 = metadata !{i32 589837, metadata !45, metadata !"tv_nsec", metadata !46, i32 123, i64 64, i64 64, i64 64, i32 0, metadata !51} ; [ DW_TAG_member ]
!51 = metadata !{i32 589846, metadata !22, metadata !"__syscall_slong_t", metadata !22, i32 177, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!52 = metadata !{i32 589837, metadata !17, metadata !"st_mtim", metadata !20, i32 153, i64 128, i64 64, i64 704, i32 0, metadata !45} ; [ DW_TAG_member ]
!53 = metadata !{i32 589837, metadata !17, metadata !"st_ctim", metadata !20, i32 154, i64 128, i64 64, i64 832, i32 0, metadata !45} ; [ DW_TAG_member ]
!54 = metadata !{i32 589837, metadata !17, metadata !"__glibc_reserved", metadata !20, i32 164, i64 192, i64 64, i64 960, i32 0, metadata !55} ; [ DW_TAG_member ]
!55 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 192, i64 64, i64 0, i32 0, metadata !51, metadata !56, i32 0, null} ; [ DW_TAG_array_type ]
!56 = metadata !{metadata !57}
!57 = metadata !{i32 589857, i64 0, i64 2}        ; [ DW_TAG_subrange_type ]
!58 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !59} ; [ DW_TAG_pointer_type ]
!59 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !14} ; [ DW_TAG_const_type ]
!60 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__get_file", metadata !"__get_file", metadata !"", metadata !1, i32 63, metadata !61, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!61 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !62, i32 0, null} ; [ DW_TAG_subroutine_type ]
!62 = metadata !{metadata !63, metadata !35}
!63 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !64} ; [ DW_TAG_pointer_type ]
!64 = metadata !{i32 589846, metadata !7, metadata !"exe_file_t", metadata !7, i32 42, i64 0, i64 0, i64 0, i32 0, metadata !65} ; [ DW_TAG_typedef ]
!65 = metadata !{i32 589843, metadata !1, metadata !"", metadata !7, i32 33, i64 192, i64 64, i64 0, i32 0, null, metadata !66, i32 0, null} ; [ DW_TAG_structure_type ]
!66 = metadata !{metadata !67, metadata !68, metadata !69, metadata !72}
!67 = metadata !{i32 589837, metadata !65, metadata !"fd", metadata !7, i32 34, i64 32, i64 32, i64 0, i32 0, metadata !35} ; [ DW_TAG_member ]
!68 = metadata !{i32 589837, metadata !65, metadata !"flags", metadata !7, i32 35, i64 32, i64 32, i64 32, i32 0, metadata !11} ; [ DW_TAG_member ]
!69 = metadata !{i32 589837, metadata !65, metadata !"off", metadata !7, i32 38, i64 64, i64 64, i64 64, i32 0, metadata !70} ; [ DW_TAG_member ]
!70 = metadata !{i32 589846, metadata !71, metadata !"off64_t", metadata !71, i32 98, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!71 = metadata !{i32 589865, metadata !"types.h", metadata !"/usr/include/x86_64-linux-gnu/sys", metadata !2} ; [ DW_TAG_file_type ]
!72 = metadata !{i32 589837, metadata !65, metadata !"dfile", metadata !7, i32 39, i64 64, i64 64, i64 128, i32 0, metadata !5} ; [ DW_TAG_member ]
!73 = metadata !{i32 589870, i32 0, metadata !1, metadata !"umask", metadata !"umask", metadata !"umask", metadata !1, i32 88, metadata !74, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @umask} ; [ DW_TAG_subprogram ]
!74 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !75, i32 0, null} ; [ DW_TAG_subroutine_type ]
!75 = metadata !{metadata !76, metadata !76}
!76 = metadata !{i32 589846, metadata !71, metadata !"mode_t", metadata !71, i32 75, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!77 = metadata !{i32 589870, i32 0, metadata !1, metadata !"has_permission", metadata !"has_permission", metadata !"", metadata !1, i32 97, metadata !78, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!78 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !79, i32 0, null} ; [ DW_TAG_subroutine_type ]
!79 = metadata !{metadata !35, metadata !35, metadata !16}
!80 = metadata !{i32 589870, i32 0, metadata !1, metadata !"chroot", metadata !"chroot", metadata !"chroot", metadata !1, i32 1457, metadata !81, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @chroot} ; [ DW_TAG_subprogram ]
!81 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !82, i32 0, null} ; [ DW_TAG_subroutine_type ]
!82 = metadata !{metadata !35, metadata !58}
!83 = metadata !{i32 589870, i32 0, metadata !1, metadata !"unlinkat", metadata !"unlinkat", metadata !"unlinkat", metadata !1, i32 1239, metadata !84, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, i32)* @unlinkat} ; [ DW_TAG_subprogram ]
!84 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !85, i32 0, null} ; [ DW_TAG_subroutine_type ]
!85 = metadata !{metadata !35, metadata !35, metadata !58, metadata !35}
!86 = metadata !{i32 589870, i32 0, metadata !1, metadata !"unlink", metadata !"unlink", metadata !"unlink", metadata !1, i32 1218, metadata !81, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @unlink} ; [ DW_TAG_subprogram ]
!87 = metadata !{i32 589870, i32 0, metadata !1, metadata !"rmdir", metadata !"rmdir", metadata !"rmdir", metadata !1, i32 1200, metadata !81, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @rmdir} ; [ DW_TAG_subprogram ]
!88 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__df_chown", metadata !"__df_chown", metadata !"", metadata !1, i32 707, metadata !89, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!89 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !90, i32 0, null} ; [ DW_TAG_subroutine_type ]
!90 = metadata !{metadata !35, metadata !5, metadata !91, metadata !92}
!91 = metadata !{i32 589846, metadata !71, metadata !"uid_t", metadata !71, i32 86, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!92 = metadata !{i32 589846, metadata !71, metadata !"gid_t", metadata !71, i32 70, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!93 = metadata !{i32 589870, i32 0, metadata !1, metadata !"readlink", metadata !"readlink", metadata !"readlink", metadata !1, i32 1262, metadata !94, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i8*, i8*, i64)* @readlink} ; [ DW_TAG_subprogram ]
!94 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !95, i32 0, null} ; [ DW_TAG_subroutine_type ]
!95 = metadata !{metadata !96, metadata !58, metadata !13, metadata !97}
!96 = metadata !{i32 589846, metadata !71, metadata !"ssize_t", metadata !71, i32 115, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!97 = metadata !{i32 589846, metadata !71, metadata !"size_t", metadata !71, i32 150, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!98 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fsync", metadata !"fsync", metadata !"fsync", metadata !1, i32 1140, metadata !99, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @fsync} ; [ DW_TAG_subprogram ]
!99 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !100, i32 0, null} ; [ DW_TAG_subroutine_type ]
!100 = metadata !{metadata !35, metadata !35}
!101 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fstatfs", metadata !"fstatfs", metadata !"fstatfs", metadata !1, i32 1120, metadata !102, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.statfs*)* @fstatfs} ; [ DW_TAG_subprogram ]
!102 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !103, i32 0, null} ; [ DW_TAG_subroutine_type ]
!103 = metadata !{metadata !35, metadata !35, metadata !104}
!104 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !105} ; [ DW_TAG_pointer_type ]
!105 = metadata !{i32 589843, metadata !1, metadata !"statfs", metadata !106, i32 25, i64 960, i64 64, i64 0, i32 0, null, metadata !107, i32 0, null} ; [ DW_TAG_structure_type ]
!106 = metadata !{i32 589865, metadata !"statfs.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!107 = metadata !{metadata !108, metadata !110, metadata !111, metadata !113, metadata !114, metadata !115, metadata !117, metadata !118, metadata !126, metadata !127, metadata !128, metadata !129}
!108 = metadata !{i32 589837, metadata !105, metadata !"f_type", metadata !106, i32 26, i64 64, i64 64, i64 0, i32 0, metadata !109} ; [ DW_TAG_member ]
!109 = metadata !{i32 589846, metadata !22, metadata !"__fsword_t", metadata !22, i32 172, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!110 = metadata !{i32 589837, metadata !105, metadata !"f_bsize", metadata !106, i32 27, i64 64, i64 64, i64 64, i32 0, metadata !109} ; [ DW_TAG_member ]
!111 = metadata !{i32 589837, metadata !105, metadata !"f_blocks", metadata !106, i32 29, i64 64, i64 64, i64 128, i32 0, metadata !112} ; [ DW_TAG_member ]
!112 = metadata !{i32 589846, metadata !22, metadata !"__fsblkcnt_t", metadata !22, i32 163, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!113 = metadata !{i32 589837, metadata !105, metadata !"f_bfree", metadata !106, i32 30, i64 64, i64 64, i64 192, i32 0, metadata !112} ; [ DW_TAG_member ]
!114 = metadata !{i32 589837, metadata !105, metadata !"f_bavail", metadata !106, i32 31, i64 64, i64 64, i64 256, i32 0, metadata !112} ; [ DW_TAG_member ]
!115 = metadata !{i32 589837, metadata !105, metadata !"f_files", metadata !106, i32 32, i64 64, i64 64, i64 320, i32 0, metadata !116} ; [ DW_TAG_member ]
!116 = metadata !{i32 589846, metadata !22, metadata !"__fsfilcnt_t", metadata !22, i32 167, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!117 = metadata !{i32 589837, metadata !105, metadata !"f_ffree", metadata !106, i32 33, i64 64, i64 64, i64 384, i32 0, metadata !116} ; [ DW_TAG_member ]
!118 = metadata !{i32 589837, metadata !105, metadata !"f_fsid", metadata !106, i32 41, i64 64, i64 32, i64 448, i32 0, metadata !119} ; [ DW_TAG_member ]
!119 = metadata !{i32 589846, metadata !22, metadata !"__fsid_t", metadata !22, i32 135, i64 0, i64 0, i64 0, i32 0, metadata !120} ; [ DW_TAG_typedef ]
!120 = metadata !{i32 589843, metadata !1, metadata !"", metadata !22, i32 134, i64 64, i64 32, i64 0, i32 0, null, metadata !121, i32 0, null} ; [ DW_TAG_structure_type ]
!121 = metadata !{metadata !122}
!122 = metadata !{i32 589837, metadata !120, metadata !"__val", metadata !22, i32 134, i64 64, i64 32, i64 0, i32 0, metadata !123} ; [ DW_TAG_member ]
!123 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 32, i64 0, i32 0, metadata !35, metadata !124, i32 0, null} ; [ DW_TAG_array_type ]
!124 = metadata !{metadata !125}
!125 = metadata !{i32 589857, i64 0, i64 1}       ; [ DW_TAG_subrange_type ]
!126 = metadata !{i32 589837, metadata !105, metadata !"f_namelen", metadata !106, i32 42, i64 64, i64 64, i64 512, i32 0, metadata !109} ; [ DW_TAG_member ]
!127 = metadata !{i32 589837, metadata !105, metadata !"f_frsize", metadata !106, i32 43, i64 64, i64 64, i64 576, i32 0, metadata !109} ; [ DW_TAG_member ]
!128 = metadata !{i32 589837, metadata !105, metadata !"f_flags", metadata !106, i32 44, i64 64, i64 64, i64 640, i32 0, metadata !109} ; [ DW_TAG_member ]
!129 = metadata !{i32 589837, metadata !105, metadata !"f_spare", metadata !106, i32 45, i64 256, i64 64, i64 704, i32 0, metadata !130} ; [ DW_TAG_member ]
!130 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 256, i64 64, i64 0, i32 0, metadata !109, metadata !131, i32 0, null} ; [ DW_TAG_array_type ]
!131 = metadata !{metadata !132}
!132 = metadata !{i32 589857, i64 0, i64 3}       ; [ DW_TAG_subrange_type ]
!133 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_ftruncate", metadata !"__fd_ftruncate", metadata !"__fd_ftruncate", metadata !1, i32 781, metadata !134, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i64)* @__fd_ftruncate} ; [ DW_TAG_subprogram ]
!134 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !135, i32 0, null} ; [ DW_TAG_subroutine_type ]
!135 = metadata !{metadata !35, metadata !35, metadata !70}
!136 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fchown", metadata !"fchown", metadata !"fchown", metadata !1, i32 726, metadata !137, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, i32)* @fchown} ; [ DW_TAG_subprogram ]
!137 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !138, i32 0, null} ; [ DW_TAG_subroutine_type ]
!138 = metadata !{metadata !35, metadata !35, metadata !91, metadata !92}
!139 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fchdir", metadata !"fchdir", metadata !"fchdir", metadata !1, i32 624, metadata !99, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @fchdir} ; [ DW_TAG_subprogram ]
!140 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__concretize_ptr", metadata !"__concretize_ptr", metadata !"", metadata !1, i32 1415, metadata !141, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!141 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !142, i32 0, null} ; [ DW_TAG_subroutine_type ]
!142 = metadata !{metadata !143, metadata !143}
!143 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!144 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__concretize_size", metadata !"__concretize_size", metadata !"", metadata !1, i32 1422, metadata !145, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!145 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !146, i32 0, null} ; [ DW_TAG_subroutine_type ]
!146 = metadata !{metadata !97, metadata !97}
!147 = metadata !{i32 589870, i32 0, metadata !1, metadata !"getcwd", metadata !"getcwd", metadata !"getcwd", metadata !1, i32 1380, metadata !148, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i8* (i8*, i64)* @getcwd} ; [ DW_TAG_subprogram ]
!148 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !149, i32 0, null} ; [ DW_TAG_subroutine_type ]
!149 = metadata !{metadata !13, metadata !13, metadata !97}
!150 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__concretize_string", metadata !"__concretize_string", metadata !"", metadata !1, i32 1428, metadata !151, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!151 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !152, i32 0, null} ; [ DW_TAG_subroutine_type ]
!152 = metadata !{metadata !58, metadata !58}
!153 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_statfs", metadata !"__fd_statfs", metadata !"__fd_statfs", metadata !1, i32 1103, metadata !154, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.statfs*)* @__fd_statfs} ; [ DW_TAG_subprogram ]
!154 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !155, i32 0, null} ; [ DW_TAG_subroutine_type ]
!155 = metadata !{metadata !35, metadata !58, metadata !104}
!156 = metadata !{i32 589870, i32 0, metadata !1, metadata !"lchown", metadata !"lchown", metadata !"lchown", metadata !1, i32 744, metadata !157, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, i32)* @lchown} ; [ DW_TAG_subprogram ]
!157 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !158, i32 0, null} ; [ DW_TAG_subroutine_type ]
!158 = metadata !{metadata !35, metadata !58, metadata !91, metadata !92}
!159 = metadata !{i32 589870, i32 0, metadata !1, metadata !"chown", metadata !"chown", metadata !"chown", metadata !1, i32 713, metadata !157, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, i32)* @chown} ; [ DW_TAG_subprogram ]
!160 = metadata !{i32 589870, i32 0, metadata !1, metadata !"chdir", metadata !"chdir", metadata !"chdir", metadata !1, i32 606, metadata !81, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*)* @chdir} ; [ DW_TAG_subprogram ]
!161 = metadata !{i32 589870, i32 0, metadata !1, metadata !"utimes", metadata !"utimes", metadata !"utimes", metadata !1, i32 256, metadata !162, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.timespec*)* @utimes} ; [ DW_TAG_subprogram ]
!162 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !163, i32 0, null} ; [ DW_TAG_subroutine_type ]
!163 = metadata !{metadata !35, metadata !58, metadata !164}
!164 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !165} ; [ DW_TAG_pointer_type ]
!165 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 128, i64 64, i64 0, i32 0, metadata !166} ; [ DW_TAG_const_type ]
!166 = metadata !{i32 589843, metadata !1, metadata !"timeval", metadata !167, i32 31, i64 128, i64 64, i64 0, i32 0, null, metadata !168, i32 0, null} ; [ DW_TAG_structure_type ]
!167 = metadata !{i32 589865, metadata !"time.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!168 = metadata !{metadata !169, metadata !170}
!169 = metadata !{i32 589837, metadata !166, metadata !"tv_sec", metadata !167, i32 32, i64 64, i64 64, i64 0, i32 0, metadata !49} ; [ DW_TAG_member ]
!170 = metadata !{i32 589837, metadata !166, metadata !"tv_usec", metadata !167, i32 33, i64 64, i64 64, i64 64, i32 0, metadata !171} ; [ DW_TAG_member ]
!171 = metadata !{i32 589846, metadata !22, metadata !"__suseconds_t", metadata !22, i32 143, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!172 = metadata !{i32 589870, i32 0, metadata !1, metadata !"futimesat", metadata !"futimesat", metadata !"futimesat", metadata !1, i32 277, metadata !173, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, %struct.timespec*)* @futimesat} ; [ DW_TAG_subprogram ]
!173 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !174, i32 0, null} ; [ DW_TAG_subroutine_type ]
!174 = metadata !{metadata !35, metadata !35, metadata !58, metadata !164}
!175 = metadata !{i32 589870, i32 0, metadata !1, metadata !"access", metadata !"access", metadata !"access", metadata !1, i32 73, metadata !176, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32)* @access} ; [ DW_TAG_subprogram ]
!176 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !177, i32 0, null} ; [ DW_TAG_subroutine_type ]
!177 = metadata !{metadata !35, metadata !58, metadata !35}
!178 = metadata !{i32 589870, i32 0, metadata !1, metadata !"select", metadata !"select", metadata !"select", metadata !1, i32 1295, metadata !179, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.fd_set*, %struct.fd_set*, %struct.fd_set*, %struct.timespec*)* @select} ; [ DW_TAG_subprogram ]
!179 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !180, i32 0, null} ; [ DW_TAG_subroutine_type ]
!180 = metadata !{metadata !35, metadata !35, metadata !181, metadata !181, metadata !181, metadata !191}
!181 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !182} ; [ DW_TAG_pointer_type ]
!182 = metadata !{i32 589846, metadata !183, metadata !"fd_set", metadata !183, i32 82, i64 0, i64 0, i64 0, i32 0, metadata !184} ; [ DW_TAG_typedef ]
!183 = metadata !{i32 589865, metadata !"select.h", metadata !"/usr/include/x86_64-linux-gnu/sys", metadata !2} ; [ DW_TAG_file_type ]
!184 = metadata !{i32 589843, metadata !1, metadata !"", metadata !183, i32 65, i64 1024, i64 64, i64 0, i32 0, null, metadata !185, i32 0, null} ; [ DW_TAG_structure_type ]
!185 = metadata !{metadata !186}
!186 = metadata !{i32 589837, metadata !184, metadata !"fds_bits", metadata !183, i32 69, i64 1024, i64 64, i64 0, i32 0, metadata !187} ; [ DW_TAG_member ]
!187 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 1024, i64 64, i64 0, i32 0, metadata !188, metadata !189, i32 0, null} ; [ DW_TAG_array_type ]
!188 = metadata !{i32 589846, metadata !183, metadata !"__fd_mask", metadata !183, i32 65, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!189 = metadata !{metadata !190}
!190 = metadata !{i32 589857, i64 0, i64 15}      ; [ DW_TAG_subrange_type ]
!191 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !166} ; [ DW_TAG_pointer_type ]
!192 = metadata !{i32 589870, i32 0, metadata !1, metadata !"close", metadata !"close", metadata !"close", metadata !1, i32 303, metadata !99, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @close} ; [ DW_TAG_subprogram ]
!193 = metadata !{i32 589870, i32 0, metadata !1, metadata !"dup2", metadata !"dup2", metadata !"dup2", metadata !1, i32 1156, metadata !194, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32)* @dup2} ; [ DW_TAG_subprogram ]
!194 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !195, i32 0, null} ; [ DW_TAG_subroutine_type ]
!195 = metadata !{metadata !35, metadata !35, metadata !35}
!196 = metadata !{i32 589870, i32 0, metadata !1, metadata !"dup", metadata !"dup", metadata !"dup", metadata !1, i32 1181, metadata !99, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32)* @dup} ; [ DW_TAG_subprogram ]
!197 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_open", metadata !"__fd_open", metadata !"__fd_open", metadata !1, i32 128, metadata !198, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32, i32)* @__fd_open} ; [ DW_TAG_subprogram ]
!198 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !199, i32 0, null} ; [ DW_TAG_subroutine_type ]
!199 = metadata !{metadata !35, metadata !58, metadata !35, metadata !76}
!200 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_openat", metadata !"__fd_openat", metadata !"__fd_openat", metadata !1, i32 201, metadata !201, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, i32, i32)* @__fd_openat} ; [ DW_TAG_subprogram ]
!201 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !202, i32 0, null} ; [ DW_TAG_subroutine_type ]
!202 = metadata !{metadata !35, metadata !35, metadata !58, metadata !35, metadata !76}
!203 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fcntl", metadata !"fcntl", metadata !"fcntl", metadata !1, i32 1048, metadata !194, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32, ...)* @fcntl} ; [ DW_TAG_subprogram ]
!204 = metadata !{i32 589870, i32 0, metadata !1, metadata !"ioctl", metadata !"ioctl", metadata !"ioctl", metadata !1, i32 898, metadata !205, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i64, ...)* @ioctl} ; [ DW_TAG_subprogram ]
!205 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !206, i32 0, null} ; [ DW_TAG_subroutine_type ]
!206 = metadata !{metadata !35, metadata !35, metadata !23}
!207 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_getdents", metadata !"__fd_getdents", metadata !"__fd_getdents", metadata !1, i32 814, metadata !208, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.dirent64*, i32)* @__fd_getdents} ; [ DW_TAG_subprogram ]
!208 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !209, i32 0, null} ; [ DW_TAG_subroutine_type ]
!209 = metadata !{metadata !35, metadata !11, metadata !210, metadata !11}
!210 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !211} ; [ DW_TAG_pointer_type ]
!211 = metadata !{i32 589843, metadata !1, metadata !"dirent64", metadata !212, i32 38, i64 2240, i64 64, i64 0, i32 0, null, metadata !213, i32 0, null} ; [ DW_TAG_structure_type ]
!212 = metadata !{i32 589865, metadata !"dirent.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!213 = metadata !{metadata !214, metadata !215, metadata !217, metadata !219, metadata !221}
!214 = metadata !{i32 589837, metadata !211, metadata !"d_ino", metadata !212, i32 39, i64 64, i64 64, i64 0, i32 0, metadata !25} ; [ DW_TAG_member ]
!215 = metadata !{i32 589837, metadata !211, metadata !"d_off", metadata !212, i32 40, i64 64, i64 64, i64 64, i32 0, metadata !216} ; [ DW_TAG_member ]
!216 = metadata !{i32 589846, metadata !22, metadata !"__off64_t", metadata !22, i32 133, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!217 = metadata !{i32 589837, metadata !211, metadata !"d_reclen", metadata !212, i32 41, i64 16, i64 16, i64 128, i32 0, metadata !218} ; [ DW_TAG_member ]
!218 = metadata !{i32 589860, metadata !1, metadata !"short unsigned int", metadata !1, i32 0, i64 16, i64 16, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!219 = metadata !{i32 589837, metadata !211, metadata !"d_type", metadata !212, i32 42, i64 8, i64 8, i64 144, i32 0, metadata !220} ; [ DW_TAG_member ]
!220 = metadata !{i32 589860, metadata !1, metadata !"unsigned char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!221 = metadata !{i32 589837, metadata !211, metadata !"d_name", metadata !212, i32 43, i64 2048, i64 8, i64 152, i32 0, metadata !222} ; [ DW_TAG_member ]
!222 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 2048, i64 8, i64 0, i32 0, metadata !14, metadata !223, i32 0, null} ; [ DW_TAG_array_type ]
!223 = metadata !{metadata !224}
!224 = metadata !{i32 589857, i64 0, i64 255}     ; [ DW_TAG_subrange_type ]
!225 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_lseek", metadata !"__fd_lseek", metadata !"__fd_lseek", metadata !1, i32 475, metadata !226, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i32, i64, i32)* @__fd_lseek} ; [ DW_TAG_subprogram ]
!226 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !227, i32 0, null} ; [ DW_TAG_subroutine_type ]
!227 = metadata !{metadata !70, metadata !35, metadata !70, metadata !35}
!228 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_fstat", metadata !"__fd_fstat", metadata !"__fd_fstat", metadata !1, i32 758, metadata !78, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, %struct.stat*)* @__fd_fstat} ; [ DW_TAG_subprogram ]
!229 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_lstat", metadata !"__fd_lstat", metadata !"__fd_lstat", metadata !1, i32 587, metadata !230, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.stat*)* @__fd_lstat} ; [ DW_TAG_subprogram ]
!230 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !231, i32 0, null} ; [ DW_TAG_subroutine_type ]
!231 = metadata !{metadata !35, metadata !58, metadata !16}
!232 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fstatat", metadata !"fstatat", metadata !"fstatat", metadata !1, i32 551, metadata !233, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i8*, %struct.stat*, i32)* @fstatat} ; [ DW_TAG_subprogram ]
!233 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !234, i32 0, null} ; [ DW_TAG_subroutine_type ]
!234 = metadata !{metadata !35, metadata !35, metadata !58, metadata !235, metadata !35}
!235 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !236} ; [ DW_TAG_pointer_type ]
!236 = metadata !{i32 589843, metadata !1, metadata !"stat", metadata !20, i32 47, i64 1152, i64 64, i64 0, i32 0, null, metadata !237, i32 0, null} ; [ DW_TAG_structure_type ]
!237 = metadata !{metadata !238, metadata !239, metadata !241, metadata !242, metadata !243, metadata !244, metadata !245, metadata !246, metadata !247, metadata !248, metadata !249, metadata !251, metadata !252, metadata !253, metadata !254}
!238 = metadata !{i32 589837, metadata !236, metadata !"st_dev", metadata !20, i32 48, i64 64, i64 64, i64 0, i32 0, metadata !21} ; [ DW_TAG_member ]
!239 = metadata !{i32 589837, metadata !236, metadata !"st_ino", metadata !20, i32 53, i64 64, i64 64, i64 64, i32 0, metadata !240} ; [ DW_TAG_member ]
!240 = metadata !{i32 589846, metadata !22, metadata !"__ino_t", metadata !22, i32 128, i64 0, i64 0, i64 0, i32 0, metadata !23} ; [ DW_TAG_typedef ]
!241 = metadata !{i32 589837, metadata !236, metadata !"st_nlink", metadata !20, i32 61, i64 64, i64 64, i64 128, i32 0, metadata !27} ; [ DW_TAG_member ]
!242 = metadata !{i32 589837, metadata !236, metadata !"st_mode", metadata !20, i32 62, i64 32, i64 32, i64 192, i32 0, metadata !29} ; [ DW_TAG_member ]
!243 = metadata !{i32 589837, metadata !236, metadata !"st_uid", metadata !20, i32 64, i64 32, i64 32, i64 224, i32 0, metadata !31} ; [ DW_TAG_member ]
!244 = metadata !{i32 589837, metadata !236, metadata !"st_gid", metadata !20, i32 65, i64 32, i64 32, i64 256, i32 0, metadata !33} ; [ DW_TAG_member ]
!245 = metadata !{i32 589837, metadata !236, metadata !"__pad0", metadata !20, i32 67, i64 32, i64 32, i64 288, i32 0, metadata !35} ; [ DW_TAG_member ]
!246 = metadata !{i32 589837, metadata !236, metadata !"st_rdev", metadata !20, i32 69, i64 64, i64 64, i64 320, i32 0, metadata !21} ; [ DW_TAG_member ]
!247 = metadata !{i32 589837, metadata !236, metadata !"st_size", metadata !20, i32 74, i64 64, i64 64, i64 384, i32 0, metadata !38} ; [ DW_TAG_member ]
!248 = metadata !{i32 589837, metadata !236, metadata !"st_blksize", metadata !20, i32 78, i64 64, i64 64, i64 448, i32 0, metadata !41} ; [ DW_TAG_member ]
!249 = metadata !{i32 589837, metadata !236, metadata !"st_blocks", metadata !20, i32 80, i64 64, i64 64, i64 512, i32 0, metadata !250} ; [ DW_TAG_member ]
!250 = metadata !{i32 589846, metadata !22, metadata !"__blkcnt_t", metadata !22, i32 159, i64 0, i64 0, i64 0, i32 0, metadata !39} ; [ DW_TAG_typedef ]
!251 = metadata !{i32 589837, metadata !236, metadata !"st_atim", metadata !20, i32 91, i64 128, i64 64, i64 576, i32 0, metadata !45} ; [ DW_TAG_member ]
!252 = metadata !{i32 589837, metadata !236, metadata !"st_mtim", metadata !20, i32 92, i64 128, i64 64, i64 704, i32 0, metadata !45} ; [ DW_TAG_member ]
!253 = metadata !{i32 589837, metadata !236, metadata !"st_ctim", metadata !20, i32 93, i64 128, i64 64, i64 832, i32 0, metadata !45} ; [ DW_TAG_member ]
!254 = metadata !{i32 589837, metadata !236, metadata !"__glibc_reserved", metadata !20, i32 106, i64 192, i64 64, i64 960, i32 0, metadata !55} ; [ DW_TAG_member ]
!255 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__fd_stat", metadata !"__fd_stat", metadata !"__fd_stat", metadata !1, i32 532, metadata !230, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, %struct.stat*)* @__fd_stat} ; [ DW_TAG_subprogram ]
!256 = metadata !{i32 589870, i32 0, metadata !1, metadata !"write", metadata !"write", metadata !"write", metadata !1, i32 403, metadata !257, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i32, i8*, i64)* @write} ; [ DW_TAG_subprogram ]
!257 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !258, i32 0, null} ; [ DW_TAG_subroutine_type ]
!258 = metadata !{metadata !96, metadata !35, metadata !143, metadata !97}
!259 = metadata !{i32 589870, i32 0, metadata !1, metadata !"read", metadata !"read", metadata !"read", metadata !1, i32 335, metadata !257, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i64 (i32, i8*, i64)* @read} ; [ DW_TAG_subprogram ]
!260 = metadata !{i32 589870, i32 0, metadata !1, metadata !"__df_chmod", metadata !"__df_chmod", metadata !"", metadata !1, i32 645, metadata !261, i1 true, i1 true, i32 0, i32 0, null, i32 256, i1 true, null} ; [ DW_TAG_subprogram ]
!261 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !262, i32 0, null} ; [ DW_TAG_subroutine_type ]
!262 = metadata !{metadata !35, metadata !5, metadata !76}
!263 = metadata !{i32 589870, i32 0, metadata !1, metadata !"fchmod", metadata !"fchmod", metadata !"fchmod", metadata !1, i32 680, metadata !264, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i32, i32)* @fchmod} ; [ DW_TAG_subprogram ]
!264 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !265, i32 0, null} ; [ DW_TAG_subroutine_type ]
!265 = metadata !{metadata !35, metadata !35, metadata !76}
!266 = metadata !{i32 589870, i32 0, metadata !1, metadata !"chmod", metadata !"chmod", metadata !"chmod", metadata !1, i32 658, metadata !267, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i32)* @chmod} ; [ DW_TAG_subprogram ]
!267 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !268, i32 0, null} ; [ DW_TAG_subroutine_type ]
!268 = metadata !{metadata !35, metadata !58, metadata !76}
!269 = metadata !{i32 590081, metadata !0, metadata !"pathname", metadata !1, i32 39, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!270 = metadata !{i32 590080, metadata !271, metadata !"c", metadata !1, i32 40, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!271 = metadata !{i32 589835, metadata !0, i32 39, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!272 = metadata !{i32 590080, metadata !271, metadata !"i", metadata !1, i32 41, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!273 = metadata !{i32 590080, metadata !274, metadata !"df", metadata !1, i32 48, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!274 = metadata !{i32 589835, metadata !271, i32 48, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!275 = metadata !{i32 590081, metadata !60, metadata !"fd", metadata !1, i32 63, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!276 = metadata !{i32 590080, metadata !277, metadata !"f", metadata !1, i32 65, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!277 = metadata !{i32 589835, metadata !278, i32 63, i32 0, metadata !1, i32 3} ; [ DW_TAG_lexical_block ]
!278 = metadata !{i32 589835, metadata !60, i32 63, i32 0, metadata !1, i32 2} ; [ DW_TAG_lexical_block ]
!279 = metadata !{i32 590081, metadata !73, metadata !"mask", metadata !1, i32 88, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!280 = metadata !{i32 590080, metadata !281, metadata !"r", metadata !1, i32 89, metadata !76, i32 0} ; [ DW_TAG_auto_variable ]
!281 = metadata !{i32 589835, metadata !73, i32 88, i32 0, metadata !1, i32 4} ; [ DW_TAG_lexical_block ]
!282 = metadata !{i32 590081, metadata !77, metadata !"flags", metadata !1, i32 97, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!283 = metadata !{i32 590081, metadata !77, metadata !"s", metadata !1, i32 97, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!284 = metadata !{i32 590080, metadata !285, metadata !"write_access", metadata !1, i32 98, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!285 = metadata !{i32 589835, metadata !77, i32 97, i32 0, metadata !1, i32 5} ; [ DW_TAG_lexical_block ]
!286 = metadata !{i32 590080, metadata !285, metadata !"read_access", metadata !1, i32 98, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!287 = metadata !{i32 590080, metadata !285, metadata !"mode", metadata !1, i32 99, metadata !76, i32 0} ; [ DW_TAG_auto_variable ]
!288 = metadata !{i32 590081, metadata !80, metadata !"path", metadata !1, i32 1457, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!289 = metadata !{i32 590081, metadata !83, metadata !"dirfd", metadata !1, i32 1239, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!290 = metadata !{i32 590081, metadata !83, metadata !"pathname", metadata !1, i32 1239, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!291 = metadata !{i32 590081, metadata !83, metadata !"flags", metadata !1, i32 1239, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!292 = metadata !{i32 590080, metadata !293, metadata !"dfile", metadata !1, i32 1242, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!293 = metadata !{i32 589835, metadata !83, i32 1239, i32 0, metadata !1, i32 7} ; [ DW_TAG_lexical_block ]
!294 = metadata !{i32 590081, metadata !86, metadata !"pathname", metadata !1, i32 1218, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!295 = metadata !{i32 590080, metadata !296, metadata !"dfile", metadata !1, i32 1219, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!296 = metadata !{i32 589835, metadata !86, i32 1218, i32 0, metadata !1, i32 8} ; [ DW_TAG_lexical_block ]
!297 = metadata !{i32 590081, metadata !87, metadata !"pathname", metadata !1, i32 1200, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!298 = metadata !{i32 590080, metadata !299, metadata !"dfile", metadata !1, i32 1201, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!299 = metadata !{i32 589835, metadata !87, i32 1200, i32 0, metadata !1, i32 9} ; [ DW_TAG_lexical_block ]
!300 = metadata !{i32 590081, metadata !88, metadata !"df", metadata !1, i32 707, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!301 = metadata !{i32 590081, metadata !88, metadata !"owner", metadata !1, i32 707, metadata !91, i32 0} ; [ DW_TAG_arg_variable ]
!302 = metadata !{i32 590081, metadata !88, metadata !"group", metadata !1, i32 707, metadata !92, i32 0} ; [ DW_TAG_arg_variable ]
!303 = metadata !{i32 590081, metadata !93, metadata !"path", metadata !1, i32 1262, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!304 = metadata !{i32 590081, metadata !93, metadata !"buf", metadata !1, i32 1262, metadata !13, i32 0} ; [ DW_TAG_arg_variable ]
!305 = metadata !{i32 590081, metadata !93, metadata !"bufsize", metadata !1, i32 1262, metadata !97, i32 0} ; [ DW_TAG_arg_variable ]
!306 = metadata !{i32 590080, metadata !307, metadata !"dfile", metadata !1, i32 1263, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!307 = metadata !{i32 589835, metadata !93, i32 1262, i32 0, metadata !1, i32 11} ; [ DW_TAG_lexical_block ]
!308 = metadata !{i32 590080, metadata !309, metadata !"r", metadata !1, i32 1279, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!309 = metadata !{i32 589835, metadata !307, i32 1279, i32 0, metadata !1, i32 12} ; [ DW_TAG_lexical_block ]
!310 = metadata !{i32 590081, metadata !98, metadata !"fd", metadata !1, i32 1140, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!311 = metadata !{i32 590080, metadata !312, metadata !"f", metadata !1, i32 1141, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!312 = metadata !{i32 589835, metadata !98, i32 1140, i32 0, metadata !1, i32 13} ; [ DW_TAG_lexical_block ]
!313 = metadata !{i32 590080, metadata !314, metadata !"r", metadata !1, i32 1149, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!314 = metadata !{i32 589835, metadata !312, i32 1149, i32 0, metadata !1, i32 14} ; [ DW_TAG_lexical_block ]
!315 = metadata !{i32 590081, metadata !101, metadata !"fd", metadata !1, i32 1120, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!316 = metadata !{i32 590081, metadata !101, metadata !"buf", metadata !1, i32 1120, metadata !104, i32 0} ; [ DW_TAG_arg_variable ]
!317 = metadata !{i32 590080, metadata !318, metadata !"f", metadata !1, i32 1121, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!318 = metadata !{i32 589835, metadata !101, i32 1120, i32 0, metadata !1, i32 15} ; [ DW_TAG_lexical_block ]
!319 = metadata !{i32 590080, metadata !320, metadata !"r", metadata !1, i32 1133, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!320 = metadata !{i32 589835, metadata !318, i32 1133, i32 0, metadata !1, i32 16} ; [ DW_TAG_lexical_block ]
!321 = metadata !{i32 590081, metadata !133, metadata !"fd", metadata !1, i32 781, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!322 = metadata !{i32 590081, metadata !133, metadata !"length", metadata !1, i32 781, metadata !70, i32 0} ; [ DW_TAG_arg_variable ]
!323 = metadata !{i32 590080, metadata !324, metadata !"f", metadata !1, i32 783, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!324 = metadata !{i32 589835, metadata !133, i32 781, i32 0, metadata !1, i32 17} ; [ DW_TAG_lexical_block ]
!325 = metadata !{i32 590080, metadata !326, metadata !"r", metadata !1, i32 804, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!326 = metadata !{i32 589835, metadata !324, i32 804, i32 0, metadata !1, i32 18} ; [ DW_TAG_lexical_block ]
!327 = metadata !{i32 589876, i32 0, metadata !133, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 782, metadata !35, i1 true, i1 true, i32* @n_calls.5292} ; [ DW_TAG_variable ]
!328 = metadata !{i32 589876, i32 0, metadata !147, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 1381, metadata !35, i1 true, i1 true, i32* @n_calls.5868} ; [ DW_TAG_variable ]
!329 = metadata !{i32 589876, i32 0, metadata !192, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 304, metadata !35, i1 true, i1 true, i32* @n_calls.4900} ; [ DW_TAG_variable ]
!330 = metadata !{i32 589876, i32 0, metadata !256, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 404, metadata !35, i1 true, i1 true, i32* @n_calls.4981} ; [ DW_TAG_variable ]
!331 = metadata !{i32 589876, i32 0, metadata !259, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 336, metadata !35, i1 true, i1 true, i32* @n_calls.4920} ; [ DW_TAG_variable ]
!332 = metadata !{i32 589876, i32 0, metadata !263, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 681, metadata !35, i1 true, i1 true, i32* @n_calls.5199} ; [ DW_TAG_variable ]
!333 = metadata !{i32 589876, i32 0, metadata !266, metadata !"n_calls", metadata !"n_calls", metadata !"", metadata !1, i32 659, metadata !35, i1 true, i1 true, i32* @n_calls.5176} ; [ DW_TAG_variable ]
!334 = metadata !{i32 590081, metadata !136, metadata !"fd", metadata !1, i32 726, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!335 = metadata !{i32 590081, metadata !136, metadata !"owner", metadata !1, i32 726, metadata !91, i32 0} ; [ DW_TAG_arg_variable ]
!336 = metadata !{i32 590081, metadata !136, metadata !"group", metadata !1, i32 726, metadata !92, i32 0} ; [ DW_TAG_arg_variable ]
!337 = metadata !{i32 590080, metadata !338, metadata !"f", metadata !1, i32 727, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!338 = metadata !{i32 589835, metadata !136, i32 726, i32 0, metadata !1, i32 19} ; [ DW_TAG_lexical_block ]
!339 = metadata !{i32 590080, metadata !340, metadata !"r", metadata !1, i32 737, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!340 = metadata !{i32 589835, metadata !338, i32 737, i32 0, metadata !1, i32 20} ; [ DW_TAG_lexical_block ]
!341 = metadata !{i32 590081, metadata !139, metadata !"fd", metadata !1, i32 624, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!342 = metadata !{i32 590080, metadata !343, metadata !"f", metadata !1, i32 625, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!343 = metadata !{i32 589835, metadata !139, i32 624, i32 0, metadata !1, i32 21} ; [ DW_TAG_lexical_block ]
!344 = metadata !{i32 590080, metadata !345, metadata !"r", metadata !1, i32 637, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!345 = metadata !{i32 589835, metadata !343, i32 637, i32 0, metadata !1, i32 22} ; [ DW_TAG_lexical_block ]
!346 = metadata !{i32 590081, metadata !140, metadata !"p", metadata !1, i32 1415, metadata !143, i32 0} ; [ DW_TAG_arg_variable ]
!347 = metadata !{i32 590080, metadata !348, metadata !"pc", metadata !1, i32 1417, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!348 = metadata !{i32 589835, metadata !140, i32 1415, i32 0, metadata !1, i32 23} ; [ DW_TAG_lexical_block ]
!349 = metadata !{i32 590081, metadata !144, metadata !"s", metadata !1, i32 1422, metadata !97, i32 0} ; [ DW_TAG_arg_variable ]
!350 = metadata !{i32 590080, metadata !351, metadata !"sc", metadata !1, i32 1423, metadata !97, i32 0} ; [ DW_TAG_auto_variable ]
!351 = metadata !{i32 589835, metadata !144, i32 1422, i32 0, metadata !1, i32 24} ; [ DW_TAG_lexical_block ]
!352 = metadata !{i32 590081, metadata !147, metadata !"buf", metadata !1, i32 1380, metadata !13, i32 0} ; [ DW_TAG_arg_variable ]
!353 = metadata !{i32 590081, metadata !147, metadata !"size", metadata !1, i32 1380, metadata !97, i32 0} ; [ DW_TAG_arg_variable ]
!354 = metadata !{i32 590080, metadata !355, metadata !"r", metadata !1, i32 1382, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!355 = metadata !{i32 589835, metadata !147, i32 1380, i32 0, metadata !1, i32 25} ; [ DW_TAG_lexical_block ]
!356 = metadata !{i32 590081, metadata !150, metadata !"s", metadata !1, i32 1428, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!357 = metadata !{i32 590080, metadata !358, metadata !"sc", metadata !1, i32 1429, metadata !13, i32 0} ; [ DW_TAG_auto_variable ]
!358 = metadata !{i32 589835, metadata !150, i32 1428, i32 0, metadata !1, i32 26} ; [ DW_TAG_lexical_block ]
!359 = metadata !{i32 590080, metadata !358, metadata !"i", metadata !1, i32 1430, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!360 = metadata !{i32 590080, metadata !361, metadata !"c", metadata !1, i32 1433, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!361 = metadata !{i32 589835, metadata !358, i32 1433, i32 0, metadata !1, i32 27} ; [ DW_TAG_lexical_block ]
!362 = metadata !{i32 590080, metadata !363, metadata !"cc", metadata !1, i32 1442, metadata !14, i32 0} ; [ DW_TAG_auto_variable ]
!363 = metadata !{i32 589835, metadata !361, i32 1442, i32 0, metadata !1, i32 28} ; [ DW_TAG_lexical_block ]
!364 = metadata !{i32 590081, metadata !153, metadata !"path", metadata !1, i32 1103, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!365 = metadata !{i32 590081, metadata !153, metadata !"buf", metadata !1, i32 1103, metadata !104, i32 0} ; [ DW_TAG_arg_variable ]
!366 = metadata !{i32 590080, metadata !367, metadata !"dfile", metadata !1, i32 1104, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!367 = metadata !{i32 589835, metadata !153, i32 1103, i32 0, metadata !1, i32 29} ; [ DW_TAG_lexical_block ]
!368 = metadata !{i32 590080, metadata !369, metadata !"r", metadata !1, i32 1113, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!369 = metadata !{i32 589835, metadata !367, i32 1113, i32 0, metadata !1, i32 30} ; [ DW_TAG_lexical_block ]
!370 = metadata !{i32 590081, metadata !156, metadata !"path", metadata !1, i32 744, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!371 = metadata !{i32 590081, metadata !156, metadata !"owner", metadata !1, i32 744, metadata !91, i32 0} ; [ DW_TAG_arg_variable ]
!372 = metadata !{i32 590081, metadata !156, metadata !"group", metadata !1, i32 744, metadata !92, i32 0} ; [ DW_TAG_arg_variable ]
!373 = metadata !{i32 590080, metadata !374, metadata !"df", metadata !1, i32 746, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!374 = metadata !{i32 589835, metadata !156, i32 744, i32 0, metadata !1, i32 31} ; [ DW_TAG_lexical_block ]
!375 = metadata !{i32 590080, metadata !376, metadata !"r", metadata !1, i32 751, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!376 = metadata !{i32 589835, metadata !374, i32 751, i32 0, metadata !1, i32 32} ; [ DW_TAG_lexical_block ]
!377 = metadata !{i32 590081, metadata !159, metadata !"path", metadata !1, i32 713, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!378 = metadata !{i32 590081, metadata !159, metadata !"owner", metadata !1, i32 713, metadata !91, i32 0} ; [ DW_TAG_arg_variable ]
!379 = metadata !{i32 590081, metadata !159, metadata !"group", metadata !1, i32 713, metadata !92, i32 0} ; [ DW_TAG_arg_variable ]
!380 = metadata !{i32 590080, metadata !381, metadata !"df", metadata !1, i32 714, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!381 = metadata !{i32 589835, metadata !159, i32 713, i32 0, metadata !1, i32 33} ; [ DW_TAG_lexical_block ]
!382 = metadata !{i32 590080, metadata !383, metadata !"r", metadata !1, i32 719, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!383 = metadata !{i32 589835, metadata !381, i32 719, i32 0, metadata !1, i32 34} ; [ DW_TAG_lexical_block ]
!384 = metadata !{i32 590081, metadata !160, metadata !"path", metadata !1, i32 606, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!385 = metadata !{i32 590080, metadata !386, metadata !"dfile", metadata !1, i32 607, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!386 = metadata !{i32 589835, metadata !160, i32 606, i32 0, metadata !1, i32 35} ; [ DW_TAG_lexical_block ]
!387 = metadata !{i32 590080, metadata !388, metadata !"r", metadata !1, i32 617, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!388 = metadata !{i32 589835, metadata !386, i32 617, i32 0, metadata !1, i32 36} ; [ DW_TAG_lexical_block ]
!389 = metadata !{i32 590081, metadata !161, metadata !"path", metadata !1, i32 256, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!390 = metadata !{i32 590081, metadata !161, metadata !"times", metadata !1, i32 256, metadata !164, i32 0} ; [ DW_TAG_arg_variable ]
!391 = metadata !{i32 590080, metadata !392, metadata !"dfile", metadata !1, i32 257, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!392 = metadata !{i32 589835, metadata !161, i32 256, i32 0, metadata !1, i32 37} ; [ DW_TAG_lexical_block ]
!393 = metadata !{i32 590080, metadata !392, metadata !"r", metadata !1, i32 269, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!394 = metadata !{i32 590081, metadata !172, metadata !"fd", metadata !1, i32 277, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!395 = metadata !{i32 590081, metadata !172, metadata !"path", metadata !1, i32 277, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!396 = metadata !{i32 590081, metadata !172, metadata !"times", metadata !1, i32 277, metadata !164, i32 0} ; [ DW_TAG_arg_variable ]
!397 = metadata !{i32 590080, metadata !398, metadata !"r", metadata !1, i32 295, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!398 = metadata !{i32 589835, metadata !172, i32 277, i32 0, metadata !1, i32 38} ; [ DW_TAG_lexical_block ]
!399 = metadata !{i32 590080, metadata !400, metadata !"f", metadata !1, i32 279, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!400 = metadata !{i32 589835, metadata !398, i32 279, i32 0, metadata !1, i32 39} ; [ DW_TAG_lexical_block ]
!401 = metadata !{i32 590081, metadata !175, metadata !"pathname", metadata !1, i32 73, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!402 = metadata !{i32 590081, metadata !175, metadata !"mode", metadata !1, i32 73, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!403 = metadata !{i32 590080, metadata !404, metadata !"dfile", metadata !1, i32 74, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!404 = metadata !{i32 589835, metadata !175, i32 73, i32 0, metadata !1, i32 40} ; [ DW_TAG_lexical_block ]
!405 = metadata !{i32 590080, metadata !406, metadata !"r", metadata !1, i32 81, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!406 = metadata !{i32 589835, metadata !404, i32 81, i32 0, metadata !1, i32 41} ; [ DW_TAG_lexical_block ]
!407 = metadata !{i32 590081, metadata !178, metadata !"nfds", metadata !1, i32 1294, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!408 = metadata !{i32 590081, metadata !178, metadata !"read", metadata !1, i32 1294, metadata !181, i32 0} ; [ DW_TAG_arg_variable ]
!409 = metadata !{i32 590081, metadata !178, metadata !"write", metadata !1, i32 1294, metadata !181, i32 0} ; [ DW_TAG_arg_variable ]
!410 = metadata !{i32 590081, metadata !178, metadata !"except", metadata !1, i32 1295, metadata !181, i32 0} ; [ DW_TAG_arg_variable ]
!411 = metadata !{i32 590081, metadata !178, metadata !"timeout", metadata !1, i32 1295, metadata !191, i32 0} ; [ DW_TAG_arg_variable ]
!412 = metadata !{i32 590080, metadata !413, metadata !"in_read", metadata !1, i32 1296, metadata !182, i32 0} ; [ DW_TAG_auto_variable ]
!413 = metadata !{i32 589835, metadata !178, i32 1295, i32 0, metadata !1, i32 42} ; [ DW_TAG_lexical_block ]
!414 = metadata !{i32 590080, metadata !413, metadata !"in_write", metadata !1, i32 1296, metadata !182, i32 0} ; [ DW_TAG_auto_variable ]
!415 = metadata !{i32 590080, metadata !413, metadata !"in_except", metadata !1, i32 1296, metadata !182, i32 0} ; [ DW_TAG_auto_variable ]
!416 = metadata !{i32 590080, metadata !413, metadata !"os_read", metadata !1, i32 1296, metadata !182, i32 0} ; [ DW_TAG_auto_variable ]
!417 = metadata !{i32 590080, metadata !413, metadata !"os_write", metadata !1, i32 1296, metadata !182, i32 0} ; [ DW_TAG_auto_variable ]
!418 = metadata !{i32 590080, metadata !413, metadata !"os_except", metadata !1, i32 1296, metadata !182, i32 0} ; [ DW_TAG_auto_variable ]
!419 = metadata !{i32 590080, metadata !413, metadata !"i", metadata !1, i32 1297, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!420 = metadata !{i32 590080, metadata !413, metadata !"count", metadata !1, i32 1297, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!421 = metadata !{i32 590080, metadata !413, metadata !"os_nfds", metadata !1, i32 1297, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!422 = metadata !{i32 590080, metadata !423, metadata !"f", metadata !1, i32 1327, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!423 = metadata !{i32 589835, metadata !413, i32 1327, i32 0, metadata !1, i32 43} ; [ DW_TAG_lexical_block ]
!424 = metadata !{i32 590080, metadata !425, metadata !"tv", metadata !1, i32 1349, metadata !166, i32 0} ; [ DW_TAG_auto_variable ]
!425 = metadata !{i32 589835, metadata !413, i32 1349, i32 0, metadata !1, i32 44} ; [ DW_TAG_lexical_block ]
!426 = metadata !{i32 590080, metadata !425, metadata !"r", metadata !1, i32 1350, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!427 = metadata !{i32 590080, metadata !428, metadata !"f", metadata !1, i32 1365, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!428 = metadata !{i32 589835, metadata !425, i32 1365, i32 0, metadata !1, i32 45} ; [ DW_TAG_lexical_block ]
!429 = metadata !{i32 590081, metadata !192, metadata !"fd", metadata !1, i32 303, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!430 = metadata !{i32 590080, metadata !431, metadata !"f", metadata !1, i32 305, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!431 = metadata !{i32 589835, metadata !192, i32 303, i32 0, metadata !1, i32 46} ; [ DW_TAG_lexical_block ]
!432 = metadata !{i32 590080, metadata !431, metadata !"r", metadata !1, i32 306, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!433 = metadata !{i32 590081, metadata !193, metadata !"oldfd", metadata !1, i32 1156, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!434 = metadata !{i32 590081, metadata !193, metadata !"newfd", metadata !1, i32 1156, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!435 = metadata !{i32 590080, metadata !436, metadata !"f", metadata !1, i32 1157, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!436 = metadata !{i32 589835, metadata !193, i32 1156, i32 0, metadata !1, i32 47} ; [ DW_TAG_lexical_block ]
!437 = metadata !{i32 590080, metadata !438, metadata !"f2", metadata !1, i32 1163, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!438 = metadata !{i32 589835, metadata !436, i32 1163, i32 0, metadata !1, i32 48} ; [ DW_TAG_lexical_block ]
!439 = metadata !{i32 590081, metadata !196, metadata !"oldfd", metadata !1, i32 1181, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!440 = metadata !{i32 590080, metadata !441, metadata !"f", metadata !1, i32 1182, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!441 = metadata !{i32 589835, metadata !196, i32 1181, i32 0, metadata !1, i32 49} ; [ DW_TAG_lexical_block ]
!442 = metadata !{i32 590080, metadata !443, metadata !"fd", metadata !1, i32 1187, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!443 = metadata !{i32 589835, metadata !441, i32 1188, i32 0, metadata !1, i32 50} ; [ DW_TAG_lexical_block ]
!444 = metadata !{i32 590081, metadata !197, metadata !"pathname", metadata !1, i32 128, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!445 = metadata !{i32 590081, metadata !197, metadata !"flags", metadata !1, i32 128, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!446 = metadata !{i32 590081, metadata !197, metadata !"mode", metadata !1, i32 128, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!447 = metadata !{i32 590080, metadata !448, metadata !"df", metadata !1, i32 129, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!448 = metadata !{i32 589835, metadata !197, i32 128, i32 0, metadata !1, i32 51} ; [ DW_TAG_lexical_block ]
!449 = metadata !{i32 590080, metadata !448, metadata !"f", metadata !1, i32 130, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!450 = metadata !{i32 590080, metadata !448, metadata !"fd", metadata !1, i32 131, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!451 = metadata !{i32 590080, metadata !452, metadata !"os_fd", metadata !1, i32 181, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!452 = metadata !{i32 589835, metadata !448, i32 181, i32 0, metadata !1, i32 52} ; [ DW_TAG_lexical_block ]
!453 = metadata !{i32 590081, metadata !200, metadata !"basefd", metadata !1, i32 201, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!454 = metadata !{i32 590081, metadata !200, metadata !"pathname", metadata !1, i32 201, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!455 = metadata !{i32 590081, metadata !200, metadata !"flags", metadata !1, i32 201, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!456 = metadata !{i32 590081, metadata !200, metadata !"mode", metadata !1, i32 201, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!457 = metadata !{i32 590080, metadata !458, metadata !"f", metadata !1, i32 202, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!458 = metadata !{i32 589835, metadata !200, i32 201, i32 0, metadata !1, i32 53} ; [ DW_TAG_lexical_block ]
!459 = metadata !{i32 590080, metadata !458, metadata !"fd", metadata !1, i32 203, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!460 = metadata !{i32 590080, metadata !458, metadata !"os_fd", metadata !1, i32 236, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!461 = metadata !{i32 590080, metadata !462, metadata !"bf", metadata !1, i32 205, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!462 = metadata !{i32 589835, metadata !458, i32 205, i32 0, metadata !1, i32 54} ; [ DW_TAG_lexical_block ]
!463 = metadata !{i32 590081, metadata !203, metadata !"fd", metadata !1, i32 1048, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!464 = metadata !{i32 590081, metadata !203, metadata !"cmd", metadata !1, i32 1048, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!465 = metadata !{i32 590080, metadata !466, metadata !"f", metadata !1, i32 1049, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!466 = metadata !{i32 589835, metadata !203, i32 1048, i32 0, metadata !1, i32 55} ; [ DW_TAG_lexical_block ]
!467 = metadata !{i32 590080, metadata !466, metadata !"ap", metadata !1, i32 1050, metadata !468, i32 0} ; [ DW_TAG_auto_variable ]
!468 = metadata !{i32 589846, metadata !469, metadata !"va_list", metadata !469, i32 110, i64 0, i64 0, i64 0, i32 0, metadata !470} ; [ DW_TAG_typedef ]
!469 = metadata !{i32 589865, metadata !"stdio.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!470 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 192, i64 64, i64 0, i32 0, metadata !471, metadata !478, i32 0, null} ; [ DW_TAG_array_type ]
!471 = metadata !{i32 589843, metadata !1, metadata !"__va_list_tag", metadata !472, i32 0, i64 192, i64 64, i64 0, i32 0, null, metadata !473, i32 0, null} ; [ DW_TAG_structure_type ]
!472 = metadata !{i32 589865, metadata !"<built-in>", metadata !"/home/qiu/QTools/klee/runtime/POSIX/", metadata !2} ; [ DW_TAG_file_type ]
!473 = metadata !{metadata !474, metadata !475, metadata !476, metadata !477}
!474 = metadata !{i32 589837, metadata !471, metadata !"gp_offset", metadata !472, i32 0, i64 32, i64 32, i64 0, i32 0, metadata !11} ; [ DW_TAG_member ]
!475 = metadata !{i32 589837, metadata !471, metadata !"fp_offset", metadata !472, i32 0, i64 32, i64 32, i64 32, i32 0, metadata !11} ; [ DW_TAG_member ]
!476 = metadata !{i32 589837, metadata !471, metadata !"overflow_arg_area", metadata !472, i32 0, i64 64, i64 64, i64 64, i32 0, metadata !143} ; [ DW_TAG_member ]
!477 = metadata !{i32 589837, metadata !471, metadata !"reg_save_area", metadata !472, i32 0, i64 64, i64 64, i64 128, i32 0, metadata !143} ; [ DW_TAG_member ]
!478 = metadata !{metadata !479}
!479 = metadata !{i32 589857, i64 0, i64 0}       ; [ DW_TAG_subrange_type ]
!480 = metadata !{i32 590080, metadata !466, metadata !"arg", metadata !1, i32 1051, metadata !11, i32 0} ; [ DW_TAG_auto_variable ]
!481 = metadata !{i32 590080, metadata !482, metadata !"flags", metadata !1, i32 1070, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!482 = metadata !{i32 589835, metadata !466, i32 1070, i32 0, metadata !1, i32 56} ; [ DW_TAG_lexical_block ]
!483 = metadata !{i32 590080, metadata !484, metadata !"r", metadata !1, i32 1096, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!484 = metadata !{i32 589835, metadata !466, i32 1096, i32 0, metadata !1, i32 57} ; [ DW_TAG_lexical_block ]
!485 = metadata !{i32 590081, metadata !204, metadata !"fd", metadata !1, i32 898, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!486 = metadata !{i32 590081, metadata !204, metadata !"request", metadata !1, i32 898, metadata !23, i32 0} ; [ DW_TAG_arg_variable ]
!487 = metadata !{i32 590080, metadata !488, metadata !"f", metadata !1, i32 902, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!488 = metadata !{i32 589835, metadata !204, i32 898, i32 0, metadata !1, i32 58} ; [ DW_TAG_lexical_block ]
!489 = metadata !{i32 590080, metadata !488, metadata !"ap", metadata !1, i32 903, metadata !468, i32 0} ; [ DW_TAG_auto_variable ]
!490 = metadata !{i32 590080, metadata !488, metadata !"buf", metadata !1, i32 904, metadata !143, i32 0} ; [ DW_TAG_auto_variable ]
!491 = metadata !{i32 590080, metadata !492, metadata !"stat", metadata !1, i32 920, metadata !235, i32 0} ; [ DW_TAG_auto_variable ]
!492 = metadata !{i32 589835, metadata !488, i32 920, i32 0, metadata !1, i32 59} ; [ DW_TAG_lexical_block ]
!493 = metadata !{i32 590080, metadata !494, metadata !"ts", metadata !1, i32 924, metadata !495, i32 0} ; [ DW_TAG_auto_variable ]
!494 = metadata !{i32 589835, metadata !492, i32 924, i32 0, metadata !1, i32 60} ; [ DW_TAG_lexical_block ]
!495 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !496} ; [ DW_TAG_pointer_type ]
!496 = metadata !{i32 589843, metadata !1, metadata !"termios", metadata !497, i32 29, i64 480, i64 32, i64 0, i32 0, null, metadata !498, i32 0, null} ; [ DW_TAG_structure_type ]
!497 = metadata !{i32 589865, metadata !"termios.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!498 = metadata !{metadata !499, metadata !501, metadata !502, metadata !503, metadata !504, metadata !506, metadata !510, metadata !512}
!499 = metadata !{i32 589837, metadata !496, metadata !"c_iflag", metadata !497, i32 30, i64 32, i64 32, i64 0, i32 0, metadata !500} ; [ DW_TAG_member ]
!500 = metadata !{i32 589846, metadata !497, metadata !"tcflag_t", metadata !497, i32 29, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!501 = metadata !{i32 589837, metadata !496, metadata !"c_oflag", metadata !497, i32 31, i64 32, i64 32, i64 32, i32 0, metadata !500} ; [ DW_TAG_member ]
!502 = metadata !{i32 589837, metadata !496, metadata !"c_cflag", metadata !497, i32 32, i64 32, i64 32, i64 64, i32 0, metadata !500} ; [ DW_TAG_member ]
!503 = metadata !{i32 589837, metadata !496, metadata !"c_lflag", metadata !497, i32 33, i64 32, i64 32, i64 96, i32 0, metadata !500} ; [ DW_TAG_member ]
!504 = metadata !{i32 589837, metadata !496, metadata !"c_line", metadata !497, i32 34, i64 8, i64 8, i64 128, i32 0, metadata !505} ; [ DW_TAG_member ]
!505 = metadata !{i32 589846, metadata !497, metadata !"cc_t", metadata !497, i32 24, i64 0, i64 0, i64 0, i32 0, metadata !220} ; [ DW_TAG_typedef ]
!506 = metadata !{i32 589837, metadata !496, metadata !"c_cc", metadata !497, i32 35, i64 256, i64 8, i64 136, i32 0, metadata !507} ; [ DW_TAG_member ]
!507 = metadata !{i32 589825, metadata !1, metadata !"", metadata !1, i32 0, i64 256, i64 8, i64 0, i32 0, metadata !505, metadata !508, i32 0, null} ; [ DW_TAG_array_type ]
!508 = metadata !{metadata !509}
!509 = metadata !{i32 589857, i64 0, i64 31}      ; [ DW_TAG_subrange_type ]
!510 = metadata !{i32 589837, metadata !496, metadata !"c_ispeed", metadata !497, i32 36, i64 32, i64 32, i64 416, i32 0, metadata !511} ; [ DW_TAG_member ]
!511 = metadata !{i32 589846, metadata !497, metadata !"speed_t", metadata !497, i32 25, i64 0, i64 0, i64 0, i32 0, metadata !11} ; [ DW_TAG_typedef ]
!512 = metadata !{i32 589837, metadata !496, metadata !"c_ospeed", metadata !497, i32 37, i64 32, i64 32, i64 448, i32 0, metadata !511} ; [ DW_TAG_member ]
!513 = metadata !{i32 590080, metadata !514, metadata !"ws", metadata !1, i32 993, metadata !515, i32 0} ; [ DW_TAG_auto_variable ]
!514 = metadata !{i32 589835, metadata !492, i32 993, i32 0, metadata !1, i32 61} ; [ DW_TAG_lexical_block ]
!515 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !516} ; [ DW_TAG_pointer_type ]
!516 = metadata !{i32 589843, metadata !1, metadata !"winsize", metadata !517, i32 28, i64 64, i64 16, i64 0, i32 0, null, metadata !518, i32 0, null} ; [ DW_TAG_structure_type ]
!517 = metadata !{i32 589865, metadata !"ioctl-types.h", metadata !"/usr/include/x86_64-linux-gnu/bits", metadata !2} ; [ DW_TAG_file_type ]
!518 = metadata !{metadata !519, metadata !520, metadata !521, metadata !522}
!519 = metadata !{i32 589837, metadata !516, metadata !"ws_row", metadata !517, i32 29, i64 16, i64 16, i64 0, i32 0, metadata !218} ; [ DW_TAG_member ]
!520 = metadata !{i32 589837, metadata !516, metadata !"ws_col", metadata !517, i32 30, i64 16, i64 16, i64 16, i32 0, metadata !218} ; [ DW_TAG_member ]
!521 = metadata !{i32 589837, metadata !516, metadata !"ws_xpixel", metadata !517, i32 31, i64 16, i64 16, i64 32, i32 0, metadata !218} ; [ DW_TAG_member ]
!522 = metadata !{i32 589837, metadata !516, metadata !"ws_ypixel", metadata !517, i32 32, i64 16, i64 16, i64 48, i32 0, metadata !218} ; [ DW_TAG_member ]
!523 = metadata !{i32 590080, metadata !524, metadata !"res", metadata !1, i32 1016, metadata !525, i32 0} ; [ DW_TAG_auto_variable ]
!524 = metadata !{i32 589835, metadata !492, i32 1016, i32 0, metadata !1, i32 62} ; [ DW_TAG_lexical_block ]
!525 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !35} ; [ DW_TAG_pointer_type ]
!526 = metadata !{i32 590080, metadata !527, metadata !"r", metadata !1, i32 1041, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!527 = metadata !{i32 589835, metadata !488, i32 1041, i32 0, metadata !1, i32 63} ; [ DW_TAG_lexical_block ]
!528 = metadata !{i32 590081, metadata !207, metadata !"fd", metadata !1, i32 814, metadata !11, i32 0} ; [ DW_TAG_arg_variable ]
!529 = metadata !{i32 590081, metadata !207, metadata !"dirp", metadata !1, i32 814, metadata !210, i32 0} ; [ DW_TAG_arg_variable ]
!530 = metadata !{i32 590081, metadata !207, metadata !"count", metadata !1, i32 814, metadata !11, i32 0} ; [ DW_TAG_arg_variable ]
!531 = metadata !{i32 590080, metadata !532, metadata !"f", metadata !1, i32 815, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!532 = metadata !{i32 589835, metadata !207, i32 814, i32 0, metadata !1, i32 64} ; [ DW_TAG_lexical_block ]
!533 = metadata !{i32 590080, metadata !534, metadata !"i", metadata !1, i32 829, metadata !70, i32 0} ; [ DW_TAG_auto_variable ]
!534 = metadata !{i32 589835, metadata !532, i32 829, i32 0, metadata !1, i32 65} ; [ DW_TAG_lexical_block ]
!535 = metadata !{i32 590080, metadata !534, metadata !"pad", metadata !1, i32 829, metadata !70, i32 0} ; [ DW_TAG_auto_variable ]
!536 = metadata !{i32 590080, metadata !534, metadata !"bytes", metadata !1, i32 829, metadata !70, i32 0} ; [ DW_TAG_auto_variable ]
!537 = metadata !{i32 590080, metadata !538, metadata !"df", metadata !1, i32 839, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!538 = metadata !{i32 589835, metadata !534, i32 839, i32 0, metadata !1, i32 66} ; [ DW_TAG_lexical_block ]
!539 = metadata !{i32 590080, metadata !540, metadata !"os_pos", metadata !1, i32 862, metadata !70, i32 0} ; [ DW_TAG_auto_variable ]
!540 = metadata !{i32 589835, metadata !532, i32 862, i32 0, metadata !1, i32 67} ; [ DW_TAG_lexical_block ]
!541 = metadata !{i32 590080, metadata !540, metadata !"res", metadata !1, i32 863, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!542 = metadata !{i32 590080, metadata !540, metadata !"s", metadata !1, i32 864, metadata !70, i32 0} ; [ DW_TAG_auto_variable ]
!543 = metadata !{i32 590080, metadata !544, metadata !"pos", metadata !1, i32 880, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!544 = metadata !{i32 589835, metadata !540, i32 880, i32 0, metadata !1, i32 68} ; [ DW_TAG_lexical_block ]
!545 = metadata !{i32 590080, metadata !546, metadata !"dp", metadata !1, i32 886, metadata !210, i32 0} ; [ DW_TAG_auto_variable ]
!546 = metadata !{i32 589835, metadata !544, i32 886, i32 0, metadata !1, i32 69} ; [ DW_TAG_lexical_block ]
!547 = metadata !{i32 590081, metadata !225, metadata !"fd", metadata !1, i32 475, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!548 = metadata !{i32 590081, metadata !225, metadata !"offset", metadata !1, i32 475, metadata !70, i32 0} ; [ DW_TAG_arg_variable ]
!549 = metadata !{i32 590081, metadata !225, metadata !"whence", metadata !1, i32 475, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!550 = metadata !{i32 590080, metadata !551, metadata !"new_off", metadata !1, i32 476, metadata !70, i32 0} ; [ DW_TAG_auto_variable ]
!551 = metadata !{i32 589835, metadata !225, i32 475, i32 0, metadata !1, i32 70} ; [ DW_TAG_lexical_block ]
!552 = metadata !{i32 590080, metadata !551, metadata !"f", metadata !1, i32 477, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!553 = metadata !{i32 590081, metadata !228, metadata !"fd", metadata !1, i32 758, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!554 = metadata !{i32 590081, metadata !228, metadata !"buf", metadata !1, i32 758, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!555 = metadata !{i32 590080, metadata !556, metadata !"f", metadata !1, i32 759, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!556 = metadata !{i32 589835, metadata !228, i32 758, i32 0, metadata !1, i32 71} ; [ DW_TAG_lexical_block ]
!557 = metadata !{i32 590080, metadata !558, metadata !"r", metadata !1, i32 768, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!558 = metadata !{i32 589835, metadata !556, i32 768, i32 0, metadata !1, i32 72} ; [ DW_TAG_lexical_block ]
!559 = metadata !{i32 590081, metadata !229, metadata !"path", metadata !1, i32 587, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!560 = metadata !{i32 590081, metadata !229, metadata !"buf", metadata !1, i32 587, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!561 = metadata !{i32 590080, metadata !562, metadata !"dfile", metadata !1, i32 588, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!562 = metadata !{i32 589835, metadata !229, i32 587, i32 0, metadata !1, i32 73} ; [ DW_TAG_lexical_block ]
!563 = metadata !{i32 590080, metadata !564, metadata !"r", metadata !1, i32 596, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!564 = metadata !{i32 589835, metadata !562, i32 596, i32 0, metadata !1, i32 74} ; [ DW_TAG_lexical_block ]
!565 = metadata !{i32 590081, metadata !232, metadata !"fd", metadata !1, i32 551, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!566 = metadata !{i32 590081, metadata !232, metadata !"path", metadata !1, i32 551, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!567 = metadata !{i32 590081, metadata !232, metadata !"buf", metadata !1, i32 551, metadata !235, i32 0} ; [ DW_TAG_arg_variable ]
!568 = metadata !{i32 590081, metadata !232, metadata !"flags", metadata !1, i32 551, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!569 = metadata !{i32 590080, metadata !570, metadata !"dfile", metadata !1, i32 565, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!570 = metadata !{i32 589835, metadata !232, i32 551, i32 0, metadata !1, i32 75} ; [ DW_TAG_lexical_block ]
!571 = metadata !{i32 590080, metadata !570, metadata !"r", metadata !1, i32 572, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!572 = metadata !{i32 590080, metadata !573, metadata !"f", metadata !1, i32 553, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!573 = metadata !{i32 589835, metadata !570, i32 553, i32 0, metadata !1, i32 76} ; [ DW_TAG_lexical_block ]
!574 = metadata !{i32 590081, metadata !255, metadata !"path", metadata !1, i32 532, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!575 = metadata !{i32 590081, metadata !255, metadata !"buf", metadata !1, i32 532, metadata !16, i32 0} ; [ DW_TAG_arg_variable ]
!576 = metadata !{i32 590080, metadata !577, metadata !"dfile", metadata !1, i32 533, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!577 = metadata !{i32 589835, metadata !255, i32 532, i32 0, metadata !1, i32 77} ; [ DW_TAG_lexical_block ]
!578 = metadata !{i32 590080, metadata !579, metadata !"r", metadata !1, i32 541, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!579 = metadata !{i32 589835, metadata !577, i32 541, i32 0, metadata !1, i32 78} ; [ DW_TAG_lexical_block ]
!580 = metadata !{i32 590081, metadata !256, metadata !"fd", metadata !1, i32 403, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!581 = metadata !{i32 590081, metadata !256, metadata !"buf", metadata !1, i32 403, metadata !143, i32 0} ; [ DW_TAG_arg_variable ]
!582 = metadata !{i32 590081, metadata !256, metadata !"count", metadata !1, i32 403, metadata !97, i32 0} ; [ DW_TAG_arg_variable ]
!583 = metadata !{i32 590080, metadata !584, metadata !"f", metadata !1, i32 405, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!584 = metadata !{i32 589835, metadata !256, i32 403, i32 0, metadata !1, i32 79} ; [ DW_TAG_lexical_block ]
!585 = metadata !{i32 590080, metadata !586, metadata !"r", metadata !1, i32 423, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!586 = metadata !{i32 589835, metadata !584, i32 425, i32 0, metadata !1, i32 80} ; [ DW_TAG_lexical_block ]
!587 = metadata !{i32 590080, metadata !588, metadata !"actual_count", metadata !1, i32 448, metadata !97, i32 0} ; [ DW_TAG_auto_variable ]
!588 = metadata !{i32 589835, metadata !584, i32 448, i32 0, metadata !1, i32 81} ; [ DW_TAG_lexical_block ]
!589 = metadata !{i32 590081, metadata !259, metadata !"fd", metadata !1, i32 335, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!590 = metadata !{i32 590081, metadata !259, metadata !"buf", metadata !1, i32 335, metadata !143, i32 0} ; [ DW_TAG_arg_variable ]
!591 = metadata !{i32 590081, metadata !259, metadata !"count", metadata !1, i32 335, metadata !97, i32 0} ; [ DW_TAG_arg_variable ]
!592 = metadata !{i32 590080, metadata !593, metadata !"f", metadata !1, i32 337, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!593 = metadata !{i32 589835, metadata !259, i32 335, i32 0, metadata !1, i32 82} ; [ DW_TAG_lexical_block ]
!594 = metadata !{i32 590080, metadata !595, metadata !"r", metadata !1, i32 364, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!595 = metadata !{i32 589835, metadata !593, i32 365, i32 0, metadata !1, i32 83} ; [ DW_TAG_lexical_block ]
!596 = metadata !{i32 590081, metadata !260, metadata !"df", metadata !1, i32 645, metadata !5, i32 0} ; [ DW_TAG_arg_variable ]
!597 = metadata !{i32 590081, metadata !260, metadata !"mode", metadata !1, i32 645, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!598 = metadata !{i32 590081, metadata !263, metadata !"fd", metadata !1, i32 680, metadata !35, i32 0} ; [ DW_TAG_arg_variable ]
!599 = metadata !{i32 590081, metadata !263, metadata !"mode", metadata !1, i32 680, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!600 = metadata !{i32 590080, metadata !601, metadata !"f", metadata !1, i32 683, metadata !63, i32 0} ; [ DW_TAG_auto_variable ]
!601 = metadata !{i32 589835, metadata !263, i32 680, i32 0, metadata !1, i32 85} ; [ DW_TAG_lexical_block ]
!602 = metadata !{i32 590080, metadata !603, metadata !"r", metadata !1, i32 700, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!603 = metadata !{i32 589835, metadata !601, i32 700, i32 0, metadata !1, i32 86} ; [ DW_TAG_lexical_block ]
!604 = metadata !{i32 590081, metadata !266, metadata !"path", metadata !1, i32 658, metadata !58, i32 0} ; [ DW_TAG_arg_variable ]
!605 = metadata !{i32 590081, metadata !266, metadata !"mode", metadata !1, i32 658, metadata !76, i32 0} ; [ DW_TAG_arg_variable ]
!606 = metadata !{i32 590080, metadata !607, metadata !"dfile", metadata !1, i32 661, metadata !5, i32 0} ; [ DW_TAG_auto_variable ]
!607 = metadata !{i32 589835, metadata !266, i32 658, i32 0, metadata !1, i32 87} ; [ DW_TAG_lexical_block ]
!608 = metadata !{i32 590080, metadata !609, metadata !"r", metadata !1, i32 673, metadata !35, i32 0} ; [ DW_TAG_auto_variable ]
!609 = metadata !{i32 589835, metadata !607, i32 673, i32 0, metadata !1, i32 88} ; [ DW_TAG_lexical_block ]
!610 = metadata !{i32 73, i32 0, metadata !175, null}
!611 = metadata !{i32 39, i32 0, metadata !0, metadata !612}
!612 = metadata !{i32 74, i32 0, metadata !404, null}
!613 = metadata !{i32 40, i32 0, metadata !271, metadata !612}
!614 = metadata !{i32 43, i32 0, metadata !271, metadata !612}
!615 = metadata !{i32 46, i32 0, metadata !271, metadata !612}
!616 = metadata !{i32 47, i32 0, metadata !271, metadata !612}
!617 = metadata !{i32 48, i32 0, metadata !274, metadata !612}
!618 = metadata !{null}
!619 = metadata !{i32 49, i32 0, metadata !274, metadata !612}
!620 = metadata !{i32 76, i32 0, metadata !404, null}
!621 = metadata !{i32 1428, i32 0, metadata !150, metadata !622}
!622 = metadata !{i32 81, i32 0, metadata !406, null}
!623 = metadata !{i32 1415, i32 0, metadata !140, metadata !624}
!624 = metadata !{i32 1429, i32 0, metadata !358, metadata !622}
!625 = metadata !{i32 1417, i32 0, metadata !348, metadata !624}
!626 = metadata !{i32 1418, i32 0, metadata !348, metadata !624}
!627 = metadata !{i32 0}
!628 = metadata !{i32 1432, i32 0, metadata !358, metadata !622}
!629 = metadata !{i32 1433, i32 0, metadata !361, metadata !622}
!630 = metadata !{i32 1434, i32 0, metadata !361, metadata !622}
!631 = metadata !{i32 1436, i32 0, metadata !361, metadata !622}
!632 = metadata !{i32 1439, i32 0, metadata !361, metadata !622}
!633 = metadata !{i32 1442, i32 0, metadata !363, metadata !622}
!634 = metadata !{i32 1443, i32 0, metadata !363, metadata !622}
!635 = metadata !{i32 1444, i32 0, metadata !363, metadata !622}
!636 = metadata !{i32 1445, i32 0, metadata !363, metadata !622}
!637 = metadata !{i32 82, i32 0, metadata !406, null}
!638 = metadata !{i32 83, i32 0, metadata !406, null}
!639 = metadata !{i32 79, i32 0, metadata !404, null}
!640 = metadata !{i32 88, i32 0, metadata !73, null}
!641 = metadata !{i32 89, i32 0, metadata !281, null}
!642 = metadata !{i32 90, i32 0, metadata !281, null}
!643 = metadata !{i32 91, i32 0, metadata !281, null}
!644 = metadata !{i32 1457, i32 0, metadata !80, null}
!645 = metadata !{i32 1458, i32 0, metadata !646, null}
!646 = metadata !{i32 589835, metadata !80, i32 1457, i32 0, metadata !1, i32 6} ; [ DW_TAG_lexical_block ]
!647 = metadata !{i32 1459, i32 0, metadata !646, null}
!648 = metadata !{i32 1460, i32 0, metadata !646, null}
!649 = metadata !{i32 1463, i32 0, metadata !646, null}
!650 = metadata !{i32 1467, i32 0, metadata !646, null}
!651 = metadata !{i32 1468, i32 0, metadata !646, null}
!652 = metadata !{i32 1469, i32 0, metadata !646, null}
!653 = metadata !{i32 1239, i32 0, metadata !83, null}
!654 = metadata !{i32 39, i32 0, metadata !0, metadata !655}
!655 = metadata !{i32 1242, i32 0, metadata !293, null}
!656 = metadata !{i32 40, i32 0, metadata !271, metadata !655}
!657 = metadata !{i32 43, i32 0, metadata !271, metadata !655}
!658 = metadata !{i32 46, i32 0, metadata !271, metadata !655}
!659 = metadata !{i32 47, i32 0, metadata !271, metadata !655}
!660 = metadata !{i32 48, i32 0, metadata !274, metadata !655}
!661 = metadata !{i32 49, i32 0, metadata !274, metadata !655}
!662 = metadata !{i32 1243, i32 0, metadata !293, null}
!663 = metadata !{i32 1245, i32 0, metadata !293, null}
!664 = metadata !{i32 1246, i32 0, metadata !293, null}
!665 = metadata !{i32 1247, i32 0, metadata !293, null}
!666 = metadata !{i32 1248, i32 0, metadata !293, null}
!667 = metadata !{i32 1249, i32 0, metadata !293, null}
!668 = metadata !{i32 1250, i32 0, metadata !293, null}
!669 = metadata !{i32 1252, i32 0, metadata !293, null}
!670 = metadata !{i32 1253, i32 0, metadata !293, null}
!671 = metadata !{i32 1257, i32 0, metadata !293, null}
!672 = metadata !{i32 1258, i32 0, metadata !293, null}
!673 = metadata !{i32 1259, i32 0, metadata !293, null}
!674 = metadata !{i32 1218, i32 0, metadata !86, null}
!675 = metadata !{i32 39, i32 0, metadata !0, metadata !676}
!676 = metadata !{i32 1219, i32 0, metadata !296, null}
!677 = metadata !{i32 40, i32 0, metadata !271, metadata !676}
!678 = metadata !{i32 43, i32 0, metadata !271, metadata !676}
!679 = metadata !{i32 46, i32 0, metadata !271, metadata !676}
!680 = metadata !{i32 47, i32 0, metadata !271, metadata !676}
!681 = metadata !{i32 48, i32 0, metadata !274, metadata !676}
!682 = metadata !{i32 49, i32 0, metadata !274, metadata !676}
!683 = metadata !{i32 1220, i32 0, metadata !296, null}
!684 = metadata !{i32 1222, i32 0, metadata !296, null}
!685 = metadata !{i32 1223, i32 0, metadata !296, null}
!686 = metadata !{i32 1224, i32 0, metadata !296, null}
!687 = metadata !{i32 1225, i32 0, metadata !296, null}
!688 = metadata !{i32 1226, i32 0, metadata !296, null}
!689 = metadata !{i32 1227, i32 0, metadata !296, null}
!690 = metadata !{i32 1229, i32 0, metadata !296, null}
!691 = metadata !{i32 1230, i32 0, metadata !296, null}
!692 = metadata !{i32 1234, i32 0, metadata !296, null}
!693 = metadata !{i32 1235, i32 0, metadata !296, null}
!694 = metadata !{i32 1236, i32 0, metadata !296, null}
!695 = metadata !{i32 1200, i32 0, metadata !87, null}
!696 = metadata !{i32 39, i32 0, metadata !0, metadata !697}
!697 = metadata !{i32 1201, i32 0, metadata !299, null}
!698 = metadata !{i32 40, i32 0, metadata !271, metadata !697}
!699 = metadata !{i32 43, i32 0, metadata !271, metadata !697}
!700 = metadata !{i32 46, i32 0, metadata !271, metadata !697}
!701 = metadata !{i32 47, i32 0, metadata !271, metadata !697}
!702 = metadata !{i32 48, i32 0, metadata !274, metadata !697}
!703 = metadata !{i32 49, i32 0, metadata !274, metadata !697}
!704 = metadata !{i32 1202, i32 0, metadata !299, null}
!705 = metadata !{i32 1204, i32 0, metadata !299, null}
!706 = metadata !{i32 1205, i32 0, metadata !299, null}
!707 = metadata !{i32 1206, i32 0, metadata !299, null}
!708 = metadata !{i32 1208, i32 0, metadata !299, null}
!709 = metadata !{i32 1209, i32 0, metadata !299, null}
!710 = metadata !{i32 1213, i32 0, metadata !299, null}
!711 = metadata !{i32 1214, i32 0, metadata !299, null}
!712 = metadata !{i32 1215, i32 0, metadata !299, null}
!713 = metadata !{i32 1262, i32 0, metadata !93, null}
!714 = metadata !{i32 39, i32 0, metadata !0, metadata !715}
!715 = metadata !{i32 1263, i32 0, metadata !307, null}
!716 = metadata !{i32 40, i32 0, metadata !271, metadata !715}
!717 = metadata !{i32 43, i32 0, metadata !271, metadata !715}
!718 = metadata !{i32 46, i32 0, metadata !271, metadata !715}
!719 = metadata !{i32 47, i32 0, metadata !271, metadata !715}
!720 = metadata !{i32 48, i32 0, metadata !274, metadata !715}
!721 = metadata !{i32 49, i32 0, metadata !274, metadata !715}
!722 = metadata !{i32 1264, i32 0, metadata !307, null}
!723 = metadata !{i32 1267, i32 0, metadata !307, null}
!724 = metadata !{i32 1268, i32 0, metadata !307, null}
!725 = metadata !{i32 1269, i32 0, metadata !307, null}
!726 = metadata !{i32 1270, i32 0, metadata !307, null}
!727 = metadata !{i32 1271, i32 0, metadata !307, null}
!728 = metadata !{i32 1272, i32 0, metadata !307, null}
!729 = metadata !{i32 1273, i32 0, metadata !307, null}
!730 = metadata !{i32 1275, i32 0, metadata !307, null}
!731 = metadata !{i32 1276, i32 0, metadata !307, null}
!732 = metadata !{i32 1279, i32 0, metadata !309, null}
!733 = metadata !{i32 1280, i32 0, metadata !309, null}
!734 = metadata !{i32 1281, i32 0, metadata !309, null}
!735 = metadata !{i32 1282, i32 0, metadata !309, null}
!736 = metadata !{i32 1140, i32 0, metadata !98, null}
!737 = metadata !{i32 63, i32 0, metadata !60, metadata !738}
!738 = metadata !{i32 1141, i32 0, metadata !312, null}
!739 = metadata !{i32 64, i32 0, metadata !278, metadata !738}
!740 = metadata !{i32 65, i32 0, metadata !277, metadata !738}
!741 = metadata !{i32 66, i32 0, metadata !277, metadata !738}
!742 = metadata !{i32 1143, i32 0, metadata !312, null}
!743 = metadata !{i32 1144, i32 0, metadata !312, null}
!744 = metadata !{i32 1145, i32 0, metadata !312, null}
!745 = metadata !{i32 1146, i32 0, metadata !312, null}
!746 = metadata !{i32 1149, i32 0, metadata !314, null}
!747 = metadata !{i32 1150, i32 0, metadata !314, null}
!748 = metadata !{i32 1151, i32 0, metadata !314, null}
!749 = metadata !{i32 1120, i32 0, metadata !101, null}
!750 = metadata !{i32 63, i32 0, metadata !60, metadata !751}
!751 = metadata !{i32 1121, i32 0, metadata !318, null}
!752 = metadata !{i32 64, i32 0, metadata !278, metadata !751}
!753 = metadata !{i32 65, i32 0, metadata !277, metadata !751}
!754 = metadata !{i32 66, i32 0, metadata !277, metadata !751}
!755 = metadata !{i32 1123, i32 0, metadata !318, null}
!756 = metadata !{i32 1124, i32 0, metadata !318, null}
!757 = metadata !{i32 1125, i32 0, metadata !318, null}
!758 = metadata !{i32 1128, i32 0, metadata !318, null}
!759 = metadata !{i32 1129, i32 0, metadata !318, null}
!760 = metadata !{i32 1130, i32 0, metadata !318, null}
!761 = metadata !{i32 1131, i32 0, metadata !318, null}
!762 = metadata !{i32 1133, i32 0, metadata !320, null}
!763 = metadata !{i32 1134, i32 0, metadata !320, null}
!764 = metadata !{i32 1135, i32 0, metadata !320, null}
!765 = metadata !{i32 781, i32 0, metadata !133, null}
!766 = metadata !{i32 63, i32 0, metadata !60, metadata !767}
!767 = metadata !{i32 783, i32 0, metadata !324, null}
!768 = metadata !{i32 64, i32 0, metadata !278, metadata !767}
!769 = metadata !{i32 65, i32 0, metadata !277, metadata !767}
!770 = metadata !{i32 66, i32 0, metadata !277, metadata !767}
!771 = metadata !{i32 785, i32 0, metadata !324, null}
!772 = metadata !{i32 787, i32 0, metadata !324, null}
!773 = metadata !{i32 788, i32 0, metadata !324, null}
!774 = metadata !{i32 789, i32 0, metadata !324, null}
!775 = metadata !{i32 792, i32 0, metadata !324, null}
!776 = metadata !{i32 793, i32 0, metadata !324, null}
!777 = metadata !{i32 794, i32 0, metadata !324, null}
!778 = metadata !{i32 795, i32 0, metadata !324, null}
!779 = metadata !{i32 798, i32 0, metadata !324, null}
!780 = metadata !{i32 799, i32 0, metadata !324, null}
!781 = metadata !{i32 800, i32 0, metadata !324, null}
!782 = metadata !{i32 801, i32 0, metadata !324, null}
!783 = metadata !{i32 804, i32 0, metadata !326, null}
!784 = metadata !{i32 808, i32 0, metadata !326, null}
!785 = metadata !{i32 809, i32 0, metadata !326, null}
!786 = metadata !{i32 726, i32 0, metadata !136, null}
!787 = metadata !{i32 63, i32 0, metadata !60, metadata !788}
!788 = metadata !{i32 727, i32 0, metadata !338, null}
!789 = metadata !{i32 64, i32 0, metadata !278, metadata !788}
!790 = metadata !{i32 65, i32 0, metadata !277, metadata !788}
!791 = metadata !{i32 66, i32 0, metadata !277, metadata !788}
!792 = metadata !{i32 729, i32 0, metadata !338, null}
!793 = metadata !{i32 730, i32 0, metadata !338, null}
!794 = metadata !{i32 731, i32 0, metadata !338, null}
!795 = metadata !{i32 734, i32 0, metadata !338, null}
!796 = metadata !{%struct.exe_disk_file_t* null}
!797 = metadata !{i32 707, i32 0, metadata !88, metadata !798}
!798 = metadata !{i32 735, i32 0, metadata !338, null}
!799 = metadata !{i32 708, i32 0, metadata !800, metadata !798}
!800 = metadata !{i32 589835, metadata !88, i32 707, i32 0, metadata !1, i32 10} ; [ DW_TAG_lexical_block ]
!801 = metadata !{i32 709, i32 0, metadata !800, metadata !798}
!802 = metadata !{i32 737, i32 0, metadata !340, null}
!803 = metadata !{i32 738, i32 0, metadata !340, null}
!804 = metadata !{i32 739, i32 0, metadata !340, null}
!805 = metadata !{i32 624, i32 0, metadata !139, null}
!806 = metadata !{i32 63, i32 0, metadata !60, metadata !807}
!807 = metadata !{i32 625, i32 0, metadata !343, null}
!808 = metadata !{i32 64, i32 0, metadata !278, metadata !807}
!809 = metadata !{i32 65, i32 0, metadata !277, metadata !807}
!810 = metadata !{i32 66, i32 0, metadata !277, metadata !807}
!811 = metadata !{i32 627, i32 0, metadata !343, null}
!812 = metadata !{i32 628, i32 0, metadata !343, null}
!813 = metadata !{i32 629, i32 0, metadata !343, null}
!814 = metadata !{i32 632, i32 0, metadata !343, null}
!815 = metadata !{i32 633, i32 0, metadata !343, null}
!816 = metadata !{i32 634, i32 0, metadata !343, null}
!817 = metadata !{i32 635, i32 0, metadata !343, null}
!818 = metadata !{i32 637, i32 0, metadata !345, null}
!819 = metadata !{i32 638, i32 0, metadata !345, null}
!820 = metadata !{i32 639, i32 0, metadata !345, null}
!821 = metadata !{i32 1380, i32 0, metadata !147, null}
!822 = metadata !{i32 1384, i32 0, metadata !355, null}
!823 = metadata !{i32 1386, i32 0, metadata !355, null}
!824 = metadata !{i32 1387, i32 0, metadata !355, null}
!825 = metadata !{i32 1388, i32 0, metadata !355, null}
!826 = metadata !{i32 1389, i32 0, metadata !355, null}
!827 = metadata !{i32 1392, i32 0, metadata !355, null}
!828 = metadata !{i32 1393, i32 0, metadata !355, null}
!829 = metadata !{i64 1024}
!830 = metadata !{i32 1394, i32 0, metadata !355, null}
!831 = metadata !{i32 1395, i32 0, metadata !355, null}
!832 = metadata !{i32 1415, i32 0, metadata !140, metadata !833}
!833 = metadata !{i32 1398, i32 0, metadata !355, null}
!834 = metadata !{i32 1417, i32 0, metadata !348, metadata !833}
!835 = metadata !{i32 1418, i32 0, metadata !348, metadata !833}
!836 = metadata !{i32 1422, i32 0, metadata !144, metadata !837}
!837 = metadata !{i32 1399, i32 0, metadata !355, null}
!838 = metadata !{i32 1423, i32 0, metadata !351, metadata !837}
!839 = metadata !{i32 1424, i32 0, metadata !351, metadata !837}
!840 = metadata !{i32 1403, i32 0, metadata !355, null}
!841 = metadata !{i32 1404, i32 0, metadata !355, null}
!842 = metadata !{i32 1405, i32 0, metadata !355, null}
!843 = metadata !{i32 1406, i32 0, metadata !355, null}
!844 = metadata !{i32 1407, i32 0, metadata !355, null}
!845 = metadata !{i32 1103, i32 0, metadata !153, null}
!846 = metadata !{i32 39, i32 0, metadata !0, metadata !847}
!847 = metadata !{i32 1104, i32 0, metadata !367, null}
!848 = metadata !{i32 40, i32 0, metadata !271, metadata !847}
!849 = metadata !{i32 43, i32 0, metadata !271, metadata !847}
!850 = metadata !{i32 46, i32 0, metadata !271, metadata !847}
!851 = metadata !{i32 47, i32 0, metadata !271, metadata !847}
!852 = metadata !{i32 48, i32 0, metadata !274, metadata !847}
!853 = metadata !{i32 49, i32 0, metadata !274, metadata !847}
!854 = metadata !{i32 1105, i32 0, metadata !367, null}
!855 = metadata !{i32 1107, i32 0, metadata !367, null}
!856 = metadata !{i32 1108, i32 0, metadata !367, null}
!857 = metadata !{i32 1109, i32 0, metadata !367, null}
!858 = metadata !{i32 1428, i32 0, metadata !150, metadata !859}
!859 = metadata !{i32 1113, i32 0, metadata !369, null}
!860 = metadata !{i32 1415, i32 0, metadata !140, metadata !861}
!861 = metadata !{i32 1429, i32 0, metadata !358, metadata !859}
!862 = metadata !{i32 1417, i32 0, metadata !348, metadata !861}
!863 = metadata !{i32 1418, i32 0, metadata !348, metadata !861}
!864 = metadata !{i32 1432, i32 0, metadata !358, metadata !859}
!865 = metadata !{i32 1433, i32 0, metadata !361, metadata !859}
!866 = metadata !{i32 1434, i32 0, metadata !361, metadata !859}
!867 = metadata !{i32 1436, i32 0, metadata !361, metadata !859}
!868 = metadata !{i32 1439, i32 0, metadata !361, metadata !859}
!869 = metadata !{i32 1442, i32 0, metadata !363, metadata !859}
!870 = metadata !{i32 1443, i32 0, metadata !363, metadata !859}
!871 = metadata !{i32 1444, i32 0, metadata !363, metadata !859}
!872 = metadata !{i32 1445, i32 0, metadata !363, metadata !859}
!873 = metadata !{i32 1114, i32 0, metadata !369, null}
!874 = metadata !{i32 1115, i32 0, metadata !369, null}
!875 = metadata !{i32 744, i32 0, metadata !156, null}
!876 = metadata !{i32 39, i32 0, metadata !0, metadata !877}
!877 = metadata !{i32 746, i32 0, metadata !374, null}
!878 = metadata !{i32 40, i32 0, metadata !271, metadata !877}
!879 = metadata !{i32 43, i32 0, metadata !271, metadata !877}
!880 = metadata !{i32 46, i32 0, metadata !271, metadata !877}
!881 = metadata !{i32 47, i32 0, metadata !271, metadata !877}
!882 = metadata !{i32 48, i32 0, metadata !274, metadata !877}
!883 = metadata !{i32 49, i32 0, metadata !274, metadata !877}
!884 = metadata !{i32 748, i32 0, metadata !374, null}
!885 = metadata !{i32 707, i32 0, metadata !88, metadata !886}
!886 = metadata !{i32 749, i32 0, metadata !374, null}
!887 = metadata !{i32 708, i32 0, metadata !800, metadata !886}
!888 = metadata !{i32 709, i32 0, metadata !800, metadata !886}
!889 = metadata !{i32 1428, i32 0, metadata !150, metadata !890}
!890 = metadata !{i32 751, i32 0, metadata !376, null}
!891 = metadata !{i32 1415, i32 0, metadata !140, metadata !892}
!892 = metadata !{i32 1429, i32 0, metadata !358, metadata !890}
!893 = metadata !{i32 1417, i32 0, metadata !348, metadata !892}
!894 = metadata !{i32 1418, i32 0, metadata !348, metadata !892}
!895 = metadata !{i32 1432, i32 0, metadata !358, metadata !890}
!896 = metadata !{i32 1433, i32 0, metadata !361, metadata !890}
!897 = metadata !{i32 1434, i32 0, metadata !361, metadata !890}
!898 = metadata !{i32 1436, i32 0, metadata !361, metadata !890}
!899 = metadata !{i32 1439, i32 0, metadata !361, metadata !890}
!900 = metadata !{i32 1442, i32 0, metadata !363, metadata !890}
!901 = metadata !{i32 1443, i32 0, metadata !363, metadata !890}
!902 = metadata !{i32 1444, i32 0, metadata !363, metadata !890}
!903 = metadata !{i32 1445, i32 0, metadata !363, metadata !890}
!904 = metadata !{i32 752, i32 0, metadata !376, null}
!905 = metadata !{i32 753, i32 0, metadata !376, null}
!906 = metadata !{i32 713, i32 0, metadata !159, null}
!907 = metadata !{i32 39, i32 0, metadata !0, metadata !908}
!908 = metadata !{i32 714, i32 0, metadata !381, null}
!909 = metadata !{i32 40, i32 0, metadata !271, metadata !908}
!910 = metadata !{i32 43, i32 0, metadata !271, metadata !908}
!911 = metadata !{i32 46, i32 0, metadata !271, metadata !908}
!912 = metadata !{i32 47, i32 0, metadata !271, metadata !908}
!913 = metadata !{i32 48, i32 0, metadata !274, metadata !908}
!914 = metadata !{i32 49, i32 0, metadata !274, metadata !908}
!915 = metadata !{i32 716, i32 0, metadata !381, null}
!916 = metadata !{i32 707, i32 0, metadata !88, metadata !917}
!917 = metadata !{i32 717, i32 0, metadata !381, null}
!918 = metadata !{i32 708, i32 0, metadata !800, metadata !917}
!919 = metadata !{i32 709, i32 0, metadata !800, metadata !917}
!920 = metadata !{i32 1428, i32 0, metadata !150, metadata !921}
!921 = metadata !{i32 719, i32 0, metadata !383, null}
!922 = metadata !{i32 1415, i32 0, metadata !140, metadata !923}
!923 = metadata !{i32 1429, i32 0, metadata !358, metadata !921}
!924 = metadata !{i32 1417, i32 0, metadata !348, metadata !923}
!925 = metadata !{i32 1418, i32 0, metadata !348, metadata !923}
!926 = metadata !{i32 1432, i32 0, metadata !358, metadata !921}
!927 = metadata !{i32 1433, i32 0, metadata !361, metadata !921}
!928 = metadata !{i32 1434, i32 0, metadata !361, metadata !921}
!929 = metadata !{i32 1436, i32 0, metadata !361, metadata !921}
!930 = metadata !{i32 1439, i32 0, metadata !361, metadata !921}
!931 = metadata !{i32 1442, i32 0, metadata !363, metadata !921}
!932 = metadata !{i32 1443, i32 0, metadata !363, metadata !921}
!933 = metadata !{i32 1444, i32 0, metadata !363, metadata !921}
!934 = metadata !{i32 1445, i32 0, metadata !363, metadata !921}
!935 = metadata !{i32 720, i32 0, metadata !383, null}
!936 = metadata !{i32 721, i32 0, metadata !383, null}
!937 = metadata !{i32 606, i32 0, metadata !160, null}
!938 = metadata !{i32 39, i32 0, metadata !0, metadata !939}
!939 = metadata !{i32 607, i32 0, metadata !386, null}
!940 = metadata !{i32 40, i32 0, metadata !271, metadata !939}
!941 = metadata !{i32 43, i32 0, metadata !271, metadata !939}
!942 = metadata !{i32 46, i32 0, metadata !271, metadata !939}
!943 = metadata !{i32 47, i32 0, metadata !271, metadata !939}
!944 = metadata !{i32 48, i32 0, metadata !274, metadata !939}
!945 = metadata !{i32 49, i32 0, metadata !274, metadata !939}
!946 = metadata !{i32 609, i32 0, metadata !386, null}
!947 = metadata !{i32 611, i32 0, metadata !386, null}
!948 = metadata !{i32 612, i32 0, metadata !386, null}
!949 = metadata !{i32 613, i32 0, metadata !386, null}
!950 = metadata !{i32 1428, i32 0, metadata !150, metadata !951}
!951 = metadata !{i32 617, i32 0, metadata !388, null}
!952 = metadata !{i32 1415, i32 0, metadata !140, metadata !953}
!953 = metadata !{i32 1429, i32 0, metadata !358, metadata !951}
!954 = metadata !{i32 1417, i32 0, metadata !348, metadata !953}
!955 = metadata !{i32 1418, i32 0, metadata !348, metadata !953}
!956 = metadata !{i32 1432, i32 0, metadata !358, metadata !951}
!957 = metadata !{i32 1433, i32 0, metadata !361, metadata !951}
!958 = metadata !{i32 1434, i32 0, metadata !361, metadata !951}
!959 = metadata !{i32 1436, i32 0, metadata !361, metadata !951}
!960 = metadata !{i32 1439, i32 0, metadata !361, metadata !951}
!961 = metadata !{i32 1442, i32 0, metadata !363, metadata !951}
!962 = metadata !{i32 1443, i32 0, metadata !363, metadata !951}
!963 = metadata !{i32 1444, i32 0, metadata !363, metadata !951}
!964 = metadata !{i32 1445, i32 0, metadata !363, metadata !951}
!965 = metadata !{i32 618, i32 0, metadata !388, null}
!966 = metadata !{i32 619, i32 0, metadata !388, null}
!967 = metadata !{i32 256, i32 0, metadata !161, null}
!968 = metadata !{i32 39, i32 0, metadata !0, metadata !969}
!969 = metadata !{i32 257, i32 0, metadata !392, null}
!970 = metadata !{i32 40, i32 0, metadata !271, metadata !969}
!971 = metadata !{i32 43, i32 0, metadata !271, metadata !969}
!972 = metadata !{i32 46, i32 0, metadata !271, metadata !969}
!973 = metadata !{i32 47, i32 0, metadata !271, metadata !969}
!974 = metadata !{i32 48, i32 0, metadata !274, metadata !969}
!975 = metadata !{i32 49, i32 0, metadata !274, metadata !969}
!976 = metadata !{i32 259, i32 0, metadata !392, null}
!977 = metadata !{i32 261, i32 0, metadata !392, null}
!978 = metadata !{i32 262, i32 0, metadata !392, null}
!979 = metadata !{i32 264, i32 0, metadata !392, null}
!980 = metadata !{i32 265, i32 0, metadata !392, null}
!981 = metadata !{i32 267, i32 0, metadata !392, null}
!982 = metadata !{i32 1428, i32 0, metadata !150, metadata !983}
!983 = metadata !{i32 269, i32 0, metadata !392, null}
!984 = metadata !{i32 1415, i32 0, metadata !140, metadata !985}
!985 = metadata !{i32 1429, i32 0, metadata !358, metadata !983}
!986 = metadata !{i32 1417, i32 0, metadata !348, metadata !985}
!987 = metadata !{i32 1418, i32 0, metadata !348, metadata !985}
!988 = metadata !{i32 1432, i32 0, metadata !358, metadata !983}
!989 = metadata !{i32 1433, i32 0, metadata !361, metadata !983}
!990 = metadata !{i32 1434, i32 0, metadata !361, metadata !983}
!991 = metadata !{i32 1436, i32 0, metadata !361, metadata !983}
!992 = metadata !{i32 1439, i32 0, metadata !361, metadata !983}
!993 = metadata !{i32 1442, i32 0, metadata !363, metadata !983}
!994 = metadata !{i32 1443, i32 0, metadata !363, metadata !983}
!995 = metadata !{i32 1444, i32 0, metadata !363, metadata !983}
!996 = metadata !{i32 1445, i32 0, metadata !363, metadata !983}
!997 = metadata !{i32 270, i32 0, metadata !392, null}
!998 = metadata !{i32 271, i32 0, metadata !392, null}
!999 = metadata !{i32 277, i32 0, metadata !172, null}
!1000 = metadata !{i32 278, i32 0, metadata !398, null}
!1001 = metadata !{i32 63, i32 0, metadata !60, metadata !1002}
!1002 = metadata !{i32 279, i32 0, metadata !400, null}
!1003 = metadata !{i32 64, i32 0, metadata !278, metadata !1002}
!1004 = metadata !{i32 65, i32 0, metadata !277, metadata !1002}
!1005 = metadata !{i32 66, i32 0, metadata !277, metadata !1002}
!1006 = metadata !{i32 281, i32 0, metadata !400, null}
!1007 = metadata !{i32 282, i32 0, metadata !400, null}
!1008 = metadata !{i32 283, i32 0, metadata !400, null}
!1009 = metadata !{i32 284, i32 0, metadata !400, null}
!1010 = metadata !{i32 285, i32 0, metadata !400, null}
!1011 = metadata !{i32 286, i32 0, metadata !400, null}
!1012 = metadata !{i32 287, i32 0, metadata !400, null}
!1013 = metadata !{i32 289, i32 0, metadata !400, null}
!1014 = metadata !{i32 39, i32 0, metadata !0, metadata !1015}
!1015 = metadata !{i32 291, i32 0, metadata !398, null}
!1016 = metadata !{i32 40, i32 0, metadata !271, metadata !1015}
!1017 = metadata !{i32 43, i32 0, metadata !271, metadata !1015}
!1018 = metadata !{i32 46, i32 0, metadata !271, metadata !1015}
!1019 = metadata !{i32 47, i32 0, metadata !271, metadata !1015}
!1020 = metadata !{i32 48, i32 0, metadata !274, metadata !1015}
!1021 = metadata !{i32 49, i32 0, metadata !274, metadata !1015}
!1022 = metadata !{i32 292, i32 0, metadata !398, null}
!1023 = metadata !{i32 297, i32 0, metadata !398, null}
!1024 = metadata !{i32 1428, i32 0, metadata !150, metadata !1023}
!1025 = metadata !{i32 1415, i32 0, metadata !140, metadata !1026}
!1026 = metadata !{i32 1429, i32 0, metadata !358, metadata !1023}
!1027 = metadata !{i32 1417, i32 0, metadata !348, metadata !1026}
!1028 = metadata !{i32 1418, i32 0, metadata !348, metadata !1026}
!1029 = metadata !{i32 1432, i32 0, metadata !358, metadata !1023}
!1030 = metadata !{i32 1433, i32 0, metadata !361, metadata !1023}
!1031 = metadata !{i32 1434, i32 0, metadata !361, metadata !1023}
!1032 = metadata !{i32 1436, i32 0, metadata !361, metadata !1023}
!1033 = metadata !{i32 1439, i32 0, metadata !361, metadata !1023}
!1034 = metadata !{i32 1442, i32 0, metadata !363, metadata !1023}
!1035 = metadata !{i32 1443, i32 0, metadata !363, metadata !1023}
!1036 = metadata !{i32 1444, i32 0, metadata !363, metadata !1023}
!1037 = metadata !{i32 1445, i32 0, metadata !363, metadata !1023}
!1038 = metadata !{i32 298, i32 0, metadata !398, null}
!1039 = metadata !{i32 299, i32 0, metadata !398, null}
!1040 = metadata !{i32 1294, i32 0, metadata !178, null}
!1041 = metadata !{i32 1295, i32 0, metadata !178, null}
!1042 = metadata !{i32 1296, i32 0, metadata !413, null}
!1043 = metadata !{i32 1297, i32 0, metadata !413, null}
!1044 = metadata !{i32 1299, i32 0, metadata !413, null}
!1045 = metadata !{i32 1303, i32 0, metadata !413, null}
!1046 = metadata !{i32 1300, i32 0, metadata !413, null}
!1047 = metadata !{i32 1301, i32 0, metadata !413, null}
!1048 = metadata !{i32 1306, i32 0, metadata !413, null}
!1049 = metadata !{i32 1310, i32 0, metadata !413, null}
!1050 = metadata !{i32 1307, i32 0, metadata !413, null}
!1051 = metadata !{i32 1308, i32 0, metadata !413, null}
!1052 = metadata !{i32 1313, i32 0, metadata !413, null}
!1053 = metadata !{i32 1317, i32 0, metadata !413, null}
!1054 = metadata !{i32 1314, i32 0, metadata !413, null}
!1055 = metadata !{i32 1315, i32 0, metadata !413, null}
!1056 = metadata !{i32 1320, i32 0, metadata !413, null}
!1057 = metadata !{i32 1321, i32 0, metadata !413, null}
!1058 = metadata !{i32 1322, i32 0, metadata !413, null}
!1059 = metadata !{i32 1325, i32 0, metadata !413, null}
!1060 = metadata !{i32 1326, i32 0, metadata !413, null}
!1061 = metadata !{i32 64, i32 0, metadata !278, metadata !1062}
!1062 = metadata !{i32 1327, i32 0, metadata !423, null}
!1063 = metadata !{i32 66, i32 0, metadata !277, metadata !1062}
!1064 = metadata !{i32 1328, i32 0, metadata !423, null}
!1065 = metadata !{i32 undef}
!1066 = metadata !{i32 63, i32 0, metadata !60, metadata !1062}
!1067 = metadata !{i32 1329, i32 0, metadata !423, null}
!1068 = metadata !{i32 1330, i32 0, metadata !423, null}
!1069 = metadata !{i32 1331, i32 0, metadata !423, null}
!1070 = metadata !{i32 1333, i32 0, metadata !423, null}
!1071 = metadata !{i32 1334, i32 0, metadata !423, null}
!1072 = metadata !{i32 1335, i32 0, metadata !423, null}
!1073 = metadata !{i32 1336, i32 0, metadata !423, null}
!1074 = metadata !{i32 1338, i32 0, metadata !423, null}
!1075 = metadata !{i32 1339, i32 0, metadata !423, null}
!1076 = metadata !{i32 1340, i32 0, metadata !423, null}
!1077 = metadata !{i32 1341, i32 0, metadata !423, null}
!1078 = metadata !{i32 1346, i32 0, metadata !413, null}
!1079 = metadata !{i32 1349, i32 0, metadata !425, null}
!1080 = metadata !{i32 1351, i32 0, metadata !425, null}
!1081 = metadata !{i32 1353, i32 0, metadata !425, null}
!1082 = metadata !{i32 1356, i32 0, metadata !425, null}
!1083 = metadata !{i32 1357, i32 0, metadata !425, null}
!1084 = metadata !{i32 1358, i32 0, metadata !425, null}
!1085 = metadata !{i32 1361, i32 0, metadata !425, null}
!1086 = metadata !{i32 1364, i32 0, metadata !425, null}
!1087 = metadata !{i32 64, i32 0, metadata !278, metadata !1088}
!1088 = metadata !{i32 1365, i32 0, metadata !428, null}
!1089 = metadata !{i32 66, i32 0, metadata !277, metadata !1088}
!1090 = metadata !{i32 1366, i32 0, metadata !428, null}
!1091 = metadata !{i32 1367, i32 0, metadata !428, null}
!1092 = metadata !{i32 1368, i32 0, metadata !428, null}
!1093 = metadata !{i32 1369, i32 0, metadata !428, null}
!1094 = metadata !{i32 303, i32 0, metadata !192, null}
!1095 = metadata !{i32 306, i32 0, metadata !431, null}
!1096 = metadata !{i32 308, i32 0, metadata !431, null}
!1097 = metadata !{i32 63, i32 0, metadata !60, metadata !1098}
!1098 = metadata !{i32 310, i32 0, metadata !431, null}
!1099 = metadata !{i32 64, i32 0, metadata !278, metadata !1098}
!1100 = metadata !{i32 65, i32 0, metadata !277, metadata !1098}
!1101 = metadata !{i32 66, i32 0, metadata !277, metadata !1098}
!1102 = metadata !{i32 311, i32 0, metadata !431, null}
!1103 = metadata !{i32 312, i32 0, metadata !431, null}
!1104 = metadata !{i32 313, i32 0, metadata !431, null}
!1105 = metadata !{i32 316, i32 0, metadata !431, null}
!1106 = metadata !{i32 317, i32 0, metadata !431, null}
!1107 = metadata !{i32 318, i32 0, metadata !431, null}
!1108 = metadata !{i32 319, i32 0, metadata !431, null}
!1109 = metadata !{i32 330, i32 0, metadata !431, null}
!1110 = metadata !{i32 332, i32 0, metadata !431, null}
!1111 = metadata !{i32 1156, i32 0, metadata !193, null}
!1112 = metadata !{i32 63, i32 0, metadata !60, metadata !1113}
!1113 = metadata !{i32 1157, i32 0, metadata !436, null}
!1114 = metadata !{i32 64, i32 0, metadata !278, metadata !1113}
!1115 = metadata !{i32 65, i32 0, metadata !277, metadata !1113}
!1116 = metadata !{i32 66, i32 0, metadata !277, metadata !1113}
!1117 = metadata !{i32 1159, i32 0, metadata !436, null}
!1118 = metadata !{i32 1160, i32 0, metadata !436, null}
!1119 = metadata !{i32 1161, i32 0, metadata !436, null}
!1120 = metadata !{i32 1163, i32 0, metadata !438, null}
!1121 = metadata !{i32 1164, i32 0, metadata !438, null}
!1122 = metadata !{i32 303, i32 0, metadata !192, metadata !1121}
!1123 = metadata !{i32 306, i32 0, metadata !431, metadata !1121}
!1124 = metadata !{i32 308, i32 0, metadata !431, metadata !1121}
!1125 = metadata !{i32 63, i32 0, metadata !60, metadata !1126}
!1126 = metadata !{i32 310, i32 0, metadata !431, metadata !1121}
!1127 = metadata !{i32 64, i32 0, metadata !278, metadata !1126}
!1128 = metadata !{i32 65, i32 0, metadata !277, metadata !1126}
!1129 = metadata !{i32 311, i32 0, metadata !431, metadata !1121}
!1130 = metadata !{i32 312, i32 0, metadata !431, metadata !1121}
!1131 = metadata !{i32 313, i32 0, metadata !431, metadata !1121}
!1132 = metadata !{i32 316, i32 0, metadata !431, metadata !1121}
!1133 = metadata !{i32 317, i32 0, metadata !431, metadata !1121}
!1134 = metadata !{i32 318, i32 0, metadata !431, metadata !1121}
!1135 = metadata !{i32 319, i32 0, metadata !431, metadata !1121}
!1136 = metadata !{i32 330, i32 0, metadata !431, metadata !1121}
!1137 = metadata !{i32 332, i32 0, metadata !431, metadata !1121}
!1138 = metadata !{i32 1168, i32 0, metadata !438, null}
!1139 = metadata !{i32 1170, i32 0, metadata !438, null}
!1140 = metadata !{i32 1177, i32 0, metadata !438, null}
!1141 = metadata !{i32 1181, i32 0, metadata !196, null}
!1142 = metadata !{i32 63, i32 0, metadata !60, metadata !1143}
!1143 = metadata !{i32 1182, i32 0, metadata !441, null}
!1144 = metadata !{i32 64, i32 0, metadata !278, metadata !1143}
!1145 = metadata !{i32 65, i32 0, metadata !277, metadata !1143}
!1146 = metadata !{i32 66, i32 0, metadata !277, metadata !1143}
!1147 = metadata !{i32 1183, i32 0, metadata !441, null}
!1148 = metadata !{i32 1184, i32 0, metadata !441, null}
!1149 = metadata !{i32 1185, i32 0, metadata !441, null}
!1150 = metadata !{i32 1189, i32 0, metadata !443, null}
!1151 = metadata !{i32 1188, i32 0, metadata !443, null}
!1152 = metadata !{i32 1191, i32 0, metadata !443, null}
!1153 = metadata !{i32 1192, i32 0, metadata !443, null}
!1154 = metadata !{i32 1193, i32 0, metadata !443, null}
!1155 = metadata !{i32 1195, i32 0, metadata !443, null}
!1156 = metadata !{i32 128, i32 0, metadata !197, null}
!1157 = metadata !{i32 133, i32 0, metadata !448, null}
!1158 = metadata !{i32 134, i32 0, metadata !448, null}
!1159 = metadata !{i32 136, i32 0, metadata !448, null}
!1160 = metadata !{i32 137, i32 0, metadata !448, null}
!1161 = metadata !{i32 138, i32 0, metadata !448, null}
!1162 = metadata !{i32 141, i32 0, metadata !448, null}
!1163 = metadata !{i32 144, i32 0, metadata !448, null}
!1164 = metadata !{i32 39, i32 0, metadata !0, metadata !1165}
!1165 = metadata !{i32 146, i32 0, metadata !448, null}
!1166 = metadata !{i32 40, i32 0, metadata !271, metadata !1165}
!1167 = metadata !{i32 43, i32 0, metadata !271, metadata !1165}
!1168 = metadata !{i32 46, i32 0, metadata !271, metadata !1165}
!1169 = metadata !{i32 47, i32 0, metadata !271, metadata !1165}
!1170 = metadata !{i32 48, i32 0, metadata !274, metadata !1165}
!1171 = metadata !{i32 49, i32 0, metadata !274, metadata !1165}
!1172 = metadata !{i32 147, i32 0, metadata !448, null}
!1173 = metadata !{i32 150, i32 0, metadata !448, null}
!1174 = metadata !{i32 153, i32 0, metadata !448, null}
!1175 = metadata !{i32 154, i32 0, metadata !448, null}
!1176 = metadata !{i32 168, i32 0, metadata !448, null}
!1177 = metadata !{i32 169, i32 0, metadata !448, null}
!1178 = metadata !{i32 170, i32 0, metadata !448, null}
!1179 = metadata !{i32 173, i32 0, metadata !448, null}
!1180 = metadata !{i32 97, i32 0, metadata !77, metadata !1179}
!1181 = metadata !{i32 99, i32 0, metadata !285, metadata !1179}
!1182 = metadata !{i32 101, i32 0, metadata !285, metadata !1179}
!1183 = metadata !{i32 107, i32 0, metadata !285, metadata !1179}
!1184 = metadata !{i32 118, i32 0, metadata !285, metadata !1179}
!1185 = metadata !{i32 121, i32 0, metadata !285, metadata !1179}
!1186 = metadata !{i32 174, i32 0, metadata !448, null}
!1187 = metadata !{i32 175, i32 0, metadata !448, null}
!1188 = metadata !{i32 178, i32 0, metadata !448, null}
!1189 = metadata !{i32 1428, i32 0, metadata !150, metadata !1190}
!1190 = metadata !{i32 181, i32 0, metadata !452, null}
!1191 = metadata !{i32 1415, i32 0, metadata !140, metadata !1192}
!1192 = metadata !{i32 1429, i32 0, metadata !358, metadata !1190}
!1193 = metadata !{i32 1417, i32 0, metadata !348, metadata !1192}
!1194 = metadata !{i32 1418, i32 0, metadata !348, metadata !1192}
!1195 = metadata !{i32 1432, i32 0, metadata !358, metadata !1190}
!1196 = metadata !{i32 1433, i32 0, metadata !361, metadata !1190}
!1197 = metadata !{i32 1434, i32 0, metadata !361, metadata !1190}
!1198 = metadata !{i32 1436, i32 0, metadata !361, metadata !1190}
!1199 = metadata !{i32 1439, i32 0, metadata !361, metadata !1190}
!1200 = metadata !{i32 1442, i32 0, metadata !363, metadata !1190}
!1201 = metadata !{i32 1443, i32 0, metadata !363, metadata !1190}
!1202 = metadata !{i32 1444, i32 0, metadata !363, metadata !1190}
!1203 = metadata !{i32 1445, i32 0, metadata !363, metadata !1190}
!1204 = metadata !{i32 182, i32 0, metadata !452, null}
!1205 = metadata !{i32 183, i32 0, metadata !452, null}
!1206 = metadata !{i32 184, i32 0, metadata !452, null}
!1207 = metadata !{i32 186, i32 0, metadata !452, null}
!1208 = metadata !{i32 190, i32 0, metadata !448, null}
!1209 = metadata !{i32 189, i32 0, metadata !448, null}
!1210 = metadata !{i32 191, i32 0, metadata !448, null}
!1211 = metadata !{i32 193, i32 0, metadata !448, null}
!1212 = metadata !{i32 195, i32 0, metadata !448, null}
!1213 = metadata !{i32 201, i32 0, metadata !200, null}
!1214 = metadata !{i32 204, i32 0, metadata !458, null}
!1215 = metadata !{i32 63, i32 0, metadata !60, metadata !1216}
!1216 = metadata !{i32 205, i32 0, metadata !462, null}
!1217 = metadata !{i32 64, i32 0, metadata !278, metadata !1216}
!1218 = metadata !{i32 65, i32 0, metadata !277, metadata !1216}
!1219 = metadata !{i32 66, i32 0, metadata !277, metadata !1216}
!1220 = metadata !{i32 207, i32 0, metadata !462, null}
!1221 = metadata !{i32 208, i32 0, metadata !462, null}
!1222 = metadata !{i32 209, i32 0, metadata !462, null}
!1223 = metadata !{i32 210, i32 0, metadata !462, null}
!1224 = metadata !{i32 211, i32 0, metadata !462, null}
!1225 = metadata !{i32 212, i32 0, metadata !462, null}
!1226 = metadata !{i32 213, i32 0, metadata !462, null}
!1227 = metadata !{i32 215, i32 0, metadata !462, null}
!1228 = metadata !{i32 39, i32 0, metadata !0, metadata !1229}
!1229 = metadata !{i32 218, i32 0, metadata !458, null}
!1230 = metadata !{i32 40, i32 0, metadata !271, metadata !1229}
!1231 = metadata !{i32 43, i32 0, metadata !271, metadata !1229}
!1232 = metadata !{i32 46, i32 0, metadata !271, metadata !1229}
!1233 = metadata !{i32 47, i32 0, metadata !271, metadata !1229}
!1234 = metadata !{i32 48, i32 0, metadata !274, metadata !1229}
!1235 = metadata !{i32 49, i32 0, metadata !274, metadata !1229}
!1236 = metadata !{i32 220, i32 0, metadata !458, null}
!1237 = metadata !{i32 224, i32 0, metadata !458, null}
!1238 = metadata !{i32 223, i32 0, metadata !458, null}
!1239 = metadata !{i32 226, i32 0, metadata !458, null}
!1240 = metadata !{i32 227, i32 0, metadata !458, null}
!1241 = metadata !{i32 228, i32 0, metadata !458, null}
!1242 = metadata !{i32 231, i32 0, metadata !458, null}
!1243 = metadata !{i32 234, i32 0, metadata !458, null}
!1244 = metadata !{i32 236, i32 0, metadata !458, null}
!1245 = metadata !{i32 1428, i32 0, metadata !150, metadata !1244}
!1246 = metadata !{i32 1415, i32 0, metadata !140, metadata !1247}
!1247 = metadata !{i32 1429, i32 0, metadata !358, metadata !1244}
!1248 = metadata !{i32 1417, i32 0, metadata !348, metadata !1247}
!1249 = metadata !{i32 1418, i32 0, metadata !348, metadata !1247}
!1250 = metadata !{i32 1432, i32 0, metadata !358, metadata !1244}
!1251 = metadata !{i32 1433, i32 0, metadata !361, metadata !1244}
!1252 = metadata !{i32 1434, i32 0, metadata !361, metadata !1244}
!1253 = metadata !{i32 1436, i32 0, metadata !361, metadata !1244}
!1254 = metadata !{i32 1439, i32 0, metadata !361, metadata !1244}
!1255 = metadata !{i32 1442, i32 0, metadata !363, metadata !1244}
!1256 = metadata !{i32 1443, i32 0, metadata !363, metadata !1244}
!1257 = metadata !{i32 1444, i32 0, metadata !363, metadata !1244}
!1258 = metadata !{i32 1445, i32 0, metadata !363, metadata !1244}
!1259 = metadata !{i32 237, i32 0, metadata !458, null}
!1260 = metadata !{i32 238, i32 0, metadata !458, null}
!1261 = metadata !{i32 239, i32 0, metadata !458, null}
!1262 = metadata !{i32 242, i32 0, metadata !458, null}
!1263 = metadata !{i32 243, i32 0, metadata !458, null}
!1264 = metadata !{i32 244, i32 0, metadata !458, null}
!1265 = metadata !{i32 245, i32 0, metadata !458, null}
!1266 = metadata !{i32 247, i32 0, metadata !458, null}
!1267 = metadata !{i32 249, i32 0, metadata !458, null}
!1268 = metadata !{i32 1048, i32 0, metadata !203, null}
!1269 = metadata !{i32 1050, i32 0, metadata !466, null}
!1270 = metadata !{i32 63, i32 0, metadata !60, metadata !1271}
!1271 = metadata !{i32 1049, i32 0, metadata !466, null}
!1272 = metadata !{i32 64, i32 0, metadata !278, metadata !1271}
!1273 = metadata !{i32 65, i32 0, metadata !277, metadata !1271}
!1274 = metadata !{i32 66, i32 0, metadata !277, metadata !1271}
!1275 = metadata !{i32 1053, i32 0, metadata !466, null}
!1276 = metadata !{i32 1054, i32 0, metadata !466, null}
!1277 = metadata !{i32 1055, i32 0, metadata !466, null}
!1278 = metadata !{i32 1058, i32 0, metadata !466, null}
!1279 = metadata !{i32 1062, i32 0, metadata !466, null}
!1280 = metadata !{i32 1063, i32 0, metadata !466, null}
!1281 = metadata !{i32 1064, i32 0, metadata !466, null}
!1282 = metadata !{i32 1067, i32 0, metadata !466, null}
!1283 = metadata !{i32 1068, i32 0, metadata !466, null}
!1284 = metadata !{i32 1070, i32 0, metadata !482, null}
!1285 = metadata !{i32 1071, i32 0, metadata !482, null}
!1286 = metadata !{i32 1}
!1287 = metadata !{i32 1072, i32 0, metadata !482, null}
!1288 = metadata !{i32 1076, i32 0, metadata !466, null}
!1289 = metadata !{i32 1077, i32 0, metadata !466, null}
!1290 = metadata !{i32 1078, i32 0, metadata !466, null}
!1291 = metadata !{i32 1091, i32 0, metadata !466, null}
!1292 = metadata !{i32 1092, i32 0, metadata !466, null}
!1293 = metadata !{i32 1093, i32 0, metadata !466, null}
!1294 = metadata !{i32 1096, i32 0, metadata !484, null}
!1295 = metadata !{i32 1097, i32 0, metadata !484, null}
!1296 = metadata !{i32 1098, i32 0, metadata !484, null}
!1297 = metadata !{i32 898, i32 0, metadata !204, null}
!1298 = metadata !{i32 903, i32 0, metadata !488, null}
!1299 = metadata !{i32 63, i32 0, metadata !60, metadata !1300}
!1300 = metadata !{i32 902, i32 0, metadata !488, null}
!1301 = metadata !{i32 64, i32 0, metadata !278, metadata !1300}
!1302 = metadata !{i32 65, i32 0, metadata !277, metadata !1300}
!1303 = metadata !{i32 66, i32 0, metadata !277, metadata !1300}
!1304 = metadata !{i32 910, i32 0, metadata !488, null}
!1305 = metadata !{i32 911, i32 0, metadata !488, null}
!1306 = metadata !{i32 912, i32 0, metadata !488, null}
!1307 = metadata !{i32 915, i32 0, metadata !488, null}
!1308 = metadata !{i32 916, i32 0, metadata !488, null}
!1309 = metadata !{i32 917, i32 0, metadata !488, null}
!1310 = metadata !{i32 919, i32 0, metadata !488, null}
!1311 = metadata !{i32 920, i32 0, metadata !492, null}
!1312 = metadata !{i32 922, i32 0, metadata !492, null}
!1313 = metadata !{i32 924, i32 0, metadata !494, null}
!1314 = metadata !{i32 926, i32 0, metadata !494, null}
!1315 = metadata !{i32 929, i32 0, metadata !494, null}
!1316 = metadata !{i32 932, i32 0, metadata !494, null}
!1317 = metadata !{i32 933, i32 0, metadata !494, null}
!1318 = metadata !{i32 934, i32 0, metadata !494, null}
!1319 = metadata !{i32 935, i32 0, metadata !494, null}
!1320 = metadata !{i32 936, i32 0, metadata !494, null}
!1321 = metadata !{i32 937, i32 0, metadata !494, null}
!1322 = metadata !{i32 938, i32 0, metadata !494, null}
!1323 = metadata !{i32 939, i32 0, metadata !494, null}
!1324 = metadata !{i32 940, i32 0, metadata !494, null}
!1325 = metadata !{i32 941, i32 0, metadata !494, null}
!1326 = metadata !{i32 942, i32 0, metadata !494, null}
!1327 = metadata !{i32 943, i32 0, metadata !494, null}
!1328 = metadata !{i32 944, i32 0, metadata !494, null}
!1329 = metadata !{i32 945, i32 0, metadata !494, null}
!1330 = metadata !{i32 946, i32 0, metadata !494, null}
!1331 = metadata !{i32 947, i32 0, metadata !494, null}
!1332 = metadata !{i32 948, i32 0, metadata !494, null}
!1333 = metadata !{i32 949, i32 0, metadata !494, null}
!1334 = metadata !{i32 950, i32 0, metadata !494, null}
!1335 = metadata !{i32 951, i32 0, metadata !494, null}
!1336 = metadata !{i32 952, i32 0, metadata !494, null}
!1337 = metadata !{i32 953, i32 0, metadata !494, null}
!1338 = metadata !{i32 954, i32 0, metadata !494, null}
!1339 = metadata !{i32 955, i32 0, metadata !494, null}
!1340 = metadata !{i32 956, i32 0, metadata !494, null}
!1341 = metadata !{i32 958, i32 0, metadata !494, null}
!1342 = metadata !{i32 959, i32 0, metadata !494, null}
!1343 = metadata !{i32 964, i32 0, metadata !492, null}
!1344 = metadata !{i32 965, i32 0, metadata !492, null}
!1345 = metadata !{i32 968, i32 0, metadata !492, null}
!1346 = metadata !{i32 969, i32 0, metadata !492, null}
!1347 = metadata !{i32 974, i32 0, metadata !492, null}
!1348 = metadata !{i32 975, i32 0, metadata !492, null}
!1349 = metadata !{i32 978, i32 0, metadata !492, null}
!1350 = metadata !{i32 979, i32 0, metadata !492, null}
!1351 = metadata !{i32 984, i32 0, metadata !492, null}
!1352 = metadata !{i32 985, i32 0, metadata !492, null}
!1353 = metadata !{i32 988, i32 0, metadata !492, null}
!1354 = metadata !{i32 989, i32 0, metadata !492, null}
!1355 = metadata !{i32 993, i32 0, metadata !514, null}
!1356 = metadata !{i32 994, i32 0, metadata !514, null}
!1357 = metadata !{i32 995, i32 0, metadata !514, null}
!1358 = metadata !{i32 996, i32 0, metadata !514, null}
!1359 = metadata !{i32 997, i32 0, metadata !514, null}
!1360 = metadata !{i32 1000, i32 0, metadata !514, null}
!1361 = metadata !{i32 1001, i32 0, metadata !514, null}
!1362 = metadata !{i32 1006, i32 0, metadata !492, null}
!1363 = metadata !{i32 1007, i32 0, metadata !492, null}
!1364 = metadata !{i32 1008, i32 0, metadata !492, null}
!1365 = metadata !{i32 1009, i32 0, metadata !492, null}
!1366 = metadata !{i32 1011, i32 0, metadata !492, null}
!1367 = metadata !{i32 1012, i32 0, metadata !492, null}
!1368 = metadata !{i32 1016, i32 0, metadata !524, null}
!1369 = metadata !{i32 1017, i32 0, metadata !524, null}
!1370 = metadata !{i32 1018, i32 0, metadata !524, null}
!1371 = metadata !{i32 1019, i32 0, metadata !524, null}
!1372 = metadata !{i32 1020, i32 0, metadata !524, null}
!1373 = metadata !{i32 1024, i32 0, metadata !524, null}
!1374 = metadata !{i32 1026, i32 0, metadata !524, null}
!1375 = metadata !{i32 1027, i32 0, metadata !524, null}
!1376 = metadata !{i32 1031, i32 0, metadata !492, null}
!1377 = metadata !{i32 1032, i32 0, metadata !492, null}
!1378 = metadata !{i32 1033, i32 0, metadata !492, null}
!1379 = metadata !{i32 1036, i32 0, metadata !492, null}
!1380 = metadata !{i32 1037, i32 0, metadata !492, null}
!1381 = metadata !{i32 1038, i32 0, metadata !492, null}
!1382 = metadata !{i32 1041, i32 0, metadata !527, null}
!1383 = metadata !{i32 1042, i32 0, metadata !527, null}
!1384 = metadata !{i32 1043, i32 0, metadata !527, null}
!1385 = metadata !{i32 814, i32 0, metadata !207, null}
!1386 = metadata !{i32 63, i32 0, metadata !60, metadata !1387}
!1387 = metadata !{i32 815, i32 0, metadata !532, null}
!1388 = metadata !{i32 64, i32 0, metadata !278, metadata !1387}
!1389 = metadata !{i32 65, i32 0, metadata !277, metadata !1387}
!1390 = metadata !{i32 66, i32 0, metadata !277, metadata !1387}
!1391 = metadata !{i32 817, i32 0, metadata !532, null}
!1392 = metadata !{i32 818, i32 0, metadata !532, null}
!1393 = metadata !{i32 819, i32 0, metadata !532, null}
!1394 = metadata !{i32 822, i32 0, metadata !532, null}
!1395 = metadata !{i32 823, i32 0, metadata !532, null}
!1396 = metadata !{i32 824, i32 0, metadata !532, null}
!1397 = metadata !{i32 825, i32 0, metadata !532, null}
!1398 = metadata !{i32 827, i32 0, metadata !532, null}
!1399 = metadata !{i64 0}
!1400 = metadata !{i32 829, i32 0, metadata !534, null}
!1401 = metadata !{i32 832, i32 0, metadata !534, null}
!1402 = metadata !{i32 833, i32 0, metadata !534, null}
!1403 = metadata !{i32 838, i32 0, metadata !534, null}
!1404 = metadata !{i32 835, i32 0, metadata !534, null}
!1405 = metadata !{i32 836, i32 0, metadata !534, null}
!1406 = metadata !{i32 839, i32 0, metadata !538, null}
!1407 = metadata !{i32 840, i32 0, metadata !538, null}
!1408 = metadata !{i32 841, i32 0, metadata !538, null}
!1409 = metadata !{i32 842, i32 0, metadata !538, null}
!1410 = metadata !{i32 843, i32 0, metadata !538, null}
!1411 = metadata !{i32 844, i32 0, metadata !538, null}
!1412 = metadata !{i32 845, i32 0, metadata !538, null}
!1413 = metadata !{i32 846, i32 0, metadata !538, null}
!1414 = metadata !{i32 847, i32 0, metadata !538, null}
!1415 = metadata !{i32 851, i32 0, metadata !534, null}
!1416 = metadata !{i32 852, i32 0, metadata !534, null}
!1417 = metadata !{i32 853, i32 0, metadata !534, null}
!1418 = metadata !{i32 854, i32 0, metadata !534, null}
!1419 = metadata !{i32 855, i32 0, metadata !534, null}
!1420 = metadata !{i32 856, i32 0, metadata !534, null}
!1421 = metadata !{i32 857, i32 0, metadata !534, null}
!1422 = metadata !{i32 858, i32 0, metadata !534, null}
!1423 = metadata !{i32 860, i32 0, metadata !534, null}
!1424 = metadata !{i32 862, i32 0, metadata !540, null}
!1425 = metadata !{i32 864, i32 0, metadata !540, null}
!1426 = metadata !{i32 873, i32 0, metadata !540, null}
!1427 = metadata !{i32 874, i32 0, metadata !540, null}
!1428 = metadata !{i32 875, i32 0, metadata !540, null}
!1429 = metadata !{i32 876, i32 0, metadata !540, null}
!1430 = metadata !{i32 877, i32 0, metadata !540, null}
!1431 = metadata !{i32 878, i32 0, metadata !540, null}
!1432 = metadata !{i32 880, i32 0, metadata !544, null}
!1433 = metadata !{i32 881, i32 0, metadata !544, null}
!1434 = metadata !{i32 885, i32 0, metadata !544, null}
!1435 = metadata !{i32 886, i32 0, metadata !546, null}
!1436 = metadata !{i32 887, i32 0, metadata !546, null}
!1437 = metadata !{i32 888, i32 0, metadata !546, null}
!1438 = metadata !{i32 475, i32 0, metadata !225, null}
!1439 = metadata !{i32 63, i32 0, metadata !60, metadata !1440}
!1440 = metadata !{i32 477, i32 0, metadata !551, null}
!1441 = metadata !{i32 64, i32 0, metadata !278, metadata !1440}
!1442 = metadata !{i32 65, i32 0, metadata !277, metadata !1440}
!1443 = metadata !{i32 66, i32 0, metadata !277, metadata !1440}
!1444 = metadata !{i32 479, i32 0, metadata !551, null}
!1445 = metadata !{i32 480, i32 0, metadata !551, null}
!1446 = metadata !{i32 481, i32 0, metadata !551, null}
!1447 = metadata !{i32 484, i32 0, metadata !551, null}
!1448 = metadata !{i32 491, i32 0, metadata !551, null}
!1449 = metadata !{i32 492, i32 0, metadata !551, null}
!1450 = metadata !{i32 494, i32 0, metadata !551, null}
!1451 = metadata !{i32 498, i32 0, metadata !551, null}
!1452 = metadata !{i32 499, i32 0, metadata !551, null}
!1453 = metadata !{i32 500, i32 0, metadata !551, null}
!1454 = metadata !{i32 504, i32 0, metadata !551, null}
!1455 = metadata !{i32 505, i32 0, metadata !551, null}
!1456 = metadata !{i32 506, i32 0, metadata !551, null}
!1457 = metadata !{i32 509, i32 0, metadata !551, null}
!1458 = metadata !{i32 510, i32 0, metadata !551, null}
!1459 = metadata !{i32 513, i32 0, metadata !551, null}
!1460 = metadata !{i32 515, i32 0, metadata !551, null}
!1461 = metadata !{i32 516, i32 0, metadata !551, null}
!1462 = metadata !{i32 518, i32 0, metadata !551, null}
!1463 = metadata !{i32 519, i32 0, metadata !551, null}
!1464 = metadata !{i32 523, i32 0, metadata !551, null}
!1465 = metadata !{i32 524, i32 0, metadata !551, null}
!1466 = metadata !{i32 525, i32 0, metadata !551, null}
!1467 = metadata !{i32 528, i32 0, metadata !551, null}
!1468 = metadata !{i32 529, i32 0, metadata !551, null}
!1469 = metadata !{i32 758, i32 0, metadata !228, null}
!1470 = metadata !{i32 63, i32 0, metadata !60, metadata !1471}
!1471 = metadata !{i32 759, i32 0, metadata !556, null}
!1472 = metadata !{i32 64, i32 0, metadata !278, metadata !1471}
!1473 = metadata !{i32 65, i32 0, metadata !277, metadata !1471}
!1474 = metadata !{i32 66, i32 0, metadata !277, metadata !1471}
!1475 = metadata !{i32 761, i32 0, metadata !556, null}
!1476 = metadata !{i32 762, i32 0, metadata !556, null}
!1477 = metadata !{i32 763, i32 0, metadata !556, null}
!1478 = metadata !{i32 766, i32 0, metadata !556, null}
!1479 = metadata !{i32 768, i32 0, metadata !558, null}
!1480 = metadata !{i32 772, i32 0, metadata !558, null}
!1481 = metadata !{i32 773, i32 0, metadata !558, null}
!1482 = metadata !{i32 777, i32 0, metadata !556, null}
!1483 = metadata !{i32 778, i32 0, metadata !556, null}
!1484 = metadata !{i32 587, i32 0, metadata !229, null}
!1485 = metadata !{i32 39, i32 0, metadata !0, metadata !1486}
!1486 = metadata !{i32 588, i32 0, metadata !562, null}
!1487 = metadata !{i32 40, i32 0, metadata !271, metadata !1486}
!1488 = metadata !{i32 43, i32 0, metadata !271, metadata !1486}
!1489 = metadata !{i32 46, i32 0, metadata !271, metadata !1486}
!1490 = metadata !{i32 47, i32 0, metadata !271, metadata !1486}
!1491 = metadata !{i32 48, i32 0, metadata !274, metadata !1486}
!1492 = metadata !{i32 49, i32 0, metadata !274, metadata !1486}
!1493 = metadata !{i32 589, i32 0, metadata !562, null}
!1494 = metadata !{i32 590, i32 0, metadata !562, null}
!1495 = metadata !{i32 591, i32 0, metadata !562, null}
!1496 = metadata !{i32 1428, i32 0, metadata !150, metadata !1497}
!1497 = metadata !{i32 596, i32 0, metadata !564, null}
!1498 = metadata !{i32 1415, i32 0, metadata !140, metadata !1499}
!1499 = metadata !{i32 1429, i32 0, metadata !358, metadata !1497}
!1500 = metadata !{i32 1417, i32 0, metadata !348, metadata !1499}
!1501 = metadata !{i32 1418, i32 0, metadata !348, metadata !1499}
!1502 = metadata !{i32 1432, i32 0, metadata !358, metadata !1497}
!1503 = metadata !{i32 1433, i32 0, metadata !361, metadata !1497}
!1504 = metadata !{i32 1434, i32 0, metadata !361, metadata !1497}
!1505 = metadata !{i32 1436, i32 0, metadata !361, metadata !1497}
!1506 = metadata !{i32 1439, i32 0, metadata !361, metadata !1497}
!1507 = metadata !{i32 1442, i32 0, metadata !363, metadata !1497}
!1508 = metadata !{i32 1443, i32 0, metadata !363, metadata !1497}
!1509 = metadata !{i32 1444, i32 0, metadata !363, metadata !1497}
!1510 = metadata !{i32 1445, i32 0, metadata !363, metadata !1497}
!1511 = metadata !{i32 600, i32 0, metadata !564, null}
!1512 = metadata !{i32 601, i32 0, metadata !564, null}
!1513 = metadata !{i32 551, i32 0, metadata !232, null}
!1514 = metadata !{i32 552, i32 0, metadata !570, null}
!1515 = metadata !{i32 63, i32 0, metadata !60, metadata !1516}
!1516 = metadata !{i32 553, i32 0, metadata !573, null}
!1517 = metadata !{i32 64, i32 0, metadata !278, metadata !1516}
!1518 = metadata !{i32 65, i32 0, metadata !277, metadata !1516}
!1519 = metadata !{i32 66, i32 0, metadata !277, metadata !1516}
!1520 = metadata !{i32 555, i32 0, metadata !573, null}
!1521 = metadata !{i32 556, i32 0, metadata !573, null}
!1522 = metadata !{i32 557, i32 0, metadata !573, null}
!1523 = metadata !{i32 558, i32 0, metadata !573, null}
!1524 = metadata !{i32 559, i32 0, metadata !573, null}
!1525 = metadata !{i32 560, i32 0, metadata !573, null}
!1526 = metadata !{i32 561, i32 0, metadata !573, null}
!1527 = metadata !{i32 563, i32 0, metadata !573, null}
!1528 = metadata !{i32 39, i32 0, metadata !0, metadata !1529}
!1529 = metadata !{i32 565, i32 0, metadata !570, null}
!1530 = metadata !{i32 40, i32 0, metadata !271, metadata !1529}
!1531 = metadata !{i32 43, i32 0, metadata !271, metadata !1529}
!1532 = metadata !{i32 46, i32 0, metadata !271, metadata !1529}
!1533 = metadata !{i32 47, i32 0, metadata !271, metadata !1529}
!1534 = metadata !{i32 48, i32 0, metadata !274, metadata !1529}
!1535 = metadata !{i32 49, i32 0, metadata !274, metadata !1529}
!1536 = metadata !{i32 566, i32 0, metadata !570, null}
!1537 = metadata !{i32 567, i32 0, metadata !570, null}
!1538 = metadata !{i32 568, i32 0, metadata !570, null}
!1539 = metadata !{i32 574, i32 0, metadata !570, null}
!1540 = metadata !{i32 1428, i32 0, metadata !150, metadata !1539}
!1541 = metadata !{i32 1415, i32 0, metadata !140, metadata !1542}
!1542 = metadata !{i32 1429, i32 0, metadata !358, metadata !1539}
!1543 = metadata !{i32 1417, i32 0, metadata !348, metadata !1542}
!1544 = metadata !{i32 1418, i32 0, metadata !348, metadata !1542}
!1545 = metadata !{i32 1432, i32 0, metadata !358, metadata !1539}
!1546 = metadata !{i32 1433, i32 0, metadata !361, metadata !1539}
!1547 = metadata !{i32 1434, i32 0, metadata !361, metadata !1539}
!1548 = metadata !{i32 1436, i32 0, metadata !361, metadata !1539}
!1549 = metadata !{i32 1439, i32 0, metadata !361, metadata !1539}
!1550 = metadata !{i32 1442, i32 0, metadata !363, metadata !1539}
!1551 = metadata !{i32 1443, i32 0, metadata !363, metadata !1539}
!1552 = metadata !{i32 1444, i32 0, metadata !363, metadata !1539}
!1553 = metadata !{i32 1445, i32 0, metadata !363, metadata !1539}
!1554 = metadata !{i32 581, i32 0, metadata !570, null}
!1555 = metadata !{i32 582, i32 0, metadata !570, null}
!1556 = metadata !{i32 532, i32 0, metadata !255, null}
!1557 = metadata !{i32 39, i32 0, metadata !0, metadata !1558}
!1558 = metadata !{i32 533, i32 0, metadata !577, null}
!1559 = metadata !{i32 40, i32 0, metadata !271, metadata !1558}
!1560 = metadata !{i32 43, i32 0, metadata !271, metadata !1558}
!1561 = metadata !{i32 46, i32 0, metadata !271, metadata !1558}
!1562 = metadata !{i32 47, i32 0, metadata !271, metadata !1558}
!1563 = metadata !{i32 48, i32 0, metadata !274, metadata !1558}
!1564 = metadata !{i32 49, i32 0, metadata !274, metadata !1558}
!1565 = metadata !{i32 534, i32 0, metadata !577, null}
!1566 = metadata !{i32 535, i32 0, metadata !577, null}
!1567 = metadata !{i32 536, i32 0, metadata !577, null}
!1568 = metadata !{i32 1428, i32 0, metadata !150, metadata !1569}
!1569 = metadata !{i32 541, i32 0, metadata !579, null}
!1570 = metadata !{i32 1415, i32 0, metadata !140, metadata !1571}
!1571 = metadata !{i32 1429, i32 0, metadata !358, metadata !1569}
!1572 = metadata !{i32 1417, i32 0, metadata !348, metadata !1571}
!1573 = metadata !{i32 1418, i32 0, metadata !348, metadata !1571}
!1574 = metadata !{i32 1432, i32 0, metadata !358, metadata !1569}
!1575 = metadata !{i32 1433, i32 0, metadata !361, metadata !1569}
!1576 = metadata !{i32 1434, i32 0, metadata !361, metadata !1569}
!1577 = metadata !{i32 1436, i32 0, metadata !361, metadata !1569}
!1578 = metadata !{i32 1439, i32 0, metadata !361, metadata !1569}
!1579 = metadata !{i32 1442, i32 0, metadata !363, metadata !1569}
!1580 = metadata !{i32 1443, i32 0, metadata !363, metadata !1569}
!1581 = metadata !{i32 1444, i32 0, metadata !363, metadata !1569}
!1582 = metadata !{i32 1445, i32 0, metadata !363, metadata !1569}
!1583 = metadata !{i32 545, i32 0, metadata !579, null}
!1584 = metadata !{i32 546, i32 0, metadata !579, null}
!1585 = metadata !{i32 403, i32 0, metadata !256, null}
!1586 = metadata !{i32 407, i32 0, metadata !584, null}
!1587 = metadata !{i32 63, i32 0, metadata !60, metadata !1588}
!1588 = metadata !{i32 409, i32 0, metadata !584, null}
!1589 = metadata !{i32 64, i32 0, metadata !278, metadata !1588}
!1590 = metadata !{i32 65, i32 0, metadata !277, metadata !1588}
!1591 = metadata !{i32 66, i32 0, metadata !277, metadata !1588}
!1592 = metadata !{i32 411, i32 0, metadata !584, null}
!1593 = metadata !{i32 412, i32 0, metadata !584, null}
!1594 = metadata !{i32 413, i32 0, metadata !584, null}
!1595 = metadata !{i32 416, i32 0, metadata !584, null}
!1596 = metadata !{i32 417, i32 0, metadata !584, null}
!1597 = metadata !{i32 418, i32 0, metadata !584, null}
!1598 = metadata !{i32 419, i32 0, metadata !584, null}
!1599 = metadata !{i32 422, i32 0, metadata !584, null}
!1600 = metadata !{i32 1415, i32 0, metadata !140, metadata !1601}
!1601 = metadata !{i32 425, i32 0, metadata !586, null}
!1602 = metadata !{i32 1417, i32 0, metadata !348, metadata !1601}
!1603 = metadata !{i32 1418, i32 0, metadata !348, metadata !1601}
!1604 = metadata !{i32 1422, i32 0, metadata !144, metadata !1605}
!1605 = metadata !{i32 426, i32 0, metadata !586, null}
!1606 = metadata !{i32 1423, i32 0, metadata !351, metadata !1605}
!1607 = metadata !{i32 1424, i32 0, metadata !351, metadata !1605}
!1608 = metadata !{i32 430, i32 0, metadata !586, null}
!1609 = metadata !{i32 431, i32 0, metadata !586, null}
!1610 = metadata !{i32 432, i32 0, metadata !586, null}
!1611 = metadata !{i32 433, i32 0, metadata !586, null}
!1612 = metadata !{i32 435, i32 0, metadata !586, null}
!1613 = metadata !{i32 436, i32 0, metadata !586, null}
!1614 = metadata !{i32 437, i32 0, metadata !586, null}
!1615 = metadata !{i32 440, i32 0, metadata !586, null}
!1616 = metadata !{i32 441, i32 0, metadata !586, null}
!1617 = metadata !{i32 444, i32 0, metadata !586, null}
!1618 = metadata !{i32 442, i32 0, metadata !586, null}
!1619 = metadata !{i32 448, i32 0, metadata !588, null}
!1620 = metadata !{i32 449, i32 0, metadata !588, null}
!1621 = metadata !{i32 452, i32 0, metadata !588, null}
!1622 = metadata !{i32 453, i32 0, metadata !588, null}
!1623 = metadata !{i32 455, i32 0, metadata !588, null}
!1624 = metadata !{i32 456, i32 0, metadata !588, null}
!1625 = metadata !{i32 460, i32 0, metadata !588, null}
!1626 = metadata !{i32 461, i32 0, metadata !588, null}
!1627 = metadata !{i32 463, i32 0, metadata !588, null}
!1628 = metadata !{i32 464, i32 0, metadata !588, null}
!1629 = metadata !{i32 466, i32 0, metadata !588, null}
!1630 = metadata !{i32 467, i32 0, metadata !588, null}
!1631 = metadata !{i32 469, i32 0, metadata !588, null}
!1632 = metadata !{i32 470, i32 0, metadata !588, null}
!1633 = metadata !{i32 335, i32 0, metadata !259, null}
!1634 = metadata !{i32 339, i32 0, metadata !593, null}
!1635 = metadata !{i32 341, i32 0, metadata !593, null}
!1636 = metadata !{i32 344, i32 0, metadata !593, null}
!1637 = metadata !{i32 345, i32 0, metadata !593, null}
!1638 = metadata !{i32 346, i32 0, metadata !593, null}
!1639 = metadata !{i32 63, i32 0, metadata !60, metadata !1640}
!1640 = metadata !{i32 349, i32 0, metadata !593, null}
!1641 = metadata !{i32 64, i32 0, metadata !278, metadata !1640}
!1642 = metadata !{i32 65, i32 0, metadata !277, metadata !1640}
!1643 = metadata !{i32 66, i32 0, metadata !277, metadata !1640}
!1644 = metadata !{i32 351, i32 0, metadata !593, null}
!1645 = metadata !{i32 352, i32 0, metadata !593, null}
!1646 = metadata !{i32 353, i32 0, metadata !593, null}
!1647 = metadata !{i32 356, i32 0, metadata !593, null}
!1648 = metadata !{i32 357, i32 0, metadata !593, null}
!1649 = metadata !{i32 358, i32 0, metadata !593, null}
!1650 = metadata !{i32 359, i32 0, metadata !593, null}
!1651 = metadata !{i32 362, i32 0, metadata !593, null}
!1652 = metadata !{i32 1415, i32 0, metadata !140, metadata !1653}
!1653 = metadata !{i32 365, i32 0, metadata !595, null}
!1654 = metadata !{i32 1417, i32 0, metadata !348, metadata !1653}
!1655 = metadata !{i32 1418, i32 0, metadata !348, metadata !1653}
!1656 = metadata !{i32 1422, i32 0, metadata !144, metadata !1657}
!1657 = metadata !{i32 366, i32 0, metadata !595, null}
!1658 = metadata !{i32 1423, i32 0, metadata !351, metadata !1657}
!1659 = metadata !{i32 1424, i32 0, metadata !351, metadata !1657}
!1660 = metadata !{i32 370, i32 0, metadata !595, null}
!1661 = metadata !{i32 371, i32 0, metadata !595, null}
!1662 = metadata !{i32 372, i32 0, metadata !595, null}
!1663 = metadata !{i32 374, i32 0, metadata !595, null}
!1664 = metadata !{i32 376, i32 0, metadata !595, null}
!1665 = metadata !{i32 377, i32 0, metadata !595, null}
!1666 = metadata !{i32 378, i32 0, metadata !595, null}
!1667 = metadata !{i32 381, i32 0, metadata !595, null}
!1668 = metadata !{i32 383, i32 0, metadata !595, null}
!1669 = metadata !{i32 382, i32 0, metadata !595, null}
!1670 = metadata !{i32 386, i32 0, metadata !593, null}
!1671 = metadata !{i32 387, i32 0, metadata !593, null}
!1672 = metadata !{i32 391, i32 0, metadata !593, null}
!1673 = metadata !{i32 392, i32 0, metadata !593, null}
!1674 = metadata !{i32 395, i32 0, metadata !593, null}
!1675 = metadata !{i32 396, i32 0, metadata !593, null}
!1676 = metadata !{i32 398, i32 0, metadata !593, null}
!1677 = metadata !{i32 342, i32 0, metadata !593, null}
!1678 = metadata !{i32 680, i32 0, metadata !263, null}
!1679 = metadata !{i32 63, i32 0, metadata !60, metadata !1680}
!1680 = metadata !{i32 683, i32 0, metadata !601, null}
!1681 = metadata !{i32 64, i32 0, metadata !278, metadata !1680}
!1682 = metadata !{i32 65, i32 0, metadata !277, metadata !1680}
!1683 = metadata !{i32 66, i32 0, metadata !277, metadata !1680}
!1684 = metadata !{i32 685, i32 0, metadata !601, null}
!1685 = metadata !{i32 686, i32 0, metadata !601, null}
!1686 = metadata !{i32 687, i32 0, metadata !601, null}
!1687 = metadata !{i32 690, i32 0, metadata !601, null}
!1688 = metadata !{i32 691, i32 0, metadata !601, null}
!1689 = metadata !{i32 692, i32 0, metadata !601, null}
!1690 = metadata !{i32 693, i32 0, metadata !601, null}
!1691 = metadata !{i32 694, i32 0, metadata !601, null}
!1692 = metadata !{i32 697, i32 0, metadata !601, null}
!1693 = metadata !{i32 645, i32 0, metadata !260, metadata !1694}
!1694 = metadata !{i32 698, i32 0, metadata !601, null}
!1695 = metadata !{i32 646, i32 0, metadata !1696, metadata !1694}
!1696 = metadata !{i32 589835, metadata !260, i32 645, i32 0, metadata !1, i32 84} ; [ DW_TAG_lexical_block ]
!1697 = metadata !{i32 647, i32 0, metadata !1696, metadata !1694}
!1698 = metadata !{i32 648, i32 0, metadata !1696, metadata !1694}
!1699 = metadata !{i32 649, i32 0, metadata !1696, metadata !1694}
!1700 = metadata !{i32 651, i32 0, metadata !1696, metadata !1694}
!1701 = metadata !{i32 653, i32 0, metadata !1696, metadata !1694}
!1702 = metadata !{i32 654, i32 0, metadata !1696, metadata !1694}
!1703 = metadata !{i32 700, i32 0, metadata !603, null}
!1704 = metadata !{i32 701, i32 0, metadata !603, null}
!1705 = metadata !{i32 702, i32 0, metadata !603, null}
!1706 = metadata !{i32 658, i32 0, metadata !266, null}
!1707 = metadata !{i32 39, i32 0, metadata !0, metadata !1708}
!1708 = metadata !{i32 661, i32 0, metadata !607, null}
!1709 = metadata !{i32 40, i32 0, metadata !271, metadata !1708}
!1710 = metadata !{i32 43, i32 0, metadata !271, metadata !1708}
!1711 = metadata !{i32 46, i32 0, metadata !271, metadata !1708}
!1712 = metadata !{i32 47, i32 0, metadata !271, metadata !1708}
!1713 = metadata !{i32 48, i32 0, metadata !274, metadata !1708}
!1714 = metadata !{i32 49, i32 0, metadata !274, metadata !1708}
!1715 = metadata !{i32 51, i32 0, metadata !274, metadata !1708}
!1716 = metadata !{i32 663, i32 0, metadata !607, null}
!1717 = metadata !{i32 664, i32 0, metadata !607, null}
!1718 = metadata !{i32 665, i32 0, metadata !607, null}
!1719 = metadata !{i32 666, i32 0, metadata !607, null}
!1720 = metadata !{i32 667, i32 0, metadata !607, null}
!1721 = metadata !{i32 670, i32 0, metadata !607, null}
!1722 = metadata !{i32 645, i32 0, metadata !260, metadata !1723}
!1723 = metadata !{i32 671, i32 0, metadata !607, null}
!1724 = metadata !{i32 646, i32 0, metadata !1696, metadata !1723}
!1725 = metadata !{i32 647, i32 0, metadata !1696, metadata !1723}
!1726 = metadata !{i32 648, i32 0, metadata !1696, metadata !1723}
!1727 = metadata !{i32 649, i32 0, metadata !1696, metadata !1723}
!1728 = metadata !{i32 651, i32 0, metadata !1696, metadata !1723}
!1729 = metadata !{i32 653, i32 0, metadata !1696, metadata !1723}
!1730 = metadata !{i32 654, i32 0, metadata !1696, metadata !1723}
!1731 = metadata !{i32 1428, i32 0, metadata !150, metadata !1732}
!1732 = metadata !{i32 673, i32 0, metadata !609, null}
!1733 = metadata !{i32 1415, i32 0, metadata !140, metadata !1734}
!1734 = metadata !{i32 1429, i32 0, metadata !358, metadata !1732}
!1735 = metadata !{i32 1417, i32 0, metadata !348, metadata !1734}
!1736 = metadata !{i32 1418, i32 0, metadata !348, metadata !1734}
!1737 = metadata !{i32 1432, i32 0, metadata !358, metadata !1732}
!1738 = metadata !{i32 1433, i32 0, metadata !361, metadata !1732}
!1739 = metadata !{i32 1434, i32 0, metadata !361, metadata !1732}
!1740 = metadata !{i32 1436, i32 0, metadata !361, metadata !1732}
!1741 = metadata !{i32 1439, i32 0, metadata !361, metadata !1732}
!1742 = metadata !{i32 1442, i32 0, metadata !363, metadata !1732}
!1743 = metadata !{i32 1443, i32 0, metadata !363, metadata !1732}
!1744 = metadata !{i32 1444, i32 0, metadata !363, metadata !1732}
!1745 = metadata !{i32 1445, i32 0, metadata !363, metadata !1732}
!1746 = metadata !{i32 674, i32 0, metadata !609, null}
!1747 = metadata !{i32 675, i32 0, metadata !609, null}

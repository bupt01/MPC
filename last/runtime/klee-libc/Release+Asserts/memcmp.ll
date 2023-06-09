; ModuleID = 'memcmp.c'
target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-f128:128:128-n8:16:32:64"
target triple = "x86_64-unknown-linux-gnu"

define i32 @memcmp(i8* nocapture %s1, i8* nocapture %s2, i64 %n) nounwind readonly {
entry:
  tail call void @llvm.dbg.value(metadata !{i8* %s1}, i64 0, metadata !10), !dbg !20
  tail call void @llvm.dbg.value(metadata !{i8* %s2}, i64 0, metadata !11), !dbg !20
  tail call void @llvm.dbg.value(metadata !{i64 %n}, i64 0, metadata !12), !dbg !20
  %0 = icmp eq i64 %n, 0, !dbg !21
  br i1 %0, label %bb5, label %bb1.preheader, !dbg !21

bb1.preheader:                                    ; preds = %entry
  %tmp13 = add i64 %n, -1
  br label %bb1

bb1:                                              ; preds = %bb1.preheader, %bb3
  %indvar = phi i64 [ 0, %bb1.preheader ], [ %indvar.next, %bb3 ]
  %p1.0 = getelementptr i8* %s1, i64 %indvar
  %p2.0 = getelementptr i8* %s2, i64 %indvar
  %1 = load i8* %p1.0, align 1, !dbg !22
  %2 = load i8* %p2.0, align 1, !dbg !22
  %3 = icmp eq i8 %1, %2, !dbg !22
  br i1 %3, label %bb3, label %bb2, !dbg !22

bb2:                                              ; preds = %bb1
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !13), !dbg !22
  tail call void @llvm.dbg.value(metadata !{null}, i64 0, metadata !19), !dbg !22
  tail call void @llvm.dbg.value(metadata !23, i64 0, metadata !13), !dbg !24
  %4 = zext i8 %1 to i32, !dbg !24
  tail call void @llvm.dbg.value(metadata !23, i64 0, metadata !19), !dbg !24
  %5 = zext i8 %2 to i32, !dbg !24
  %6 = sub nsw i32 %4, %5, !dbg !24
  br label %bb5, !dbg !24

bb3:                                              ; preds = %bb1
  %7 = icmp eq i64 %tmp13, %indvar, !dbg !25
  %indvar.next = add i64 %indvar, 1
  br i1 %7, label %bb5, label %bb1, !dbg !25

bb5:                                              ; preds = %bb3, %entry, %bb2
  %.0 = phi i32 [ %6, %bb2 ], [ 0, %entry ], [ 0, %bb3 ]
  ret i32 %.0, !dbg !24
}

declare void @llvm.dbg.value(metadata, i64, metadata) nounwind readnone

!llvm.dbg.sp = !{!0}
!llvm.dbg.lv.memcmp = !{!10, !11, !12, !13, !19}

!0 = metadata !{i32 589870, i32 0, metadata !1, metadata !"memcmp", metadata !"memcmp", metadata !"memcmp", metadata !1, i32 42, metadata !3, i1 false, i1 true, i32 0, i32 0, null, i32 256, i1 true, i32 (i8*, i8*, i64)* @memcmp} ; [ DW_TAG_subprogram ]
!1 = metadata !{i32 589865, metadata !"memcmp.c", metadata !"/home/qiu/QTools/klee/runtime/klee-libc/", metadata !2} ; [ DW_TAG_file_type ]
!2 = metadata !{i32 589841, i32 0, i32 1, metadata !"memcmp.c", metadata !"/home/qiu/QTools/klee/runtime/klee-libc/", metadata !"4.2.1 (Based on Apple Inc. build 5658) (LLVM build 2.9)", i1 true, i1 true, metadata !"", i32 0} ; [ DW_TAG_compile_unit ]
!3 = metadata !{i32 589845, metadata !1, metadata !"", metadata !1, i32 0, i64 0, i64 0, i64 0, i32 0, null, metadata !4, i32 0, null} ; [ DW_TAG_subroutine_type ]
!4 = metadata !{metadata !5, metadata !6, metadata !6, metadata !7}
!5 = metadata !{i32 589860, metadata !1, metadata !"int", metadata !1, i32 0, i64 32, i64 32, i64 0, i32 0, i32 5} ; [ DW_TAG_base_type ]
!6 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, null} ; [ DW_TAG_pointer_type ]
!7 = metadata !{i32 589846, metadata !8, metadata !"size_t", metadata !8, i32 28, i64 0, i64 0, i64 0, i32 0, metadata !9} ; [ DW_TAG_typedef ]
!8 = metadata !{i32 589865, metadata !"xlocale.h", metadata !"/usr/include", metadata !2} ; [ DW_TAG_file_type ]
!9 = metadata !{i32 589860, metadata !1, metadata !"long unsigned int", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, i32 7} ; [ DW_TAG_base_type ]
!10 = metadata !{i32 590081, metadata !0, metadata !"s1", metadata !1, i32 42, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!11 = metadata !{i32 590081, metadata !0, metadata !"s2", metadata !1, i32 42, metadata !6, i32 0} ; [ DW_TAG_arg_variable ]
!12 = metadata !{i32 590081, metadata !0, metadata !"n", metadata !1, i32 42, metadata !7, i32 0} ; [ DW_TAG_arg_variable ]
!13 = metadata !{i32 590080, metadata !14, metadata !"p1", metadata !1, i32 44, metadata !16, i32 0} ; [ DW_TAG_auto_variable ]
!14 = metadata !{i32 589835, metadata !15, i32 42, i32 0, metadata !1, i32 1} ; [ DW_TAG_lexical_block ]
!15 = metadata !{i32 589835, metadata !0, i32 42, i32 0, metadata !1, i32 0} ; [ DW_TAG_lexical_block ]
!16 = metadata !{i32 589839, metadata !1, metadata !"", metadata !1, i32 0, i64 64, i64 64, i64 0, i32 0, metadata !17} ; [ DW_TAG_pointer_type ]
!17 = metadata !{i32 589862, metadata !1, metadata !"", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, metadata !18} ; [ DW_TAG_const_type ]
!18 = metadata !{i32 589860, metadata !1, metadata !"unsigned char", metadata !1, i32 0, i64 8, i64 8, i64 0, i32 0, i32 8} ; [ DW_TAG_base_type ]
!19 = metadata !{i32 590080, metadata !14, metadata !"p2", metadata !1, i32 44, metadata !16, i32 0} ; [ DW_TAG_auto_variable ]
!20 = metadata !{i32 42, i32 0, metadata !0, null}
!21 = metadata !{i32 43, i32 0, metadata !15, null}
!22 = metadata !{i32 47, i32 0, metadata !14, null}
!23 = metadata !{i8* undef}
!24 = metadata !{i32 48, i32 0, metadata !14, null}
!25 = metadata !{i32 50, i32 0, metadata !14, null}

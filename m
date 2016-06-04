Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id E5AA61A1E44
 for <linux-nvdimm@lists.01.org>; Sat,  4 Jun 2016 13:54:44 -0700 (PDT)
Subject: [PATCH 12/13] x86/insn: remove pcommit
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 04 Jun 2016 13:53:37 -0700
Message-ID: <146507361711.8347.134160267558534164.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146507355220.8347.12117020810872172684.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, x86@kernel.org, david@fromorbit.com, Adrian Hunter <adrian.hunter@intel.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, linux-kernel@vger.kernel.org, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@suse.de>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The pcommit instruction is being deprecated in favor of ADR
(asynchronous DRAM refresh) flush-on-power-fail, required at the
platform level.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Xiao Guangrong <guangrong.xiao@linux.intel.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/include/asm/cpufeatures.h                 |    1 
 arch/x86/include/asm/special_insns.h               |   46 --------------------
 arch/x86/lib/x86-opcode-map.txt                    |    2 -
 tools/objtool/arch/x86/insn/x86-opcode-map.txt     |    2 -
 tools/perf/arch/x86/tests/insn-x86-dat-32.c        |    2 -
 tools/perf/arch/x86/tests/insn-x86-dat-64.c        |    2 -
 tools/perf/arch/x86/tests/insn-x86-dat-src.c       |    4 --
 .../perf/util/intel-pt-decoder/x86-opcode-map.txt  |    2 -
 8 files changed, 3 insertions(+), 58 deletions(-)

diff --git a/arch/x86/include/asm/cpufeatures.h b/arch/x86/include/asm/cpufeatures.h
index 4a413485f9eb..700d97df7d28 100644
--- a/arch/x86/include/asm/cpufeatures.h
+++ b/arch/x86/include/asm/cpufeatures.h
@@ -225,7 +225,6 @@
 #define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
 #define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
 #define X86_FEATURE_SMAP	( 9*32+20) /* Supervisor Mode Access Prevention */
-#define X86_FEATURE_PCOMMIT	( 9*32+22) /* PCOMMIT instruction */
 #define X86_FEATURE_CLFLUSHOPT	( 9*32+23) /* CLFLUSHOPT instruction */
 #define X86_FEATURE_CLWB	( 9*32+24) /* CLWB instruction */
 #define X86_FEATURE_AVX512PF	( 9*32+26) /* AVX-512 Prefetch */
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index d96d04377765..587d7914ea4b 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -253,52 +253,6 @@ static inline void clwb(volatile void *__p)
 		: [pax] "a" (p));
 }
 
-/**
- * pcommit_sfence() - persistent commit and fence
- *
- * The PCOMMIT instruction ensures that data that has been flushed from the
- * processor's cache hierarchy with CLWB, CLFLUSHOPT or CLFLUSH is accepted to
- * memory and is durable on the DIMM.  The primary use case for this is
- * persistent memory.
- *
- * This function shows how to properly use CLWB/CLFLUSHOPT/CLFLUSH and PCOMMIT
- * with appropriate fencing.
- *
- * Example:
- * void flush_and_commit_buffer(void *vaddr, unsigned int size)
- * {
- *         unsigned long clflush_mask = boot_cpu_data.x86_clflush_size - 1;
- *         void *vend = vaddr + size;
- *         void *p;
- *
- *         for (p = (void *)((unsigned long)vaddr & ~clflush_mask);
- *              p < vend; p += boot_cpu_data.x86_clflush_size)
- *                 clwb(p);
- *
- *         // SFENCE to order CLWB/CLFLUSHOPT/CLFLUSH cache flushes
- *         // MFENCE via mb() also works
- *         wmb();
- *
- *         // PCOMMIT and the required SFENCE for ordering
- *         pcommit_sfence();
- * }
- *
- * After this function completes the data pointed to by 'vaddr' has been
- * accepted to memory and will be durable if the 'vaddr' points to persistent
- * memory.
- *
- * PCOMMIT must always be ordered by an MFENCE or SFENCE, so to help simplify
- * things we include both the PCOMMIT and the required SFENCE in the
- * alternatives generated by pcommit_sfence().
- */
-static inline void pcommit_sfence(void)
-{
-	alternative(ASM_NOP7,
-		    ".byte 0x66, 0x0f, 0xae, 0xf8\n\t" /* pcommit */
-		    "sfence",
-		    X86_FEATURE_PCOMMIT);
-}
-
 #define nop() asm volatile ("nop")
 
 
diff --git a/arch/x86/lib/x86-opcode-map.txt b/arch/x86/lib/x86-opcode-map.txt
index d388de72eaca..28632ee68377 100644
--- a/arch/x86/lib/x86-opcode-map.txt
+++ b/arch/x86/lib/x86-opcode-map.txt
@@ -947,7 +947,7 @@ GrpTable: Grp15
 4: XSAVE
 5: XRSTOR | lfence (11B)
 6: XSAVEOPT | clwb (66) | mfence (11B)
-7: clflush | clflushopt (66) | sfence (11B) | pcommit (66),(11B)
+7: clflush | clflushopt (66) | sfence (11B)
 EndTable
 
 GrpTable: Grp16
diff --git a/tools/objtool/arch/x86/insn/x86-opcode-map.txt b/tools/objtool/arch/x86/insn/x86-opcode-map.txt
index d388de72eaca..28632ee68377 100644
--- a/tools/objtool/arch/x86/insn/x86-opcode-map.txt
+++ b/tools/objtool/arch/x86/insn/x86-opcode-map.txt
@@ -947,7 +947,7 @@ GrpTable: Grp15
 4: XSAVE
 5: XRSTOR | lfence (11B)
 6: XSAVEOPT | clwb (66) | mfence (11B)
-7: clflush | clflushopt (66) | sfence (11B) | pcommit (66),(11B)
+7: clflush | clflushopt (66) | sfence (11B)
 EndTable
 
 GrpTable: Grp16
diff --git a/tools/perf/arch/x86/tests/insn-x86-dat-32.c b/tools/perf/arch/x86/tests/insn-x86-dat-32.c
index 3b491cfe204e..38a48daed154 100644
--- a/tools/perf/arch/x86/tests/insn-x86-dat-32.c
+++ b/tools/perf/arch/x86/tests/insn-x86-dat-32.c
@@ -654,5 +654,3 @@
 "0f c7 1d 78 56 34 12 \txrstors 0x12345678",},
 {{0x0f, 0xc7, 0x9c, 0xc8, 0x78, 0x56, 0x34, 0x12, }, 8, 0, "", "",
 "0f c7 9c c8 78 56 34 12 \txrstors 0x12345678(%eax,%ecx,8)",},
-{{0x66, 0x0f, 0xae, 0xf8, }, 4, 0, "", "",
-"66 0f ae f8          \tpcommit ",},
diff --git a/tools/perf/arch/x86/tests/insn-x86-dat-64.c b/tools/perf/arch/x86/tests/insn-x86-dat-64.c
index 4fe7cce179c4..1f11ea85b60f 100644
--- a/tools/perf/arch/x86/tests/insn-x86-dat-64.c
+++ b/tools/perf/arch/x86/tests/insn-x86-dat-64.c
@@ -764,5 +764,3 @@
 "0f c7 9c c8 78 56 34 12 \txrstors 0x12345678(%rax,%rcx,8)",},
 {{0x41, 0x0f, 0xc7, 0x9c, 0xc8, 0x78, 0x56, 0x34, 0x12, }, 9, 0, "", "",
 "41 0f c7 9c c8 78 56 34 12 \txrstors 0x12345678(%r8,%rcx,8)",},
-{{0x66, 0x0f, 0xae, 0xf8, }, 4, 0, "", "",
-"66 0f ae f8          \tpcommit ",},
diff --git a/tools/perf/arch/x86/tests/insn-x86-dat-src.c b/tools/perf/arch/x86/tests/insn-x86-dat-src.c
index 41b1b1c62660..033b8a6fdab9 100644
--- a/tools/perf/arch/x86/tests/insn-x86-dat-src.c
+++ b/tools/perf/arch/x86/tests/insn-x86-dat-src.c
@@ -866,10 +866,6 @@ int main(void)
 
 #endif /* #ifndef __x86_64__ */
 
-	/* pcommit */
-
-	asm volatile("pcommit");
-
 	/* Following line is a marker for the awk script - do not change */
 	asm volatile("rdtsc"); /* Stop here */
 
diff --git a/tools/perf/util/intel-pt-decoder/x86-opcode-map.txt b/tools/perf/util/intel-pt-decoder/x86-opcode-map.txt
index d388de72eaca..28632ee68377 100644
--- a/tools/perf/util/intel-pt-decoder/x86-opcode-map.txt
+++ b/tools/perf/util/intel-pt-decoder/x86-opcode-map.txt
@@ -947,7 +947,7 @@ GrpTable: Grp15
 4: XSAVE
 5: XRSTOR | lfence (11B)
 6: XSAVEOPT | clwb (66) | mfence (11B)
-7: clflush | clflushopt (66) | sfence (11B) | pcommit (66),(11B)
+7: clflush | clflushopt (66) | sfence (11B)
 EndTable
 
 GrpTable: Grp16

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

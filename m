Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 61E9E81EF9
 for <linux-nvdimm@lists.01.org>; Thu, 17 Nov 2016 12:36:31 -0800 (PST)
Subject: [PATCH] x86: Add warning when memmap=nn!ss and
 CONFIG_RANDOMIZE_BASE enabled
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 17 Nov 2016 13:36:35 -0700
Message-ID: <147941499514.131046.6450643991764692220.stgit@djiang5-desk3.ch.intel.com>
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
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

CONFIG_RANDOMIZE_BASE can place the kernel anywhere. This causes a problem
for when memmap=nn!ss is used. This information is not known until after
the kernel starts executing and the decision for where the randomized
base goes happens before the kernel is uncompressed. memmap=nn!ss is not
reliable in the presence of CONFIG_RANDOMIZE_BASE.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/kernel-parameters.txt |    5 ++++-
 arch/x86/kernel/e820.c              |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 37babf9..4bf32ab 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2290,7 +2290,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			[KNL,X86] Mark specific memory as protected.
 			Region of memory to be used, from ss to ss+nn.
 			The memory region may be marked as e820 type 12 (0xc)
-			and is NVDIMM or ADR memory.
+			and is NVDIMM or ADR memory. If CONFIG_RANDOMIZE_BASE
+			is enabled the kernel image may collide overwrite the
+			pmem range on subsequent boots. memmap=nn!ss is not
+			reliable in the presence CONFIG_RANDOMIZE_BASE.
 
 	memory_corruption_check=0/1 [X86]
 			Some BIOSes seem to corrupt the first 64k of
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index b85fe5f..d85be72 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -904,6 +904,8 @@ static int __init parse_memmap_one(char *p)
 	} else if (*p == '!') {
 		start_at = memparse(p+1, &p);
 		e820_add_region(start_at, mem_size, E820_PRAM);
+		if (IS_ENABLED(CONFIG_RANDOMIZE_BASE))
+			pr_warn("e820: CONFIG_RANDOMIZE_BASE enabled, kernel image may collide/overwrite the pmem range on subsequent boots!\n");
 	} else
 		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

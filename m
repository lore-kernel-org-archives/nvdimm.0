Return-Path: <owner-linux-mm@kvack.org>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Subject: [PATCH] arm64: configurable sparsemem section size
Date: Tue, 23 Apr 2019 16:38:43 -0400
Message-Id: <20190423203843.2898-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: owner-linux-mm@kvack.org
To: pasha.tatashin@soleen.com, jmorris@namei.org, sashal@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, akpm@linux-foundation.org, mhocko@suse.com, dave.hansen@linux.intel.com, dan.j.williams@intel.com, keith.busch@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, zwisler@kernel.org, thomas.lendacky@amd.com, ying.huang@intel.com, fengguang.wu@intel.com, bp@suse.de, bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de, jglisse@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com, rppt@linux.vnet.ibm.com, ard.biesheuvel@linaro.org, andrew.murray@arm.com, james.morse@arm.com, marc.zyngier@arm.com, sboyd@kernel.org, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

sparsemem section size determines the maximum size and alignment that
is allowed to offline/online memory block. The bigger the size the less
the clutter in /sys/devices/system/memory/*. On the other hand, however,
there is less flexability in what granules of memory can be added and
removed.

Recently, it was enabled in Linux to hotadd persistent memory that
can be either real NV device, or reserved from regular System RAM
and has identity of devdax.

The problem is that because ARM64's section size is 1G, and devdax must
have 2M label section, the first 1G is always missed when device is
attached, because it is not 1G aligned.

Allow, better flexibility by making section size configurable.

Signed-off-by: Pavel Tatashin <pasha.tatashin@soleen.com>
---
 arch/arm64/Kconfig                 | 10 ++++++++++
 arch/arm64/include/asm/sparsemem.h |  2 +-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index b5d8cf57e220..a0c5b9d13a7f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -801,6 +801,16 @@ config ARM64_PA_BITS
 	default 48 if ARM64_PA_BITS_48
 	default 52 if ARM64_PA_BITS_52
 
+config ARM64_SECTION_SIZE_BITS
+	int "sparsemem section size shift"
+	range 27 30
+	default "30"
+	depends on SPARSEMEM
+	help
+	  Specify section size in bits. Section size determines the hotplug
+	  hotremove granularity. The current size can be determined from
+	  /sys/devices/system/memory/block_size_bytes
+
 config CPU_BIG_ENDIAN
        bool "Build big-endian kernel"
        help
diff --git a/arch/arm64/include/asm/sparsemem.h b/arch/arm64/include/asm/sparsemem.h
index b299929fe56c..810db34d7038 100644
--- a/arch/arm64/include/asm/sparsemem.h
+++ b/arch/arm64/include/asm/sparsemem.h
@@ -18,7 +18,7 @@
 
 #ifdef CONFIG_SPARSEMEM
 #define MAX_PHYSMEM_BITS	CONFIG_ARM64_PA_BITS
-#define SECTION_SIZE_BITS	30
+#define SECTION_SIZE_BITS	CONFIG_ARM64_SECTION_SIZE_BITS
 #endif
 
 #endif
-- 
2.21.0

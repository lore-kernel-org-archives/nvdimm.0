Return-Path: <linux-kernel-owner@vger.kernel.org>
Subject: [PATCH 1/2] arch: consolidate CONFIG_STRICT_DEVM in
 lib/Kconfig.debug
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 21 Nov 2015 19:57:02 -0800
Message-ID: <20151122035702.9313.52457.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Catalin Marinas <catalin.marinas@arm.com>, linux-nvdimm@lists.01.org, Heiko Carstens <heiko.carstens@de.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

Let all the archs that implement CONFIG_STRICT_DEVM use a common
definition in lib/Kconfig.debug.

Note, the 'depends on !SPARC' is due to sparc not implementing
devmem_is_allowed().

Cc: Kees Cook <keescook@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "David S. Miller" <davem@davemloft.net>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/arm/Kconfig.debug       |   14 --------------
 arch/arm64/Kconfig.debug     |   14 --------------
 arch/powerpc/Kconfig.debug   |   12 ------------
 arch/s390/Kconfig.debug      |   12 ------------
 arch/tile/Kconfig            |    3 ---
 arch/unicore32/Kconfig.debug |   14 --------------
 arch/x86/Kconfig.debug       |   17 -----------------
 lib/Kconfig.debug            |   19 +++++++++++++++++++
 8 files changed, 19 insertions(+), 86 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 259c0ca9c99a..e356357d86bb 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -15,20 +15,6 @@ config ARM_PTDUMP
 	  kernel.
 	  If in doubt, say "N"
 
-config STRICT_DEVMEM
-	bool "Filter access to /dev/mem"
-	depends on MMU
-	---help---
-	  If this option is disabled, you allow userspace (root) access to all
-	  of memory, including kernel and userspace memory. Accidental
-	  access to this is obviously disastrous, but specific access can
-	  be used by people debugging the kernel.
-
-	  If this option is switched on, the /dev/mem file only allows
-	  userspace access to memory mapped peripherals.
-
-          If in doubt, say Y.
-
 # RMK wants arm kernels compiled with frame pointers or stack unwinding.
 # If you know what you are doing and are willing to live without stack
 # traces, you can get a slightly smaller kernel by setting this option to
diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 04fb73b973f1..e13c4bf84d9e 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -14,20 +14,6 @@ config ARM64_PTDUMP
 	  kernel.
 	  If in doubt, say "N"
 
-config STRICT_DEVMEM
-	bool "Filter access to /dev/mem"
-	depends on MMU
-	help
-	  If this option is disabled, you allow userspace (root) access to all
-	  of memory, including kernel and userspace memory. Accidental
-	  access to this is obviously disastrous, but specific access can
-	  be used by people debugging the kernel.
-
-	  If this option is switched on, the /dev/mem file only allows
-	  userspace access to memory mapped peripherals.
-
-	  If in doubt, say Y.
-
 config PID_IN_CONTEXTIDR
 	bool "Write the current PID to the CONTEXTIDR register"
 	help
diff --git a/arch/powerpc/Kconfig.debug b/arch/powerpc/Kconfig.debug
index 3a510f4a6b68..a0e44a9c456f 100644
--- a/arch/powerpc/Kconfig.debug
+++ b/arch/powerpc/Kconfig.debug
@@ -335,18 +335,6 @@ config PPC_EARLY_DEBUG_CPM_ADDR
 	  platform probing is done, all platforms selected must
 	  share the same address.
 
-config STRICT_DEVMEM
-	def_bool y
-	prompt "Filter access to /dev/mem"
-	help
-	  This option restricts access to /dev/mem.  If this option is
-	  disabled, you allow userspace access to all memory, including
-	  kernel and userspace memory. Accidental memory access is likely
-	  to be disastrous.
-	  Memory access is required for experts who want to debug the kernel.
-
-	  If you are unsure, say Y.
-
 config FAIL_IOMMU
 	bool "Fault-injection capability for IOMMU"
 	depends on FAULT_INJECTION
diff --git a/arch/s390/Kconfig.debug b/arch/s390/Kconfig.debug
index c56878e1245f..26c5d5beb4be 100644
--- a/arch/s390/Kconfig.debug
+++ b/arch/s390/Kconfig.debug
@@ -5,18 +5,6 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config STRICT_DEVMEM
-	def_bool y
-	prompt "Filter access to /dev/mem"
-	---help---
-	  This option restricts access to /dev/mem.  If this option is
-	  disabled, you allow userspace access to all memory, including
-	  kernel and userspace memory. Accidental memory access is likely
-	  to be disastrous.
-	  Memory access is required for experts who want to debug the kernel.
-
-	  If you are unsure, say Y.
-
 config S390_PTDUMP
 	bool "Export kernel pagetable layout to userspace via debugfs"
 	depends on DEBUG_KERNEL
diff --git a/arch/tile/Kconfig b/arch/tile/Kconfig
index 106c21bd7f44..7b2d40db11fa 100644
--- a/arch/tile/Kconfig
+++ b/arch/tile/Kconfig
@@ -116,9 +116,6 @@ config ARCH_DISCONTIGMEM_DEFAULT
 config TRACE_IRQFLAGS_SUPPORT
 	def_bool y
 
-config STRICT_DEVMEM
-	def_bool y
-
 # SMP is required for Tilera Linux.
 config SMP
 	def_bool y
diff --git a/arch/unicore32/Kconfig.debug b/arch/unicore32/Kconfig.debug
index 1a3626239843..f075bbe1d46f 100644
--- a/arch/unicore32/Kconfig.debug
+++ b/arch/unicore32/Kconfig.debug
@@ -2,20 +2,6 @@ menu "Kernel hacking"
 
 source "lib/Kconfig.debug"
 
-config STRICT_DEVMEM
-	bool "Filter access to /dev/mem"
-	depends on MMU
-	---help---
-	  If this option is disabled, you allow userspace (root) access to all
-	  of memory, including kernel and userspace memory. Accidental
-	  access to this is obviously disastrous, but specific access can
-	  be used by people debugging the kernel.
-
-	  If this option is switched on, the /dev/mem file only allows
-	  userspace access to memory mapped peripherals.
-
-          If in doubt, say Y.
-
 config EARLY_PRINTK
 	def_bool DEBUG_OCD
 	help
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 137dfa96aa14..1116452fcfc2 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -5,23 +5,6 @@ config TRACE_IRQFLAGS_SUPPORT
 
 source "lib/Kconfig.debug"
 
-config STRICT_DEVMEM
-	bool "Filter access to /dev/mem"
-	---help---
-	  If this option is disabled, you allow userspace (root) access to all
-	  of memory, including kernel and userspace memory. Accidental
-	  access to this is obviously disastrous, but specific access can
-	  be used by people debugging the kernel. Note that with PAT support
-	  enabled, even in this case there are restrictions on /dev/mem
-	  use due to the cache aliasing requirements.
-
-	  If this option is switched on, the /dev/mem file only allows
-	  userspace access to PCI space and the BIOS code and data regions.
-	  This is sufficient for dosemu and X and all common users of
-	  /dev/mem.
-
-	  If in doubt, say Y.
-
 config X86_VERBOSE_BOOTUP
 	bool "Enable verbose x86 bootup info messages"
 	default y
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index 8c15b29d5adc..ad85145d0047 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -1853,3 +1853,22 @@ source "samples/Kconfig"
 
 source "lib/Kconfig.kgdb"
 
+config STRICT_DEVMEM
+	bool "Filter access to /dev/mem"
+	depends on MMU
+	depends on !SPARC
+	default y if TILE || PPC || S390
+	---help---
+	  If this option is disabled, you allow userspace (root) access to all
+	  of memory, including kernel and userspace memory. Accidental
+	  access to this is obviously disastrous, but specific access can
+	  be used by people debugging the kernel. Note that with PAT support
+	  enabled, even in this case there are restrictions on /dev/mem
+	  use due to the cache aliasing requirements.
+
+	  If this option is switched on, the /dev/mem file only allows
+	  userspace access to PCI space and the BIOS code and data regions.
+	  This is sufficient for dosemu and X and all common users of
+	  /dev/mem.
+
+	  If in doubt, say Y.


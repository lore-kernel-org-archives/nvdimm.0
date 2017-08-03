Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x242.google.com (mail-pf0-x242.google.com
 [IPv6:2607:f8b0:400e:c00::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 951DC21E1DAD9
 for <linux-nvdimm@lists.01.org>; Thu,  3 Aug 2017 00:47:50 -0700 (PDT)
Received: by mail-pf0-x242.google.com with SMTP id c65so798115pfl.0
 for <linux-nvdimm@lists.01.org>; Thu, 03 Aug 2017 00:50:02 -0700 (PDT)
From: Steven Swanson <swanson@eng.ucsd.edu>
Subject: [RFC 16/16] NOVA: Build infrastructure
Date: Thu, 03 Aug 2017 00:50:00 -0700
Message-ID: <150174660010.104003.3617931744226337860.stgit@hn>
In-Reply-To: <150174646416.104003.14042713459553361884.stgit@hn>
References: <150174646416.104003.14042713459553361884.stgit@hn>
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
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: Steven Swanson <steven.swanson@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Steven Swanson <swanson@cs.ucsd.edu>
---
 fs/Kconfig       |    2 ++
 fs/Makefile      |    1 +
 fs/nova/Kconfig  |   15 +++++++++++++++
 fs/nova/Makefile |    9 +++++++++
 4 files changed, 27 insertions(+)
 create mode 100644 fs/nova/Kconfig
 create mode 100644 fs/nova/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index b0e42b6a96b9..571714353a5f 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -58,6 +58,8 @@ config FS_DAX_PMD
 	depends on ZONE_DEVICE
 	depends on TRANSPARENT_HUGEPAGE
 
+source "fs/nova/Kconfig"
+
 endif # BLOCK
 
 # Posix ACL utility routines
diff --git a/fs/Makefile b/fs/Makefile
index 7bbaca9c67b1..53f6465e0f4c 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -113,6 +113,7 @@ obj-$(CONFIG_OMFS_FS)		+= omfs/
 obj-$(CONFIG_JFS_FS)		+= jfs/
 obj-$(CONFIG_XFS_FS)		+= xfs/
 obj-$(CONFIG_9P_FS)		+= 9p/
+obj-$(CONFIG_NOVA_FS)		+= nova/
 obj-$(CONFIG_AFS_FS)		+= afs/
 obj-$(CONFIG_NILFS2_FS)		+= nilfs2/
 obj-$(CONFIG_BEFS_FS)		+= befs/
diff --git a/fs/nova/Kconfig b/fs/nova/Kconfig
new file mode 100644
index 000000000000..c1c692edef92
--- /dev/null
+++ b/fs/nova/Kconfig
@@ -0,0 +1,15 @@
+config NOVA_FS
+	tristate "NOVA: log-structured file system for non-volatile memories"
+	depends on FS_DAX
+	select CRC32
+	select LIBCRC32C
+	help
+	  If your system has a block of fast (comparable in access speed to
+	  system memory) and non-volatile byte-addressable memory and you wish
+	  to mount a light-weight filesystem with strong consistency support
+	  over it, say Y here.
+
+	  To compile this as a module, choose M here: the module will be
+	  called nova.
+
+	  If unsure, say N.
diff --git a/fs/nova/Makefile b/fs/nova/Makefile
new file mode 100644
index 000000000000..c45e418652ca
--- /dev/null
+++ b/fs/nova/Makefile
@@ -0,0 +1,9 @@
+#
+# Makefile for the linux NOVA filesystem routines.
+#
+
+obj-$(CONFIG_NOVA_FS) += nova.o
+
+nova-y := balloc.o bbuild.o checksum.o dax.o dir.o file.o gc.o inode.o ioctl.o \
+	journal.o log.o mprotect.o namei.o parity.o rebuild.o snapshot.o stats.o \
+	super.o symlink.o sysfs.o perf.o

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

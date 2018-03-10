Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg0-x242.google.com (mail-pg0-x242.google.com
 [IPv6:2607:f8b0:400e:c05::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F2A92258AEF5
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:14:08 -0800 (PST)
Received: by mail-pg0-x242.google.com with SMTP id g12so4844016pgs.0
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 10:20:26 -0800 (PST)
From: Andiry Xu <jix024@eng.ucsd.edu>
Subject: [RFC v2 09/83] Add Kconfig and Makefile
Date: Sat, 10 Mar 2018 10:17:50 -0800
Message-Id: <1520705944-6723-10-git-send-email-jix024@eng.ucsd.edu>
In-Reply-To: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: coughlan@redhat.com, miklos@szeredi.hu, Andiry Xu <jix024@cs.ucsd.edu>, david@fromorbit.com, jack@suse.com, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

From: Andiry Xu <jix024@cs.ucsd.edu>

Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
---
 fs/Kconfig       |  2 ++
 fs/Makefile      |  1 +
 fs/nova/Kconfig  | 15 +++++++++++++++
 fs/nova/Makefile |  7 +++++++
 4 files changed, 25 insertions(+)
 create mode 100644 fs/nova/Kconfig
 create mode 100644 fs/nova/Makefile

diff --git a/fs/Kconfig b/fs/Kconfig
index bc821a8..5e9ff3e 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -58,6 +58,8 @@ config FS_DAX_PMD
 	depends on ZONE_DEVICE
 	depends on TRANSPARENT_HUGEPAGE
 
+source "fs/nova/Kconfig"
+
 # Selected by DAX drivers that do not expect filesystem DAX to support
 # get_user_pages() of DAX mappings. I.e. "limited" indicates no support
 # for fork() of processes with MAP_SHARED mappings or support for
diff --git a/fs/Makefile b/fs/Makefile
index add789e..65ea619 100644
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
index 0000000..c1c692e
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
index 0000000..eb19646
--- /dev/null
+++ b/fs/nova/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the linux NOVA filesystem routines.
+#
+
+obj-$(CONFIG_NOVA_FS) += nova.o
+
+nova-y := bbuild.o inode.o rebuild.o super.o
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

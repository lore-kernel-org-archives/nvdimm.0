Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FA5A220E8CA6
 for <linux-nvdimm@lists.01.org>; Fri, 13 Apr 2018 13:47:40 -0700 (PDT)
Subject: [PATCH] MAINTAINERS: Adding backup maintainers for libnvdimm and DAX
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 13 Apr 2018 13:47:40 -0700
Message-ID: <152365245998.33329.8224892765972973116.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding additional maintainers to libnvdimm related code and DAX.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 MAINTAINERS |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 73d83416d852..958f75ad4193 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4246,6 +4246,9 @@ F:	include/trace/events/fs_dax.h
 
 DEVICE DIRECT ACCESS (DAX)
 M:	Dan Williams <dan.j.williams@intel.com>
+M:	Dave Jiang <dave.jiang@intel.com>
+M:	Ross Zwisler <ross.zwisler@linux.intel.com>
+M:	Vishal Verma <vishal.l.verma@intel.com>
 L:	linux-nvdimm@lists.01.org
 S:	Supported
 F:	drivers/dax/
@@ -8034,6 +8037,9 @@ F:	tools/lib/lockdep/
 
 LIBNVDIMM BLK: MMIO-APERTURE DRIVER
 M:	Ross Zwisler <ross.zwisler@linux.intel.com>
+M:	Dan Williams <dan.j.williams@intel.com>
+M:	Vishal Verma <vishal.l.verma@intel.com>
+M:	Dave Jiang <dave.jiang@intel.com>
 L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
@@ -8042,6 +8048,9 @@ F:	drivers/nvdimm/region_devs.c
 
 LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
 M:	Vishal Verma <vishal.l.verma@intel.com>
+M:	Dan Williams <dan.j.williams@intel.com>
+M:	Ross Zwisler <ross.zwisler@linux.intel.com>
+M:	Dave Jiang <dave.jiang@intel.com>
 L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
@@ -8049,6 +8058,9 @@ F:	drivers/nvdimm/btt*
 
 LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
 M:	Ross Zwisler <ross.zwisler@linux.intel.com>
+M:	Dan Williams <dan.j.williams@intel.com>
+M:	Vishal Verma <vishal.l.verma@intel.com>
+M:	Dave Jiang <dave.jiang@intel.com>
 L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 S:	Supported
@@ -8064,6 +8076,9 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.txt
 
 LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
 M:	Dan Williams <dan.j.williams@intel.com>
+M:	Ross Zwisler <ross.zwisler@linux.intel.com>
+M:	Vishal Verma <vishal.l.verma@intel.com>
+M:	Dave Jiang <dave.jiang@intel.com>
 L:	linux-nvdimm@lists.01.org
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

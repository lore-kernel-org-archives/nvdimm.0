Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4DB55207DF2A4
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 10:35:16 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] nvdimm docs: remove reference to CONFIG_NFIT_TEST
Date: Thu,  5 Jul 2018 11:35:09 -0600
Message-Id: <20180705173509.10849-1-ross.zwisler@linux.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This symbol doesn't currently exist.  The instructions on how to compile &
load nfit_test are here:

https://github.com/pmem/ndctl

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 Documentation/nvdimm/nvdimm.txt | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/nvdimm/nvdimm.txt b/Documentation/nvdimm/nvdimm.txt
index e894de69915a..985091a86866 100644
--- a/Documentation/nvdimm/nvdimm.txt
+++ b/Documentation/nvdimm/nvdimm.txt
@@ -248,9 +248,8 @@ by a region device with a dynamically assigned id (REGION0 - REGION5).
     be contiguous in DPA-space.
 
     This bus is provided by the kernel under the device
-    /sys/devices/platform/nfit_test.0 when CONFIG_NFIT_TEST is enabled and
-    the nfit_test.ko module is loaded.  This not only test LIBNVDIMM but the
-    acpi_nfit.ko driver as well.
+    /sys/devices/platform/nfit_test.0 when the nfit_test.ko module is loaded.
+    This not only test LIBNVDIMM but the acpi_nfit.ko driver as well.
 
 
 LIBNVDIMM Kernel Device Model and LIBNDCTL Userspace API
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

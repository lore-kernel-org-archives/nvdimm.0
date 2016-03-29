Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id 85E881A1DF3
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 15:24:27 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: update minimum kernel for ARS tests
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Mar 2016 15:23:20 -0700
Message-ID: <20160329222320.31212.67532.stgit@dwillia2-desk3.jf.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

In 4.6 the kernel is updated to the new ACPI 6.1 definition of the ARS
command set.  The unit test for ARS commands expects these latest
definitions, so disable this test by default on older kernels.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 2dd1eb6fcb0a..0cab89208867 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -1847,7 +1847,7 @@ static int check_commands(struct ndctl_bus *bus, struct ndctl_dimm *dimm,
 	if (rc)
 		goto out;
 
-	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 3, 0)))
+	if (!ndctl_test_attempt(test, KERNEL_VERSION(4, 6, 0)))
 		goto out;
 
 	/* Check Bus commands */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

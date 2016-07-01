Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 770B91A1DFB
 for <linux-nvdimm@lists.01.org>; Fri,  1 Jul 2016 15:10:12 -0700 (PDT)
Subject: [ndctl PATCH] test: override current kernel version with
 environment variable
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 01 Jul 2016 15:08:53 -0700
Message-ID: <146741093296.25756.14218284344995187267.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For backport kernels where the functionality is more advanced than the base
kernel version implies, allow 'KVER' environment to override the results of
'uname -r'.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/core.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/test/core.c b/test/core.c
index b5703273fa76..c2d225d4921e 100644
--- a/test/core.c
+++ b/test/core.c
@@ -14,12 +14,16 @@ struct ndctl_test {
 
 static unsigned int get_system_kver(void)
 {
+	const char *kver = getenv("KVER");
 	struct utsname utsname;
 	int a, b, c;
 
-	uname(&utsname);
+	if (!kver) {
+		uname(&utsname);
+		kver = utsname.release;
+	}
 
-	if (sscanf(utsname.release, "%d.%d.%d", &a, &b, &c) != 3)
+	if (sscanf(kver, "%d.%d.%d", &a, &b, &c) != 3)
 		return LINUX_VERSION_CODE;
 
 	return KERNEL_VERSION(a,b,c);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

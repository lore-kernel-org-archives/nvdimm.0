Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 0696E1A1F02
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 12:51:15 -0700 (PDT)
Subject: [ndctl PATCH 7/7] ndctl: fix unchecked return value
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 25 Apr 2016 12:50:26 -0700
Message-ID: <146161382607.21779.2208336715925326189.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146161378966.21779.1219526957524644729.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Static analysis flags the sscanf() in get_system_kver() for return-value
checking. Fall back to the system kernel headers version.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/core.c b/test/core.c
index dba9c4c38ab1..b5703273fa76 100644
--- a/test/core.c
+++ b/test/core.c
@@ -19,7 +19,8 @@ static unsigned int get_system_kver(void)
 
 	uname(&utsname);
 
-	sscanf(utsname.release, "%d.%d.%d", &a, &b, &c);
+	if (sscanf(utsname.release, "%d.%d.%d", &a, &b, &c) != 3)
+		return LINUX_VERSION_CODE;
 
 	return KERNEL_VERSION(a,b,c);
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

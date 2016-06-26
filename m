Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 81CAA1A1E00
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:26:31 -0700 (PDT)
Subject: [ndctl PATCH 9/9] test, libndctl: kill some dead code
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:25:15 -0700
Message-ID: <146698351517.40541.8674344835909731999.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
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

check_namespaces() used to do some i/o testing, but that's long since
been replaced.  Clean up some straggling statements.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/libndctl.c |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/test/libndctl.c b/test/libndctl.c
index 947849d7176b..b03fc27a5f0b 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -1460,7 +1460,6 @@ static int check_namespaces(struct ndctl_region *region,
 	ndns_save = NULL;
 	for (i = 0; (namespace = namespaces[i]); i++) {
 		struct ndctl_namespace *ndns;
-		int fd = -1;
 		uuid_t uu;
 
 		snprintf(devname, sizeof(devname), "namespace%d.%d",
@@ -1651,8 +1650,6 @@ static int check_namespaces(struct ndctl_region *region,
 				break;
 			}
 		}
-		if (fd >= 0)
-			close(fd);
 		namespace->do_configure = 0;
 
 		__ndns_save = realloc(ndns_save,

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

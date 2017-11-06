Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3719202E5E52
 for <linux-nvdimm@lists.01.org>; Mon,  6 Nov 2017 15:14:32 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 1/3] libndctl: refactor returns in
 ndctl_bus_get_scrub_count
Date: Mon,  6 Nov 2017 16:16:08 -0700
Message-Id: <20171106231610.8271-1-vishal.l.verma@intel.com>
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

Static analysis warns about logically dead/unreachable code since all
options for 'rc' are accounted for. Make this section a bit more succinct,
while fixing both this warning as well as ensuring gcc doesn't warn about
reaching the end of a non-void function.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 4434846..e78a32c 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1086,13 +1086,7 @@ NDCTL_EXPORT unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus)
 		return UINT_MAX;
 
 	rc = sscanf(buf, "%u%c", &scrub_count, &in_progress);
-	if (rc < 0)
-		return UINT_MAX;
-	if (rc == 0) {
-		/* unable to read scrub count */
-		return UINT_MAX;
-	}
-	if (rc >= 1)
+	if (rc > 0)
 		return scrub_count;
 
 	return UINT_MAX;
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

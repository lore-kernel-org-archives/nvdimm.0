Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2842D211ADA52
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 14:15:13 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libndctl: ignore ENXIO in ndctl_namespace_delete
Date: Tue,  8 Jan 2019 15:15:10 -0700
Message-Id: <20190108221510.28553-1-vishal.l.verma@intel.com>
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

The kernel will return ENXIO and fail attempts to set the size of a
namespace that has already been deleted. When we are deleting a
namespace, we don't care that it has been previously destroyed, or is
in an uninitialized state.

Ignore the ENXIO from setting the size to zero in this case, and report
to the callers of this API that the deletion was successful.

This addresses github issue #73.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 0c3a35e..e82a08d 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -4303,7 +4303,12 @@ NDCTL_EXPORT int ndctl_namespace_delete(struct ndctl_namespace *ndns)
 	}
 
 	rc = namespace_set_size(ndns, 0);
-	if (rc)
+	/*
+	 * if the namespace has already been deleted, this will return
+	 * -ENXIO due to the uuid check in __size_store. We can safely
+	 *  ignore it in the case of writing a zero.
+	 */
+	if (rc && (rc != -ENXIO))
 		return rc;
 
 	region->namespaces_init = 0;
-- 
2.17.2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

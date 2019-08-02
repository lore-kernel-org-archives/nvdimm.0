Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6980221311C11
 for <linux-nvdimm@lists.01.org>; Fri,  2 Aug 2019 17:11:57 -0700 (PDT)
Subject: [ndctl PATCH v3 8/8] ndctl/namespace: Report ENOSPC when regions
 are full
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 02 Aug 2019 16:55:08 -0700
Message-ID: <156479010859.707590.12017196692329765020.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156479006271.707590.298793474092813749.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156479006271.707590.298793474092813749.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The create-namespace error message:

    failed to create namespace: Resource temporarily unavailable

...is misleading because the lack of capacity is permanent until the
user frees up space.

Trap EAGAIN and translate to ENOSPC in case the region capacity search
fails:

    failed to create namespace: No space left on device

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/namespace.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 5c457224cb13..89113f760bbf 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1415,6 +1415,15 @@ static int do_xaction_namespace(const char *namespace,
 		}
 	}
 
+	if (action == ACTION_CREATE && rc == -EAGAIN) {
+		/*
+		 * Namespace creation searched through all candidate
+		 * regions and all of them said "nope, I don't have
+		 * enough capacity", so report -ENOSPC
+		 */
+		rc = -ENOSPC;
+	}
+
 	return rc;
 }
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

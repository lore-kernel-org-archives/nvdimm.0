Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1F1EB21CAD998
 for <linux-nvdimm@lists.01.org>; Mon,  5 Aug 2019 16:46:08 -0700 (PDT)
Subject: [ndctl PATCH v4 7/7] ndctl/namespace: Report ENOSPC when regions
 are full
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 05 Aug 2019 16:29:20 -0700
Message-ID: <156504776008.847544.15426025945427673536.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <156504772175.847544.11368833704527657055.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156504772175.847544.11368833704527657055.stgit@dwillia2-desk3.amr.corp.intel.com>
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

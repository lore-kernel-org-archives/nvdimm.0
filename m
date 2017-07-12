Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 07CB821D0B65F
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 08:02:15 -0700 (PDT)
Date: Wed, 12 Jul 2017 08:04:01 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] nvdimm: Remove minimum size requirement
Message-ID: <20170712150401.GA12920@bombadil.infradead.org>
References: <20170710183248.2417-1-willy@infradead.org>
 <CAPcyv4ioWUmiHbaGVcpxuK-j0JrcGk-_VcpR6yQtQMUwcRTRcQ@mail.gmail.com>
 <20170710203012.GB22476@bombadil.infradead.org>
 <CAPcyv4h7udHTuf78-_iLid68yMhBqTy9=b7GupJn3ZBLJoAWJA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4h7udHTuf78-_iLid68yMhBqTy9=b7GupJn3ZBLJoAWJA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Cheng-mean Liu <soccerl@microsoft.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> You're right. It should return -ENODEV regardless, but the warning
> should be for non-zero too small namespaces.

OK, try this:

---- 8< ----

From: Matthew Wilcox <mawilcox@microsoft.com>
Date: Mon, 10 Jul 2017 14:26:59 -0400
Subject: [PATCH] nvdimm: Remove minimum size requirement

There was no need to have a minimum size of 4MB for NV-DIMMs; it was
just a sanity check.  Keep a check that it's at least one page in size
because we really can't add less than a page to the memory map.

Promote the print statement from 'debug' level to 'warning', since there
was no information for my colleague who stumbled over this problem while
attempting to add a 2MB chunk of memory.  There may be some zero-sized
devices on the list, and those are not warned about.

Truncate the resource_size_t to an int and print it using %d rather
than printing it in hex as a pointer to an address.  We know it's less
than PAGE_SIZE, so it'll fit in an int.

Reported-by: Cheng-mean Liu <soccerl@microsoft.com>
Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/nvdimm/namespace_devs.c | 7 ++++---
 include/uapi/linux/ndctl.h      | 4 ----
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 5f1c6756e57c..518c3507f67f 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1689,9 +1689,10 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 	}
 
 	size = nvdimm_namespace_capacity(ndns);
-	if (size < ND_MIN_NAMESPACE_SIZE) {
-		dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
-				&size, ND_MIN_NAMESPACE_SIZE);
+	if (size < PAGE_SIZE) {
+		if (size)
+			dev_warn(&ndns->dev, "%d too small must be at least %ld\n",
+					(int)size, PAGE_SIZE);
 		return ERR_PTR(-ENODEV);
 	}
 
diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 6d3c54264d8e..3ad1623bb585 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -299,10 +299,6 @@ enum nd_driver_flags {
 	ND_DRIVER_DAX_PMEM	  = 1 << ND_DEVICE_DAX_PMEM,
 };
 
-enum {
-	ND_MIN_NAMESPACE_SIZE = 0x00400000,
-};
-
 enum ars_masks {
 	ARS_STATUS_MASK = 0x0000FFFF,
 	ARS_EXT_STATUS_SHIFT = 16,
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

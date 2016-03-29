Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 5C6E81A1EED
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 11:29:17 -0700 (PDT)
Subject: [PATCH] libnvdimm, pfn: fix uuid validation
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Mar 2016 11:28:09 -0700
Message-ID: <20160329182809.13112.73824.stgit@dwillia2-desk3.jf.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

If we detect a namespace has a stale info block in the init path, we
should overwrite with the latest configuration.  In fact, we already
return -ENODEV when the parent uuid is invalid, the same should be done
for the 'self' uuid.  Otherwise we can get into a condition where
userspace is unable to reconfigure the pfn-device without directly /
manually invalidating the info block.

Cc: <stable@vger.kernel.org>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 254d3bc13f70..e071e214feba 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -376,7 +376,7 @@ int nd_pfn_validate(struct nd_pfn *nd_pfn)
 	} else {
 		/* from init we validate */
 		if (memcmp(nd_pfn->uuid, pfn_sb->uuid, 16) != 0)
-			return -EINVAL;
+			return -ENODEV;
 	}
 
 	if (nd_pfn->align > nvdimm_namespace_capacity(ndns)) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

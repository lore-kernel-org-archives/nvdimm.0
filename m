Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C6F1721F3C187
 for <linux-nvdimm@lists.01.org>; Mon,  9 Oct 2017 14:02:07 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH v3 3/4] libnvdimm, badrange: remove a WARN for list_empty
Date: Mon,  9 Oct 2017 15:03:28 -0600
Message-Id: <20171009210329.836-4-vishal.l.verma@intel.com>
In-Reply-To: <20171009210329.836-1-vishal.l.verma@intel.com>
References: <20171009210329.836-1-vishal.l.verma@intel.com>
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

Now that we're reusing the badrange functions for nfit_test, and that
exposes badrange injection/clearing to userspace via the DSM paths, it
is plausible that a user may call the clear DSM multiple times. Since it
is harmless to do so, we can remove the WARN in badrange_forget.

Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 drivers/nvdimm/badrange.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
index 0b67dcf..e068d72 100644
--- a/drivers/nvdimm/badrange.c
+++ b/drivers/nvdimm/badrange.c
@@ -114,7 +114,6 @@ void badrange_forget(struct badrange *badrange, phys_addr_t start,
 	struct badrange_entry *bre, *next;
 
 	spin_lock(&badrange->lock);
-	WARN_ON_ONCE(list_empty(badrange_list));
 
 	/*
 	 * [start, clr_end] is the badrange interval being cleared.
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

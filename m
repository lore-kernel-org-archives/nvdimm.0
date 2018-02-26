Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx143.netapp.com (mx143.netapp.com
 [IPv6:2620:10a:4005:8000:2306::c])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D7C7209574E2
 for <linux-nvdimm@lists.01.org>; Mon, 26 Feb 2018 08:48:26 -0800 (PST)
From: Boaz Harrosh <boazh@netapp.com>
Subject: [PATCH] dax: ->direct_access does not sleep anymore
Message-ID: <6a5a6353-2714-8eb6-2566-a4384a95db0b@netapp.com>
Date: Mon, 26 Feb 2018 18:50:35 +0200
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
To: Dan Williams <dan.j.williams@intel.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


In Patch:
	[7a862fb] brd: remove dax support

  Dan Williams has removed the only might_sleep
  implementation of ->direct_access.
  So we no longer need to check for it.

CC: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Boaz Harrosh <boazh@netapp.com>
---
 drivers/dax/super.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/dax/super.c b/drivers/dax/super.c
index 3ec8046..0a75550 100644
--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -236,12 +236,6 @@ long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
 {
 	long avail;
 
-	/*
-	 * The device driver is allowed to sleep, in order to make the
-	 * memory directly accessible.
-	 */
-	might_sleep();
-
 	if (!dax_dev)
 		return -EOPNOTSUPP;
 
-- 
2.5.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

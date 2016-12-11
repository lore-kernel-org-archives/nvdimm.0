Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6562F820DC
 for <linux-nvdimm@lists.01.org>; Sun, 11 Dec 2016 09:16:44 -0800 (PST)
Subject: [PATCH] libnvdimm, pfn: fix align attribute
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 11 Dec 2016 09:12:35 -0800
Message-ID: <148147635510.15804.6542455844975735279.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Fix the format specifier so that the attribute can be parsed correctly.
Currently it returns decimal 1000 for a 4096-byte alignment.

Cc: <stable@vger.kernel.org>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Fixes: 315c562536c4 ("libnvdimm, pfn: add 'align' attribute, default to HPAGE_SIZE")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pfn_devs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index cea8350fbc7e..a2ac9e641aa9 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -108,7 +108,7 @@ static ssize_t align_show(struct device *dev,
 {
 	struct nd_pfn *nd_pfn = to_nd_pfn_safe(dev);
 
-	return sprintf(buf, "%lx\n", nd_pfn->align);
+	return sprintf(buf, "%ld\n", nd_pfn->align);
 }
 
 static ssize_t __align_store(struct nd_pfn *nd_pfn, const char *buf)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

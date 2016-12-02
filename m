Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay112.isp.belgacom.be (mailrelay112.isp.belgacom.be
 [195.238.20.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C960781F60
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:20:39 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 3/8 linux-next] libnvdimm, namespace: move persistence warning
Date: Fri,  2 Dec 2016 20:20:36 +0100
Message-Id: <1480706436-21058-1-git-send-email-fabf@skynet.be>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: fabf@skynet.be, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

There's no need to warn on persistence yet as some validity tests
are on the way.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/nvdimm/pmem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 822a712..204912c 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -266,9 +266,6 @@ static int pmem_attach_disk(struct device *dev,
 	dev_set_drvdata(dev, pmem);
 	pmem->phys_addr = res->start;
 	pmem->size = resource_size(res);
-	if (nvdimm_has_flush(nd_region) < 0)
-		dev_warn(dev, "unable to guarantee persistence of writes due to unknown flushing capability of the memory region\n");
-
 	if (!devm_request_mem_region(dev, res->start, resource_size(res),
 				dev_name(dev))) {
 		dev_warn(dev, "could not reserve region %pR\n", res);
@@ -279,6 +276,9 @@ static int pmem_attach_disk(struct device *dev,
 	if (!q)
 		return -ENOMEM;
 
+	if (nvdimm_has_flush(nd_region) < 0)
+		dev_warn(dev, "unable to guarantee persistence of writes due to unknown flushing capability of the memory region\n");
+
 	pmem->pfn_flags = PFN_DEV;
 	if (is_nd_pfn(dev)) {
 		addr = devm_memremap_pages(dev, &pfn_res, &q->q_usage_counter,
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

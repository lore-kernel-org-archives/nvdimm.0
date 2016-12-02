Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay112.isp.belgacom.be (mailrelay112.isp.belgacom.be
 [195.238.20.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C50281F5C
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:20:01 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/8 linux-next] libnvdimm,
 namespace: update message level on smaller reservations
Date: Fri,  2 Dec 2016 20:19:57 +0100
Message-Id: <1480706397-20954-1-git-send-email-fabf@skynet.be>
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

kernel command lines like memmap=1M!512M gave no pmem outputs
without debugging.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/nvdimm/namespace_devs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index abe5c6b..b00045b 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1532,8 +1532,8 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 
 	size = nvdimm_namespace_capacity(ndns);
 	if (size < ND_MIN_NAMESPACE_SIZE) {
-		dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
-				&size, ND_MIN_NAMESPACE_SIZE);
+		dev_warn(&ndns->dev, "%pa, too small must be at least %#x\n",
+			 &size, ND_MIN_NAMESPACE_SIZE);
 		return ERR_PTR(-ENODEV);
 	}
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

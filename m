Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay112.isp.belgacom.be (mailrelay112.isp.belgacom.be
 [195.238.20.139])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B36981F5C
 for <linux-nvdimm@lists.01.org>; Fri,  2 Dec 2016 11:21:26 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 5/8 linux-next] libnvdimm: remove else after return in
 nsio_rw_bytes()
Date: Fri,  2 Dec 2016 20:21:19 +0100
Message-Id: <1480706479-21162-1-git-send-email-fabf@skynet.be>
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

else after return is not needed.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 drivers/nvdimm/claim.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index d5dc80c..c0c113e 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -238,11 +238,10 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 		if (unlikely(is_bad_pmem(&nsio->bb, offset / 512, sz_align)))
 			return -EIO;
 		return memcpy_from_pmem(buf, nsio->addr + offset, size);
-	} else {
-		memcpy_to_pmem(nsio->addr + offset, buf, size);
-		nvdimm_flush(to_nd_region(ndns->dev.parent));
 	}
 
+	memcpy_to_pmem(nsio->addr + offset, buf, size);
+	nvdimm_flush(to_nd_region(ndns->dev.parent));
 	return 0;
 }
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

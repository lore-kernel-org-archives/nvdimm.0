Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mailrelay104.isp.belgacom.be (mailrelay104.isp.belgacom.be
 [195.238.20.131])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A9EA81F74
 for <linux-nvdimm@lists.01.org>; Sat,  3 Dec 2016 10:53:41 -0800 (PST)
From: Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 1/3 libnvdimm-pending] libnvdimm: remove else after return
 in nsio_rw_bytes()
Date: Sat,  3 Dec 2016 19:53:32 +0100
Message-Id: <1480791212-21347-1-git-send-email-fabf@skynet.be>
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
V2: -applied on top of libnvdimm-pending

 drivers/nvdimm/claim.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/nvdimm/claim.c b/drivers/nvdimm/claim.c
index 4638b9e..75c36c3 100644
--- a/drivers/nvdimm/claim.c
+++ b/drivers/nvdimm/claim.c
@@ -242,29 +242,28 @@ static int nsio_rw_bytes(struct nd_namespace_common *ndns,
 		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align)))
 			return -EIO;
 		return memcpy_from_pmem(buf, nsio->addr + offset, size);
-	} else {
-
-		if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
-			if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
-				long cleared;
-
-				cleared = nvdimm_clear_poison(&ndns->dev,
-							      offset, size);
-				if (cleared != size) {
-					size = cleared;
-					rc = -EIO;
-				}
-
-				badblocks_clear(&nsio->bb, sector,
-						cleared >> 9);
-			} else
+	}
+
+	if (unlikely(is_bad_pmem(&nsio->bb, sector, sz_align))) {
+		if (IS_ALIGNED(offset, 512) && IS_ALIGNED(size, 512)) {
+			long cleared;
+
+			cleared = nvdimm_clear_poison(&ndns->dev,
+						      offset, size);
+			if (cleared != size) {
+				size = cleared;
 				rc = -EIO;
-		}
+			}
 
-		memcpy_to_pmem(nsio->addr + offset, buf, size);
-		nvdimm_flush(to_nd_region(ndns->dev.parent));
+			badblocks_clear(&nsio->bb, sector,
+					cleared >> 9);
+		} else
+			rc = -EIO;
 	}
 
+	memcpy_to_pmem(nsio->addr + offset, buf, size);
+	nvdimm_flush(to_nd_region(ndns->dev.parent));
+
 	return rc;
 }
 
-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

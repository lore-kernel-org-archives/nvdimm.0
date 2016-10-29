Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.polytechnique.org (mx1.polytechnique.org [129.104.30.34])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0C53581CCC
 for <linux-nvdimm@lists.01.org>; Sat, 29 Oct 2016 04:29:09 -0700 (PDT)
From: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Subject: [PATCH 1/1] nvdimm: use the right length of "pmem"
Date: Sat, 29 Oct 2016 13:28:52 +0200
Message-Id: <20161029112852.19975-1-nicolas.iooss_linux@m4x.org>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: Nicolas Iooss <nicolas.iooss_linux@m4x.org>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

In order to test that the name of a resource begins with "pmem", call
strncmp() with 4 as length instead of 3 to match the whole prefix.

Fixes: 16660eaea0cc ("libnvdimm, namespace: update label implementation
for multi-pmem")
Signed-off-by: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
---
 drivers/nvdimm/label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/label.c b/drivers/nvdimm/label.c
index fac7cabe8f56..dd615345699f 100644
--- a/drivers/nvdimm/label.c
+++ b/drivers/nvdimm/label.c
@@ -938,7 +938,7 @@ int nd_pmem_namespace_label_update(struct nd_region *nd_region,
 		}
 
 		for_each_dpa_resource(ndd, res)
-			if (strncmp(res->name, "pmem", 3) == 0)
+			if (strncmp(res->name, "pmem", 4) == 0)
 				count++;
 		WARN_ON_ONCE(!count);
 
-- 
2.10.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

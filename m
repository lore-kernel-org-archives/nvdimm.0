Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22962212377E1
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 12:08:45 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/4] ndctl/namespace.c: Fix a potential integer overflow
Date: Fri, 10 May 2019 13:08:39 -0600
Message-Id: <20190510190839.29637-5-vishal.l.verma@intel.com>
In-Reply-To: <20190510190839.29637-1-vishal.l.verma@intel.com>
References: <20190510190839.29637-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Static analysis warns that we may cause an integer overflow when
left-shifting bb->len in nstype_clear_badblocks(). While it is unlikely
to trigger this in real-world usage, since bb->len is limited by the
kernel, the fix is is a trivial cast, and it quells the warning, and
increases our robustness.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/namespace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 31e6ecd..58a9e3c 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1146,7 +1146,7 @@ static int nstype_clear_badblocks(struct ndctl_namespace *ndns,
 		unsigned long long bb_begin, bb_end, bb_len;
 
 		bb_begin = region_begin + (bb->offset << 9);
-		bb_len = bb->len << 9;
+		bb_len = (unsigned long long)bb->len << 9;
 		bb_end = bb_begin + bb_len - 1;
 
 		/* bb is not fully contained in the usable area */
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45B7B2034D8D5
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 14:56:57 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/3] ndctl, update: fix uninitialized variable warnings
Date: Wed, 21 Feb 2018 16:02:51 -0700
Message-Id: <20180221230252.16632-3-vishal.l.verma@intel.com>
In-Reply-To: <20180221230252.16632-1-vishal.l.verma@intel.com>
References: <20180221230252.16632-1-vishal.l.verma@intel.com>
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

In send_firmware, if the file size ('remain') were to be zero, 'rc'
would never get assigned. While this conditon would never be reached
because we have already checked the file size to be greater than zero,
initialize 'rc' anyway to silence the compiler warning.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/update.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/update.c b/ndctl/update.c
index 877d37f..71d95eb 100644
--- a/ndctl/update.c
+++ b/ndctl/update.c
@@ -208,7 +208,7 @@ static int send_firmware(struct update_context *uctx)
 {
 	struct ndctl_cmd *cmd = NULL;
 	ssize_t read;
-	int rc;
+	int rc = -ENXIO;
 	enum ND_FW_STATUS status;
 	struct fw_info *fw = &uctx->dimm_fw;
 	uint32_t copied = 0, len, remain;
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

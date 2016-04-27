Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t4623.austin.hp.com (g2t4623.austin.hp.com [15.73.212.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B05A71A1F2E
 for <linux-nvdimm@lists.01.org>; Wed, 27 Apr 2016 15:46:54 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [RFC v10 7/7] nvmdimm: ND_CMD_CALL
Date: Wed, 27 Apr 2016 16:46:19 -0600
Message-Id: <6c0b2ea4da2779413d519f29a6441c55279fd18a.1461793650.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1461793650.git.jerry.hoemann@hpe.com>
References: <cover.1461793650.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1461793650.git.jerry.hoemann@hpe.com>
References: <cover.1461793650.git.jerry.hoemann@hpe.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Increase value of ND_CMD_CALL to delay need to remap ioctl
numbers to underpinning DSM spec.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/uapi/linux/ndctl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/ndctl.h b/include/uapi/linux/ndctl.h
index 9214af7..2ba1e33 100644
--- a/include/uapi/linux/ndctl.h
+++ b/include/uapi/linux/ndctl.h
@@ -125,7 +125,7 @@ enum {
 	ND_CMD_VENDOR_EFFECT_LOG_SIZE = 7,
 	ND_CMD_VENDOR_EFFECT_LOG = 8,
 	ND_CMD_VENDOR = 9,
-	ND_CMD_CALL = 10,
+	ND_CMD_CALL = 30,
 };
 
 enum {
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

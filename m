Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t6223.austin.hp.com (g1t6223.austin.hp.com [15.73.96.124])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C158E1A1F2F
 for <linux-nvdimm@lists.01.org>; Tue, 15 Mar 2016 14:32:40 -0700 (PDT)
From: Jerry Hoemann <jerry.hoemann@hpe.com>
Subject: [PATCH v7 3/7] nvdimm: Increase max envelope size for IOCTL
Date: Tue, 15 Mar 2016 15:32:12 -0600
Message-Id: <def23dbf74ee08faa28b8526a449d327aa228f43.1458076114.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458076114.git.jerry.hoemann@hpe.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
In-Reply-To: <cover.1458076114.git.jerry.hoemann@hpe.com>
References: <cover.1458076114.git.jerry.hoemann@hpe.com>
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

In __nd_ioctl must first read in the fixed sized portion of an ioctl
so that it can then determine the size of the variable part.

Prepare for ND_CMD_CALL_DSM calls which have larger fixed portion
wrapper.

Signed-off-by: Jerry Hoemann <jerry.hoemann@hpe.com>
---
 include/linux/libnvdimm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index 833867b..af31d1c 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -27,7 +27,7 @@ enum {
 	/* need to set a limit somewhere, but yes, this is likely overkill */
 	ND_IOCTL_MAX_BUFLEN = SZ_4M,
 	ND_CMD_MAX_ELEM = 5,
-	ND_CMD_MAX_ENVELOPE = 16,
+	ND_CMD_MAX_ENVELOPE = 256,
 	ND_MAX_MAPPINGS = 32,
 
 	/* region flag indicating to direct-map persistent memory by default */
-- 
1.7.11.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

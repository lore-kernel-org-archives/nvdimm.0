Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com
 [IPv6:2607:f8b0:4864:20::744])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 66513211E95B2
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:39 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b74so2452349qkg.9
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:39 -0700 (PDT)
From: Dexuan Cui <dexuan.cui@gmail.com>
Subject: [ndctl PATCH v3 3/5] ndctl,
 monitor: Don't require the support of ND_CMD_SMART_THRESHOLD
Date: Sat, 23 Mar 2019 04:20:27 +0000
Message-Id: <20190323042028.4310-4-decui@microsoft.com>
In-Reply-To: <20190323042028.4310-1-decui@microsoft.com>
References: <20190323042028.4310-1-decui@microsoft.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, dave.jiang@intel.com, linux-nvdimm@lists.01.org, mikelley@microsoft.com
Cc: qi.fuli@fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

When a NVDIMM doesn't support ND_CMD_SMART_THRESHOLD, it may support
ND_CMD_SMART or a variant of ND_CMD_SMART. Allow such a NVDIMM to work
with "ndctl monitor".

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 ndctl/monitor.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/ndctl/monitor.c b/ndctl/monitor.c
index 43b2abe..346a6df 100644
--- a/ndctl/monitor.c
+++ b/ndctl/monitor.c
@@ -275,17 +275,13 @@ static void filter_dimm(struct ndctl_dimm *dimm, struct util_filter_ctx *fctx)
 		err(&monitor, "%s: no smart support\n", name);
 		return;
 	}
-	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD)) {
-		err(&monitor, "%s: no smart threshold support\n", name);
-		return;
-	}
 
-	if (!ndctl_dimm_is_flag_supported(dimm, ND_SMART_ALARM_VALID)) {
+	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_SMART_THRESHOLD)) {
+		dbg(&monitor, "%s: no smart threshold support\n", name);
+	} else if (!ndctl_dimm_is_flag_supported(dimm, ND_SMART_ALARM_VALID)) {
 		err(&monitor, "%s: smart alarm invalid\n", name);
 		return;
-	}
-
-	if (enable_dimm_supported_threshold_alarms(dimm)) {
+	} else if (enable_dimm_supported_threshold_alarms(dimm)) {
 		err(&monitor, "%s: enable supported threshold alarms failed\n", name);
 		return;
 	}
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

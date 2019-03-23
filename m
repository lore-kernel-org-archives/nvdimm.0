Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com
 [IPv6:2607:f8b0:4864:20::844])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D3F2211E9FA3
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:41 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id t28so4881358qte.6
 for <linux-nvdimm@lists.01.org>; Fri, 22 Mar 2019 21:20:41 -0700 (PDT)
From: Dexuan Cui <dexuan.cui@gmail.com>
Subject: [ndctl PATCH v3 4/5] libndctl: Add a new dimm-op cmd_is_supported()
Date: Sat, 23 Mar 2019 04:20:28 +0000
Message-Id: <20190323042028.4310-5-decui@microsoft.com>
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

A NVDIMM family may need to report that it supports a command, even if
the command is not set in dimm->cmd_mask, e.g. a non-NVDIMM_FAMILY_INTEL
famimy may support ND_CMD_SMART or some kind of variant of ND_CMD_SMART,
while the kernel only sets ND_CMD_SMART in the nvdimm->cmd_mask for
NVDIMM_FAMILY_INTEL.

Signed-off-by: Dexuan Cui <decui@microsoft.com>
---
 ndctl/lib/libndctl.c | 5 +++++
 ndctl/lib/private.h  | 1 +
 2 files changed, 6 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 24b8ad3..4acfb03 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1769,6 +1769,11 @@ NDCTL_EXPORT int ndctl_dimm_failed_map(struct ndctl_dimm *dimm)
 NDCTL_EXPORT int ndctl_dimm_is_cmd_supported(struct ndctl_dimm *dimm,
 		int cmd)
 {
+	struct ndctl_dimm_ops *ops = dimm->ops;
+
+	if (ops && ops->cmd_is_supported)
+		return ops->cmd_is_supported(dimm, cmd);
+
 	return !!(dimm->cmd_mask & (1ULL << cmd));
 }
 
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index a9d35c5..2ddc1d2 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -292,6 +292,7 @@ struct ndctl_bb {
 
 struct ndctl_dimm_ops {
 	const char *(*cmd_desc)(int);
+	bool (*cmd_is_supported)(struct ndctl_dimm *, int);
 	struct ndctl_cmd *(*new_smart)(struct ndctl_dimm *);
 	unsigned int (*smart_get_flags)(struct ndctl_cmd *);
 	unsigned int (*smart_get_health)(struct ndctl_cmd *);
-- 
2.19.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

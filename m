Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C1B8F7B
	for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 22:38:39 +0000 (UTC)
Received: by mail-qt1-f181.google.com with SMTP id z6so2106620qtv.5
        for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 14:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zGuXVVPN/m5K4FKkj7oASxab4A65Q5i9aQDCiJUiKXI=;
        b=YHK+/jfYarj5IgKRdIloHToCkh58W0gvE6RUx+RZb6x7ws/VbTmTI7/+dGFk8+C0X0
         o4nFwiCyZuZtadRs+CjtQqIjMHk1++zdFofN5ZAKHCCISznVAT6XmOZB8yKm20HcD4JL
         6f//uHMtvCsKCxKAZx52Etrx0PehRKfBo0HuAp7FUt1ZI5JMc4NEQKusGt8c+KPV64EC
         MPhq4YTEH1vKIOs5eg2NVI6hanREz7yUaxRgAHW3XAuT2hIR5d5Lthttd8BkaSJFlHKF
         /cGGFV1wklM6i0DmuE3AuIaMezIcSffAF6If857U2AZte01+BQ5cJnDlZHTd9Ksil+tR
         5KSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zGuXVVPN/m5K4FKkj7oASxab4A65Q5i9aQDCiJUiKXI=;
        b=d9kUYSQDBSVU8MKpqrXeaT/vR8wLMFranIf5cyMxuGhNGVaqpKcqilMdj7IPwQZHGJ
         jkpSXjwlMOy40D1sST70u7/fNMGclhwVaGCydylR4xp7TPKvf9EfOzvPIe3qtJLOuaKi
         nwgyopPk4XrXp7qaxy2sitDLRdYsYCeJmK5MrvI/IUe1c27G7oD6xG4U4xZSqyOn2xry
         zZfeM4VYtSmLUc4EeaKCk7VCCU8h46AYEuMW0Gkjm18tusIC3IXA2/yLgDVEcOLY6Evi
         l0c3VqCgQPZbm/pFqECdcHb2ujSboNLXJVGMkJ7QvQdjD+g/2hLmSZBlDkK52rFiqa3P
         bS6w==
X-Gm-Message-State: ANoB5pkjV0d68HX5AKYFCTDf0Fwmb1cTPVGCr0P1RawDFMpUoA9cMrtO
	N77f/Lm9+B1mkMKOo0HdkzSZyYzIBcbIntqLdNJX4sjwm49g3oOEt/se+ygQZo+ZTvruJZMv561
	M2Ai/jE9f+Y0b9+pCacLth/THlcRl+HW64Wv9d68kuoeQrzYc4KZWsFh4GQdlhkXong==
X-Google-Smtp-Source: AA0mqf5KqmG0Sq88qSj7/BPLyPU0YvMbKZ5JLdLGt2SfuM7/sVXNwkkldV0BDiEzOxULloqT1yDoxg==
X-Received: by 2002:ac8:4908:0:b0:3a5:faa7:35e7 with SMTP id e8-20020ac84908000000b003a5faa735e7mr4366879qtq.66.1668724718629;
        Thu, 17 Nov 2022 14:38:38 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id do52-20020a05620a2b3400b006fba0a389a4sm1272237qkb.88.2022.11.17.14.38.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 14:38:38 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH 1/2 v2] libndctl/msft: Cleanup the code
Date: Thu, 17 Nov 2022 17:37:49 -0500
Message-Id: <20221117223749.6783-1-mav@ixsystems.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clean up the code, making it more uniform with others and
allowing more methods to be implemented later.

Signed-off-by: Alexander Motin <mav@ixsystems.com>
---
 ndctl/lib/msft.c | 58 ++++++++++++++++++++++++++++++++++++++----------
 ndctl/lib/msft.h | 13 ++++-------
 2 files changed, 50 insertions(+), 21 deletions(-)

diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index 3112799..efc7fe1 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -2,6 +2,7 @@
 // Copyright (C) 2016-2017 Dell, Inc.
 // Copyright (C) 2016 Hewlett Packard Enterprise Development LP
 // Copyright (C) 2016-2020, Intel Corporation.
+/* Copyright (C) 2022 iXsystems, Inc. */
 #include <stdlib.h>
 #include <limits.h>
 #include <util/log.h>
@@ -12,12 +13,39 @@
 #define CMD_MSFT(_c) ((_c)->msft)
 #define CMD_MSFT_SMART(_c) (CMD_MSFT(_c)->u.smart.data)
 
+static const char *msft_cmd_desc(int fn)
+{
+	static const char * const descs[] = {
+		[NDN_MSFT_CMD_CHEALTH] = "critical_health",
+		[NDN_MSFT_CMD_NHEALTH] = "nvdimm_health",
+		[NDN_MSFT_CMD_EHEALTH] = "es_health",
+	};
+	const char *desc;
+
+	if (fn >= (int) ARRAY_SIZE(descs))
+		return "unknown";
+	desc = descs[fn];
+	if (!desc)
+		return "unknown";
+	return desc;
+}
+
+static bool msft_cmd_is_supported(struct ndctl_dimm *dimm, int cmd)
+{
+	/* Handle this separately to support monitor mode */
+	if (cmd == ND_CMD_SMART)
+		return true;
+
+	return !!(dimm->cmd_mask & (1ULL << cmd));
+}
+
 static u32 msft_get_firmware_status(struct ndctl_cmd *cmd)
 {
 	return cmd->msft->u.smart.status;
 }
 
-static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+static struct ndctl_cmd *alloc_msft_cmd(struct ndctl_dimm *dimm,
+		unsigned int func, size_t in_size, size_t out_size)
 {
 	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
 	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
@@ -30,12 +58,12 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 		return NULL;
 	}
 
-	if (test_dimm_dsm(dimm, NDN_MSFT_CMD_SMART) == DIMM_DSM_UNSUPPORTED) {
+	if (test_dimm_dsm(dimm, func) == DIMM_DSM_UNSUPPORTED) {
 		dbg(ctx, "unsupported function\n");
 		return NULL;
 	}
 
-	size = sizeof(*cmd) + sizeof(struct ndn_pkg_msft);
+	size = sizeof(*cmd) + sizeof(struct nd_cmd_pkg) + in_size + out_size;
 	cmd = calloc(1, size);
 	if (!cmd)
 		return NULL;
@@ -45,25 +73,30 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 	cmd->type = ND_CMD_CALL;
 	cmd->size = size;
 	cmd->status = 1;
+	cmd->get_firmware_status = msft_get_firmware_status;
 
 	msft = CMD_MSFT(cmd);
 	msft->gen.nd_family = NVDIMM_FAMILY_MSFT;
-	msft->gen.nd_command = NDN_MSFT_CMD_SMART;
+	msft->gen.nd_command = func;
 	msft->gen.nd_fw_size = 0;
-	msft->gen.nd_size_in = offsetof(struct ndn_msft_smart, status);
-	msft->gen.nd_size_out = sizeof(msft->u.smart);
+	msft->gen.nd_size_in = in_size;
+	msft->gen.nd_size_out = out_size;
 	msft->u.smart.status = 0;
-	cmd->get_firmware_status = msft_get_firmware_status;
 
 	return cmd;
 }
 
+static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	return (alloc_msft_cmd(dimm, NDN_MSFT_CMD_NHEALTH,
+			0, sizeof(struct ndn_msft_smart)));
+}
+
 static int msft_smart_valid(struct ndctl_cmd *cmd)
 {
 	if (cmd->type != ND_CMD_CALL ||
-	    cmd->size != sizeof(*cmd) + sizeof(struct ndn_pkg_msft) ||
 	    CMD_MSFT(cmd)->gen.nd_family != NVDIMM_FAMILY_MSFT ||
-	    CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_SMART ||
+	    CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_NHEALTH ||
 	    cmd->status != 0)
 		return cmd->status < 0 ? cmd->status : -EINVAL;
 	return 0;
@@ -80,9 +113,8 @@ static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 	}
 
 	/* below health data can be retrieved via MSFT _DSM function 11 */
-	return NDN_MSFT_SMART_HEALTH_VALID |
-		NDN_MSFT_SMART_TEMP_VALID |
-		NDN_MSFT_SMART_USED_VALID;
+	return ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID |
+	    ND_SMART_USED_VALID;
 }
 
 static unsigned int num_set_bit_health(__u16 num)
@@ -171,6 +203,8 @@ static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
 }
 
 struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
+	.cmd_desc = msft_cmd_desc,
+	.cmd_is_supported = msft_cmd_is_supported,
 	.new_smart = msft_dimm_cmd_new_smart,
 	.smart_get_flags = msft_cmd_smart_get_flags,
 	.smart_get_health = msft_cmd_smart_get_health,
diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
index 978cc11..8d246a5 100644
--- a/ndctl/lib/msft.h
+++ b/ndctl/lib/msft.h
@@ -2,21 +2,16 @@
 /* Copyright (C) 2016-2017 Dell, Inc. */
 /* Copyright (C) 2016 Hewlett Packard Enterprise Development LP */
 /* Copyright (C) 2014-2020, Intel Corporation. */
+/* Copyright (C) 2022 iXsystems, Inc. */
 #ifndef __NDCTL_MSFT_H__
 #define __NDCTL_MSFT_H__
 
 enum {
-	NDN_MSFT_CMD_QUERY = 0,
-
-	/* non-root commands */
-	NDN_MSFT_CMD_SMART = 11,
+	NDN_MSFT_CMD_CHEALTH = 10,
+	NDN_MSFT_CMD_NHEALTH = 11,
+	NDN_MSFT_CMD_EHEALTH = 12,
 };
 
-/* NDN_MSFT_CMD_SMART */
-#define NDN_MSFT_SMART_HEALTH_VALID	ND_SMART_HEALTH_VALID
-#define NDN_MSFT_SMART_TEMP_VALID	ND_SMART_TEMP_VALID
-#define NDN_MSFT_SMART_USED_VALID	ND_SMART_USED_VALID
-
 /*
  * This is actually function 11 data,
  * This is the closest I can find to match smart
-- 
2.30.2


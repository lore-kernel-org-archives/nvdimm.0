Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4473D290A
	for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 21:13:03 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id p18so2166903qkg.2
        for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 13:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Q/xWMa0IQsRo9ujWqq1eV0n1/KriKTafnN8Cj/TBPr8=;
        b=LTgSOGc4Hs0KWHefJ8srzd6lb6YY18tqZ4DxmqHKXcbcLjgARL7KdGbyloRW7j2R4i
         mwe6PbKzo0dYvvIWM39rAuvatEVKt9IAA5WWMDza1B/zfcO06lk1SvvJjFX4Q6qrmOZs
         YBF3bwdLwae2jb3lbpysx6Bl9NKwiSlUkb8Vkge0J5A6P1WA0e/SszwBLWKYzzAYoURr
         wCbKrLwJofAozPqoG9PEVoFIgIKW/XVpa8y+RG0JRwk6Hq5od/vQtxyFQHdsDamVacqj
         Y7ekSCLke9znGCnpJy0hDEOLz3jFnIjMOjQuI0GswMeHLRI5P5TwfgVHPxI8KWRqHU7p
         0Vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q/xWMa0IQsRo9ujWqq1eV0n1/KriKTafnN8Cj/TBPr8=;
        b=EL61iu74OFOmVoibCBGi5BtCNu9qcKt7XFnrbbuEsBOEbBrQetBJNASEsBFwybmLG3
         e84tqqWn3OSnVphv5r3KyIALVR526hvZQC+COetSHkx4ldpXmFoXMMYrP7HInuuyJqc2
         9sOSv05GVaqz3GcrlWH/jweudFMBtKyVV4Ciqi0x17vKfwlIB/mQTQeNmCRw8aS8Ng6Y
         HiFZ1bqpfMfQyxd8XL33VrDZa7F0dNUXJcOZ7/1cq8gRc/g/VUvJt8Gmacp20ABDDlNE
         GyzQY4aG9hiSV96+8bH701Api7Zl4PQZpJDKSziSFGYuEJz7ijtzAdcFQIqB2t8dWUtX
         3UwA==
X-Gm-Message-State: ANoB5pkbD/fNPO5s4eNrh54AuyBJtwWtU3JIlG/9wnoUgP2jRv/jztdV
	UPOAIHACtkxjijgxJG0WgMpAqo/FCW8cotb3EI3nHBIAHb9N02YUwdrurPVL+5w/oaPBJtN9Ytm
	MfM1KuBxGsFPZHOuusEywHDCaT9d1z4HhR5ObNHB8J61m+NX00Sk6MuVw7dEEqkIlpg==
X-Google-Smtp-Source: AA0mqf4S6wBaWwBgnb40svHkfTD7inlZQt8xYHM/r2OLRa72xZdSFw7g9BA8L1c4tyzGbozSGr4urQ==
X-Received: by 2002:a05:620a:6011:b0:6e8:1fa:13e9 with SMTP id dw17-20020a05620a601100b006e801fa13e9mr3398506qkb.393.1668719581831;
        Thu, 17 Nov 2022 13:13:01 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id bb22-20020a05622a1b1600b0039c37a7914csm946462qtb.23.2022.11.17.13.13.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 13:13:01 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH] libndctl/msft: Improve "smart" state reporting
Date: Thu, 17 Nov 2022 16:09:36 -0500
Message-Id: <20221117210935.5717-1-mav@ixsystems.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Previous code reported "smart" state based on number of bits
set in the module health field.  But actually any single bit
set there already means critical failure.  Rework the logic
according to specification, properly reporting non-critical
state in case of warning threshold reached, critical in case
of any module health bit set or error threshold reached and
fatal if NVDIMM exhausted its life time.  In attempt to
report the cause of failure in absence of better methods,
report reached thresholds as more or less matching alarms.

While there clean up the code, making it more uniform with
others and allowing more methods to be implemented later.

Signed-off-by: Alexander Motin <mav@ixsystems.com>
---
 ndctl/lib/msft.c | 111 ++++++++++++++++++++++++++++++++---------------
 ndctl/lib/msft.h |  13 ++----
 2 files changed, 79 insertions(+), 45 deletions(-)

diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index 3112799..8f66c97 100644
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
@@ -80,28 +113,33 @@ static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 	}
 
 	/* below health data can be retrieved via MSFT _DSM function 11 */
-	return NDN_MSFT_SMART_HEALTH_VALID |
-		NDN_MSFT_SMART_TEMP_VALID |
-		NDN_MSFT_SMART_USED_VALID;
+	return ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID |
+	    ND_SMART_USED_VALID | ND_SMART_ALARM_VALID;
 }
 
-static unsigned int num_set_bit_health(__u16 num)
+static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
 {
-	int i;
-	__u16 n = num & 0x7FFF;
-	unsigned int count = 0;
+	unsigned int health = 0;
+	int rc;
 
-	for (i = 0; i < 15; i++)
-		if (!!(n & (1 << i)))
-			count++;
+	rc = msft_smart_valid(cmd);
+	if (rc < 0) {
+		errno = -rc;
+		return UINT_MAX;
+	}
 
-	return count;
+	if (CMD_MSFT_SMART(cmd)->nvm_lifetime == 0)
+		health |= ND_SMART_FATAL_HEALTH;
+	if (CMD_MSFT_SMART(cmd)->health != 0 ||
+	    CMD_MSFT_SMART(cmd)->err_thresh_stat != 0)
+		health |= ND_SMART_CRITICAL_HEALTH;
+	if (CMD_MSFT_SMART(cmd)->warn_thresh_stat != 0)
+		health |= ND_SMART_NON_CRITICAL_HEALTH;
+	return health;
 }
 
-static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
+static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
 {
-	unsigned int health;
-	unsigned int num;
 	int rc;
 
 	rc = msft_smart_valid(cmd);
@@ -110,21 +148,13 @@ static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
 		return UINT_MAX;
 	}
 
-	num = num_set_bit_health(CMD_MSFT_SMART(cmd)->health);
-	if (num == 0)
-		health = 0;
-	else if (num < 2)
-		health = ND_SMART_NON_CRITICAL_HEALTH;
-	else if (num < 3)
-		health = ND_SMART_CRITICAL_HEALTH;
-	else
-		health = ND_SMART_FATAL_HEALTH;
-
-	return health;
+	return CMD_MSFT_SMART(cmd)->temp * 16;
 }
 
-static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
+static unsigned int msft_cmd_smart_get_alarm_flags(struct ndctl_cmd *cmd)
 {
+	__u8 stat;
+	unsigned int flags = 0;
 	int rc;
 
 	rc = msft_smart_valid(cmd);
@@ -133,7 +163,13 @@ static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
 		return UINT_MAX;
 	}
 
-	return CMD_MSFT_SMART(cmd)->temp * 16;
+	stat = CMD_MSFT_SMART(cmd)->err_thresh_stat |
+	    CMD_MSFT_SMART(cmd)->warn_thresh_stat;
+	if (stat & 3) /* NVM_LIFETIME/ES_LIFETIME */
+		flags |= ND_SMART_SPARE_TRIP;
+	if (stat & 4) /* ES_TEMP */
+		flags |= ND_SMART_CTEMP_TRIP;
+	return flags;
 }
 
 static unsigned int msft_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
@@ -171,10 +207,13 @@ static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
 }
 
 struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
+	.cmd_desc = msft_cmd_desc,
+	.cmd_is_supported = msft_cmd_is_supported,
 	.new_smart = msft_dimm_cmd_new_smart,
 	.smart_get_flags = msft_cmd_smart_get_flags,
 	.smart_get_health = msft_cmd_smart_get_health,
 	.smart_get_media_temperature = msft_cmd_smart_get_media_temperature,
+	.smart_get_alarm_flags = msft_cmd_smart_get_alarm_flags,
 	.smart_get_life_used = msft_cmd_smart_get_life_used,
 	.xlat_firmware_status = msft_cmd_xlat_firmware_status,
 };
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


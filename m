Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84CBDAD4A
	for <nvdimm@lists.linux.dev>; Fri, 13 Jan 2023 17:28:59 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id a25so12444498qto.10
        for <nvdimm@lists.linux.dev>; Fri, 13 Jan 2023 09:28:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=quj/d6YhK1xwyQgQrm9ayPJfpa/2mWRFvcRY9gifr/k=;
        b=KVZsY/gbUCwANvUMfIz/8lkQD5FmMpxCFDID3nOIrOxmuej9L58TkXFvpNkXVS35De
         wBdaT16+f7RSCMJdbxLdNTrb+CyWZGs3KGOCc+9m1AUvKVqBmaRWAqi3VIddhZax9UlG
         YKja5rMDsps8Gbd1U4k+ulvX5vjIcarpbGDWIzDCWWgwkbXwUJfHLRY0Sav54A2v0VTK
         ZcmOwWOXouC/QqH/syeJIiBY7R7nKEr2Li9DYdXLXkP/4wpk9YFqzeh5spqBxKnRBPkB
         TinvndcI2ZZB/fwaNVAF6DL/NURInyUTvCEItwKwE4FAEJ+ZFXh+4F8AlJSjUJ7buZI0
         vicA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=quj/d6YhK1xwyQgQrm9ayPJfpa/2mWRFvcRY9gifr/k=;
        b=wFVF4PYTST4ouzJW/VAWGDaSj5EpUmq3B3J1eiYQmWT1H53XAKXmLcK1QH9nkELMN0
         l6ArM5WD4et2FAwwdO+VxgFUdearDoBIpDnoZ9pD7KNNs3MNbEAAZGTinHQmBA/QabsZ
         mAryXu5z71nsPg1AZXF8lHdimBXr8VxI4mfiWC4JJ9MbKQiebijTZm8k7fj8zPs0MiAj
         nsGFu5F2TYmsFPSB/M7kcNhSCc0SeDjtinl+rZLUWKUDGWaFxlNm7qcy1k+uZwuPv1Q2
         YJQi7MqxO19T499+DywgQW6vJPf2IsIDb9YfuWtU8LB8Z/e1ooIcrpfHvIIsiXclQrqh
         p2iA==
X-Gm-Message-State: AFqh2kqb0Szjd064CCT6opAVzX8PjSjGpujEo+viwRV7zLMOHUzKqXmN
	X/v8LfY+c8IKbXaFjcTTygMbLmvBrwaSlroYXkLT8nqaHVDNBHxnnDHw2PsIME3WaPo3YrFPytd
	NMBOzFugjoeZw6SWWr+xjVX9WzCeWUXr5ABONRSteaBXeh+lq7D6+58+vqa1Bzs4rVi9X
X-Google-Smtp-Source: AMrXdXuUbK0rpPehJGWks0A/jjy/V80x+ZinlFqR8pTieaLchCfSTqcBMgWMM5EFHofmDZGapuJs8Q==
X-Received: by 2002:ac8:67d8:0:b0:3ae:1ef:16d8 with SMTP id r24-20020ac867d8000000b003ae01ef16d8mr24863637qtp.2.1673630938058;
        Fri, 13 Jan 2023 09:28:58 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id t34-20020a05622a182200b003a527d29a41sm10817157qtc.75.2023.01.13.09.28.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 09:28:57 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Lijun Pan <Lijun.Pan@dell.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH 1/2 v2 RESEND] libndctl/msft: Cleanup the code
Date: Fri, 13 Jan 2023 12:27:32 -0500
Message-Id: <20230113172732.1122643-1-mav@ixsystems.com>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clean up the code, making it more uniform with others and
allowing more methods to be implemented later:
 - remove nonsense NDN_MSFT_CMD_SMART definition, replacing it
with real commands, primarity NDN_MSFT_CMD_NHEALTH;
 - allow sending arbitrary commands and add their descriptions;
 - add custom cmd_is_supported method to allow monitor mode.

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


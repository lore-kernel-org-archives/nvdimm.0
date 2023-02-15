Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A749E7B
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 16:51:27 +0000 (UTC)
Received: by mail-qv1-f45.google.com with SMTP id l4so6426923qvh.11
        for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 08:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=STW69iuKspho13um/rsdKY6jzS6j0PjXfQUTKtGfNHQ=;
        b=emuFqyWs2SEwZVrgtb7jFOEvpHNiEWlYhvz1f8/SRrCajbnqQJUIgjrJIuaqhBOtXQ
         IDTEwA8C9caxee9Zw3+hH6BqDZ2JGQYgoWdjJza+bFcTD63qgQvcfOcLqN+7jhuKA1FU
         UpFMlNujASMxU3k+IXs9WIclt5bUv4DNhQqP+gGj/3MSGmfX56v9dENgETnmlMwtR92D
         JNbtYKavrNH2mWGBntAFIsfgZYNN0Gd9iwWmauISlzfsWXwJWUC4WI0UY1PVYjr9EU2s
         50BxdSQtbtTzH8IgYoxX6+zxMFWZTzW9oe0TBgJq2AJC+u5/13LYQ4bpLZhuevepyEim
         6AtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=STW69iuKspho13um/rsdKY6jzS6j0PjXfQUTKtGfNHQ=;
        b=VaomhWOKqg1tRq6+3m0YyQ2sXlkpcHC0484huNh1VHxaEaoW6gs2gVxR9H4bDUEi5J
         1jxbY0WWyCKOKXk7G1jVoshXBGSns1LQ/cOJxNdCVONtoqjPNBC+jAc5wiyNJyOtEQ/N
         SrFlw/KwAQm3eQ8XH4jMJilp+Ofog8xzZUks2v8wKEP+vOcWOuL9gs9Z6fmi9kfh9fTV
         4KWpzHt52E57jIy8SziyLkxAQ6LadiTV/GxTUQ1djilpsZKQPUz0OTxStWTWiqHQn2Lm
         4xnVckgrnES3q/+aXQHQC7jdPp2blGf6RC/DzxkIneG1OJ7VS3ocE07Ea3R+tTfvaRAa
         vV+w==
X-Gm-Message-State: AO0yUKWvH17hUh6+FOqZzhs0N1zUixl99h9YN2mWkRs9NP+fqVydBDXI
	norin01Waz/YrnKs/ovGqzdQOJ2FFnzwo8wY3elotYdmYUUeSCxOZCn39WJIO45rV1Nase7WGvD
	9xl3AyE2So92BHP+hBNRjH7mPuYwR/bCPS8LYmbYA9vXq0WzbHo5T8lIV1Ckbtlh+Vebp
X-Google-Smtp-Source: AK7set9zA6V7/ryZfapEPUsBszDII0WZ8vQ3IGhAwKXmyAjd2UiKRRbhQTI99dW/hzqM6xYXv1Td2g==
X-Received: by 2002:a05:6214:ac6:b0:56e:b6de:e782 with SMTP id g6-20020a0562140ac600b0056eb6dee782mr5436818qvi.29.1676479886164;
        Wed, 15 Feb 2023 08:51:26 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id y10-20020ac8128a000000b003b68ea3d5c8sm13353529qti.41.2023.02.15.08.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 08:51:25 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH 2/4 v3] libndctl/msft: Replace nonsense NDN_MSFT_CMD_SMART command
Date: Wed, 15 Feb 2023 11:49:30 -0500
Message-Id: <20230215164930.707170-2-mav@ixsystems.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230215164930.707170-1-mav@ixsystems.com>
References: <20230215164930.707170-1-mav@ixsystems.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no NDN_MSFT_CMD_SMART command.  There are 3 relevant ones,
reporting different aspects of the module health.  Define those and
use NDN_MSFT_CMD_NHEALTH, while making the code more universal to
allow use of others later.

Signed-off-by:	Alexander Motin <mav@ixsystems.com>
---
 ndctl/lib/msft.c | 41 +++++++++++++++++++++++++++++++++--------
 ndctl/lib/msft.h |  8 ++++----
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index 22f72dd..b5278c5 100644
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
@@ -12,12 +13,30 @@
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
@@ -30,12 +49,12 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
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
@@ -48,22 +67,27 @@ static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
 
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
 	cmd->get_firmware_status = msft_get_firmware_status;
 
 	return cmd;
 }
 
+static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
+{
+	return alloc_msft_cmd(dimm, NDN_MSFT_CMD_NHEALTH, 0,
+	    sizeof(struct ndn_msft_smart));
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
@@ -170,6 +194,7 @@ static int msft_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
 }
 
 struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
+	.cmd_desc = msft_cmd_desc,
 	.new_smart = msft_dimm_cmd_new_smart,
 	.smart_get_flags = msft_cmd_smart_get_flags,
 	.smart_get_health = msft_cmd_smart_get_health,
diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
index c462612..8d246a5 100644
--- a/ndctl/lib/msft.h
+++ b/ndctl/lib/msft.h
@@ -2,14 +2,14 @@
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
 
 /*
-- 
2.30.2


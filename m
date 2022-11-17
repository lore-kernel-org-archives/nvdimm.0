Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3C3A464
	for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 22:38:59 +0000 (UTC)
Received: by mail-qt1-f171.google.com with SMTP id e15so2122203qts.1
        for <nvdimm@lists.linux.dev>; Thu, 17 Nov 2022 14:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/sakPxkdhefEPhxq3cq6e29lQC77134wJ/YGMkb/Hak=;
        b=H5T9uUrVcMsNlW3j5pU4Pi4tZdL3GPeJbX5bipqUzsb3AzPvj058P6CTCYlkBWiQfV
         dB+YPm4dr85XTGC+mKDKrB5njM57eKANJKTEccinWBcxQlbDT+NoiM/CaUXQcHZp/GLl
         vlriTSbMchPqMeLwjRHsIr2kzrNmhZHQiOt4yyVOO2puUuAuATby7Gg+SSENoB/q2bVn
         k3+UM19cfgfbrZR1RdnTiCHI7vCeh7JLkKHAcOTKNvhbWliqGmOXiSx+mzwulMXbZmEO
         mXAaUaRHtDQ7eX27+IAerDm+XZbc0lm+TCEmVl4j+ugN6TOVpYIMcW4PW6d8nLagQfsy
         NZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/sakPxkdhefEPhxq3cq6e29lQC77134wJ/YGMkb/Hak=;
        b=GKZe4xi6Q/xuF6BgtZeXZkB6hddcWlQ4GYdmDGOnJXgfR6Jq/DV+Z2LEPVIl1DxbtB
         T6fRvzNeThp1cayAbqJY758Xp9RhyNnOBmLC710n6/CtYcGcM25KA2KbA/zUfcnJFGTq
         R1VMm/n4fuouf5l+SPCm9eAdCX380BJ9D3UIBDoXvtBtC8y9fLfRiDsXGFOLqJJs4GiC
         f91KtHcJkBn1uSUsF8SsNGJv2on/gFiVhwjMlHqAO3TDoEGhJSebygrNCPYWAx/9ur16
         ODqxFabjwRP/ae298lp3S0cH2GJyOaQgSl1JEqTv+KfkB2gbyQ754M25c1SmmSWAwJZt
         eSMg==
X-Gm-Message-State: ANoB5plKk+4xAppQbiFvK4/hkhM3c7Ru5RXmvDo1KUL5K1WtoJIrIqBk
	FBRJ8mXzccjtvezVx6JzdgipAsDP6iTz/vo0SnqBix9A8BD25qBiIMTSQrWE4frSM5H1N6Dfa/m
	zpZPCBKfM0szz8YKYPAoIfAf3gySDrLlxU1ZYDhV4f6kbHbrUflt0bXgdvR/cmyl9KA==
X-Google-Smtp-Source: AA0mqf5M+SBmplXomz9eCcrbOPGtNqE1R3vUPf6JJ8OG8Fwo1Sb7IeOCp5/PzzkiMIxpvdLJPgMuFQ==
X-Received: by 2002:ac8:6688:0:b0:3a5:3e8c:6130 with SMTP id d8-20020ac86688000000b003a53e8c6130mr4209352qtp.259.1668724738061;
        Thu, 17 Nov 2022 14:38:58 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id do52-20020a05620a2b3400b006fba0a389a4sm1272237qkb.88.2022.11.17.14.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 14:38:57 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH 2/2 v2] libndctl/msft: Improve "smart" state reporting
Date: Thu, 17 Nov 2022 17:37:51 -0500
Message-Id: <20221117223749.6783-2-mav@ixsystems.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221117223749.6783-1-mav@ixsystems.com>
References: <20221117223749.6783-1-mav@ixsystems.com>
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

Signed-off-by: Alexander Motin <mav@ixsystems.com>
---
 ndctl/lib/msft.c | 55 ++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index efc7fe1..8f66c97 100644
--- a/ndctl/lib/msft.c
+++ b/ndctl/lib/msft.c
@@ -114,26 +114,32 @@ static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
 
 	/* below health data can be retrieved via MSFT _DSM function 11 */
 	return ND_SMART_HEALTH_VALID | ND_SMART_TEMP_VALID |
-	    ND_SMART_USED_VALID;
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
@@ -142,21 +148,13 @@ static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
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
@@ -165,7 +163,13 @@ static unsigned int msft_cmd_smart_get_media_temperature(struct ndctl_cmd *cmd)
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
@@ -209,6 +213,7 @@ struct ndctl_dimm_ops * const msft_dimm_ops = &(struct ndctl_dimm_ops) {
 	.smart_get_flags = msft_cmd_smart_get_flags,
 	.smart_get_health = msft_cmd_smart_get_health,
 	.smart_get_media_temperature = msft_cmd_smart_get_media_temperature,
+	.smart_get_alarm_flags = msft_cmd_smart_get_alarm_flags,
 	.smart_get_life_used = msft_cmd_smart_get_life_used,
 	.xlat_firmware_status = msft_cmd_xlat_firmware_status,
 };
-- 
2.30.2


Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71E4DAD4A
	for <nvdimm@lists.linux.dev>; Fri, 13 Jan 2023 17:29:25 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id s5so15141854qtx.6
        for <nvdimm@lists.linux.dev>; Fri, 13 Jan 2023 09:29:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/sakPxkdhefEPhxq3cq6e29lQC77134wJ/YGMkb/Hak=;
        b=K3sRdoz5wRmCe+2PYlRpHuC8DzEmhvTo5iOdVZG4qGxBC91eMLwExHqGm1AbR5uLfv
         ihHOAhtQLaDojcgmN8e5DE0HBtao5L1crewk1KbArfbA1SMt2rWCpQ4ee09GVsD29LFX
         PMXrHgnzdy/a7IDgOOfVW2wJTs7nDhXENIeJzwYOyB8ntCr3OrF+I+OwSh5RbYwy2V0G
         96D/RzEb60rP2WiBYM8qipvfaJXIx48U3d4UHGY8Xb3XhYPg3UlXdvlu0qKwjzXSDHgm
         Pohm6KKy64zv95W+YrxTrC+KIUBlr6I40LoqyUVgpgsz1nu9eBYT+kVkRY3g3NvkouSl
         0eLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/sakPxkdhefEPhxq3cq6e29lQC77134wJ/YGMkb/Hak=;
        b=LODxPUJOq2vLtwWUW7VklA5yznVDvD11ezxBozl11h+jXGuKyQMwMFQcvnxaDrkT9A
         1reLNQnZtXKXbBTli2Yv7fYz+VLYfWsovyur5Nfs0G8lbUbm1dUmhv5slFXOB/NJtv9p
         NeiwTNvHFTw1mqzqLwzoLPuKGCKx78Nc7geiqN5R0jddKT6nBpy4lbXg50K6IGc5qDzC
         fhzdWlFULIGBySo1AmkckiK1KIoTE5UswvCyzIKck1G+7USL3g/2VkWktMtOMGaUzTKT
         C4FjmdNuLzWDrc+XCHPH+we8w45XWFWgq5DQVefSBgNKUPShpu3gicrJehIdsqaDwSTF
         3BMg==
X-Gm-Message-State: AFqh2kruMPhg7c+VuQs70ZKOKXsohXWVRzvGpKRhMzHWXMUkx+6ioxzI
	UKXVXuRSqn92QfWPvE5U4R5n2MyJWmAqiqnuIwv+vL1seSrg7qHbJhGLbJakDte80AYsM8qHY2h
	sHLX72VJ9PurVDaJYxrsVS9R3MrP+gfxFDLAYdPBiBXxhQWIObTLwOll89kF4yUksvk5E
X-Google-Smtp-Source: AMrXdXskPzmYpYVSWrPcYgSLNJ/CvvTkOVinN2SC8FI/ZOIh9rBit6jdpipn4IQEGDzaX8nikw2BSg==
X-Received: by 2002:ac8:7205:0:b0:3ad:841d:e65b with SMTP id a5-20020ac87205000000b003ad841de65bmr27167736qtp.7.1673630963883;
        Fri, 13 Jan 2023 09:29:23 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id t34-20020a05622a182200b003a527d29a41sm10817157qtc.75.2023.01.13.09.29.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 09:29:23 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Lijun Pan <Lijun.Pan@dell.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH 2/2 v2 RESEND] libndctl/msft: Improve "smart" state reporting
Date: Fri, 13 Jan 2023 12:27:34 -0500
Message-Id: <20230113172732.1122643-2-mav@ixsystems.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230113172732.1122643-1-mav@ixsystems.com>
References: <20230113172732.1122643-1-mav@ixsystems.com>
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


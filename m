Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAECB7B
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 16:52:01 +0000 (UTC)
Received: by mail-qt1-f177.google.com with SMTP id b21so2987086qtr.13
        for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 08:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ixsystems.com; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6rEa4B27p8KJ9J93PuZ29qcEuS5+ftu87mGHg/UW+S0=;
        b=G4car/K1Ch/HPm/DcGjgzlDjPUXs6aQurOpxJuZbZZBQLWhLtHjtYYp1HL1u8r4/E9
         rbHStqnfiNQ/7uLCXDsUf8bykaIBdEgRM36xzbl72FtCAdC4pMrIPl/YhwEKUVZViYQj
         evHhLUgckgcy34x4eDq/3cRBJqyt2g8T7tY5k1czlCTRbHnnjKTO43Lgni8prg2PT7sq
         SdXwf/lbJxUYWAq7O0AePPhnon1mYPZ0L9Jz/u9MOecqRIuSAHpfLmdom7T/S8ws1R0H
         xxAJcAGOZT063HtO1ov1YQA1BsYre4vxQ7FjX03r5rvgqzfyK2wGguIq/dPgGojvKuQW
         kK+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6rEa4B27p8KJ9J93PuZ29qcEuS5+ftu87mGHg/UW+S0=;
        b=qDGosKql0xUDsTCv8Tea1HQhD4umCK+KWGjOhapenKx/9B/9cVAv23hvFx0FkxZrqO
         4cFyliWd1csrvbGii3OJeWMGrx2LvLPiMsZShpkEquaUKdM4mmw65WXvw8VJTabX1v19
         p6hpx5ekKLAyX16u4RIBYm+SO+M6bo6Ope9SzvvfCsQKdT/a7eLpoRP0xEfb2UsUxxA4
         5dHIXBYtoKEysJJ42jMAk5dQXc7jxktlqWvXF1yNe4i1BhkN+oVMzfpvJ4bvjgem9+HX
         9FAsVHn73uL/8mSlFbfG8+WXk2H+yB1gn6cDg8R+AOdVDzZWaRbtBzN1p3WJrVyg3y5+
         4aiQ==
X-Gm-Message-State: AO0yUKWo1QPKVdaBcnrbZ+ryHXJVYQuO3pdHD+t6QEJ/z7JPdlKamZYZ
	di7R5MvWw60y5GoEGWvSoQTxz1WccC+slCCtuTq4U1ycRZu/pofIA/X0teWAqGDHV1C19ip1JKH
	omcO4b9reNugUhGgyDFFCetlkou1v01GYTK9rR1HbzvSDo8CEyYiIIitFTn93bBrp7Yuu
X-Google-Smtp-Source: AK7set9lX2WX+Ht6kBZYIGFhWgD6waKf+8s8Fh13FEFORcPDJWS2OJsTdEdHVyrS0G0+iTFkisdSnw==
X-Received: by 2002:a05:622a:551:b0:3a9:81f0:d8e9 with SMTP id m17-20020a05622a055100b003a981f0d8e9mr4301314qtx.68.1676479920281;
        Wed, 15 Feb 2023 08:52:00 -0800 (PST)
Received: from testm50.mav.ixsystems.net ([38.32.73.2])
        by smtp.gmail.com with ESMTPSA id y10-20020ac8128a000000b003b68ea3d5c8sm13353529qti.41.2023.02.15.08.51.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 08:51:59 -0800 (PST)
From: Alexander Motin <mav@ixsystems.com>
To: nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexander Motin <mav@ixsystems.com>
Subject: [ndctl PATCH 4/4 v3] libndctl/msft: Improve "smart" state reporting
Date: Wed, 15 Feb 2023 11:49:34 -0500
Message-Id: <20230215164930.707170-4-mav@ixsystems.com>
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

Previous code reported "smart" state based on number of bits set in
the module health field.  But actually any single bit set there
already means critical failure.  Rework the logic according to the
specifications, properly reporting non-critical state in case of
warning threshold reached, critical in case of any module health bit
set or error threshold reached and fatal if NVDIMM exhausted its
life time.  In attempt to report the cause of failure in absence of
better methods, report reached thresholds as more or less matching
alarms.

Signed-off-by: Alexander Motin <mav@ixsystems.com>
---
 ndctl/lib/msft.c | 55 ++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 25 deletions(-)

diff --git a/ndctl/lib/msft.c b/ndctl/lib/msft.c
index b8ef00f..a66ca9c 100644
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


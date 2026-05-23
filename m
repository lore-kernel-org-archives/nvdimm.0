Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30ABB37DE85
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529860; cv=none; b=DFNPOjwG4LqyCV+eydFcqEHbuiPcXw5t3X1TbzRhhsWoiyr73q184qY3LabVRFQu1wjwCHmu7Fixsrj6cL1ztC9rELTSyBSgAcVuc93x80N/HXD2aAuBkXeeCYu1/6TuOxpazrU0VD49a5zz5mFRhmZ5SQlKlaPqwjs0k8H54dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529860; c=relaxed/simple;
	bh=6YH0VSg8z29bgT7vuC21hIpLnKsIOMZukMbTGDrmXbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j6vGN92eFXXODGDvFySwoVjjXnwChBJL6oqq03zmzGFHuaCv3tBrlULUJ5nK5jpQRW979uSHt532vyn81LLcNE1kkq8mVzZr5R0uQji9vKJVsYi2LFz0GH7dvCivdflFPkk10pz8NBpHVbHoMvaVuIV/G4Grg/eMsHw9G1a6A78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kEqwSBcQ; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kEqwSBcQ"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-30246cfd41aso1934119eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529858; x=1780134658; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSuhJuhrWfLqNYKOHdVj5Qj8f5x9bU9bPIIaF+njKdY=;
        b=kEqwSBcQwWFARK9nJ2WvfN6ec+CKBPq2MAGA2scrVYI60X1XiuycYF/KSKWvwq3NW2
         CjYI3/4JkMK9t0/jzoK3+x42uDkvVLiyqRJnJG6Lfwb5skTZ59vBTUmvRe5Q9QPx9wTx
         Am/b43h+hU/QXmLRe7xG5L3BSiFnJ+WodpnrZXGVZR6aqmgt0X/p8yJqclPzuP1k8G9h
         RVqv56IKKug60LfleJPwFN0JMn22Wt7ZvXsb/PrCb66rLXlKrMXiYrx/9TEDWIVP93yf
         5y6ziUb8J933kBHpC74C5gAWul6x3xxAQJea75+Ts+q2nNBBjqQGG8uExCIzro+x5Rnp
         7Ktw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529858; x=1780134658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KSuhJuhrWfLqNYKOHdVj5Qj8f5x9bU9bPIIaF+njKdY=;
        b=gRtD6xUzUYbNsQepsFrakeywocDS3xOXGB45QxvU7/PY/8myTAypkt6RZeQgg4nlK7
         ezc7oK4JORXvC+gWji29gLXSeGx1VPIIX+TOkMVTNklVMJLFtIrGl0UdyTjefGiJI3Ga
         /R/Hk0C1NgH5GcPcccLN5teiqg8BqzvmTYpmmw8R8Lwh95voSqui7OXdaCvDODqf/W8p
         edOpvVWyJKIKWmJgfSTUg8AhWBXuT+FDOTu7kYMpwIV4zvCuA9b2vyBU7Rki8cpwERN/
         59Shs/c+YsnemwOFWRzNbmfoIc3Xw0a3iPEPMmY4kV4YGe/77xkUrsqsM2pk6t3nIb9n
         T3iQ==
X-Gm-Message-State: AOJu0YwRXGGzpycLSdwPvR4DMvCueuQ6HRWHYKLSKJsyqAa6R+6iD9fP
	J2Qr2JLDgB8y6ZUX74W3leOdl5TIq3eRLhad6N2KPGgfMHEqs8WDSDF8
X-Gm-Gg: Acq92OHwDz2YMnnAko1JeDH93Ke9bgbPJF6Hyruzf1640dDHHyNB2Klsujr0hmRNRao
	ZSgFMGweSk0VsLPQIq+5skrAk2SGLbhWE6q/WjHxQLrSmI7CiWyeODG6euqdXlkD5CVt6MbnK8c
	v6bxI253sfToF/5kP7G3GqL833Ufwlu5okqIWdD50RmWb5s6aXD/YW/wWayezSneXng/NxF6QrV
	nZHBRBZgU7zlxKpAy75kxAhKkBs+ZE+dPKGgiXehVwOC9e4uUkiP6mryP1PgCB/Z6Q5oQLihj3h
	9RmHOrImOpwcQX6P+JKsRGAO25Jtgsw8o1qs5+gPfqPJYFU9Vr2HJ9eJSN9qTxYtCOL1XsXDNjK
	MWMKpTxjCQI6DvFWFdFuH9Cv9hAiVL7APyubaaGsK8b/xGNq0xdki2v+g6sCM6i06L3bBE7WuE4
	NRCEbQd6h3RNO74nEM8gTEflpaweUpO2/wkAlnJEUqkyxcH/zlplJPOb4YBZPjD1WpsIJ7rkGEe
	YC5Rrc=
X-Received: by 2002:a05:7300:cb86:b0:2ed:e12:3773 with SMTP id 5a478bee46e88-304491faf02mr3957866eec.35.1779529858372;
        Sat, 23 May 2026 02:50:58 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3045225b7b6sm4595756eec.25.2026.05.23.02.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:50:56 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v6 3/7] cxl/region: Add cxl-cli support for dynamic RAM A
Date: Sat, 23 May 2026 02:50:38 -0700
Message-ID: <20260523095043.471098-4-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260523095043.471098-1-anisa.su@samsung.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

A singular Dynamic RAM partition is exposed via the kernel.

Use this partition in cxl-cli.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[iweiny: New patch for decoder_ram_a]
---
 cxl/json.c   | 20 ++++++++++++++++++++
 cxl/memdev.c |  4 +++-
 cxl/region.c | 27 ++++++++++++++++++++++++---
 3 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/cxl/json.c b/cxl/json.c
index a925488..e94c809 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -620,6 +620,20 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		}
 	}
 
+	size = cxl_memdev_get_dynamic_ram_a_size(memdev);
+	if (size) {
+		jobj = util_json_object_size(size, flags);
+		if (jobj)
+			json_object_object_add(jdev, "dynamic_ram_a_size", jobj);
+
+		qos_class = cxl_memdev_get_dynamic_ram_a_qos_class(memdev);
+		if (qos_class != CXL_QOS_CLASS_NONE) {
+			jobj = json_object_new_int(qos_class);
+			if (jobj)
+				json_object_object_add(jdev, "dynamic_ram_a_qos_class", jobj);
+		}
+	}
+
 	if (flags & UTIL_JSON_HEALTH) {
 		jobj = util_cxl_memdev_health_to_json(memdev, flags);
 		if (jobj)
@@ -917,6 +931,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 				json_object_object_add(
 					jdecoder, "volatile_capable", jobj);
 		}
+		if (cxl_decoder_is_dynamic_ram_a_capable(decoder)) {
+			jobj = json_object_new_boolean(true);
+			if (jobj)
+				json_object_object_add(
+					jdecoder, "dynamic_ram_a_capable", jobj);
+		}
 	}
 
 	if (cxl_port_is_root(port) &&
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 6e44d15..bdcb008 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -269,8 +269,10 @@ static int __reserve_dpa(struct cxl_memdev *memdev,
 
 	if (mode == CXL_DECODER_MODE_RAM)
 		avail_dpa = cxl_memdev_get_ram_size(memdev);
-	else
+	else if (mode == CXL_DECODER_MODE_PMEM)
 		avail_dpa = cxl_memdev_get_pmem_size(memdev);
+	else
+		avail_dpa = cxl_memdev_get_dynamic_ram_a_size(memdev);
 
 	cxl_decoder_foreach(port, decoder) {
 		size = cxl_decoder_get_dpa_size(decoder);
diff --git a/cxl/region.c b/cxl/region.c
index 85d4d9b..3c935bf 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -303,7 +303,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 
 	if (param.type) {
 		p->mode = cxl_decoder_mode_from_ident(param.type);
-		if (p->mode == CXL_DECODER_MODE_RAM && param.uuid) {
+		if ((p->mode == CXL_DECODER_MODE_RAM ||
+		     p->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) && param.uuid) {
 			log_err(&rl,
 				"can't set UUID for ram / volatile regions");
 			goto err;
@@ -417,6 +418,9 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 		case CXL_DECODER_MODE_PMEM:
 			size = cxl_memdev_get_pmem_size(memdev);
 			break;
+		case CXL_DECODER_MODE_DYNAMIC_RAM_A:
+			size = cxl_memdev_get_dynamic_ram_a_size(memdev);
+			break;
 		default:
 			/* Shouldn't ever get here */ ;
 		}
@@ -448,8 +452,10 @@ static int create_region_validate_qos_class(struct parsed_params *p)
 
 		if (p->mode == CXL_DECODER_MODE_RAM)
 			qos_class = cxl_memdev_get_ram_qos_class(memdev);
-		else
+		else if (p->mode == CXL_DECODER_MODE_PMEM)
 			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
+		else
+			qos_class = cxl_memdev_get_dynamic_ram_a_qos_class(memdev);
 
 		/* No qos_class entries. Possibly no kernel support */
 		if (qos_class == CXL_QOS_CLASS_NONE)
@@ -488,6 +494,12 @@ static int validate_decoder(struct cxl_decoder *decoder,
 			return -EINVAL;
 		}
 		break;
+	case CXL_DECODER_MODE_DYNAMIC_RAM_A:
+		if (!cxl_decoder_is_dynamic_ram_a_capable(decoder)) {
+			log_err(&rl, "%s is not dynamic_ram_a capable\n", devname);
+			return -EINVAL;
+		}
+		break;
 	default:
 		log_err(&rl, "unknown type: %s\n", param.type);
 		return -EINVAL;
@@ -509,9 +521,11 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 		return;
 
 	/*
-	 * default to pmem if both types are set, otherwise the single
+	 * default to pmem if all types are set, otherwise the single
 	 * capability dominates.
 	 */
+	if (cxl_decoder_is_dynamic_ram_a_capable(p->root_decoder))
+		p->mode = CXL_DECODER_MODE_DYNAMIC_RAM_A;
 	if (cxl_decoder_is_volatile_capable(p->root_decoder))
 		p->mode = CXL_DECODER_MODE_RAM;
 	if (cxl_decoder_is_pmem_capable(p->root_decoder))
@@ -699,6 +713,13 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 				param.root_decoder);
 			return -ENXIO;
 		}
+	} else if (p->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) {
+		region = cxl_decoder_create_dynamic_ram_a_region(p->root_decoder);
+		if (!region) {
+			log_err(&rl, "failed to create region under %s\n",
+				param.root_decoder);
+			return -ENXIO;
+		}
 	} else {
 		log_err(&rl, "region type '%s' is not supported\n",
 			param.type);
-- 
2.43.0


Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06EA639FCB5
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791673044; cv=none; b=q4MQtPcHd4YF1wFqtGINFl8DEtiqUDPpYeKdBZq4zvJ1INRRTm5wStJ1zs4Mzc3Hz7RG+CqvFk+obBXw+OaGWagoP683LvqbNgOnTbHzFDFf++UPRT6ycmHc9p/eyhDQ55QeSnzE4qErqb3FRjfpIau86DrgA08lKKP1VpjyylY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791673044; c=relaxed/simple;
	bh=rJSNS3hxFXjvhAIjk0zs30Ksq5LMT0FmugM3VSedSqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nwiXFeVSxxzdD17SXqx+v6q59sdY9feYxwS3VAeJgY1FrnQDLtTesV2ND04kWr6eVRT45qp/Y982XUSHm5L8FdMQHdeZP6m5k7qa/t3znAY54LbpbB7nMwPy9zkzeel4MRHoLzgSrxiSiGHJkgkEo5co3TF8V3P5aSOTXuGCpl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ELkVFGUc; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ELkVFGUc"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc1bc88a20eso520318a12.3
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791673042; x=1792277842; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pLoOW8JonK/+ilXezPkpunwCJzUAC6S3Zezv3PLAoaE=;
        b=ELkVFGUcIskfmPQaK07UXTXPBYFBmp7s53C1yA7Vg3szVkoeJqWrfoW8O1eplcVQJ5
         isJHd7zkAVPkWrwq5z4hpBQso73A5XPzx1f7cc/ozk4ndIOUA9HopizhIESMH++3Sg1I
         Zdp1RLbmWXKSgxT+oilFY5eIQIXYll9NW2GgBTC8Cmu2QS7ZtNs0lrD3anu6tJ1u2reS
         gWVYWwddhgmIbLop2WDY/sfoWObI9knPb9voYZLilU27LQxwvztf2kxMCCgOv5QVBOXr
         tsm50qHzRmuGN25L9K1vvV2Nn8J5ptBZH/A4OIizupHy7iQph7JUhHfWZuLGETeW9dWr
         I3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791673042; x=1792277842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pLoOW8JonK/+ilXezPkpunwCJzUAC6S3Zezv3PLAoaE=;
        b=wO2vCDKl8Ry8ZM3DqgSdoI/aoYn/Ng5oCFVxObIGWWOpH75KVUgj8o68IWOlN9yo1g
         bv4kpJ9XrqWFG1Xnex+xPxlwJdujmCMgyNPuelr2GOs4cwjitz7cW0CLwtjoeFiK0ypX
         9+fdq3F+Rp/ty6jf9HK+eWOxKDBRhYgqIQeC65HPLSwAWr6XVaNxqHbJ4o+Alq5s/8FD
         gusXEcT0uNNvKtALsMZxdBuPfOyRQNFD9X/YDi3B0kzkLCYU6oApysIgEAFOb+85X8mA
         22IycNmOR+A6v+PSe58n0gwVxFC8PtUdwjWMLpMUSWLhhc59mHOwegX4cz0T1zS5eteL
         9LBg==
X-Gm-Message-State: AFq9FYJKu2LorOOxOlRyvSINEWlpzYV/A6t4qg09d0oMWQIL/7qN74vm
	Zul+xx9hZT4dqlou8hvPdWMcNG8PCytvZZP9KMi5wuEZ0wyHYUROTdbk
X-Gm-Gg: AYBFou05yRIRshE2v0Wx13N8sE6q52agdSWJLpjbby/MdfQGn+SgG4zMFQJO7PrtZNm
	307MjCpLSLfECbT/lWHc8+G6ZbXeN6Ag2OLNxV8V2qpkSzCB+0mcUaD51WszU/mvIJHUDOVFoLe
	5D5tYFLoYBrtm12ms4ElmjUkAgEMjd5jg9VfaLLzx5k+fcEZzD4CqzpvveUbh+YERFJu2LF4VT9
	UsPoOjZYi1119fF2XquN/xDvPalAoDZ7W6h7CTG0ru/OZfP/rZiecg78wuGkUHsiq3p5PESjOi5
	poU4+n2rJ1OhO0GW6rG2wF3C0d8xPzNNTDrZSwYmzwPO+1sVWKj1ROodAO9mZ286HT1006NkRPM
	YFpRUW9xnrFnw3of2QOMuQZxxDrksQmemc5m+xWwBHORnD/+VH4jm/D5Fm+Es2qoTPT0W7wcnQ/
	Jt0acZZF+LFsdv5Nik9li8w4pmIkp3OpJ2kA21kQ9WsIJseIp97ow/wvtMHRaVkKIToD/WDuOFW
	ql/wnZnTLBVmm3USnB9+Q7Iv3jJOVI1za+rkB4=
X-Received: by 2002:a05:6a21:484:b0:3de:61f6:4206 with SMTP id adf61e73a8af0-3e16bf6d39dmr4612005637.70.1791673042285;
        Sat, 10 Oct 2026 15:57:22 -0700 (PDT)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e07329sm2603662a12.5.2026.10.10.15.57.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:57:21 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v16 4/8] cxl/events: Split event msgnum configuration from irq setup
Date: Sun, 11 Oct 2026 07:54:55 +0900
Message-ID: <20261010225852.10727-5-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010225852.10727-1-anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Split cxl_event_config_msgnums() from irq setup in preparation for
separate DCD interrupts configuration.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
---
 drivers/cxl/pci.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 2fe9db4b3d86..4867657f5526 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -600,35 +600,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
 	return cxl_event_get_int_policy(mds, policy);
 }
 
-static int cxl_event_irqsetup(struct cxl_memdev_state *mds)
+static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
+			      struct cxl_event_interrupt_policy *policy)
 {
 	struct cxl_dev_state *cxlds = &mds->cxlds;
-	struct cxl_event_interrupt_policy policy;
 	int rc;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
-	if (rc)
-		return rc;
-
-	rc = cxl_event_req_irq(cxlds, policy.info_settings);
+	rc = cxl_event_req_irq(cxlds, policy->info_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Info log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.warn_settings);
+	rc = cxl_event_req_irq(cxlds, policy->warn_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Warn log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.failure_settings);
+	rc = cxl_event_req_irq(cxlds, policy->failure_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Failure log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.fatal_settings);
+	rc = cxl_event_req_irq(cxlds, policy->fatal_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Fatal log\n");
 		return rc;
@@ -675,11 +671,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return -EBUSY;
 	}
 
+	rc = cxl_event_config_msgnums(mds, &policy);
+	if (rc)
+		return rc;
+
 	rc = cxl_mem_alloc_event_buf(mds);
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds);
+	rc = cxl_event_irqsetup(mds, &policy);
 	if (rc)
 		return rc;
 
-- 
2.43.0


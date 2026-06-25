Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A2E3D8907
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386909; cv=none; b=O7J/bjWBva413UMMvX6/3McdFS6xMntvGiLWNAzwMdQkGnnywtxAU+DSrubFVFnjuPaqvOmfz5WI+BYGbVaICvmpEw+V5vtRAbfAX+FnuEnEAgJxjM2NyE66hRDBKsQ0O9hGcjeceT04z3X+iwmoiOza3hgsATGXRfTogxFtJRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386909; c=relaxed/simple;
	bh=b/Rqlb7CRq2lHk7bPAK4VQjGp6d+BXhYLUx1wMMJHzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KC9ZST8YgPy4FN9eLKvQpeyWSJqCl1ZuRXhBFbnJwvRCqtSZE3k6MIK/mKV+6RkCkNyUk7rLnz0aMJ29tgDgOlUB2xV9zw/b9BsFqLUPBPsR01ISR1wend3ughy5WPfYGxY0ftXKdoiU4o+weDpumF7EpJTsmF9i+becPAcGKio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A7uRSuDo; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A7uRSuDo"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-30bf8b2bd20so4518853eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386905; x=1782991705; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2jKp/0nhQptqz/M2+wfNC1AREQXAADTJq6niusW0KQg=;
        b=A7uRSuDo2KGZr+aL9y1RnfJBJznKkkT/PchJuVvNkLaT3igRwbObi/xgLxlE9l6LX4
         HsvI/kEM5f6vuRsGxO7Cn8SzSJfgy8qzp10aA1kTQ82wd0N91JW1xpPwULnpNQMvSWeI
         WzWCjgbMiamZK9QoS+MLEUWmBKCcBBgGAyHVvFQf8LqQX9qyY3Gy41JsxWXNC6A97njt
         bOBHY/n+Haj5uucmqZOsnE45Pb9DxKs38ksomEtUvz4rpBoQX2w9OPW8hpFFRsxELs/U
         77gcL9Jk4xqr6cpTP0F13P+vJLquSKN/bVCP0e3F1PgS28uU1NYQZTXDQrQg2Z+oPXNH
         rHdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386905; x=1782991705;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2jKp/0nhQptqz/M2+wfNC1AREQXAADTJq6niusW0KQg=;
        b=lOnthx1drbMFEZShMVlindQNz9L1qjZZHqQrPc1CBFPZ0COU6EHTXHQlRkjH4pHlpv
         sEvzegZucVKvZvk0g5s+PU1vL8SMT17+MVeL71rT7oqa+YgfOwXff1vuUhV/MxGG+0M2
         9jFpg+bv2QOIt2kqGX0rVJz5VDvg/3yfBl0ma64CpZLxZ7UYPi9yARDme7LmwuVpRS0Q
         xt8PsrV8kLSo/oldud0JW6Gw1YtiGLEvDDCKx+YEhTsRhXJJ5Hh6cGSS2IvByLZpVuG3
         sAdMMmiZF3lsMrTXiC47JID0jO1+C7t1mur9WCXa/8Z+2EXpD1dG731PtY/fHcWJDFl2
         E+6Q==
X-Gm-Message-State: AOJu0Yxtm3/2lVRd/LSf/ouZw/9cqNTmQ8qTBU3BlkLHNR4q6nfFxts4
	/aZ8xEbGXSN1OUnvT7Ox4T4JhNJRWHyawCWUNYpMX82jK/pD6TI0Cpsr
X-Gm-Gg: AfdE7cneL0uhoWHXL5tosEZUpfmu186ERuqAa9FKl/SS03xxTW/PDCs0dsXRTvLKB2F
	xYJQ0qXxsw8zzcAqlxmuu13MA7YXSoFJdQXIiTIffKUKGoZ7OAA2fQDmSH0m/k+9tOmidp85/DE
	GcDOyq0k4uS2Z3T8xYtUpR0ICrxRAFpyS22MWUACOagw7gyW6wftl+qFIrgovUEyfQBimt87ZKm
	sTm4lFvaKodSPWhH30nFPVKSg6aXC+MT7rXw1ewOCuqTQb0OtDqk8pMCXPfLHRLyfkLv86xjbbm
	LcJy9wTnSCpTuwoE2mBP5u/iENJhJValDd2SN7NiN2n2GmOG01GJad1ysfPe1abWUtmPVJyB4+3
	DPpSxEdQVGKMjJ4+Pce6spXm2AgNofHKaStVrjDPzXIh0cYUhzPOntKvkDPP9KATRQVBFYpHQ7v
	DrHLrJEplALIJUlriPTeQYdeVBJXVSLPByYXfOo2wgk66TTqff+3czY1VznPTvn3rP112A
X-Received: by 2002:a05:7300:8184:b0:2ed:e16:6b4a with SMTP id 5a478bee46e88-30c84df4aadmr2221250eec.32.1782386904999;
        Thu, 25 Jun 2026 04:28:24 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:24 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>
Subject: [PATCH v11 09/31] cxl/pci: Factor out interrupt policy check
Date: Thu, 25 Jun 2026 04:04:46 -0700
Message-ID: <20260625112638.550691-10-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
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

Factor out event interrupt setting validation.

Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
---
 drivers/cxl/pci.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 35942b2ace53..8d12c684d670 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -639,6 +639,21 @@ static bool cxl_event_int_is_fw(u8 setting)
 	return mode == CXL_INT_FW;
 }
 
+static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
+					  struct cxl_event_interrupt_policy *policy)
+{
+	if (cxl_event_int_is_fw(policy->info_settings) ||
+	    cxl_event_int_is_fw(policy->warn_settings) ||
+	    cxl_event_int_is_fw(policy->failure_settings) ||
+	    cxl_event_int_is_fw(policy->fatal_settings)) {
+		dev_err(mds->cxlds.dev,
+			"FW still in control of Event Logs despite _OSC settings\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
@@ -661,14 +676,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (cxl_event_int_is_fw(policy.info_settings) ||
-	    cxl_event_int_is_fw(policy.warn_settings) ||
-	    cxl_event_int_is_fw(policy.failure_settings) ||
-	    cxl_event_int_is_fw(policy.fatal_settings)) {
-		dev_err(mds->cxlds.dev,
-			"FW still in control of Event Logs despite _OSC settings\n");
+	if (!cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
-	}
 
 	rc = cxl_event_config_msgnums(mds, &policy);
 	if (rc)
-- 
2.43.0


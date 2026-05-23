Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3453B340A76
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529436; cv=none; b=hz9QYZBqrH9g/xSaL8d43d1Z2biTu4ZwlNWJPf0ERWbtM1u9Fmrs84LNHuqVVYYMvRWPfF6HOx1kpltEKdB1rZ/66ROwsctkIOAS1PsH5Osv3EN2eotqlsrrlbu8tmsYpEjUsw9OM2GXbAJGqTKWTitdwC+rjWKBbZ/miznwzYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529436; c=relaxed/simple;
	bh=TRNy5M/WN3qqAniDdN+oE2OFskxJxYDlCStFug8uZT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y3OzXMnGCAeW+Il39MTWR4RXwMTqvi9Suidl9NKS9sDsV9ybBRcpGtLZ3UtSTNgOg8wAvY7dXiH140LZKHOwKZ1anHSlaO38xpbS6gCMewt+7h3pzIxeOttdNV7wDFVYbSefWq+j/B4S60uxAfX07YQ4gO59TQac7xpP9AKR+EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MtPHr97c; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MtPHr97c"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3042a388168so1871328eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529431; x=1780134231; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=s6d+nwILJMu/HApS7ffo+r9TZ58+uVhFX0f64Cee/yY=;
        b=MtPHr97c/NzNkhWuRtdXUi9sVY+a4qWuvLoQGf2/BNYtSbdLdIkLePrpmWF0CtQNgm
         9R4dt9KJ8dgETkb/0+Ih5NrghNzYdSuH0GrBBYwItZ4YFVXpAIff9I9fLxUKLcWbEUkU
         LgrYlOFLl5vsnRjwP52wIesUGU0k/DKEYoHLBKh/sE2wfnxodgQzzaPJOhGMjreUWuxQ
         aiNR0tXdJ1N+9umdjyIsueli7RXoZOh1VlrnQPaY9gdOWNlcebTRGKgjA8dItBSA9CrI
         OjcgahgWWPUmA0DJdqm22Hj8gOt7MI5CRN3j5b0e/3wrh8izG3ZCVSUQswaePwTjhBt7
         uWEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529431; x=1780134231;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=s6d+nwILJMu/HApS7ffo+r9TZ58+uVhFX0f64Cee/yY=;
        b=EAxH5cjQjr7RrX5Br2ii460bn8hV/BTMMYO7gONlTNq05pe5fwLNq0DlV6RITRQdss
         XAYV5Tk+C1cPekTN5POR2dH9r9mX2kn8Ax9rQpAR+DM8d0R+yNHmf/qZ/p5R1YQSCQb9
         uvKCKhjRWz51Q8GjrwjFqfcAkfsGDsOFSb2TvtddYisBbLaN1A4dBzoGZsKfUqWMqzNh
         0aktbsjpKm9UcgVfI5ry3jwo8axdZ1SytsCE0pntdchSZR/SYemCITTHVJY2sCdlJOV4
         jEfjNaYeCHMtMzZeSsIPfQkW6i7D8kBXbyrV7CJsVfGpQCZEamPfeFaj3YRnJAcLIbZ1
         G2mw==
X-Gm-Message-State: AOJu0YypFLq2Vej0rD50oExnueT1jc0qgv7LGD/B97HZk51usCucry6J
	6oM/yZG5M2vOGxlGu9GZJu/mxVt4+6eTFt2RNxaHteoYDCu+dMVhIXA3
X-Gm-Gg: Acq92OG4NyDolrLlEphfpc0NXziZsDN5XmmwGUEiCF3ltTQ3KOUnJHHYA0OfDfd+9FM
	BPj2XNCPWJPTwNBtwAEcnRq1D9xRJJphe55FUZKEI5f+bpd+pyW9IiTX5goSfmPST9ltQGPZ2CA
	QdrNEpC/USDVdDVuUSkNhdlOUpiCU8EUnH8w6AWu0l2Ss5caMPWlv37sjM6m4IpoOMDf8zAExBB
	XwE8LK3M23krB+RZ08kmPs7CW8SbKiCvzY7ekwzK9a6UXIyY+e1mmD4rDEEbcoMjinPK17RkkFk
	KjHKboJ5S8ED23P61r+krnTv4ZM9i4MTd5fvb/Fw/OtvWT5GcSC6AdR2RNo4EZH5Mm8OYr/J8zd
	2b0+B5o//L7r98e7ByLAplGCmnQ9sFNUdryt8VJaW5/H1JMsAXye18OzYPRgGVpFUEvL/l6Daiq
	FtrA5C1z9q1LCROA1krGmdPSy/IQIuqJ4I/sJptbTLBuaOYYCRlmUQDvHhM+JWO5gg4zbe0g0wS
	2sAwss=
X-Received: by 2002:a05:7022:f91:b0:129:1d25:f1da with SMTP id a92af1059eb24-13633a69b63mr4019288c88.3.1779529431282;
        Sat, 23 May 2026 02:43:51 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:50 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Li Ming <ming.li@zohomail.com>
Subject: [PATCH v10 08/31] cxl/events: Split event msgnum configuration from irq setup
Date: Sat, 23 May 2026 02:43:02 -0700
Message-ID: <2906584012fc147ecf67578022a78415f60f73ce.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Split cxl_event_config_msgnums() from irq setup in preparation for
separate DCD interrupts configuration.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: rebase]
---
 drivers/cxl/pci.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 60f9fa05d9ef..35942b2ace53 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -599,35 +599,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
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
@@ -674,11 +670,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
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


Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C9438736A
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529436; cv=none; b=sInABnSqzHahDGDl8i1t8iztGtvbIGKVq06ksjGcYFW56f+BI1HkJjER7wg4TU6BJg/vBay0hwTUjUbp4M4SFQCgpHSDaEKcHwcdJJozFAvepbtD01VRw8iRqwaj6Xjt+5J682CyXVApnX9rO9FIEkqKKKE/Hit/xgmnapjDSzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529436; c=relaxed/simple;
	bh=cA6OvtiMYiH8fWm6hs/pB2NqRBhSnJLhmhXOqE10cNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfUsQfYNx1A/F8a+qH6109BNU22QG8ZTVMtzI1vzgnXQRwVAODZ0cH2NwVEzTExG4YxjBlXyeVJOGv5meREYmy+NVmTr1kbY8PASJst4WgYqDk9pOddCbSfqNOEhndrBtVwMY9d7ksnQFohYeJxEfnWaUK9m0rpeoita1G89Xrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XdKg03uE; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XdKg03uE"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-2ef2a1cc06dso12795986eec.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529433; x=1780134233; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=veSAHzzDLBJHWUT6ObwVQlgXBETLjKgsofHDN9ZwSyE=;
        b=XdKg03uEXY6wYeMLVjPJHBCdyDz4cCkcndzQ9478VOr9a8OqCx/EbXPgb+3XzpOXFb
         B2yAYZyZswJMAm+sr0mvBBZ+zXxQmj/pIEFL6hgguK6OAjOWaeSz/bcvcRhNYEYirJ2X
         AVOsr5ezJajipH5AoRkfQfOuXvJDGjA/XgZcHn2NOrWVMJBEERT1bR/KraMs64l+Ws0d
         RmLYF3nlriZ5awI2tdDzolRdXGTD+OS1Gj5iXdU8JUs54lF3g0fVv0Ka8OI5ifk4goUk
         7w3wVSsZGokWc/Ym1S6R6z5U56+FDKf+MHC4lvU6SixH7yh2eViS5varOl6vNY3XYpDh
         gSHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529433; x=1780134233;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=veSAHzzDLBJHWUT6ObwVQlgXBETLjKgsofHDN9ZwSyE=;
        b=nwQfW9R7dhB8TYGl6vl3SLSnE5qw0SgBJJBympoPIWqQRQLJ8xDyqDWinKAZWtyC5E
         yH0xbX197OtEwkkvl36RPUx53xA9htfj7LsDbVasR35UDzR5ieITVXW7AMICUvdFn5Na
         APjFzeUOUkO3GrEeHXkRyI5Pyoi8Pn3l5SdlqorN60bGD1hAOMhxA4CyP+mbhG1gpWxF
         noay9rOPhaEjoHMeYvp6yAeZ7+l++1YPm1WBZ4pDCbIH2I1m2CMnzb5MQoseaiASPX6d
         RkUALdgcBo3gti5ohCeWtM8vvZO3yzDfovBNZt1I1qphlQAkDkyQ9SSzkQ6Mr1mbfS71
         7A+A==
X-Gm-Message-State: AOJu0YzSFM99Tj9HZUBdDjEtOdO2wXG94mIdDIT20umIH5DSnmVcfeo7
	LqPhBHFp8eVwVViTwiiDCmv19SxOX7MQZTd9wTiiw56UNzK9UsmgC+SG
X-Gm-Gg: Acq92OFGEPgR75+yoSWFk6QyDTweaCemJdillVP/TPqW/X4OHuzHU67SpUrSkJn0prY
	lvnhXRPCdnq/TOdlgpcJYetG7A5kTFs+3iJJI24DHTi6uZdlYktwOsfr7ZI2mNzUWFv/+DJ06Jd
	bCqMdWTj2dA4Mmy2QU4MFteOo9QAFzIJKA8GK5PLDckhnrBHbuu/AF5kXB9R69xMnJR4q/jujFl
	1s7qmSoVxnTLWzF3nqCXMM7MScbzI4IvxRCibPC+tbxhw8GoY3LbhTmivr6Pbhs4QWnr4NujsPG
	7CetUU6M2lcanaRP1vCCTZNjtwANLMl+v0X/PCXuF/OCMUsePcDIbfUjdsa7i318RAf+0VhSaPV
	bVvWUXN5gFehw0zE/d/C+ZRv2BzVs/5q9VtMQURCNWtrnv29wD+vwS5Ncss8CQeSUOpua2jUra4
	V9/SapNxP8juvyWBxSH4X8H6oKzk22kS7iVqnCEPHtgIzGW1wXDkPuaDq8cGqNSbnVu4YEudKNh
	SbNNPyVeR3c429EqA==
X-Received: by 2002:a05:7022:1e11:b0:130:6c8f:5a87 with SMTP id a92af1059eb24-1365f81e50amr3002026c88.13.1779529433221;
        Sat, 23 May 2026 02:43:53 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:52 -0700 (PDT)
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
	Li Ming <ming.li@zohomail.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v10 09/31] cxl/pci: Factor out interrupt policy check
Date: Sat, 23 May 2026 02:43:03 -0700
Message-ID: <a211cbf4417cfeac8ebb9152ff66d9acf9b2c085.1779528761.git.anisa.su@samsung.com>
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

Factor out event interrupt setting validation.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: rebase]
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


Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0D61392C5F
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 20:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791404328; cv=none; b=Vh3OixSUBc72zKDP0+bKwVsoXujOQB9fBtjqe/xes0QDH5UXJUvvR+z1b9esjlTeFCpigxxjMksikFvWln6eaH47/7FSq5rXSTdtDGRRCXL6jHYwnnN0BQSioIT1/H+DstDd7cWyvqhFMObJkjhrd5l1l2XlN/28CfQM7A4HjFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791404328; c=relaxed/simple;
	bh=aq0AMSyhxQLdXuPHgvAFBRB0ypmluL2Ow3NcbByDnYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0HYElQOKGw0lSgBtCWTTnzaZvJCGVUEebtkQD5NE14IQOzMGMw2I0ONm7DfeQG4yd5wKx0cnG60cYni6+Cn6AADUY4FZJGMIWEsQml4LT3yzb3wPxB5dcfQSjcFnyo5BTNVyaU4gMmtjha9fmjJsJmLIzf2duFl9F0nfP16/Os=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bK5sk4pN; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bK5sk4pN"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-3a865731ee4so2029835a91.2
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 13:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791404323; x=1792009123; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O4ajd1qKUyYuUsNFBJ1eWwssuwOD2W4HQfyS01t4xII=;
        b=bK5sk4pNYkTl/yrsZkqacJBxp3r6Lfvdzk7idzV1UgCGqd26l94fWHxjCwAViPBH7t
         opozw4u1QdtUXAUq+6VXa60eGCKnVUcqENuBxeplaQgi85I1WU4liZ7UsJTwpbUTG5hz
         5rEWD2raTviQb7DM91sIc1EobiWVgwelnCdx59Urz0kAgWZLcL1HI/QrnNpq4JjV27D+
         1WkC+IrZ8DLR6U8wwQP9ccHhjLVqV/ewVkwEruNGEpWTVbHYbtPMk4CH0LCxy6VFpnRl
         yG1HfqMwWYLVUdFGVuUvNpLN33hYhcmuIPnMEbORZI6LUaxifqgZvgT6+SX5agPzqDBH
         Fn/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791404323; x=1792009123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=O4ajd1qKUyYuUsNFBJ1eWwssuwOD2W4HQfyS01t4xII=;
        b=sLRCsdi+TdBqyAXXxT0nQAyuou72gpuV3B5tenDlGYVqGBthikGIq92GRfYUEV2DB6
         4VBUb/YgNphA4z/TgCGCHOBXR72dCdfcatJVG7J8z9mJ2VCZOsGlHXBq3Y7Rfj3MSSqt
         AF4Dcwe6OlAZY92+T7a/vOmD2sKpcA0L/cs/UPNIT8C6SWOttdz5t9fV/VC3iWyLuabL
         6G+l76i+MPI57IH1Tzl81dqlscSzExPN8FSVTlpCIusRy0yTu6ptRviYzOQJk8IKKmwh
         OwompIRDvAwtO0h0zewYI1+gdFwCP5u6da21KE2H5/94Qe2ohhqhCZGB5b5rtJCWILgC
         nMpQ==
X-Gm-Message-State: AFq9FYKVJhFFGGeRouvw1wocwe428J9d7sSd4ihxiatK2XzXWte6Uja9
	Xt7PEPfzHIrJjRR8yEHjJXvCshim6vrHO1RG7fh4vgk3+qS3HYrrA6JL
X-Gm-Gg: AYBFou1RY+jWO2kZjggbh4yUyZRqtr56fdVH7MeBtj5Ymnv5ZfhyaDw5DnRD090pgtl
	6GjYhTQwtay4niKeYuCg3PIDNmSdVVELkzy9Mr1FnwptdKnWkG3WcBmAO2wqVlRCla3me/Wsl8c
	NidcEyyn0UugCQDfdypP+IQgoAmOG3qyNqOBWu8D9zChVaSYDLnf1Woj033vzHEsBondUmTLBgo
	Q0CHt+22fpZe/7ovd5jHkd2M73ps7H38/+l5UvO6dpB9lcBhqrwQZYQDErovqp7ZhKYY5gbRScz
	5XuqDFHxXIWKSOEMoo+cit/Bv8gtQAQ7PZAejo+dvemmI7AFtTXnqROmvLPEfkAcKVAwwsG8pEV
	NsqO0ADejIJjO2ECRO8BfjazO2Ggaok3OI7NEvJKJaqLjdvX54my/E/g7cDCfRLl4c4C4F1BHUG
	5kzoRynS5rN+jJQ2CnsMLVdr5U62wFFGOXPRF0RdSU4NVi8ApqRgEibuOkXf6D5r0OFRlJB8o/p
	giHYtx/ySKRLWOu+o/I9IFWdKSbVMML3wIj1hY9RBiLR6fat5rpJDwiY/1J/YfN8hGdGft89w2o
	aF3N+D8/ydoogw==
X-Received: by 2002:a17:90b:1344:b0:3a8:7bbc:3f3e with SMTP id 98e67ed59e1d1-3a8a1b0071cmr3203301a91.41.1791404323214;
        Wed, 07 Oct 2026 13:18:43 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com (c-24-19-224-150.hsd1.wa.comcast.net. [24.19.224.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7ab034sm967623a91.4.2026.10.07.13.18.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 13:18:42 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
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
Subject: [PATCH v15 5/8] cxl/pci: Factor out interrupt policy check
Date: Wed,  7 Oct 2026 13:16:38 -0700
Message-ID: <20261007201828.952-6-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007201828.952-1-anisa.su@samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
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

Factor out check for firmware ownership of memory event logs.

Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Richard Cheng <icheng@nvidia.com>
---
 drivers/cxl/pci.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 4867657f5526..7b754af2168d 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -640,6 +640,14 @@ static bool cxl_event_int_is_fw(u8 setting)
 	return mode == CXL_INT_FW;
 }
 
+static bool cxl_event_fw_owns_mem_logs(struct cxl_event_interrupt_policy *policy)
+{
+	return cxl_event_int_is_fw(policy->info_settings) ||
+	       cxl_event_int_is_fw(policy->warn_settings) ||
+	       cxl_event_int_is_fw(policy->failure_settings) ||
+	       cxl_event_int_is_fw(policy->fatal_settings);
+}
+
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
@@ -662,10 +670,7 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (cxl_event_int_is_fw(policy.info_settings) ||
-	    cxl_event_int_is_fw(policy.warn_settings) ||
-	    cxl_event_int_is_fw(policy.failure_settings) ||
-	    cxl_event_int_is_fw(policy.fatal_settings)) {
+	if (cxl_event_fw_owns_mem_logs(&policy)) {
 		dev_err(mds->cxlds.dev,
 			"FW still in control of Event Logs despite _OSC settings\n");
 		return -EBUSY;
-- 
2.43.0


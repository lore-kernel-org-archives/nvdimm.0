Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE5A3909B8
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 20:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791404323; cv=none; b=BSdg+adOzYjN08+suXHzbsgrD7GsJcI9h1N3zXgeLwq1itKN0le9KsaWcMrdxmtfnRPnoWOLqrfWfSdPv9U8tVkKKnARzsrpHvUIrYJMIHSVGkPK33AnD56guB4pRXmRK50OXU7VMv/hzacXdAKwIXehTphRx3roHrCIDDrqCsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791404323; c=relaxed/simple;
	bh=1tLVbNbDl7HUDxUPwAgwX4uqgjQuBujm+60EP1X9Ssg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTTFTOeLgk/V3OAi/qA/Q890lHrHp8GXv8w90uMeJJb1dWte+mxE7DbHzhoQGbhLrusgQNln77YC9k63hTVIuxCODryuq/Ywqbhx8WZ2OxYDFsZqDifZ+KivllDLLBCr1aYCvsJefx7M1Low4yYEvbG2KXg4f/nenztXurFzPJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XJNg7K40; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XJNg7K40"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-39647aa9d52so20554a91.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 13:18:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791404322; x=1792009122; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=98oKjZ2K1yRfCkrJS+595quXtp5aYGeP0oglAScHwVE=;
        b=XJNg7K40ezDv840M8ZezPLItctBiJgR8kmLwPX3DVCxXoGvIBsZ4IMctDwxdbmPXky
         u8xmxADBzCDQgNs0bUdl5GKHgEv0eplw93o2/pp9C2dDYR1s3Y4ehsWSgewEh6Lgg4ob
         zgXdQHsQUjSwrb4AQJq+S2EuwLO91yO/aQQkHrpNdXAR5c2lufb70NrRqCxnBowu9pzn
         Stm+niOTLbU4WsnvhGBxiphvf2cxSYGhztnYb/hFDQf9Hr7yig1/mNIqRxKdWUO3QTNX
         8PAnbjvSM2cvtTNWjEcTTVcYfrrH8RDCIhQ5YEmqVBvxjr/d4Fp2+sm/hBH4t+d1bifZ
         uQ9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791404322; x=1792009122;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=98oKjZ2K1yRfCkrJS+595quXtp5aYGeP0oglAScHwVE=;
        b=M9o/G3MYA9l69uvP+pGDM7ZcstC/0YsclyEO0MCRQ8UPKjDBIGFR5ZU7bGZV4iXvrK
         MnQghtbE2p4O8l8uNNCZoMfocTaWOk+fJJTOgXuW7pHeJt0+kxXiUobeVvtTg2xDlLPo
         h0xOW5u74HsEqt1/7pltyKVtd/E8h4Y7frgA29KYe9l1S4SDAuNI7TV7517+DA2Nq0UF
         Z5FZMbdSFZspefJ4JUx168NMrr5tmSkwUukKBOirB8SLp3At+plYlytiQtZdXtdgSG2E
         VNBMIUoqKAXpvTJB9TjDeypwl32L8SeIOcV/55ANdZvfXVpqtDlN44frM9ERJfwAMkHk
         zHBQ==
X-Gm-Message-State: AFq9FYLjpeM+zjGucEQKHXHzK2A2IPIyWIjTBtaBAuY9aYBlMUSELpK8
	C2iCy8x0GdxhbXaCXOtsZg9Iw9rkIvybS71457MUEoT58RRrSOJs02m0
X-Gm-Gg: AYBFou0t7FP9MmgOE4dlj4Q8qDASsjitO9XUaa8DzQo55XP3KNkUqw4pwROUPNiP1IJ
	rMz0q8A3HjdnZNbEn04ukTz/iOdw6S3zifbfka97utCoCVVwYl2ryXL6wYuuPG0Mmy9PIOpevzf
	B20U6S0B+2Kw7YYdzzDwpfd4OmSj2T9BybAOhxAtVcZC7kKflEEZg31GfoBx7eKTDa1h7vEbam1
	zoTLGe3FUXCADG/PFFCpFTDGhf9r4NppX0c7FSyjv5a0fNKTUd6hNx5ObK5Oehgp0SwGB8yT1My
	KccqVmArDcHL8RgfdVT+7BtTshibakEaZHsVkwx3D4+bc82+eMCmiLDfoZ0inMXhQ4sm3m3iidK
	BuFSgASwq4D2Co2rkNoeEp0gQjq7lOz7Mx6xvEEPX+dK8IMC/XKtYluu8qWnkA0ItoKvuDRFqWq
	bDB9idjB1KucU2AgUbQYHEl+ur1FVqiDPXS0JDAElzIT782OYlDRBF7RMsBOuZwT0vouAyvq3OZ
	uXegbC4l127T2Q6XyttB6AYf7bJO9K46iFu3pQ82Zg78A0dQtS4YXUlzX8MzzQ1c07MEPMNjlB/
	/pZ5Cz7uMnUjJA==
X-Received: by 2002:a17:90b:2789:b0:3a0:c85a:ee12 with SMTP id 98e67ed59e1d1-3aaedba393fmr139084a91.41.1791404321274;
        Wed, 07 Oct 2026 13:18:41 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com (c-24-19-224-150.hsd1.wa.comcast.net. [24.19.224.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7ab034sm967623a91.4.2026.10.07.13.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 13:18:40 -0700 (PDT)
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
Subject: [PATCH v15 4/8] cxl/events: Split event msgnum configuration from irq setup
Date: Wed,  7 Oct 2026 13:16:37 -0700
Message-ID: <20261007201828.952-5-anisa.su@samsung.com>
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

Split cxl_event_config_msgnums() from irq setup in preparation for
separate DCD interrupts configuration.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
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


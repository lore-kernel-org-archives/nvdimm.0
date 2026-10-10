Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEE239A7F0
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:57:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791673050; cv=none; b=otbS93NLUtjYKp3/8zKkZ2jSvzF4Je+D27aJPHjttdn0uYuI1+c8gPZ/wEtLdLmru4ol77SYjYl0dQlpI40gKA7SQW1bZv2aCdUhWJnmyF0dTXxSJ+6ltF8LQ5mtmz3kSFb3NX0lh2HAx4aHXmzpiLcmUOnjGruRAx06J7mANe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791673050; c=relaxed/simple;
	bh=wTrXCdV8AzwxSn8/wumycYvIi/3KBkGCkcB7oOa/3gQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MNxlT0zXKqDC8EBHwhleUTTXPTw98KjJf4R9GVRtJWpTt1TDhcYEGVhLTmDOzROXdLnsOF6SgcbXydIjGlMw0VFnv4zyGYUHkObbGtdOV1xYWvLr51y1ZUSMkeQh0mMLascO2lrLGBln+PqBJkajP3Dt0whXa9jDMgiyqxnyoGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RehviXH9; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RehviXH9"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3a7cfe8f761so1841382a91.1
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791673048; x=1792277848; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qdsV85v5vqXCLh3/0lUrvTrzvLjiTUom72JURhklJHg=;
        b=RehviXH9eHkxaucV4Fc/7sWL6kaD8QFyflJ0Myotcz8KD6bn8yVW9xnC6Psse95hhi
         sUBs6l8ftLsAvwNWjM33+4V5LCS11ZvP1Ufd/KY3ltylOtj++pHyyFeINhrKpSlClg3G
         1elEPi0rnPvyF3Q3ha65GNOC0EH0BlFHssKqGm2ijY674I2HCTHwfUS2maYZ0JL8zpgD
         Zu8zspd/aUIRarAfmQJvigLJ/GSjgx5ELxkWs8OU6C6xvNdEI639VCXka4w78ebG9HZS
         l0COBChIMfpEx52uJ8L5n31fUSPmBP3zhwU3nCGmjiJjS69M3t1fJBxjj8PzpDBXUt6m
         62vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791673048; x=1792277848;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qdsV85v5vqXCLh3/0lUrvTrzvLjiTUom72JURhklJHg=;
        b=aRXUnPwcEV4LX+2fkRtyjVK1MQeM6FciFz/nuMynH4oHsQREt3syQ4QaBfSX4+f+bL
         I41s9IwuWMFSnYIhFRZJzbfkK/TNSLqTa/uM7D3hSxRPStOFpJ/JjCIvqyJRPx8fm8TS
         u+wjw2SKZb6vzY/7Hutu62vOMX2+JsXKOEWO3S+eqiTmw1wEHPrBfAdV+RTsXDSebfV2
         AiJyah+91el1yEmB9G2ASl8XwLhk+pst0IDPsBLmZcUpk3cOp4MWJ4U4Vaii2ilucQgZ
         WtLXskiCjZnVDjlYA+Gf1bOFpMojFFdInimVhuZiT0Lzou8/dolyXdDpa0VUeeZN6VtF
         Ln3w==
X-Gm-Message-State: AFq9FYJg6F6u5PuirnlpaUS33P/yueY2r0aPrBj/XgRhmqjXJSSFyBVY
	vUdcVQNZfEKHKMbeSR8XHZCIM5TtmhvlMp1JDJ1lNIOvvu3ax2t7NoMt
X-Gm-Gg: AYBFou0tbv1CJ6gB9OyXo8hHaBNM9Yi1hdcN4QarABYXBP245sKQ0WBNOgKtSMb0DUE
	pdjsHX0MRoGC6l/GiUwQg+STtMTN0eaASQLadsJToI4WZMPKPu3WyyYGP9VXFjtepX0icbL7ZIz
	yr1iZJai2a79Pb0hjrKUWdOuJSXc3v0lZ7t7ZbU3LzOi4Ukko3+n79d547eJwX5rKZFJdyWj/V3
	/Z86TiZSKZ9n315BdkFV0FfRO0j31vf1j8DY6unQsRPnQMyiHZTJfV1l7Kn0/7r1gnNQEYJOYf7
	g+n9+bqaLOcx4EqYdzQLfIvsAHr2vLkbO8dXplqGoPcJEIZR17+hBmQVKrF62SLaN6AcMmEe4Sz
	IH0Q1/QGgX7A9zRdxv1laAUMmXTcfPr3F5b5N0+pA0WGz1Y4WMmNKKJ3lAPusKD0U9vd21+hjCZ
	9+6ONAjNmGTFSV2dkabfVFgwUIJRBe7VufZCZvrA4jAPyLlLihUKB1Zbn6g4Q+I8ajTx8jyy89n
	/i93+DBk2if9vqYMhw4tqoFSTjqg9OMSISwAoI=
X-Received: by 2002:a17:90b:48cb:b0:3a4:cf85:aef with SMTP id 98e67ed59e1d1-3ab36d637b6mr4475092a91.25.1791673048079;
        Sat, 10 Oct 2026 15:57:28 -0700 (PDT)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e07329sm2603662a12.5.2026.10.10.15.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:57:26 -0700 (PDT)
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
Subject: [PATCH v16 5/8] cxl/pci: Factor out interrupt policy check
Date: Sun, 11 Oct 2026 07:54:56 +0900
Message-ID: <20261010225852.10727-6-anisa.su@samsung.com>
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

Factor out check for firmware ownership of memory event logs.

Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
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


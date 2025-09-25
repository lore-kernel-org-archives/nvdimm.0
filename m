Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5B7C15530C
	for <nvdimm@lists.linux.dev>; Thu, 25 Sep 2025 06:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758782707; cv=none; b=SqZEYCgVM8MUnrQ7cB7aKyJdV8pj8Xa+WE0TfcmGC4Aaj8qRI5DOLthXBfhQ9x+lMGn/XRwkqgC/xdKU/TENEmVBInyLZwjnrFAWs1e75BeqBm8AUNl1/seG32yPoHiDLhMtmEACrucoS+SK0da5PJlUDtrEA/FUMtzeBZcbRac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758782707; c=relaxed/simple;
	bh=bbqdLAvx27nbu3tvSbwfNO0qFRmAy4gvrfSqHxZwiK8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XgOMs5wR8hZrobVD0YIdO1tURqxTTkg4H2Ir5sgFtXNuRDGVYJWgCCgDpG7bEM+D/XEqzWsmBLLes9l70faqR7c+aydE0D81DmiVkYRaBOFt1//8Qup5BAbha9JdMy+WmQUXJ4fzaOQws9gT5RUZ/cni976geRqVk8zaXQQPKsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R/6iNCZS; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R/6iNCZS"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b55115148b4so487155a12.3
        for <nvdimm@lists.linux.dev>; Wed, 24 Sep 2025 23:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758782705; x=1759387505; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qwRwggwBb3rmsP7hAuRkEzNpFvdy0j6v2pW8m7D4xoA=;
        b=R/6iNCZSaxnxo82vstu91HtxoI3yV/TrnmS55f0WD0b9TQQbSfjrT2J6lJe3dHm8F6
         u2eeWz8G/zipJRYqpEl0V3TmcmBBsVDz9ss445sRJs82OCXfHholaIS3spYerok3LAYq
         BA5HmNO31DhjSBoL+l4jPUtblCeWx4NS9PDSX9c2cgnDEqNBtWP79DBXg/KB2qBA5fJB
         48Ij04kyRNM51k0IhDG0UL5/8XnC8jRyrYMQxp+BqLHQjp1erovXMAF/v90I/jamm09c
         0NdW/YGwCnSmpimqFYYQy/13gCXJVHkfT5rPqL52rPFiBr6TpyndXMhgaCjUMYEmssLg
         z7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758782705; x=1759387505;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qwRwggwBb3rmsP7hAuRkEzNpFvdy0j6v2pW8m7D4xoA=;
        b=KM6gFDgJBfpFN8TTAxosRuSBcd1qGDJcX1ZMaGp3d1zDr/Vo+ljG/9pJ/cuqwbG9le
         xFrq39pXaj5lwiTPWqM0kKeBt5/CR5xJM0G0FeZNgtdSvW2f+Xzab+ieE7KTpQPdKUk3
         8l3LjGgIZT5HmnUsepKltE0td6hjWrc/96xMpRxo1P2VJTm6ZcWXZipKiBsyPWHTWuGG
         To7T6lXwi9SleUOTBsPDeqlshUH4JG3RUcqH5+c6EvBKb//krnKoSsPJ+/ambHoP9JXu
         yJCwiJA+dVXfJ9CN/kd7A55d1hD6AESJI2GO4IPh7/uJxUcCoMbJAhho9bTvWngG1G6H
         7xsQ==
X-Forwarded-Encrypted: i=1; AJvYcCU+5AU8+Ypp9g2JXrseKNvQn/fwHehS+tVLmHk7x7IlbYXsE2oOS4o34wK5ZYTc65e4GUEpStw=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTckhYXPL1pulmRa2S+GiZkKPvePoDB8E6QVvnw+EbCNbZ9Vrx
	uE+KLNa2ooXfIy7k+b9RzD9eRpQ03VbCaKnGblcopLjc1qRagJXmwyKc
X-Gm-Gg: ASbGncv+RN8EIlj+cfDLvk7Cnn6pXsGtIrL+w2M5KmLWVhwcOJdZ61EiIoKURB7roOc
	Q3SSq+/HLzwqBuIwZTKEaqbYAeMdG+4nYFKe2M+d4Czobg3MfcbtP/xvkcCQS7rU5wwmDwzAg5V
	CVUZ20zZYEK3EIl4o3ha3pdpKipEEIr3PzX1IrcKefDuTjW8oZxVAKpUwiX4Uvy38sdgCzH/7cG
	qpwbQpTNtkeEx7hPl45fTxrtykLrEExbBR6fYK77V7NwZdA5ZCiPVVRnTonM1z0HsEVB+SfbucA
	rxQvRqzsWwH9XdUEBGPv8oWOS8JkAMGpgMjkCEt68ISgczsNT5bXyg8dDyPMfIlqsyCmkQ5nuGC
	6TL0Qa3RGb3x7iiqGlkq1VsD7hK515S2SkWY=
X-Google-Smtp-Source: AGHT+IHt19jtOEnBkeB66T1h510FySIpowgoYjHbNvNGdh2zxGfDHDDIanQQL8ZzNs+QeMAQPJrNJg==
X-Received: by 2002:a17:902:ebc8:b0:271:6af4:15c with SMTP id d9443c01a7336-27ed4a91a97mr31723675ad.36.1758782705016;
        Wed, 24 Sep 2025 23:45:05 -0700 (PDT)
Received: from lgs.. ([2408:8418:1100:9530:1f22:92a4:6034:d4c4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-27ed6ad21e9sm13507665ad.144.2025.09.24.23.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 23:45:04 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Santosh Sivaraj <santosh@fossix.org>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
Subject: [PATCH v3] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails in ndtest_probe()
Date: Thu, 25 Sep 2025 14:44:48 +0800
Message-ID: <20250925064448.1908583-1-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

devm_kcalloc() may fail. ndtest_probe() allocates three DMA address
arrays (dcr_dma, label_dma, dimm_dma) and later unconditionally uses
them in ndtest_nvdimm_init(), which can lead to a NULL pointer
dereference under low-memory conditions.

Check all three allocations and return -ENOMEM if any allocation fails,
jumping to the common error path. Do not emit an extra error message
since the allocator already warns on allocation failure.

Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
changelog:
v3:
- Add NULL checks for all three devm_kcalloc() calls and goto the common
  error label on failure.

v2:
- Drop pr_err() on allocation failure; only NULL-check and return -ENOMEM.
- No other changes.
---
 tools/testing/nvdimm/test/ndtest.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 68a064ce598c..8e3b6be53839 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -850,11 +850,22 @@ static int ndtest_probe(struct platform_device *pdev)
 
 	p->dcr_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				 sizeof(dma_addr_t), GFP_KERNEL);
+	if (!p->dcr_dma) {
+		rc = -ENOMEM;
+		goto err;
+	}
 	p->label_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				   sizeof(dma_addr_t), GFP_KERNEL);
+	if (!p->label_dma) {
+		rc = -ENOMEM;
+		goto err;
+	}
 	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				  sizeof(dma_addr_t), GFP_KERNEL);
-
+	if (!p->dimm_dma) {
+		rc = -ENOMEM;
+		goto err;
+	}
 	rc = ndtest_nvdimm_init(p);
 	if (rc)
 		goto err;
-- 
2.43.0


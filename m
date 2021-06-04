Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A211E70
	for <nvdimm@lists.linux.dev>; Fri,  4 Jun 2021 07:08:56 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so6919061pjz.3
        for <nvdimm@lists.linux.dev>; Fri, 04 Jun 2021 00:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bx1IMpPvJSEx/CYsOWeEb3w/W5jZteIIsuNuR4r+SVs=;
        b=lCNer6mYvuXGI8BUJau+IM9EMFY99rdNgIK3E1kOZNFFzqolGbODIrnHFcV67r7heP
         yVIi+4joboFfFXn1DyBXfd1q61Fp/Gl4sEJWQpGuajmO+wnKiw3gFWqDvXKIvjoc9iOA
         SMjbCU/l4mwtEGZDpQLcWzzTLzln3UD6vOEKP+yNsulXY1ukag9dbdTKygyOZszKbkuP
         6Ml2tqWH/WuxEX5GuJRHtP/JfrX/jLmMmywAS1rXWqIfN/6TIYHWqOPDf4z92Ntrw/52
         T96FMA5R5kTJd612WY3xOpAc7zNh75/gMduG+T2W1NqrKdB9iMiYPlXxfyR+G4sYS4/4
         JX2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bx1IMpPvJSEx/CYsOWeEb3w/W5jZteIIsuNuR4r+SVs=;
        b=BZ3v/AmpqkXVlq44mRM5XxHrT7XLaz/pSbIv/wKKSNTNeiudd/0pHh6uldahU3cHFw
         qBEaUEkPZYdd58IFT2EFdl3RslaRX7u6e9+sj6JRTODQ1ZB0iOtx9Qosds1NjmXrzSgW
         MKtat7G1hwT8KYp7YtXrWSMc4g3jlvQZtzwGmo9sVOAA6rigSnMDzfEExL5EKB8s/CmJ
         65l45YPck6z6xjTEhC8bO0rZkFBs+WUnq//ckuchfAbLM48lI4fdtwLSFopX67tv+nUT
         x2PcAlboQbCAJNvOmTVTYeOyMfkFh9cwU3ZFjFxzoThX4r0L3/BVxpLiWaTTkvoZ8YGa
         t3Uw==
X-Gm-Message-State: AOAM53355KRm7g6AIbLy+PbTlS63Jpu3KeXoNhgZMCcFpDDFmR8yhkQ9
	0kpqnr1CL1yxjSQ5d+4USVV7HcrdtIFQ5Q==
X-Google-Smtp-Source: ABdhPJxBlryqkZZAK0mSV5HFFDih0EExRuYlh4XL68adWlSfFJCdOthXfRZpkt84LEVRtlpd17x+sQ==
X-Received: by 2002:a17:90a:4410:: with SMTP id s16mr3266427pjg.25.1622790535954;
        Fri, 04 Jun 2021 00:08:55 -0700 (PDT)
Received: from desktop.fossix.local ([103.21.79.4])
        by smtp.gmail.com with ESMTPSA id i8sm1091647pgt.58.2021.06.04.00.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Jun 2021 00:08:55 -0700 (PDT)
From: Santosh Sivaraj <santosh@fossix.org>
To: Linux NVDIMM <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Santosh Sivaraj <santosh@fossix.org>
Subject: [PATCH] nvdimm/test: Fix corruption due to memory overflow
Date: Fri,  4 Jun 2021 12:38:28 +0530
Message-Id: <20210604070828.2747433-1-santosh@fossix.org>
X-Mailer: git-send-email 2.31.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The test allocates memory only for 4 DIMMS but more dimms are
configured, due to which the module crashes on exit, strangely
this was not observed on x86 so far, but very easily reproduced on
PowerPC.

Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
---
 tools/testing/nvdimm/test/ndtest.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 09d98317bf4e..960a37aa3f07 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -22,7 +22,6 @@ enum {
 	DIMM_SIZE = SZ_32M,
 	LABEL_SIZE = SZ_128K,
 	NUM_INSTANCES = 2,
-	NUM_DCR = 4,
 	NDTEST_MAX_MAPPING = 6,
 };
 
@@ -1606,8 +1605,6 @@ static const struct attribute_group *ndtest_attribute_groups[] = {
 
 static int ndtest_bus_register(struct ndtest_priv *p)
 {
-	p->config = &bus_configs[p->pdev.id];
-
 	p->bus_desc.ndctl = ndtest_ctl;
 	p->bus_desc.module = THIS_MODULE;
 	p->bus_desc.provider_name = NULL;
@@ -1667,14 +1664,16 @@ static int ndtest_probe(struct platform_device *pdev)
 	int rc;
 
 	p = to_ndtest_priv(&pdev->dev);
+	p->config = &bus_configs[pdev->id];
+
 	if (ndtest_bus_register(p))
 		return -ENOMEM;
 
-	p->dcr_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
+	p->dcr_dma = devm_kcalloc(&p->pdev.dev, p->config->dimm_count,
 				 sizeof(dma_addr_t), GFP_KERNEL);
-	p->label_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
+	p->label_dma = devm_kcalloc(&p->pdev.dev, p->config->dimm_count,
 				   sizeof(dma_addr_t), GFP_KERNEL);
-	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
+	p->dimm_dma = devm_kcalloc(&p->pdev.dev, p->config->dimm_count,
 				  sizeof(dma_addr_t), GFP_KERNEL);
 
 	rc = ndtest_nvdimm_init(p);
-- 
2.31.1


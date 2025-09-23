Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABBE322DB6
	for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758632416; cv=none; b=NZSfKTdpCvfyD936tT5GFk9ti/wkYIr/cOqk9DI3X/lKQw9NlyJSUbJyC2bOweObu8uPvsrxlaPMrx41Mcbd1NMJPZuoiayGfz8AnjqcsawhDadiLnBoHYX3Pho1aiwlRjafb3jkcb8yRN9WULjgV4NMFj54ynlQO7k+37IvUtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758632416; c=relaxed/simple;
	bh=fpgqG3PPMbLAJYHf4nYwntPFHa09JCf1vAbUPv7WyK4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cP6q/FJgjhyAlMYfR4zU3y5yIGmCMHxD09m3vJz8EBSzy5t4lHS0DNP1dfLFvuS8mIPAvSCuX5zRKmGZdb3/RuLVKHAu1lGgs8cYkb63Edbgqd7PW/x8+BcnfblkBGkPDFO3W0dBL7RxiX5O+11nYZu/zFnM3e0nkUmES92rZjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JxgFMIwv; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JxgFMIwv"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3306b83ebdaso4786244a91.3
        for <nvdimm@lists.linux.dev>; Tue, 23 Sep 2025 06:00:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758632414; x=1759237214; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Nh5SwzIzASTLhVaTpXrHPJRdBlRjDqtp1v+iQDlbfos=;
        b=JxgFMIwvOozNZZ/+F4dJRAY9BTZdp/estKIMP8lOtlywQ30JZbgyOmekKkkPqjvU01
         NIWHgUVbHqE4L/3UOJxQ4Q7q0iUvFq8AxZntLHhZXdsYkO3CfQ+VcbfWUSmUkVZqk6ID
         FJZV9QpJNNPq3pTdDmd/XrLKaEkIZTPLRtAhjoig37pmDG1KRka8IJYJAgladE6e+Bcz
         8dfotF7wor4Fk7W0R870thSdgDlZ8nCt4na7Z0pU4rzkYySLrnC2oJRcWMj6NN76DOzw
         3hFYwXez71EkgEEAEJnKLDs2QJbZhQYXi1WbSJwkyti+AQ2ejRNKAmNjWjM8+nEYpZ5X
         ARlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758632414; x=1759237214;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nh5SwzIzASTLhVaTpXrHPJRdBlRjDqtp1v+iQDlbfos=;
        b=UJGU2siOYJRMBBU49q+vYUKfRWMeNF229KNSiH4pT+c0yi5ckh6v2FC8ZNz5+h+fIb
         zxMH9yd5rU7oZm8vB8H8TcyvyQxnDh2Uubw7/fYE22RnRG+daVt837Gue6+3dzaumavw
         Y0Iw+p1osMO/bvhp53xsdOM3r0BdTgl9mjjrINsSt4NlpPAw3qJUg15yI2VRPH66EUlN
         2NeTq8BC7FpdjNFsL3kAv5IjOZSFW1Hjhc0TB+2dPduVD2qjZUwezGsBrfTRDRGoFxgN
         3gZT4xL4J0k0aGR7XziNaENLo6dxDGryXKujcNV2B+wdjVgMcCZ4REwZyrdfbjTnH5SD
         kN/w==
X-Forwarded-Encrypted: i=1; AJvYcCVfvMTdSf4hKiHyhpZM/QXksSVOU9JlUGnRBewxW3LXUU5lTgIZe6IilGTIgfAhR3wv5e/0e90=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5Y14u3SaIDvZZ0uQwdY/MSLZgKQvUiaQR2Hh2YB3bugWeSNea
	LcSD17XC0bDLfiasO9BMAQqqmfS6qmCwxD2zZcCuL2dRvcceDtAOtgqr
X-Gm-Gg: ASbGncsQvTQaPn0OB5nmkUGfodK7QdsNlU4LcPgBR9GOy8b4miCJQCx18ucHWvYaMho
	RHzGv2EB0MCpj/RHCLs/Yg1FDOFGh9VblfkuTEtLBlnwb3kWh+UcoQfeFNynDujtcZbonizvoqT
	FPS1lvStGbsoMaioZSu3wWuHuTgVdUzeBZIeHcdm1znwaltH9NKTie/oAV8tPm+fKUU3uU6/xK/
	avo3IuB4akZSjb/oSbPxvOyFSMCb29Ff8JCLBFe1hDrns+dIL2Zj37UldUSTDzNSf2zuFcc/6BM
	Y/RkJK0PU8dlsR0GWW8PPIUQ4EYK6ElfLnMhAio3OVQKN5846cpdkVakIHfKiEB+IRcCnkWQ01O
	JbN2bTXfQaSLtWU18s2OrVXd+LEf8OJw4xg==
X-Google-Smtp-Source: AGHT+IEVwoSV/1C7G9K+WLOLmPwik9m4PPFJYbHnIWzyucU6AzZaAx84ogTIVfkz9b6BwPzEVvys1w==
X-Received: by 2002:a17:90b:3a8a:b0:32b:c9fc:8aa2 with SMTP id 98e67ed59e1d1-332a96fd4c8mr3170726a91.20.1758632413614;
        Tue, 23 Sep 2025 06:00:13 -0700 (PDT)
Received: from lgs.. ([2408:8418:1100:9530:4f2e:20bc:b03d:e78])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32ed273f557sm19059243a91.15.2025.09.23.06.00.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 06:00:13 -0700 (PDT)
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
Subject: [PATCH v2] nvdimm: ndtest: Return -ENOMEM if devm_kcalloc() fails in ndtest_probe()
Date: Tue, 23 Sep 2025 20:59:53 +0800
Message-ID: <20250923125953.1859373-1-lgs201920130244@gmail.com>
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

Check all three allocations and return -ENOMEM if any allocation fails.
Do not emit an extra error message since the allocator already warns on
allocation failure.

Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
Changes in v2:
- Drop pr_err() on allocation failure; only NULL-check and return -ENOMEM.
- No other changes.
---
 tools/testing/nvdimm/test/ndtest.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 68a064ce598c..abdbe0c1cb63 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -855,6 +855,9 @@ static int ndtest_probe(struct platform_device *pdev)
 	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				  sizeof(dma_addr_t), GFP_KERNEL);
 
+	if (!p->dcr_dma || !p->label_dma || !p->dimm_dma)
+		return -ENOMEM;
+
 	rc = ndtest_nvdimm_init(p);
 	if (rc)
 		goto err;
-- 
2.43.0


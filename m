Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE8CE314B9D
	for <nvdimm@lists.linux.dev>; Thu, 18 Sep 2025 15:55:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758210934; cv=none; b=UYiA426kN4KqWcuf5gIvprBzY4snjH5FlRBLNz/XkCnwrpzMBudJYpbbDych9dpzgGaRrfb9fjdksWdpTD5mH3ODpZIj5lnS3wekJ4ddE9o1hBUlISuf820SVhYPHlm7J/OzveaWg1bJOeCYuh2Ar7sZ+LfHhS3u22IBYLjsjRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758210934; c=relaxed/simple;
	bh=9NHi/2Cce6YtYupIQCjuGL2CK/BqjDprlX3JyUrBZ4k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iKnIL0wCO06hsvfha4r+2N5/AS8biis4yTWeTx/SKF6WhBs+U+8IIJutl86hDo0Ewj+L7/mIoTvBjzAIIaYHn+jlRHplENy3Cns1T+ZKVwRx0z9UIOUEkMmIn5wv/IQaumHhhRN+jsNltjR/sfhrrDDUqM51tyauNwCuMGk84C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Le2UJJvB; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Le2UJJvB"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-8dd35d9d574so855735241.0
        for <nvdimm@lists.linux.dev>; Thu, 18 Sep 2025 08:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758210932; x=1758815732; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2Sc26hxDTkdtCvz76lZc7JwNfgd5ybo+08CIFSOrjwg=;
        b=Le2UJJvBYQs2sJl1CaDHkJpkVmkjtDeqWmc28nRAkkPgfjYBmscMDHTlM/8K6ZBeln
         LopLCqS2FZsUyk7p341e8Tp8KM6KjIV7Vk4v9+LRETpWiN6j93qCyH1EwS0Q2UHwuCSM
         cqn5wu769j3Z/iaagh/yUVs245qM2oSa5VphN/bXfsOSxseYTUHbRMTsvpQ2u93QznJr
         P7BA6LVlzC0fzUUKom8o7i+yNGVkLMu4NokBL8r/LNmEiUojiDJ57GVoDO+GCeC/SDp2
         reBU7Xd7315sQqm7naSZS+0R0PFX2KXmNHUjnJeLIjoLXLG3OP7vHOlzeLHiwHfsvpU9
         rffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758210932; x=1758815732;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Sc26hxDTkdtCvz76lZc7JwNfgd5ybo+08CIFSOrjwg=;
        b=vUKJpXCya7quCU2ycke27myakscIvik6XZGrXEQWtYer5NoZJ3Qow7Cfy/7ejwhaoj
         nt58TYttunkDZPMVJ1BRHRNlpFHUAjGzpatLnluO98MockC0p5/DKGLxuHW8JbQFG6ZD
         abq2/dgrfhKdsk2VXEbGCX4hiIPUEOLE+OrJlPoc/TuJ0Gyw5AYHnxLScpBgHuue1ZeN
         2dNnJ+8I2dIQvxR0Si7HoaYw4qh5CsW6zK/Z1gksF1iRLmcntworj3m4UL4KmKQigXz/
         ryYslTAq0UVaAiyeXm4h9M7lXYhjlDodZfRH/+IxWKKG6w8ynsj7QcEn1YV7OWwBx3WF
         1URA==
X-Forwarded-Encrypted: i=1; AJvYcCXQrc0xQnVpnzqB+vBpfmnnwDFx9+RgI/FCYlJ+qt8JRss9/IUXRAO+Mqwjd2doDRE0HyOzBb0=@lists.linux.dev
X-Gm-Message-State: AOJu0Yysb3HvW85qyz0RcwjgqBhCHntDd6odwEmAK3SUl/Un2UUlAKO0
	KzMOwy74b2o9TE/9ZqIPAhj5rlR1rvR0X/HKpPzuiIR5hm7QVjAfS05NOMtfulFX+9c=
X-Gm-Gg: ASbGncv/jdZUWckoryK2aoZXJ23D6Wsy9Rt0/kRZPI2sTnlxkchf2Taf5Y8WbqofMdl
	6PEaHlZSqP1prsOrp29fsBc2Ub353Oxy6W/cTxCXWCUDseUv7tFDth47EWHXOq9PN0iz5LUYwNh
	cOSnxE7LuSsFI0p08Fe1xv1tC2gBhCb+S1HFU7S8epTJ10OB42g3nKAr8zxmlj75+rb+flkW2OL
	kb3vF2Wi3cXWoUhh1WqHVXkL3T5mI6+/l8dKoEuGM3nGX4v6jlzpgVu6PV8war01DLnbnLa+Ho4
	zVwceGmC34b2IQXI3x0J6fADwVklaoxlF5gFSWHXiTUOvbVNw9iaBHwac96g7QuPO+A/Kigg0RR
	dX16c74u1hmqgb+45of62QuI++uw9wBdsQZQUpIfX1w==
X-Google-Smtp-Source: AGHT+IF9suJfr/TckXhc3x4V/Ham0gaboRPTGKUywBt8FfSoHGxa1LjxFJVx6FIwVN06VaKFltF9Bg==
X-Received: by 2002:aa7:888e:0:b0:772:499e:99c4 with SMTP id d2e1a72fcca58-77bf926881fmr9331092b3a.18.1758204996072;
        Thu, 18 Sep 2025 07:16:36 -0700 (PDT)
Received: from lgs.. ([2408:8417:e00:1e5d:70da:6ea2:4e14:821e])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cff321237sm2490376b3a.102.2025.09.18.07.16.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Sep 2025 07:16:35 -0700 (PDT)
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
Subject: [PATCH] nvdimm: ndtest: Add check for devm_kcalloc() allocations in ndtest_probe()
Date: Thu, 18 Sep 2025 22:16:06 +0800
Message-ID: <20250918141606.3589435-1-lgs201920130244@gmail.com>
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
dereference on allocation failure.

Add NULL checks for all three allocations and return -ENOMEM if any
allocation fails.

Fixes: 9399ab61ad82 ("ndtest: Add dimms to the two buses")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 tools/testing/nvdimm/test/ndtest.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 68a064ce598c..516f304bb0b9 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -855,6 +855,11 @@ static int ndtest_probe(struct platform_device *pdev)
 	p->dimm_dma = devm_kcalloc(&p->pdev.dev, NUM_DCR,
 				  sizeof(dma_addr_t), GFP_KERNEL);
 
+	if (!p->dcr_dma || !p->label_dma || !p->dimm_dma) {
+		pr_err("%s: failed to allocate DMA address arrays\n", __func__);
+		return -ENOMEM;
+	}
+
 	rc = ndtest_nvdimm_init(p);
 	if (rc)
 		goto err;
-- 
2.43.0


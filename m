Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A23D179B8
	for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 12:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707741442; cv=none; b=cnTkaJXb4u20/WdC0LZnwrqYLMRuCJSO7RgI+f3f58k5xlTgD3dHx8DI2ZJ3KjZr0xBYrTdlFqNnMu/V2/GITuBot+g0gFeB8uc0jgPJ8gpOJEmbYhtcBkQ9YXg0e9kEXVCsFS12l+KBxkHhVNY90I3irQ1psp3cy/waAKYiMAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707741442; c=relaxed/simple;
	bh=rjGem0+Mdx3zMqtsPh+p6M0a+nK87Skeaewc5zcaBZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nCJy6HpePBtCkv2UMKLoZQQSN67YGbl+r8sv2lCspyp3MUdbPf87JffhuUn68vtPVYoAvIv5ly8Yf3jbepni5t9BXJjjPdYREZAxULbduLy4bqIYUy6Cen0jz9eJMGrbWPjhdROvB5yfFAs752gVK7xMA3lyP8JEgE2oFJ8GGq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X+ao96Eu; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X+ao96Eu"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-33adec41b55so1672278f8f.0
        for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 04:37:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707741439; x=1708346239; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RXGczKj3ihT9B0gwlTHeZymBL18MEXnrHdGuOKOcQnQ=;
        b=X+ao96Eu1lLf+jYGVsz6gOKzs2QNl0uFGMl+eYv4dG56FdKPWvtLscJbknQJ/HGGvX
         i//ie1OoPpZZnbC+5NSAGUf06F06n4j3YItTcRTfYS7H1OH3dv0BArSKwfxFuapqOptR
         wrFRvoLctNG89DG5PBsJr3IUWmBRGFpumMCYEzX+EoCwWkozRhphEOvE4BA5SlWBcVXD
         +sBOgdbaRVX4kpA1+gzhCNqHk5AThJZC7RHZxFBDQoZroMTBpTykcBdZYDLdDSDwNYu9
         z5YkFk2qBABUftPU0WSQB5+aDGqdW93U0P5rau+fP4J2Uo+qFlX+tWEx5RyRfcgSodIB
         RG/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707741439; x=1708346239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RXGczKj3ihT9B0gwlTHeZymBL18MEXnrHdGuOKOcQnQ=;
        b=ZnoZ4m4gm0a2C5yV6Z+Sd7pF7F8dyjebrJHXEwC7xehIwFpDcPbXMjuKk5EvuD6CG/
         MB1wNoqTx6wIh+m0HUb8oP2LGI8GgpisnccUZuk6WPBnV4n5X6DCZlS2WPgOqkWq5Bwe
         /jM+1ZLDTSXdfWl6Z2CdiBMHcZuV1UWzewbU1nSER2+YYXBpJieafM/olyPswizBVoOZ
         8xRy+ZDHIaYW3e8Vw6iCurI+0PG3GFTef4bldtkoxcHSPkpTKfyAbqx8c4Cqh6MWPVgh
         SAysiCKBAYiBuc0Yijk4xdcMrdxR3pwInsTK9RohzZDWULWKwp6A0AD4FFAmJhcG1Q39
         xrOw==
X-Forwarded-Encrypted: i=1; AJvYcCVPnHtbv1nC/Pv7WnH5e9/PRcdnp4Bnm2viRK/SAbNdODP9b1YgZBSrEjWlra8PdJo+IrWeILIbpF4xKWwKcpnEB79PD6be
X-Gm-Message-State: AOJu0YzOaEbCUT+HLJNaJLDBo6ALSdXGZOuk5ctyUVeTGt0I9L0IPnUR
	vO8Z8aL1B5z2XUQGsS3Xtax/5Hp8gqWlNOejMC91ZmM1wJv7D2OB
X-Google-Smtp-Source: AGHT+IEGqmdLxlHK3dpRs7HNMDVrwhK4UZNuaco4vujaL7RT5dq50AdXd9EwxI4XPPERlmxlPqsJKA==
X-Received: by 2002:adf:f106:0:b0:33b:8151:5bd1 with SMTP id r6-20020adff106000000b0033b81515bd1mr2032112wro.37.1707741439065;
        Mon, 12 Feb 2024 04:37:19 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXbvijxeyhqm8MtrIjLqp8beCE2aBE0fWT+MbAgi3CsKyOKT1Os7RDAXazUMdapqNz3acTdUUBz6S/6WILDyrfEbk+ceHXo0rEUVzg7KwM7saDq1xSmz3itU6/OO1N0YXAilkc11oyh/P6PMETlXk28QxvyNyZve6ENbgTMQDFv2ofealxKnR0jM8C/
Received: from morpheus.home.roving-it.com (8.c.1.0.0.0.0.0.0.0.0.0.0.0.0.0.1.8.6.2.1.1.b.f.0.b.8.0.1.0.0.2.ip6.arpa. [2001:8b0:fb11:2681::1c8])
        by smtp.googlemail.com with ESMTPSA id ay15-20020a5d6f0f000000b0033b4ebc3c8fsm6897290wrb.2.2024.02.12.04.37.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Feb 2024 04:37:18 -0800 (PST)
From: Peter Robinson <pbrobinson@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev
Cc: Peter Robinson <pbrobinson@gmail.com>
Subject: [PATCH] libnvdimm: Fix ACPI_NFIT in BLK_DEV_PMEM help
Date: Mon, 12 Feb 2024 12:37:10 +0000
Message-ID: <20240212123716.795996-1-pbrobinson@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ACPI_NFIT config option is described incorrectly as the
inverse NFIT_ACPI, which doesn't exist, so update the help
to the actual config option.

Fixes: 18da2c9ee41a0 ("libnvdimm, pmem: move pmem to drivers/nvdimm/")
Signed-off-by: Peter Robinson <pbrobinson@gmail.com>
---
 drivers/nvdimm/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvdimm/Kconfig b/drivers/nvdimm/Kconfig
index 77b06d54cc62e..fde3e17c836c8 100644
--- a/drivers/nvdimm/Kconfig
+++ b/drivers/nvdimm/Kconfig
@@ -24,7 +24,7 @@ config BLK_DEV_PMEM
 	select ND_PFN if NVDIMM_PFN
 	help
 	  Memory ranges for PMEM are described by either an NFIT
-	  (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
+	  (NVDIMM Firmware Interface Table, see CONFIG_ACPI_NFIT), a
 	  non-standard OEM-specific E820 memory type (type-12, see
 	  CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
 	  'memmap=nn[KMG]!ss[KMG]' kernel command line (see
-- 
2.43.0


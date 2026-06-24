Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420803D812D
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 14:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313083; cv=none; b=awkxcw/mzpEYCL26rB9jN+ECPzi7x/82xS4eegPt1jlpal3NkcZKULIfpkI5N5Di+8CgoR3YFNtQa7XLNccVud6gjbc9GVTiOiq2uFgixyA9BSmbSUtQx3Mgw9zvfiAUpaf8vcNxtOKYUBpm7bGPvqC4BpOy7D+FZYPB5NLtIZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313083; c=relaxed/simple;
	bh=nbCS8knRu9kWXO+MoSid1D8mBkTg92BavF+PIpIJUV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=elPJdzOCEav8LaET1wy2Z7dJtj4//Sv9n4/6gp88wzZEjfWGTcs48GAWq/4gjn3D6T0kIXPWX/vTRrthm51HXtW5L61ng1qhIBqJkxbF43EeMFqbi+ehChuWsyXc6qYB6p8a+Lc6+yKuQwlIgi0yiO7UdsnA/dpmkwGMryTsckI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=CnbtqbD7; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="CnbtqbD7"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-519f6a10d9bso7348231cf.3
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 07:58:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313081; x=1782917881; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zb2DpzIiqwLq7NyM2oLUvxWd/WuB3n7pHvXvXxwOytE=;
        b=CnbtqbD7Lux2NhqSJPnWJw26p+I29vBAAWRa0uJsR0RNNvgqB5oGVV5JrpzPHDyFYE
         B1+eehGIMHO4hdkCPnZhv0X7F1HdrM7sckiaregddol26cOpmtNjl0o0vVW4wIIDgFBZ
         rtQpArsVTII520U96F3o3CsNT88IhcLAVFNfP+nDT79P0W+jLnaUdKQE6CM6bqxC7c4d
         goTShxCFP4EtCMGzJuxkyF6D1mZ5DTC2s47PvMmx5VoXHFps6zLzmM00kNXweHSoQJFk
         HB6vlZIgduE0gIJtpJI8oKtykfT8jzK9RQJJWMTfoYyKQ97a5mKgAQnfGNCoJMfg+sAg
         41cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313081; x=1782917881;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zb2DpzIiqwLq7NyM2oLUvxWd/WuB3n7pHvXvXxwOytE=;
        b=pmG1KmAfNL8huqBPp4MQGAI/bvWvGRH0hfXpIbv6dhcLcz11C2tRgXwG+rBJR8YO9c
         CQJIEOhyuUi7xSIx4WhTiZbzzE4sCCUNDnT3JUMDfxl1hevRNxWxTAqPlDuf7rM+PZw2
         OHDTGW2uX3HydfPAOOq/qAWvkruWYLiaQ2kL0DvLqLk7cjgeFldkgiSXjqOCgBU2reM0
         qHB0J8JcGfJyDdWVXy//R9OUx1gQM5/9cfnCE9l6cacV1Re+znCvlWvqbnhKy+XaNRk2
         DtnDCZnF8Rgnou7Ye1d/0S6p56i8C+4yEjiZ2Mkt+HiDUm4Zz3HCnrG1qexcCNba85KA
         4v2A==
X-Forwarded-Encrypted: i=1; AFNElJ+32+DZ2cQ/MaLmdTHYpl2zHTyzhDCWodRCNc/IJNBhP6yXhPNxEJFDcX5q1ZI7LgaCF6l6I/o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8iyJnFKcv8WN3U+nuTmc96PlviHjFGSyYPybpE0gSlMF293Zm
	ST7LnbDGzmVoccXuXH9ocestLKIg26OAYbP1lOIe4/B1zTtc4rgiNvlm0zJEHVHCmjc=
X-Gm-Gg: AfdE7cmoOHRWO0xbQkzntIl4RN+2TQIl33Dpd599xYZJ/rhG0MlTSI/DbnF5elfFChR
	5X8ZY5TAjO/0TppR2/h3GBkyfuBeDwIa/ATVgai4MHL3teMB4Yj0mEEJMEsEunLB+Gazc9fDH8B
	+GJgtBsiQ1rAx8Y+uRt9D3QL3UYQFf19i8xpR5eB2AhW/RzLDeKPUNzpt9OvekrMeyoNyQR7UOH
	T13s5rv15SkOCHyWdhkS64bwwj//j5hyh3RNKdvJJKmrSkMwsLMJ/hkCFqV8/Qm4WOafur3KCAV
	2ny9wpj4rt1zFJkh5RXsuzcH1Cz5WdM2/4LLEjkdHSqms2D+F08CaMK/XAO0CUwXc17PYXW8go+
	ti6/GExgTz6WobagTITJCzZaWo06gvZ+sF3nsfezLFRpXaPryHz/JEPUO3wYuqNi1myGySE7WFu
	SHXFpEvEOCNU5O4dxDLrZFxVu7pWJH8SUyNfzUV7JqhDBk+cbK1epqLI9ty1saQqSOSx2e6DPmf
	w==
X-Received: by 2002:a05:622a:130f:b0:517:675f:3eff with SMTP id d75a77b69052e-51a61d30f45mr54054471cf.10.1782313081085;
        Wed, 24 Jun 2026 07:58:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:58:00 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v5 3/9] mm/memory_hotplug: export mhp_get_default_online_type
Date: Wed, 24 Jun 2026 10:57:38 -0400
Message-ID: <20260624145744.3532049-4-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624145744.3532049-1-gourry@gourry.net>
References: <20260624145744.3532049-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drivers which may pass hotplug policy down to DAX need MMOP_ symbols
and the mhp_get_default_online_type function for hotplug use cases.

Some drivers (cxl) co-mingle their hotplug and devdax use-cases into
the same driver code, and chose the dax_kmem path as the default driver
path - making it difficult to require hotplug as a predicate to building
the overall driver (it may break other non-hotplug use-cases).

Export mhp_get_default_online_type function to allow these drivers to
build when hotplug is disabled and still use the DAX use case.

In the built-out case we simply return MMOP_OFFLINE as it's
non-destructive.  The internal function can never return -1 either,
so we choose this to allow for defining the function with 'enum mmop'.

Signed-off-by: Gregory Price <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/memory_hotplug.h | 2 ++
 mm/memory_hotplug.c            | 1 +
 2 files changed, 3 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 7c9d66729c60..f059025f8f8b 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -316,6 +316,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
 extern int arch_create_linear_mapping(int nid, u64 start, u64 size,
 				      struct mhp_params *params);
 void arch_remove_linear_mapping(u64 start, u64 size);
+#else
+static inline enum mmop mhp_get_default_online_type(void) { return MMOP_OFFLINE; }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
 #endif /* __LINUX_MEMORY_HOTPLUG_H */
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 6833208cc17c..494257054095 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -239,6 +239,7 @@ enum mmop mhp_get_default_online_type(void)
 
 	return mhp_default_online_type;
 }
+EXPORT_SYMBOL_GPL(mhp_get_default_online_type);
 
 void mhp_set_default_online_type(enum mmop online_type)
 {
-- 
2.54.0


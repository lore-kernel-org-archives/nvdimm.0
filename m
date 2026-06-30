Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EC342EEE91
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854338; cv=none; b=D+7tFa6Q7T8Ri5gC6dcj9PHXgrMLFoSk7gXP/iohGmNr9klfYwns2OzC6qcArGb7vnoBonMQOB8cyoXZdSkVcvTnkAn1M6T+3JiV3bN34kFAiDuqFQEMAkcQ8BgqZh5Y1EMGdDiV8AF0q30CRp/LciMZEWuDrH87u4HYzaoykh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854338; c=relaxed/simple;
	bh=EGGGAMPdoaoIYEzc8d+Nft+EyBoE2MoOmk6lJpb1nqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErQ11ub0sJHn0rgF748rZ+1NQKFp6D472E0zR4gBRWxzxlYGHMpfbtpmxcAA0xal8EIzZeYZiOZQCrKz44xS9EJoBVXmy1A6nvNHz5p0VOBQoWCd+PkPrOxwKEBuavqguCO9X7X/dcVeKwtzxji+rdxnfOa3RFbcvUtPBo6QKJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Ofom9ZEb; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Ofom9ZEb"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-923220bf1d5so460772385a.0
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854335; x=1783459135; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0XGoZmURbYPyoE28BDme2QX7BFop+44e7z5jxOHqkV4=;
        b=Ofom9ZEbj+gcSF5Qnp7UhPJFFU3NPzszvPWT6fvTQ3om3tO2KuXTfZgVDlH6VsiwuZ
         uqWPN8EmEaYA4lYNJ7Df0JQCISLGq9zsAVcXelB9nK0q6tGRnPhnIsKrNzjFJ8d3xK/W
         W+ElQVnYHK53h58Cws31GLfjJytviCwo7t7OKZrjC51YRV1jOhkkY0Nj6QZIIhEOBb3G
         ml03TrGDkXfOT1T7nB7oqRZZYiNRVxhoIeuO3p4oyTJHu/CYwe89UfRZypY3TT01sVy0
         j/edTESwQalPLuDq1egzb/7x2wgjibYyXS+A7uCOygRoAdXHQGSnjo99gLeZ7CrMyp5q
         ZwOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854335; x=1783459135;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0XGoZmURbYPyoE28BDme2QX7BFop+44e7z5jxOHqkV4=;
        b=MK19xeYwAHdSQOCOnsigmj+3Lv98f8oO6m/ZE0YR18YVlVFa3pRtneDmSvRnydIH4z
         xIoswjaE8Jmv5NCHHYUlwGMcnZonhtpVUn1KzPELikVP/y/pB4wwyVtSNkc3EYMJqKEN
         Zxl+gzeL5qtQoSUcQRHmSZYH6EGqo71dbHqYacCKjZjxzEcdEO3boktbc8OIINf4Em+p
         QbePj6zzjCyLiqUIMMx0KGQWAI7DvAGhHxAVXvN1MEk+3IMb6DUXbkIiAP9vPyBkqRj7
         jiSGiOWwYz0ITavp1ypA7ROCgpckrqe3k5OO3a2KTRpOfn+3mWKoxg0qf+eyftdoCsdn
         cmbA==
X-Gm-Message-State: AOJu0Yy5a8eBZH5tYM6sPSxl1Gs2dKpTBXCRPhQtatjivbrNuW9Bl5+B
	KE3QP6ITcRrf8EHEFsI7Seq2E7gMyYbDwvK4qoE0uvuPrzIhb940JQwTT5iCSy5F25s=
X-Gm-Gg: AfdE7cm2z2M1OcVq0+eUsQf2AIJcMTzLH8MARdqrL8ZG7Qldbpy7vhawmin7HBndNM4
	u6/vRlMMIAAzFIlU8oCADpCfOqp7qPtoMm9e7O98FQ8nK5VAa3bYh7QDHvF0mx+m/OEWbqjXfKU
	IW6ff+3y1GjItUY7oXdQaQfqWhn8mMtXwnDLe3eofH3WRJTgVOzuaG394RVAkk1zOaxEvpO0+iJ
	xK0mSBH1eH08NtuY7HXYq9acak71ksrfJCH8+GgKSCeOq3M96/1+h8GJAW8JL9s6MzRuO46hSvE
	NFNzyRVKyLRx7z5mfHHOnLgociralqPuWICq9NvQryXlT19AnEx6OpM81jat2i4v5jQs1BXREQD
	f+/I7Mfp21Qlsnm8wLGC4Zo1qqU7jfyxly8TLDq3NYKHcA5EX8Rajz/RWTXsWdDq05+okMtWPiz
	OhFGtwPbCOCUMEORhw+EauhzDUEpT9smG5tozI8MQr4Nn87FTx2i2mJjCfnJIGh/cUnlLIXwftS
	w==
X-Received: by 2002:a05:620a:4721:b0:915:79c8:ec92 with SMTP id af79cd13be357-92e627931e6mr816969285a.37.1782854335567;
        Tue, 30 Jun 2026 14:18:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:55 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
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
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com
Subject: [PATCH v6 04/10] mm/memory_hotplug: export mhp_get_default_online_type
Date: Tue, 30 Jun 2026 17:18:36 -0400
Message-ID: <20260630211842.2252800-5-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
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
index 5d4b628c4a1f..4d51fcb93a37 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -317,6 +317,8 @@ extern struct zone *zone_for_pfn_range(enum mmop online_type,
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
2.53.0-Meta


Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com [209.85.160.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EB093803DB
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 08:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768380763; cv=none; b=Uv2Vo6AEnP97gJwUALcxFMv/KBu8Oaf+mpawQtRVp7nj8dYhxDSKWHMQTIas35xh7R9eDdP4Y+4uyHBe1AA1Ca/Cg7529AjWjzHTjAgeeEolrG1EzcLG9889Avkv8o6Mpq0+RUDtNaPn775RKN/jpvN7LImMlKJNCFN3yLcuJ+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768380763; c=relaxed/simple;
	bh=cImdW1I8gYlqyptmlVX3KT4VCZEIXu721DnCa4CHzjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OdNT6QkYDXi9CiRnNO2Nyj7gXOaEErbkpexoRrE0cbX60qn4YwEVhA8Wr66dcBRK/7U2QtrBl6f0PjRow/ly+aHDPwXuWpSSS16X441GwMH8EsKH5OxI+4okgInviYBVp+TLyWdsp9/a3lCwffkYsXBs03WY4HKrw9YgOBrV59s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=MVsZ65+3; arc=none smtp.client-ip=209.85.160.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="MVsZ65+3"
Received: by mail-qt1-f193.google.com with SMTP id d75a77b69052e-5014b671367so4672441cf.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 00:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380756; x=1768985556; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HDpE5wtoJCiMhRN5zrFeLb7soUJCKnfGA3SqaObqP6g=;
        b=MVsZ65+3BjwgxTZaugSWINsTYTZht3CsLrAevEs3vWJtEKP8qbDtm+HYHwyIrNvicg
         rqZrQqEdsgdKXBdSvkKmV6U9hxQ90deTStFXBicLSehXaRRE6CMJgYrBx1NDfhFtGKGs
         v0ylfg4Zm4ei5p4sY5HPbL1749m9IDZD+jFWYo5Il2n05FP1Io37kZXQb9lKpsapP2XR
         rrk3AuUK0wusQ0q2ZKLeFoXjI60BG3yhabImlnyg0xVORfXbowDLVdlKF5ZKvktAXVOi
         iOnQMuYJxZcz+J8p0LL2MlRL1U5dp/y9s2Reop0hgCjDVl0v75qsXl+O8XzTFdJISx1h
         pw7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380756; x=1768985556;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HDpE5wtoJCiMhRN5zrFeLb7soUJCKnfGA3SqaObqP6g=;
        b=nqsNW/qvHxHXgv9DPtzb8u8uv6Aj5zSzbGUqaW3YpyrEIDWi/zuHPh/mp/6oZ5wguY
         9RaYvneTCW/sEjmLDbcLinVDpXAMPTIqFX5OhYAVJvB5/Ho1DYxZQmZYOZqt2NMiSoon
         rE1Jmg65h0sKE/gczcF/KtQYG8VbXCZmtd6q8F1HvEblwQBoVAmFP1HJEg9iZk68FV0l
         WXh0qSrEoa47btom66uBfoGgo4lZqLSjL6nZgAwH9+OD39JDO/UB3Jezq+SXrdbIUwRa
         +Gy+HrRSzibJM8cquI9na3JjH1pK54jY2E+yZKCubgJ7Xdvj9mXEf83nxShk/UjFQSzC
         pi/g==
X-Forwarded-Encrypted: i=1; AJvYcCW6wZ+7gXq5wY/V3TZ43dLKBfcn2UipwnmQby6j3qf6e/iW2mke2WaAwj8LrghV4nbkCmnVCoU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwOVlzE2Tt1BUmg3NeG2+PKtxTpECCXFsAbKp4UyO2n47npiuYI
	TjeivCUStIcyuLSyWmOiPwpFJYYy1a19jQtw2VELtmP7RalCkGOAJH+aV9p5vTqN0bwSTgniz7g
	Opuo5d4z62Q==
X-Gm-Gg: AY/fxX6c2EYm5dZIfisEJWYHaFtJd89iJc8s9uP8cMZl3a/EcDHRc7Da1+y8dFL2iNA
	oDx3E1Sr7+2Xuzxs1Jyolt1Xz31FuDPyxz8u6EToYdk0erKw67tMZBbhxT8KrzftZKD/dZE4TBh
	68K8E/lGEE2h3JDke9zWEQ52+ItFDbwXSLPnlRmRzcHR0DrJ8F4AOqiJazwTwYAAYQuYv2nfmA8
	D41YJuwwkpmoSmF7zCYzZta9uNSENIR/jSW9WbvSVcoKwHt5wJiwLdXEew9Ptfe6UHfSn3JhOVN
	0AlYTXijkDupdViFk0OyxR7QIoCAZj+r7AtSEiZvoA2DbmN4qnJuwSvr6g86Q42FQvWPwBOn7t+
	icDGfK+MGaq9CzWoP+93wDG2zUQTQBhkuEGHJw4MPPqo0f7v+T0dcBdBFEmWg38HiolBtFK9IGA
	z7OU+n0kogEA46AFPKvzzQYrvtK+QAGJA8ly3sSkgBJDZJEHE4VkYFrOmm6dcQeGVbLEBaQHgyl
	Lb+JdtKATeDiA==
X-Received: by 2002:a05:622a:18a9:b0:4f1:ac9c:9388 with SMTP id d75a77b69052e-50148125e71mr26783181cf.0.1768380756171;
        Wed, 14 Jan 2026 00:52:36 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:35 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH 1/8] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Wed, 14 Jan 2026 03:51:53 -0500
Message-ID: <20260114085201.3222597-2-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.
This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable. No functional change.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 389989a28abe..5718556121f0 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	int *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1578,8 +1580,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 		merge_system_ram_resource(res);
 
 	/* online pages if requested */
-	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+	if (mhp_get_default_online_type() != MMOP_OFFLINE) {
+		int online_type = mhp_get_default_online_type();
+
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
+	}
 
 	return ret;
 error:
-- 
2.52.0


Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16DBE391E67
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 15:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774105456; cv=none; b=aP0ucBgqQ9S5g6G5hOX8XPyFPM6A+QyoNu3wey8nLXae96wthCG2QbqOaG6c9yMcQ/5ORZUd+tsnDqPPFaT98zfarg00T5zyNOpsj6tVOfUKFZGH65Q76LDL5mBGpucEaS0N/yHVJ7sDCbNnsppIYWWBjl3Z4dumQbsjxOBF4Wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774105456; c=relaxed/simple;
	bh=yADcON58BEc3yFXzCjE0Ob9wsd7UaBtY/rhvKXGDZqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAIf/wdZdSL5gcMcJZbi61zdO4RQBSoGJKfj/6jq4CpZNl78DZmv5E+sbnCoQQebnM6iGfvy64eWFwKjsU2Nh+29ghDVkURnUftv2PlA1T0ZNYWLcFwWe/IUO4G0Y9mHt3N69TuukBaikBYP8eavrp6aLwDaUoirNyy5+cKat14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=uKRz53RP; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="uKRz53RP"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-5fff77ff69bso314460137.2
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 08:04:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105454; x=1774710254; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=caGxMrakhd3CQmCyLFUIWJ+VIS649rYQrZPqpBwweHk=;
        b=uKRz53RPHitRU77ETX8BcG3aUHCNgS6ym8sOZVPrvFMqO/SG4dc83R1l4LxZsCL/pI
         vp2To9RAlAzxSPht3VQYnUIayNKNBVLBRhjnuVVrjdrlvJykY6qNfkS5i6X7fTUlQmMB
         ilBjwpQ9Yv3EWzrCWwj0GonbJfBiPIXfehT5YbbbLHzBV4VUqJVElLmhfIr8Evr9PAD9
         mCsq7vSf2ZhU5wWeTy84gbXrioTMOBCM/xd3qBn7SaBwoUCNjHsGln/OTD7pXMfYFYii
         AAFaSAMPh6vYwalmFia3VKWVm+cCkwO3wlaxTs3WwHGRYc9VZvc26t2Cg2Px/3cQJmaf
         uyfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105454; x=1774710254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=caGxMrakhd3CQmCyLFUIWJ+VIS649rYQrZPqpBwweHk=;
        b=C3MFVCDpkWVoytAbmnLXg1rGPClIvOFlr2u8L8rViL2uJUrhqUapHLuZDqq57SXy/Q
         xnW0yrUfci0x9+aLN+iOD+sPR9T53L/OB7tFYwZHFcw/BjEEMrDVGnIOD4vPFUiVxXl+
         gFF6g1ksy/1UoB5GtkbgQ4xfoUlnx9+c0nlLr2iyYJjuJ75imbJjTnHoQ95ssMr1butX
         QEsEKU7Il3EbZ0Pe+pfo4ab9F735fcssrcCQk79fXDIQCYqXN+xtQk9TUgO/Tn4qVrXV
         C5Ily9m/qjksw0/HfuK32DJB+JxqZqstbVj/eX2YvyDCsTn50WD6nyOdoh8xg0DGiolF
         FzNw==
X-Forwarded-Encrypted: i=1; AJvYcCUmL4cU05ml3rYoPUoe8Q8DUPtEU1fag2IzOfjJAyqLylZ5Ryn09XBDTZVGTW/r5bOa7fdOqns=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywrnb1mrSHmngZZg5nSva14cOFEUN+b/yLDzGM/6GrarmObkgdF
	2dO5+i2OQfL3Ih8vvPc4r17x3zLBgneyIL1BnW1GL1DQIneRw514VlwS6Zs1AwN7Yk4=
X-Gm-Gg: ATEYQzxIP8/yFsj/kYtbrftHpq53REzmr//LWs6p2+L3BsnI/TCKNR1Lf/DZK5LEAOw
	YaiAenNGjcrL6nJnN5t8EFwHWf3FQbze41kgOWRHM0/aNtroc7V1bh+JLpqIfzy/fmb8bWpvrgV
	l898w+uwHjttLiuLP+sQvjnKDCZ8PgI4suwQekUZjAj1QrstNl0jtZVL3IqU2w3FxtjMU/bqxWy
	pefhnGdG+2PqJSp1+1LFHFx7clNM4Je2DI5Y2mmhUDdvHbThTVt9k0/X0W3m58YZoX8jvi3RKWM
	9Qf5oDJaZc8vXe1QRfymNu645jqzanZT8Z65thNlzEZ36HOQ8HVI0Mh5ONlpNgKuC0Dr+SKupKu
	JtpF9M2N4Nlgf7b27mXXOvt1lSCIYB2DPue3zyOUdpPnoEd89r0YHhd6Gw1FIygqQldAtDAAfYE
	oNY+rybFARAp9vEMOJH6pfgL+Xd4wGJZLh+uaR/uBOdTi5LS57ijc31LRfC64k4noEF8VJ+miib
	8VsV4OYLPfpjkqVR2Bvfp/zQg==
X-Received: by 2002:a05:6102:8089:b0:5ff:e39d:9f9b with SMTP id ada2fe7eead31-602aeb3a44amr3175883137.16.1774105454003;
        Sat, 21 Mar 2026 08:04:14 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:13 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 3/8] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Sat, 21 Mar 2026 11:03:59 -0400
Message-ID: <20260321150404.3288786-4-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
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
type via a local variable.

No functional change.

Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/memory_hotplug.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 86d3faf50453..282bf3d89613 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1338,7 +1338,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1492,6 +1494,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1580,7 +1583,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
-- 
2.53.0


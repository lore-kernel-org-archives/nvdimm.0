Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C883D331A
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 21:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780694362; cv=none; b=lHaREsqGssXFYhDbI2wFf1uzWutlUieBhNs1Hj55f5n73regXbFoC0/7YYIY0HSsyQ6eP3b35m4+aBFAjA9K812qYHi7RwFmn/fTp8pFkKeH+shHo6mxDvMLHOGPxEfTjQw19eTM7zD5ViDyEc0s0QpLfd8+de2O6AM9tSBHFpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780694362; c=relaxed/simple;
	bh=5Ke3NaIM8Nos+HKJ6P0Knao9PHLgdSQ3RyZDgwl5zPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyySAhh7+LZTXtha91C3Yvc3Vsi+9WjD/y0194UfedaA2LgSAOesjNZPFDz352+BpdPGKbXhLsxqQTV7vnuTk2hZjiPcdUyu1G2KKo8YBIpvejBH+efYuZyaY1iAVIG13JpuNe+mY+Bw8Dp5q9oUDwt/uTx/HEE5Y4q4rG5NU2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=FI/64zhD; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="FI/64zhD"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-8ce65629acaso27118336d6.3
        for <nvdimm@lists.linux.dev>; Fri, 05 Jun 2026 14:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694358; x=1781299158; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oucyR6ExWtK/Mt3ZHMUJ1XBxl0rtHFiWxfVOhnoVW3U=;
        b=FI/64zhDCJMR9xMxRG9+o+U1APs/5mjC2vLrJLxEOmQ6MV9IkNS+GF2NwPeYN3bQrp
         NY2ipIAgtk7/FJfLVxM9S9SO+Hp3hSk8pFPlOeW02YGdagzx1KlR+vahQ8KSLq9gmxVD
         xvFJSlSFolhnuK/qW/PvPm5+mRavXeMWI0Hd/3NIwpWb5FPetsCWXR6Uk0qbFqZ7G5Yz
         K0sug+oMK/mnt4RlGtU+2qH/EVRqttI0KCAmckE4vDRPAk4ElFk6l2Fh3wdMpge4tFvl
         URgXVv23Y2TpSIyuBoNLogAuswC2PH2bylkhX0Iahhp4plvaebCrUF/WN3H13107jliE
         x3yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694358; x=1781299158;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oucyR6ExWtK/Mt3ZHMUJ1XBxl0rtHFiWxfVOhnoVW3U=;
        b=HOXxGcsdAS9SFI6/8snhzaJKr9f1Z5bjNSdCFLz0WgUEE7JISTQA62FqzLD26UdWxC
         KH//aPmzPbL2jTk/IHb0NZya4/dLY2zBOlp4VGfwNBujPgug1kJN/72F0qrFKo/HZ5jI
         ehtUXwBWFXCNp57TOK/vdQyX6hFyNnK+A59/fYnIXIvIZo6aydHRlWQlhaAKZADalKxJ
         KOEDu6qx/W5ogjefGe8tbGVAFOZdzlJtl9Ktq9eM1IVvlEezLmZi+t8PZNgSxviGPyJy
         f0hngR5quJU90AMfV969iyBvjg2qsfvm6wZDx6cs3OKnE1IH/cvJSrHEFBBH0nPrKE3g
         JHWA==
X-Forwarded-Encrypted: i=1; AFNElJ+RfA4COcDOMEwXGmG1hZXkr3i2H6yuzzDKfRjM7iA0BDiaChtiRwylcCBhMyS94dVq9dTfGAs=@lists.linux.dev
X-Gm-Message-State: AOJu0YwT6qFiIncqLTXvui0fNDA32aqSHMscRs2sciwRhHo1epOu5AtU
	Qq+dABk4+JNDZE1q5skOa7e9QlI0QCgINdjuuwkUq1yB9RRD+FrkRML1rVpxEO3jy58=
X-Gm-Gg: Acq92OFx31SyrpcjxyjuFViVGK3fp/1+hPtEtT49fcrvJc4C7WhOTFrSbAS6nTEWbN9
	3/mLlLz56Vy1fn7xJZEE5DG32P5Ar6JtM7pom//9DprOEyp+ppYeeq9gPOVpdxLV9yvmA5BMbrl
	5V1TpMeRR6oYy40mGW5QVWeCzd+RIatUaqdZo+DpaqidYHxwCmhElvvpFV0utJTMuXno0ulCaoh
	qficFGfcxkJS22FVfde5ZNXZT3CLGTgBZJEeVHjZ78V99VXjwFntvJrF4TkWApgRqWwYCxNci/j
	DTaHi9DJq41T7/ETE5NVMsFSFgk/WwoOt2BsV6ye4YKSkUikv0dIVDzAAAHuYJaHwE4YlbYcF6l
	iZH8hSh/muEvujm1YG2o91yI/8w4XLhrJP4F+171DwXQiyCnoWQ9WkU7Fr82Y1kaUv4TPItOPvo
	EY3TrMwePtQeJY+LKKxEDkh7YPLia5mbR0J01cazK09D/dvbG7eE/mM21mF9ml935gjj7tSYTE+
	O6VajUscyIIMiiNtZYvkOQ=
X-Received: by 2002:a05:6214:2687:b0:8cc:d4fd:702c with SMTP id 6a1803df08f44-8cee62655c6mr91017826d6.43.1780694358540;
        Fri, 05 Jun 2026 14:19:18 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:18 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 2/9] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Fri,  5 Jun 2026 22:19:04 +0100
Message-ID: <20260605211911.2160954-3-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
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
index 7ac19fab2263..6833208cc17c 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1337,7 +1337,9 @@ static int check_hotplug_memory_range(u64 start, u64 size)
 
 static int online_memory_block(struct memory_block *mem, void *arg)
 {
-	mem->online_type = mhp_get_default_online_type();
+	enum mmop *online_type = arg;
+
+	mem->online_type = *online_type;
 	return device_online(&mem->dev);
 }
 
@@ -1494,6 +1496,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 {
 	struct mhp_params params = { .pgprot = pgprot_mhp(PAGE_KERNEL) };
+	enum mmop online_type = mhp_get_default_online_type();
 	enum memblock_flags memblock_flags = MEMBLOCK_NONE;
 	struct memory_group *group = NULL;
 	u64 start, size;
@@ -1582,7 +1585,8 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	/* online pages if requested */
 	if (mhp_get_default_online_type() != MMOP_OFFLINE)
-		walk_memory_blocks(start, size, NULL, online_memory_block);
+		walk_memory_blocks(start, size, &online_type,
+				   online_memory_block);
 
 	return ret;
 error:
-- 
2.54.0


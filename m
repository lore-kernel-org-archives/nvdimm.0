Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2A6322C77
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854339; cv=none; b=TU9Tsdv4cGv+UUuSvSwfXCaLpcaZemdX0TP0obmiEiwsxC3d8h8Mg8xIsELH+1b0LJmJ7uu9lxNb0LC5SMpJPWqdpcuvYwiKwGqv3yHOBWf2VasjDlvu8aBE63Efsk3LCtLdH4nMPoVYJ2BBsSB5nAE8Joa6yVQcVssFE3LbOJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854339; c=relaxed/simple;
	bh=X6kC2z4Xyj+V+APtGHSXJjIu5DjDPN1Hl4dMPopeuUU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7s6URvQ83JUlydv4jdIZlZU6Hncn6nodVhOZD7TsDQiIRfrO9GEa03to+r3GC3a5ZYflBuNisV5N7ip306Om2GNWM+KVmz2YncHNKiRoSV85ne0OP/sVzlI2FJJfjNlBv2k69EAX3oVpxz/2W4XCFrLX8r16TxTT0pLM4JMlB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=GR35Hz0B; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="GR35Hz0B"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-92e55b62640so197959185a.0
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854334; x=1783459134; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BKwO5GGulWgyuo4GgOfyW93Razp13/peNYJDujzNXk0=;
        b=GR35Hz0BQdnv28Osf5ueMpZ/UsPjK+vI3s+mbtRabNjpX7oylo/U6fwXtxXTRdMMq2
         Dnu5R03Fy+YMWZJwc7R3Lm6O1MDPgDAzemyNZZMLXyjUt8ftEZdwoEnqdHumePGBeFws
         +CCKMzzkMi6oWvXAPID71HwzKxUB2Dwk40sPyGy8no9LxBTkvMprq2eynE61UhQhM9NG
         HCtN1/ma+UvpcagLlcq+leG9V9u623c3ABHpiTZkPwZyeuaPf0WspkYWbyVsSICn8Dkn
         gUsGYXbCJqAPYnRWschMk5YR7Pxe+MoVeE7vF/zSdu5JekD3DB98v5b1ska2cNa/5w4v
         EOBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854334; x=1783459134;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BKwO5GGulWgyuo4GgOfyW93Razp13/peNYJDujzNXk0=;
        b=o4JNqYo40c1M0upFsSFeGOLTStkNhwS9zmniE9+7FOpgWjXTgRKSXSxwHZp5/1Nu8o
         3MWhFy7/OlW0ibgQSkl71IVRCjMtYsRWk+aM+Tp4k1byvKRW9P+OvLn5Lt0tgHzzE4G+
         u4jpbieWDEWSWU6+48lFsLBz7dadLpyFAQuf3F/I1Zm3hjU2dfbh4thILobw1JI93QIY
         1JOKkzYfLswIB5FJ1ytrakJRWqITq+lhsPO+Pu1ghbXuXkMVPUAtKsvHPWmbEX72doNc
         pUbcbQ/lbUHUdm4OgQPUxUV4s4VFO2D+1iHYZrVr/POE3w9gvksyGBq/xqc48r0DW82m
         2lCg==
X-Gm-Message-State: AOJu0Yz6p5rOirgJNyY7ViVpHILjhCeu06WHdQogcu3tlPaH0hXkZHFw
	H/aN5PFSjtiIQWjdQCffZYVarzCKUhvGt7jH8S9oyVHJfonVGFyO4UGiy5O4vpSIKTAP6ZyUoWT
	rvHKZ
X-Gm-Gg: AfdE7cmwqYmR88L+QwD/ZMGYJA+VVcQqZk5XBqlpSY/lnYG3L/rzglERadEU/lNYhzE
	vTwHMnjAR5ber2zsF/ji6xQMZJ2rCvcUyOMwJ5eTjn4bggBCxo9vtY3pk/WfkGNW4ZBNv2sVc1w
	qKt74Y7QUucVAeeX6/RWeEhF69K8ZE1TAxVp9YT6vl+W6824S9r44j+zIefbNTt2+Y2/N9EFB6R
	tNYZ1t+USQDO7NRN3pyPzfptF7L6E47ax03Jd2B1x1aBRvXNU+CjCdvQz3vBH6inaNO+3vU2Ep4
	glfMAwzlgHDQM8T8C2kKYRDaRWsW0S4gFKR5OKEO2l0Q+sh2+sK43BGHBLX9trX3KaOP8zJQtun
	RcXgj3W47wG3eLziygdWlRp6V2gPxUEwkF8RPKLF8f6Q3ScGFPvqYtITtYxK5Vle1sALGmd31Gs
	qKvJHqQVY4zNZEGPfPKoCd34kcbyBq4QCoCqUbwkeVdnPWYq2wdlNcJC9oLvv+6IljTL9puOBlX
	A==
X-Received: by 2002:a05:620a:8018:b0:915:8f76:8005 with SMTP id af79cd13be357-92e6d8bc859mr391991585a.47.1782854333767;
        Tue, 30 Jun 2026 14:18:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:18:53 -0700 (PDT)
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
	apopple@nvidia.com,
	Pankaj Gupta <pankaj.gupta@amd.com>
Subject: [PATCH v6 03/10] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Tue, 30 Jun 2026 17:18:35 -0400
Message-ID: <20260630211842.2252800-4-gourry@gourry.net>
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

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
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
2.53.0-Meta


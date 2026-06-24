Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5793D902C
	for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 14:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782313080; cv=none; b=sy84uetFW91m2Se+wTWJqjbmlkkycAtpt77vpc+dPEnBtTEvLSf3dtXpzkVQNDjJyJ6honITnH1UL1ZfEDDDTTa4/uoDHGt1XlLWwkm8k1rbgNLOxaAhLFBcivtWEFwBzJC4hDbJ5WL7u6EouJmlxFWw3Qn9xXzePQP4lfyZXVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782313080; c=relaxed/simple;
	bh=cz/Kd5Fg1n6RVtyFBzJpN2apXZy9vJ9be28aEaW5jhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1WrJoGEmQZ5RhziW00GDlqGLo9tiigHa6kL5jGpoLv/MpLhxoJwM9glKk5Z2ulTuR5tAgXXrTYvuqMvIDEPIZfm1ejGOaf0o5RPTvfvj22R08uJrLSyQ1oZhj46gHPoLi7pmX5MoYjqB0+D/en1TYiahJE1Xf2h7wMq6E2uaEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=jbRpIgeQ; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="jbRpIgeQ"
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-517b1f2c6adso9594391cf.2
        for <nvdimm@lists.linux.dev>; Wed, 24 Jun 2026 07:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782313078; x=1782917878; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UQoqst23Sd/uqsFRXXVKz4Ck7yyavMrD/eBg48X+nsY=;
        b=jbRpIgeQeX5/AM1PM6aHkUyezKeU1wcxLP+1g+N/qMWZceh+8VsoiuEk0ZXEJiYIrC
         dGnYzlPn821da1skuBzYsXefn+ImK+eD80XbUWspQym1FPYSxHyRccPF5lmeYVhg7DDM
         gVT3uDug3Cr0g6onxaAp8KZD9vecvRH4ZVNEXQgqCBxWGtVsxTlHssDH+KWqbimJnJ+6
         a+1i1lnxKj76mvroBlCZmwv2grJ2s4EpG6cGQYF3VytNKi7b/0c8dUkUOSQJ5RkA3QoQ
         goBezJMMWzUO5QBUFvOXiumh6pccInsznwDBexgdF7uRhg9hp7xCsIEWD3cK4TOdqMzg
         uHow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782313078; x=1782917878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UQoqst23Sd/uqsFRXXVKz4Ck7yyavMrD/eBg48X+nsY=;
        b=bIEKA0YSPcJ+52qylg4JpwkDah6kU19My+XpFWngRd7tKEDOPRKpYU/Iv29s2TciOz
         8rRq0tDvXuoOKDeT+AnDqGefUH1DhafuvXpf5vGFPTiNIQ77aX5SXXEk9VWIljgjepiR
         bff5a5XP5gonoBFZMaTxkDQDd4yb0JO2L3QFCIqGqdl92qps2tYtBQHvYVb9IOMAN0OM
         soyE2DRAew0bd6zUTtMv6KgMP+Tgimn3n0JsTBAwFDrq3kXpbN10RuX8xbKqdk2Bm+RT
         gT3R+7OKjudpwSPLJL38hf/a4pbxYp5qU8Xobw8mbLyCSuR7ilzDsnqiKrIN5SodvMMY
         /0Tw==
X-Forwarded-Encrypted: i=1; AFNElJ/5vbz2jYyVi8OXmLDe6rHHd6VYq1tJHfgH50B0onG8G0X37kJ/lrOCdE54O/6RQFWAoLhEXak=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYLie1dDh7R41wQndmHTWaopglZJJKUrkjmIHohwwqSvdltJBC
	RNeCmsBIZBewIj8EwvCqyX7cwo3SowcvPfxrIEjG01HD/ju1JVjz0Kr8WrCpJrShfKRxGaHSiTX
	lgRvD
X-Gm-Gg: AfdE7cky4OFl9uLcsXNzebb1ST6XJ3/gum3Qwt3Ehnh6BwsaZRbh4D25YTt+J11SRgf
	3DASRUEcZTpnQEUBDuzu5S4pISxbXur8n/1RiKgl+HHx4P//T2AwkpInQkT6RQD943iIAGIIiTz
	c5blCviuhWK0WHkWR6wB/lnMGSx1k9OZmVxnerEYAl3ZIVG1TvrT+/LSjr1BsmfB7Tn8fdis2EL
	JS1Q28vhkkHoVxPHtmSdc6O7c4qJA5Cvxp/wtuqbLUpSHaSLsC9jsL12yBW1uJqPW6Q40HGQ9fY
	4LGnq+xh2JMLKYKTXrpOrCi3DNHN9SqcN768aqEfvA57o73yi6MpE3Te/O1d1IqYkGHtJUGtgBL
	eZMzvHE1TtR8Pw+GFf8sAUQ1gwyVM/DHmR+f89hit4pYhhD7u9Fwn5yrPoti+B+6lY+4gMMcEb6
	1sPFoK9gIHsrYJ750/9zi7eM7eMUnb/NJ2aBPicLx7C6x4ol9NgIwyUSIpWsuxdiMo9+SkCpa9q
	Q==
X-Received: by 2002:ac8:7dce:0:b0:517:7e26:36a9 with SMTP id d75a77b69052e-51a5485b854mr12138801cf.39.1782313078372;
        Wed, 24 Jun 2026 07:57:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51a51ae8ee7sm49502301cf.24.2026.06.24.07.57.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2026 07:57:57 -0700 (PDT)
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
Subject: [PATCH v5 2/9] mm/memory_hotplug: pass online_type to online_memory_block() via arg
Date: Wed, 24 Jun 2026 10:57:37 -0400
Message-ID: <20260624145744.3532049-3-gourry@gourry.net>
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

Modify online_memory_block() to accept the online type through its arg
parameter rather than calling mhp_get_default_online_type() internally.

This prepares for allowing callers to specify explicit online types.

Update the caller in add_memory_resource() to pass the default online
type via a local variable.

No functional change.

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


Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EB047F2ED
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 13:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792156430; cv=none; b=IWF4+vtskyrG6A6BpxLDq3GEzrwMW98a4DdEht+Edd8tIs1Lf3yVKzrWOFmH2Ww8dNoHRgyIm2ne2z1UC8T/O+SYmX+1FmMzI5b9vsNKUtqI4ot+2Chts9Y3963oi7lnASYGzVbWEp9txWUkyhhUTxOH3xa/PVujkK+3x2p6R1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792156430; c=relaxed/simple;
	bh=L6pjBYO8pyfc74NKRJM+Aw+PuIzrtslIC2/PolNoslI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SirC4IJDUDk7fR9mjI82qL6WzJrrnEAN+GDVyw+GRY0FrF1B3yGFANTjrO6TtYmMvizoaosTaP3vvpJGiq96IKsSacsqsKMQAMbHuNBGcWmYXZjkuts72iyGtZhMRzS58KFee29zPqZ/D1sKyAcb0fXrlSuNMUO01ONeGE3ln4s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ifR6H2IL; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ifR6H2IL"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3acb512a7a0so808716a91.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 06:13:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792156428; x=1792761228; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bq/LpBxXTW0ASsexzlAoQoBY+9bpCrcejtfW5Dqw6Do=;
        b=ifR6H2IL/jN8aIOsbGjkgE6C9K7e5LLIcyugjl7/f13dSYn3MTpDpeL1P3rSpegWBP
         oo1v9ezHzypHKxU6BNIG9bpSYhK7mEyaEyXWJRxKovXj/i9p2AOexaoR9W9RqowKqjPg
         bIoIDNpry7+IwC4+Jb71lP7h8fmukzMdFi5OOkOu19FblMCUhVbBl8dGDmnKi/1b0dzf
         tiGNWX2o5+1Ql9kXOe0p1A/8oT9v7TAIMH3l81UYOajnIl68OvOro+TE05cMnfislVd9
         7juE2yuNLIOh5/c8oo6HMaAbugpV0Gil6dc1yYQJYXWWuysurDmPGtbwCCIeDf3qfJNx
         q12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792156428; x=1792761228;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bq/LpBxXTW0ASsexzlAoQoBY+9bpCrcejtfW5Dqw6Do=;
        b=GvMA8z7vKkG7gFLA4sgtuzuR0NBGcB0s0xQ1w+aVx5qqWDPe2gaoaOT1gcILguEyLG
         Gpu2ex+n9otxIPhuNs9BDPq92UVOs349Y5EZvCKQ+DyB0qK9OdcxQZrXKkz87H07hsgy
         riu2uqVMWFKjuurAjEy4wLXj0Dexzatzjk9FmYi6FMAKXr1KkIQO3CQYPgvnLl+ctHzC
         IFIGJxDl0pVJbVbSyXhVkWnPb7zucmOOoxOF+02+bW0AGgTONyJuhR9X6F788ZUWLtgf
         w9mRlAwBVDbcjI8v3oou/hFBTIe3awDF4nlXXIdD5FNTQmkyci0k3vYI4GbFIZsbB0dD
         YEDA==
X-Forwarded-Encrypted: i=1; AKwUvBwEgL6dvBhvkxCWcrAjJvgt/SwpBPP7lTEcIkyX0+XEQQdvSmBgQ0qeMS6i6YSdbokSqjxHHfM=@lists.linux.dev
X-Gm-Message-State: AFq9FYI75Nrg8y3xWNQWVEpHHGEbODv0ToAK2rbdQYo80sFUDZZgmkJJ
	y6/kPNrUkEjImKzg/o1SkhOIvtX4nGANguK2ZwvJ3rwKX+m8urqkmoGrorf+pKzXnUQ=
X-Gm-Gg: AYBFou34k5fxyFYhc2CFGRs9TUFB7kaA2a6bpGyoBGWw+sMsA+LNQfTiVg4/LUfHZOP
	zpRhO6H9XyPykgIauDvMIywZ4pfHETOfVdLsOHCwTSV892OrIwbaqY+PZLw6UIcRnqn9ynrf1e7
	g4fZPP73opiTxMw/Kzj6CK9xlqEcxzsFxOD9VVgH4WE1TLE+dIVPcbBya1dGXUpPEtSyj3O/zUM
	DLa1Nqan2p6junkWbyVXhBz/1qQ5nI1ADAlJvc9NkIPnovxzYZkZfmo5Cf6mkRHG+ZiYtL0P9L1
	eYAom+KWeqh0FSU7OMkCDae3wsurzVrVfUkHcSo9s65S8AN+KI9yH1VUu7GpF7vuuwmnsWKSkkz
	fTeOqO43x4MShOd52x5bufk83cfgZgcHxvlQzWKG/lIZf1mZivKdoXfrxuuh2ACpLoD9BzQCnc6
	h9uc+TEFAUbkcdHkhS8FJeKQqeNz+25Gq5QxwFhUZhVOPqt7OepDFNeLKYTeZcvB0X1h3Y6c88/
	YqmvczKwuJkG7OFgzA=
X-Received: by 2002:a17:90b:134e:b0:3ac:9259:122c with SMTP id 98e67ed59e1d1-3ac9259151cmr5507879a91.40.1792156427018;
        Fri, 16 Oct 2026 06:13:47 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc487cccdsm4240433a91.8.2026.10.16.06.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 06:13:46 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] mm: warn on unaligned compound zone device ranges
Date: Fri, 16 Oct 2026 21:13:34 +0800
Message-ID: <20261016131334.3419393-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A compound page of order N must start at a PFN aligned to 2^N pages.
Therefore, a range used to initialize compound pages must start on a
compound-page boundary and contain an integral number of compound pages.

Two recent Device DAX bugs were caused by ranges that violated this
invariant, but neither was detected by memmap_init_zone_device().

Warn if the adjusted zone-device range violates this invariant so future
violations are reported when the compound pages are initialized.

Link: https://lore.kernel.org/r/20261016053944.2579541-1-songmuchun@bytedance.com
Link: https://lore.kernel.org/r/20261016054914.2601510-1-songmuchun@bytedance.com
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 4c17a892924d..01ced0553ce9 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1142,6 +1142,8 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	if (!nr_pages)
 		return;
 
+	VM_WARN_ON(!IS_ALIGNED(start_pfn | nr_pages, pfns_per_compound));
+
 	/*
 	 * Seed the reusable head-page template from the first real struct
 	 * page. The normal page-init and refcount helpers must operate on

base-commit: 63562804f25cb5b6f5e4f5e3a9f0d1c3c6868596
-- 
2.54.0


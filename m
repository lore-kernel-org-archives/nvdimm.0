Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 378C447FB03
	for <nvdimm@lists.linux.dev>; Tue, 15 Sep 2026 09:56:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789466190; cv=none; b=GgNp5xlv6CVDYnb0V7v3HKS13OLTJaelmpSwGq/RvHbcl7M16UULtNv/XG8+awHaFAsVBGi11b/pW+bld12ttctKh++tcvR4TVY7BKEYyrXyzvEGq8sXM8JXtDO9UDUPZz4HDJzOFBeKPMB4hoBiWpB6JikWuB8VMH6Ehy32zlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789466190; c=relaxed/simple;
	bh=BB7k7ub4vUDJmQ/eaAHtM5pQJLzkR3AGtfGbD7j+Lkg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AGG/j0zdRR2X5xWwBPJUsteZGcQt486tnHJA8Swky/HiDfabXt1OvaOpQpekRq7h5cOf/gkgXpbVvJ7Wwg9OZxsX9y6qy66hxhJisnwyhsekdyVqzZXRsdPtBDaYzyf7+k9QpE3eBaswAvIwi9Kpzakhw1oc6UrGYs/BAtrRRC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=GZiftSBB; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="GZiftSBB"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd53691be5so27527245ad.1
        for <nvdimm@lists.linux.dev>; Tue, 15 Sep 2026 02:56:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789466187; x=1790070987; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kk0ehQlGGghmi0p0Ac4j/t7sHqTD4Je0ypdc0ovTfjU=;
        b=GZiftSBBVfNN+34ZwyJKSsIsJ35BwvgRGat3bnIpzn5JuRGmel1e5LQABbf9t5MFue
         3PXRameDnYI30Z655+geuo72vSdFnMuBaztNRxlivowa5k4j4ZoeXJhG8DV4wQgfS60q
         8LVF8uSMkHrfP3RZoEBlD5I1Mf7rf0k9qckkpZoMGGbd3+M6BvMnGBxuLTRJl9Fy5tjN
         Q66VbWHPxCNkq3pLNSivaVbiQ7lw9B0kR32qP/ZT148Gaes0lRsD4PjTKgJ9ZPI1J08+
         XM9w3kP0h0oAXeoWSvY8fJJhLGp4s3LMqwSVYlhRNVGSuUEIXO5R4L7IW6W5ZvBcD7TN
         HMig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789466187; x=1790070987;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kk0ehQlGGghmi0p0Ac4j/t7sHqTD4Je0ypdc0ovTfjU=;
        b=RQAH6mqxbN8BGRTU2YMitdQ2d4K0k1CzGC0JccRvscsS/YwhHPtrxqkHJnsi3qFhi4
         +eCP7PwcGhwVIiiA+L0Tp9H7u7Kni8e6tD6C59i5Sba0PxxaPtBDb0cQPAq9sI+Qvc0I
         T57D44jDgXVNYHH6L1+jF+rHNQcCNkKaMgbc3QcCvbrPYh7R2gl5TGm7LtiABAmEzJVz
         S0jU+kPjiLHWGFmxdjAW7HBjgvvAFm7EPdB9Lm3/RiuuiD4Ch7QBPnIfQAg632ZjY6F5
         UBuM5HH2D3AlCladxnrRhpowzbFHiVX5g0SYvBVtIRDh6i7yCUQnsb5qwNKr9hrr43ev
         9jVw==
X-Forwarded-Encrypted: i=1; AKwUvBz4/n086v0bXmVIyLYoGCyyxnrpNBKjFwC8VrIiodqRiQnp9CujmvmSQd+ayvbLTi2hfy8w4pk=@lists.linux.dev
X-Gm-Message-State: AFuF++ldkcp8mQuR6NRBPRUBbvsJuPZXu8DZB9AvgE7M1UGg2x5APrJO
	zGFJ3vA7HIe/8nvKyMVNNXMCAjIrPSsNVj3Fv4Ca4a5abBTfsTEQcdW+u9VoqAvi7xQ=
X-Gm-Gg: AYBFou36re655NfiXaE5Oo2jUpOqReNBT4ZGEZSwix5mMEqiJcDDuK4cH+2wPKAjCu8
	89Q4BgMhbp7zir5rUf/VDGX03NW6Bby8NLBnfIt6L6bSz7bbWOdRrT1Hcl8xdf+nr4PZvLaWkEZ
	EglOaLx/CCobhW9mdgMUOVPEqQ4uo7dl4Q0mdTLGu+wA0Gted0vrnWS3FJR5M9eV8/WweYWlY+c
	HemeuRKlXhLZ4MTrgEUkswKhs5PpistmQFVcIcxRcz5cYeixf6yit59PCHO/YyyMaq7fibj6tha
	0skBeSvfqPQms0+AQLY2vidKQ5xt0cYaF89lyg7CgBlbh2s+d+WKjqRRlw/TxePDwemjL2WTdQJ
	nFgxuxYnqL9MpAnPDywWcquOA3+GPiRhNy2smvh9D9oGUb9yShGDALhhJNn0A4Kb1YiRd+dMOo8
	UFp/ebJa/f7Oxa25OCwAsFsT/itnwRT/xo0SP+cEXWP9fWU2Cj7yL9TimSvi7Fhyq9PMqxI2EdB
	wGRXc4FnutE+xVLQUk=
X-Received: by 2002:a17:90b:3fcf:b0:39e:ac:b776 with SMTP id 98e67ed59e1d1-39e00acb9edmr5989905a91.25.1789466187403;
        Tue, 15 Sep 2026 02:56:27 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39dfd6b9687sm4477827a91.0.2026.09.15.02.56.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 02:56:26 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	muchun.song@linux.dev
Subject: [PATCH 0/2] dax: Fix Device DAX range allocation validation
Date: Tue, 15 Sep 2026 17:56:19 +0800
Message-ID: <20260915095621.3744167-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While working on the HugeTLB Vmemmap Optimization (HVO) generalization,
Sashiko reported that memmap_init_zone_device() could be asked to
initialize struct pages with a large-page order for a physical range
that was not naturally aligned to that order.

Following the Device DAX call path confirmed that the condition was
reachable. Device DAX range validation checks the range size, but not
its start address. An unaligned range can therefore reach
memmap_init_zone_device() after the device binds, and a subsequent write
to a userspace mapping may trigger a kernel panic. With the help of an
LLM, I was able to reproduce the failure.

The automatic resize path has a related problem. It can split an aligned
size request across arbitrary free gaps, consume an unaligned fragment,
and leave the resize partially applied when a later allocation fails.

This series validates both the start and size of every Device DAX range
and makes automatic resize account only for usable aligned space. It
also fixes the mapping sysfs attribute to propagate validation failures
instead of reporting success without allocating the requested range.

Muchun Song (2):
  dax/bus: fix Device DAX range alignment validation
  dax/bus: fix mapping attribute error reporting

 drivers/dax/bus.c | 144 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 109 insertions(+), 35 deletions(-)


base-commit: 1a1de54f7369cd2b5bac0f265910e60ad3a6b4c3
-- 
2.54.0


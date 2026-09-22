Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEC341D641
	for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 08:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790065561; cv=none; b=uh52C5e2tNdlSQo2m5InpK0+Fxn5+Qj3vYtjcl2AtzYyx3WiBdEDqqiMgWWLPv4w1w+Ac1FrzV1Grgb7Jt7f98FbY86YdyQt6MmfyWOrRtzMBr9TpMpqm706LUPVBbVWby70an6TR3nMMoJQovt73eCIar9AaZYSTruMzRWFtVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790065561; c=relaxed/simple;
	bh=dBBpa7Ydst38i8cZsMQVxzXK9rqMNseU8twqVhQtE78=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=BR4KktfgJzhdTNaNu9izttW2QxrWOiRE36i2FX73ky5qfHnJaFaPoyRkyuUBOhfwBn8sTLuiAqimqT6ABihgGemrLdxX4883S+IjUT9/z8E44ggfWAy5A+pU+eQw0jBa397/fOEY9Jq6VdA+i0+0uSCgt2EhfXjPNYq3Mzu15Ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=kjexEEh9; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="kjexEEh9"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4bdf8abaaso3154807a12.2
        for <nvdimm@lists.linux.dev>; Tue, 22 Sep 2026 01:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790065558; x=1790670358; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Id4aiEwWk24mT8CByvlZpwQS9RXne8NT6QXvKFa3y1M=;
        b=kjexEEh9Z6oRWMq5DpdmaIw/VEHyLJ2FJsAfrLcDfnK9Kapz+jCZapDqvIZOD95CH2
         Zk2MrXVrfmT1K0OMB1Bzp0PcT0hD6On7FXSkWTlgmvil98JSjwNm5kagYh5ZZkqSnHmf
         lbqCQjnlvEz/zCriSOcpSzYvyIhO1patQ/ikoe7H11ihIWwNCWs1F2oaDly7A3Yfg9N7
         chVNgM7P38JU3VUQ/cFxeq2n29YRWv2rB/bLLbWp27CzmYLIpAwI5fWcxJogIBQGA0ZC
         u1pdx11V/PEbQ60guEUnphXlMxI474SAC0wSf02bUQEqeLWKpJZU4i/wjkCqybSZMhHB
         N1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790065558; x=1790670358;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Id4aiEwWk24mT8CByvlZpwQS9RXne8NT6QXvKFa3y1M=;
        b=XMrQGfcp7mLVaSlw6MOW/6mpgfQeGYE1WWxNjfahZHClXVHL0o1lwvscUubdFtcy1v
         d1gTVcSG1/R7cbeE1xTmkQkDQ5DfqNVSQn6WMX2Dbkx80qC7VFIlackEiTOUrJgmqui0
         /wycb459xaylsXQdAmsSHb+f76tPFq9OOCApQ4nDJvIP1u1s/CEtj3v2TXQXbI1F5pLC
         DJbuk6W0aMl/eseEuHoxebm7T4lN5y8WKDQRQ/JvchPJpntcq1vWLSrZwvPVJ1ghQMpg
         9GwTHKlg9aPvpbzXIc3ncpHr2HK2y7UtP6VZmZnlWUic7NOzU6KPSSEke84EmZOiS1T7
         iAFA==
X-Forwarded-Encrypted: i=1; AKwUvBzTc+1m8XjNEPLVThM6MI/eJsdrS+cFuZEAqWfLVC1s6I18lqH4U6XnD1HrCfUv9FIU0hgzQ9s=@lists.linux.dev
X-Gm-Message-State: AFuF++mybyOZaqrFSELbrG+hWS/e4k24QPK0whVXP7XB42NszuwOqVoU
	C+xgCXRwcPzjMqPHwJ1+9qsnJiFUs552UE5pAD2zbrZ2jWU+EGnLubHGup2T/TuDch8=
X-Gm-Gg: AYBFou1mF93VhEIBByJPEnGy08fF8G5eTuJJMJNOYMlsbR3q/tQKYStEoPjLIZOXAS+
	SKfMx8vf1i1p/Ggc3Fr7hIKu1dA0hyPIll6Nt5ZgnHo/jXyOqdFtDWVveIKvklnLhbmukgCBxZr
	8kGps3J9fRhBueKSMA4b3N4GY8x0psyZJL8FyAtss50wJdJm3mM4d/h25pLRUGTMgD8CSsVGDvs
	4Z1ntzDxh6J30tRpr98vs/p0AA9Qa3han2VgO1J9Ey1RIPfgliofaglw/05H//YRwNbyp8+78pq
	JUc5tVNlk0oT2YuVT2YjnLndS/X5LLfYQ5vFRas2lDB6CGMfz4lIA5Yu9DGAWxWswDHAhP+4mBH
	J1Y0bwCxsfoYWDdSbpqXYq4lgr/Cx9tPZnqEUkFXlUNIe57mQ4+++kJomMwL2FR10OsAkgs/yUt
	biwuOQXPZskucSlbsQS9D3YB2rA4uMUgRq5ec7AZZv8KNtmyg2Otj1VJQ228D7xIpP/4tUUXD/c
	z36+VQBTy0TZXvoWY5w
X-Received: by 2002:a17:90b:1e53:b0:39e:2c5c:a69a with SMTP id 98e67ed59e1d1-3a07309eb75mr436231a91.5.1790065558109;
        Tue, 22 Sep 2026 01:25:58 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a07385e516sm223056a91.0.2026.09.22.01.25.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 01:25:57 -0700 (PDT)
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
Subject: [PATCH v2 0/2] dax: Fix Device DAX range allocation validation
Date: Tue, 22 Sep 2026 16:25:49 +0800
Message-ID: <20260922082551.874901-1-songmuchun@bytedance.com>
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

This series first fixes the mapping sysfs attribute to propagate
validation failures. It then validates both the start and size of every
Device DAX range and makes automatic resize account only for usable
aligned space.

The changes were tested by booting the kernel in a VM with a fragmented
dynamic DAX region. Misaligned mappings were rejected with -EINVAL,
aligned allocation and multi-range mmap read/write succeeded, and an
allocation exceeding the usable aligned space returned -ENOSPC without
leaving a partial allocation.

v2:
- Return explicit errors before Device DAX range allocation
  (suggested by Dave Jiang)
- Move the mapping error reporting fix before the range alignment
  validation fix for independent backports (suggested by Dave Jiang)
- Keep the alloc_is_aligned() name to avoid unrelated helper renaming
  (suggested by Dave Jiang)

v1: https://lore.kernel.org/all/20260915095621.3744167-1-songmuchun@bytedance.com/

Muchun Song (2):
  dax/bus: fix mapping attribute error reporting
  dax/bus: fix Device DAX range alignment validation

 drivers/dax/bus.c | 142 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 110 insertions(+), 32 deletions(-)


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.54.0


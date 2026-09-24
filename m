Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8F230DECB
	for <nvdimm@lists.linux.dev>; Thu, 24 Sep 2026 02:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790218245; cv=none; b=E3iw+Me6HpBXl8RkfrePY3quWHz+XRuUfYhAkPJjigPzqq9BCywnlLzNPReM6aatKPQL8wn4zFR781q6k7mOKDNeD+kuhek5r8lypOLELfnfNax+JcGl123L9saHLLhhGHq/828tEz/KnMGHjjeBHyLDOtKzPxWzif55NpDZJ7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790218245; c=relaxed/simple;
	bh=HZdsv4xPU2mPZq3H1+rj/rzm1nmW2gVvYpGBVmgJSZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IvJsLd816OlR6ZbGjsXwmzqvte/3mgZN2U03D9iLOaYaOmMo+5P3xLTr0amfC9jU5GjW6IpCwuxA2ujvSpDWR4Nq7msd4f5ANiYV0OjTnYZ34xjQ6btsQBpvfraG/NtuXo3bjVo1smeFuVCHkwmKrK7JvxQzf6FSatNKUP/XoEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=DySq1b63; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="DySq1b63"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2dd53691be5so10565535ad.1
        for <nvdimm@lists.linux.dev>; Wed, 23 Sep 2026 19:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790218243; x=1790823043; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CPGTCvzEDldSCqnC4/5DFnL7iPnVDOTde0NQNs3OjKo=;
        b=DySq1b63ma61rKVRw7Jcwdj/bPrkPbBRzmRcNv3LmRfIx2I1lGGfuElV4Nm/4+Bf+k
         Du5TqvHwnyCZ6+xMx3MMZ73ma7iqf4Nk4RbN2QMuwBTFQzxqnRakXAj+toN+oXLtQasR
         DWDvHi4PyxfHCP80+A/w0czwOpIypW/j5NGM0VdrjX/dXKe5oIPohVcggIMFWxXo/2cZ
         eExrVwB8LrOCEXBzfXEIo6lHj+sPNlBLwDwMFJwPJS1PhSK7cw8cz2U2Fga96yi0LPj/
         WMAeY+7f4ABKZwne9LjZnINMnlQ/A39++uQUXm11aPG2LQAmydzVJxy1Fv7JqNkeriL5
         TTmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790218243; x=1790823043;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CPGTCvzEDldSCqnC4/5DFnL7iPnVDOTde0NQNs3OjKo=;
        b=YZPEZw6yTmuZZIzpTk+WEFHBNPrQIgXQiOja0aEURm+VXS7SffWa3PrsCxWlNhlWwp
         apKv7KYLpLotRWy+TCIC3f3Cwi1QAc4aU+nNf8HhVpZqw6xuh8abaqFsk4wb4o2MkhWr
         evxigY+7nfQr178fn9VYbQTVhYnQ368mRT9bwkazXoHaaRVhK27RIDtdgH2f782DVODH
         5kiNY6NFYnv2TG7vKCDqrlp4kOcEOQFrT5CNz0B+icjMff8wAI1WD5wOySoPb3LPAqSX
         r+muUQV/Mizz18G16Yksujk9VTiNq2m8/lZehQ6cUvwlj1g9jciZNs4FD7u1Xhpqn9Mr
         1HSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzG59qJaXny5Z8b3IruWZa5K3qFL2pNCtsJO0Fkyhor8/iJOB0WtJTkxteXN2XhJ2zJnHfQ9Dw=@lists.linux.dev
X-Gm-Message-State: AFuF++mX3/6HadoeFTnc0r7Wn2bFgfFxE1sSxmj0QqrHE9MGv99uV+LH
	X5qoqQAsMmICkJ0zQnKpPogn3utAaTNr86N3TlZFx/7U0IhajgPwM+rM+oVpJGoetZg=
X-Gm-Gg: AYBFou10yiU1HTMnycyUnWlP6rJTKiGG0Wpe2ddF/eB8TkXMDdpIDtHET1u2QPdDhIJ
	uGOvdXQVfnsQRInYB4BWkk4XNn5NGAL9sOw4yAaFHfOeQ/45r6f0LrdcRRms88xO2iv20YYGbgh
	btywJZWnseZkUCgKuaSD2Vx3ag+OP4NFM7LKzrz/46zNFjvHG3tX639fBQ7URG3TAK0jUM3XcpY
	C6AtLrHFE6uoS+tuMEfMb50hPoV7px3n7pFHZv2WVZ/PKiPEZEHxQuo7ku8W/X0ONxOqaBq+8nd
	/gYPI6KnEZpiarM9KKZiKnj8Vqrct3bhDXprIHIXB4UG5ybH+n4ESy+kYqpDzBbNUt36kH1JmC3
	h+KcqspjEL8lp+JfVBiz7519k2pJl/vAlotimX7yoE5EO3DgxU8hB/KGELXwElY8bQsf4QxgLBZ
	0r4bW/geUZEB+JqZYtG5jbfkoSkfxvGOczCFxLYtU5zJ1jrW84keknJs/pCsKqbbaf5K1cxHSN2
	V5axPLMvzg+m+JX14gn
X-Received: by 2002:a17:902:fc48:b0:2d9:484:861d with SMTP id d9443c01a7336-2df7e24f14cmr8581875ad.10.1790218242834;
        Wed, 23 Sep 2026 19:50:42 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.100])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2df6a5a4f6bsm18638185ad.15.2026.09.23.19.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 19:50:41 -0700 (PDT)
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
Subject: [PATCH v3 0/2] dax: Fix Device DAX range allocation validation
Date: Thu, 24 Sep 2026 10:50:33 +0800
Message-ID: <20260924025035.1265035-1-songmuchun@bytedance.com>
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

v3:
- Collect Reviewed-by from Dave Jiang
- Serialize size alignment validation with alignment updates to avoid a
  partial shrink after a concurrent alignment change (reported by Sashiko)
- Document the size validation serialization in the commit message

v2: https://lore.kernel.org/all/20260922082551.874901-1-songmuchun@bytedance.com/
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

 drivers/dax/bus.c | 152 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 115 insertions(+), 37 deletions(-)


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
2.54.0


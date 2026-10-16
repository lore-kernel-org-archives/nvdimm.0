Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2858133939C
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 05:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792129764; cv=none; b=daP3ycN68jbsPfZ9zEiWG20MKhgA6CqJ6/D0AXRLzvsNAPYZZcK5Ll6akaGrTfjCCNvi/XEDXzQlI97n7EF0S+IKBFhJZTcycWJuWXMXcX2MEypSbNURNj7PZDgCSnQImPuIz5t4T2s1HJW8mtEAOp1MqVYRpxSQ9zqXkL3Lo5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792129764; c=relaxed/simple;
	bh=rCTBXZWsA+DFjYHLb8u5Oa7Bvqyi+ouM5tudHnnjwtA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=foeUxTF/u/z1Nrq8YtaaeAYpJkhvMuzp1y+lPpXiqIIXkxNaaCtHpUGc2NAJOE/N0RhJp/GGaUjauE+WREm2dn8JejQneyQot0G+HBwt2/8nbD6cbMva7X899H5eEtd8RgdM64f1hXQGMViSOlnFcYz6bwUrQ+XPlwzBkn40p2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=NbZXjMAe; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="NbZXjMAe"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2e915887d9dso24940085ad.1
        for <nvdimm@lists.linux.dev>; Thu, 15 Oct 2026 22:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792129762; x=1792734562; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=z5sNEdkVrvo7sH9ZJvBOJJZb8XmvxfiMz5rU6UHY+Ek=;
        b=NbZXjMAenHuBhV5p1wQllPIN8iSMs8eNlkrF/lHylnW5I/5xgAixE9uCGFfMRfG3Du
         13yFTDtDyH2k3BOA+seOwEdZAMpPPw9ciHNrhK5dTkiU+y03rYda/EQ0pTUeQfw5xuVt
         AXBmSovQOj0g8ecdKVmpTzYJIGrzemnmiBsu858N2JygPyLOsaF0pUrsSpQw+7qU3muT
         DLk+AVF2OE1gdwdxCR7yjn86TwZHphSd3369147uER9MFJeuSSWHbNl26H27a1fAcnPx
         pkT8Dii5jNjwy6pnY3m1Vfu1kuPT0dApfJn+mxOYBnhnVp2+IkGWQwgC4+bYpGn7dXb6
         lWeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792129762; x=1792734562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z5sNEdkVrvo7sH9ZJvBOJJZb8XmvxfiMz5rU6UHY+Ek=;
        b=vSK6ScTfEPMay/0P+rbHA1HsxU5Kb4p5nABO5akqiKgBL5FJq5yRuvwfzDgG7Y58IT
         Jps7DrP771x0m46e7Ppxitsl0Fjw6t+qSOe6UKSzRFHp9/CuY3FNGcl8di0p8P6pUzCD
         HblNgnsixefww0j4iRmEMlvxq1+YkgKArmRkux88vo1/ME9UALTHNHT4EAfhmJAhqrNU
         yqhpf0Iv/mv1ydklA4HFI3rQ8p7spkNy0W/vItWRrHy+aI8/7YfPbJ6aGmf22UAEetUV
         mGKFNeXkypSSJrfp/9PvUx1x4q9nyPDfIo/3zkwLAdxeOSMClDvJf/yVbdr16JonAV0N
         Pvag==
X-Forwarded-Encrypted: i=1; AKwUvBxnvVe069KFVmLpdj1wrg1SAX90fa2jsDJQeRBf8OAexmNx27H0bKa452BV/ReieT8hobX/bJ0=@lists.linux.dev
X-Gm-Message-State: AFq9FYJVaQDFi57NvuS8VIBK97Qg4IHL2CJ48SJvaxEU1GOjWKIj5VGO
	iS/kVjJyxtpTG2fUPJWuwr7mkmDPNKilPxcNRPgQ9dReDORokNbLAVoduI0ARSPm09w=
X-Gm-Gg: AYBFou0ITBnbf8o17cE38OwyKKHmoVlb03S8JtZY1OE2QloNP0QeTk7+sQyaWIRGFLq
	zU6/+kjauYRJdYAjJic8kn8sQFn1/LwIthnKYt/RPGaG9v9bbdQ8ETzzVISYhfFbyly1AvBsdSZ
	N/3RdB5dkxxquTSMcnQ/A9yyuhLBwSOnTeDk3WQ+GLkK0vAB77Os5zoZcnTkHtFb8WJBUGjcc9t
	Ocb8PobnRQZQE7cYIGHQo30UZhyUumRmghE1zy//kPNMxKPKegAc1qU2f46cKXlyk1MdojhXyt3
	XJvFnRl1o1pwIdnHXR98v1stNBfjES+J91xi+chwUSOqXfHB71ddScgU3iqK8fKvH/6t1Xk1YF3
	L6FEOULfD8VdB4tWCeXjsnkH/9NJpVtWT4LhAjoHkEHehssChvAMDDXU7yH+1/srN6Q4SwSCK0c
	dg5bY2G7h3vjngFLw4ceNZgarbzd5DfkdjaBDxVzyEN82ko2aEiS+lE/7ul57zo2Rydqhg4ftkY
	duMAfRj5Q0pNIWX2ws=
X-Received: by 2002:a17:903:1b4f:b0:2e9:7ff5:544c with SMTP id d9443c01a7336-2e97ff55897mr13235965ad.25.1792129762374;
        Thu, 15 Oct 2026 22:49:22 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e804d7csm4697445ad.15.2026.10.15.22.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 22:49:21 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	stable@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH] dax/pmem: fix unaligned compound devmap initialization
Date: Fri, 16 Oct 2026 13:49:14 +0800
Message-ID: <20261016054914.2601510-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Static pmem Device DAX namespaces reserve space for namespace metadata
before the user-visible data range, and may also include padding needed
to satisfy the Device DAX alignment. __dax_pmem_probe() adjusts the
dax_region range to start at the data range, but the dev_pagemap range
still starts at the beginning of the namespace.

That is not valid for compound devmap mappings whose memmap is stored in
system RAM. Compound page initialization requires the start PFN to be
naturally aligned to the compound page size, because the head and tail
struct pages are initialized according to that geometry. If the pgmap
starts before the aligned data range, memmap_init_zone_device() can build
compound page metadata from an unaligned PFN.

The resulting struct page layout is inconsistent with the Device DAX
mapping. A later mmap fault can then resolve the user-visible PFN through
invalid compound page metadata and hit a kernel panic while inserting the
DAX folio.

Fix this by advancing the pgmap start to the aligned Device DAX data
range for non-altmap compound mappings. Leave base-page namespaces
unchanged, and leave the altmap path unchanged because
memmap_init_zone_device() already skips the altmap reservation itself.

Fixes: 14606001efb4 ("device-dax: compound devmap support")
Cc: <stable@vger.kernel.org>
Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
Assisted-by: LLM
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 drivers/dax/pmem.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..d3a9b85107b0 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -51,6 +51,13 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 	/* adjust the dax_region range to the start of data */
 	range = pgmap.range;
 	range.start += offset;
+	/*
+	 * When the memmap is stored in RAM, exclude metadata and alignment
+	 * padding from compound page initialization.  Otherwise, the pgmap
+	 * may start before the naturally aligned Device DAX data range.
+	 */
+	if (!pgmap_altmap(&pgmap) && le32_to_cpu(pfn_sb->align) > PAGE_SIZE)
+		pgmap.range.start = range.start;
 	dax_region = alloc_dax_region(dev, region_id, &range,
 			nd_region->target_node, le32_to_cpu(pfn_sb->align),
 			IORESOURCE_DAX_STATIC);

base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
-- 
2.54.0


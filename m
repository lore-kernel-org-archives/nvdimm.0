Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794020504;
	b=aNBko/3Jn3qdcJOJV4TbabBWyi3y43KowZjlfE7qu4vl0vOG8X/R+EKSNDLKB323KwVe
	 T7+2wsyfjV8bjFEEEL3xWamWhYwmQ0XbD8rPmgZhAqiba1kqqQOH4jp+TwiymkaB9K9T4
	 UxRPI3Ki3ooUz3R2aXW0gPsSeKpGjMQjVIWFlpGlL8F3blfcuUcX8VGIJJ3ZK/Yx8N5SS
	 EFh5fDOaQGVcRxXwDuJ2KbVo61lD6zJ8k2b9P7CvBc2tMMIOlu6NOBH5siE5zmXJdQ7Uw
	 jg0U09JkpJi66HrFTyefOMvlgrFmfQGdzEMTpn94YlLKJs9OpLXiJRynBFoabHzbxGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794020504;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=c7RdJd1ac0ZTEx+/NYzXEY+S8dr+3ZAZRK/h78/Mnrs=;
	b=1ohApgpFbCABQ4VnWacYqQ+wBYva1lUiHLYnzgNwH4EXRtEumXEbcOQcZnyVJnovNKGK
	 jT1c3r6hdKkdYB1nJorkfk/BUu0xACb4ZqT20okTxXV4xlIUaowe5hVkVA9Humaa/kP0Z
	 nnBOYTVnEvjO7CM87U1Mr5HQujFMcZzoaTEXfWQvo4wuxEVqq06RpVmxwET67THQ+DNo/
	 jk8eHBdxpiQXyHVeDjlgn/ipDFpvI3dWlXcY+lnidWKg24KI/5SSiwATXGzcUL9BjV+SQ
	 9+kUWeRXUlVFZOuaPGrll4JZFpcieg5nCHdOnRey78bMKpyt4doXfAJW/Au1E/T2Bnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=bytedance.com;
	spf=pass smtp.mailfrom=bytedance.com;
	dkim=pass header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b="S/gN4aRF";
	arc=none smtp.remote-ip=74.125.82.41
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8F6606A326
	for <nvdimm@lists.linux.dev>; Sat,  7 Nov 2026 03:01:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D8F6606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=S/gN4aRF
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1ae18eb9b69so1512254c88.0
        for <nvdimm@lists.linux.dev>; Fri, 06 Nov 2026 19:01:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794020503; x=1794625303; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c7RdJd1ac0ZTEx+/NYzXEY+S8dr+3ZAZRK/h78/Mnrs=;
        b=S/gN4aRFdzZdIh/C5l7VcqbyYPbPzWtK0SrW5vrirWPm36JUJlaeJE2Aq+TOMb7a5A
         4zW5TxVXx/p742++BmMtj/1hYIF7RRyG4qvCU6Yx61s3JCe0nGyI/LqHcSeljoFs+Ug9
         B2ke8UfuROYxs0ClBpC4lUm5Ise/HGMsAO/gKW4DqhbpNdWhVLIhl7aWuU5zW04YT0H5
         pSW1tqc0hwPO5Uq/4fD+7Hss0pvPci8lMdq55r+Olzs3owxyjcdqtI/zQdfHTP5T+zuN
         KzoDMbqh2d37vN/y6NSPT8eqkhS85GZuGUF5KzhdEI1nM8G6JvGJhFJ4fHywsjExXlIL
         wANA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794020503; x=1794625303;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c7RdJd1ac0ZTEx+/NYzXEY+S8dr+3ZAZRK/h78/Mnrs=;
        b=YgmwF8qnp62EL52B5iuPnhQE5pZEJJ11eW213ztwo5MI7Vk3yrJDtfV0JPBLtnCOvc
         bRQZf5lck5OPzgncd0SlcEmCUzI8GMWYBGSZYr1Sf6YqoYlaZ+VBT7jvSGvODYp7X9YK
         YstPdoIDbTY9Nd+1TRYGNCZMrYgy5dMGvrnepXQ6ps43eQSFMIU6UgIU5nDBAzNurdBy
         Rg1lWGTVohEyIDlWtBIMnzsc3cWs4Yaecf7tlzEXRdy5OsoZDFOlX54sEfP6lPIJGvuZ
         KS4cqxJZEErH7dMybrtfIYB1K0QfIJD1guliqdWqgVtYWjy+U4fdlU/6MdhOOFCwddQG
         41Iw==
X-Forwarded-Encrypted: i=1; AKwUvBwqvQoAFYCvvJVZgw4ey54sQGY7YWyFny2jbz5x8miStBnMsAJkG3rXlhn8uY9mcmZKHF0LQ8M=@lists.linux.dev
X-Gm-Message-State: APuU4Z9Gw+R4rHs2v9KCCBOZ5PBY/92pL6X0FUSagXiDU/0oNw+Y2ZgF
	rz7QkqYlfJcvU2Xk9iMV5qnTx8H4JuVuPJy8Mfllke+bFHCQoahueu634zs5c8+71fk=
X-Gm-Gg: AYBFou1h4mL3amVJ9YT8Puj6MXVeSuWemTfF4dLskjCBLvawCCso+peT3nxCEaw02rz
	I3mFaCKt2SZ8Eewh8E7TRqVRinCUTG4lMlwLeCvDM/9d3CRLPUnEhz0Eb5XISnYcPxIeLTKFARr
	OIAmRIuhHZKKoJ02L4dg7gYNbi86XvdL2RpRkVh//Sm8Nuusvzko/jP+UgBmFfqH46hzlIG/fCa
	Tr4k3dB+M/rY2XOeRdm0yLg9RFMIo5QgLglzOgX358RlXozvozM1kj4tM2OIHs5hHJjqLwPm0Dz
	U7fi00KUz/NyidsB09otAiECJV7X6TY0D0GIEMiZIMkX6+pHrdpdiGnDw4ZhH6bS0u88OqVT32E
	VKp6PPMZ70c1ly00KTOZjSrhRCcKYSDtPAR/X7CoJ62YnmAbiIQc35tDoLDL7F1oonbEC9zwujj
	HXGjgEEvyq9nhIHi8WEgAqGljPZ4sB+HBiiWacXhQCDbbzMrSz3l5sC9JusF5s1/ztFGxPgLmcY
	Ul4FZII0telYK16KSnVRFrrh3EHITq7jk/N3c1VPNOhkPoZXFir5m2lPXgAL5QzvmBZcEeavPea
	JCFDsm8FuWk5lFyjciybaFComQa2h/4J82UlxUe5n1LJWZn6zSdOBbfIw1ElJw==
X-Received: by 2002:a05:7023:a5a:b0:1a0:e3e2:22a3 with SMTP id a92af1059eb24-1b25d33a590mr5333663c88.31.1794020502203;
        Fri, 06 Nov 2026 19:01:42 -0800 (PST)
Received: from G6L4RL2QG9 ([2409:8a00:1832:6900:c8de:13da:804b:a0fa])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b25e4b4aa7sm9534473c88.13.2026.11.06.19.01.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 06 Nov 2026 19:01:40 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Joao Martins <joao.m.martins@oracle.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Pavithra Prakash <pavrampu@linux.ibm.com>,
	Muchun Song <muchun.song@linux.dev>,
	stable@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2] dax/pmem: fix unaligned compound devmap initialization
Date: Sat,  7 Nov 2026 11:01:26 +0800
Message-ID: <20261107030126.90894-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
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

Fix this by rounding the pgmap start up to the Device DAX alignment for
non-altmap mappings. This gives compound mappings the required naturally
aligned start while retaining full-section vmemmap savings when the
original start is already aligned. The altmap path remains unchanged
because memmap_init_zone_device() skips the altmap reservation itself.

Fixes: 14606001efb4 ("device-dax: compound devmap support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
---
v2:
- Round the pgmap start up to the Device DAX alignment to retain
  full-section vmemmap savings (suggested by Alison Schofield)
- Update the commit message to describe the alignment approach

v1: https://lore.kernel.org/20261016054914.2601510-1-songmuchun@bytedance.com/
---
 drivers/dax/pmem.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..d54d23f1cc58 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -51,6 +51,12 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 	/* adjust the dax_region range to the start of data */
 	range = pgmap.range;
 	range.start += offset;
+	/*
+	 * When the memmap is stored in RAM, compound page initialization
+	 * must start at a naturally aligned address.
+	 */
+	if (!pgmap_altmap(&pgmap))
+		pgmap.range.start = ALIGN(pgmap.range.start, nd_pfn->align);
 	dax_region = alloc_dax_region(dev, region_id, &range,
 			nd_region->target_node, le32_to_cpu(pfn_sb->align),
 			IORESOURCE_DAX_STATIC);

base-commit: a91337fb5e8e0127c8b5be87be9f3027f95b48bc
-- 
2.54.0


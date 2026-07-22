Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57EF7421253
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 18:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745333; cv=none; b=n+BLmHYMqj/TmaT/QGnlz9yBGlVO65xhm1lajOR0vAywV1Rwrr5DtFFIw1mrwnWHx3mEG2nNXXd7X9ni85+LtO1sqI4HI4yL60kmFi7PoJKl9IBx78w8x18h+Y4/nECrqOaL1YDxWXVGvcIIeYcQjYvEzHJEUN5vB7vd/haZtkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745333; c=relaxed/simple;
	bh=fB5MDXjdpz5iQAHGUhY49ZSZzLO4uAvM0Zy2BponGt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMIdhML/lL8L+oO/ZbJ1xZoG8shjB4/AetSmF3AjGn5Or7auYeVLV/eXPis2SnsHmEmljv78h08LXcr3PRRM8blYPITFym9fRRGZPOS3gXJ9rsdA9kURYAzzo40+gqPR1eenUw4HYgBWLMA04QoylP0IgEDCdm1s/qDkjHnzeE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=puLIufp3; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="puLIufp3"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8f256eaedf8so153003406d6.2
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 11:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784745330; x=1785350130; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=j2CVKVqJBHsKrJ5Bdm2nCmvoLlboB+s0FhSW+cZN6ac=;
        b=puLIufp3WizBAE8jJt/OHoanybj+I9SSbtrMcJUGkflmfyGyNFThBqdarMdFoOrya/
         sU5nndnEDjzr2r9rTsuagjhTk+OOwjz1X5G98vn2Mn/DDZRin/u8rMpZzgcni+0rqFYi
         qg+rcoVa55FtvxtlCbUkU9ffCYtiobPK0j7TbGs+pnpyyCE4LnujEtN1VMcFnlPNP7L7
         Yb/Y8Kevn+YEC1gKBFBba2g6kyVKMOW1W7/VUa8AQKvWllbxHCUkYfdPnsAAuDSC0Y3p
         3TjlKqJLxjnGmLERxQY+6JBIwfY/32wPVYFp168crtYPKELVujtlqL8ynKjSu1TO4b5i
         1NKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745330; x=1785350130;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=j2CVKVqJBHsKrJ5Bdm2nCmvoLlboB+s0FhSW+cZN6ac=;
        b=Cr+32iwHCRzP+bR7LmxgsZUI4ToBl1crT96x/alwqVWixD14UpZwfeBD4CpWXPGbPT
         xGXsialync+o03s7IEZfrqajwQXs6Q5bEvGPyiesv/XCTjIIJvjiZQThydEZ4ZXXuIsd
         ZzgjVUNObNLib5k5gy2hKmNG9ozd2HxRFiZ0Dy9z/lQx8ZhBN8J03qtFPS6pql5U5WRr
         9Hbil5t6fLcrkfRssuo5Oqw7dzKEtvo8uUJYA9f+xujITyMH9vKMx5dKU8D6MlmJtRW7
         RAO0NofNbFffnjIqF4Q9hXyEshn1tLW/TPx8yRZvP6Nk1MAu7a7tLJihXxh5I8jOBYBa
         3pxQ==
X-Gm-Message-State: AOJu0Yz31/xywQjxT/Lsn4UJinEJqbHqM15iZv7/Yms9vJIP0NgRvWZU
	A0RZIBzOwa2uTXN4p9LBv4kn7U/L+n4RVb8uR1Go5kTiR8X9uwKpCfuhsn+LT3mQ9jc=
X-Gm-Gg: AR+sD11rDoxLZwn0Gzum2lGP6+9k09M1dE8UeEHyLv6bQ9DxNlbRdGLerzQTyQ8o99R
	pKDnd2RfaYxvnppr18xk9Mn1zbp9nVcDs3uI85FMN4Fs9NGYwupNavRza4eYS9i6aVoQeWCkzSj
	f/Pi/wMUO7YEdJCrELC/oI/Y5hwjEFVfq5wZyf4/yjpyyBONbVU+ActD4s830NkLx8LoFPDbIt+
	D86oiB5oHsjPvawXo8uFF4F1ngIZW8SQhkyzpb2CXbjsSD8YNzCzb1ewROiNqYdmYg+ioKcnYAj
	spaP0lM4EAy/kdSyIJKaxDPcixPHf7U+xCjIzIvRoJqPEN8sZZ+K9IDBO8rD6HEwAb2cTMkC1Hg
	sGK6oL68eZE1k5Pr7UbhCl090Tb+C8jhmuQuwwjNTxyKs/cELfAhA8qhSTRdjP7RQIn5tI7Sn4n
	OTYvKzBlKSwTZByLvKBd9EJj87Pj17mCbxCBoSYGQJKsvVTYw25M/H2BN1CjcP53M=
X-Received: by 2002:a05:6214:5d0a:b0:8f1:579e:a41b with SMTP id 6a1803df08f44-907ca295150mr757966d6.24.1784745330173;
        Wed, 22 Jul 2026 11:35:30 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b3e96sm27630216d6.1.2026.07.22.11.35.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:35:29 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Subject: [RFC PATCH 4/8] dax/kmem: add the user_numa opt-in (CAP_USER_NUMA) for private nodes
Date: Wed, 22 Jul 2026 14:35:15 -0400
Message-ID: <20260722183519.935213-5-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722183519.935213-1-gourry@gourry.net>
References: <20260722183519.935213-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add the "user_numa" setting NODE_PRIVATE_CAP_USER_NUMA so userspace
may control residency on the node via mempolicy and migration.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index cf6cb927e5ed5..8023db23e2f99 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -629,10 +629,12 @@ static ssize_t name##_store(struct device *dev,				\
 static DEVICE_ATTR_RW(name)
 
 KMEM_PRIVATE_CAP_ATTR(reclaim, NODE_PRIVATE_CAP_RECLAIM);
+KMEM_PRIVATE_CAP_ATTR(user_numa, NODE_PRIVATE_CAP_USER_NUMA);
 
 /* Per-service opt-ins. Visibility toggled by 'private' control */
 static struct attribute *dax_kmem_private_attrs[] = {
 	&dev_attr_reclaim.attr,
+	&dev_attr_user_numa.attr,
 	NULL,
 };
 static const struct attribute_group dax_kmem_private_group = {
-- 
2.53.0-Meta


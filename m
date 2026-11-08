Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794126086;
	b=mq7ptcJB6Q228Xyku/xhZ+Fg6AMWuyjA0PXbXEErbilTiF6acnQffiD5LswxO8NZekls
	 J/kLkFVkVc+BCD/4Gv7asRevfHMfbUg4Aduu6AsqLoxAgk6AEql5/1eP6jPvYZx2rs35e
	 Jd9ZgCwX82JeGVDyc3DYKwXsDPKINSUv81A5dUtDyCddd+OLKrPZhS21K+s9TzUzIowpj
	 WCWCHFto2ItJO3SpNii6d8QhyRi8dMfJiD6QzdtDugfT8M0tlpdh5PI7UhjnpsqPKLg/k
	 sutVaUv0iB/4I196tQ7zIiLj74uNnHgLmh9GIPlrBx2twJcsoDf7Ga50hHYfGpayezQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794126086;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=kBdqOrR4M0OqiRPiZCcUf5luLzFwBf8tcIlsxdbBp3Y=;
	b=wznHywFucQQqPk81V1YY/6EA3eFIFg6C2TLDUTU1pPwe77u0cyam87alpjz1lZX4ltuS
	 MkR4U4YTgtm9egrx5fSkmlANQyE6Eu8KQlNKjMAbzwqyarAes4dvqIBtieOh4Zdl7Tm4L
	 HYZD+ryECQAhbS9hh/2GEZHR6yvUH14eUm4EN8hrQjzipETOMhCWUOgWvyg+pQvhDkYSn
	 XiaZJGZiB1xQevfwmkOOLiATjAjB6P4UwoPnf9nJcw47o+VteZkWBsZFf88rF6ef5c18Q
	 sQqc/6bp1dXE9oxTNZjjZzVamaC+iVPGD2g9pnt7AHQQtMiCrcHHLNtIvfAA3Y3HUfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qKbBB9bM;
	arc=none smtp.remote-ip=209.85.128.52
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3F5C606A321
	for <nvdimm@lists.linux.dev>; Sun,  8 Nov 2026 08:21:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E3F5C606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=qKbBB9bM
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso2158785e9.1
        for <nvdimm@lists.linux.dev>; Sun, 08 Nov 2026 00:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794126084; x=1794730884; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kBdqOrR4M0OqiRPiZCcUf5luLzFwBf8tcIlsxdbBp3Y=;
        b=qKbBB9bMFa/1xQXzonqvVYCa3aQfP4kJ3zn+p3cHeWQJ9kaZkNin6U3AwTwdaKaqsR
         0/tFWvNlX2b5NrB1fUxtPeHUIS6PjAiCDjwHCmuwmjTqgqiq2KxZ68hKM229JDum5buj
         /Obaq6BVsyeQHQckX5yBketm9uYQ3DcLuSg8oh3hq1CRDpYE3hGMCPPKafoIZuWFQgFH
         3fV48GQVuN9IpQGgC/48zF++V4JeIgceOiI4QyObPg5ZRiBlq43+4APXuFCHH/l1yVww
         i6K8dNjFcOirNFbZbsiq3/CJJrrG8jKhE0b+RKL4/omQ3+zFP0LAOoaqqaFIinz0tKbn
         Ha6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794126084; x=1794730884;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kBdqOrR4M0OqiRPiZCcUf5luLzFwBf8tcIlsxdbBp3Y=;
        b=YOT4o4WciRRUSNmN1X6a1fbpSIenUUfGKEd9SqtVL2cbulZHL+2Q5X2QrfFjfRDgh/
         lM7M/vRJARAbUky+BqndtBrsj6jvnVJ9VXKvQXRU1vygaFwl4tJPrvTc50Yz0p2m/VJC
         DbUUB0Xs3DMIyToeNsX9/QuP3n6gd6HtpVMK8bl3A5Bzd0dwoBNd9mYw4ifVSdXtN+tf
         npcUoGe51VI9sS7it2a/2lzfdkLMQ249+iss8szmp5e7NAHZYbyde9Fx1UhysIng6WfV
         0oOhnbV3fIkfOXtWxIb3cBHK6ZZwEVyo972WxuoXMMIkYNK8q1XX0CuEBj3rR4vsEDhB
         0+cQ==
X-Forwarded-Encrypted: i=1; AL+hErH4r8zkPKvffAm7EQUuy0IKadL+4AfSTS+vaAbg+Y1cMG64Sl6TwLYZClxbIkSvXb86uOIyIuI=@lists.linux.dev
X-Gm-Message-State: APuU4Z+/4Uq27rpQo4Ijf/nt28D0jFBBzsk22BiEz1P10T1wKyAUI0gk
	OHEt1N35IBzl+FCQQ76/wuQYB59g+iEjtOP+DeftW2zwG6JJ87gNr05s
X-Gm-Gg: AYBFou3TybcQCNty0ZiYTrgj452TN29Xq4JUVS7v6aECD245RvdRWbEqcuB1w4Vr4Sz
	oXMDxrvQcFfPJW2rMcowL65HFtzAqWCncIZNiZ5F/r89UTa9oEGK7dI0X/5vcMKpbGGRmJ/zM9G
	NYO66och5/4nBd00lDKQixv5eueyoEfpvyOh7IIRNgFHIIPSaJ351NllPUllc2YLG3OWtePje+C
	YVMIZHTu3IaynL0FjOQ8YSONYyirO6nNaIEloeTrN4/6DdEKO9puA3LFp4W+xyv+WYqRTFs4HtM
	p0JYl12zOjlooRCKpGSbzx6yJzV7xGA76ZtBkR2Un7CrVt3tIM9zKRKDnOXrSZtxH7fiLyZCrm3
	pNzSeniCCw8IshHw8oBZYQNbnzbZKqQjbDf7gNqLSjz2NeM+gICId3BRB7WpYcjfBnMYE9Nc5s8
	qgN3rVoNudf8T6B3gtpS03RXnX5WIFCNurz/Rci5Yvajvg6ueYuYUVlRunaFBZntb23cH3S9DjI
	Ivtb3oMNJbFdw1U3vDqbDphhTPgUM1zHtsNFjrUXicEgU7Vxu+7gsFp2miaAzzLxwG5mus3XqHF
	VfV0IYjFRgSdweR6U+0Q4EutflqgJkxRP0pRbXSn8iIVitbvoySo/tN+gp+itzLUBwQ=
X-Received: by 2002:a05:600c:5397:b0:4a2:47:b79c with SMTP id 5b1f17b1804b1-4b963c84476mr15033085e9.32.1794126084090;
        Sun, 08 Nov 2026 00:21:24 -0800 (PST)
Received: from localhost.localdomain ([2a06:c701:475e:f800:9c3f:1631:3855:dec8])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b90ee247e9sm43521165e9.6.2026.11.08.00.21.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 00:21:23 -0800 (PST)
From: Avi Weiss <thnkslprpt@gmail.com>
To: djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Cc: iweiny@kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v2] nvdimm/pmem: propagate personality discovery errors
Date: Sun,  8 Nov 2026 10:21:16 +0200
Message-ID: <20261108082115.2029038-2-thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
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

nd_pmem_probe() ignores errors from BTT discovery and only propagates
-EOPNOTSUPP from PFN and DAX discovery. Allocation failures can therefore
be mistaken for an absent personality, allowing a namespace to fall back
to raw PMEM.

Report -ENOMEM when allocating the BTT, PFN, or DAX info-block buffer
fails, retaining the existing device cleanup paths. Propagate discovery
errors other than -ENODEV and -ENXIO, and keep raw-PMEM fallback for
those two error codes.

Fixes: 8c2f7e8658df ("libnvdimm: infrastructure for btt devices")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
---

v2:
- return -ENOMEM for BTT, PFN, and DAX superblock buffer
  allocation failures, retaining the existing cleanup paths
- correct/clarify the comment describing raw-PMEM fallback and
  namespace-seed advancement
- rebase to v7.4-rc1

 drivers/nvdimm/btt_devs.c |  4 +++-
 drivers/nvdimm/dax_devs.c |  4 +++-
 drivers/nvdimm/pfn_devs.c |  4 +++-
 drivers/nvdimm/pmem.c     | 19 ++++++++-----------
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/nvdimm/btt_devs.c b/drivers/nvdimm/btt_devs.c
index d6b2f157368f6..c3c5cb686743b 100644
--- a/drivers/nvdimm/btt_devs.c
+++ b/drivers/nvdimm/btt_devs.c
@@ -349,7 +349,9 @@ int nd_btt_probe(struct device *dev, struct nd_namespace_common *ndns)
 	if (!btt_dev)
 		return -ENOMEM;
 	btt_sb = devm_kzalloc(dev, sizeof(*btt_sb), GFP_KERNEL);
-	rc = __nd_btt_probe(to_nd_btt(btt_dev), ndns, btt_sb);
+	rc = -ENOMEM;
+	if (btt_sb)
+		rc = __nd_btt_probe(to_nd_btt(btt_dev), ndns, btt_sb);
 	dev_dbg(dev, "btt: %s\n", rc == 0 ? dev_name(btt_dev) : "<none>");
 	if (rc < 0) {
 		struct nd_btt *nd_btt = to_nd_btt(btt_dev);
diff --git a/drivers/nvdimm/dax_devs.c b/drivers/nvdimm/dax_devs.c
index decc70f2fe3ff..4d4048578efac 100644
--- a/drivers/nvdimm/dax_devs.c
+++ b/drivers/nvdimm/dax_devs.c
@@ -113,7 +113,9 @@ int nd_dax_probe(struct device *dev, struct nd_namespace_common *ndns)
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn = &nd_dax->nd_pfn;
 	nd_pfn->pfn_sb = pfn_sb;
-	rc = nd_pfn_validate(nd_pfn, DAX_SIG);
+	rc = -ENOMEM;
+	if (pfn_sb)
+		rc = nd_pfn_validate(nd_pfn, DAX_SIG);
 	dev_dbg(dev, "dax: %s\n", rc == 0 ? dev_name(dax_dev) : "<none>");
 	if (rc < 0) {
 		nd_detach_ndns(dax_dev, &nd_pfn->ndns);
diff --git a/drivers/nvdimm/pfn_devs.c b/drivers/nvdimm/pfn_devs.c
index 8fa9c16aba7ea..39b8d5eed7ef5 100644
--- a/drivers/nvdimm/pfn_devs.c
+++ b/drivers/nvdimm/pfn_devs.c
@@ -637,7 +637,9 @@ int nd_pfn_probe(struct device *dev, struct nd_namespace_common *ndns)
 	pfn_sb = devm_kmalloc(dev, sizeof(*pfn_sb), GFP_KERNEL);
 	nd_pfn = to_nd_pfn(pfn_dev);
 	nd_pfn->pfn_sb = pfn_sb;
-	rc = nd_pfn_validate(nd_pfn, PFN_SIG);
+	rc = -ENOMEM;
+	if (pfn_sb)
+		rc = nd_pfn_validate(nd_pfn, PFN_SIG);
 	dev_dbg(dev, "pfn: %s\n", rc == 0 ? dev_name(pfn_dev) : "<none>");
 	if (rc < 0) {
 		nd_detach_ndns(pfn_dev, &nd_pfn->ndns);
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index 0766a6949b285..efdb804ad5d78 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -632,28 +632,25 @@ static int nd_pmem_probe(struct device *dev)
 	ret = nd_btt_probe(dev, ndns);
 	if (ret == 0)
 		return -ENXIO;
+	else if (ret != -ENODEV && ret != -ENXIO)
+		return ret;
 
 	/*
-	 * We have two failure conditions here, there is no
-	 * info reserver block or we found a valid info reserve block
-	 * but failed to initialize the pfn superblock.
-	 *
-	 * For the first case consider namespace as a raw pmem namespace
-	 * and attach a disk.
-	 *
-	 * For the latter, consider this a success and advance the namespace
-	 * seed.
+	 * An absent or unreadable PFN/DAX info block allows probing the
+	 * next personality or falling back to raw PMEM. Other errors
+	 * are propagated, including -EOPNOTSUPP, which causes
+	 * nvdimm_bus_probe() to advance the namespace seed.
 	 */
 	ret = nd_pfn_probe(dev, ndns);
 	if (ret == 0)
 		return -ENXIO;
-	else if (ret == -EOPNOTSUPP)
+	else if (ret != -ENODEV && ret != -ENXIO)
 		return ret;
 
 	ret = nd_dax_probe(dev, ndns);
 	if (ret == 0)
 		return -ENXIO;
-	else if (ret == -EOPNOTSUPP)
+	else if (ret != -ENODEV && ret != -ENXIO)
 		return ret;
 
 	/* probe complete, attach handles namespace enabling */

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.43.0


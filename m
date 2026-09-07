Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490843FC5CD
	for <nvdimm@lists.linux.dev>; Mon,  7 Sep 2026 06:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762887; cv=none; b=Tn3Wuv3AX2b1CZlnWjU1cIbNOVziU5zsi3D9J3v6/OkMD04GzqZ/aWEvQ+i5VsFfnNY4JEVJuHtdv2ceiVNVevLQYatIXf+PtPDWw9uD5N0yQJSKrZS3Kr8ZDhUxrVhZGB7Ywv3mSjRR+zzKiNf3uIOjWwacde3ME7d0PO0S0eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762887; c=relaxed/simple;
	bh=Ql863CIdFrhai+9amEdxgVMwOZcomyaSzXXOF3BjFUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gnPQPsqDibVap0XyzJqpIFBgaAgyrDbJLkcDdNNxXTYJcpN/0MDYh8G+AQLO/Bz5uw9NzonsA1/SCQpQS6dGCTU14NI/+HEFVx6EETdlIUz3zQYEXNvPr1OtUIdwezBgHKhPLXyyHbRs5oX5/9V3QVe0dnmFtUTyy0WEh01Cqag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bUhty6Mz; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bUhty6Mz"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-398e9698a70so2736590a91.0
        for <nvdimm@lists.linux.dev>; Sun, 06 Sep 2026 23:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788762886; x=1789367686; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IGXRzybwUI7C7o2runxizvTUVf4fxrOoRZ8hpY+ozB4=;
        b=bUhty6Mzb8obMXQG150dUqrwxf8j1Uv4GHiDPUecx6CFV/48h3YQRopRjkXSMrBqlC
         NKvOBn9uFysx2J4ktV+z3tyLQjym/xbK3Yu3fnG/0sbzO/0n7vz0MwtBc2mYozabHvXG
         rAFQd8c/xi19ZP9nIsKM/Wm7l1zByL7tD62lDAOm44Ti27WojLDmTUBQy62UiHw+Trnn
         UNB1BUBDW9+BTv5aGoj53LXo3ai4rLbaP+EXMrS66xYRVjolsPf5EXSntanCmYw1Jnz9
         mk23EwqKOinnsQbUjkLaOomOIdeR7JF5TfEWWaCnLVFbxBjOzWgiyOwsopTtQrvauU3X
         HlNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788762886; x=1789367686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IGXRzybwUI7C7o2runxizvTUVf4fxrOoRZ8hpY+ozB4=;
        b=p0czrHjtMF09yYfwxFXsk6qZWcDuSB/U6cyB5gGIdY8VsS1TP7/NhHFDYOjO/1cBxM
         HZcuzqvmRLh+lPKuVi6er996X+8dkOYu9USx4kpkDoooUW2APW28WiRZERgbGU0nDvVu
         gEvGCbUGZnXt8nuFbNaYybw78Ul7dO2xTnFmOCGpEKHI8LV6Z35L8wqsXoRu5vmgDAfU
         wAxjrgsQvvxdpLYkrCPBZV3MU/OxA5lvSnqF2+WA6Z2CZ/g7Ak16bzGV6BgiYDWL67LH
         EGKu+2zRnmjSvoYPIYuo1W16qbZdg0YeNsqt9uK0Te2Gz5epeWZmcf4p/fJibnjPRcqq
         AhvA==
X-Gm-Message-State: AFuF++lpJUNW0CnlSuDfPW0ZXwSU+d6m7h12G0Rh9P0fmWX2klshPVZ7
	HT4vYe7+zr4PnVp6gwk90/H19achehzOoeofR4fW1czTU+q3PvwTHcjw
X-Gm-Gg: AYBFou32RPuweIleoz0zdODr8Gor/MiTuzeMph9r2UdNqekoBGcbnUdqXK1bcTLZtyI
	pY6Pmz/lVmtHjs/YeFQF0Fgen7jDn2ElHFgq3eTBlu7IkdwbEhNmdH5QuikEo8s08Fmj7t974PC
	HXOoD6dlPBvtinL9Q60pwf5jS3vLtxpNk/aziPrJNPhDrQfoE2alKdmAw4hqcMJHpS6r6fLs4u5
	XI0R7f7x+Qpt7R+1d3B6WwswzXLtYcfxh2X6wVlUcuMlAPdIrKTMQYvu/vbpeseyBBF+eJQsKnt
	kJvY4H/PzrzcWVvF4wGbKF6Q8zG05/yH3Gc7Sz75FeflaBpiVJbyEFeGBgXHZUkMTq4yJKp9aQf
	AaSD0dSMIrHhE+V8km87zf8oic0EH4H1Raqqr7gvlSUh2BMGZ2sMTWJeNlxgSWqBjQ/BRes4KDc
	eQ+jhLNAwNASrXiq4SPTm1tNSWAEHL7Z/97+Oj0ZBJh767/hOGC/ppVzCvkBVasSWGzh3LX+g1S
	avKPR2aPRlD6RI=
X-Received: by 2002:a17:90b:5243:b0:38e:c232:9d3f with SMTP id 98e67ed59e1d1-39b2614df1emr33143914a91.5.1788762885565;
        Sun, 06 Sep 2026 23:34:45 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432441f5f2sm27634416c88.15.2026.09.06.23.34.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:34:45 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] tools/testing: fix repeated word 'from' in comment
Date: Mon,  7 Sep 2026 12:04:34 +0530
Message-ID: <20260907063434.23060-3-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20260907063434.23060-1-hemanth.selam@gmail.com>
References: <20260907063434.23060-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Drop the second 'from', reported by checkpatch.pl as a possible repeated
word.  Only touches a comment, no code changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 tools/testing/nvdimm/test/nfit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index 009fe107b0d7..b1802456fbc4 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -59,7 +59,7 @@
  * *) The first portion of dimm0 and dimm1 are interleaved as REGION0.
  *    A single PMEM namespace "pm0.0" is created using half of the
  *    REGION0 SPA-range.  REGION0 spans dimm0 and dimm1.  PMEM namespace
- *    allocate from from the bottom of a region.  The unallocated
+ *    allocate from the bottom of a region.  The unallocated
  *    portion of REGION0 aliases with REGION2 and REGION3.  That
  *    unallacted capacity is reclaimed as BLK namespaces ("blk2.0" and
  *    "blk3.0") starting at the base of each DIMM to offset (a) in those
-- 
2.48.1


Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4983A3F58E1
	for <nvdimm@lists.linux.dev>; Fri,  3 Jul 2026 14:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783090165; cv=none; b=VUM41mpbmbqo5YIHmWsp1HGjb+tOs6pVbKpkfgRV30BLLA1xr+Nd2hW1eUw4yxy2nCHkIKfBzlibs7OCmssHW+Fl1WV1Y0TEe6KKR4CIWNakWkxYeDtxtgiOJ38GmKbfxhNiJKmC1JbMq3SUUQzghlyR9zgEALlnhGwiCP4BxKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783090165; c=relaxed/simple;
	bh=uRid3eL/VxSq3eZBqfbHBU9T31HrNfJLPuY0heyVGSs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=L/SdUHkxSB9/YeEroKkeuHofq48UbPYJObAz25IZcFZFexnqVHgmqxhL3eT9kLMSGwEEcmN2gXRyrIhiCCt5IZSo9wYmBdHqwCX8hdbtwMvrUTEVlxK4+Qj/BT5Ym9y7yMKyX5uEr9nlMPvqA2cqQfGFGmY4bnHQKLRiQsehbzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UVXyPBMw; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UVXyPBMw"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-c96cb024ee0so459114a12.1
        for <nvdimm@lists.linux.dev>; Fri, 03 Jul 2026 07:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783090163; x=1783694963; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=DbbkU6ft1I7DR2Zuvn/uSRD/TRkfhQXU+lS2f73m8xQ=;
        b=UVXyPBMw0spF+FBo1AP6znQrnw/CPWn9Eey3IbSbDoN7P2ncOzv3wNyr4Bijmr0nwL
         TKW1vFc5L02Knn1zaQVWrReGX1/r1mWzVax3H/C5nz3h8X+e/uikI9l70Z9tIsWyIu6Y
         KYEHWWG0IrVz5lbVBvvWmMZGGNAQYJanhzB0vlM+MgQI9jAPJQKbJo7xlb8L1/TyAtcg
         6jsL/blco7bDLbKgmfSr4G1mSsP1kSH0qwDcSsDjjxChyIER0QgbDQcfhX/gtSxSUP/E
         r6d6+oV0BTRO4go7n6LqUFL9rd66VFVkL8PBMAKCR96rvKRkkHYb164XhOATajZ4SLhG
         f6qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783090163; x=1783694963;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DbbkU6ft1I7DR2Zuvn/uSRD/TRkfhQXU+lS2f73m8xQ=;
        b=bNpR5QRGik2kL2u3FUDO5SA7L2X/HMEEE3SxtVEQ86RT/MxthlGLaUg+pXArxLvvzW
         FpLH+khIVRdrUzeMPVgvuJNKoek+fHVnSYGwazbXv+IwN//qXi0KnUhNuZSFvUd7hURz
         w0AGR3+FiKACghRsimHzWtarCqJ7erJazi4GUrP1powcjq8J+gMozHRYExwFbsu94fYN
         AyoZJoKPBEelJR/cIJmC33pbQKoZ/YkqVyghvGwl/2PTgaQwlM/RaGO+k4Leuzgej0Wf
         djR5rX4yYbFkZh64MeC/18P57bIVIKUQmOsyZxVdJxAh8K3WMTK1784KjRh/ZPRtrDXP
         X1iw==
X-Gm-Message-State: AOJu0YyJ6XCfboIadXxTCyuFD3TizjsysYE2/SlFS4hCR440m5bC3LZT
	Gm9+Cy2YBRtefdTD6x+r+INnZqXLP728zAw9VpYLU++5Uo+JUNZebBwa
X-Gm-Gg: AfdE7cnOuLMP0ITmgLEj6E0yLpLcmPWLKsi1tPFJHR4HpFDM9VgEOmQIXKh7GJt5mxG
	iiGhc2Ris4gbFCuAkmaH/AEdj/UPcPAp8GD57xPl55Gw8/wNd2UtTbE2qjsILaK0oMSYU3Of/uW
	h9O7xTxtsKEkGrFstjn8JNAWcQFYyHPgcmbpTZGVwPHgzryQroBf+cnhwJ8VGYxqfEsV80ZHMBd
	SYw4kdbOmuTWNuwIz26dUxEQQHqZDahFbUhNyM/eED8YySQ5XrOkFJHDgqvDFlzU5df3Za4hJqr
	cDeUH3uVtkwmt6aHRcl1SMBi1eyw/QtySLeWb7aEooEJ/vZ4jF5ZG/nDiEjYRHJwgrrgXrA2P09
	b//PcaeDt+bBa3phbP9GcE/6E62hobjJtYsm9bPppL6l/aa5ARzfJaeTJsxlwp8awmSxPKnjoih
	twnbH0j/0HxQ==
X-Received: by 2002:a05:6300:4c:b0:3bf:b60b:da95 with SMTP id adf61e73a8af0-3c03c717507mr139694637.60.1783090163488;
        Fri, 03 Jul 2026 07:49:23 -0700 (PDT)
Received: from ubuntu.. ([2405:201:8026:213e:4288:f1d2:acae:80f])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30f3b252222sm1662490eec.23.2026.07.03.07.49.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 07:49:23 -0700 (PDT)
From: mdshahid03@gmail.com
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mohammad Shahid <mdshahid03@gmail.com>
Subject: [PATCH] nvdimm: nfit: remove redundant NULL check before vfree()
Date: Fri,  3 Jul 2026 20:18:51 +0530
Message-ID: <20260703144851.80309-1-mdshahid03@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mohammad Shahid <mdshahid03@gmail.com>

vfree() safely handles NULL pointers, so the explicit NULL check
before calling vfree() is unnecessary.

This issue was reported by ifnullfree.cocci.

Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
---
 tools/testing/nvdimm/test/nfit.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
index f87e9f251d13..009fe107b0d7 100644
--- a/tools/testing/nvdimm/test/nfit.c
+++ b/tools/testing/nvdimm/test/nfit.c
@@ -1644,8 +1644,7 @@ static void *__test_alloc(struct nfit_test *t, size_t size, dma_addr_t *dma,
  err:
 	if (*dma && size >= DIMM_SIZE)
 		gen_pool_free(nfit_pool, *dma, size);
-	if (buf)
-		vfree(buf);
+	vfree(buf);
 	kfree(nfit_res);
 	return NULL;
 }
-- 
2.43.0


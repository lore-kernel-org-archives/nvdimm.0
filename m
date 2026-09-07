Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882833FCB10
	for <nvdimm@lists.linux.dev>; Mon,  7 Sep 2026 06:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788762885; cv=none; b=Gzuyv6YsBzWQZMaFor9kFg9wjvkJ1enyISCl8xjY5AMCScS10GQUclXXBS/2PIzcnB4rFSLhqt5KQna/k1Ne5HJJN85I9TewYwX5FkJqzHRY9UeIUnhnVX/sO0bYhWdDCTIvH2b3YFiexMD/EX602DVhasZybKNZUrm2Hz6LalI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788762885; c=relaxed/simple;
	bh=mF5bB7ZuCeAivvXX11QVrUiyugh1yN50bL/u3C6zj6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZPFq08mkIbtRhVM7HZyr60Yas0AvLuPIa6WpX0gAz4T7LHXiR+A3+cgeapBcZeHqzdcy1JpTddvdzock+i6qPBL9stTv3K2VmqRyqISZjLFg5xQghqdTQtnB3cASPMI5DbFcR9foAPDvmhpRotBN6/EfgJd3Ot+APYdRRLHkfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BLNfeiHQ; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BLNfeiHQ"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-85377c8bc96so2872917b3a.3
        for <nvdimm@lists.linux.dev>; Sun, 06 Sep 2026 23:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788762883; x=1789367683; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WWG6h0UUZGYCltMe9vagrJc+4k4VjMae5SVmtvIpYNk=;
        b=BLNfeiHQX5g0mD66qVy/fRzqmJyRBPPO00jUGNrRgevX1dX2+ToXX1xNGUwHcyFCxU
         p6A0F74DJyXX+kd2Enes5e8kk3XhaICOtQ9qs4rCjF9SBuwwcQYgDUFHE41Z5vZzgIz/
         uMFTbQZDejIznWID4C+us7+5A5HNuA+ZPdSjM5wZYweHgpzHAUnZZymEDUsKpXslS1xq
         fpgnmQZfMWhZNRrJNH70iZYgG29En7AY1v98X8alKyEe5pxXdTbwQ/KbA5Osq3uRh2cB
         uup6aG3df6C1d1wczKsmOJdAp2pX/baoilelDuASy7ErXfd+yZwfD7a1HKl+dUupIwry
         W+xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788762883; x=1789367683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WWG6h0UUZGYCltMe9vagrJc+4k4VjMae5SVmtvIpYNk=;
        b=iT9veCAtdQvTisabHfML9kgQBBq7JctVPeQHwpofKzQXNv4JziS++wIbSlwf0T6U0E
         KhqJLMslyNtGgDkrWZ+/3e49wSjNh2o2gLBlQbSRiByQoH7IWVsOjOpCI6L8TCMUQ3Ba
         uFbbNnXH88SPtWmTErZpZoKRTzd5RckpjriVt2juDBXlTuoKIAdJZ1O5+uchDOmVIjpU
         YDPNGc8nxQ4xktywuZnA1XCESziFh882CnKIFkB7Q6+GGTDCQFg2DAATL4Ow/xxNztZo
         Ee98gDEC8uE8WPjjGFHwdcCWiCtl9raVRZWjtiPNWUBGaDf9A0qLcrvEeej85M5HJmuW
         d9IQ==
X-Gm-Message-State: AFuF++kRXVXZiCGDWeS+44+Sp5BGxYkB2+UIhZLkL1W2GE7RzceZ6RDn
	FQ7cnTWTdT3+hzaTY5dUoTjrW6SeR5h+2APUaoGs7ELa1daxBWWzrii4Nbjm3OY20aQ=
X-Gm-Gg: AYBFou2zX8joB9UBy4006rTXZWZUitWvJnMB3Pj+4yA9Ly2pkebnI9Hjxv0mkLbrLjx
	qa4T6i3c152j5Zk+4QEmcUOM9meU2kLhfVHde6ipjDQZRv6ugxwut1Je00NBR9ZqEi9zrqs9xMZ
	ZjM/QoJ04GBIgUdwv7sKFD6i2PFPCIeMKevOwtutfvKQ33MHeYsysBM1UlMtvUFRgCztMKErbL9
	+MW8CaZLo6gLUowsNBCx6XhImmdUKQpuAJzVTDVrxi3qGA+Rxv4uXTjh5oquJMCvxG7f+Rdqqa+
	BPn402A7GLsGWpJb9a7EZE1V7coktjTmUwQVGdkoFgUVbyFStvqYfixu6jHP0ONFOp3gSx2xIk8
	wQl9R40alE04DfFV4h3C2N/BpudieLxdNb2hWXjkQrKqJmySI1K4vg/rzZMTQ2ze4Rd7ThFL+Wq
	7OhAxstdCv95MX6s6Fdxykwhyl4EP0hP7NmRsptvFwr1LpbzAAjfItSwxSb/eY92gY2KKcvvfI1
	BoDqSg63dQxsA==
X-Received: by 2002:a05:6a20:3ca8:b0:3c4:46ca:334b with SMTP id adf61e73a8af0-3da39cf4744mr31751078637.9.1788762882626;
        Sun, 06 Sep 2026 23:34:42 -0700 (PDT)
Received: from volcano9f6e-hostos.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1432441f5f2sm27634416c88.15.2026.09.06.23.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 23:34:42 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] nvdimm: fix typos in comments
Date: Mon,  7 Sep 2026 12:04:33 +0530
Message-ID: <20260907063434.23060-2-hemanth.selam@gmail.com>
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

Fix typos in comments, reported by scripts/checkpatch.pl using the
misspelling list in scripts/spelling.txt.  Only touches comments, no code
changes.

Assisted-by: Cursor:claude-opus-5
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 drivers/nvdimm/namespace_devs.c | 2 +-
 include/linux/libnvdimm.h       | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 557fe0cb43e2..4935c6508448 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1448,7 +1448,7 @@ struct nd_namespace_common *nvdimm_namespace_common_probe(struct device *dev)
 			return ERR_PTR(-ENODEV);
 
 		/*
-		 * Flush any in-progess probes / removals in the driver
+		 * Flush any in-progress probes / removals in the driver
 		 * for the raw personality of this namespace.
 		 */
 		device_lock(&ndns->dev);
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index d929d83abf3b..586421b86162 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -59,7 +59,7 @@ enum {
 	ND_REGION_PERSIST_CACHE = 1,
 	/*
 	 * Platform provides mechanisms to automatically flush outstanding
-	 * write data from memory controler to pmem on system power loss.
+	 * write data from memory controller to pmem on system power loss.
 	 * (ADR)
 	 */
 	ND_REGION_PERSIST_MEMCTRL = 2,
-- 
2.48.1


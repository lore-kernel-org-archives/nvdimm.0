Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107473A0B24
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791673069; cv=none; b=cVmiGeh0uZtw3kDm9U7KMfRuVrlnPzK43lXG8ILd9GTk1cPsco9bATpcRg70igyhBCfBppAtQtaBanyBrmNBz5iL0lowKltGIrTdtRqwu+0VIPeWq1y11LQoFuYo/B2E2SS+wtPTjcflNgRMnfU8Gxpum12rjlrm/wY7i+WMeA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791673069; c=relaxed/simple;
	bh=JnmxjIlhNrqNDcxHSzbYS1DDAMqga2BAmEwhynazEsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyLcOgA+xnoNbGigKAnBWQAs9h9ljxGUf/vG52x+swOeCL3dkrHnpcSXiB3y7+uOwhlho8vRHjMqtFa0BgqkrmOFnMEz8m12nSVYiUrfBlu/gcfFa02mclmBOPWHMrYWsV2tAtijIV4NScU5jIvZr52XVgHDMFZszFV1755KVhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRFYnStK; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRFYnStK"
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-88bd2b44f3aso319498b3a.0
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791673062; x=1792277862; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1YTLtaT9iHCUU2BwSqHbgs21TBjanDGosXtNAr9CKhM=;
        b=YRFYnStKD58lYP168+y80TflFvWN9chbAjN8vNxr6bEDrnskCUt5H+7Um5EQfXltca
         zA9DUtObkhjxCisgWvH20dZZxhDRZE7zgtdXfSFlbV8z2vXgoqwft8iwJoMVs9RbpfpR
         t3sxpDtY8DLiJ9c/OItmoxu2KoOKKn40eGgfK1G2jQH6NwP3JHdydQVCMGeEMC9pzsA3
         CkD4UBnfDZaurDDVQgaa8o/x8/1vrLLKYJy13DsGO9cAuk+oyoOq9ul7TAbue8e0fFjF
         YXqFh90xj1LF9X6QMYcHwx0FqtZe2J+zJIb85NtGVxgvZp1s9c3iykX8bKiGMjikEoZV
         416A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791673062; x=1792277862;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1YTLtaT9iHCUU2BwSqHbgs21TBjanDGosXtNAr9CKhM=;
        b=FkhoLormNkxjpb9uT80n0V9JVbfiF5NFSTXeu0TVQiFlShfVW2yew86JNqM88WfKMt
         jzFrVKXMc8G7GZzqHnSxnM/8P7/IbKrI78xz51VRciV7oIywur+U/hq7k+1CBo57GZiJ
         2KVHzM+wBSybriC8D6TorVRP7Q/+PYbG+NF5nfRCOZDSzIa8SeJwd5uy1tA3WX6Lb6CR
         t8TjaHmHw8bdtUr+9rYHrXMNO6C1txYLHx+I2P7iNtvZUogRUqNd/wNEwZ8pN3hIKndy
         DubWVDBot15BQnQHh+QD8cklRez5n5Kp7PMHbnn/lMnTcx3iqfCBnkKOH/SQI33FRX+D
         e2yQ==
X-Gm-Message-State: AFq9FYJLF3ie5fxtICm2ODI0Y1bJ44brlbPHNkeBaJBkOkR/toj7JDRr
	HWuvHD1E3hJyIp57e22TGsm+YF2utgrFtfpOgDu0wRtSJI79bxDvLp6e
X-Gm-Gg: AYBFou1UwOcEweBuMnaBOiFRO5NyrKLPKYz4u5/2X+zyLHt9jQkMYQzEAfb6VSwgrA6
	50YXfjXu3GjMwbgZVr73nvJxGx2xl6fsU1gZ6pTmL1L16hk8fNp8/j3diIW4b23VRL+Z4oXCVWH
	aHzHeRenAeMhDYM/X24qBJtrs2qcM3ViT2NDTClIGVg2X/vHdyogzKqlug4FSR/peGCUQWBixgz
	s6rxfCjjQuJWeXLbbmrI69o0mJaj/G3HaSwGJ1fILuZfxjEk3JuTjMdHxviE91WFtIKVesLEhWL
	X1GEbb/KGmIxQX48bs4kvslWXs2F69fOGC/ZZFgxmI2d4EEyIqUerc+E0J9enPu1X0zPtLn6s4o
	ufcJDXLH2AqcESBL4NcvE4yxW3EVa0jIcbSfFxJkEV2lVJ2KolW4SVAtKfhScyYH9YmRGl3bg8m
	/Y8+1xXUGG0mE/nxyR1C7H6lNeL72FvkOMxgHH51+OaxF0Zy2kzYkd+Wzmyi1k3tkXcMC/Dfiex
	/2KKAQUAxtdONRMCqDfai+lubmz
X-Received: by 2002:a05:6a21:178a:b0:3d3:ad3c:49a9 with SMTP id adf61e73a8af0-3e16be86b53mr4752997637.23.1791673062136;
        Sat, 10 Oct 2026 15:57:42 -0700 (PDT)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e07329sm2603662a12.5.2026.10.10.15.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:57:41 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v16 8/8] Documentation/cxl: Document DPA partition layout and ordering rules
Date: Sun, 11 Oct 2026 07:54:59 +0900
Message-ID: <20261010225852.10727-9-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010225852.10727-1-anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DC Partitions complicate DPA ordering. Add a DPA Partitions section to
cxl-driver.rst describing spec-mandated and Linux requirements for the
layout.

maturity-map.rst breaks the DCD entry into sub-items so the map shows
what this series lands: partition enumeration is [1], event handling
and DC-backed DAX regions remain [0] until the follow-on series enables
them. The parent stays [0]; nothing is usable yet.

Suggested-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
---
 .../driver-api/cxl/linux/cxl-driver.rst       | 35 +++++++++++++++++++
 Documentation/driver-api/cxl/maturity-map.rst |  4 +++
 2 files changed, 39 insertions(+)

diff --git a/Documentation/driver-api/cxl/linux/cxl-driver.rst b/Documentation/driver-api/cxl/linux/cxl-driver.rst
index dd6dd17dc536..212df4fb8d63 100644
--- a/Documentation/driver-api/cxl/linux/cxl-driver.rst
+++ b/Documentation/driver-api/cxl/linux/cxl-driver.rst
@@ -181,6 +181,41 @@ A Memory Device is a discrete base object that is not a port.  While the
 physical device it belongs to may also host an `endpoint`, the relationship
 between an `endpoint` and a `memdev` is not captured in sysfs.
 
+DPA Partitions
+~~~~~~~~~~~~~~
+A memory device presents its capacity as one flat `Device Physical Address`
+(DPA) space divided into `partitions`, which Linux lays out in a fixed
+order::
+
+  DPA 0                                                     end
+  +---------------+---------------+---------------------------+
+  |      ram      |     pmem      |       dynamic_ram_1       |
+  +---------------+---------------+---------------------------+
+  part[0]         part[1]         part[2]
+
+Part of that order is required by the CXL specification and part of it is a
+Linux choice.
+
+The `ram` and `pmem` order is mandated.  CXL r4.0 section 8.2.10.9.2.1 "Get
+Partition Info" (4100h), Table 8-310, mandates that volatile capacity starts
+at DPA 0 and pmem starts at the DPA immediately following it.
+
+Dynamic Capacity partitions only need to be 256MB aligned according to
+CXL r4.0 section 8.2.10.9.9.1 "Get Dynamic Capacity Configuration"
+(opcode 4800h), Table 8-347. So a device could leave a gap between ram/pmem
+(static) capacity and its first DC partition, or between one DC partition
+and the next.
+
+Linux chooses not to support gaps between static and dynamic capacity: the
+first DC partition must begin at the DPA immediately following static
+capacity -- after pmem, after ram on a device with no pmem, or at DPA 0 on
+a device with no static capacity at all.
+
+Currently, only one dynamic partition is supported. A device may report up
+to eight (CXL r4.0 Table 8-346); Linux configures the first as its
+`dynamic_ram_1` partition. Gaps between DC partitions are not checked, since
+only the first is used.
+
 Port Relationships
 ~~~~~~~~~~~~~~~~~~
 In our example described above, there are four host bridges attached to the
diff --git a/Documentation/driver-api/cxl/maturity-map.rst b/Documentation/driver-api/cxl/maturity-map.rst
index 282c1102dd81..fefd31899229 100644
--- a/Documentation/driver-api/cxl/maturity-map.rst
+++ b/Documentation/driver-api/cxl/maturity-map.rst
@@ -150,6 +150,10 @@ Memory-pooling
 * [1] Hotplug of LDs (via PCI hotplug)
 * [0] Dynamic Capacity Device (DCD) Support
 
+  * [1] DC partition enumeration / configuration (Get DC Config, CDAT DSMAS, event interrupts)
+  * [0] Extent add / release event handling
+  * [0] DC-backed DAX regions
+
 Multi-host sharing
 ------------------
 
-- 
2.43.0


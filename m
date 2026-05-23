Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42B1C386C3C
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529431; cv=none; b=jKJZCc5Pp9wYLzecdTfSYD+8rEpn/YtnT0In36GH+gme4kW3ftG3GXlBUcyers7liYkYyvIMnecFbLhMweai9KNNz6ccvFy9OqREltBqyLOv9yu0Z3KXihqgsHjlUZ6uOp82bkCb8x+VUAsMa5+4qW4kqmRbo5sGA0+WtukfPnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529431; c=relaxed/simple;
	bh=bhkVV5eWL9q2QBEtj+qST0UkfpKTX/AYf0RWbT4RAzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9VfovJKgoJrkeTyazsCENd0esVJNHxa0DbUpcvc8gX9Ly4LA0+mx8gQng4BCwbtTBHkp3XviC1a4YX1jm+OtuHY98/dvlrmX6PU/XY0kXXwQzkU77uoNFWKIql7evOJORlmBPQUJ4EkQAx+VgQSymzeZAjm4Lfsz0Ki/zwSKKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=URqbbT0B; arc=none smtp.client-ip=74.125.82.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="URqbbT0B"
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3044857f09aso2978994eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529427; x=1780134227; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7WfczXqcXBpP3sctFNC30HRypl1xDvSsdjoS+nUQlBk=;
        b=URqbbT0BtDJ7gCsLF9V5eluEO5hD+ZYzYg2v/sHVuqWkmO/F2X2BhC3xige+vEgvAi
         1jkv4/N0kp0Tz+D4DDbz5JhvFB/DCfsHrbULCJ29Q8HE2et3atD+OIkfNjmlDCroQaOL
         Z/9BL/Vq4yri6SYgc/9PS72DGsrzTxIc5CqIdnVTH1Bq02u5Ynr06Yf3iUdEmd8hQy82
         hy547szqtbJGCO5GyMQNWvENef68tepo0SsaU/8LVzE62FYKQawzhXoc09Q4JcI42Rbv
         a6FKj4C6UC5uv4f39PjOsa8yxPzwCNdDZPboV7XUVnpcG5B9+3uBu1rKh8Jk0nhvxN+V
         S+rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529427; x=1780134227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7WfczXqcXBpP3sctFNC30HRypl1xDvSsdjoS+nUQlBk=;
        b=Pt+EjVikVMoBM+JJCe1qDD2wvomYy3ALCXcbbD1vedP2SD+R1BOQ6o8fFKZtoaNCns
         FKLFFMYcI/pb3yEtC246+oPhU8q0EM5XrrCBksVaSPwUxDmg9bq3NVLP7yoxj3GDnfYO
         +uP573GVuTjlXncHFo0NPcDCHkQdbvrtqw5JvW6/FTq7foDBTBTVYxeGpoe/GhZjKDHf
         ssWSYldQNYT1pFqw/QIZICLFJMS4w/LNLDneqKmPOyfqLsIPp9WsH8if5OIAev/Ci+iC
         0TbM2s4l6knm/ORL2SnjN/HHaJ1jn4aDtqWm8ATwNX+PEXlfA6f82WJCFrovXRubjdd6
         oEwQ==
X-Gm-Message-State: AOJu0YwzCEcEaq44dVL4DBMM6Z40juLgccdo72tVPTd6h3cMlbetsw16
	VzQK0qINeykE6WwYXI9hjdzcZ9tucE8ZgreC9f0z+Yxzfoynkb9acnlLfUk17A==
X-Gm-Gg: Acq92OF7R3qIwDA763xlVaIWLkHMBbQT4PH1NjJgZePsJbk/CZMyk6PCj2rhQWGtu9B
	Sv3RUhrYENvZS0W8s4kLuEvXpC4MMLQ+UhQ6eQXnExd+mb7KslTA7nU3SS69+0eo5Zw39A67hzB
	oBpiXE9vnfuZB6rn2CXx7NPZUcKFq5KpkHHOrXm5wvZDcishPz/QaSz4lFDecQVd1UuXuXvDBPD
	+HyVVBe2iW8KQGPjo2NYBzP3Ghfmiz5Uh3cI4aCPv5r68G6TNJidLYQ2C7Fb54DwJjWKS3T9MhG
	3NG2PhpTTqP6fKQurHr1gzTfJCDynRBAvnosxVx+uup/RLJ/NvsLLmLL5YZBBDz13VhJpTryFTp
	FsArZg+zeQ9K3GH2BPQHPHX7Z0wNeG8MsKHmBzuJiGVcuHpipNPaVjx63QBqRWIRRYn7RzOucWF
	YyQwhbz+dkA4oezzqqK139vbfTB/Q6FAdHuemqPqc2AJnWaraGpZxaL1Wy/gMlzsKSmsFqJQkgP
	PJ4B7B1gctdwGTA1Y4/WmrfHcWd
X-Received: by 2002:a05:7022:6893:b0:12d:f0b1:75de with SMTP id a92af1059eb24-1365fb424admr2816473c88.22.1779529427374;
        Sat, 23 May 2026 02:43:47 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:47 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 06/31] cxl/port: Add 'dynamic_ram_a' to endpoint decoder mode
Date: Sat, 23 May 2026 02:43:00 -0700
Message-ID: <58e5e5007cd11e0b8e65016f126144f187badb39.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Endpoints can now support a single dynamic ram partition following the
persistent memory partition.

Expand the mode to allow a decoder to point to the first dynamic ram
partition.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: rebase]
---
 Documentation/ABI/testing/sysfs-bus-cxl | 18 +++++++++---------
 drivers/cxl/core/port.c                 |  4 ++++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 3d95c325f6e0..c604c7ca6432 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -358,22 +358,22 @@ Description:
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/mode
-Date:		May, 2022
-KernelVersion:	v6.0
+Date:		May, 2022, May 2025
+KernelVersion:	v6.0, v6.16 (dynamic_ram_a)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
 		translates from a host physical address range, to a device
 		local address range. Device-local address ranges are further
-		split into a 'ram' (volatile memory) range and 'pmem'
-		(persistent memory) range. The 'mode' attribute emits one of
-		'ram', 'pmem', or 'none'. The 'none' indicates the decoder is
-		not actively decoding, or no DPA allocation policy has been
-		set.
+		split into a 'ram' (volatile memory) range, 'pmem' (persistent
+		memory), and 'dynamic_ram_a' (first Dynamic RAM) range. The
+		'mode' attribute emits one of 'ram', 'pmem', 'dynamic_ram_a' or
+		'none'. The 'none' indicates the decoder is not actively
+		decoding, or no DPA allocation policy has been set.
 
 		'mode' can be written, when the decoder is in the 'disabled'
-		state, with either 'ram' or 'pmem' to set the boundaries for the
-		next allocation.
+		state, with either 'ram', 'pmem', or 'dynamic_ram_a' to set the
+		boundaries for the next allocation.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index 0c5957d1d329..a7f71f36531f 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -128,6 +128,7 @@ static DEVICE_ATTR_RO(name)
 
 CXL_DECODER_FLAG_ATTR(cap_pmem, CXL_DECODER_F_PMEM);
 CXL_DECODER_FLAG_ATTR(cap_ram, CXL_DECODER_F_RAM);
+CXL_DECODER_FLAG_ATTR(cap_dynamic_ram_a, CXL_DECODER_F_RAM);
 CXL_DECODER_FLAG_ATTR(cap_type2, CXL_DECODER_F_TYPE2);
 CXL_DECODER_FLAG_ATTR(cap_type3, CXL_DECODER_F_TYPE3);
 CXL_DECODER_FLAG_ATTR(locked, CXL_DECODER_F_LOCK);
@@ -222,6 +223,8 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
 		mode = CXL_PARTMODE_PMEM;
 	else if (sysfs_streq(buf, "ram"))
 		mode = CXL_PARTMODE_RAM;
+	else if (sysfs_streq(buf, "dynamic_ram_a"))
+		mode = CXL_PARTMODE_DYNAMIC_RAM_A;
 	else
 		return -EINVAL;
 
@@ -327,6 +330,7 @@ static struct attribute_group cxl_decoder_base_attribute_group = {
 static struct attribute *cxl_decoder_root_attrs[] = {
 	&dev_attr_cap_pmem.attr,
 	&dev_attr_cap_ram.attr,
+	&dev_attr_cap_dynamic_ram_a.attr,
 	&dev_attr_cap_type2.attr,
 	&dev_attr_cap_type3.attr,
 	&dev_attr_target_list.attr,
-- 
2.43.0


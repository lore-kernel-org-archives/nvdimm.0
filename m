Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0D178F45
	for <nvdimm@lists.linux.dev>; Tue, 20 May 2025 02:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747707441; cv=none; b=pvu0oByWG/Q8/vzvtLA1TwXVmh6idczRFHbFiV2CQReRaclSE6MhN3VLg83+uTFC6JJ/wT++ybVAv+vnJZFEawkKwWLYOLFNKc7glGTJxSnUBBIxqqnOFAi/hRLXzj465opA044fMDHEARCY1lCN2XeTgHwviH6kFzLnuhXdfcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747707441; c=relaxed/simple;
	bh=0ELGpuT6X196vDWFxZcQyQLTCIT3NcPHZVI0ad0L2tU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=o2nDaGVxx3/TtAWdmO21qtZd5P6fY1LFI1G8TziiHBptoPCbiawLzqYYMzBJ0jaSXamcrLAvUsSh9OS8SLdXzs1fiMiiXUkoGydkR9oHmpLbsUMuU7b4YRE255yKTPEjost8m61SoIQZSO1PK33GhA/AdG9ES8BA6ZoiKnVOikA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=2wbrvJXD; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="2wbrvJXD"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b1ff9b276c2so3076177a12.1
        for <nvdimm@lists.linux.dev>; Mon, 19 May 2025 19:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1747707437; x=1748312237; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Qgc1WWyAa4IDJXeZMlquPom4mmmQ18LfyHJ9MogW4mM=;
        b=2wbrvJXDrz69BG0Lfo0ABVVGfxRC/OAO1Tz+B+DjH2fjPAeiySTYhoZOjXwnZDgEck
         W2mqGX2L5CuVv1YR3PIvvEDTFm8wxq4G2DoJXvdbtQWWsDd8sAM0PXttKrTVZJCWBKp4
         gC2r3GnGd7aG/EwzcWTp4wFPIH5iTKPRJnUXW/sqOsInT9PbT3ZjUIhjSOtt7E11YD4K
         VBUt7613W3mNgA/gXIFy3BcYRzenh+azTNQULkZgGBGKPGaFbuWKYREEwlwc+fsNJds2
         IU82MJ4Ap9ZPY46UT9kwm7mXYu62XmYcLbvw8pZpjmioaf+doJYfYqOIQ3UtZ+gOUtBN
         RvYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747707438; x=1748312238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qgc1WWyAa4IDJXeZMlquPom4mmmQ18LfyHJ9MogW4mM=;
        b=MrpuqQe+2B52WcQsA2eFLbVHsLwEW73mmSob2S/XXjyDGajMwFCfHturCVKC7HRill
         FmheBJ2vEs2yWfD2N2UZ33Fcvs37l9v3ABJSdEfsJvgV5jlx0REUOtMwNoUVaFRMr47B
         +xNeSyk8VvJutPXHYXnfJx9Ns95W/PV70ZIjqWFUiOsHuxli7EHPguAwj65uLtaKtzTa
         1ByGVkO/j9Hmx+4+QC5x6E+TKl9DXLBep+jwQaImaMF16TXNW8MDeP3nBx7WBGwkOjjZ
         hE8M6MegLafQLCye32a7rp+gYG80jZAeMXzfLll0Bj7766lP8vD49roa721yeleUTP+x
         VHYQ==
X-Forwarded-Encrypted: i=1; AJvYcCU8mVG72K/47zIu5yyAOWtKZ602UUhCnMwwMgNMzx8nLWYC+++b495NcJKwhefzle55drbRQN0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzRlmB0JPPjBW2RRegXE/UQr+PqwDG5I/qv9/dy07A6JBo5Hsub
	Cr87nu6oCjV+o5YslaNZ9O0FkRFfdLrM2exU9EjwFSxjr65YFyfTUy0mI3bvLaZ/ejo=
X-Gm-Gg: ASbGncspkIGE5WqaWkxTWXapOC+QS0f656FPz74OTJLKzlVPGUAWFs5Je5S+HCujJMY
	2/E7FO0eM3Ql9hJygmUMaok9K3eogVfxRSBMTrLkg/Hc2pCI+YoEXsdDQ9tiOWc5d9z0YcwXi1Z
	jRSlm9JciWFng2RWSxIQZzQ4FtWw3OedU2pI/ja4LEOWUO9PO3lnL2DgHjUpsG9/9CBEHuuUug8
	OKEbqsO7y0p94R10xdhGlvWJZg04Fji9SiKHC4LE3yO7qG+iIUBXxnx0Y6P88QQjJZuokVqXKvx
	wWUHfWS6u0GsxotuhfO9ZZ8nQXGYtb8dR/aH+P0OH5hrGitJja1IxterdkincysIUzOzKWkSTr7
	Hg8wWR+rgDQ==
X-Google-Smtp-Source: AGHT+IGIdIH2mqsPlYNb8bZRO78i8ULrukpluljyciVMskkMfers0XHXo5DCyjiVjVUdhAJ/Ropdmw==
X-Received: by 2002:a17:903:18d:b0:220:c4e8:3b9d with SMTP id d9443c01a7336-231d4596b26mr191179295ad.37.1747707437566;
        Mon, 19 May 2025 19:17:17 -0700 (PDT)
Received: from x1.tailc1103.ts.net (97-120-251-212.ptld.qwest.net. [97.120.251.212])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4ebaf5esm66904945ad.194.2025.05.19.19.17.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 May 2025 19:17:17 -0700 (PDT)
From: Drew Fustini <drew@pdp7.com>
To: Oliver O'Halloran <oohall@gmail.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	nvdimm@lists.linux.dev,
	devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Drew Fustini <drew@pdp7.com>
Subject: [PATCH] dt-bindings: pmem: Convert binding to YAML
Date: Mon, 19 May 2025 19:14:40 -0700
Message-Id: <20250520021440.24324-1-drew@pdp7.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert the PMEM device tree binding from text to YAML. This will allow
device trees with pmem-region nodes to pass dtbs_check.

Signed-off-by: Drew Fustini <drew@pdp7.com>
---
v2: remove the txt file to make the conversion complete

 .../devicetree/bindings/pmem/pmem-region.txt  | 65 -------------------
 .../devicetree/bindings/pmem/pmem-region.yaml | 49 ++++++++++++++
 MAINTAINERS                                   |  2 +-
 3 files changed, 50 insertions(+), 66 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.txt
 create mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.yaml

diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.txt b/Documentation/devicetree/bindings/pmem/pmem-region.txt
deleted file mode 100644
index cd79975e85ec..000000000000
--- a/Documentation/devicetree/bindings/pmem/pmem-region.txt
+++ /dev/null
@@ -1,65 +0,0 @@
-Device-tree bindings for persistent memory regions
------------------------------------------------------
-
-Persistent memory refers to a class of memory devices that are:
-
-	a) Usable as main system memory (i.e. cacheable), and
-	b) Retain their contents across power failure.
-
-Given b) it is best to think of persistent memory as a kind of memory mapped
-storage device. To ensure data integrity the operating system needs to manage
-persistent regions separately to the normal memory pool. To aid with that this
-binding provides a standardised interface for discovering where persistent
-memory regions exist inside the physical address space.
-
-Bindings for the region nodes:
------------------------------
-
-Required properties:
-	- compatible = "pmem-region"
-
-	- reg = <base, size>;
-		The reg property should specify an address range that is
-		translatable to a system physical address range. This address
-		range should be mappable as normal system memory would be
-		(i.e cacheable).
-
-		If the reg property contains multiple address ranges
-		each address range will be treated as though it was specified
-		in a separate device node. Having multiple address ranges in a
-		node implies no special relationship between the two ranges.
-
-Optional properties:
-	- Any relevant NUMA associativity properties for the target platform.
-
-	- volatile; This property indicates that this region is actually
-	  backed by non-persistent memory. This lets the OS know that it
-	  may skip the cache flushes required to ensure data is made
-	  persistent after a write.
-
-	  If this property is absent then the OS must assume that the region
-	  is backed by non-volatile memory.
-
-Examples:
---------------------
-
-	/*
-	 * This node specifies one 4KB region spanning from
-	 * 0x5000 to 0x5fff that is backed by non-volatile memory.
-	 */
-	pmem@5000 {
-		compatible = "pmem-region";
-		reg = <0x00005000 0x00001000>;
-	};
-
-	/*
-	 * This node specifies two 4KB regions that are backed by
-	 * volatile (normal) memory.
-	 */
-	pmem@6000 {
-		compatible = "pmem-region";
-		reg = < 0x00006000 0x00001000
-			0x00008000 0x00001000 >;
-		volatile;
-	};
-
diff --git a/Documentation/devicetree/bindings/pmem/pmem-region.yaml b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
new file mode 100644
index 000000000000..a4aa4ce3318b
--- /dev/null
+++ b/Documentation/devicetree/bindings/pmem/pmem-region.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/pmem-region.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+maintainers:
+  - Bjorn Helgaas <bhelgaas@google.com>
+  - Oliver O'Halloran <oohall@gmail.com>
+
+title: Persistent Memory Regions
+
+description: |
+  Persistent memory refers to a class of memory devices that are:
+
+    a) Usable as main system memory (i.e. cacheable), and
+    b) Retain their contents across power failure.
+
+  Given b) it is best to think of persistent memory as a kind of memory mapped
+  storage device. To ensure data integrity the operating system needs to manage
+  persistent regions separately to the normal memory pool. To aid with that this
+  binding provides a standardised interface for discovering where persistent
+  memory regions exist inside the physical address space.
+
+properties:
+  compatible:
+    const: pmem-region
+
+  reg:
+    maxItems: 1
+
+  volatile:
+    description: |
+      Indicates the region is volatile (non-persistent) and the OS can skip
+      cache flushes for writes
+    type: boolean
+
+required:
+  - compatible
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    pmem@5000 {
+        compatible = "pmem-region";
+        reg = <0x00005000 0x00001000>;
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 96b827049501..68012219f3f7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -13564,7 +13564,7 @@ M:	Oliver O'Halloran <oohall@gmail.com>
 L:	nvdimm@lists.linux.dev
 S:	Supported
 Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
-F:	Documentation/devicetree/bindings/pmem/pmem-region.txt
+F:	Documentation/devicetree/bindings/pmem/pmem-region.yaml
 F:	drivers/nvdimm/of_pmem.c
 
 LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
-- 
2.34.1


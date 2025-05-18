Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5178A1581F0
	for <nvdimm@lists.linux.dev>; Sun, 18 May 2025 03:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747540566; cv=none; b=ABSu2YWPf2i32MzqGVR3iAswnDZpLo86ijhSbwy8nBj5nGTS72q8BdjKY4bEOsg9WgSxOWYyCJE4vvhXyA+FWaxViQeSkfHaXZup/nUdiDfs3SMcd5xF70Kpnv4f4UPwbdXeAbaXGZGbxoliYadJi3DIv001kIs4gD5deNZmeo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747540566; c=relaxed/simple;
	bh=X2R0lRUo/S7bGxarvGbPnwAztmFTvYyHEDZhH43YC3s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pOe6iU6nWumPl+LBzGWcXsTWm9dH1UNYRNVTR5XHAKhzZi8LGo3ZZ1vlxXYyit06WW6MvZotGaPfdb2gdqwW4NPYnHMAmOj9APFiHBgWTYGzImgMrQpQnTsns5lUBCUFUM4iWE6Mxd8+g4nuH70YU+vIG1w18LXx71K049cecso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com; spf=none smtp.mailfrom=pdp7.com; dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b=dFhYg4Cl; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pdp7.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=pdp7.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pdp7-com.20230601.gappssmtp.com header.i=@pdp7-com.20230601.gappssmtp.com header.b="dFhYg4Cl"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3a0bd7f4cd5so3254767f8f.0
        for <nvdimm@lists.linux.dev>; Sat, 17 May 2025 20:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pdp7-com.20230601.gappssmtp.com; s=20230601; t=1747540562; x=1748145362; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ag1YP0aXAY2InPlmdvx0/NdA/nmWNYGDzlXrc3yzqww=;
        b=dFhYg4CloBvTCnF2iUnqUDnmALqUQltWcgMlcUt3aNJ4Ijg7ebPTsdh6OTUkhBhqRp
         d/ZXtn4VtEGFfvL0MgiSlrsLwk6QMTHcplT2GDcUrPboy0OcohPb2HofIjMrFWJtFfAE
         KeFWYp+9ckxWYKBIBoQWOGb89psvv25wy4HKDpkFzrEeZqgcNBmG6tl1JnVX543/qoLg
         eCd0oTRJRtCzQ23LsooWehRVnPRTCvJe+fAD+Fq37KnybZr5k8H0aaATEc0Jv/yhBmFa
         CnKV47yRecyW2Wwzgp5OFcAlqYDmAQhlsKZVGWjjtgZ4D90JCYPhK6cDAxkWvjIjzLtE
         GDQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747540562; x=1748145362;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ag1YP0aXAY2InPlmdvx0/NdA/nmWNYGDzlXrc3yzqww=;
        b=d8YKbUqep8qMlH+GvbrIptNL0mOOXIk3ji3kEHPq/Y+W/1aoqeO4sOSgqEB0aPISdi
         M7voc860A+0A5hGqn+P4JuVScSm+BNtXNAQfE2Ulv+51FBRMmb87ZTGIWC6X5KKCkgXN
         n0vag6fJdZLC0SraCyYKDLsyKWLuDQs7wd8hw9p2a4UT7AjZiH3t6u3VPSeHWxYOA9jp
         RNIky+aDttcs2inFundpv0cZ4MgPT/sJrnjUbZOLOuMIKzQLt/08hDQ1+O2IRDsNuYKO
         aZ/OUvUuvCGCnJPt/4lxWPNe5MWvxf/+mll4nprwc/HN8tc93iZpEreh8B/n8k1hXXnU
         eN3w==
X-Forwarded-Encrypted: i=1; AJvYcCXQDv5Bbsq2wm8pGTp2UtTIys+mXAH0dY0QMdySctsuE2yruUwiy4UShfLFLkaZe7FLGujMeLk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzMBbWY+b2qq7QoHhN9ozX/70qmhacjPcQysENbjVO0fBh0iI9T
	GNGApK5z94Hr5aRKgdLx4AuTHOllq2yxgdtrHexHP+TunsAtnmUcnPIkeGAiVVPGB1FMwUG5A+1
	wSJpKzzGS+Q==
X-Gm-Gg: ASbGncvLi06zdOIaPfx2lmBivA+QY5V0GhtX670AEm4v7PmO8+bTdJWZOJy4uXaPUsk
	OHskh47RticXDL2exaVIjuzxUodC1PyrmUo14NUfB+MJkQVA1XEiGuHJKHmEkNtkmDd0BUlEqiY
	LA0CRtxcXFR70J3FD0xMrV1OrsJz9A4/A7+b2lcu7cO9BMkCkKUUCYxosOgY9thFwiU8T9lF1Hb
	Zd7qckp82Z3VMisrt69npFFYxGneXtiyuSxNUq1e0yOPGlaKBdZfDeLNz75y1EuaKSC7/FIQF+P
	HcA8JdB27eVs1+21PK0FvdVfiJMcnIMj4Tlb4AxDglsi/ndJk3QjfX0=
X-Google-Smtp-Source: AGHT+IG93wDD2jjXIrPe3sZUfvLXdAyBTc/CB1QOVVGZp0c5rnsjMhnrqRbw/as6MuAHMcVhp6gCcA==
X-Received: by 2002:a05:6000:2012:b0:3a0:b84d:805c with SMTP id ffacd0b85a97d-3a35c84ac4cmr7035704f8f.49.1747540562426;
        Sat, 17 May 2025 20:56:02 -0700 (PDT)
Received: from gen8.tailc1103.ts.net ([193.57.185.11])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a362b4e2e1sm6730947f8f.96.2025.05.17.20.56.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 May 2025 20:56:01 -0700 (PDT)
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
Date: Sat, 17 May 2025 20:55:38 -0700
Message-ID: <20250518035539.7961-1-drew@pdp7.com>
X-Mailer: git-send-email 2.43.0
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
 .../devicetree/bindings/pmem/pmem-region.yaml | 49 +++++++++++++++++++
 MAINTAINERS                                   |  2 +-
 2 files changed, 50 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.yaml

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
2.43.0


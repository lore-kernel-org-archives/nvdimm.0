Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9411F34545
	for <nvdimm@lists.linux.dev>; Wed,  2 Apr 2025 01:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743559168; cv=none; b=bxOplxzyYI1kzn77GoLnlZ3qjnET/zxNy7hC3cUSCTwB0YXkfAZQWBZIHuO1r74QFejhGErBsSyq1MyXUIPqh5HvjuUNypZkdLae8UNjJk8D/8Y1aT9n1ca9Cjx0+o+6WqsToWE1+Q3C8gmQnfi4GeLvxQQ0CSvGnmw/I5inKmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743559168; c=relaxed/simple;
	bh=uqNvFcKzNHiDSgwHvLQNxIbpQWuJPRZ0MBBCC5wOz+I=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dBUZjz1lPIo6jZexj59vmxO8kxAVwtKu65b5sp6PDWq78NmrPo7d42QyzTiUvu+VXgtXxldhHXT49jD4Ta+HOHRoBrajxELBVcFTamgv/X4YN8oh7kfqhMo0FENxUX7Y/yYO8zD3wuVPjrprweOh3gpb/T6T75mSkE6ggUIsZgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=k8WJY2R0; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="k8WJY2R0"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6ecfa716ec1so58839946d6.2
        for <nvdimm@lists.linux.dev>; Tue, 01 Apr 2025 18:59:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1743559165; x=1744163965; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=6MiemE6Vl/b5ROnmlBxt9gMb8X21cw8ERPPfIrwPI4A=;
        b=k8WJY2R0zZFpfse3xnY73SpncbUW8FDsHm+omgpfvTROAWYFcvMMcemmi4d7gKvTCo
         cVoRMzus4vykCuyaK3bIWl6vH3PL0RYWioBzAcEEtqZB5UywdrkSk6TEl3KiJp6if/yi
         8z5UrrWEa82wxb0q/ye5Jp0hrZt6ICuAnjE3ioOOAU3rjKqqlrT74+913GFjZRkFxy0+
         XpA8jCpLAUhYocWXJAkbfNOK0Xv4J1PiW7QeiRlV7wlGoZ/b7cL1wrxeOWFEVCpzk5J2
         uypse0FW7cwVEsMU/vAY9MPXo8e6K8Gah+NBe58hOufTqDZd1mUvLTrbxPFihYv5cULN
         ECkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743559165; x=1744163965;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6MiemE6Vl/b5ROnmlBxt9gMb8X21cw8ERPPfIrwPI4A=;
        b=kzuyp33dYlf16VfkTAChtmmEqjvrodnhoP3EuiD1s9UGm4ctFn4++RZQOVHFwmcuUo
         9SM3uZkN/uM2aKDckVeE90Inb5/J0VxKOp2FKCO9iqqICc4Mg55Rh9WXIL7tTBl/bBQL
         2U9qtAXWBiMHD9ypymHq8dcNZt9tpa2h75O+LsFOnQF50URzAbdFYgXgH0C3cV4RK6n5
         k32nKKTxNJeH4vh5kGsV4kdTL8qL9yQ+YZGrcJBf2d6+2yug6QROCD2t8oXk1JYX244Y
         kb+FeRo2lZCUtzJWR5Qv3Y9CbHLL4cFw7G8LQ6gpWgN8Txp80C23BKxfrqjEOVeRdNFM
         ntvA==
X-Gm-Message-State: AOJu0YzKiIPOtTsReX48LPqziO9MkURG2Qs6Au1YxjsbeNMyA4NdMcHe
	/aLqfaJnn0feqOf83/+Fnpktf8aBeaoArVvd+r4gZY+E+IbO0eQ36j5NvhQpCpU=
X-Gm-Gg: ASbGncsSobQ483JMm4kk1NA/VXC1XSfKy+hcvEfQRtcKSMINMxgMulxMm9uBoW/mxMT
	FllXt2xs2FTEWCRHkg3+9uuAhg77vUttr11HdpFkR9Bcjt1z1LmiNqpTk+q8I9SI7TiNIGALvlq
	rjlrSsOyFgcLdOe77ddUW0h7I3BX9tbMenBkukelUnhdGCtC3nC0wQyGFzNJl+UuyeJxK9AnR+5
	3EtcwUzUmD9+kqvfHYDSEZcx0safiau1FACUiIsib762tFJ9K0yZqoAWsH+7CaN9w7bIzVe3Ub7
	JMGhn59tKcDRSogajbuUd7FJnPU091xgYW6/DWa7TxC+RqhGoPphni3izET5Srr6P8h8qC2IGC5
	ge17lU2GBF3dEVfDR+CQaPr2ooQpJIxQk
X-Google-Smtp-Source: AGHT+IFTkMEgtYgeg/jyMTLw1npojfnLCbBA7oaWxjcijhqPO6qE2+4JiydGMjNyuwX0+WPP+1ah6w==
X-Received: by 2002:ad4:5c48:0:b0:6e8:9525:2ac3 with SMTP id 6a1803df08f44-6eed627930bmr247678456d6.34.1743559165433;
        Tue, 01 Apr 2025 18:59:25 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-56-208.washdc.fios.verizon.net. [173.79.56.208])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6eec9646269sm68791386d6.41.2025.04.01.18.59.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Apr 2025 18:59:25 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	David Hildenbrand <david@redhat.com>
Subject: [PATCH v2] DAX: warn when kmem regions are truncated for memory block alignment.
Date: Tue,  1 Apr 2025 21:59:20 -0400
Message-ID: <20250402015920.819077-1-gourry@gourry.net>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Device capacity intended for use as system ram should be aligned to the
archite-defined memory block size or that capacity will be silently
truncated and capacity stranded.

As hotplug dax memory becomes more prevelant, the memory block size
alignment becomes more important for platform and device vendors to
pay attention to - so this truncation should not be silent.

This issue is particularly relevant for CXL Dynamic Capacity devices,
whose capacity may arrive in spec-aligned but block-misaligned chunks.

Suggested-by: David Hildenbrand <david@redhat.com>
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index e97d47f42ee2..32fe3215e11e 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -13,6 +13,7 @@
 #include <linux/mman.h>
 #include <linux/memory-tiers.h>
 #include <linux/memory_hotplug.h>
+#include <linux/string_helpers.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -68,7 +69,7 @@ static void kmem_put_memory_types(void)
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
-	unsigned long total_len = 0;
+	unsigned long total_len = 0, orig_len = 0;
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
 	int i, rc, mapped = 0;
@@ -97,6 +98,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
+		orig_len += range_len(&dev_dax->ranges[i].range);
 		rc = dax_kmem_range(dev_dax, i, &range);
 		if (rc) {
 			dev_info(dev, "mapping%d: %#llx-%#llx too small after alignment\n",
@@ -109,6 +111,12 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (!total_len) {
 		dev_warn(dev, "rejecting DAX region without any memory after alignment\n");
 		return -EINVAL;
+	} else if (total_len != orig_len) {
+		char buf[16];
+
+		string_get_size((orig_len - total_len), 1, STRING_UNITS_2,
+				buf, sizeof(buf));
+		dev_warn(dev, "DAX region truncated by %s due to alignment\n", buf);
 	}
 
 	init_node_memory_type(numa_node, mtype);
-- 
2.47.1


Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6A114A83
	for <nvdimm@lists.linux.dev>; Fri, 14 Jul 2023 17:48:34 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-78362f574c9so85158139f.3
        for <nvdimm@lists.linux.dev>; Fri, 14 Jul 2023 10:48:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689356914; x=1691948914;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OCdm/lGSXcdU0qxB1c5esfZmTh7WAzDMe8njjEfNYZc=;
        b=YiGxpEgyCJRKhQ8hcb9o4b5y2WDf2ywqEQ6QWDxxV9hI7QMLlgIeKYQ4Z9ooOhsFFZ
         v3zH8/uAagqBWd6NTxie0CWIZYaw3i1ZADC8Bl6jhGRYWdDNZoInZDGdh5nb4mskWBKN
         z5uBTH3BSWwRQPBkZAPIM7Ycy6hMm8Xg6YvI6VQ02WxGffYZwtvk6coM/tvqfjRTLRvk
         TrR2cmPuxtkuN5PB+FwzL0w9UjW/s30EH0dKCU55GHcw/5FAEIokPzVlqWS4/gPURiKx
         i5HZmYIuEmP/AxatMtjXCJ80nOsnqZJJ1Vg28uLxiy6cS3autxsQ95yAsfuOQno2m1rO
         sMdw==
X-Gm-Message-State: ABy/qLbJHiH0HgwhJM89ZPRhIQwfGVSKvk+78E5dND79/4QqNgpQGT+c
	T42ifCQ78siLHanrUyz0jw==
X-Google-Smtp-Source: APBJJlFiKPEzsdA66+J+nkgsHoevEAp0S1+ccXmnkcPLRisdk5hiACZtuahO2gtQNu2JO5ENJ5PaaQ==
X-Received: by 2002:a6b:c40a:0:b0:783:344d:6b46 with SMTP id y10-20020a6bc40a000000b00783344d6b46mr5083783ioa.21.1689356914002;
        Fri, 14 Jul 2023 10:48:34 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id u6-20020a02cb86000000b0042b298507b3sm2736649jap.42.2023.07.14.10.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 10:48:33 -0700 (PDT)
Received: (nullmailer pid 4061344 invoked by uid 1000);
	Fri, 14 Jul 2023 17:48:19 -0000
From: Rob Herring <robh@kernel.org>
To: Oliver O'Halloran <oohall@gmail.com>, Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Cc: devicetree@vger.kernel.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: [PATCH] nvdimm: Explicitly include correct DT includes
Date: Fri, 14 Jul 2023 11:48:13 -0600
Message-Id: <20230714174813.4061206-1-robh@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The DT of_device.h and of_platform.h date back to the separate
of_platform_bus_type before it as merged into the regular platform bus.
As part of that merge prepping Arm DT support 13 years ago, they
"temporarily" include each other. They also include platform_device.h
and of.h. As a result, there's a pretty much random mix of those include
files used throughout the tree. In order to detangle these headers and
replace the implicit includes with struct declarations, users need to
explicitly include the correct includes.

Signed-off-by: Rob Herring <robh@kernel.org>
---
 drivers/nvdimm/of_pmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/of_pmem.c b/drivers/nvdimm/of_pmem.c
index 10dbdcdfb9ce..1b9f5b8a6167 100644
--- a/drivers/nvdimm/of_pmem.c
+++ b/drivers/nvdimm/of_pmem.c
@@ -2,11 +2,11 @@
 
 #define pr_fmt(fmt) "of_pmem: " fmt
 
-#include <linux/of_platform.h>
-#include <linux/of_address.h>
+#include <linux/of.h>
 #include <linux/libnvdimm.h>
 #include <linux/module.h>
 #include <linux/ioport.h>
+#include <linux/platform_device.h>
 #include <linux/slab.h>
 
 struct of_pmem_private {
-- 
2.40.1


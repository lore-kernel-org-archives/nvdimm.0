Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05EE02C80
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 17:00:41 +0000 (UTC)
Received: by mail-pf1-f174.google.com with SMTP id a8so260022pfa.6
        for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 09:00:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ajou.ac.kr; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Onl1JpmjZEa6zJu2g35kLpJMmMBIoxN/vI9o07uZnSE=;
        b=vG81hp3GKcDmDaHOEl5NZqjWXqgKUrX8vpZ4U+RfzlWC0F5JUgHlxzbXhrzgfjS//A
         HUeiYP+XaNjRlzyClU0pNEVdAgc/UC/0hICDjqLbIw8LfYGJ4jUW+PffSJFnRHLctw6A
         0V627+CXnH7SJVSr2BOcS8aAGbFY3INNRdSF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Onl1JpmjZEa6zJu2g35kLpJMmMBIoxN/vI9o07uZnSE=;
        b=iM3Lz2j+GXR6HQ5/zyyJiKBHe8jZeQAX1Zv5LTSzwrgSHFTToEJsIN3xV3TzSsQhYk
         tNw3v+N23njVReZp7dW7ggQeteKrsaWf8UaB1twZ/cbPzgpoRV8MMtDAFc9BE4eZGswY
         Q+U/2mcUMM2ait3JbG/qDJ/zmypi7uvRbMB74IMPr+7NyXAB9engMo7Z1EReM5rZCDiY
         byPwBUzmifl8hBFNNZYQNmwr+DWXicEnPBOJFzqpmyi6ky21NH1BEl2boPteuty1uVob
         wPSBK/AwT3eF6LDOFTNJlnEzXaEUPMDxUB/fp02TH0ZpdhAogqBiWO25UoOnsy6LCmBf
         xxYw==
X-Gm-Message-State: AOAM531O1gXjfxFiq+mHuuM+n8y3ibGvR5+okwfA1PeRqbDGeE0/OXXR
	TVFm9hBZ1HW6B1pgg0zlvET2sw==
X-Google-Smtp-Source: ABdhPJzhTWxkvUgBtwM91u+cYKbIdx3dFiNFTCB+D62IGdpTAENUFNPgH4+d0xS7tt+MSUEXK5AAeQ==
X-Received: by 2002:aa7:9009:0:b0:4c6:fe2f:6a94 with SMTP id m9-20020aa79009000000b004c6fe2f6a94mr11307661pfo.25.1643216441424;
        Wed, 26 Jan 2022 09:00:41 -0800 (PST)
Received: from localhost.localdomain ([210.107.197.32])
        by smtp.googlemail.com with ESMTPSA id q6sm17540644pgb.85.2022.01.26.09.00.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 09:00:41 -0800 (PST)
From: Jonghyeon Kim <tome01@ajou.ac.kr>
To: dan.j.williams@intel.com
Cc: vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Jonghyeon Kim <tome01@ajou.ac.kr>
Subject: [PATCH 2/2] dax/kmem: Update spanned page stat of origin device node
Date: Thu, 27 Jan 2022 02:00:02 +0900
Message-Id: <20220126170002.19754-2-tome01@ajou.ac.kr>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220126170002.19754-1-tome01@ajou.ac.kr>
References: <20220126170002.19754-1-tome01@ajou.ac.kr>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

When device memory adds to the online NUMA node, the number of spanned
pages of the original device NUMA node should be updated.

By this patch, we can monitor the current spanned pages of each node
more accurately.

Signed-off-by: Jonghyeon Kim <tome01@ajou.ac.kr>
---
 drivers/dax/kmem.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index a37622060fff..f63a739ac790 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -11,6 +11,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
+#include <linux/memory_hotplug.h>
 #include "dax-private.h"
 #include "bus.h"
 
@@ -48,6 +49,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	struct dax_kmem_data *data;
 	int i, rc, mapped = 0;
 	int numa_node;
+	int dev_node;
 
 	/*
 	 * Ensure good NUMA information for the persistent memory.
@@ -147,6 +149,18 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 
 	dev_set_drvdata(dev, data);
 
+	/* Update spanned_pages of the device numa node */
+	dev_node = dev_to_node(dev);
+	if (dev_node != numa_node && dev_node < numa_node) {
+		struct pglist_data *pgdat = NODE_DATA(dev_node);
+		struct zone *zone = &pgdat->node_zones[ZONE_DEVICE];
+		unsigned long start_pfn = zone->zone_start_pfn;
+		unsigned long nr_pages = NODE_DATA(numa_node)->node_spanned_pages;
+
+		shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
+		update_pgdat_span(pgdat);
+	}
+
 	return 0;
 
 err_request_mem:
-- 
2.17.1


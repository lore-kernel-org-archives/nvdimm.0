Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFB652904
	for <nvdimm@lists.linux.dev>; Thu, 19 May 2022 17:25:34 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id l7-20020a17090aaa8700b001dd1a5b9965so5842733pjq.2
        for <nvdimm@lists.linux.dev>; Thu, 19 May 2022 10:25:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2QRd1Hj7z8PQ6OGAWnpJxYHyy9vDcMOmiRfmbwhyjgQ=;
        b=hRwvBgiXo+VzZn4+ZMIuphIGy3cRF1TZwhoAN7s4erqo0CFUk1qb6ydVp88d+2ipZi
         yJUJi0Vh+xqciOv/aQqybtbFA0SnHgW11kIpK7xCdSLq/JtOf56mzXpce/OevP5i8ryj
         RpxcKm3CLN2X/5r7tX2qLHOrtwgaScLaFuzYtEEMVLbqgiN74TV36cmO3hF12CqtCQ9C
         DaNjTFnJRzNK8zou/DzS9HANilhYaiwS4DrM4QaSv9VKBFLV3uzkMAxedajyr7YJS54O
         mz5s5WeLD5t36bFXc3CHmj6/16zZj8DfbVv8OsRa3DOkYQT1g2sPgZL2y5nd/1mksJZS
         GRUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2QRd1Hj7z8PQ6OGAWnpJxYHyy9vDcMOmiRfmbwhyjgQ=;
        b=VnQ4JVO9T9mnHAMpeNrwktdV/U5alY6rGyMavyQmyTVRUtCX6LwhJvTmIbUD//tDT0
         Pi2D2WaAnm3pfvrLokZCMEv/knz0CbqBVrhPmEiPoskWadeBffDf2QkMFHXMbfs5AXqe
         CmlTivrf4RMiGUBLlfc62IelxdHYRcRdrhx5EXwg6VxwNov2Qte1J+s8bxyrvElla7jq
         dCkqSLvfMDrF6NAifU03s8vtHfo0pCZ09jxKEhKhNmXkqXQqx3TV655uDte3GO5CSTz2
         NoJvIYw6HM+5Wg2Dq35dFnANylxkaXH6DdbAUJ09g/XQGe0Z1Q99V/79OZ72jaj5DfR8
         q0QA==
X-Gm-Message-State: AOAM533hjIx4FX5uLuzrnsT+DPy4t3kl7/rkvocTRIigGVA/GMY7pwPu
	zeRRV/InGbb1bXYCbGM4Gg==
X-Google-Smtp-Source: ABdhPJwilFeifO0CVAPkBmNZUYBAAIobtr791UrG2yrXWCxaxjHkGeXGvgtvvCY54ifcmkoBoEresA==
X-Received: by 2002:a17:90b:3e8b:b0:1dc:e471:1a69 with SMTP id rj11-20020a17090b3e8b00b001dce4711a69mr6878682pjb.60.1652981134105;
        Thu, 19 May 2022 10:25:34 -0700 (PDT)
Received: from zaphod.evilpiepirate.org (068-119-229-002.res.spectrum.com. [68.119.229.2])
        by smtp.gmail.com with ESMTPSA id y4-20020a655a04000000b003c6ab6ba06csm3859126pgs.79.2022.05.19.10.25.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 10:25:33 -0700 (PDT)
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@vger.kernel.org,
	pmladek@suse.com,
	rostedt@goodmis.org,
	senozhatsky@chromium.org
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
	andriy.shevchenko@linux.intel.com,
	willy@infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v2 25/28] tools/testing/nvdimm: Convert to printbuf
Date: Thu, 19 May 2022 13:24:18 -0400
Message-Id: <20220519172421.162394-26-kent.overstreet@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220519172421.162394-1-kent.overstreet@gmail.com>
References: <20220519172421.162394-1-kent.overstreet@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This converts from seq_buf to printbuf. Here we're using printbuf with
an external buffer, meaning it's a direct conversion.

Signed-off-by: Kent Overstreet <kent.overstreet@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: nvdimm@lists.linux.dev
---
 tools/testing/nvdimm/test/ndtest.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 3ca7c32e93..e9b642f7f8 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -12,7 +12,7 @@
 #include <linux/ndctl.h>
 #include <nd-core.h>
 #include <linux/printk.h>
-#include <linux/seq_buf.h>
+#include <linux/printbuf.h>
 
 #include "../watermark.h"
 #include "nfit_test.h"
@@ -797,32 +797,30 @@ static ssize_t flags_show(struct device *dev,
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 	struct ndtest_dimm *dimm = nvdimm_provider_data(nvdimm);
-	struct seq_buf s;
+	struct printbuf s = PRINTBUF_EXTERN(buf, PAGE_SIZE);
 	u64 flags;
 
 	flags = dimm->flags;
 
-	seq_buf_init(&s, buf, PAGE_SIZE);
 	if (flags & PAPR_PMEM_UNARMED_MASK)
-		seq_buf_printf(&s, "not_armed ");
+		pr_buf(&s, "not_armed ");
 
 	if (flags & PAPR_PMEM_BAD_SHUTDOWN_MASK)
-		seq_buf_printf(&s, "flush_fail ");
+		pr_buf(&s, "flush_fail ");
 
 	if (flags & PAPR_PMEM_BAD_RESTORE_MASK)
-		seq_buf_printf(&s, "restore_fail ");
+		pr_buf(&s, "restore_fail ");
 
 	if (flags & PAPR_PMEM_SAVE_MASK)
-		seq_buf_printf(&s, "save_fail ");
+		pr_buf(&s, "save_fail ");
 
 	if (flags & PAPR_PMEM_SMART_EVENT_MASK)
-		seq_buf_printf(&s, "smart_notify ");
+		pr_buf(&s, "smart_notify ");
 
+	if (printbuf_written(&s))
+		pr_buf(&s, "\n");
 
-	if (seq_buf_used(&s))
-		seq_buf_printf(&s, "\n");
-
-	return seq_buf_used(&s);
+	return printbuf_written(&s);
 }
 static DEVICE_ATTR_RO(flags);
 
-- 
2.36.0


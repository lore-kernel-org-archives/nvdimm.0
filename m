Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AA38185F
	for <nvdimm@lists.linux.dev>; Mon,  8 Aug 2022 02:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=JSiABMMZnULesSHXbODZXbNdNrS+sWlJ8WR8yu48vGY=; b=R+fJeXfM+C7UzxYJOIbPtnhJZN
	ZFVd2X7tbiIrV3eQ+rjj9m0N85640VYmeYs0YCyQT8oTrXtm5P7wkAQ+W8xxRQUAfmbU9FccnA1lE
	+pf9VZUG0TAk9uZysyl2+JyAI/2JX50RSZDsMeFoJspbcYgJytqXk7D27TyyA3B+29V6S/QCmHUQX
	/5lVcoZ2gVykipqHm3UWr7u/5l7YqVcU1HNZC8zlsYKcb4c4xhh+mVj2zqzE3FkN2Bj4qSWbMNXf6
	cTLiGoAeF6E3+KTxB1NLTNpmw48EMBhf+q5XVGeuYbRGaJBXGEfqiMPch1+k89PhMvVMrv8AqZW8K
	KsTEv3Tw==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1oKshy-00DVSZ-Iz; Mon, 08 Aug 2022 02:41:34 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-kernel@vger.kernel.org,
	pmladek@suse.com,
	Kent Overstreet <kent.overstreet@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v5 24/32] tools/testing/nvdimm: Convert to printbuf
Date: Mon,  8 Aug 2022 03:41:20 +0100
Message-Id: <20220808024128.3219082-25-willy@infradead.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220808024128.3219082-1-willy@infradead.org>
References: <20220808024128.3219082-1-willy@infradead.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kent Overstreet <kent.overstreet@gmail.com>

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
index 4d1a947367f9..a2097955dace 100644
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
@@ -740,32 +740,30 @@ static ssize_t flags_show(struct device *dev,
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
+		prt_printf(&s, "not_armed ");
 
 	if (flags & PAPR_PMEM_BAD_SHUTDOWN_MASK)
-		seq_buf_printf(&s, "flush_fail ");
+		prt_printf(&s, "flush_fail ");
 
 	if (flags & PAPR_PMEM_BAD_RESTORE_MASK)
-		seq_buf_printf(&s, "restore_fail ");
+		prt_printf(&s, "restore_fail ");
 
 	if (flags & PAPR_PMEM_SAVE_MASK)
-		seq_buf_printf(&s, "save_fail ");
+		prt_printf(&s, "save_fail ");
 
 	if (flags & PAPR_PMEM_SMART_EVENT_MASK)
-		seq_buf_printf(&s, "smart_notify ");
+		prt_printf(&s, "smart_notify ");
 
+	if (printbuf_written(&s))
+		prt_printf(&s, "\n");
 
-	if (seq_buf_used(&s))
-		seq_buf_printf(&s, "\n");
-
-	return seq_buf_used(&s);
+	return printbuf_written(&s);
 }
 static DEVICE_ATTR_RO(flags);
 
-- 
2.35.1


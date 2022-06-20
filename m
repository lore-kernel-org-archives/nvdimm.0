Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679E7B
	for <nvdimm@lists.linux.dev>; Mon, 20 Jun 2022 00:43:35 +0000 (UTC)
Received: by mail-qk1-f170.google.com with SMTP id c83so6888859qke.3
        for <nvdimm@lists.linux.dev>; Sun, 19 Jun 2022 17:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c+8VrBQ9WReeZhxiPy4cLYIhVweEbjxzP+O3PD/upkI=;
        b=hG1zSXlqMLSt6C53e/b9Mbo0SIVK2m3R3jUS+uuyLNSYU7h0hemVP+PRCJbhYgLMX7
         FyNfHr+aW+bfF+gBFHQVtjYmTqBlPCmff2HDumH0thLuIMmi+5xTZif5rFBJ+/Im7rAY
         1iX2kT7GRCrIcIEadxyY1d1XK2xwI+VfWhMkRQQXdVqaQ1Fe0sWfvN1U4Bkz0s0EOCFP
         8abRX4B1TCxLaNePhLqRU6tlIUx0JP4G+9qFcUhjmBSi/tOCHoHYoFp9xNjydTdju9/h
         wJokcyg3abuBPNvUSNp4Rqz/gHfQqlC/+laxZ12aplYKKmjtUIHJTaMhGSQZkwxGp0ta
         ffZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c+8VrBQ9WReeZhxiPy4cLYIhVweEbjxzP+O3PD/upkI=;
        b=5CI48/xHRyVY6ZH/3/nL+2UyQlL2+rMLh55t8UWu1nfnW8C7fcdrlKkc0IF2ohfhHD
         IImOguSOzW6MY2kwzkEzgIQ6hUH7b52jxIz8uVacfP7+4dLMso1KTK7dRYCF69d1zSO9
         hZiRAWM0Ztf6q4hd3H+9DOUt2FjPnO6J0/ZyUZ/lC6dlfzuqjj9MLVtwb6Tgv80y8rNw
         egUY86isw9lOYUdnnkYXJZViUmMvwEZHih/lYExniORiAtrQKrl/3+kHirFZhwXkNdPT
         qxa3Kj5CAVdEGVJxA1C15voqyISfHUu5K7UiPnb2NHue++VsFQ8lLfd87MOo5ukoKYpC
         PuvA==
X-Gm-Message-State: AJIora91q/4WeXzxHqqwzn1IPitJRFZeS8Q7ovxHVwbj08riMu9/ed7Y
	ff6Bx+290zbHFdnnKyWgSQ==
X-Google-Smtp-Source: AGRyM1sebw4W5sjFrt3VW++8K/4IO2JYqZAC0xgWvLT2GDMfU7O1Du2uxp+uMD8HWJJW0TKREzVJcA==
X-Received: by 2002:a05:620a:f05:b0:6a9:7122:edb1 with SMTP id v5-20020a05620a0f0500b006a97122edb1mr14790338qkl.82.1655685814618;
        Sun, 19 Jun 2022 17:43:34 -0700 (PDT)
Received: from localhost (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id y17-20020a37f611000000b006a69f6793c5sm9944488qkj.14.2022.06.19.17.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:43:33 -0700 (PDT)
From: Kent Overstreet <kent.overstreet@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	pmladek@suse.com
Cc: Kent Overstreet <kent.overstreet@gmail.com>,
	rostedt@goodmis.org,
	enozhatsky@chromium.org,
	linux@rasmusvillemoes.dk,
	willy@infradead.org,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	nvdimm@lists.linux.dev
Subject: [PATCH v4 26/34] tools/testing/nvdimm: Convert to printbuf
Date: Sun, 19 Jun 2022 20:42:25 -0400
Message-Id: <20220620004233.3805-27-kent.overstreet@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620004233.3805-1-kent.overstreet@gmail.com>
References: <20220620004233.3805-1-kent.overstreet@gmail.com>
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
index 4d1a947367..a2097955da 100644
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
2.36.1


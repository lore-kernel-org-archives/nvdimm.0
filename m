Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B3F72
	for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 08:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=g194Vr0DbJJzl/cEBAOEB80E7ddEOgEwRtc3SehTkCM=; b=lyCSOPfKbPWW13G/HmmUiQm4IC
	QLe792xQKuM9NbcuvC5GyG0KUfbDE99SMG+iGV4qgI+gHx45B+kQ3VqE+I59zu2Qyu58AGIn6vY9e
	tuq6NT5v0x1HsztO7WudPF6/OY56AnbBqRwflD+p7JPohYY6+lU6FjV7hhUwt4snsfin0upZNbdZl
	ZHA0DGVwH0LHihfwbpa2LUgyRE8TaO8KkkQ/wC3IkzWVuFeC63xXmjXowE3hYO5yV05kgyyGpQxJF
	KN2Tg73MZY1+CWzpKlwFfgJQIdvNLuPBBP15FfKql0w378ARYnLPXX/5jIzgFUwpS19vgzGmBwmps
	T7gyZUvA==;
Received: from [2001:4bb8:184:72db:fcf4:862e:2c86:9efc] (helo=localhost)
	by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1mSb3I-003dHK-63; Tue, 21 Sep 2021 08:23:08 +0000
From: Christoph Hellwig <hch@lst.de>
To: akpm@linux-foundation.org,
	naoya.horiguchi@nec.com
Cc: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Subject: [PATCH] mm: don't include <linux/dax.h> in <linux/mempolicy.h>
Date: Tue, 21 Sep 2021 10:22:53 +0200
Message-Id: <20210921082253.1859794-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html

Not required at all, and having this causes a huge kernel rebuild
as soon as something in dax.h changes.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/mempolicy.h | 1 -
 mm/memory-failure.c       | 1 +
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mempolicy.h b/include/linux/mempolicy.h
index 0aaf91b496e2fe..b4992a7e1abbd7 100644
--- a/include/linux/mempolicy.h
+++ b/include/linux/mempolicy.h
@@ -8,7 +8,6 @@
 
 #include <linux/sched.h>
 #include <linux/mmzone.h>
-#include <linux/dax.h>
 #include <linux/slab.h>
 #include <linux/rbtree.h>
 #include <linux/spinlock.h>
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 470400cc751363..adcd6d7b7233c9 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -39,6 +39,7 @@
 #include <linux/kernel-page-flags.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/task.h>
+#include <linux/dax.h>
 #include <linux/ksm.h>
 #include <linux/rmap.h>
 #include <linux/export.h>
-- 
2.30.2


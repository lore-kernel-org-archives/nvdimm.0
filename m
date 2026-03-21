Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9259A391E63
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774105455; cv=none; b=A9qui/706QYIHdwVEyYIIbvXG+ZW7UjVmIBei47tZEzH+F28dehFhy/ADwFG+jHbOb75w4zoRh1CwBTQhoqooZaYZ5+KsyQglTWLDI2xutPbOFku2rUaKKgvt98aMTtdO3u5L3YikSTi8Yv19bfGq7DZlSIQzPwQp7i00SUSkzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774105455; c=relaxed/simple;
	bh=4aQ6c6cuuLgbidEXo4JUWgHdhHA0vPcOx/O2oIS0jG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqDuJGkikwKTEBk/ojgFy+yY/EEA2fKwKn2CBFsTBIV7H685k12Nk7a7xY080ghVSdUK3Od8KH8DWKAJq+wrQtLLt5n5Mwn0mKsCXXc927muBI95XOpkqIEdXzH7yRlXZE50qXC8/xjUMjqp6WL016U3ouOGY6ReNHrZhfb4AYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=kcGDmTye; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="kcGDmTye"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8cfbbdbaf3cso280474885a.0
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 08:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105452; x=1774710252; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EZlQlpoI2kyeTHm+ataFfQwGqNyciJ5dRDvCF4GFSVw=;
        b=kcGDmTyeDyauvw2atrpFSdy9YlFiMvPyOjeISUg05sRPHSGkDiO/WB55AMfSOsG6TS
         BqDDP1k1WLKXSm8Rl+ifiyz2SKMZ+Yg3xsHh93XoFGcylatGfmPHdkRUtEGFOjPooa/Q
         88xt9NgPoYdyu3R5HodSFd/6KdHmaM1XRqU9B7yda2tUJf3O+1nJK9JDv8DGSKPoShgB
         CgI3HZOmfpcNmq8MUzWCpkXGMArEIwSwQraDD07gqFLKl+8Kcd7btDijj9/RxhK4zoCt
         oT24aoTVHIVdjqRHEQEZhO9zF3em6xvBO2+2Je/4aPKI5JUocHo/uK8Ictpls1DMZIlk
         CjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105452; x=1774710252;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EZlQlpoI2kyeTHm+ataFfQwGqNyciJ5dRDvCF4GFSVw=;
        b=fnoIlT8/N5w2Si/Bwlhn+AYvH8lIABEKfUAQqBg79x1w7oUxAu0Vba4Bpar8pypwLG
         h4QIoVP78Qe7gB6qOUhQ1JQ5F92XbAcbj+w+J811kuIUa5bJOJPOLHkJhMm3LhaQJd7Q
         XpJ84zv3TuaAE10+TYGHunuZNLazIoxgsZJ8dr2qfDcI/XSOGi5kALjwAjsdq1kMBQ+Y
         Mglwuno0AqAt05SEZ6FRlKYg3y/eMA3tL94xXHLtsIybtpC3XqPRWTiWHv84Uh/bFlcV
         cMbQDYasG6gEqZiDcAQTjseJWFG0uEE2HpjABbLai4j4yklCzcNyjEeJqGV2KfJFC6IH
         F/lQ==
X-Forwarded-Encrypted: i=1; AJvYcCXT46YVIVls+YKn8DA0CNDG6vw46q/nWp9klMeVBXKoyVbQg+xBzSjb+Ycm/2erXnRMFuJNvt8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxYUQ1hL3A6/7SxzfTx7hBvGXejt9+QrHS/wIEw6HXDH8G/gvnh
	j7HhBDFXWEyYZHS+l2bxepZ3DceuDNJVIACppcjKdm33uukwAKF55FT/XCV4z3x3d7M=
X-Gm-Gg: ATEYQzxXNOW/rFVaTb4GMNovDDqUr9V/GzI3ZdBo4hoKbG1hLIDs+GOn6o/LS2hv9eb
	mlAQZmzXD3OnrEMXnEQ+xkGHRkZ748r0jNIZVzxDqpDlm1PdWebfRPCcIaaTTuYCL9HotpidjAB
	ZVByvUCVJ4KK0YIodytFgeCtDMynmwt+ddM03ptGslxJ+8bn5ud4+puE7s6XvN2NBXo5UKJgwfI
	FzzlGW4ZzfFTE2Rq6PKlnI9agmPks9fCym/P9Vd8JPfF1WzAiX3XljnvjvADYEzuSccQIOsFWdO
	yjInTs9jjkhVneztaej3K/6E849t6c7r8DC2zY27IUv1YU6zTBG6sIqGmaFgpYNMnAp1v7CuKE3
	BhhYfzrsW5OMRL6F5KuN6+uGjGQC1om45fMOa+bAu8a//CWeGjbcB9ijgXnMSGjbzeCPOK7ccxK
	wwtv1pM/5qqzEyMMeMg6hsXORz/34mnqOdM78AioLOBEoYvbhYgWauddYCiJHav4czhwYt/Clxo
	EirTqWXqLGqUJ0sof/lQ/S0Hw==
X-Received: by 2002:a05:620a:454b:b0:8cd:8ce4:c0ad with SMTP id af79cd13be357-8cfb9e4b1b4mr1481729385a.22.1774105452426;
        Sat, 21 Mar 2026 08:04:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:11 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 2/8] mm/memory: add memory_block_align_range() helper
Date: Sat, 21 Mar 2026 11:03:58 -0400
Message-ID: <20260321150404.3288786-3-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Memory hotplug operations require ranges aligned to memory block
boundaries.  This is a generic operation for hotplug.

Add memory_block_align_range() as a common helper in <linux/memory.h>
that aligns the start address up and end address down to memory block
boundaries.

Update dax/kmem to use this helper.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c     |  4 +---
 include/linux/memory.h | 22 ++++++++++++++++++++++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index eb693a581961..798f389df992 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -26,9 +26,7 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	struct dev_dax_range *dax_range = &dev_dax->ranges[i];
 	struct range *range = &dax_range->range;
 
-	/* memory-block align the hotplug range */
-	r->start = ALIGN(range->start, memory_block_size_bytes());
-	r->end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+	*r = memory_block_align_range(range);
 	if (r->start >= r->end) {
 		r->start = range->start;
 		r->end = range->end;
diff --git a/include/linux/memory.h b/include/linux/memory.h
index 5bb5599c6b2b..17cdf6ba3823 100644
--- a/include/linux/memory.h
+++ b/include/linux/memory.h
@@ -20,6 +20,7 @@
 #include <linux/compiler.h>
 #include <linux/mutex.h>
 #include <linux/memory_hotplug.h>
+#include <linux/range.h>
 
 #define MIN_MEMORY_BLOCK_SIZE     (1UL << SECTION_SIZE_BITS)
 
@@ -100,6 +101,27 @@ int arch_get_memory_phys_device(unsigned long start_pfn);
 unsigned long memory_block_size_bytes(void);
 int set_memory_block_size_order(unsigned int order);
 
+/**
+ * memory_block_align_range - align a physical address range to memory blocks
+ * @range: the input range to align
+ *
+ * Aligns the start address up and the end address down to memory block
+ * boundaries. This is required for memory hotplug operations which must
+ * operate on memory-block aligned ranges.
+ *
+ * Returns the aligned range. Callers should check that the returned
+ * range is valid (aligned.start < aligned.end) before using it.
+ */
+static inline struct range memory_block_align_range(const struct range *range)
+{
+	struct range aligned;
+
+	aligned.start = ALIGN(range->start, memory_block_size_bytes());
+	aligned.end = ALIGN_DOWN(range->end + 1, memory_block_size_bytes()) - 1;
+
+	return aligned;
+}
+
 struct memory_notify {
 	unsigned long start_pfn;
 	unsigned long nr_pages;
-- 
2.53.0


Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F373A386441
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 05:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788413766; cv=none; b=Qd8qy46APjs7NPoHr3kqThQTyi9CGz2xNbPAA6J3P0q4HY1kCa3O5JcMX4zs2Ll4hCBzewCZ9yyZtHaKQS+WCQQSD5QkrE09HK/tNXX0u1fMfUVe6tngY2l1VXYlIGQ8rVKvrbCyC3ZF8byi5O5ZIwzlhYB0MN4aDbEwn4yDUUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788413766; c=relaxed/simple;
	bh=pFx9cx0I838cE2nczWgH9ctLbDnOiEyF5R1ouuYP4NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qJefNUtniVf5TMBCTMrDlWwrOu+KrKo3xI7cfGB9Pf8tx7zmFK37avoUxZ0uW5Qel8SrsxQjYL1JEBeRKpSv+5XS8EwqMnQ9Q1rRsNC4Mj/tU+21heNQGtv53ULlB+EO7mA8hVo0XttL9geiY4GDX90iRfwrkWiWvU4Vjnsea10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=mbe/UGMJ; arc=none smtp.client-ip=91.218.175.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="mbe/UGMJ"
X-Envelope-To: nvdimm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=pFx9cx0I838cE2nczWgH9ctLbDnOiEyF5R1ouuYP4NQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788413762; v=1; x=1789018562;
 b=mbe/UGMJyH1rOfM5Ld/5vxSk9loP41r8KSqZ9An9nyPJeO8fCLPWYanz+WJxMgt6PvZddoSi
 ku7uZp+Ho69Y4IkrmvIqMCxEV0vmjzhKpyJhCYNX2SnoLhE+7QiihBv9L+ucnepxsAy5VZ8TS62
 uv1V9KQYurYNPg+nKrygATbU=
X-Envelope-To: nvdimm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id cee8c7a11c707db3;
	Thu, 03 Sep 2026 05:36:02 +0000
X-Mizu-Trace-ID: cee8c7a11c707db3
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Ira Weiny <iweiny@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 1/2] mm/page-flags: Define HWPoison test-and-change helpers unconditionally
Date: Thu,  3 Sep 2026 13:35:34 +0800
Message-ID: <20260903053535.17611-2-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260903053535.17611-1-kaitao.cheng@linux.dev>
References: <20260903053535.17611-1-kaitao.cheng@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Kaitao Cheng <chengkaitao@kylinos.cn>

Page flag helpers for configuration-dependent flags provide false or no-op
variants so that their users can be independent of the configuration.

The HWPoison helpers do not fully follow this pattern. When
CONFIG_MEMORY_FAILURE is enabled, PAGEFLAG() and TESTSCFLAG() provide the
regular, test-and-set, and test-and-clear operations. When it is disabled,
only PAGEFLAG_FALSE() is instantiated, leaving TestSetPageHWPoison() and
TestClearPageHWPoison() undefined.

Use TESTSCFLAG_FALSE() to provide the missing accessors when memory failure
handling is disabled. Both accessors return false, which is consistent with
HWPoison state being unavailable, and makes the accessor interface
consistent across configurations.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 include/linux/page-flags.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7a863572adce..a2315ab1dd3a 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -656,6 +656,7 @@ TESTSCFLAG(HWPoison, hwpoison, PF_ANY)
 #define __PG_HWPOISON (1UL << PG_hwpoison)
 #else
 PAGEFLAG_FALSE(HWPoison, hwpoison)
+TESTSCFLAG_FALSE(HWPoison, hwpoison)
 #define __PG_HWPOISON 0
 #endif
 
-- 
2.50.1 (Apple Git-155)


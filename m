Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D953D45F4
	for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 19:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784576125; cv=none; b=uryG6hCqvZdcChC1u/9CFdpI5Ziytf7/DAQ5IExTYaBMXPBrw5hd7QKH/wT/93tuiIeABauOC5cHlwJ9+6AkL8H1Cs0xqfN7FAB4MMQoMRuM9cbP44thWeE3VVDuHj6Km9ikDEAGNLu/DP0qCaXup1kWQs0S7bGh45lS3tUoKZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784576125; c=relaxed/simple;
	bh=YDZvVuwxxNQNjdV0uMiVC+0kbWzivRWlBZFWKXKo0fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bJBmKS7OAtWOE3zGcM2il2SpQ4LA5dvSHGVIJwsXLIZP1YgSbBbyiSboB+YiyxBSSujCkp5XtDUF/9F96X+hCQN5PDPEkbR1CetCA+M1NuQW4Nr8xFpLzbrUto6duMoeK62uiLu6fUVI3ZjdCScG8jpFfDobYbJfHzdhKCitbGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=VT23AYWY; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="VT23AYWY"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e57a753f9so948658885a.2
        for <nvdimm@lists.linux.dev>; Mon, 20 Jul 2026 12:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576115; x=1785180915; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bn1va8d6JpVtah/28aJ2nDxAxk/IiYTaqElYsPWqJNc=;
        b=VT23AYWY9cnj9qy1D+Yq8FkEcDFRq3jfJbbXSj0si2/mzTkP8QCNacFiZeVJ1nzw2q
         VuaMp3St/OOy2doCBkxBzKkZnwCKrODvOUYoavJ00Vi5YW/oGD0qquNAwFZPBCEGctc8
         4CNS9PNE9xdeh1CZ8ctT0In+g59Qfd3A+Zy2aTJzLe7obN7Husw9+wI21aqfVp1mqIDY
         eArPu9e9BRr7XqMfMTI+cExbRhJywwJ7HbnJptdTxiME4+4lrn4DnDVjZ7k7OhlYpi8w
         ZverMq73P5cWVB8HfKyIVlEYLlgvcKaWf0wqfli1ZfOdZ8w3I18JHb2b0nBNWsrG5fzo
         hJvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576115; x=1785180915;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bn1va8d6JpVtah/28aJ2nDxAxk/IiYTaqElYsPWqJNc=;
        b=pVsKkPR2t+IAz0jlDG/8JzqdyP7CPK5Wor8Nwhz5FOxgw5/4W4Iee9/iiEgDe8Cy0X
         msKUrQRVJbZUa6J9E+KpB+q0gTxfznCSJeVrN0w6TJRxp7vr4xWP6vo4f/EWepb2P4Vt
         wYkIIXRzfYgXChCa5aTsI/gbjcoBO6obFb24HiMPaBWpS5Jw3f8R4lT0KUDHZ8JbLg5+
         MX9nLBlen65pgU1Lelm5vHY/gfuUboP4XdlvPUqzWf99SzXGy5wAtG8aBKB/wfUDil/0
         j/t0ueRTNE90NWQYCmAWh+1w6EM5g6lS3tZjpHFrburmgcak7StYIy03GECgH6Gg9heL
         j30g==
X-Forwarded-Encrypted: i=1; AHgh+Rq3IvShgUmzIIsGHVKuYbVlplZIqSoM8H3FjOW+x8jF0PS8/3e1GQwAUDaphv4esaKOVOecgSg=@lists.linux.dev
X-Gm-Message-State: AOJu0YxXQV6qZSz5ICtNSnTQwIoK4LM1q+cLzpqqcS6gnue3U6QWctsF
	2lfnHmVwbYKd+eGhHH8/NY0lLv2KqpbqM25+6ha+WUwD+Mq0GagSFuE7BGUuRkI0hl0=
X-Gm-Gg: AfdE7ck1HiTb7haC9BTuBXjX8AAbSTQWSRqRulSMmpwNU7ky3IEuBh6Dosv6v+8E6zh
	9bFgidnh1DDVmgJUqb/uFQZlr+mz8t9I1HUgMR6rJIuWv5FRZxiA7nDgbIUGjTQIS3zWZx/PBrs
	sMMEwvCxIBnNd2K7g2zRe9/AOgJJPq9qNwc5l9YJdAy3ZuBpLAsEUYtBRVNQpU5dsXu+KlvEflQ
	FcaVpWJTkk+veN9UbhG+NhQLk9MOEL5QaIKY5GUlquBjRaxNXwEW4Y13hElYT3QHzt0ufG5DfDE
	oqBLEdwWfuzcN+HRcr46waajXdeOUNYp+cyESWTps22GK0jMEkQZA92kFd8pc6sRpmpC7gLAgpS
	2iBFp7PNtu1PvVShp+eAMIf1svSvLXGwZteHnRo8pOjeA1AMcuriLdPnd7DeipP2Gj7onNNXkOX
	AebDOB5Ndw6wIJOfO8YzxnJZQmg8TXXuscJvFGd0Th2gOJ8BnVOz0SI8PkSatQ5aA=
X-Received: by 2002:a05:620a:f0b:b0:92e:5ffe:7833 with SMTP id af79cd13be357-930b41d083dmr1531787885a.61.1784576115361;
        Mon, 20 Jul 2026 12:35:15 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:15 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 14/36] mm/damon: skip private node memory in DAMON migration and pageout
Date: Mon, 20 Jul 2026 15:34:08 -0400
Message-ID: <20260720193431.3841992-15-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

DAMON operates on physical address ranges, which can cover private
node memory. Skip private-node folios in both DAMON's migration
and reclaim paths.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/damon/paddr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e4f98d67461f5..c741a94319750 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -12,6 +12,7 @@
 #include <linux/swap.h>
 #include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
+#include <linux/node_private.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -250,6 +251,10 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 			continue;
 		}
 
+		/* private node memory is not reclaimable by default */
+		if (folio_is_private_node(folio))
+			goto put_folio;
+
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
@@ -344,6 +349,10 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
+		/* private nodes do not support migration by default */
+		if (folio_is_private_node(folio))
+			goto put_folio;
+
 		if (!folio_isolate_lru(folio))
 			goto put_folio;
 		list_add(&folio->lru, &folio_list);
-- 
2.53.0-Meta


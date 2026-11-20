Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198221;
	b=j8V2Q5TW1sij0RV4W5TcztYOEXWh6sKsUTyJEWExAJvN7pJ57R6acfBCGiKmT6jWMyjR
	 GykIcvXs+gRD+tLDcG4uopifJ0CKy45R9pQTLQJ2/EiOUoLiE7SPSV06h2egVoLNXeSbf
	 Ul4Epbyp7TnBEv86G74I0Gd9cQl1oaIupbOVSeUCASekssflRnuywsCc6s4ewhCeBDpTU
	 xZ3oiOAa1IepCcNlhN6fDSnvl922aTNdmxhb9UnAZ4o29fDINmW1rT6sW1aidDKhpYm47
	 WaOnEFIYGrLuFZdhRka+czhLKspz94BLqZSXryqzJ9ik7B8Ftg0lZ5zFvkQg2sf1JVA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198221;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TnBcAFfhuVREQ06HLGZKn0FAq5MbkYivQ/m5eQpyggM=;
	b=iLjiBGEEofTyhPqT+GN/FdBs8EIszWHFmTnXM8+c4Yx3ndDmyh+aPZW/jCBvRRgShbBS
	 x5zhswH5rtTkXqdX8f/NFFp1J0F7WfyUACIWRhapelMUEIyX3krQDinaGfFjQjFVIxH+e
	 fan+cw/xvnebw0F/aMJqRoyqYEdFt+OY8Emg5JYF45EQZVMvk/SpOlxZP6TPlTc7yyCsb
	 98GG37HNrpDu9y/U30kUSszOtIdvO7FGe/Sh5gyDzC+CuQtFrkvXzNfvazPV6UPhT8xaB
	 Xd2t9HDuj2GBkBPUvz8uMEzrmngQqD9zxNs1caSee2p6nnO9ZGx/aPP/gYgs5eHpoBA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YK1hl+bK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4EB606CD3E;
	Fri, 20 Nov 2026 18:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YK1hl+bK
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198221;
	b=qJkmafLuPOE8M0aBVjR/exmicWICeISqh+HZfyHaXbkLf1riyO9ANamxO+Lo33giKGLY
	 O3hVeLpZM0CuJT15D2n9Fi6/EvsJTqHDAUFpAAtffrLtflbm5PiBzP69JgLQWd/lIGl7c
	 8RnxMAVQ7bUQXYVv6EH5X4eGyXbNQynqQUPZy1Kl/hoFJNHloLb/SE16UZgC7pWAa5v5i
	 XIjz+sdz/mNTXwEMqI3ZepVfdJj2rCtFnWu6Gd6gv7HksYDFTkiKHT71BmXxDajiP2qjs
	 bPz5FlD0LKqItxZnRAfMYUjd4BaFT5pZ6rvOq6O8gH6j2pmtM9odGl5SA92DqPk4gWQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198221;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=TnBcAFfhuVREQ06HLGZKn0FAq5MbkYivQ/m5eQpyggM=;
	b=koDVgmXM11C0LlsNK4OZkRVTjl2/sP+GRzlySPv20PccX6FKMgU8kZmo/HBuXlxx3/v6
	 P7m/MK1Pz+xM69ljVPMVhMLaR+1kWofcn4wXQ7Ia+KTpk/hfmvd+8blX7T0z25ZOnktIU
	 cFvu56pnmOp13Q9hWLnAaWicaHe5Brzeo6aEqkWl2/aaJ49JvAHht4brl2FFHc9ZsxLPE
	 z/mmOxOZfGIeTE94qrByF8qD/VQiIRm7aDsNUMVyd9hRFq0RRxsyBdO8qUzg3n0dS7f01
	 vuboYefAWbzsbO7y3734GmnxkG90wUsMs6Y8oVKIZ0hDJ0EBMSux0H5z/58J1ZORftw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 748EA1F01801;
	Fri, 20 Nov 2026 18:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198221;
	bh=TnBcAFfhuVREQ06HLGZKn0FAq5MbkYivQ/m5eQpyggM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YK1hl+bKP8+9Er4E+bA4YsEmnQQPMrEnjL+DZ/FUBgBPWEWEYAqkA9XkTO5cVSTir
	 ADAjlZDtvV4k7RmHMmZH/jVSBgibXiabHkP5JCrjZ76pPO2Or7sbIn2tqg5ygwQpQR
	 jXLAVNkVgmAMjdqPuJrnpLZT2y5cQ8vfCIlf4n50qTQprsAqiiTKnzL0f1cwbAGWRJ
	 GVvukh0OLwFZVbjTePhf+3eDsMMC7sZU0mNWG3n0yruWdfTdSNCIweBRQdLJ7AjHwg
	 5xskS9V3eqBOvQc5M1Z52LxnMng7DUCc1AR3tQu6zceYeoMAirYkaf1nzuMUsMzoA5
	 2AtXfGS/nJTMg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 487184B90D;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:10 -0500
Subject: [PATCH 19/60] mm: add folio_is_common_memory() and
 page_is_common_memory()
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-19-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1507;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=m/xIO2hju0O2MUxmJsoUbcjHDLOxcmw4vOXYB3RhCDc=;
 b=r9U28O85QC7KiTn0NtGXb3PVRmPqixIvxW3FarWvGYMIe+TtX/FQCmUuDfZ/0dXaLjaL/g/Lw
 F7K7kgvtuD+BLMHEs+q0AR9fgZqrNmHByKFqFVDK5bc8MLFaIcotn7f
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

N_MEMORY_COMMON decides where ordinary allocations and node-scoped
services go, but MM services that walk folios reach them through page
tables, physical addresses or LRU lists, whatever node they are on.

Add folio_is_common_memory() and page_is_common_memory() for those
services. ZONE_DEVICE folios are never common memory, so the helpers
can replace the folio_is_zone_device() and page_is_zone_device() checks
those services already make. Following commits convert them.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/internal.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/internal.h b/mm/internal.h
index c102e0f498bf..cd0562f0b68f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -65,6 +65,21 @@ void folio_mark_lazyfree(struct folio *folio);
 void node_set_memory_state(int nid);
 void node_clear_memory_state(int nid);
 
+/*
+ * Common memory is available to generic MM services. ZONE_DEVICE folios do
+ * not qualify even when their NUMA node is common.
+ */
+static inline bool folio_is_common_memory(struct folio *folio)
+{
+	return !folio_is_zone_device(folio) &&
+	       node_state(folio_nid(folio), N_MEMORY_COMMON);
+}
+
+static inline bool page_is_common_memory(struct page *page)
+{
+	return folio_is_common_memory(page_folio(page));
+}
+
 /* mm/vmscan.c */
 unsigned long zone_reclaimable_pages(struct zone *zone);
 unsigned long try_to_free_pages(struct zonelist *zonelist, int order,

-- 
2.56.1



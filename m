Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198242;
	b=csJjqpvE355OhL9Qj9owq8n//lYvAWylR3CThV7GvchVtZxJULJsU+PtPzH2tYpOdnHq
	 VKxcSw8+jM5XT3clv8JaYUvBFU9ICxXc9ZX4fgGGSJDaJdGowF+zcVhAT7Q8x9tkUSy0u
	 rYYcfmkrDNtOimV6o5WS2miR5Lc9hF2zfNH2j3lMhVnBZ5zJPXoppXj9jPaLksBgJ7XRz
	 Ax9U6MTPaYy5WD0C2NI953N8A+LBmxoaAIzgDCAIS9p9hTgfXhXBVTTodmmBBTCei3HLG
	 Ltossr1fiFiGv/k588XBUQn38m2T7iMsmD2ZQmwWaMqHQhTU3Nup/SOcoJBQMP632gg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198242;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=08jpQl5uuZyQGxrg7doFW/+cSJVy/xq9ASMxnxrK8D4=;
	b=LmAkBL/cYWC9o5SZscYMEJkR5SSe0+Y82CmmMHY8rl/lCG326J2a4B2XIAT8sWv6EkAz
	 CwchBHASZwCg1SZWSj7KIwOMXaQbUUDrv9raEH/0fXtEkvd/n7tS7hap5sEJwRtuwxxqC
	 D4bTJO55idGwvFGU+6Zlf+y/kRe/utziaEKnAJtw+jjamuJ3FNXAlbWVG1JgI27egAvR8
	 C2LoPcbqJUUiqtrJGwDFPSFkYH6WMpK0kY7ygORAn7tb9ZkplkkV2NqVLep0XziQAPlSI
	 mfIUPOBOXIHjKo7kNJTbYiBS5qL/K2OifFq0aIRQu7Qg5nnrj3qnOePQeUMN2439lEQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBvdvPF5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB26606CD2C;
	Fri, 20 Nov 2026 18:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZBvdvPF5
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198241;
	b=lXglAEyFpCtyFlCM5cCHbEARUAa68g46/A6F1RbFTqkMgbHxLizxMYRKvKY3wbS5xSbf
	 on4dwVB6Or5BiFMb8WsdRAFUO0QeLRPh2RzhFxD3ufBFnO/DFDYGOFWWSOIofV5Gk27PK
	 oudKjDT71sqWu7m7tDDhn9HZuU7tGs/PRyPTl6EzvjqIV02hZZK/qBnpzmEvWZWLP20MP
	 Mqc54z4WZMNilen2r81C5PsuP+JWe1xMQt4KMyWkTTxGFnTS6m80FCp51O2Ubm+1v3T2J
	 IZNIfwG9wonZMXZ7usda9vW0RlEUDZQyVM++5xRFSuumDztQYt/AQZW8ZTW6mCcctGQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198241;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=08jpQl5uuZyQGxrg7doFW/+cSJVy/xq9ASMxnxrK8D4=;
	b=RiO3CSNcC17NiVIdISV1AJmgguvgJYZQXsSGxg6ZA6GW9QKMbCGzyNP0wlyo3KLHapGp
	 tWxIyvnzVtzBKdyuTTCo5xHPQbbtowJNRUbkAfwFSpSEMz633NMHIivcD5WW0jk1SD2Tk
	 vYKQ76cOtRroKQg+tS8vbcK1M2llN9Wqg9QaFQteoa2QO7Ih+wSH/Y+0VSlTb8F0OdCZ/
	 rhAOkmkgzUdm2Bsjzv5UQdGycEdrUmkASv2Htxwqs4lB3H5dF4oREko0I4HH/9vRdtUun
	 hXnfYMbY6pzDf6N4gflGuCd4bpEoKo0ts+KDWbquANniQYEYUvbd07mz81EptnhtvEg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D6FE61F01805;
	Fri, 20 Nov 2026 18:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198241;
	bh=08jpQl5uuZyQGxrg7doFW/+cSJVy/xq9ASMxnxrK8D4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZBvdvPF5v602wMQZ6Z84fGkNGrHpML+ZxUa8rYHhHoVSwm4UC/MrnaCVRP872tXRf
	 vVvCS5bHJ8jQ4GtO92Bb1BKSwnxJayHZwAy9pt4+wm/Zeh3SnS3o2g3qQwPGB/IaFp
	 3nrXqnrA7oj3wcWPrZeG4Ucl5i1imBervMI2voEiduaLpX4nVYkCRLdBkrjkwvRK7L
	 DbSU3gP/ArEuKA617zSGToHy8YwLhCH2HN7nTDoKwUopYDZ6C/yt0OYseq94Qb9N60
	 3Qw5XU5tJXce2KWqWC7nSUQX7N3jvFzeJbmG7zcN2wji71aPrygxWqGUsTLAKNnREl
	 U5yuoGeR1WocA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9880A4B959;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:29 -0500
Subject: [PATCH 38/60] mm/page_alloc: refuse contiguous allocation from
 private memory
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
Message-Id: <20261120-private_nodes_v6-v1-38-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1528;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=SJvqLJtfHqxTbxOinmUOdOKCVWk7SGtVeDyrji7C2Tw=;
 b=Irg8N3GrwFg5yXeCFynVswMM6e7cnSR82GrmMFfEKmwMHPcu5/cEKgAKCYKrx+y54cYfXcmSK
 kzbXph7DqTTAa3NH+5AcJKokpz3sVmwYO3+Bw14lYWZ+1wiDm0fftM2
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Exact-PFN contiguous allocation bypasses the zonelists and can invoke
compaction and reclaim.

Reject a range on a private node with -EPERM before isolating any pages,
and document the error.

If a user of private ranges shows up, alloc_contig_range() can grow an
ACR flag or an exported api for private allocations.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index de1a13a91ef4..08e57f809a03 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7379,7 +7379,8 @@ static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages
  * free_frozen_pages() also could be used to free compound frozen pages
  * directly.
  *
- * Return: zero on success or negative error code.
+ * Return: zero on success or negative error code
+ *         -EPERM if the range is on a private memory node.
  */
 int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 		acr_flags_t alloc_flags, gfp_t gfp_mask)
@@ -7410,6 +7411,9 @@ int alloc_contig_frozen_range_noprof(unsigned long start, unsigned long end,
 	if (WARN_ON_ONCE((gfp_mask & __GFP_COMP) && order > MAX_FOLIO_ORDER))
 		return -EINVAL;
 
+	if (node_state(zone_to_nid(cc.zone), N_MEMORY_PRIVATE))
+		return -EPERM;
+
 	gfp_mask = current_gfp_context(gfp_mask);
 	if (__alloc_contig_verify_gfp_mask(gfp_mask, (gfp_t *)&cc.gfp_mask))
 		return -EINVAL;

-- 
2.56.1



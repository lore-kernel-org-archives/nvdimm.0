Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198203;
	b=nSa1lHEZvltOSt//X/YiEA8MUv8p3O2aZl15FRIfumlO1rNah87JjYH6EJB5Nj7YukZw
	 r+xhxU8FxSSfjqyXEw5P/aD3cE/7d8yUTHKzYk5i/cB2Tn1wG7FBjlAr6rLVVgaAADMKD
	 Qyp6W3d0MM8xh6NGR1mZ+urJauHGEXpe0eY4wsPk70JEHFsbQhd+oPgwnq9hwWLq24va1
	 66xKNSgyUnBhi1mFYmhupVsLSw0u5yWRk9SW+awLeT0OmrLVDN5dkM1zTk/lHCfHhe6aI
	 FCYrmAAdRn5r6dxQeR/kgJxeqDzzlsvhkCd3//9r3C3klrY0Ct9Jwn8qkB5obJXBDuQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198203;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gr73u4IkiOa9BCictU2VtS3g9h9o19ZGrPCxtMBrlkU=;
	b=1M8Ouc2ydTwVgpI3Hg1CD+z3FZBvIthvpTgU1LyklXxtY5JKtxWG3R0F4vdG3jjs33iK
	 lz6uLUOzTpyAWJ6+YhLAkHUVjCS3C5RFUNEgy8iw6qYvntzs5t524zrl2ZfIuUJL+5rdS
	 1KQjZyBe5T6TAX3HwPF1TwJMzyd7aSEUs6Um23KJkSdRN2rPEw3QHUdwGHj7AKn+mjDkF
	 YkURr3+MaX093dVwENL8+PaHeL2sXQi48tUyB5Oxdxb7uK9Z5QjCrCuLhNIvSiobeWIhk
	 bbOuk0eOP9usnQY4ATWNEl5xLcgC298XBkJkbq/862OlOGRV33+sA+jVI1PGhiQ1O1w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V9t4NOrO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A945860A3821;
	Fri, 20 Nov 2026 18:10:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V9t4NOrO
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198203;
	b=pcy6TrsYtbxPT00FFvMrWxXBm1BvXD+RrBzPHwHerYQDTPFtwJdJA5XJahkQbNBc7WEM
	 Xk4NtW0MD97lz3yaShzWH0hsHZJO1bXAi6bIPkAYFlE0muF+FzoMmjTumU089+1I8/4cN
	 AsBxLJPh3iq4HfPCa+aBy23vRBvIAhPTKZ/EymnD5J31jkL3hG1krzuvsZZQI4TZpFKTM
	 BXJ/YnzVx0bO7hQDknSc4mzgD4gOjP5ySipbZzLAVUv61qBGWiUXDtRiw8rkIADu7RVaQ
	 mEUwG8wQ7ju1Fiqeb/8ni7qI4ZBaFa53CfEkyew7/oHGUTL+2GiBQf9T2lAyCroM0pA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198203;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gr73u4IkiOa9BCictU2VtS3g9h9o19ZGrPCxtMBrlkU=;
	b=WeZWO+IwlNudUoUdh0s8YJ1GUqI/4tDzw28u5/J47P4X2QCV9Kmkk33gEWEomstNd8mh
	 uuBdTc0Q1WNObr9UE6wuBXRqvl9bKovJDeNznB+Ic4Fda/Ek7hgK/j//R4Dm+oJS1WSmJ
	 1UKpysKz0bU+UmHPEBBb6rY1+qqF2w17hBtG7jUNFc+pZyd04ZGv2tP7AH+82umL8EMt2
	 3ZgyNnBQrkS5OgvlGV4FoBCmjfcGKGekMRaqnXsFYD2q+ez+SlwRdNGc83IJjNgsPTvyY
	 GySuD+lK7F4qUcAzygYX1oJMBDX/czQz5ak/mzYLWr9thA9B+TIWBPbX00rA1ph3DFg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 33BA51F000C6;
	Fri, 20 Nov 2026 18:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198202;
	bh=gr73u4IkiOa9BCictU2VtS3g9h9o19ZGrPCxtMBrlkU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=V9t4NOrOpwKjlJTSqfVNs2ckW7HzMjb+nEVmUZZ0v3HqmXVn89EzNv+FjnJYR5YuV
	 zw6H5C4aBVGOHHOqJGAn/47aPFcQDb4Pa/ak15Cp1iHMt3KQR4ZEdmfcT6ECFWQQM8
	 eQLAAHScIUH2Z8ICdKMb2wf8mECAjDzACzUDhDtefxHi2yXlXZ9ImxnFF+5KR1vS1L
	 WcP2At4FYuKxScI4u15+PpVeFK/h8ayZTeVYSlkTvYYP5OY805Mi7gm0HKFfpy/V27
	 fPtrbFu/UIGXO5OM+Ji5+fr0PsV9r+3CJMEVLpn4g4Wohi7q4PP2+I3lnePq2OPgUn
	 1mK1l/3GDIGrg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 175F44B8E5;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:00 -0500
Subject: [PATCH 09/60] mm/damon: reject migration destinations outside
 common memory
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
Message-Id: <20261120-private_nodes_v6-v1-9-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=912;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=PHs1dwZV5jWDY/oD9jV+dBublSOMfq9XyD2sA1X67ls=;
 b=EHjtqMd7/8EaTbdZ+vJ1PCa8apdnUFyPwhm5wisIAr5smnjEwxj+N6vWTCoyNXJw98hRk2en0
 +blI33RHe8NCH5zVJHV0l2+J4bHQKjBy4yR6u86Gh0NgqVYPfJ4g5b/
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

DAMOS migration actions move folios to a node the user picks. As with
move_pages(2), the destination should be general purpose memory.

Reject a destination outside N_MEMORY_COMMON, exactly the same as a
node without memory is rejected today.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/damon/ops-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 2216a0023154..15cabc79613b 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -498,7 +498,7 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 		return nr_migrated;
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
-			!node_state(target_nid, N_MEMORY)) {
+			!node_state(target_nid, N_MEMORY_COMMON)) {
 		damon_putback_folio_list(folio_list);
 		return nr_migrated;
 	}

-- 
2.56.1



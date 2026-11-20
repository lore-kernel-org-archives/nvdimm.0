Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198265;
	b=vdN4RGs0iQF3/hO2bXu1a+3Oi7p4WQyMnt1yuD92O0xpXSjXtNtJAbgKxicPNJ7CO4qL
	 +bPmuOFC37l4vrIh8NY1sYDttaqOeVTa5d9QOWKNXJKVfYTMCf29v9bVYp9sExlS4nTe/
	 NRmfCqId74OpEY4MNEjTDN0khVMgKvZYFWA5LZASfHSwbaHVAUr+38dG2YCM3MT1KA/mi
	 vZYyPhjFpLWyPD9OqLnQTNWcwiluhGKx/9cm7lCi3uAFPePp8enEplCtVUDofUxgXllod
	 OmqqbcVzjnU4bO+WPMreQ0Rml6p8Jq3BYLUU20aHFSjQ8NmO/uwhZi/HBvwqkh5vYpQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198265;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SDxj2h8LUz/yKelW0hpXFzxdAGDfTr2wWvPbhGHboyw=;
	b=E2Vk2Rv2FNCrm45+Omk2ZVagZ3ET7ukOJL2RHt2B21QfJXkD45o4wBjUN0ZdS03xMy0J
	 06QwzQcY0Hrhsztwif05ds+lfJYonKfniaIZ0uV7kOFzUZLjGXHXLV8n1OEkNu75NuSrE
	 3Tha0HYbE9UiOB4SQQR7lRXAUX7u7TIcB56Y2y+iilW7HnYJl3iPa4/Dc7Y46VS1/Sybb
	 FP6iz5UZaf3mLQLkIpzUNHon/sJFe8f3dMWQVM6eZkcWHki6tT7sKdROUHTM8yd6A8Vsb
	 wwcwLMifIfenxUd5VRqTfv3EPeyMRI81m/ToPU/EcfYcLvpOlSAir/XoQ26MEZ9WaQA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7wL3Pl5;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F133606B44A;
	Fri, 20 Nov 2026 18:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K7wL3Pl5
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198264;
	b=kE0AhTAjt5mvEomE/RIe4XLX4Hs2ipvGMh0A39Gte3At61QLY3YKijQYtPfmLTu0cvOn
	 2G5RexrBMAmASK+T0PHWMxP1tockKYsktieMqq2ylad8C408CeJvqBSD+qR4uIHzvlVA/
	 8iyviVJfOQKQXAR7Z9L/hZBcAIVr1O5P6081d2jPsmRSGzLQSp8V+5dR0vi50Hiwvo1ku
	 RILztZiGyaELi7K3FGx1xNrZdUp5hxcqi0ah8qqqQbE9LgVeVjJDxHLp6PG1p4tkF97we
	 soDLFree2320Fy9NDAF/9mtOALb0Qyi4AnFPocjLG6TzfVopq8B3nL7H8sDj0uGoI7Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198264;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SDxj2h8LUz/yKelW0hpXFzxdAGDfTr2wWvPbhGHboyw=;
	b=wRB7iNq2zmkQkjDdbza26hhQjBigLAjR1kMtCXtf+GIKUOZiSo+IL/oF3gJT3i2WFwBT
	 7jl7GuqyrLroFzr+uqmwn5D+QPqo5DMZlS+5LexuSyn8YdebRKRD4myPFx4gPnntuq3Un
	 ljL8hIRxZbSiM//AT7dpwBnYtFQHxAzNPyv5BBVC1qWOLhT0ljKJQtf6IqGvj8R2lTpqQ
	 5rmnq6Ts2xsJQwKycqgevOqIvf6vo56IUnd2v1gq1FIGmdvmTcMrPZVEuDOOc2IZErjjq
	 1cJ1+f/Ojy4pRZKZ7Zl27JC3bEA78PGp4/I9JNQHGAWWY1BlhhuhfLd4FBmZYSMA86A==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A237D1F00ADF;
	Fri, 20 Nov 2026 18:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198264;
	bh=SDxj2h8LUz/yKelW0hpXFzxdAGDfTr2wWvPbhGHboyw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=K7wL3Pl51LKxnGHBdlAfvvRb3zx0G66FKkg2Bk9pnCrUpi0EZWpAc3i3mKVijKO+1
	 gk92KS4/xtldhh5+fZmphZMHXuR88Ba5MWhELHAEJBcstzv9ZD03CiMskChzCin+mS
	 SErYPhg0XAZ+ESZUpSS0Chrr00UQSAT/TAiivIAB2oBadcTsH6+FFSNbVOtUETNY4W
	 6qipPQWvN/58Cy+XDAsMTE0sXGXqp2JYllhF8hDMy3sEF2WyIMwfOTFZch2HkNRsCl
	 LU7gP8sH2rNAIDKCqNR3V/QaSbefxiPNdOQitIeIQJIlNIA62N7R+Vc8+thL45zOk+
	 NJojqlBCUiZhg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1E32C4B969;
	Fri, 20 Nov 2026 18:09:22 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:33 -0500
Subject: [PATCH 42/60] mm: fail private placement on exhaustion instead of
 OOM killing
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
Message-Id: <20261120-private_nodes_v6-v1-42-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=3361;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=TbRq76F0ctxLdrc4ZvqTJEioaj0puOvUL1bbmmWV60Y=;
 b=4TuCqLi3E6og3lhWPEnbx57vqhH0UZ+xHpnIJwJApHy8FsrwbpMCJEhWBmQF1kacYofzGuQUk
 MJg+9HMhsJnCGqIcMdsQtmg/Q+w3B05gKy4AO+RBfvyb9bK7v/Vtefk
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Private memory belongs to a device or specialized service and is a fixed
pool, like the HugeTLB pool. The OOM killer has no good answer for it:
the task that faults the last page may not be the one that filled the
node, a remote accessor or another mapper of a shared object would be
blamed, and killing a task does not free shared private pages.

When reclaim cannot satisfy an allocation from a private zonelist, fail
it instead of OOMing.
  - __alloc_pages_may_oom() does not select a victim for a private
    request, and marks the task.
  - handle_mm_fault() turns VM_FAULT_OOM from such a failure into
    VM_FAULT_SIGBUS. GUP and remote access see -EFAULT, and other
    callers see the allocation failure, e.g. -ENOMEM from write(2).

A request that became ineligible since the last retry check is not
exhausted. Report progress so the slowpath retries and relaxes it.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/sched.h |  2 ++
 mm/memory.c           |  5 +++++
 mm/page_alloc.c       | 14 ++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index e4f6323d7855..8a2e37475e5d 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1038,6 +1038,8 @@ struct task_struct {
 	/* whether the LRU algorithm may apply to this access */
 	unsigned			in_lru_fault:1;
 #endif
+	/* A private memory allocation failed; a fault reports SIGBUS. */
+	unsigned			private_alloc_failed:1;
 #ifdef CONFIG_COMPAT_BRK
 	unsigned			brk_randomized:1;
 #endif
diff --git a/mm/memory.c b/mm/memory.c
index 282266dd5e5d..4a8a08df28ff 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7003,6 +7003,7 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	}
 
 	is_droppable = !!(vma->vm_flags & VM_DROPPABLE);
+	current->private_alloc_failed = 0;
 
 	/*
 	 * Enable the memcg OOM handling for faults triggered in user
@@ -7034,6 +7035,10 @@ vm_fault_t handle_mm_fault(struct vm_area_struct *vma, unsigned long address,
 	if (is_droppable && (flags & FAULT_FLAG_USER))
 		ret &= ~VM_FAULT_OOM;
 
+	/* Exhausted private memory fails like an empty HugeTLB pool. */
+	if (unlikely(current->private_alloc_failed) && (ret & VM_FAULT_OOM))
+		ret = (ret & ~VM_FAULT_OOM) | VM_FAULT_SIGBUS;
+
 	if (flags & FAULT_FLAG_USER) {
 		mem_cgroup_exit_user_fault();
 		/*
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 63cc8729c41a..ea48991ef589 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4176,6 +4176,20 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	 * failures more gracefully we should just bail out here.
 	 */
 
+	/*
+	 * Private memory is a fixed pool, exhausting it fails the allocation
+	 * rather than selecting an OOM victim. Otherwise, if there is some
+	 * indication of progress because of a revoked request, just report
+	 * some progress so the slowpath retries and relaxes it.
+	 */
+	if (ac->alloc_flags & ALLOC_ZONELIST_PRIVATE) {
+		if (!alloc_private_reachable(gfp_mask, ac))
+			*did_some_progress = 1;
+		else
+			current->private_alloc_failed = 1;
+		goto out;
+	}
+
 	/* Exhausted what can be done so it's blame time */
 	if (out_of_memory(&oc) ||
 	    WARN_ON_ONCE_GFP(gfp_mask & __GFP_NOFAIL, gfp_mask)) {

-- 
2.56.1



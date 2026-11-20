Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198246;
	b=pH4+gDtcYvB3AQLhy1cRKd5BN4R792p20EGX23EyhWwwLZylmXOsSfx45rbodbFHYguV
	 iX6oyL8OsxFeWinRWYnPW9yWxJbor7njlvXROc6HJzavlACYzkMMx1HJr9y1t7/D5qlcc
	 0pkrwIjluXjTWKEzaJFZ0u67xWCUKICjj8COTSU1rrgz8+naRlIg2O65kRxeJjCZ8Dlmh
	 rlJP1fnB0Ecx8EdCe72Idiqb0KEIEtNaHYliyjK4Vd9dDV35y0hImbwsrKFWxyGFmUnfy
	 1VNTY3vlBIAyD7eok4Zmx75bQA5Q/45hEiUOQqnp8LzOlDLRZHvznV2q5aeTQ0TTeTg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198246;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hiSbpQWW/gUTlgsWMM+m+hivzUTcJ7Oj0fNSfIqp+1A=;
	b=wiyP9L7xsEO5/1MPWSoGZN9IJ64vOZ2eqXK0ajWFARDGR8BW2j1b4q7R/yv0tKOkdEjI
	 SwcDXHRhzcVNv6c/xvA9pJyF8QiWNVO99TRrlrTbL5slF+tAYbZ/m1Ft2WygvqfbAHbpm
	 w3JBmfZn5tbq7LSTZPBHjo2Jr6hioryv5pg1KMLF6bohCFjL3b3Vox06p+sxzS0XTV6W1
	 CSXaVdaRM/Nt7yQXO+tz8GWRHV94aTQ/eqqaQXMiLZdMws/0t43LrUB8I2J7TqmssBwkF
	 Hpu6Y/3AvFMu2Tsm7QwlY0iZPG62vGXFuKn2TQK03Oj4nx8iTmcsNy6GHLDsqMVtDbQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzeXBNrG;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CE4606D4BB;
	Fri, 20 Nov 2026 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzeXBNrG
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198246;
	b=JLCK/1Ws0DNb2BtIjvl/rjL4ZdV7YRR2AaVy6Rjz/nTB74cYF9gUY4xXwWOdZLu31ODS
	 ucBY6jYwFHPOcOqE2QLr79Kz3xh3F7CsvSS/PKKJLLI0elotFgHPAhtN7wFBu/GXJY7uk
	 0JqjeyR3ImW52+NjjnHK8nuXpfNR7pJsxkBUF+j9AZmhYVJhkT1LJSfhV5uDysc6z0hE9
	 xOBKkNZobSQHaa2ODDHZZm9JM/wyqzvzDiYjhuF+vfETxN3Ei3MYMESlaxOPyloglB50j
	 Bp/gr0Lj9ivrcqhOI3tvogL5PJOaABPzUXInTysURal+SZoZjdXEegT9Z3zFyoJCv4w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198246;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hiSbpQWW/gUTlgsWMM+m+hivzUTcJ7Oj0fNSfIqp+1A=;
	b=0soQzFTtJZ9LH6SbQS0ITK3KwtmAcUG4j5NFIU3AOBMKbtoOhag7X44tHUGt1/a3Pohk
	 tc7l2gzNtfg65chs+CfhPjIYfJWdeHs/RloFv65dh3F1vTddmE6Sa7stwwsGgjotYtfrO
	 33D33LzZsyRxkrGzj/ceWB6zk4Tk5VD9kq8tZeW8xrWuCOh/vBWYiA18Q3bfIGbOaoc45
	 XUsUrHNoNhlHbFlVQbR9nr6zUdpDUWchREmu5CzGg009wYKJaJPD/39OcHW19kw60v+zY
	 HQ9bubmKGlHJUD485POjORlqQLjgT1uvnDi1xyhsP2k/ReKqqlawEvsr45D0BxSXsYQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C1B011F000EE;
	Fri, 20 Nov 2026 18:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198246;
	bh=hiSbpQWW/gUTlgsWMM+m+hivzUTcJ7Oj0fNSfIqp+1A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=lzeXBNrGCFqAkK/xazqF7QRS23kUzGWnxZlT951Rp0PEbxISdvk1XmykWIudz8qc/
	 Tr8S2uKWKKbdhBX/slG2p0spfzICWOvlSDKE6pjrVMMAnlOxT2u/ha5cMChWer78AF
	 f7ndfQSEwxzyvlc+JVcn39ZAnwurcKQOOFxZySFidua1SGNoTRkTPN/4GcXO/q6W9v
	 qz5SNk5ZnVUK3gColHP1ML0kS7GzF1UU5UC/q45sgqhOBQ7TdLXc7r6kitQUfSbf4G
	 Qz9m6iYnEV+917NjAWcfdUszpbQBZO5GbRWMr+vKqmot9jElI6HvCtRZrcsP6Lkg3S
	 1m8pl6LIYIAMw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 02F0C4B945;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:24 -0500
Subject: [PATCH 33/60] cgroup/cpuset: ignore private nodes when matching
 OOM victims
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
Message-Id: <20261120-private_nodes_v6-v1-33-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1825;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=tfQy6A54qGIg5N0QwMR0J5wQcHlPo4StvKwwDY0AXzQ=;
 b=TOQv91CCE4kl6kuILhP9vhwwGPNmP5h8d1k9lUI5PYoPQsNY3N5JtGHROUurmkLEfZ7JXBtci
 YRpEP+Zs0diDRgCXyfgSRDIhjJbJuiQm1kaI1p1h+gZS7NfXp8/pkI9
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

The OOM killer only considers a task an eligible victim if its
mems_allowed intersects the allocating task's mems_allowed. The
assumption is that a shared node means shared ordinary memory.

Private nodes break that assumption. If two cpusets partition common
memory but both allow a private node, an OOM in one could kill tasks in
the other and free nothing the allocating task can use.

Initially, private memory allocations will never invoke the OOM killer,
so only common memory pressure reaches this check.

Leave private nodes out of the intersection.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 8401b69ee3da..e20f9ccb8ab7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4628,15 +4628,19 @@ int cpuset_mem_spread_node(void)
  * @tsk2: pointer to task_struct of some other task.
  *
  * Description: Return true if @tsk1's mems_allowed intersects the
- * mems_allowed of @tsk2.  Used by the OOM killer to determine if
- * one of the task's memory usage might impact the memory available
- * to the other.
+ * mems_allowed of @tsk2 outside private memory nodes.  Used by the OOM
+ * killer to determine if one of the task's memory usage might impact the
+ * memory available to the other.
  **/
 
 int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
 				   const struct task_struct *tsk2)
 {
-	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
+	nodemask_t shared;
+
+	nodes_and(shared, tsk1->mems_allowed, tsk2->mems_allowed);
+	nodes_andnot(shared, shared, node_states[N_MEMORY_PRIVATE]);
+	return !nodes_empty(shared);
 }
 
 /**

-- 
2.56.1



Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198198;
	b=YiuSRdy33LBSsnkygr4wx9sXL6tnDE/8fP1iF69NVNXwjhaS6unq9sZ93otHDYwKRm1H
	 FS6LLrvYteRkSbvx2QycHwHitmgSbjzVVJ7SAhi0UPzaoLSSAZyj/JLXEE9yH87aQCo4z
	 hgK02tfdhCQ6y4FsjwNrjMEskZPULbRdWDij9VojiHL2aM/TfIsBSeIal95udDDMr7xUM
	 M7SsiZxcLQjMdGd7k5TGBUjVXBzgsK/n+anHvKa4CEna1VON/ppBe0iegAsjzrXFLWt0A
	 e9az3Y2NDSDnwGJTnLvBg6DxUZK1FaxTtKqufpRVunsHDI5EOCy/SseVMAYOWOTar9Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198198;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Im7ezlywxNUuwRgGis5+rWWOQyX3m2uPTqHdnIjcZAs=;
	b=RjQ44AQaKCqUi+vSMEpa/Klbsj7e8xPAN7qLK+uKQlhjuC3vpoFzUmmOroYXj7mb/E+C
	 BXxnrMLQVmL4KSIPKrrc/NGfWCh07YLeRfkgHxm5z9rh5gA52BJAi+lxaehFLi8au73JS
	 BjfI0ql2OU3HVbq5L3A98s+eRzvHQLxi9CRe3fwqRD5e97xOeZYE9egFWFCeeNZpNRdyM
	 Y7OrHa4m3/Bs+fh1N/+WbZPCxyZN6l+w7HPL8D673DrgwG3wuYWzS3z7t2LunnYMEgKvY
	 ojw3sDDk0qmKzD1mg9JreMvnugYRUQsFZMMRlymmV8ivIdlj8lyHAT4FY8p3sRPWB3w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dchYLp+h;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC41E606A892;
	Fri, 20 Nov 2026 18:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dchYLp+h
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198198;
	b=UvPwsINDuioUsGg9iJs5YK4/OWQNZOYOephrlVkuNLjJDhJMV+UOfgawpfX5JJBexpc5
	 6vFeGKeHLM7UlDwNypxs3vMCsTRQlTL8HGqPJWUBwDXjQj6KlXdDg/gRhXdcHcxCMC6Gr
	 s8NLaVNhmtO5rzECkb+KR1eGId7IwvEgDNZ4rDFfIRjC8pcCUyEX2ptfNp5SAsNt/fNWs
	 Rm8EbCtiRZNxdZ8JTP4lxkN570Qfwu7ijt381sUzAdicZAS69WiElBJuSX+Gmoyza2dQD
	 8wuw+xTSOoIcEcrWioFxDPhM2Ho0MjhlHeiXOa9o2qvJpwehmEHt18QgZObYKzPC/KQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198198;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Im7ezlywxNUuwRgGis5+rWWOQyX3m2uPTqHdnIjcZAs=;
	b=EJEu691U4b4DCfV3Jr3lHBYVHGuC/MISRfMt87JxQFNmKUGOJRkqYotfs2dilnv2PY0N
	 fvYTgaGsjHI7o9YUPYde7N7vqkjBtwQTBzS4BPFUyzG/6sAWxD2vTz40kC2Ap+Ykm1DqB
	 OcgHAIzndbbw3F0ngmHiedQHk6Dk6c1bMtLIti/s/mkBgEehmKer3MLCJ8gle5RmT5NgA
	 hcWVlqUJKYUbUuqfL9B8JEHFPdmGeEcXMUSNGbguFQjFks8h08UM1pRoclWFdgmc25nAm
	 ouF7MoEkeb4Oq/o5a/qQyVSPapRnnMerQ15tcoO7MxUlofzbV8g6YWnL2GsofvgJ/iQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 140A31F0283C;
	Fri, 20 Nov 2026 18:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198198;
	bh=Im7ezlywxNUuwRgGis5+rWWOQyX3m2uPTqHdnIjcZAs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=dchYLp+hrjFDOCm0ytR1h2GPWngIoMng7Pd5UlPgUC8+P8Uln5NrpAvQbD7RZ6E6+
	 DQBWIh4YZWOtF7HGgUGUOlasWGLHr1wq7YXr9AjibLWflIWharbECkXcZaH57GvWXp
	 rckveu07RFzbSJ3TOJc3QuP0jdehxgd035OR2ZqQI2ahxaMeX0jzOLWkeK03QaVOS3
	 ecJ4tg7Sx19Fm5dnHBun836psesQTrl/ju4sDQwn+2mCYohlVys8w+tqSCc9OcgVYT
	 lNDeCQFAVMqJM36HxcrcivInYUpoGNso7kfI805G30G8lz+OC+lfj9DAtUY5pCv30+
	 uV4rWPjRYlyig==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DDC054B901;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:07 -0500
Subject: [PATCH 16/60] mm/oom_kill: compare OOM constraints against common
 memory
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
Message-Id: <20261120-private_nodes_v6-v1-16-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1433;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=CGbgCesiUK7FaS3uE7XEsjS4RivbEoofszYkkl9tolQ=;
 b=Rl5iRdBywuqFmQMQRF7nrZzOaOma19N8ic11E9/UVk+2PB3MAEYUmgBsm8qCfHUD/luGjWSnn
 1y963MhGKdIDVXBwN1DmjehCfEvUCZJcZl0Bhfm95sNHcGlPv8/lJgd
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

Ordinary allocations reach only common-memory zonelists. Compare policy
and cpuset constraints against N_MEMORY_COMMON, so nodes outside it
neither make an otherwise global policy appear constrained nor inflate
the constrained capacity.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/oom_kill.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5d48bd862c27..1ec22bdad1fd 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -274,9 +274,9 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 	 * get_page_from_freelist().
 	 */
 	if (oc->nodemask &&
-	    !nodes_subset(node_states[N_MEMORY], *oc->nodemask)) {
+	    !nodes_subset(node_states[N_MEMORY_COMMON], *oc->nodemask)) {
 		oc->totalpages = total_swap_pages;
-		for_each_node_mask(nid, *oc->nodemask)
+		for_each_node_mask_state(nid, *oc->nodemask, N_MEMORY_COMMON)
 			oc->totalpages += node_present_pages(nid);
 		return CONSTRAINT_MEMORY_POLICY;
 	}
@@ -289,7 +289,8 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 
 	if (cpuset_limited) {
 		oc->totalpages = total_swap_pages;
-		for_each_node_mask(nid, cpuset_current_mems_allowed)
+		for_each_node_mask_state(nid, cpuset_current_mems_allowed,
+					 N_MEMORY_COMMON)
 			oc->totalpages += node_present_pages(nid);
 		return CONSTRAINT_CPUSET;
 	}

-- 
2.56.1



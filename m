Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198220;
	b=i9IwQnLWKz/5dRoz6TKY8eNs2SQfcsJeZDCUc7GbZtejQiPWuULZv4YIqQNax7Hq22Q0
	 s4aNODaKNmnwJL19y95FTPpfCPRIz/2RiSfptplBvRBkGVJH06fQZcnLCpLM/6pEQGREr
	 gyCKT7U2k0TAbsR5vZVfkkrz8MJO9BQDgX5vi8P1Jt/foR5vITb0/6uNvMDi0kHO/+kH9
	 cg240ptdaldajwOnHnQa025n0vYzctbK9Zwvd8IIpHkKfxLYTCO1kfyFUaYZL74s/apiR
	 zrLOZkZwI2K+zLlREx9Pk+c8qI1nXdF4UIzB+yrgii2MtArENy+E78uMArKKfFPnRtA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198220;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=avxZ8VwluYTpGbEPJyzSvO3syrnk95XEoYzgDY1xt9U=;
	b=i57j5iedCPruat0S8OquOmp1pEiv93NfMAiMHCNX30a8acpuf5aECQVzaQ6T2HvFqlxs
	 fRfyCC4ZvNU328xUEAPLop8GEEGezO3mJmn1M5I3IibNuX2izQL2c2FmHUZUz02xubYUN
	 Cnt5PEBuu+cI9VWz+Albsd7a+iHeBqhiuWvZp6lHedTtonkdzLIIvPw8FCKls66uYMnIT
	 FmpmIkNW+aT+XGOvUgc8MxgWDipDKomBhaWsx0kMSAsiHAGpMkMioNFt1tgd9VdVmjBFL
	 16J/vu99z8isdOvfNBTrnUpL8+5ekRvLz7yBvjyBOJjh6WyiALSh6wkYzNrWD8eLmVQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="D2aB/uXS";
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACECA606B239;
	Fri, 20 Nov 2026 18:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D2aB/uXS
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198220;
	b=hD1Eu1zCTZJzGAMX9OA6xikeSL52yggJ37jm2EYpBuaGOhdfZXw55CyIhtqsUP29YUGh
	 EWTCpkz/Sd1vrp8axQzfTKfVgTEpcOm1Ci0BShxe7IJZ70+dOOnlMt+SQGeHxNj2xHz3v
	 WvTJZiJ9wNNyU4aimqHyxu7l/PopctV+XgykyT0RBfVoksi/+GOopwgIllXDEjih6pUvb
	 7uGZ+rCj9TlkHUSiDdaEAyKYSWC2TdH1iECj26w27DOqAPEQp1VSuHSDGdagK3bYn5ZHl
	 ggClgkgHroWUU1yAfhBIIS4CxJziq9xMuwhkegBvrAM2JgV6w39DI8+uZ8C4YgAmEtA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198220;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=avxZ8VwluYTpGbEPJyzSvO3syrnk95XEoYzgDY1xt9U=;
	b=VigLLr8CtfG2WY1NXMikKD8NyPk+2di5QNnERM4PBQz27KdqyyX9wT8cZqYxvzHg2DKZ
	 /lAyrmVP8+ElBMeoVnS9DWzOLEQfGE1jv7CqhJrg80uVDMCghsd+7A5FFRBWXJ21fRmmj
	 L1sBFRbtLcNQ4LIgv6fPvBxkhzm36TXEWvKRwFbb9j6gw7EMh2nY+xUHo4fXKx4QPY5iO
	 VFhC6kM+hie7DXQ7mnnHuCPp/EqXLrNd8hEr/FuIVQ0EIt0xUsSMJbGi2TmqrwMnz9VwF
	 mRMnNezUMhsFqwgG9YIPSxNQn1DvlWVfJiSJ/10jep5Z7Dq2UdAvehWznE5E4QGnLMw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3E5F11F031C6;
	Fri, 20 Nov 2026 18:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198220;
	bh=avxZ8VwluYTpGbEPJyzSvO3syrnk95XEoYzgDY1xt9U=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=D2aB/uXSvCFHiP5MSqQ3LZnJkITZcMGDq9nlw8XDyl7R0wLzvvL0gpUPejD7rOw73
	 KqIuQkUVFAaU/1QkUwYP9VoCEE5cg186rfXhIDtu23Z/7E2kKg8o3de/KyO8nsXgSR
	 s2fxikGluaHtaPUHaWaeYEeqUjk8FAx0aNjS9UrgwLVAwYbqXgzgoagKZDxW2YMvnl
	 VZuIPB4gJxHyo60jwPfAKR5VLHo649hf6jnxSz5oo9KX7b1acCZ1taVesnO2jPYdHY
	 W5HDJMe0NZDHyNqykQWchLkIrLWNQTTIfmwCZLlnIg3Pk7XGfpqSka4CISOm4SWD6E
	 2bsuCz3XmEFMA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 26CD74B909;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:09 -0500
Subject: [PATCH 18/60] mm/khugepaged: base the recommended min_free_kbytes
 on common memory
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
Message-Id: <20261120-private_nodes_v6-v1-18-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=820;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=JCSrPzqa2r6D3icJs5AIufuY11hG988pPEZwgCCKHVU=;
 b=f3X9GhfZRr3Y70akJ+5LQMJEYnQw87oEwJYni6EhKNTNghWitJzBda24ENsNg3gaswvLxfzcA
 QCSxARUrbOQAlPm+bIz7doFjfAUsXQ0DXnPHQw+oYeT5ibepz98hWgq
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

set_recommended_min_free_kbytes() reserves two pageblocks per populated
zone to help THP allocations avoid fragmentation. The reserve serves
ordinary allocations, which use only common memory, so count only the
zones on N_MEMORY_COMMON nodes.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/khugepaged.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2dc4245814df..a930d99f89da 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3151,6 +3151,9 @@ void set_recommended_min_free_kbytes(void)
 	}
 
 	for_each_populated_zone(zone) {
+		if (!node_state(zone_to_nid(zone), N_MEMORY_COMMON))
+			continue;
+
 		/*
 		 * We don't need to worry about fragmentation of
 		 * ZONE_MOVABLE since it only has movable pages.

-- 
2.56.1



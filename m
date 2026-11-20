Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198190;
	b=GQxFnwhgH8lmT2Lh0o6+wqEMW8NhdpdpU4G3kdNhtPdh7pn0Gcigmq/6P7JxjCi5q1PT
	 o+ziWWxHFpiAhupB4xwk8mbi07h7KwMWRgEZicSIwjtiDuusygXRBLHzuU18xf/jjbPxL
	 OM4Tdug0jpF1S0SADtl8Chyrsjew1lHbT/UrjQQtL5vA4XIyIqwpKH7a0Cw/iDmjgsGnk
	 8/odgd5GUaiAajFTsmwN/6vjYoyVn0I44Mg2LKIkfeE65MxR1XnLQT+9S/Ru8uspdr6MA
	 qFtXkcxiLZYcjKsu8rsqN+PiPO6PJg6I6vriNbiOFggUwOX+C6Y6CaRBgicZ3Q6k89Q==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198190;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=09bgEhSy3QiJXmk+xsvyg2Evx8mn/TJLK5Z3TiEB/ao=;
	b=anApJoI25o8kJOfMKtB9V/q3tNRvU1Rgf6waJMNHNjaWSxAoimEhTRHV6qCWqMK89hp7
	 Xsu2smCcrzEyja34v16Kv2FLu6j1zUevpG8rdhZIB+UTnbfGnURfbD/iJXX2Uqe5thxMH
	 uKWErBWDY1ZqjBes1YAlZ4B8JWeUP7PbA70BoPsxVbYM3160GeuByVt8nbg2OqkclDr0F
	 2i/Wl90B//Z3YJPMyEAY3OS3AiAqAI2QZOBz0xuI2p/9GYUUP3zgUYVVdn/zKd4yiSKDp
	 kxYlGYsgJFMW//TkNaCZiEEhUjmlLM6onozCpkPT3JPr2wT5+ZfBdfhJsHlaj7DLSDQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SsV6KZZ1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54E2A606A8B2;
	Fri, 20 Nov 2026 18:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SsV6KZZ1
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198190;
	b=N+Qy+T2bdr5PAHxPEbCgApcfVSg97siwTSdi+Lcldk0UQBW00ZzGzwoDLf7aoXCbAM6W
	 quDHQts8hwe1Lf1OAlCMRXkokvcqlFtNBi+AknhurhC6EsdikHvp+bRQutJMsPR6bS0ca
	 W9Ju0iUP/EhQLEAruXJnnvqQcbKc8pST+Jq1LPqJp8sorjmN6y73zkhtBUxc7CUAdeQ2l
	 Ibgl3syrg0tphnypKVwuJqjZuPQMN51kLmrdwzT2YWSNUapbWm/KcCNm6/biT4d5XUem3
	 lkvMbQA4kfY5K1jihPG/oj3pXBVJODWMtGa6AZ15GmUMehXqJUA/Q94FhAI8h5nKMZQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198190;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=09bgEhSy3QiJXmk+xsvyg2Evx8mn/TJLK5Z3TiEB/ao=;
	b=iPvH0lpTiKTsBUb+nUpV0mJTvnd2bRTphH2Q4OCjLCjzwwo2z/qBtikV9bHX971B3jEQ
	 EryojyDmGqlYh7Qd8pXWnlo2336zIn3GH/6SRsS+BiHrddwWetALyoYBBGqLgOjR6LcOz
	 wl1FmbmZt9X/kAQTt+RAtO/69hRHCXC3WcvjmHP6TyUmLiNFIra3e/DqnJCzAngpZybOl
	 omfHuxaDlkTt1pPU86T4jek4MOdnFun7gNnrRYp4rtBgfXb/Dt1Ii3x4pLQWi+86Y4yQ/
	 3RTD3CPfm4vXyLn7usTW8dWcHp/SwlzK/jMk5UlkGTqgolept8TgXwjaJCxNStQFMFg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 88A0B1F000E6;
	Fri, 20 Nov 2026 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198190;
	bh=09bgEhSy3QiJXmk+xsvyg2Evx8mn/TJLK5Z3TiEB/ao=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=SsV6KZZ1j1ga9KNSpYagswfdV2/hI3yyH/oqQMAES7hrnb0NkcoAXuP9+ootTF0mU
	 CtCQXgus7oIdwHKUqloWKcOUu2X4gqMSciZ9wNUFsHxteRQcKr0TPVtgHGWyabOj9x
	 FnLApsBTSer+K7B42c4SKLo8q5GWcvhdFHzYpe2ZocCOrw2pE+foGzNjvv9KEsQBqd
	 Hx5Cj2YHHn86b4dpe2ZTqFQTIQYeu/P+6PL49Rzxs2Dd6SZNTvbpRn0RxpU9RwciWq
	 Q4LT4pRcVhZzJEGmZ0c3rtyCgtT8FW30LvswTu9hLn4msOr9QxP7QKaIm7iuCY2mJs
	 i3Z9xciE7VtOw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EDA364B8E1;
	Fri, 20 Nov 2026 18:09:17 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:08:59 -0500
Subject: [PATCH 08/60] mm/migrate: reject move_pages() destinations outside
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
Message-Id: <20261120-private_nodes_v6-v1-8-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=835;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=pP22b8YF19lh+xtqINC6tvfU3jfkWVAhKO3xXxkME4Q=;
 b=zIyXXPWBVmQkXDlYvC5h4ZDvLmW7Fv9UoBLS9vJ/Pz9f2a+rQQr2z64NdVHxlPNBrL4P3HD5y
 CL9ctZIadC8AcBeiIq1b1GZsIOfZ0Hg0mQWqGbUkGaNZffKMPxNdRDC
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

move_pages(2) places user memory on a node the caller picks. As with
memory policies, the destination should be general purpose memory.

Reject a destination outside N_MEMORY_COMMON with -ENODEV, exactly
the same as a node without memory is rejected today.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 65869b8acec5..208788b130fa 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2411,7 +2411,7 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
 		err = -ENODEV;
 		if (node < 0 || node >= MAX_NUMNODES)
 			goto out_flush;
-		if (!node_state(node, N_MEMORY))
+		if (!node_state(node, N_MEMORY_COMMON))
 			goto out_flush;
 
 		err = -EACCES;

-- 
2.56.1



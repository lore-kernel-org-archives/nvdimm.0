Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198225;
	b=Gnx5cg2qLGbAjPU8KWD5htVuTgodJ/lvi+mWP1M7mJnwCFjYHvnwDMhY0qx9Tk9m+8MY
	 foW1rj+K/dsTMZhPRNs3TTSImE46hUH7dCwq6B+p2IEoAMy3gZAvX5LF/GjqGGt2AJaKm
	 fTMN/V0sprv8Knwtc7WCjlvkBDpFUrlehLu+FzmcmpTWwMYKAavw/exj1FfV0taOalmRz
	 aeJbcuNQ8eeZ3Q6hi4EeuSbW6doB7G2ISOg+9mzDjsRi2WmtYX3q9AhvN8KOMjAhXmCB6
	 4uabk0M7CVM5vr8D6swKEzIlClxMmkSt21hz47rz7DkMiwOHq3KPk9WF2gqUVaqo6+w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198225;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S63qEZh37FcqDEnZtOKDS8dEDMlYAdmMAyDqP/DP/54=;
	b=T7GxTF8cvJGm7S83cA+LpxdTnm8rZUhQy+OIrTYs99AfO2qAcv25ICNYuj+nsTLM+plW
	 BQz3VxY2tdwJYS87PH4yNjhonoUjY9Z+5Ezasa24VCI3EesKIz3WAYmG6tW7xcu4Kli27
	 yXw0dhea/Z6G8y49wKiEGlkY9oIygHQ+wzo/O4zyFq42IoMI1wtg8f/L19+9hAUTXAyoF
	 oiCDfMCBI6wi+pPAhFmisABa6deIP7g3O16zK70unAdzo630w0WEOMm8aND09BE7NxDk1
	 Tyxu+ypL8eg1JsPBMJK6LgQmFsQWIKm2fOHs2BsWOuIixSwZ0SYggfPzlv3r0Ck5o6A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVLJY2PQ;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F207F60A6F52;
	Fri, 20 Nov 2026 18:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZVLJY2PQ
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198224;
	b=yqU5ecurKoDiEOhvAnlzJjQaSCBP1ee4OOtiMk4vpbUCIkYz0PfiR4vCrCCf1WKj99qE
	 WSDp01rYpGXnWwHczZqR6HL/DEkoUU9z6U4itLr/2DHqSGEUe6Vm6eHyzIYM+Y9fWyV7S
	 hSjwazpxHZ5cvr47AgiLrabbRGA55HyAuoIduXPw3VbY8cLN2zDiy2plW4K0mfQVmoTxv
	 Ru1eFO9ls1cIDDL1Xnq8cxAhYVky8EiLg1zHGYtM8FtPqT2ykX38dhd4EJsihb08oLZ8U
	 j4Xnu+HWkOiGxYCldFFGoprJKfQrEitvpOGPyf7ojUNAFHbLVeJFF0KMlIkOpjpoveQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198224;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S63qEZh37FcqDEnZtOKDS8dEDMlYAdmMAyDqP/DP/54=;
	b=YHvacQ75KOqGQWSmYFEfl77Fl+bHmVZdC9Y1GOPrvaA0kOpvw69fdo6rUtzDUUnlbkW0
	 OKwbxFe/5dh8KxvN0R+pUBWzPIsB4JFVjnYaXSrdXqV/t2I1WyTzptbo546RFhlpu+Qqf
	 MW4KT+GIxYnE5+V1+3AE3kaA59sixN4AQFCfxjmaCunS23n445rcm03SqsM7pTjmyvFlx
	 Q58kD7eUm5Ejn6qhBCoqM8UOPAmOvkThPIjzj0jbEDu2eGj6/qgWA/fs8q3pV4d5h9h3n
	 ITOmi76fIs74WOqUv1/tSzwhq//4+O0fYp7FB1PM+CKPN24EbtTGeSbKyKAO9nlG85w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 455E41F01562;
	Fri, 20 Nov 2026 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198224;
	bh=S63qEZh37FcqDEnZtOKDS8dEDMlYAdmMAyDqP/DP/54=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ZVLJY2PQk4ZjjL0X8TjBmaZdw5tkLK1C0P1FL24bMwbuBrDIriVSJtT7O+2Lfmtiw
	 RTongJWEvKPqofnHYKuWX7tK/NeSgYZ+iSFX7Wo7pTse9jSgK+KKwQBNEFXpNj4qhq
	 m43pxPUjCkRkLI+s7n16QC1tVTqv4am+s0VX054l6ot54k6n89c9trRG47Q1iwUu3f
	 Md31akv4CxU764xdpl4v8wOEmD32Yx5LGbDFw0IDxnzy0O21z2S1el4iMaFIa5Cw4x
	 TiQwcar9xixbAkblZrCXk17rQQbRPMRanFt8UjdbNdCV9TGc7Pzf4J0czkaD8OWjwX
	 YxvnOKOSnIVPg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 28C3B4B929;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:17 -0500
Subject: [PATCH 26/60] mm/migrate: leave pages outside common memory in
 move_pages()
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
Message-Id: <20261120-private_nodes_v6-v1-26-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=857;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=AKM465apFVaa3BIvx9XBEK691w0dLD6ac7SFTDNSyZQ=;
 b=zKNmtwP0ZJy98reK9MCbqubRCfEXRiY4oIhpY5EIBd6qtzzkCGaM6TwqOsdAK0YxCEyfiIv7s
 pNtU/wZ9nLKDgoZ6+gYrdIUpvysLRVgvfMsEzFM7klZsQ3JuUN5Arbk
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

move_pages(2) moves the pages a caller names, and reports the node of
each page in status queries.

Leave pages outside common memory where they are: refuse to move them,
similar to ZONE_DEVICE pages. Status queries move nothing, so they
still report the node of each page.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 208788b130fa..ac583afa1bc5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2287,7 +2287,7 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 		return -EFAULT;
 
-	if (folio_is_zone_device(folio))
+	if (!folio_is_common_memory(folio))
 		return -ENOENT;
 
 	if (folio_nid(folio) == node)

-- 
2.56.1



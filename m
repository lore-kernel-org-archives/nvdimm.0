Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198258;
	b=lZ3OAPyS1Bgb47kmNul/vNjkPDPz+wVDQDWc3EpRinFlBCjfbAz382DaII2HQXm7OLpw
	 gZYyHV6Nhi+JkHkujfpMS3pvk5Prjs/NsMJn92HuG/+plkpLJEgcWu2bicED9s+iKHl2n
	 Zm25E8tJlq8TNXQHzjqUWd9HT0geL/eSY3Ya4Pd80ehHi+bY+/4vo+sFGNaOG22QvJNgJ
	 y2boYp1C8Hcu4XMWI/pBDf+csKiJV6v+UzCrKNbpjfrdIK8QhWR1hXewTV0WALgtnqLCE
	 69IJpz9+LPbD1vAlrcDKtflStwaNimK9Rr/cOX5Jzqt/Avl6y3AOAiz2K8ZzbfriIDQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198258;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=lF7OwP7qMctjh4Bb/Y3A/pUbShZLcwfeP8EGSSilShE=;
	b=yoxTN5eYo7hzSRNg8Q3q4QHjb8a2gZOOpoqhXRYbMV1MeoIlLmzmzyeKFP0BrT1JZt40
	 q9O6+zCIypJyf9+zyUe8FxFSVEQnkt+ZEn4W5gTCmdnWtvIIGmCpugyEmJACcNtsSIsgv
	 pc/sMy1iYZXBhW12PS8ztGwhhamRqQlBzLiLLLy2Mv+t8FoFi9b6Ho+eIHTUV51z9+9fm
	 EQ2KHCqTnwZnnPtxDqoLe/JK78q0uBgTIxJsTSwuLHlLQxZH4mHFVfPj2altNVfq2BaGf
	 sXAMtaHby6tdDEHvwbBNwg6THVC2i7YVDfZEx95qs2MUNHNhsxXd+6oADGmTRfwJwRw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifCOLUmo;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBB4160A5BC0;
	Fri, 20 Nov 2026 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ifCOLUmo
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198258;
	b=c3Oik8dJymVtdT7unocgwRLlG8r1YnnQErsBHYn8RQksCO7G8PG2dZq2JyiKmDoJiv5p
	 izkWcERRVYuaWYIHUvbiRcq91+S5/4fvsUtlDAqbD/jwnDpy+V1JPIHXi8mxEwnHaF4GK
	 mN1Ki5sLqquWbZNaSiiVPXG0v4kVj0EjPY7XAiYt1Wd4lGQhUPP9d8aA1B07NxVz/6Upw
	 87iDI/OqyDjsAQM4Dm0m9Qx25lENsYicdMYBT+1PFdRZNTzY0E4Uc/e1bmGO8m9OknM1D
	 OikiwaI7HDasvEqprZfZ0qlzjzTVBqfikT1eQO9w88jy9UNGTyhU7pCCyCOFdlOqzEg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198258;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=lF7OwP7qMctjh4Bb/Y3A/pUbShZLcwfeP8EGSSilShE=;
	b=xRcKL/Ld0UoPHEW90eds1BQEwklfdtKNrdiO3m7DM85UBLgyoEeSmBH8XeuCqaaiI+YY
	 s1oJdh9DM/dR9Pek60J+adlNkhblWdbeajo2XP7osIlvvgknohx060MH2K2fD33k80l95
	 Au1sPeKiQB/kxUMtCld7TqMxXCey/I7Zzgt1z75CJzyb848M3TzbCQV3BsrxGzG1mwNkP
	 mNvGnYtIRz17Z0uGiE+XakyVf+8fj25zySUbnfcSjsISCktkLjX1QvY1GdNPuqUZXPXJL
	 pSBTc1Af5gURNivbj/Q1ACa/jvohIAC1u3UbZrC9TCccxk8DsQatZDslrBlskM+RB8Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3566E1F0156B;
	Fri, 20 Nov 2026 18:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198258;
	bh=lF7OwP7qMctjh4Bb/Y3A/pUbShZLcwfeP8EGSSilShE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ifCOLUmov8u7tApw218R6ThuN29QVicMopVGZVBYstFzmxHU5spmv1XX2nTwACAdX
	 O/y929lQfIHHbnh0N1+Sktc+7dpdccKVYlce5eH1cOfGSFfBJyyhgwd1qtGWuTiB/q
	 +UPbYLjUzn3tFInS4/XiGpnZZzhzd0M5WXYg/GNuN4ZJySc1O/78JoszES6m+jjTAO
	 645ATe+fUWyXJ4w2QRmdwHNklcZ8VnKeiqUUrZxSOUeiujxrQIqSnvLKsDCRMAMORa
	 6e2bDjjuOaYOaqZDIknk/xB++xACNoDMVdp1sNld4PS5JoA9eMyfqHYEnDb4C/ONMK
	 5BPCfTmck2nEA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B84654B95D;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:30 -0500
Subject: [PATCH 39/60] mm/page_alloc: add a private-node zonelist
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
Message-Id: <20261120-private_nodes_v6-v1-39-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=3134;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=OqpMdBUt5im1cMgZFE5X+fZAbGJWYU6WcOHKkFwuS9o=;
 b=o/dYXsRSD+kDIMnUJjWNiDdysIiPZ9AEs4oJxtAad9XJMPtLlNyz+nTDlkBw/SrIIzFQ8NEmg
 Q5LoNu0vSTqCQh8ZHl/nPuFBHXZVGMqF4GQxX08YQa6pADhhTLCJq4v
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

A private node carries N_MEMORY without N_MEMORY_COMMON, so the FALLBACK
and NOFALLBACK zonelists already exclude it. That leaves no zonelist
that can reach it.

Add ZONELIST_PRIVATE, which holds a node's local zones only if the node
is private. Common nodes have an empty private zonelist.

Like the existing zonelists, it is sized for every zone of every node.
That adds a zoneref (16 bytes on 64-bit) per possible zone, MAX_NUMNODES
* MAX_NR_ZONES, to each pgdat. A smaller local-only zonelist type can be
a follow-up if this matters.

When the zonelist becomes selectable, __GFP_THISNODE will still suppress
OOM, while the page allocator selects the private zonelist instead of
NOFALLBACK.

If a user grows requiring fallback behavior to COMMON nodes when the
private node is out of memory, we can consider adding a fallback
variant - but for now private node allocations use a local-only
zonelist to limit complexity.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 include/linux/mmzone.h | 5 +++--
 mm/mm_init.c           | 5 +++--
 mm/page_alloc.c        | 2 ++
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index d6c1a43c0bc8..05f212b56c9d 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1402,10 +1402,11 @@ enum {
 	ZONELIST_FALLBACK,	/* zonelist with fallback */
 #ifdef CONFIG_NUMA
 	/*
-	 * The NUMA zonelists are doubled because we need zonelists that
-	 * restrict the allocations to a single node for __GFP_THISNODE.
+	 * NUMA nodes also have local-only zonelists that restrict allocations
+	 * to a single node, for __GFP_THISNODE and for private-node access.
 	 */
 	ZONELIST_NOFALLBACK,	/* zonelist without fallback (__GFP_THISNODE) */
+	ZONELIST_PRIVATE,	/* local private-node access, no fallback */
 #endif
 	MAX_ZONELISTS
 };
diff --git a/mm/mm_init.c b/mm/mm_init.c
index 99a45fd04ac5..a6ff49043b5c 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -99,7 +99,8 @@ void __init mminit_verify_zonelist(void)
 
 			/* Print information about the zonelist */
 			printk(KERN_DEBUG "mminit::zonelist %s %d:%s = ",
-				listid > 0 ? "thisnode" : "general", nid,
+				listid == 0 ? "general" :
+				listid == 1 ? "thisnode" : "private", nid,
 				zone->name);
 
 			/* Iterate the zonelist */
@@ -2706,7 +2707,7 @@ void __init mm_core_init(void)
 	init_zero_page_pfn();
 
 	/* Initializations relying on SMP setup */
-	BUILD_BUG_ON(MAX_ZONELISTS > 2);
+	BUILD_BUG_ON(MAX_ZONELISTS > 3);
 	build_all_zonelists(NULL);
 	page_alloc_init_cpuhp();
 	alloc_tag_sec_init();
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 08e57f809a03..0bd21916cea1 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6010,6 +6010,8 @@ static void build_zonelists(pg_data_t *pgdat)
 			    ZONELIST_FALLBACK);
 	build_local_zonelist(pgdat, ZONELIST_NOFALLBACK,
 			     node_state(nid, N_MEMORY_COMMON));
+	build_local_zonelist(pgdat, ZONELIST_PRIVATE,
+			     node_state(nid, N_MEMORY_PRIVATE));
 }
 
 #ifdef CONFIG_HAVE_MEMORYLESS_NODES

-- 
2.56.1



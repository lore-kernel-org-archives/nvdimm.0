Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198207;
	b=RN2uS4o+R91XtvU5Es0hiPPyorClkqsRpp7PcihLxNFF2wblCRylFDpLLqdnT61s2L0A
	 J4GqN4+eaF6gPWQWipjVHn0ejab1b1GZtroqVve9qI4JHWYU/h3obvpBD2T5sowqB8ivf
	 63zSqcWZnk/HJHYnfi6QBKt3ceP4ZMUWV2nPIHoOa91h1h3rDdTJtstyv/kyfLmSepUZH
	 4+rhJMMPMOUshGPHnRrZFBFu55fMDgkMeJylLpIwLPB+pbWcEhElNr9VYGUYvJLYJpHis
	 hsEurfhBYZ3Ri6AO8O4fvw8uobvehtLe7mAKRKNmpUEk0A/IAKk+rbvKfkGeXkKEPeQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198207;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/2GT9+cT6aXktwJ+E8xAruZNdnX0GNZG3Q3TOZjuPW8=;
	b=YXUWEKMRYrsfOJRbw9rTfBSu24e1RElgKpjaSsEwknIpipcYS4ONmDC46ob9T554DToh
	 uwG8Qegfi6x7YTYCyNV8f2oM4CFDZ/f2yfzgUwMlPFLp3Htw+2oHJqOTi9TaifwpIr7hr
	 9MJ34yO5jf4Sx/Fiz+ibcWgov4BUQQn0xnLvY2CwcZ1VZIcR/wxsiPNo7Rv+Gp5siWXeh
	 7PVqM48abwPOBauF05vzVJjoqfliEon8ruGeueY/f9VLuIGAeWIXEZVJeBPN2nYCRpx+B
	 yjvBVZOmn87vEMQF6yUR+UeRKfNFyWlFEFMKckXY7ci2ASgvBfnJ3y0EU7k88EiVDKw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X3kX2aRW;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F99760A262B;
	Fri, 20 Nov 2026 18:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=X3kX2aRW
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198207;
	b=DrFtKV+B5VOmawHl8nh/Nf6edLRADW7EvdCwNcYBD6WTNgiwNkYfsvcdxUJzuWp8pdcY
	 SbuLr+xcFU5T1gT/6K3DwEBkQqsGMmmEUwJ3exGaSE2HBYCIFHGa2wYh+P5FMLHjQ5apL
	 RwNybQ/Q7o3CjHT4GVYuRtoWlHTISsbkwTQdiIXBmOAACVmQ8s30b1RLMwFzyKbe9L7Fz
	 oBIf+0a+PglzODLS/xnSLU1syudflLhlr6fU/EngYW3WGEJqP9H/Te9KWWczbJYeTTGLv
	 oPGJOQWxuvxdn1UP76X5foFMzBuj0rv+zH3FxVUsY42P4GtdTg8GpXK65S9e00gnIvA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198207;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=/2GT9+cT6aXktwJ+E8xAruZNdnX0GNZG3Q3TOZjuPW8=;
	b=iU7p/dSq3N3mU299fPDL2JVsHo0Nn7T7hcEYS/1cWtTwXtHHd4S4jTNSC99zdlzVh0yj
	 q9IhjT0+KGjW/thzyQQOSvvfI1vOnrJ9VMJeUkg/emG3jL45C6Ff5ndYwCK9r9yINVgib
	 zHx1Zasq5wDt/05aBtUgjeWTMgt10gS2/WAWnvATrSM5HCtYrauYMEeQ2hVZ11LtPgd2X
	 JrfhlCmASEMRyIcZYsgYzD134QIMhYFHjgkgoI2aJZhfsz6y0jLBJKFocSJ1SqieMW2nW
	 bvEBmCh2grmFXmtWnNfzcq3S8iLLyerrKBuAXFKHp+1/P0U7XEjfw7IfPDBJhEiaLvw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B7FFE1F01803;
	Fri, 20 Nov 2026 18:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198207;
	bh=/2GT9+cT6aXktwJ+E8xAruZNdnX0GNZG3Q3TOZjuPW8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=X3kX2aRWgVtrSH8Vxt7BvKZE1Wu7jU2PNp1+FDyOt5BNEeDYqFqkzDYcMJ3jQ7yao
	 wocgNQe2UkCi85bpmoUkzqmBzaG/X6YyM5S89NrG3QFyXZmEROMHu4ScCz0v3DUGIK
	 32BpzVsVSYv/McXtYkHBuWXve+1ms7/juDTnVigkW5a84B6SMAhQlqy+VwJ4/kFaHn
	 nQahRByeoWfCOyOeFP0inmaQUyBfqI+U/2a57CwLfxmG2g2yFqaXroUGUt/byHAu1m
	 Ks5krxmg5gwMB356wisbx5GTPkY4ma/5UTiOgJzi/zQtnpXVWhqfJEPF/6h6/HG8ad
	 QoeaTPRy2QPvg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BF35F4B8FD;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:06 -0500
Subject: [PATCH 15/60] mm/page_alloc: count common memory nodes for kswapd
 recovery
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
Message-Id: <20261120-private_nodes_v6-v1-15-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=954;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=aFOBkE3dz1xwSTmNPK2kJnfdjjcB92u911EXeeybS5k=;
 b=miZr9gvtGaEB+gbuRcJGykPJI+d+lB6tSrF2muK1MI3mjI5Sn4TSITCLQ17YsndpWzcCDgzxv
 qw/A7tFHGb3BeDl3swCP0HsgD2rlRnitjHD2V8ZURSMeMu3SzxBJkCC
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

When a zone recovers above its high watermark, free_frozen_page_commit()
clears a hopeless kswapd state if more than one memory node exists,
since allocations could then have fallen back to another node without
triggering direct reclaim here.

Only common memory provide fallbacks, so count N_MEMORY_COMMON nodes.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0448d04e048a..1ec7d8000792 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2958,7 +2958,7 @@ static bool free_frozen_page_commit(struct zone *zone,
 		 * kswapd work again by resetting kswapd_failures.
 		 */
 		if (kswapd_test_hopeless(pgdat) &&
-		    num_node_state(N_MEMORY) > 1)
+		    num_node_state(N_MEMORY_COMMON) > 1)
 			kswapd_clear_hopeless(pgdat, KSWAPD_CLEAR_HOPELESS_PCP);
 	}
 	return ret;

-- 
2.56.1



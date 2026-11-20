Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198226;
	b=3RLbdT2gX30GohmjADtLEe8Tmdf5MtoeDSNJkF8BPnm1Y4r7gmm0bc0vMnR+3i99EsHB
	 jZ7MBcFy+HWIfJmpsifTWFhsGsNV5SoL7p0/dZXbpBdZBfcM2hw15f4GrdyFBUKOGL9dO
	 ZtwZantb/lK84G2odpBsowhUMT+tHVYoEHLMvVF/yV5UN8KMibPiFvzFowQq15F5HeDar
	 1/9IkA2sfcbgMzB2Xj2+nRaXF1qOCHQjSlYbQacr+osh1aBHPaXgDvhsDL8oUoojGmP78
	 jM2sZVnFfzP2x7yVEe6hF/4BWd52qPgrT7r1cUNy+cFKRB+C3Mf3TzKBceIQs0sIkoA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198226;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gyynVGeIcWRdH7dEMKcuI5jkcGEqh5D8H+zcb4PS70c=;
	b=FHsVVjUblJeBgTqteJkI6LdnjQgXlmritrGSfASODHtSr9f7dhwD9qJAQy7pVuyLSC6o
	 JYh/d/83oMmYNg3Z2rOwcChruZmMIpKten2jgrZHQnKxzQB1PTTLYpcdkciFjX1AS091H
	 PxNg2kfVrYWgcSujTQ3KG/t9k+UjWH+houyjIpmGSqzgvxR07oMPF93jDcDJYFlvLDs4z
	 8DRLX6RMghDfeZhuEzWqLDQFuJY/6IcvkMfMoId6v5cDTLClX93eokj4iaLvP/1/X9Hb6
	 9M/PKJ3QFcrIAfllXofLUXe3QwtCA74MHX60C05WAadSxFC5AwvpvjpRqyMoUqF2L8w==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mdt3DdVE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C112160A6F66;
	Fri, 20 Nov 2026 18:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mdt3DdVE
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198226;
	b=nP2xQorar+PU7FJ1JWjq+IYddD9f7mTKePbLa9Vt/uG9Lz8b4R0ntLXqYqT64PyoeX1Y
	 O1Dvw+PfsUYBnFyrVkCF6cSkm2XsRQBfz/kL9Vtqv4nJRMt2rXg0WPV1Q/gsrRa2SS1Dm
	 IsKDqf6FXO9GuMX8ytypJ02k3EMmFpuKTTkUN4qPleZpcrwMDZ5srXjOD7RgbPYhvcbiN
	 fynoqbPDgGO9/FqOCXhEB54BsVnItJ/sYH3Eefu3zLEgCx+6aWoPo0nnK+iBzesp8FUKj
	 FwnG19r0IMQw9X2BffgunfEZ8gVNE/P6ozx18AYRQPODVd09Cno+LkSDx7+NP/ljc6g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198226;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gyynVGeIcWRdH7dEMKcuI5jkcGEqh5D8H+zcb4PS70c=;
	b=jRKkPkzQ0QGqz4/j/BWz0S+OokMJk9OAqvFVKlyF0Lw1xbsBPOZvi7rQkWFLUa8hvV0M
	 liIaXgTd+OEGRXuDrYI6eAUNvnlf4tE3n3+ANGsGmovR0LUnrYavt+r/+1EkulGds9cGm
	 uLKpsc1Zg47NAg5wSoEIzG1RC5n8e/uEB2PqFF3EgDFXkGMoxwx7XqLqZbEdk5D9jumD8
	 OZvc9AlecQhF8XP7DKY6Pb02I7kA3Hrj8ouOkcJNS+RqahIKj7DOBlm9BqCRV5grkdrha
	 mN6L730W2n3xxzF+HnVfVGJszKiJOgxo0D7swu/UXGoKaAcfTQatu1VDZwQZ23wfdGA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 33D991F000C0;
	Fri, 20 Nov 2026 18:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198226;
	bh=gyynVGeIcWRdH7dEMKcuI5jkcGEqh5D8H+zcb4PS70c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=mdt3DdVECsAE6UC2Od0bqY75jbMaXlxESRSAF9lt9y1JXq+LgBDK41M9/zvzCGegW
	 811vfCQbikg78hVn+Qwl3m3GfTFE9njYlB9DVz4mrFiG8KNqkDgAk04WnUTcTpg/6O
	 OaTp58TCVY1SUiuAtWT7hh+rNuv/ps86OEgZfGR7o0b+KIB89AveFQUDMmnAzGsh6J
	 OEF/uDG+3R8CPZjIfi5tcmHu/VyyMI88sperpG4N5QxAYUj7dfOiIVRxthy+0R38SZ
	 ZP1YgfDlYvLE91crdG4YfYZZOvJPIEdEXfrNOHvNJTNdAI0ulCchyUzISA7vo2ZwR3
	 znbKdKFVj4ZBA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A11FE4B919;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:13 -0500
Subject: [PATCH 22/60] mm/mempolicy: don't NUMA-hint folios outside common
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
Message-Id: <20261120-private_nodes_v6-v1-22-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1010;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=Rhr+Cx2NDBYMgcDa4ebUGsHqlXBNnSG2bWe3JHhepuQ=;
 b=ztKZ8u2V96CzaJYP7HKnggJC7tb4ZoFzeBT1/Q9GgCywxA/2Apy1CnRFyXdEQXCHyVKOHaZex
 T6+2pAVT40UB5Xf3cmWhN94+0VSejEoU51w1IEohEcPTRwSaWPP7iUa
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

The NUMA balancing scanner installs PROT_NONE only on folios that
balancing may migrate.

folio_can_map_prot_numa() already skips ZONE_DEVICE folios. Skip folios
outside the common memory pool (N_MEMORY_COMMON) as well. Do not inject
hint faults on those folios or migrate them.

Convert the zone_device check to a common memory check (which includes
the zone device check explicitly).

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 806577e1d48b..07d577aca78c 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -863,7 +863,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 {
 	int nid;
 
-	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+	if (!folio || !folio_is_common_memory(folio) || folio_test_ksm(folio))
 		return false;
 
 	/* Also skip shared copy-on-write folios */

-- 
2.56.1



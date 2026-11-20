Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795198248;
	b=dh3yFLSV9vzpFL7IqSZ8BLQFW+D//f2nfWThWv0NwZJK9KQYXeIW5JGHzy/zVvwfaHE1
	 KqCfBRs3piZjfy/aap+G2qdvtGpW0yPRf6vqVecPRTNoW/rAtsy/0TyQI8/k4TYNHH7Ov
	 7GjD+2zZV4qvIzoHDlhsBtqyBxR33GAdMxTHIWVZ8xNE57gk6mlhZk9JpG9vpaI8VCZmR
	 cv32fUUjVkmvMEaMr423q+e0RcT3dH6oNx8ewLQAOZn8oaNP16xewxy9PIvBOVJVvMzVF
	 Dh3zrKa6CHwtyjeZnXA3yX0wUu0o5fnirSGAA9rOYQRZ2ln5QDroKg1hQs6uo7XNcNw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795198248;
	h=Received:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=//A0ClXqbe5TAeGYqOmmHsYsvO6bLrdcF/vlfAMBu7E=;
	b=ejDG/kL53YOEvZsjdGgtUNuos7LV1MWuMjCPapkPkTI7h8GNww+91ZV3BxWn9nRmuRL8
	 whtR4C1tzlOZAjGD/fVQabNrNnMg5XG17pS0i8X/BOPth8vsfgxXCjzVeHKYKtKzT98Or
	 AJ/jBWHRFKWR+fvypB6aluXRUOs7u9noX5bIREDg2vw9Pf4icGkxpDmtTVY94GFCC7Cvg
	 ClKgGPKFlJo8qU/zGfYEBoGRFgbsPl+kR5jcdWG+f2EshH7P3YH2nAaPenFq3EhSWkWl0
	 Xr7T4T9ovi0CgJmy9YMZaMA4E3oGmbZ2x3dwRBA1pjQlfNf4hNSNKPLX8NJbLcH74XA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3T3hunH;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C8D606D4A1;
	Fri, 20 Nov 2026 18:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h3T3hunH
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198248;
	b=LtKnEQsAvaEMuxdMZBuI7pqwitQaCD/GDdZUJhDBTsFZ06uQqI5wx0Ct9vN9NW5y5oi1
	 Z50QlVLAT6fY3Hc3i3F/WsayavAguLOXEBiL756cLqIvbXoN7MRNGkVB86XW7Ten8QPMQ
	 oMpuEsqetvwEYpCHJ6v1LwVeMDYhYhO6qL/wlyPteftaim91o23xE9k1IKB1sCvm7IK00
	 Uj7DY0RkKXehDOv8pkHseZb3FpmCS/V6aIymsmv+cMYQ0jBv+lM0COU3Lff77lTVAKYJK
	 zCZ2rkLkwhZXOBDaPREYBdTJYqXlcnX77mmh8MdVIju415qyXSZbG+kwQBLGure8YXA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198248;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=//A0ClXqbe5TAeGYqOmmHsYsvO6bLrdcF/vlfAMBu7E=;
	b=RUlhfjWMQRylwkg4hZK9S3zmmFWyKN+FOc6JbZWxVPkNpDiliGqZLed9P3xXXpbrJLcz
	 tDIB1WQAW5qxhXS71Be3ME7hBy1bgHbEZ/UfnZFUBkswvuLEbCN9si4iHPlHW3h0lq5oy
	 1dsYZNICdR5yZyEuwA1jbh/2V7JSX8qd26HRTPt76ZY4JLGqGDt6LHBP2yhUCCt5pniA3
	 HPMJ/CrDDkmxhlRrvKFAgdBjDvbo3p2f+IDi7iTk3sh6uy39hnOX2O8Q10mE3aG1Um9/2
	 dQ7Rk82p8aRm7/JxDdnrHB9TfZaC1Z/bQnf/nMKceodOD+fzYVfju6H7GzvVIV/ZPsg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7BEBB1F00A03;
	Fri, 20 Nov 2026 18:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198247;
	bh=//A0ClXqbe5TAeGYqOmmHsYsvO6bLrdcF/vlfAMBu7E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=h3T3hunHJdWAisf7DSzPB0PEMAn83bxnMGcbSxEVDtA/eMVfimtTKS75UYE01K2q+
	 q6rs5kEtcM8BQ/MT5oLa4PQEB9RdENUSk0T+m4su3kaxJ3XB4YkA16ZRbI1T560VTq
	 SZJFz4YPE9uhDVM3/3z8Vl63SAhQGOExocyAnDsd4afNh6VzU0thdOA8N7BKKx3RLS
	 RVy/NcRyZY2tE6+uzjcg7w442z31JGWbZwemKLiGjFtRbXcRXLaFh2d2Z+lMn7bxA2
	 /U1+uGSWYehoXdmF3l85GwcQHc08HH9hxrX6qxhwN5RK874OtWxBwkdnZAT/cjVRbk
	 eOcq5ofGltCkQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 1FEDB4B949;
	Fri, 20 Nov 2026 18:09:21 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:25 -0500
Subject: [PATCH 34/60] mm/mempolicy: don't rebind policies onto private
 nodes
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
Message-Id: <20261120-private_nodes_v6-v1-34-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=3916;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=O4sFHAoLYcMEsR+pbprmEIIYrOpT4VdUvGorp6JE4oo=;
 b=++1ya54kNulohMUVhkDNAIgSodP5iBDwFFCmWjVnOGU1NsRveo/lx1Jce0OpvaUnLUmZ7pT/r
 w52A5nrqjOZA3Cb2wKDaNK6almrCmCp5wMfSWBDh7BzHHpTEwgkoGoQ
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit

From: "Gregory Price (Meta)" <gourry@gourry.net>

A cpuset can allow private nodes, and rebinding a policy to a new cpuset
mask can move its nodes onto them:
  - a static policy reapplies the raw user mask.
  - relative and remapped policies follow node positions in the cpuset
    mask.

Ordinary policies cannot use private nodes.

Rebind policies over the cpuset's nodes other than private ones, and
record the remap base the same way, so adding or removing a private node
moves no policy.

Cpusets keep common memory in every effective mask, so a mask with no
node left is a bug. Warn, and keep the whole mask rather than leave the
policy empty.

On systems without a private node, rebinding is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 42 ++++++++++++++++++++++++++++++------------
 1 file changed, 30 insertions(+), 12 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e208018499d6..81ccc481cea1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -418,6 +418,18 @@ static int mpol_new_preferred(struct mempolicy *pol, const nodemask_t *nodes)
 	return 0;
 }
 
+/*
+ * Policies are rebound over the cpuset's nodes other than private ones. A node
+ * removed since the remap base was recorded keeps its position.
+ */
+static void mpol_rebindable_mems(nodemask_t *dst, const nodemask_t *nodes)
+{
+	nodes_andnot(*dst, *nodes, node_states[N_MEMORY_PRIVATE]);
+	/* Cpusets keep common memory in every effective mask. */
+	if (WARN_ON_ONCE(nodes_empty(*dst)))
+		*dst = *nodes;
+}
+
 /*
  * mpol_set_nodemask is called after mpol_new() to set up the nodemask, if
  * any, for the new policy.  mpol_new() has already validated the nodes
@@ -453,7 +465,8 @@ static int mpol_set_nodemask(struct mempolicy *pol,
 	if (mpol_store_user_nodemask(pol))
 		pol->w.user_nodemask = *nodes;
 	else
-		pol->w.cpuset_mems_allowed = cpuset_current_mems_allowed;
+		mpol_rebindable_mems(&pol->w.cpuset_mems_allowed,
+				     &cpuset_current_mems_allowed);
 
 	ret = mpol_ops[pol->mode].create(pol, &nsc->mask2);
 	return ret;
@@ -528,20 +541,22 @@ static void mpol_rebind_default(struct mempolicy *pol, const nodemask_t *nodes)
 
 static void mpol_rebind_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
 {
-	nodemask_t tmp;
+	nodemask_t tmp, allowed;
+
+	mpol_rebindable_mems(&allowed, nodes);
 
-	if (pol->flags & MPOL_F_STATIC_NODES)
-		nodes_and(tmp, pol->w.user_nodemask, *nodes);
-	else if (pol->flags & MPOL_F_RELATIVE_NODES)
-		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, nodes);
-	else {
+	if (pol->flags & MPOL_F_STATIC_NODES) {
+		nodes_and(tmp, pol->w.user_nodemask, allowed);
+	} else if (pol->flags & MPOL_F_RELATIVE_NODES) {
+		mpol_relative_nodemask(&tmp, &pol->w.user_nodemask, &allowed);
+	} else {
 		nodes_remap(tmp, pol->nodes, pol->w.cpuset_mems_allowed,
-								*nodes);
-		pol->w.cpuset_mems_allowed = *nodes;
+			    allowed);
+		pol->w.cpuset_mems_allowed = allowed;
 	}
 
 	if (nodes_empty(tmp))
-		tmp = *nodes;
+		tmp = allowed;
 
 	pol->nodes = tmp;
 }
@@ -549,7 +564,7 @@ static void mpol_rebind_nodemask(struct mempolicy *pol, const nodemask_t *nodes)
 static void mpol_rebind_preferred(struct mempolicy *pol,
 						const nodemask_t *nodes)
 {
-	pol->w.cpuset_mems_allowed = *nodes;
+	mpol_rebindable_mems(&pol->w.cpuset_mems_allowed, nodes);
 }
 
 /*
@@ -561,10 +576,13 @@ static void mpol_rebind_preferred(struct mempolicy *pol,
  */
 static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
 {
+	nodemask_t mems;
+
 	if (!pol || pol->mode == MPOL_LOCAL)
 		return;
+	mpol_rebindable_mems(&mems, newmask);
 	if (!mpol_store_user_nodemask(pol) &&
-	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
+	    nodes_equal(pol->w.cpuset_mems_allowed, mems))
 		return;
 
 	mpol_ops[pol->mode].rebind(pol, newmask);

-- 
2.56.1



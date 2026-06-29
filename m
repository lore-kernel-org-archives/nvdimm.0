Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2BA4028E2;
	Mon, 29 Jun 2026 12:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735857; cv=none; b=On0Uu3fpM9wbxc1Y7wXsi13In/XKH3bZwmcNzQqbTxSrJKVHI+Z5ii9rlE03J0iS0YqQHg9MN7VcW15KEfKy3vZ4KOLM9JHaA8SFu0Q8T6YMIPUlbrxBGlPoJldlc8Fs5f/3PHNEEy3O2HcLFolRtGYPF+MIKjzcDH1D/P2Df5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735857; c=relaxed/simple;
	bh=GDbBsaDu1KdsyJnwerpkgaiyxm5OJhlyBG4rMor3Ub8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lav+u1FP6n18Slmo6IJ1ta2tiycnpTzTBqp+bqbO+2mLFqynlZhzshnqjxbbybcGe4iP0J4YbOfJip1oEDEa4MqeheLuuJN++zN9AEM3PIJ2G3qba7C2wgoDKqfmWVItzh7WT/WYNDem2TUoVbXcu8GL9iH1It9a5mHbt5byYS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lNGV9yN8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lNGV9yN8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2AF71F00A3E;
	Mon, 29 Jun 2026 12:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735856;
	bh=IfYIi3h97Td9h3DBJgVJcf+P8SXVr5wM/GvJvcwStzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lNGV9yN8kBRD132uXCwgnUfErFd07LVxDdYGkBetq1diSTqEUGTMxPgPBUDMnbOlV
	 90h0il5nNqOL1Rwqv03Mf7MyJPILKA/ML+jHiOXakYHRAGB0QOi3CcojnRb3/HsP6b
	 1cfIQidEDYqwdJd8qMvDRR3kfr4dZ6E43KD639b6YBImUkci67dpgoggwfb+fdKz8B
	 oClDM1FA+NiUCX4bnHhmWU6PQwC2QCi9KkZj2cAqyUSXMe6dl1LXYbd15qxry2ghNq
	 hKoqDeMRlFWfzBJr4QkVZghkE9jRZaG/2AAnsf3PEpx66dnpBXR4xuGW73smCOyNUW
	 5X0mB7ocRS6ZQ==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 07/30] mm/rmap: elide unnecessary static inline's in interval_tree.c
Date: Mon, 29 Jun 2026 13:23:18 +0100
Message-ID: <ed5fd5358382217a92f0a6afddcfaa030c933055.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's not necessary to declare these functions static inline as they are
contained within a single compilation unit.

This makes the anonymous interval tree code consistent with the newly
updated file-backed interval tree code.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/interval_tree.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index ff36fd14ef37..b387d39e0547 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -81,19 +81,19 @@ vma_interval_tree_iter_next(struct vm_area_struct *vma,
 
 /* Anonymous interval tree (anon_vma->rb_root) */
 
-static inline unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
+static unsigned long avc_start_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_start_pgoff(avc->vma);
 }
 
-static inline unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
+static unsigned long avc_last_pgoff(struct anon_vma_chain *avc)
 {
 	return vma_last_pgoff(avc->vma);
 }
 
 INTERVAL_TREE_DEFINE(struct anon_vma_chain, rb, unsigned long, rb_subtree_last,
 		     avc_start_pgoff, avc_last_pgoff,
-		     static inline, __anon_vma_interval_tree)
+		     static, __anon_vma_interval_tree)
 
 void anon_vma_interval_tree_insert(struct anon_vma_chain *node,
 				   struct rb_root_cached *root)
-- 
2.54.0


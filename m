Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6987544998C;
	Fri, 10 Jul 2026 20:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783714977; cv=none; b=D0+WY/rbAeduXB1e1yCNmrRd31RuVYnrOnitUQ7rYimdRwkw/5Gyd/kNzGiFxZ/4YDiCAlhR6GQUZjvpxc6WGJfyvNUdvQjTocvhavBO2yT0B/iBnfn9pJ8A17/zLTq5gBdkC7vE/+CGvyTT8R8JTthc8tcv4WcFXgC66/fNDUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783714977; c=relaxed/simple;
	bh=Ckq9F1B5R4ctEUJqWXYT1jV2i9Vim92hn6PkYJsjcDc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QvhB/8j2xglgO6RbQMop7fwUrxcbfK6JuMHyESNHhgZSaSrv0OYjmnMIxj1ePJHB3p6Xed9j/mno9lNMcIMvkEEZT9lQGTWdmMNoEVJDdgATLjCNS9amt4WDKtkYRGdGgDEa4aNlYo7DhPh6U1O1L2hdR+VEGgOnHK3Q7zyiDh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BygF57wD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BygF57wD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C69F1F000E9;
	Fri, 10 Jul 2026 20:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714976;
	bh=g95Hx/jZszTYl/mqKEmmLN3wpFLfcUCiQ7oLxyYPtwI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BygF57wD+F4oIx2IjGBmXSgdeyH+kDz20QKqfZkY+JeciaIqrpYGeXs92Dhu1bJQg
	 yDrXtWAFvHrGJ01GVLJpGEYigWux3ULkArB6G87U6BG+mND6GeRsCRQIqxn7ZB/Co7
	 WX5bQzX3DHLJV8P5v5PFCfG2UwKM4+ICy3syuuKgzN0aQLrIra+79BjIq5f/isekmS
	 4O/AIhZQ8j5j/Q1gq+aeN84CaAkEZVoCKAwBtKJrHGY5odfGQwzjga9mJoIKacknvz
	 VLOYvIoanmU23sKzVnBYRU2knQpn2FpJ7GQeLdVOWXN6EA1E/tTlccruzKODHlic/F
	 MkoQCxvPMfndg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:55 +0100
Subject: [PATCH v2 14/33] mm/vma: clean up anon_vma_compatible()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-14-2a5aa403d977@kernel.org>
References: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
In-Reply-To: <20260710-b4-pre-scalable-cow-v2-0-2a5aa403d977@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>, 
 Simon Schuster <schuster.simon@siemens-energy.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 Helge Deller <deller@gmx.de>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Dan Williams <djbw@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Xu Xin <xu.xin16@zte.com.cn>, 
 Chengming Zhou <chengming.zhou@linux.dev>, SJ Park <sj@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Hugh Dickins <hughd@google.com>, 
 Peter Xu <peterx@redhat.com>, Kees Cook <kees@kernel.org>, 
 Marek Szyprowski <m.szyprowski@samsung.com>, 
 Robin Murphy <robin.murphy@arm.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, 
 Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Steven Rostedt <rostedt@goodmis.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jarkko Sakkinen <jarkko@kernel.org>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Thomas Gleixner <tglx@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Ian Abbott <abbotti@mev.co.uk>, 
 H Hartley Sweeten <hsweeten@visionengravers.com>, 
 Lucas Stach <l.stach@pengutronix.de>, 
 Christian Gmeiner <christian.gmeiner@gmail.com>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>, 
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, 
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, 
 Rob Clark <robin.clark@oss.qualcomm.com>, 
 Dmitry Baryshkov <lumag@kernel.org>, 
 Abhinav Kumar <abhinav.kumar@linux.dev>, 
 Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>, 
 Marijn Suijten <marijn.suijten@somainline.org>, 
 Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>, 
 Thierry Reding <thierry.reding@kernel.org>, 
 Mikko Perttunen <mperttunen@nvidia.com>, 
 Jonathan Hunter <jonathanh@nvidia.com>, 
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>, 
 Matthew Auld <matthew.auld@intel.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Yishai Hadas <yishaih@nvidia.com>, 
 Shameer Kolothum <skolothumtho@nvidia.com>, 
 Kevin Tian <kevin.tian@intel.com>, Ankit Agrawal <ankita@nvidia.com>, 
 Alex Williamson <alex@shazbot.org>, Paolo Bonzini <pbonzini@redhat.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-parisc@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev, 
 iommu@lists.linux.dev, kasan-dev@googlegroups.com, 
 linux-sgx@vger.kernel.org, etnaviv@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, linux-arm-msm@vger.kernel.org, 
 freedreno@lists.freedesktop.org, linux-tegra@vger.kernel.org, 
 kvm@vger.kernel.org, Russell King <linux+etnaviv@armlinux.org.uk>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1642; i=ljs@kernel.org;
 h=from:subject:message-id; bh=Ckq9F1B5R4ctEUJqWXYT1jV2i9Vim92hn6PkYJsjcDc=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg20UN7HtLM/vyXsTFrxVYsWpHDm18w4P5+XM12s5+
 WWHrvf0jlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenANzkqYwMU33rlv+/mL9e+HWT
 WHxes/ljhqb8yMyVr44wrbuqccd5DcNfmT/8Ns92pKWUmxwKXbLj7ZqLidpWFw45HF1j+zc0qX0
 fGwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Break up the existing very large conditional, add comments and use
vma_[start/end]_pgoff() to make clearer what we're doing here.

No functional change intended.

Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 995de8198fbb..084afdf37385 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1967,14 +1967,25 @@ static int anon_vma_compatible(struct vm_area_struct *a, struct vm_area_struct *
 {
 	vma_flags_t diff = vma_flags_diff_pair(&a->flags, &b->flags);
 
+	/* Ignore flags that mprotect() can change. */
 	vma_flags_clear_mask(&diff, VMA_ACCESS_FLAGS);
+	/* Ignore flags that do not impact merging. */
 	vma_flags_clear_mask(&diff, VMA_IGNORE_MERGE_FLAGS);
 
-	return a->vm_end == b->vm_start &&
-		mpol_equal(vma_policy(a), vma_policy(b)) &&
-		a->vm_file == b->vm_file &&
-		vma_flags_empty(&diff) &&
-		b->vm_pgoff == a->vm_pgoff + ((b->vm_start - a->vm_start) >> PAGE_SHIFT);
+	/* Must be adjacent. */
+	if (a->vm_end != b->vm_start)
+		return false;
+	/* Must have matching policy. */
+	if (!mpol_equal(vma_policy(a), vma_policy(b)))
+		return false;
+	/* Must both be anon or map the same file (MAP_PRIVATE case). */
+	if (a->vm_file != b->vm_file)
+		return false;
+	/* Flags must be equivalent modulo mprotect(). */
+	if (!vma_flags_empty(&diff))
+		return false;
+	/* Page offset must align. */
+	return vma_end_pgoff(a) == vma_start_pgoff(b);
 }
 
 /*

-- 
2.55.0


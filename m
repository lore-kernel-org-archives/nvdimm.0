Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3476408627;
	Mon, 29 Jun 2026 12:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735872; cv=none; b=UHoLJ+KN2HnzWoPVXTcGLkk5N/c9D2ChUiqwtnnlnwcwd286n3w9PTA6UF7P/xNMR3hLaJYn+PeWMJXceLkS8AgH1dnIGMN9vysoSVOcRybMoudH45D26to+ECNJDlSjEdA/vbNvCGjpebhhOGD7mExQWcFvi7jD+pKiWyzAIqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735872; c=relaxed/simple;
	bh=tlohIfU/GkJ0Rl/MxN6Kwa79ovpFTOB5ftLX3CCYYEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQeiciKlRFOOjchpRO/A6w7GUIyh9twY4ZVDSz9/4RQLT4cgOtVJI/CRfNRG34XTcQpzTwPjPfgO7STstkxE/Cozg0lCsLvoZxtfEsfM2qjUuklRH5qpZX76EzbNBm2ABgEY4aFY8GlDZASKP5FbXeP9DSQhpuaKRzs0QT2/rvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gbRlBt02; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gbRlBt02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55091F00A3A;
	Mon, 29 Jun 2026 12:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735871;
	bh=lDqHHLYLI8SULeQcrQbbmm1Xqv4SbCojm3yMjIkoYS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gbRlBt02eZV32vXAx1N9ysOeq0S6bwI9Ce2BPgKuRfpVZlRZdgJ+Rc9bshTzbaA/Y
	 W14Sww3HyjEdedsUcYMcpQ9oUG/ausaLK7qwWO/ObfDuCVFHpJi681zlmHI1oY44qw
	 JuYWfnS14KRRMRCqN6X7rVTIgwoB+b+Q7CFljrLUmX4CHXFe+lXtsfDfiR+NpSZg/6
	 VFAgvA186XL/RNO5OBNYDw+9qoiTSPd1SJA4VjVv6xPifTqqwKvmIhr/L00cadwwD/
	 Av7DzDW/ixy/Z1oRx3ExXlGkJB1de3WNQx1EoGzP7SZH1bGKaVpj5CUFZ1WpGLIrVF
	 Z+35Yut2os7Xw==
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
Subject: [PATCH 12/30] mm/vma: clean up anon_vma_compatible()
Date: Mon, 29 Jun 2026 13:23:23 +0100
Message-ID: <5a7a07bd2a774989849b0fea84f758059ed914df.1782735110.git.ljs@kernel.org>
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

Break up the existing very large conditional, add comments and use
vma_[start/end]_pgoff() to make clearer what we're doing here.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b60375c6c5c3..6296acecf3b7 100644
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
2.54.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 937BC416CF8;
	Mon, 29 Jun 2026 12:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735908; cv=none; b=WkBYVdx6f8uOcMFgLjCQECW5jfAYIn/iv+PEtOCjZIYDz9FNorqg3wiKMF28Gyw0z0eq1rX/ZccBefBEg2I9+VeB2LxxmzCQV6xPvLTdW3roDbQrJ86zb5u+Ppb+eTc0FwP3PBCQpCyCeU6Gp/LGtE5sXcuAfIEAbI073bkgDaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735908; c=relaxed/simple;
	bh=RJx5g8rLNscyrx3rFT2JAFZ4aFH3k1R4dKVCoBl1nZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hfo3wOcJ/WPHHl9R4R8bYji3YmwEGUBQX7d8eMGoj1+AZzvsTVxktll3cxS8wbFnT75GWK8qBSfVdBmiAGf2RccaN7i9NA4im9das5MMcyekHgAEDeDI2n69V+ZnBxPE7KylavQwl8pBhlGMJS9r2VOLqyD+fqroSzLcmWJjDJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bnntvhK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bnntvhK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F341F000E9;
	Mon, 29 Jun 2026 12:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735907;
	bh=0CjsnJnmQmj9IcNR2M+P2PS6Ynd1JhNZAhWBlobX7To=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bnntvhK1Es0+AkZqUSlbageegNulQJjLp/pioGFK3HrXqebdDfvRyS5gYUI5JNuMu
	 CzpOMeomCvL20HZs4AB8qKq9Rkd8Xnw/UkVsvEcYerjCdZ10IbfN+amr4Btx1F3uxF
	 vb3+OJz87qYyu/mgNdIgl9NXt/f6YQ0fr4F6F03VSjSNdr/ehZtAgsdXjHPRiBJrhL
	 qmOSdwVCpukHHewqOVzri4bkytdwJM4r963lR9F29kjWSZZ0bbUkBZ6ZsaQLOHSeat
	 mny8L2AgBdSeOjUAetGhVhd8VyhCyF4qpd4m+IakZlvSeQnjjZmUJjHLkSlwZ0+C2I
	 OZbTP3l9yLkQw==
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
Subject: [PATCH 24/30] mm/vma: update vma_shrink() to not pass unnecessary pgoff parameter
Date: Mon, 29 Jun 2026 13:23:35 +0100
Message-ID: <6dd744d57d778f94d2fef8fd623d7c4ed8010d93.1782735110.git.ljs@kernel.org>
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

vma_shrink() does not need to adjust vma->vm_pgoff, we were passing this
parameter solely to satisfy vma_set_range()'s requirement for pgoff being
specified.

Since vma_set_range() is now isolated to vma.c, we can simply introduce
__vma_set_range() which sets only vma->vm_[start, end], and invoke this
instead, removing pgoff from vma_shrink() altogether.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c                        | 14 ++++++++++----
 mm/vma.h                        |  2 +-
 mm/vma_exec.c                   |  2 +-
 tools/testing/vma/tests/merge.c |  2 +-
 4 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index b16c5b20862f..e3355eab11f2 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -70,11 +70,17 @@ struct mmap_state {
 		.state = VMA_MERGE_START,				\
 	}
 
-static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
-			  unsigned long end, pgoff_t pgoff)
+static void __vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			    unsigned long end)
 {
 	vma->vm_start = start;
 	vma->vm_end = end;
+}
+
+static void vma_set_range(struct vm_area_struct *vma, unsigned long start,
+			  unsigned long end, pgoff_t pgoff)
+{
+	__vma_set_range(vma, start, end);
 	vma->vm_pgoff = pgoff;
 }
 
@@ -1289,7 +1295,7 @@ int vma_expand(struct vma_merge_struct *vmg)
  * Returns: 0 on success, -ENOMEM otherwise
  */
 int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
-	       unsigned long start, unsigned long end, pgoff_t pgoff)
+	       unsigned long start, unsigned long end)
 {
 	struct vma_prepare vp;
 
@@ -1310,7 +1316,7 @@ int vma_shrink(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	vma_adjust_trans_huge(vma, start, end, NULL);
 
 	vma_iter_clear(vmi);
-	vma_set_range(vma, start, end, pgoff);
+	__vma_set_range(vma, start, end);
 	vma_complete(&vp, vmi, vma->vm_mm);
 	validate_mm(vma->vm_mm);
 	return 0;
diff --git a/mm/vma.h b/mm/vma.h
index 14f026bf3be4..9658e0c678ad 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -298,7 +298,7 @@ void validate_mm(struct mm_struct *mm);
 __must_check int vma_expand(struct vma_merge_struct *vmg);
 __must_check int vma_shrink(struct vma_iterator *vmi,
 		struct vm_area_struct *vma,
-		unsigned long start, unsigned long end, pgoff_t pgoff);
+		unsigned long start, unsigned long end);
 
 static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
 			struct vm_area_struct *vma, gfp_t gfp)
diff --git a/mm/vma_exec.c b/mm/vma_exec.c
index e3644a3042e2..0107a6e3918c 100644
--- a/mm/vma_exec.c
+++ b/mm/vma_exec.c
@@ -89,7 +89,7 @@ int relocate_vma_down(struct vm_area_struct *vma, unsigned long shift)
 
 	vma_prev(&vmi);
 	/* Shrink the vma to just the new range */
-	return vma_shrink(&vmi, vma, new_start, new_end, vma_start_pgoff(vma));
+	return vma_shrink(&vmi, vma, new_start, new_end);
 }
 
 /*
diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index f8666a755749..04704d6eb426 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -227,7 +227,7 @@ static bool test_simple_shrink(void)
 
 	ASSERT_FALSE(attach_vma(&mm, vma));
 
-	ASSERT_FALSE(vma_shrink(&vmi, vma, 0, 0x1000, 0));
+	ASSERT_FALSE(vma_shrink(&vmi, vma, 0, 0x1000));
 
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
-- 
2.54.0


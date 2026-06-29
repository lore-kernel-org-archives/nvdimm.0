Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 062FE404BD0;
	Mon, 29 Jun 2026 12:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735849; cv=none; b=EVpmqjsu7TdtlTUQjQUFyKxojcS3JSsdLGAIfup/LcjVWZu0hMb6kDu6Kae1Xa9h4DYqfZonZyDAx8t+BGxVYvq3B2uuIFKoi/5NM1QwTZnrRM4au5Kuxw5pDfIz4A/mOQ4Kb8qQhm4XvnE9a44yFCJPJR/DhPBK+g0OKjMIZrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735849; c=relaxed/simple;
	bh=qCrMHTm9PJhjszylBHyfdTWhlU2+b/CXj6IeKAuoN6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=adWKqBkf3zqT+8DIokKqBElBiWXmkR8LlSGVVsueB51X1VsM7jC/ugW4bopVNrVzOQakAfXBefk9MXEemb3ciav7W9xYma24bY4EC9DNBK3AFG2EJ+cBxqw+hCbfxDRj1+F8bRktajWU7oBQFMAUXH5feCs4Hl9DA8pSA7ecZ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a8Gqq6Ha; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a8Gqq6Ha"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA58E1F00A3D;
	Mon, 29 Jun 2026 12:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735847;
	bh=FRH3nWttrO+IvYqL5rFGzJUV29IkkM89vk8rnpYCL2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a8Gqq6HazVpY453qntgYQRg2KTWt8lZ/vexm6YznKPmhVEQVTTAOij1mmS4l/ZwSI
	 tDroo5WMFbOkWde8qHAsbsbaC7BUMYnCytmnbbeZFKhKgmi+P6btImLxdQzbC0kMnf
	 G0sUKWdf8EEgiXRDkPyQ02oipSfAG4yJ5h8dNwgHrKuvhCydec0pyvNNO72DESpGdQ
	 HYc4wXd9paiOXhmo5YiZsNonoT+FRF1LSyZ++LYVPX+wXOC/ssLLGmWweo9y+WI/6/
	 2MV1JSLmt74+aX80ll2fPEpThUkOYwJTEuePiaTIjqNp6YluviVf6MaXBwCziNhmTF
	 +Vp0OVSfIq+lw==
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
Subject: [PATCH 04/30] mm: introduce and use vma_end_pgoff()
Date: Mon, 29 Jun 2026 13:23:15 +0100
Message-ID: <e379a1cb6a897126ad96e3a263fdb91d6c11f6cb.1782735110.git.ljs@kernel.org>
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

We already have vma_last_pgoff() which retrieves the last page offset
within a VMA.

However, code often wishes to span a page offset range, which requires the
exclusive end of this range.

So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
function.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2f00c75e66bd..e7ee315d5ba2 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4298,6 +4298,23 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 	return vma->vm_pgoff;
 }
 
+/**
+ * vma_end_pgoff() - Get the page offset of the exclusive end of @vma
+ * @vma: The VMA whose end page offset is required.
+ *
+ * This returns the exclusive end page offset of @vma, which is useful for
+ * expressing page offset ranges.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The exclusive end page offset of @vma.
+ */
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
 /**
  * vma_last_pgoff() - Get the page offset of the last page in @vma
  * @vma: The VMA whose last page offset is required.
@@ -4311,7 +4328,7 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
  */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
-	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
+	return vma_end_pgoff(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
-- 
2.54.0


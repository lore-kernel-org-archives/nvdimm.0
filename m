Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F371340314D;
	Mon, 29 Jun 2026 12:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735843; cv=none; b=LPcbrJAqGV2v9iaqvIx/drXv4/r/Y2BHxmQeoE0HALuIg2cy2YOAqEFvRmTbV41X1Fl3QcUIRsA+aIlGxMkKwtThurNPOd75YRVw7iLGn6MrlKoBL7AWXhgEFsJowr3Yuyqj0OTxWzfKZmKMMWT9wLjjJD1gMAJeBR4dLHmytFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735843; c=relaxed/simple;
	bh=o52UYnqObCpYmk3JYu6VG+Xb5jANbPrT1TexxoaeOsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ40DO6CIt/4TX91bOzCkchT3DZe/3sNlIQCClXmPgf8QBGjTSsaWi2Dle72c+3QWiFSH9PHWerSlB0L/7gposhM2nQ5COGUVNSNgB0JPNZ0SCcUHaX4lSCdZXRfum5WXrXfT5lNQXL3FeGVj6Kd1Mh6xHITqgj6/A3lLNnCvmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oh8cmU8O; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oh8cmU8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F1D1F00A3E;
	Mon, 29 Jun 2026 12:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735841;
	bh=7qj3/BXq+ERCdoh9SOaphljDHw7CHBVFrg7fKGArfF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oh8cmU8OIg75QXIVeNi2ei1ndGeWnWG9RU2MCpw2g+mWCbfpOy4TThFTXu2AcwGU8
	 a/PR9drmHY0W6+1jhaKUmHIPFs15yos98GDWqelwftfBTj8KpKOyW9r8qcZ9/2wjKA
	 qR1fh6TE2BJqTDqOZrypAuvTCZ8QeIDvaPLudS6E4fCAbhPevd+Mr94Xii/7kdK2v6
	 i1xmlq6thncTopue/ywRunKf211reD3QdYSCHXK1reUhNNmu4gm8eW7YO+Ls232oZj
	 w8FWGZw3/WfuL6IRFRiZ0CCOibPaVbL9f9y5awsCqQVzF12n5a57x1pcYNY0qOSM6N
	 mRwrOyQzknWZw==
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
Subject: [PATCH 02/30] mm: add kdoc comments for vma_start/last_pgoff()
Date: Mon, 29 Jun 2026 13:23:13 +0100
Message-ID: <8c618dfd7de419e3b797b8bd1cd921d4c5b8878b.1782735110.git.ljs@kernel.org>
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

Describe what vma_start_pgoff() and vma_last_pgoff() actually provide in
detail.

This is in order that we can differentiate this between functions that will
be added in a subsequent patch which provide a different page offset.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 059144435729..2f00c75e66bd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4278,11 +4278,37 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
+/**
+ * vma_start_pgoff() - Get the page offset of the start of @vma
+ * @vma: The VMA whose page offset is required.
+ *
+ * If the VMA is file-backed, this is the page offset into the file.
+ *
+ * If the VMA is anonymous, this is the virtual page offset of the start of the
+ * VMA - if unfaulted, then vma->vm_start >> PAGE_SHIFT, if faulted then the
+ * virtual page offset at the time of first fault.
+ *
+ * Note that if @vma is a MAP_PRIVATE file-backed mapping, then this returns the
+ * file offset.
+ *
+ * Returns: The page offset of the start of @vma.
+ */
 static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
 	return vma->vm_pgoff;
 }
 
+/**
+ * vma_last_pgoff() - Get the page offset of the last page in @vma
+ * @vma: The VMA whose last page offset is required.
+ *
+ * This returns the last page offset contained within @vma.
+ *
+ * See the description of vma_start_pgoff() for a description of VMA page
+ * offsets.
+ *
+ * Returns: The last page offset of @vma.
+ */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
 	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
-- 
2.54.0


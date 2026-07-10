Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D226395AC2;
	Fri, 10 Jul 2026 20:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783714746; cv=none; b=dKIyLoiWQKTGtMJNWKsLOy1/X0GqRKlUs0kPpxrNXGJtIG57ORGgBdNGbg8d62fOHyFciW3T5I10U1fhj9SNGLtOt8YgV+Td8Ffg+IaYXpbM65JYeNqAOKXeuuPL27KnONCNUcaSIwH4iSep2vs5UBv1FBMY1Aqc8F8o3E8zxns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783714746; c=relaxed/simple;
	bh=CFZAjloP4OpDX/vjHQ9xfGU3kS1+MIW18Lzf2dxH2BQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ecwEAqf+xTatpjdOlp7PC6G46aBAifhr8nkRr1WvStjMXWH4a1axYMF5MSrunDarmf50lujhjOyF6S85dwR17wVMiNN2OZjB8Arz1nhQLKLp3tW052CYHvV244hVvMuUj2XLrU/uvA5bpWdj1aBblFQAzL89x/nbGNUvyikTVYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PNLB4wzm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PNLB4wzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 322B91F000E9;
	Fri, 10 Jul 2026 20:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783714744;
	bh=5hYSYZL26i46R1YNC969ZGJ/HD8KnaWEcgglVNhE+Dg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PNLB4wzmcFTj3lyqpCjpFNseunRPOUiWwMslZHwgnXN/dz1H6bINuUrT04kt5iEp1
	 +NIb6HuWlNuqv89DVOB740oeyMjE3pCofc2ChzUc2YR4KtFhvnDcCHt+4GCE+gyXWn
	 5N+MnWj5rOmm6UXVmu60Jc6I2MfPK0J7bSg9uQcFU6wtGwwH23rkV+6hwUKmgWbLk+
	 Tctr26pEiWgizGIADOVEl3UfVfSGQDtV+0/95Ja8Pr6D6O/cbPUvsrZRSsYIjPhVRH
	 yBJazCl6C5Rhic0/GCGXO+3WaXAvZ1vidl5uvgn9Xm7ag6HsGdXlfnoynuPxHBZ7uA
	 zki2RHAqu/Mww==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:45 +0100
Subject: [PATCH v2 04/33] mm: introduce and use vma_end_pgoff()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-4-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2641; i=ljs@kernel.org;
 h=from:subject:message-id; bh=CFZAjloP4OpDX/vjHQ9xfGU3kS1+MIW18Lzf2dxH2BQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLICg61qc+aHMPw9/vjPW+ln592Xp0tkZNzkUJwaKjbTT
 FZJejNnRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZy/Q3D/4hbiseXv3Ar8Z5d
 VZLvoZHiXn7OKMDymNMzVtav98Kv2TAy7BE9e6z/xf/4eWp7lK7lvvXZtTcj8M3OVfczJc+uddx
 9iQ8A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

We already have vma_last_pgoff() which retrieves the last page offset
within a VMA.

However, code often wishes to span a page offset range, which requires the
exclusive end of this range.

So provide this in vma_end_pgoff() and update vma_last_pgoff() to use this
function.

Also update the VMA userland tests to reflect the change.

No functional change intended.

Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h              | 19 ++++++++++++++++++-
 tools/testing/vma/include/dup.h |  5 +++++
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index abac72785277..c56ca22d406c 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4331,6 +4331,23 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
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
@@ -4344,7 +4361,7 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
  */
 static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
 {
-	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
+	return vma_end_pgoff(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 668650067c7c..535747d7fee4 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -1306,6 +1306,11 @@ static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 	return vma->vm_pgoff;
 }
 
+static inline pgoff_t vma_end_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma);
+}
+
 static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
 {
 	return file->f_op->mmap_prepare(desc);

-- 
2.55.0


Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CEC399CFD;
	Fri, 10 Jul 2026 20:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783715023; cv=none; b=T7PQhiJ7kFjT9wRmWUeHIngpEW3AAFEIMzCMXdEkgpE7vsJuQHu3smXH+b66+v2xwFzz4tORNgtvJq4WVUXitxwNFEBuPrW0UOnEWoI9fd+72kVfShoBJhWNOPOZiGjqWqJnedqr4FFzGIkO+NyZ1p0CwVIm0KQGDZ3kzBTVgrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783715023; c=relaxed/simple;
	bh=fynty0cOXQIbsI8Im1dMU82VMgwlvpXxQo8CNb014Ng=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=gFd97vgE2HaLZqKCL9xhiRYzJovhY3RTzCYjWy/Prga1YNYpvcZ8H+9Ta93wfXw/M6uemA3/luzSW8T88JcDnTqtAAksd62eC8TCOUqTUo+PcDGn0tObq/+6W1SsNvKrBnzR1jcJ+XXYpI303lUWNah4S5fMlALkyjVEswJzO4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d3dTLtbw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d3dTLtbw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A19E1F000E9;
	Fri, 10 Jul 2026 20:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783715022;
	bh=2aND6ZTrK5aCnF0vB/hvCQzWPNkI/PGqvLHzAGyQuss=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d3dTLtbwHpud6iwAczcr/G9qOssm4UAuvj4AITz+zWpoo3DzOVp4gv/8j/t3INWRl
	 h2iqumoE+G4TsrZXl0JhrXm1DZwp+Xg3/+wksbc2t0H/PLF/RGB/5vKhFzP677NytU
	 q6MV3RVJSQRNxvQnBeZzwMXbXmKkia3AIRewaLGVCnf5X62tPiyvXhyTzEoOmXSEGC
	 7JJiwAJmtNQpNHVWkspiwndBidkwdss3Ra2oN97KJrOwhYLngF5H0St0YiV3hmYCXT
	 mfa+HnPzm/yNr4CqvgKrXrsT0Jsexbb8zALJKBx2Z3Z8c8MYQaM3JxOThN0dU2Lcc2
	 ZnfBU5TdzppUw==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 21:16:57 +0100
Subject: [PATCH v2 16/33] mm/vma: minor cleanup of expand_[upwards,
 downwards]()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-b4-pre-scalable-cow-v2-16-2a5aa403d977@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2119; i=ljs@kernel.org;
 h=from:subject:message-id; bh=fynty0cOXQIbsI8Im1dMU82VMgwlvpXxQo8CNb014Ng=;
 b=kA0DAAoWz53NioHifxQByyZiAGpRUzzIuaLaCaR4CfWWXA/TVMCwmdk5sAWWI2+fuF7yBKZGo
 4h1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmpRUzwACgkQz53NioHifxSSHwEA7mlE
 x52NRnGbJn2diesM85ALQpE3tCi1SqD0qgxp4fkBAMrSm0IQy3xvIXv/5PUxUHYQwVkEyzhhVNm
 YRBxFnqAF
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14

Adjust the stack expansion functions expand_upwards() and
expand_downwards() such that they are expressed in terms of named constant
values, and make use of vma_start_pgoff().

This clearly documents that we are referencing the page offset of the start
of the VMA.

Additionally this cleans up the overflow check in expand_upwards().

No functional change intended.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price <gourry@gourry.net>
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 7265a054cfa3..5d5e60ea8a25 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3216,13 +3216,12 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* Somebody else might have raced and expanded it already */
 	if (address > vma->vm_end) {
-		unsigned long size, grow;
-
-		size = address - vma->vm_start;
-		grow = (address - vma->vm_end) >> PAGE_SHIFT;
+		const unsigned long size = address - vma->vm_start;
+		const unsigned long grow = (address - vma->vm_end) >> PAGE_SHIFT;
+		const pgoff_t pgoff = vma_start_pgoff(vma);
 
 		error = -ENOMEM;
-		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
+		if (pgoff + (size >> PAGE_SHIFT) >= pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
 				if (vma_test(vma, VMA_LOCKED_BIT))
@@ -3295,13 +3294,11 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* Somebody else might have raced and expanded it already */
 	if (address < vma->vm_start) {
-		unsigned long size, grow;
-
-		size = vma->vm_end - address;
-		grow = (vma->vm_start - address) >> PAGE_SHIFT;
+		const unsigned long size = vma->vm_end - address;
+		const unsigned long grow = (vma->vm_start - address) >> PAGE_SHIFT;
 
 		error = -ENOMEM;
-		if (grow <= vma->vm_pgoff) {
+		if (grow <= vma_start_pgoff(vma)) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
 				if (vma_test(vma, VMA_LOCKED_BIT))

-- 
2.55.0


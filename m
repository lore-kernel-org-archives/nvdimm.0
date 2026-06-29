Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9DB41C31C;
	Mon, 29 Jun 2026 12:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735920; cv=none; b=CfhfG10PTXoQkzFn9Ng8GwHZzA0wFTFdgoo0cKY1iIau0zk9vlL5KcKNQr5j7UyzjtCpCXz6bO44fNnkVbr12+sVjDrcXcjkmBmmJ2i6nibLfh9yqzKNFw4VsLCBRir1+K4PfW+Ue5ZpOf0J0lpQoO9Oe625obWt9SgvW/bZu4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735920; c=relaxed/simple;
	bh=u0nsZQuzBuEkyG5AVCQS4ioqkGTOpC7ZvpTtzOMEHP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tc1w0QgRRUtdtvDzwtpxLlGRju+NHSstnklNm1itWqqFpDfT22E1c5LqGm2Ph4RvSV+U/ePZAOsrqocvuZ42WE5YGsg9e3CxMBTe0RpBB+8V3Uh6WnyyHcEmPrrtjOC8c8SoJlxX8o6sAVoHpYsdSYTTo9NDRI0zhXVyqJrCTqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LzaVIJgs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LzaVIJgs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1854A1F000E9;
	Mon, 29 Jun 2026 12:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735918;
	bh=Jss+F81DP/cs0B/Pcj9h2s0BrMlGB7h7WXj2K0PFk1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LzaVIJgsys62G+Y5l1WPaL5KQg6Z9HDAWxSbs7bAkvDQSJaO1VHm9gvWufC4VLmRZ
	 jM7dpVcbVkF0SaP5Ojhs2zhRfm/Pm/c57mYs4zRHf+LvG8Gz2lV5Zd7jFguf/A+Aer
	 MvdUsRxGB7wdbuOShGZQOpB/BZ+xQu0z6RpiPRZlQcVRrODtCGFjFyGztrKJcLuJVT
	 F/kWSDsg+64kaSG4Gtj04lo6i96YLOeVRijxNkFR2Vl4HpUl1qyQJZrEJ1ZttLFyuJ
	 VZzxp13dMEaBPNzJjC3VctdXBDUgzvzJmDPej1MoZQWyEpxYqX6bktXABOszXoE8oJ
	 Ilp56I6Xu/UJQ==
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
Subject: [PATCH 28/30] mm/vma: use guard clauses in can_vma_merge_[before, after]()
Date: Mon, 29 Jun 2026 13:23:39 +0100
Message-ID: <213918ef85ed427d29d0635db6b07b15280d3bb0.1782735110.git.ljs@kernel.org>
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

Rather than combining a bunch of conditionals in a single expression,
simplify by inverting the mergeability requirements into guard clauses.

that is - instead of checking what must be true for the conditions to be
met, instead check the inverse of the requirements and return false if any
are true, defaulting to true.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 5c3062e0e706..7201199fc668 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -215,13 +215,13 @@ static void init_multi_vma_prep(struct vma_prepare *vp,
  */
 static bool can_vma_merge_before(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ true) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ true)) {
-		if (vmg_end_pgoff(vmg) == vma_start_pgoff(vmg->next))
-			return true;
-	}
-
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ true))
+		return false;
+	if (vmg_end_pgoff(vmg) != vma_start_pgoff(vmg->next))
+		return false;
+	return true;
 }
 
 /*
@@ -235,12 +235,13 @@ static bool can_vma_merge_before(struct vma_merge_struct *vmg)
  */
 static bool can_vma_merge_after(struct vma_merge_struct *vmg)
 {
-	if (is_mergeable_vma(vmg, /* merge_next = */ false) &&
-	    is_mergeable_anon_vma(vmg, /* merge_next = */ false)) {
-		if (vma_end_pgoff(vmg->prev) == vmg_start_pgoff(vmg))
-			return true;
-	}
-	return false;
+	if (!is_mergeable_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (!is_mergeable_anon_vma(vmg, /* merge_next = */ false))
+		return false;
+	if (vma_end_pgoff(vmg->prev) != vmg_start_pgoff(vmg))
+		return false;
+	return true;
 }
 
 static void __vma_link_file(struct vm_area_struct *vma,
-- 
2.54.0


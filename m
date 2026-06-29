Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9219402420;
	Mon, 29 Jun 2026 12:23:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735839; cv=none; b=Sk7hpT75w32cC2/+aYoqhJdM6+hD7Ac++mFeCNHjIX47TocllKdtfIZZC/vAJoFY8NhDHQJjz5GRMVPqvkwNNwy8WhMgT/XKUwZJHBllTBszOv6VKlZhdzsZn52J7yQ+Rc6kb2ANSuE4EjmVFq5lPb/s46G2p+cXwv/VUBT++nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735839; c=relaxed/simple;
	bh=OL69J7MtkWT1skHTWtM8dqe2tErstikOFSMrjC+xQt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hh7gM1LLCLIGURtNp4cAHUmTijztxgsEqaW9jHml2ziob5V64z8lZUtA41gvm3JQ72Vx4oyJoE2GTivalgRG6uQbDGBCk0Zvhgwtato2BH14/3VDCyTF8eTn8zegU/8g+v1E6jGuKeyH8nwfav1kp6Vh8C9LwhgdcH7FIJO8pT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMLJ0QC8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMLJ0QC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62E51F000E9;
	Mon, 29 Jun 2026 12:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735838;
	bh=swky/ttPkfzr7S5T51FCZc+wQHBhhjRzTF+CZs6EI2Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BMLJ0QC8vq16id6FWSytyc9WeUIS7JfINQPDzJsgK3lTD2+Pt+YhpaXljUZ46/gWl
	 u4vnladD2OhaGNHvVhsUEKYZgcwpq91WRLMCG9fzRajYPiItxFBM4oxxDAJvoSlXcj
	 AXmP9TLZPDtR6taGzYr9o4/3DefiaTZu0k6kzde+oQchdYnetq1kQBDelY3Tg5Vayt
	 2csO1d2BBpXPMc/dR3xcayC1JQyR8Vp8v4DkrMhux2kOpk30jpyyDfeJ8H3+10kYT3
	 2Wn/cXoyrBgAPy8yfNf7rNJ5A9kAichrnL8ho92XTSW+VMlDBaGxdB9AvyibXTm/72
	 eINA9KxllLbWA==
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
Subject: [PATCH 01/30] mm: move vma_start_pgoff() into mm.h and clean up
Date: Mon, 29 Jun 2026 13:23:12 +0100
Message-ID: <b28b698df4c009e85c4728446ca5863d8e633164.1782735110.git.ljs@kernel.org>
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

vma_last_pgoff() already lives there, so it's a bit odd to keep
vma_start_pgoff() in mm/interval_tree.c. Move them together.

These each return unsigned long, which pgoff_t is typedef'd to. Make this
consistent and have these functions return pgoff_t instead.

Additionally, express vma_last_pgoff() in terms of vma_start_pgoff(), since
we wrap the vma->vm_pgoff access, we may as well use it here.

Also while we're here, const-ify the VMA and cleanup a bit.

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mm.h | 9 +++++++--
 mm/interval_tree.c | 5 -----
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..059144435729 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4278,9 +4278,14 @@ static inline unsigned long vma_pages(const struct vm_area_struct *vma)
 	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
 }
 
-static inline unsigned long vma_last_pgoff(struct vm_area_struct *vma)
+static inline pgoff_t vma_start_pgoff(const struct vm_area_struct *vma)
 {
-	return vma->vm_pgoff + vma_pages(vma) - 1;
+	return vma->vm_pgoff;
+}
+
+static inline pgoff_t vma_last_pgoff(const struct vm_area_struct *vma)
+{
+	return vma_start_pgoff(vma) + vma_pages(vma) - 1;
 }
 
 static inline unsigned long vma_desc_size(const struct vm_area_desc *desc)
diff --git a/mm/interval_tree.c b/mm/interval_tree.c
index 32bcfbfcf15f..344d1f5946c7 100644
--- a/mm/interval_tree.c
+++ b/mm/interval_tree.c
@@ -10,11 +10,6 @@
 #include <linux/rmap.h>
 #include <linux/interval_tree_generic.h>
 
-static inline unsigned long vma_start_pgoff(struct vm_area_struct *v)
-{
-	return v->vm_pgoff;
-}
-
 INTERVAL_TREE_DEFINE(struct vm_area_struct, shared.rb,
 		     unsigned long, shared.rb_subtree_last,
 		     vma_start_pgoff, vma_last_pgoff, /* empty */, vma_interval_tree)
-- 
2.54.0


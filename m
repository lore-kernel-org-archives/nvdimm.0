Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5E3340F8F4;
	Mon, 29 Jun 2026 12:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782735897; cv=none; b=oOZiulbsOuDo/7OAoFTaoO7eY1nD3YqssjPSKN544TCOePw3BdTJ1qSw+jRNouUvYu5FZxe21owFR7F63vH3OYNn+g1SDgDULpf6oGaUy34ynIr6shjINCSkkksWmnqjX4Wn9fW/p2uJnIDVlPVE1yoGeg4KZ19dVd+UoNzyM3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782735897; c=relaxed/simple;
	bh=t4Dqg4wAhRmxu/SFpMe36wsTX3tq8kIQZ9qm/SU91eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iiGL5Rf1KCzXUKFyRqTSdZi4Ey/ylJ9UbDK492wx3tPqcEhxcMWa0qkuOjud4OcpNEFhvIuhBUx/H5v+PBRLsshO8U/XeVV1oDb4DTcxooDfrdbr3taQOJkzdFbOyC8M7Xf4gl5EluLvdLJ/A27NpL2Tb81N43r8609eFfdOM4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ImB78Xm5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ImB78Xm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819851F000E9;
	Mon, 29 Jun 2026 12:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735895;
	bh=q/zmrg1aZZtj5Tmn6K9F810cSj24cLspebCxVYr6+vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImB78Xm5cq6RrDbmQ3J6tzrC3HLEzs7wzd0LC9qXAFx7cd4y0IcRNHPEQjaCD2kCv
	 t7/cUJE9y3I1sPoHMYrCyG34SjvURuw2nRDZurNb2jCyVmORwYVTl6EDHnREKFXwhb
	 Mbf3AenyI1/h0SqiWNCY23Z13tJZjuXnBQ9SfIzuKiUPMbB3m3+TLCnoGKijqfR3NC
	 1tp2JiV+gIsscH67BC9LhRi/4QlmripqWzergkvG/ngTTNDMnQd/mgZN6SNyqqbauP
	 IGwwhnbxNqzXNkjYdSC9Q47btcLisY0PN7QS+5n8ONjQMKE+Ptl6DATcGPdaGI14cl
	 pHvsw1KC9+rOQ==
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
Subject: [PATCH 20/30] mm/vma: introduce vma_assert_can_modify()
Date: Mon, 29 Jun 2026 13:23:31 +0100
Message-ID: <23c7602c58cacc23ef22618a27af9a2d54addf58.1782735110.git.ljs@kernel.org>
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

vma_assert_write_locked() and vma_assert_attached() are useful for their
own purposes, however VMA code absolutely does allow the modification of
non-write locked VMAs if they are at that point detached (i.e. unreachable
from anywhere).

It's therefore useful to be able to assert that a VMA is either
detached (modification doesn't matter) or write locked (you're explicitly
locked for modification).

Therefore introduce vma_assert_can_modify() for this purpose.

While we're here, make vma_is_attached() available generally - if
!CONFIG_PER_VMA_LOCKS, then there's no sense in which a VMA is
detached (vma_mark_detached() is a noop), so have this default to true in
this case.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 include/linux/mmap_lock.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 04b8f61ece5d..d513286d8160 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -506,6 +506,8 @@ static inline __must_check
 int vma_start_write_killable(struct vm_area_struct *vma) { return 0; }
 static inline void vma_assert_write_locked(struct vm_area_struct *vma)
 		{ mmap_assert_write_locked(vma->vm_mm); }
+static inline bool vma_is_attached(struct vm_area_struct *vma)
+		{ return true; }
 static inline void vma_assert_attached(struct vm_area_struct *vma) {}
 static inline void vma_assert_detached(struct vm_area_struct *vma) {}
 static inline void vma_mark_attached(struct vm_area_struct *vma) {}
@@ -530,6 +532,12 @@ static inline void vma_assert_stabilised(struct vm_area_struct *vma)
 
 #endif /* CONFIG_PER_VMA_LOCK */
 
+static inline void vma_assert_can_modify(struct vm_area_struct *vma)
+{
+	if (vma_is_attached(vma))
+		vma_assert_write_locked(vma);
+}
+
 static inline void mmap_write_lock(struct mm_struct *mm)
 {
 	__mmap_lock_trace_start_locking(mm, true);
-- 
2.54.0


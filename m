From: Barret Rhoden <brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 2/3] kvm: Use huge pages for DAX-backed files
Date: Wed, 14 Nov 2018 16:51:54 -0500
Message-ID: <20181114215155.259978-3-brho@google.com>
References: <20181109203921.178363-1-brho@google.com>
 <20181114215155.259978-1-brho@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181114215155.259978-1-brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ross Zwisler <zwisler-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vishal Verma <vishal.l.verma-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yu.c.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, yi.z.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

This change allows KVM to map DAX-backed files made of huge pages with
huge mappings in the EPT/TDP.

DAX pages are not PageTransCompound.  The existing check is trying to
determine if the mapping for the pfn is a huge mapping or not.  For
non-DAX maps, e.g. hugetlbfs, that means checking PageTransCompound.
For DAX, we can check the page table itself.

Note that KVM already faulted in the page (or huge page) in the host's
page table, and we hold the KVM mmu spinlock.  We grabbed that lock in
kvm_mmu_notifier_invalidate_range_end, before checking the mmu seq.

Signed-off-by: Barret Rhoden <brho-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
- removed map_shift local variable

 arch/x86/kvm/mmu.c | 33 +++++++++++++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index cf5f572f2305..6914989d1e3d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -3152,6 +3152,35 @@ static int kvm_handle_bad_page(struct kvm_vcpu *vcpu, gfn_t gfn, kvm_pfn_t pfn)
 	return -EFAULT;
 }
 
+static bool pfn_is_huge_mapped(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn)
+{
+	struct page *page = pfn_to_page(pfn);
+	unsigned long hva;
+
+	if (!is_zone_device_page(page))
+		return PageTransCompoundMap(page);
+
+	/*
+	 * DAX pages do not use compound pages.  The page should have already
+	 * been mapped into the host-side page table during try_async_pf(), so
+	 * we can check the page tables directly.
+	 */
+	hva = gfn_to_hva(kvm, gfn);
+	if (kvm_is_error_hva(hva))
+		return false;
+
+	/*
+	 * Our caller grabbed the KVM mmu_lock with a successful
+	 * mmu_notifier_retry, so we're safe to walk the page table.
+	 */
+	switch (dev_pagemap_mapping_shift(hva, current->mm)) {
+	case PMD_SHIFT:
+	case PUD_SIZE:
+		return true;
+	}
+	return false;
+}
+
 static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 					gfn_t *gfnp, kvm_pfn_t *pfnp,
 					int *levelp)
@@ -3168,7 +3197,7 @@ static void transparent_hugepage_adjust(struct kvm_vcpu *vcpu,
 	 */
 	if (!is_error_noslot_pfn(pfn) && !kvm_is_reserved_pfn(pfn) &&
 	    level == PT_PAGE_TABLE_LEVEL &&
-	    PageTransCompoundMap(pfn_to_page(pfn)) &&
+	    pfn_is_huge_mapped(vcpu->kvm, gfn, pfn) &&
 	    !mmu_gfn_lpage_is_disallowed(vcpu, gfn, PT_DIRECTORY_LEVEL)) {
 		unsigned long mask;
 		/*
@@ -5678,7 +5707,7 @@ static bool kvm_mmu_zap_collapsible_spte(struct kvm *kvm,
 		 */
 		if (sp->role.direct &&
 			!kvm_is_reserved_pfn(pfn) &&
-			PageTransCompoundMap(pfn_to_page(pfn))) {
+			pfn_is_huge_mapped(kvm, sp->gfn, pfn)) {
 			pte_list_remove(rmap_head, sptep);
 			need_tlb_flush = 1;
 			goto restart;
-- 
2.19.1.1215.g8438c0b245-goog

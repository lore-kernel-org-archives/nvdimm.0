Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F53F211982F2
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 11:25:36 -0800 (PST)
Subject: [PATCH RFC 3/3] kvm: Add additional check to determine if a page is
 refcounted
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 03 Dec 2018 11:25:36 -0800
Message-ID: <154386513636.27193.9038916677163713072.stgit@ahduyck-desk1.amr.corp.intel.com>
In-Reply-To: <154386493754.27193.1300965403157243427.stgit@ahduyck-desk1.amr.corp.intel.com>
References: <154386493754.27193.1300965403157243427.stgit@ahduyck-desk1.amr.corp.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com, pbonzini@redhat.com, yi.z.zhang@linux.intel.com, brho@google.com, kvm@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: yu.c.zhang@intel.com, david@redhat.com, rkrcmar@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, jack@suse.cz, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

The function kvm_is_refcounted_page is used primarily to determine if KVM
is allowed to take a reference on the page. It was using the PG_reserved
flag to determine this previously, however in the case of DAX the page has
the PG_reserved flag set, but supports pinning by taking a reference on
the page. As such I have updated the check to add a special case for
ZONE_DEVICE pages that have the new support_refcount_pinning flag set.

Signed-off-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
---
 virt/kvm/kvm_main.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 5e666df5666d..2e7e9fbb67bf 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -148,8 +148,20 @@ __weak int kvm_arch_mmu_notifier_invalidate_range(struct kvm *kvm,
 
 bool kvm_is_refcounted_pfn(kvm_pfn_t pfn)
 {
-	if (pfn_valid(pfn))
-		return !PageReserved(pfn_to_page(pfn));
+	if (pfn_valid(pfn)) {
+		struct page *page = pfn_to_page(pfn);
+
+		/*
+		 * The reference count for MMIO pages are not updated.
+		 * Previously this was being tested for with just the
+		 * PageReserved check, however now ZONE_DEVICE pages may
+		 * also allow for the refcount to be updated for the sake
+		 * of pinning the pages so use the additional check provided
+		 * to determine if the reference count on the page can be
+		 * used to pin it.
+		 */
+		return !PageReserved(page) || is_device_pinnable_page(page);
+	}
 
 	return false;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

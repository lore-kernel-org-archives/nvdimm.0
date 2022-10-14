Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ED3E4695
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791925; x=1697327925;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2hYftC5ZQ196yfpWz+XXw4uXMxFoArKPmI5qaP+piRE=;
  b=CyUTqzFlNoMEGebRbFZ30VH70G1jRHE3s7k6ylXl0Hv9xXiSDXO8lZYK
   87jpC46ZeDkep+l8ErByq/DF2vuyQCYVxRdP5flRQ5RjaQdef7qPPN1iq
   DDMtEw2zW6WFjA2f4hdQlMIYvNJw288hZXkRE9Nhdg9xqdnlMbwCxg7XO
   mTk9TRKkzuKXvAza8pOMM73zfJIweoH0EPL7Yp4+r/Fdoncxw20FvVbwQ
   0naF5QvM4KK3af6x5MWw3mCdaVA8a8RRoFdDaUtQPuyH8H55it1DOMGjO
   WuM0EMjAD91jCH6M3xz8FI7cxjsuaAHDOb2s/4O91bsqBfZ02RQhGoNSO
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="305485819"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="305485819"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:44 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="802798951"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="802798951"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:43 -0700
Subject: [PATCH v3 18/25] devdax: Sparse fixes for vmfault_t / dax-entry
 conversions
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: kernel test robot <lkp@intel.com>, david@fromorbit.com, hch@lst.de,
 nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:58:43 -0700
Message-ID: <166579192360.2236710.14796211268184430654.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that the dax-mapping-entry code has moved to a common location take
the opportunity to fixup some long standing sparse warnings. In this
case conveying vm_fault_t codes through Xarray internal values was
missing some forced casts. Add some helpers, is_dax_err(),
dax_err_to_vmfault(), and vmfault_to_dax_err() to handle the
conversions.

Fixes:
drivers/dax/mapping.c:637:39: sparse: warning: incorrect type in argument 1 (different base types)
drivers/dax/mapping.c:637:39: sparse:    expected unsigned long v
drivers/dax/mapping.c:637:39: sparse:    got restricted vm_fault_t
drivers/dax/mapping.c:639:39: sparse: warning: incorrect type in argument 1 (different base types)
drivers/dax/mapping.c:639:39: sparse:    expected unsigned long v
drivers/dax/mapping.c:639:39: sparse:    got restricted vm_fault_t
drivers/dax/mapping.c:643:31: sparse: warning: incorrect type in argument 1 (different base types)
drivers/dax/mapping.c:643:31: sparse:    expected unsigned long v
drivers/dax/mapping.c:643:31: sparse:    got restricted vm_fault_t

Reported-by: Reported-by: kernel test robot <lkp@intel.com>
Link: http://lore.kernel.org/r/202210091141.cHaQEuCs-lkp@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/mapping.c |    6 +++---
 fs/dax.c              |    8 ++++----
 include/linux/dax.h   |   16 ++++++++++++++++
 3 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/dax/mapping.c b/drivers/dax/mapping.c
index 803ae64c13d4..b452bfa98f5e 100644
--- a/drivers/dax/mapping.c
+++ b/drivers/dax/mapping.c
@@ -634,13 +634,13 @@ void *dax_grab_mapping_entry(struct xa_state *xas,
 	if (xas_nomem(xas, mapping_gfp_mask(mapping) & ~__GFP_HIGHMEM))
 		goto retry;
 	if (xas->xa_node == XA_ERROR(-ENOMEM))
-		return xa_mk_internal(VM_FAULT_OOM);
+		return vmfault_to_dax_err(VM_FAULT_OOM);
 	if (xas_error(xas))
-		return xa_mk_internal(VM_FAULT_SIGBUS);
+		return vmfault_to_dax_err(VM_FAULT_SIGBUS);
 	return entry;
 fallback:
 	xas_unlock_irq(xas);
-	return xa_mk_internal(VM_FAULT_FALLBACK);
+	return vmfault_to_dax_err(VM_FAULT_FALLBACK);
 }
 
 static void *dax_zap_entry(struct xa_state *xas, void *entry)
diff --git a/fs/dax.c b/fs/dax.c
index de79dd132e22..dc1dcbaeba05 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -707,8 +707,8 @@ static vm_fault_t dax_iomap_pte_fault(struct vm_fault *vmf, pfn_t *pfnp,
 		iter.flags |= IOMAP_WRITE;
 
 	entry = dax_grab_mapping_entry(&xas, mapping, 0);
-	if (xa_is_internal(entry)) {
-		ret = xa_to_internal(entry);
+	if (is_dax_err(entry)) {
+		ret = dax_err_to_vmfault(entry);
 		goto out;
 	}
 
@@ -829,8 +829,8 @@ static vm_fault_t dax_iomap_pmd_fault(struct vm_fault *vmf, pfn_t *pfnp,
 	 * VM_FAULT_FALLBACK.
 	 */
 	entry = dax_grab_mapping_entry(&xas, mapping, PMD_ORDER);
-	if (xa_is_internal(entry)) {
-		ret = xa_to_internal(entry);
+	if (is_dax_err(entry)) {
+		ret = dax_err_to_vmfault(entry);
 		goto fallback;
 	}
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index 1fc3d79b6aec..553bc819a6a4 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -264,6 +264,22 @@ vm_fault_t dax_iomap_fault(struct vm_fault *vmf, enum page_entry_size pe_size,
 		    pfn_t *pfnp, int *errp, const struct iomap_ops *ops);
 vm_fault_t dax_finish_sync_fault(struct vm_fault *vmf,
 		enum page_entry_size pe_size, pfn_t pfn);
+
+static inline bool is_dax_err(void *entry)
+{
+	return xa_is_internal(entry);
+}
+
+static inline vm_fault_t dax_err_to_vmfault(void *entry)
+{
+	return (vm_fault_t __force)(xa_to_internal(entry));
+}
+
+static inline void *vmfault_to_dax_err(vm_fault_t error)
+{
+	return xa_mk_internal((unsigned long __force)error);
+}
+
 void *dax_grab_mapping_entry(struct xa_state *xas,
 			     struct address_space *mapping, unsigned int order);
 void dax_unlock_entry(struct xa_state *xas, void *entry);


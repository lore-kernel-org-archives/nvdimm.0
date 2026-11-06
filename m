Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=130.117.225.111
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793984736;
	b=GXDHQhWTw9kK5TDwezFig9ZWB0wNjOWKTpTtcXtnOGwGagGHGjF6352lDVtcWWtD/r8B
	 pI4vxSJ1fjsfdT5Ll3LdlF4bdbiNJETZGEVunYD7cPvlSicKkLQOYFsBBS0xCFZxJMBWB
	 +CcWHDIOE/usjPzXboEuZRk+Hn0u69ahpvFaWcT+IIR0BoEg0BtrhUEhOygeUWyZE/QOx
	 7olXH+66Zqt/dTgswiAX/O1iB1yL7/jnTXC5kGNuheWCXcMXRgxbgfjqIvtgQgmTUrnyN
	 ViLbx9lYsM5A5DAtFF9XAY5CbWL/6JGb6AprCjgYA2u/vvhoXBwgMx7rES6+2X+T+gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793984736;
	h=DMARC-Filter:DKIM-Signature:Received:From:Date:Subject:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Message-Id:X-B4-Tracking:
	 X-Change-ID:To:Cc:X-Mailer:X-Developer-Signature:X-Developer-Key;
	bh=LqH9iMIGaGgfrltDU+0qHbUT1ie4g3kkbL58F1jr5Pc=;
	b=tdjZXMdV/OL8aj9dpKROQVZ44QcXPOHeIgSv6aEilN1QQcJM9JJk2hqsy0SFEUYelji3
	 n57E1T+jDFuhqq/NxChe/w42XeuBDjlxtOe0pxejSE0dl5SihR3W1SA+rRZJ0mFWVHOlE
	 nVQEpK6UccP42ioYYqAoGpBn37wO3R7nTzsC2BnLq/HqPp/8u5x2u5FvFgOpPCef/8/vZ
	 Ehp36usDl/cQg7ctwRHV+Jk5nOG8IlQpy2kRtCwDviUvY3MO1YT93Dj+BxsscLJvLHali
	 dSuh4pClm3b9njKIl9vrW1Ed69LPjSUxvgp0+KksPKVX5WZseXZCxq4qax4xs3+spCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=virtuozzo.com;
	spf=pass smtp.mailfrom=virtuozzo.com;
	dkim=pass header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Ago+KLWk;
	arc=none smtp.remote-ip=130.117.225.111
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50EDB606A338;
	Fri,  6 Nov 2026 17:05:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50EDB606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=virtuozzo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=Ago+KLWk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=LqH9iMIGaGgfrltDU+0qHbUT1ie4g3kkbL58F1jr5Pc=; b=Ago+KLWko091EDuZeHQ
	xy4CpnbJrV3UtJFWa/DKDNjFPXScS1j02Z/HD+SIdAiU/sGojmXnMMdoBcpTl5UuNjnuPQcOBXYg5
	tdY8AVDg0m9ETwjl0V+ANAPL/LzlSk4ZmQ2K8pR2Yuaih6M0O+Ah42qtt3fMvd/rS5UEAZ0+gg8Wo
	aMQlfaunc7lyAcg0af9VGeEcgDBX6jaLKRBo80xp3fx8ndLNqW5kLe0tAAtJv+gscRrioHhxF1+9o
	nqS2GnBc+Eg06N4bD0KqJyWaq/er2+KCnhK4v3X3OgcUw45U6Rou8m7F54o6XhdJAq/pGuFUsVxO9
	LIn6HYM3b6a7Fnw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xPNJS-00F6fe-1u;
	Fri, 06 Nov 2026 18:05:18 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Fri, 06 Nov 2026 18:05:20 +0100
Subject: [PATCH] mm/huge_memory: use folio_dup_file_rmap_pud() in
 copy_huge_pud()
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-v1-1-cf8ee4fafabb@virtuozzo.com>
X-B4-Tracking: v=1; b=H4sIAM8I7moC/yXNQQ6CMBBA0auQWTtJB6UBr2IIgXakldg2LSUaw
 t2tunyb/3dIHC0nuFY7RN5sst4V0KkCZUY3M1pdDLWoJZGQuBgf2S0et7T6iNQQtWdUPrwHk2c
 eQtaoc8D4HAO2tRDdRTVy6gSUZIh8t6/f7tb/nfL0YLV+H3AcH7uGbvCQAAAA
X-Change-ID: 20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-820094c56b90
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Dan Williams <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3715;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=gxuw6LjVBrmV9639XN62UX0bOkR/j46xaDVTVYxMcMc=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq7gjRCymH1gaE3n+O11UPy5GKgSUYwmvmhhEug
 XGKykHU5QWJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCau4I0QAKCRBRlgpH+WFc
 KiAYEACov2BLVf6uA7xgliUWGHkOGWR3GCd3SE5HdxqeC9cfajx1YRp+3ZXchQbMMFjnjzeq/md
 y086jisNW1nF4Th1SH8pAXOWOwD4PwbOW/GVAZrQFJcUFW4g48vZW/aFDOqThcvg1R9QUfpkYAF
 MjRrB0i3xJzMEMaXtWt44wQeeRxJP9tq3yMqJAoXz15NTStwwvdCG8PAAZ6pqoh5PezLcf5m59g
 udW0MGwNMOrC/IukbEzvSb+KuwSeOk63FS4dpDr+nJd0oPHzKTzLpJ7Cmio9Ge+FIWlN2mh6cdr
 83SvhFTQG0GNCm0z8qTAe7TiJMEWcnTm6nIWA8B1jSCD7Zk9OTxe45GEdMmkfRZU+BYNIeq8jPU
 myeEL6Uyg5fzo9b0ch1ln9qXG0TIzs/LJ0dWkVsj5ikVLQjnIGSw3CarWo/3UQLsbGMFN03Yge4
 vi0mFfz8tplVJFzxHviraCZTnHqCVq/9K6gj9eOwdd1w78zjmmiKE7DGHcDQmlOisHbJoSnqS1W
 dvfXCimmSQITK9Sna9W7BJEDWzSZbw/QV+60OLvceSvmfqWEEpXiueADyXRHNHW8+95XSz+e/iD
 vFN2o92Y3OkOF2otlb9DeT6ZikMcAglhovQTQ+HyrYVdSo64RZTVFjNcCW8r4TnOaQOzr/BLhpW
 oJasVA+qM7v7wxw==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A

copy_huge_pud() adds the child's rmap of a device DAX PUD with
folio_add_file_rmap_pud(). That helper maps a folio afresh: it updates
NR_FILE_MAPPED when the folio becomes mapped and mlocks it in a
VM_LOCKED VMA. Neither applies at fork: the parent keeps the folio mapped
under the page table lock, and dup_mmap() clears VM_LOCKED in the
child's VMA.

copy_present_ptes() duplicates the rmap of a PTE with
folio_dup_file_rmap_ptes(), which only raises the mapcounts. Add
folio_dup_file_rmap_pud() for the PUD level and use it in copy_huge_pud().

No functional change.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
David's fix for the device DAX PUD fork bug, commit d90bdc02e36e
("mm/huge_memory: properly handle refcounted PUD mappings on fork"),
went in before v2 of my series for the same bug [1].

This is the follow-up David asked for [2].

The Reviewed-by tags are from v2 patch 1, whose rmap.h hunk and
copy_huge_pud() line this patch carries unchanged.

The selftest from v2 [3] is not included, as it needs a real devdax
device. It is there for anyone who wants to run it.

Based on thp-7.5.misc of the mm/core tree.

[1] https://lore.kernel.org/all/20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-0-2828fe5a51ed@virtuozzo.com/
[2] https://lore.kernel.org/all/6f035f97-8b55-47ad-bd52-833b86b8ae8f@kernel.org/
[3] https://lore.kernel.org/all/20261105-vstor-150143-copy_huge_pud-folio-refcount-v2-2-2828fe5a51ed@virtuozzo.com/

Assisted-by: LLM
---
 include/linux/rmap.h | 22 ++++++++++++++++++++++
 mm/huge_memory.c     |  2 +-
 2 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 74cca0e3c7264..52fff8dc74213 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -564,6 +564,28 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 #endif
 }
 
+/**
+ * folio_dup_file_rmap_pud - duplicate a PUD mapping of a page range of a folio
+ * @folio:	The folio to duplicate the mapping of
+ * @page:	The first page to duplicate the mapping of
+ * @dst_vma:	The destination vm area
+ *
+ * The page range of the folio is defined by [page, page + HPAGE_PUD_NR)
+ *
+ * The caller needs to hold the page table lock.
+ */
+static inline void folio_dup_file_rmap_pud(struct folio *folio,
+		struct page *page, struct vm_area_struct *dst_vma)
+{
+#if defined(CONFIG_TRANSPARENT_HUGEPAGE) && \
+	defined(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD)
+	__folio_dup_file_rmap(folio, page, HPAGE_PUD_NR, dst_vma,
+			      PGTABLE_LEVEL_PUD);
+#else
+	WARN_ON_ONCE(true);
+#endif
+}
+
 static __always_inline int __folio_try_dup_anon_rmap(struct folio *folio,
 		struct page *page, int nr_pages, struct vm_area_struct *dst_vma,
 		struct vm_area_struct *src_vma, enum pgtable_level level)
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d0e19d9e6b651..13caf81cb51af 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2100,7 +2100,7 @@ int copy_huge_pud(struct vm_area_struct *dst_vma, struct vm_area_struct *src_vma
 		 * TODO: once we support anonymous pages, use
 		 * folio_try_dup_anon_rmap_*() and split if duplicating fails.
 		 */
-		folio_add_file_rmap_pud(folio, page, dst_vma);
+		folio_dup_file_rmap_pud(folio, page, dst_vma);
 		add_mm_counter(dst_mm, mm_counter_file(folio), HPAGE_PUD_NR);
 	}
 

---
base-commit: 31ea5515bf595046effc74a5bafdcc26320d2d86
change-id: 20261106-khorenko-vstor-151183-copy_huge_pud-dup-rmap-820094c56b90

Best regards,
--  
Konstantin Khorenko,
Virtuozzo Linux Kernel Team


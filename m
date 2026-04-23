Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E69436DA0B;
	Thu, 23 Apr 2026 17:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776963747; cv=none; b=X97cAZ76P4Ru7gGLDmAuJtj+tjW+JHH8z8Oe7W6vDu88VGPsJaRXI0ZDE4wlO8YqDITquyapFXD7bnSr3Th953Z0Y/z73GTMnfNrFy2FaS3HX8c7X34Ttu++MAxUn5gCA8KkXH/hhbTRIb0L89W8qnxqRk8mcjtwif7UymFDaVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776963747; c=relaxed/simple;
	bh=gdT+U3LHEUd+hnFBrmOOeWvm6nltDQqtuPiBqiE4mV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LV3EjrJLhKkIwZQ0xbteMYwufxVKgEYiSCUthAH5KHliYTliLHxVgPl35TzE2RsI+CQvs1i57b98LFt0ihB8eC6hNOFCPIcTFt6OHLP323Zqo03CmltufsRQ5Rnwr5VwKaDiZWLBO9qOumGP9GKSu0rWc9CObx7Z3ekpYwL8KQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8983C2BCB3;
	Thu, 23 Apr 2026 17:02:26 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: djbw@kernel.org,
	iweiny@kernel.org,
	pasha.tatashin@soleen.com,
	mclapinski@google.com,
	rppt@kernel.org,
	joao.m.martins@oracle.com,
	jic23@kernel.org,
	gourry@gourry.net,
	john@groves.net,
	rick.p.edgecombe@intel.com
Subject: [RFC PATCH 04/12] dax: Move dax_pgoff_to_phys() to dax bus to be used by dev dax
Date: Thu, 23 Apr 2026 10:02:11 -0700
Message-ID: <20260423170219.281618-5-dave.jiang@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260423170219.281618-1-dave.jiang@intel.com>
References: <20260423170219.281618-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move function and export symbol dax_pgoff_to_phys() to dax bus.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/dax/bus.c    | 24 ++++++++++++++++++++++++
 drivers/dax/device.c | 23 -----------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..92e79720befd 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1417,6 +1417,30 @@ static const struct device_type dev_dax_type = {
 	.groups = dax_attribute_groups,
 };
 
+/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
+__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
+		unsigned long size)
+{
+	int i;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct dev_dax_range *dax_range = &dev_dax->ranges[i];
+		struct range *range = &dax_range->range;
+		unsigned long long pgoff_end;
+		phys_addr_t phys;
+
+		pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
+		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
+			continue;
+		phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
+		if (phys + size - 1 <= range->end)
+			return phys;
+		break;
+	}
+	return -1;
+}
+EXPORT_SYMBOL_GPL(dax_pgoff_to_phys);
+
 static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 {
 	struct dax_region *dax_region = data->dax_region;
diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 705c59f469c2..e892fb4ec8e0 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -59,29 +59,6 @@ static int check_vma(struct dev_dax *dev_dax, struct vm_area_struct *vma,
 			   vma->vm_file, func);
 }
 
-/* see "strong" declaration in tools/testing/nvdimm/dax-dev.c */
-__weak phys_addr_t dax_pgoff_to_phys(struct dev_dax *dev_dax, pgoff_t pgoff,
-		unsigned long size)
-{
-	int i;
-
-	for (i = 0; i < dev_dax->nr_range; i++) {
-		struct dev_dax_range *dax_range = &dev_dax->ranges[i];
-		struct range *range = &dax_range->range;
-		unsigned long long pgoff_end;
-		phys_addr_t phys;
-
-		pgoff_end = dax_range->pgoff + PHYS_PFN(range_len(range)) - 1;
-		if (pgoff < dax_range->pgoff || pgoff > pgoff_end)
-			continue;
-		phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
-		if (phys + size - 1 <= range->end)
-			return phys;
-		break;
-	}
-	return -1;
-}
-
 static void dax_set_mapping(struct vm_fault *vmf, unsigned long pfn,
 			      unsigned long fault_size)
 {
-- 
2.53.0


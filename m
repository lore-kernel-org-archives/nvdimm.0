Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D469211F8882
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 15:06:45 -0700 (PDT)
Date: Fri, 6 Jul 2018 16:06:12 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCHv2 1/2] libnvdimm: Use max contiguous area for namespace
 size
Message-ID: <20180706220612.GA2803@localhost.localdomain>
References: <20180705201726.512-1-keith.busch@intel.com>
 <CAPcyv4hVO38=7fxegS0BY2ePr4NPtajsQyyAYt=8=u5si_9r3g@mail.gmail.com>
 <CAPcyv4hcfdr+8HUs9gsxYH7vZgtPCLwF6fvbC8-Z7YDC1GqXMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hcfdr+8HUs9gsxYH7vZgtPCLwF6fvbC8-Z7YDC1GqXMQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 05, 2018 at 06:48:25PM -0700, Dan Williams wrote:
> On Thu, Jul 5, 2018 at 6:25 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> > So, I liked how simple and straightforward this was, but the unit test
> > reminded me how complicated the free space allocation could be given
> > that we still might need to account for aliased BLK capacity.
> >
> > A few things I now notice:
> >
> > * It is possible for a dpa resource to start before nd_mapping->start
> > and/or end after nd_mapping->size. See the diagram in
> > tools/testing/nvdimm/test/nfit.c
> >
> > * We need to be summing the max extents across all DIMMs in the set
> > while also accounting for this BLK overlap problem that
> > nd_pmem_available_dpa() handles.
> >
> > The original bug arose from the fact that the
> > nd_region_available_dpa() accounts for total busy capacity and the
> > allocation path looks for extents. It would be nice to unify those two
> > functions... or maybe standardize on scan_allocate() everywhere.
> 
> I think you can redo this using reserve_free_pmem() and then find the
> largest free space reservation after accounting for blk_max_overlap as
> calculated by nd_region_available_dpa().
> 
> reserve_free_pmem() inserts resources into the dpa resource tree with
> the name "pmem-reserve" then you need to filter those against
> blk_max_overlap to find which ones might appear free, but shadowed by
> a BLK allocation on one of the DIMMs in the set. Yes, it allocates
> memory and is heavy handed, but I'm having a hard time thinking of
> something better at the moment.

Okay, I think I follow what you're saying, but let me just see if the
following is what you had in mind before sending a v3:

---
diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
index 8d348b22ba45..f30e0c3b0282 100644
--- a/drivers/nvdimm/dimm_devs.c
+++ b/drivers/nvdimm/dimm_devs.c
@@ -536,6 +536,31 @@ resource_size_t nd_blk_available_dpa(struct nd_region *nd_region)
 	return info.available;
 }
 
+/**
+ * nd_pmem_max_contiguous_dpa - For the given dimm+region, return the max
+ *				contiguous unallocated dpa range.
+ * @nd_region: constrain available space check to this reference region
+ * @nd_mapping: container of dpa-resource-root + labels
+ */
+resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
+					   struct nd_mapping *nd_mapping)
+{
+	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+	resource_size_t max = 0;
+	struct resource *res;
+
+	if (!ndd)
+		return 0;
+
+	for_each_dpa_resource(ndd, res) {
+		if (strcmp(res->name, "pmem-reserve") != 0)
+			continue;
+		if (resource_size(res) > max)
+			max = resource_size(res);
+	}
+	return max;
+}
+
 /**
  * nd_pmem_available_dpa - for the given dimm+region account unallocated dpa
  * @nd_mapping: container of dpa-resource-root + labels
diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 28afdd668905..ba5120aba9bf 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -836,7 +836,7 @@ static int __reserve_free_pmem(struct device *dev, void *data)
 	return 0;
 }
 
-static void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
+void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
 		struct nd_mapping *nd_mapping)
 {
 	struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
@@ -847,7 +847,7 @@ static void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
 			nvdimm_free_dpa(ndd, res);
 }
 
-static int reserve_free_pmem(struct nvdimm_bus *nvdimm_bus,
+int reserve_free_pmem(struct nvdimm_bus *nvdimm_bus,
 		struct nd_mapping *nd_mapping)
 {
 	struct nvdimm *nvdimm = nd_mapping->nvdimm;
@@ -1032,7 +1032,7 @@ static ssize_t __size_store(struct device *dev, unsigned long long val)
 
 		allocated += nvdimm_allocated_dpa(ndd, &label_id);
 	}
-	available = nd_region_available_dpa(nd_region);
+	available = nd_region_contiguous_max(nd_region);
 
 	if (val > available + allocated)
 		return -ENOSPC;
diff --git a/drivers/nvdimm/nd-core.h b/drivers/nvdimm/nd-core.h
index 79274ead54fb..391b97e5c820 100644
--- a/drivers/nvdimm/nd-core.h
+++ b/drivers/nvdimm/nd-core.h
@@ -100,6 +100,15 @@ struct nd_region;
 struct nvdimm_drvdata;
 struct nd_mapping;
 void nd_mapping_free_labels(struct nd_mapping *nd_mapping);
+
+int reserve_free_pmem(struct nvdimm_bus *nvdimm_bus,
+		      struct nd_mapping *nd_mapping);
+void release_free_pmem(struct nvdimm_bus *nvdimm_bus,
+		       struct nd_mapping *nd_mapping);
+
+resource_size_t nd_pmem_max_contiguous_dpa(struct nd_region *nd_region,
+					   struct nd_mapping *nd_mapping);
+resource_size_t nd_region_contiguous_max(struct nd_region *nd_region);
 resource_size_t nd_pmem_available_dpa(struct nd_region *nd_region,
 		struct nd_mapping *nd_mapping, resource_size_t *overlap);
 resource_size_t nd_blk_available_dpa(struct nd_region *nd_region);
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index ec3543b83330..48b3bd5219d2 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -357,6 +357,35 @@ static ssize_t set_cookie_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(set_cookie);
 
+resource_size_t nd_region_contiguous_max(struct nd_region *nd_region)
+{
+	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(&nd_region->dev);
+	resource_size_t available = 0;
+	int i, rc;
+
+	WARN_ON(!is_nvdimm_bus_locked(&nd_region->dev));
+	for (i = 0; i < nd_region->ndr_mappings; i++) {
+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
+		struct nvdimm_drvdata *ndd = to_ndd(nd_mapping);
+
+		/* if a dimm is disabled the available capacity is zero */
+		if (!ndd)
+			return 0;
+
+
+		if (is_memory(&nd_region->dev)) {
+			rc = reserve_free_pmem(nvdimm_bus, nd_mapping);
+			if (rc)
+				return 0;
+			available += nd_pmem_max_contiguous_dpa(nd_region,
+								nd_mapping);
+			release_free_pmem(nvdimm_bus, nd_mapping);
+		} else if (is_nd_blk(&nd_region->dev))
+			available += nd_blk_available_dpa(nd_region);
+	}
+	return available;
+}
+
 resource_size_t nd_region_available_dpa(struct nd_region *nd_region)
 {
 	resource_size_t blk_max_overlap = 0, available, overlap;
--
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

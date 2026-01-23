Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542CF3806B6
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167908; cv=none; b=nhsQPaRxBGY4Ny/XxXYlcIK2tLVVjFs2lPPedCyu3zD+J/rXtn3jvlVDG4ylMPCdB65WUMw5JLQrjqncOs3USQHS+T4S56eBnO/qguEHYADLNe1OtKR5r7aUNLRlKG8/mP+5Io1OVPLRbftTpvlBdwHJZePN4I13OVt1PAH7fZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167908; c=relaxed/simple;
	bh=oHBj1cPJz8cQ+pkC2U1P21/5vYsZOUJH1jFiM4pjtnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=DrbeZ8lJDwuAzmJHplXCzCuvBnCwXZLU2YEgXRm8LK1I9o39Ce2FWffOXXD6hngOg4/7ARajDyJJ20eIYgi7dObCz6/dSBVtdk7mE7SCwt5px9gxV45dmmi1xpVZF2+DrEEOgLlvjU3KTt3jr3Xymkt8B+WhMqoKWqdau8Hmg0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=N6dphHs7; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="N6dphHs7"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260123113143epoutp02b544a491207108daa713046302585e3a~NWNW2TrEU0069400694epoutp02e
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:43 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260123113143epoutp02b544a491207108daa713046302585e3a~NWNW2TrEU0069400694epoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167903;
	bh=P48pOT0TYblMck0fUkubQe5/ucz9763CSDBG1sAPzuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N6dphHs7QO27SwEgkG1aosTB2ZGbtIPRLgvVAFr/4Li9dBewH0tQikH4TQ+Rf7x/c
	 4mXU9s+tZ30piQ+n79VEQyRYHJsgaoLLD8fvGdXp/h3zst8rOGhFEkpgwh+5i9uRyI
	 I5VHWQoCwvO8o7mVznnwe4VHfN8cgI3bHQ9lcNho=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20260123113142epcas5p309a54180492f21217e4204c39ca39272~NWNWBVxvY2653226532epcas5p3n;
	Fri, 23 Jan 2026 11:31:42 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dyG3d6m6Cz6B9m5; Fri, 23 Jan
	2026 11:31:41 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b~NWNU7bEbS1479614796epcas5p4q;
	Fri, 23 Jan 2026 11:31:41 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113140epsmtip2aa6180409cc0d8dfaeced5e29aca429e~NWNTp7mcc2685626856epsmtip2U;
	Fri, 23 Jan 2026 11:31:39 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 12/18] cxl/region: Add devm_cxl_pmem_add_region() for
 pmem region creation
Date: Fri, 23 Jan 2026 17:01:06 +0530
Message-Id: <20260123113112.3488381-13-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260123113112.3488381-1-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b
References: <20260123113112.3488381-1-s.neeraj@samsung.com>
	<CGME20260123113141epcas5p49a1eebff4401a7fc98381358162fde2b@epcas5p4.samsung.com>

devm_cxl_pmem_add_region() is used to create cxl region based on region
information scanned from LSA.

devm_cxl_add_region() is used to just allocate cxlr and its fields are
filled later by userspace tool using device attributes (*_store()).

Inspiration for devm_cxl_pmem_add_region() is taken from these device
attributes (_store*) calls. It allocates cxlr and fills information
parsed from LSA and calls device_add(&cxlr->dev) to initiate further
region creation porbes

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Neeraj Kumar <s.neeraj@samsung.com>
---
 drivers/cxl/core/region.c | 118 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 2e60e5e72551..e384eacc46ae 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2621,6 +2621,121 @@ static struct cxl_region *devm_cxl_add_region(struct cxl_root_decoder *cxlrd,
 	return ERR_PTR(rc);
 }
 
+static ssize_t alloc_region_hpa(struct cxl_region *cxlr, u64 size)
+{
+	int rc;
+
+	if (!size)
+		return -EINVAL;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem)))
+		return rc;
+
+	return alloc_hpa(cxlr, size);
+}
+
+static ssize_t alloc_region_dpa(struct cxl_endpoint_decoder *cxled, u64 size)
+{
+	if (!size)
+		return -EINVAL;
+
+	if (!IS_ALIGNED(size, SZ_256M))
+		return -EINVAL;
+
+	return cxl_dpa_alloc(cxled, size);
+}
+
+static struct cxl_region *
+cxl_pmem_region_prep(struct cxl_root_decoder *cxlrd, int id,
+		     struct cxl_pmem_region_params *params,
+		     struct cxl_endpoint_decoder *cxled,
+		     enum cxl_decoder_type type)
+{
+	struct cxl_region_params *p;
+	struct device *dev;
+	int rc;
+
+	struct cxl_region *cxlr __free(put_cxl_region) =
+		cxl_region_alloc(cxlrd, id);
+	if (IS_ERR(cxlr))
+		return cxlr;
+
+	dev = &cxlr->dev;
+	rc = dev_set_name(dev, "region%d", id);
+	if (rc)
+		return ERR_PTR(rc);
+
+	cxlr->mode = CXL_PARTMODE_PMEM;
+	cxlr->type = type;
+
+	p = &cxlr->params;
+	p->uuid = params->uuid;
+	p->interleave_ways = params->nlabel;
+	p->interleave_granularity = params->ig;
+
+	rc = alloc_region_hpa(cxlr, params->rawsize);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = cxl_dpa_set_part(cxled, CXL_PARTMODE_PMEM);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = alloc_region_dpa(cxled, params->rawsize);
+	if (rc)
+		return ERR_PTR(rc);
+
+	/*
+	 * TODO: Currently we have support of interleave_way == 1, where
+	 * we can only have one region per mem device. It means mem device
+	 * position (params->position) will always be 0. It is therefore
+	 * attaching only one target at params->position
+	 */
+	if (params->position)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	rc = attach_target(cxlr, cxled, params->position, TASK_INTERRUPTIBLE);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = __commit(cxlr);
+	if (rc)
+		return ERR_PTR(rc);
+
+	rc = device_add(dev);
+	if (rc)
+		return ERR_PTR(rc);
+
+	return no_free_ptr(cxlr);
+}
+
+static struct cxl_region *
+devm_cxl_pmem_add_region(struct cxl_root_decoder *cxlrd, int id,
+			 struct cxl_pmem_region_params *params,
+			 struct cxl_endpoint_decoder *cxled,
+			 enum cxl_decoder_type type)
+{
+	struct cxl_port *root_port;
+	struct cxl_region *cxlr;
+	int rc;
+
+	cxlr = cxl_pmem_region_prep(cxlrd, id, params, cxled, type);
+	if (IS_ERR(cxlr))
+		return cxlr;
+
+	root_port = to_cxl_port(cxlrd->cxlsd.cxld.dev.parent);
+	rc = devm_add_action_or_reset(root_port->uport_dev,
+				      unregister_region, cxlr);
+	if (rc)
+		return ERR_PTR(rc);
+
+	dev_dbg(root_port->uport_dev, "%s: created %s\n",
+		dev_name(&cxlrd->cxlsd.cxld.dev), dev_name(&cxlr->dev));
+
+	return cxlr;
+}
+
 static ssize_t __create_region_show(struct cxl_root_decoder *cxlrd, char *buf)
 {
 	return sysfs_emit(buf, "region%u\n", atomic_read(&cxlrd->region_id));
@@ -2663,6 +2778,9 @@ struct cxl_region *cxl_create_region(struct cxl_root_decoder *cxlrd,
 		return ERR_PTR(-EBUSY);
 	}
 
+	if (pmem_params)
+		return devm_cxl_pmem_add_region(cxlrd, id, pmem_params, cxled,
+						CXL_DECODER_HOSTONLYMEM);
 	return devm_cxl_add_region(cxlrd, id, mode, CXL_DECODER_HOSTONLYMEM);
 }
 
-- 
2.34.1


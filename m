Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25D338886B
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529450; cv=none; b=kxYSmJSd+Z+UrLNM71acvM871YhDLoEiaiLRkmEzvFPGlZ245wDVK3pnOKM3+rjuyeHMFH3wSJAHBnMikxr/I+mf7lT01AtiCupXOI8V1t5Yl33NAAQt74qeMhJja2X1/KfYdJ0Q4FATK0dgHQmxD5FV1AzWKQRrRxnEbKqJgEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529450; c=relaxed/simple;
	bh=+Fs7s5G0qsALoEg5+n2VxXmV7ZgzgjcZhlIbWf49dqI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eT9KbhMYc5tPSqXEfaIEaAgm9G5PvAp+k2RSyvEWVqMKyf0Vg5C4HfjYcvtw2BBmkV74FtfnMQBBV8DPIRJb9iYnYGCfmCH9qexJVbsy+TBBtOprPhPfNUgS1hg2rGlLYA6J+W8wEZ0FnPiELfx5TTQA6hEyhI9epsw3wvddDU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QzgfEpFN; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QzgfEpFN"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-135e88b8e55so3425208c88.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529448; x=1780134248; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lmIYAuyAsD2n/pMyj9L4/1IUWr8KglMpbMYEoiJlFTY=;
        b=QzgfEpFN7Q9qErYLc4yGtB1kLBjh92ANRxrghDXc0xrDkwjKpEitcxSzhj93CxF8ME
         YihVzHKyRaNn+8rhvg/c3i7h72gZ3rNuPcHmnJQFTQtI4vXNJrjPrZPETmx5rh+qp558
         cTCUaSo9apBab2xhF8IeT+TM33FD1HCQBzvQMD25Wy04K3C31/v69lCvjzPhaPbNfviw
         vXzGMXk3Kec2UfuJlHx3g21Igvai6Qvqx7b8DMcRuSgCBHap79ygRXU62rbl7qLsCNzR
         gtJrmI0ckLnhKvJ1Ekhbt1bbWqpcATr9SoqwCBUNYVIiJOKqds1aFkSdu5Z842OIaaYA
         HbrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529448; x=1780134248;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lmIYAuyAsD2n/pMyj9L4/1IUWr8KglMpbMYEoiJlFTY=;
        b=DYyuCJLB24Lfnw/0NHXqSZv4YTZAg4x5S8Wz9rey9jFFx1bvsIkTi7JLx0jOGQwxzV
         2c1D/HqhTahNbuKSlUtE8RglXPnxME/GQTcnpouR/OcBg1MyL4NfZ3dcmzQcw7ufHXjN
         7gsxI8NO2pR/Fi3uWZY9md1mt49EBKt5a0jScLloDxWdCplUYYlNCaFgNGpHslp50occ
         9+pRoN9MyMJXY68T93DJWOFiQSfzRR8ySQR6fUvmF9WcyNk17Qwim+Kssif0EQmAuJQg
         gwa/xvtAtiIZvPsTH1fo3KSsQdeCE3tVggmadw8nrXgZEKBnE1q9NCXx7vU8pw6kxfTp
         Ddpg==
X-Gm-Message-State: AOJu0YyeqRSQfzJ1Zsck8ESV+yh4dHyX0nsu/bgsgGwj71gC0szloXUF
	ZHAvKU/LhY8KLArM9uY38w/nX46uF3QPe6I5FRjlDeXawF9eeK2nXrhO
X-Gm-Gg: Acq92OELX2HZpLhD+dS7ogr7/537eic0mSNPrm8AQDtp/gqbWh9J+ayLNl+nxHaCxP6
	Yfk7ROCFb9UKi/omeyXRPvpB9FjxfiPaZoD0bCF5XtCLxS2sgfjJD3VK8D+8ea/nHvhKccBJVOF
	K7PkpDv6vCQv1zJiqpRzkyXwFCjEjwbbCzA6nn5Q6okni6liZEmq5vkFQMsl4o00n0w3swA+nxH
	0ZxxQ0GYepyVCBTEDNHGpx7xdZwzIJlBHtWm7QrsvvIGCyoYVWxyu7xYO5SzkIT5Vk5nevelaV0
	qE//x3kiWWJDHxt1PAyApkaVZPca/s9ABZsuBjeHrQ/uv5oiTN+SnMXxTgXbJ5Myp00zBJIZT5v
	RdzXvTEcMDtit/wV5787UoG8yCeRR8Eowe0A5SCrz1mNJlv+ak0S7k8I3yWiDkrRDDT4o32ng+m
	oIfFQtC8FcXGTvqZsspHlQB2RkzlIMcGlyMHYtIfNttxe5nF6jo45BI7JC61hUbJdP/EAEOc3mG
	RHV2c8=
X-Received: by 2002:a05:7022:128a:b0:12d:de3e:86a8 with SMTP id a92af1059eb24-1365fc774a3mr2758746c88.38.1779529448111;
        Sat, 23 May 2026 02:44:08 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:07 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 16/31] cxl/extent: Validate DC extent partition
Date: Sat, 23 May 2026 02:43:10 -0700
Message-ID: <def526ee51b647e9256c7e777c6b7bd5cd647f89.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extend cxl_validate_extent() — the per-extent check of the add pipeline
to check partition membership.

Resolves an extent's DPA to its containing DC partition. Then based on
if the partition is shareable:

  - Shareable: tag must be non-null and shared_extn_seq must be non-zero
    — multiple hosts reading the same allocation rely on the device-
    stamped 1..n sequence to assemble extents in agreed order.
  - Non-sharable: shared_extn_seq must be zero — sequencing is
    meaningless when only one host consumes the allocation; tag is
    optional (null UUID permitted).

Any cross-mix is a device firmware bug; reject the extent.

Based on patches by John Groves.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: John Groves <John@Groves.net>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: split out as a separate validation step]
---
 drivers/cxl/core/core.h   |  4 ++
 drivers/cxl/core/extent.c | 78 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1bae80dbf991..30b6b05b155b 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -179,6 +179,10 @@ int cxl_pci_get_bandwidth(struct pci_dev *pdev, struct access_coordinate *c);
 int cxl_port_get_switch_dport_bandwidth(struct cxl_port *port,
 					struct access_coordinate *c);
 void memdev_release_extent(struct cxl_memdev_state *mds, struct range *range);
+const struct cxl_dpa_partition *
+cxl_extent_dc_partition(struct cxl_memdev_state *mds,
+			struct cxl_extent *extent,
+			struct range *ext_range);
 
 static inline struct device *port_to_host(struct cxl_port *port)
 {
diff --git a/drivers/cxl/core/extent.c b/drivers/cxl/core/extent.c
index 94128d06f4ed..b01507022cff 100644
--- a/drivers/cxl/core/extent.c
+++ b/drivers/cxl/core/extent.c
@@ -63,11 +63,55 @@ alloc_tag_group(struct cxl_dax_region *cxlr_dax, uuid_t *uuid)
 	return no_free_ptr(group);
 }
 
+/*
+ * Find the DC (Dynamic Capacity) partition that fully contains @ext_range,
+ * or NULL if the extent falls outside every DC partition on this memdev.
+ * The returned pointer is owned by mds->cxlds.part[] and lives for the
+ * lifetime of the memdev.
+ */
+const struct cxl_dpa_partition *
+cxl_extent_dc_partition(struct cxl_memdev_state *mds,
+			struct cxl_extent *extent,
+			struct range *ext_range)
+{
+	struct cxl_dev_state *cxlds = &mds->cxlds;
+	struct device *dev = mds->cxlds.dev;
+
+	for (int i = 0; i < cxlds->nr_partitions; i++) {
+		struct cxl_dpa_partition *part = &cxlds->part[i];
+		struct range partition_range = {
+			.start = part->res.start,
+			.end = part->res.end,
+		};
+
+		if (part->mode != CXL_PARTMODE_DYNAMIC_RAM_A)
+			continue;
+
+		if (range_contains(&partition_range, ext_range)) {
+			dev_dbg(dev, "DC extent DPA %pra (DCR:%pra)(%pU)\n",
+				ext_range, &partition_range, extent->uuid);
+			return part;
+		}
+	}
+
+	dev_err_ratelimited(dev,
+			    "DC extent DPA %pra (%pU) is not in a valid DC partition\n",
+			    ext_range, extent->uuid);
+	return NULL;
+}
+
 /*
  * Stage 1 of the add pipeline: pure, no allocation.  Resolve the extent
- * to its region/endpoint decoder and ext_range, and verify the range
- * fits in the resolved endpoint decoder's DPA resource.  Further
- * per-extent invariants layer into this function in subsequent commits.
+ * to its region/endpoint decoder and ext_range, and enforce every
+ * per-extent invariant the device must satisfy:
+ *
+ *   - DPA falls inside a Dynamic Capacity partition (cxl_extent_dc_partition).
+ *   - CDAT-sharability rules:
+ *       sharable:     tag must be non-null AND shared_extn_seq != 0
+ *       non-sharable: shared_extn_seq must be 0  (tag is optional)
+ *     Any cross-mixing is a device firmware bug.
+ *   - DPA resolves to an endpoint decoder attached to a region.
+ *   - The extent's range is fully contained in that ED's DPA resource.
  *
  * Caller must hold cxl_rwsem.region for read (cxl_dpa_to_region()).
  * On success, @out_cxled / @out_cxlr_dax / @out_ext_range carry the
@@ -81,6 +125,10 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
 {
 	u64 start_dpa = le64_to_cpu(extent->start_dpa);
 	struct cxl_memdev *cxlmd = mds->cxlds.cxlmd;
+	struct device *dev = mds->cxlds.dev;
+	uuid_t *uuid = (uuid_t *)extent->uuid;
+	u16 seq = le16_to_cpu(extent->shared_extn_seq);
+	const struct cxl_dpa_partition *part;
 	struct cxl_endpoint_decoder *cxled;
 	struct cxl_region *cxlr;
 	struct range ext_range = (struct range) {
@@ -89,6 +137,30 @@ static int cxl_validate_extent(struct cxl_memdev_state *mds,
 	};
 	struct range ed_range;
 
+	part = cxl_extent_dc_partition(mds, extent, &ext_range);
+	if (!part)
+		return -ENXIO;
+
+	if (part->perf.shareable) {
+		if (uuid_is_null(uuid)) {
+			dev_err_ratelimited(dev,
+				"DC extent DPA %pra: sharable-partition extent has null tag (firmware bug)\n",
+				&ext_range);
+			return -ENXIO;
+		}
+		if (seq == 0) {
+			dev_err_ratelimited(dev,
+				"DC extent DPA %pra (%pU): sharable-partition extent missing shared_extn_seq (firmware bug)\n",
+				&ext_range, uuid);
+			return -ENXIO;
+		}
+	} else if (seq != 0) {
+		dev_err_ratelimited(dev,
+			"DC extent DPA %pra (%pU): non-sharable partition but shared_extn_seq=%u (firmware bug)\n",
+			&ext_range, uuid, seq);
+		return -ENXIO;
+	}
+
 	cxlr = cxl_dpa_to_region(cxlmd, start_dpa, &cxled);
 	if (!cxlr)
 		return -ENXIO;
-- 
2.43.0


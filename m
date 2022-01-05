Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234A82C9C
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418311; x=1672954311;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZajtxRjy+8ZNb8dlfcJqunXfCWxVuhwxI8eHmJpO6+c=;
  b=lxr+vS9P+fPPLJeRvHXpTD3wgPVUB3Zs80u6uzuqMah2FB/RE21pRgUt
   u5NxfK2bjqxA7d4dGxtYf4Anl3OOE8sKBxaM6eaqQNP/LH8kY2mct4LL6
   MAdySt25is325ljYLBS9kZupIwMaUARzwZT3/m6bz/+9X40Pq6AEkt4Zr
   9gRTO5TlaU6o+u3n2b2IFuqn160O+AsjIV6Xz9uwww4DmBnETF2n9WWbv
   /DUXk/UFtgaWq9yJcfLeONnLgNfR0unZ06Q6CYfZYSaMPW80dN0M41d73
   SQqM0rHROB05kQRijx2WE4nt1JqTt3AflhRzMAcghf3czXm8A81HjoGo2
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240083953"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="240083953"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:31:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="470718707"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:31:50 -0800
Subject: [ndctl PATCH v3 02/16] ndctl/test: Prepare for BLK-aperture support
 removal
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:31:50 -0800
Message-ID: <164141830999.3990253.5021445352398348657.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The kernel is dropping its support for the BLK-aperture access method. The
primary side effect of this for nfit_test is that NVDIMM namespace labeling
will not be enabled by default. Update the unit tests to initialize the
label index area in this scenario.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/core.c     |   31 ++++++++++++++++++++++++++++---
 test/libndctl.c |   49 +++++++++++++++++++++++++++++++++++--------------
 2 files changed, 63 insertions(+), 17 deletions(-)

diff --git a/test/core.c b/test/core.c
index 2b03aa9b3f2a..93e1dae5a144 100644
--- a/test/core.c
+++ b/test/core.c
@@ -261,8 +261,8 @@ retry:
 		ndctl_bus_foreach(nd_ctx, bus) {
 			struct ndctl_region *region;
 
-			if (strncmp(ndctl_bus_get_provider(bus),
-						"nfit_test", 9) != 0)
+			if (strcmp(ndctl_bus_get_provider(bus),
+				   "nfit_test.0") != 0)
 				continue;
 			ndctl_region_foreach(bus, region)
 				ndctl_region_disable_invalidate(region);
@@ -280,5 +280,30 @@ retry:
 			NULL, NULL, NULL, NULL);
 	if (rc)
 		kmod_unref(*ctx);
-	return rc;
+
+	if (!nd_ctx)
+		return rc;
+
+	ndctl_bus_foreach (nd_ctx, bus) {
+		struct ndctl_region *region;
+		struct ndctl_dimm *dimm;
+
+		if (strcmp(ndctl_bus_get_provider(bus), "nfit_test.0") != 0)
+			continue;
+
+		ndctl_region_foreach (bus, region)
+			ndctl_region_disable_invalidate(region);
+
+		ndctl_dimm_foreach (bus, dimm) {
+			ndctl_dimm_read_label_index(dimm);
+			ndctl_dimm_init_labels(dimm, NDCTL_NS_VERSION_1_2);
+			ndctl_dimm_disable(dimm);
+			ndctl_dimm_enable(dimm);
+		}
+
+		ndctl_region_foreach (bus, region)
+			ndctl_region_enable(region);
+	}
+
+	return 0;
 }
diff --git a/test/libndctl.c b/test/libndctl.c
index 391b94086dae..0d6b9dd5b04b 100644
--- a/test/libndctl.c
+++ b/test/libndctl.c
@@ -2588,17 +2588,41 @@ static int check_dimms(struct ndctl_bus *bus, struct dimm *dimms, int n,
 	return 0;
 }
 
-static void reset_bus(struct ndctl_bus *bus)
+enum dimm_reset {
+	DIMM_INIT,
+	DIMM_ZERO,
+};
+
+static int reset_dimms(struct ndctl_bus *bus, enum dimm_reset reset)
 {
-	struct ndctl_region *region;
 	struct ndctl_dimm *dimm;
+	int rc = 0;
+
+	ndctl_dimm_foreach(bus, dimm) {
+		if (reset == DIMM_ZERO)
+			ndctl_dimm_zero_labels(dimm);
+		else {
+			ndctl_dimm_read_label_index(dimm);
+			ndctl_dimm_init_labels(dimm, NDCTL_NS_VERSION_1_2);
+		}
+		ndctl_dimm_disable(dimm);
+		rc = ndctl_dimm_enable(dimm);
+		if (rc)
+			break;
+	}
+
+	return rc;
+}
+
+static void reset_bus(struct ndctl_bus *bus, enum dimm_reset reset)
+{
+	struct ndctl_region *region;
 
 	/* disable all regions so that set_config_data commands are permitted */
 	ndctl_region_foreach(bus, region)
 		ndctl_region_disable_invalidate(region);
 
-	ndctl_dimm_foreach(bus, dimm)
-		ndctl_dimm_zero_labels(dimm);
+	reset_dimms(bus, reset);
 
 	/* set regions back to their default state */
 	ndctl_region_foreach(bus, region)
@@ -2609,7 +2633,6 @@ static int do_test0(struct ndctl_ctx *ctx, struct ndctl_test *test)
 {
 	struct ndctl_bus *bus = ndctl_bus_get_by_provider(ctx, NFIT_PROVIDER0);
 	struct ndctl_region *region;
-	struct ndctl_dimm *dimm;
 	int rc;
 
 	if (!bus)
@@ -2626,13 +2649,10 @@ static int do_test0(struct ndctl_ctx *ctx, struct ndctl_test *test)
 	if (rc)
 		return rc;
 
-	ndctl_dimm_foreach(bus, dimm) {
-		rc = ndctl_dimm_zero_labels(dimm);
-		if (rc < 0) {
-			fprintf(stderr, "failed to zero %s\n",
-					ndctl_dimm_get_devname(dimm));
-			return rc;
-		}
+	rc = reset_dimms(bus, DIMM_INIT);
+	if (rc < 0) {
+		fprintf(stderr, "failed to reset dimms\n");
+		return rc;
 	}
 
 	/*
@@ -2650,14 +2670,14 @@ static int do_test0(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), DAX);
 		if (rc)
 			return rc;
-		reset_bus(bus);
+		reset_bus(bus, DIMM_INIT);
 	}
 
 	if (ndctl_test_attempt(test, KERNEL_VERSION(4, 8, 0))) {
 		rc = check_regions(bus, regions0, ARRAY_SIZE(regions0), PFN);
 		if (rc)
 			return rc;
-		reset_bus(bus);
+		reset_bus(bus, DIMM_INIT);
 	}
 
 	return check_regions(bus, regions0, ARRAY_SIZE(regions0), BTT);
@@ -2672,6 +2692,7 @@ static int do_test1(struct ndctl_ctx *ctx, struct ndctl_test *test)
 		return -ENXIO;
 
 	ndctl_bus_wait_probe(bus);
+	reset_bus(bus, DIMM_ZERO);
 
 	/*
 	 * Starting with v4.10 the dimm on nfit_test.1 gets a unique


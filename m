Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4729821E95DE3
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 19:15:24 -0700 (PDT)
Subject: [ndctl PATCH v2 08/10] ndctl: refresh region type after init_labels
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 19:11:41 -0700
Message-ID: <150405910100.22171.16178052413106856140.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150405905872.22171.7217183939530397385.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150405905872.22171.7217183939530397385.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: Ryon Jensen <ryon.jensen@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Given that init_labels can change a region from hosting namespaces with
an 'nstype' of ND_DEVICE_NAMESPACE_IO to ND_DEVICE_NAMESPACE_PMEM,
arrange for ndctl_dimm_init_labels() to trigger the region to refresh
these attributes when it is next enabled.

Reported-by: Ryon Jensen <ryon.jensen@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/dimm.c     |   12 ++++++++++++
 ndctl/lib/libndctl.c |   11 +++++++++++
 ndctl/lib/private.h  |    2 ++
 3 files changed, 25 insertions(+)

diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
index 0fd8d9e30b93..49cf7cb9be6f 100644
--- a/ndctl/lib/dimm.c
+++ b/ndctl/lib/dimm.c
@@ -422,8 +422,10 @@ static int write_label_index(struct ndctl_dimm *dimm,
 NDCTL_EXPORT int ndctl_dimm_init_labels(struct ndctl_dimm *dimm,
 		enum ndctl_namespace_version v)
 {
+	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	struct nvdimm_data *ndd = &dimm->ndd;
+	struct ndctl_region *region;
 	int i;
 
 	if (!ndd->cmd_read) {
@@ -432,6 +434,16 @@ NDCTL_EXPORT int ndctl_dimm_init_labels(struct ndctl_dimm *dimm,
 		return -EINVAL;
 	}
 
+	ndctl_region_foreach(bus, region) {
+		struct ndctl_dimm *match;
+
+		ndctl_dimm_foreach_in_region(region, match)
+			if (match == dimm) {
+				region_flag_refresh(region);
+				break;
+			}
+	}
+
 	for (i = 0; i < 2; i++) {
 		int rc;
 
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 9c65646ac3e9..f52ecfe9d142 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -152,6 +152,7 @@ struct ndctl_region {
 	int btts_init;
 	int pfns_init;
 	int daxs_init;
+	int refresh_type;
 	unsigned long long size;
 	char *region_path;
 	char *region_buf;
@@ -2400,10 +2401,20 @@ NDCTL_EXPORT int ndctl_region_enable(struct ndctl_region *region)
 		return -ENXIO;
 	}
 
+	if (region->refresh_type) {
+		region->refresh_type = 0;
+		region_set_type(region, region->region_buf);
+	}
+
 	dbg(ctx, "%s: enabled\n", devname);
 	return 0;
 }
 
+void region_flag_refresh(struct ndctl_region *region)
+{
+	region->refresh_type = 1;
+}
+
 NDCTL_EXPORT void ndctl_region_cleanup(struct ndctl_region *region)
 {
 	free_stale_namespaces(region);
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 808e77da07ca..cfea5f75fcde 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -101,6 +101,8 @@ struct ndctl_dimm {
 	int format[0];
 };
 
+void region_flag_refresh(struct ndctl_region *region);
+
 /**
  * struct ndctl_ctx - library user context to find "nd" instances
  *

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B725A22526491
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 14:22:07 -0700 (PDT)
Subject: [ndctl PATCH 3/5] ndctl, scrub: add ndctl_bus_start_scrub()
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 04 Apr 2018 14:12:11 -0700
Message-ID: <152287633188.29230.414462016357911772.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152287631592.29230.11531789298631204393.stgit@dwillia2-desk3.amr.corp.intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Provide a helper routine to kick off a new ARS scrub if one is not
already running, or otherwise detect if ARS functionality is available.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |   13 +++++++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h       |    1 +
 3 files changed, 15 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index ff0d44ffefe6..21dd7207ea5e 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -1146,6 +1146,19 @@ static int __ndctl_bus_get_scrub_state(struct ndctl_bus *bus,
 	}
 }
 
+NDCTL_EXPORT int ndctl_bus_start_scrub(struct ndctl_bus *bus)
+{
+	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
+	int rc;
+
+	rc = sysfs_write_attr(ctx, bus->scrub_path, "1\n");
+	if (rc == -EBUSY)
+		return rc;
+	else if (rc < 0)
+		return -EOPNOTSUPP;
+	return 0;
+}
+
 NDCTL_EXPORT int ndctl_bus_get_scrub_state(struct ndctl_bus *bus)
 {
 	unsigned int scrub_count = 0;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index 06cace96724f..fd8f37d1783e 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -353,4 +353,5 @@ global:
 	ndctl_region_get_persistence_domain;
 	ndctl_bus_get_persistence_domain;
 	ndctl_bus_get_scrub_state;
+	ndctl_bus_start_scrub;
 } LIBNDCTL_14;
diff --git a/ndctl/libndctl.h b/ndctl/libndctl.h
index 36c04d871bd5..e690f9483fbf 100644
--- a/ndctl/libndctl.h
+++ b/ndctl/libndctl.h
@@ -122,6 +122,7 @@ int ndctl_bus_wait_probe(struct ndctl_bus *bus);
 int ndctl_bus_wait_for_scrub_completion(struct ndctl_bus *bus);
 unsigned int ndctl_bus_get_scrub_count(struct ndctl_bus *bus);
 int ndctl_bus_get_scrub_state(struct ndctl_bus *bus);
+int ndctl_bus_start_scrub(struct ndctl_bus *bus);
 int ndctl_bus_has_error_injection(struct ndctl_bus *bus);
 
 struct ndctl_dimm;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

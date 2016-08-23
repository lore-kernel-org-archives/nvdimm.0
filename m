Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 46FC51A1E3D
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 16:07:35 -0700 (PDT)
Subject: [ndctl PATCH 2/3] ndctl: add ndctl_dimm_get_health_eventfd() api
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 16:05:11 -0700
Message-ID: <147199351158.5587.16951459101164630768.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147199350116.5587.2852255825958647760.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147199350116.5587.2852255825958647760.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Return a poll(2) capable file descriptor that triggers whenever an
nvdimm device receives an ACPI 6.1 health event notification.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c   |   11 +++++++++++
 ndctl/lib/libndctl.sym |    1 +
 ndctl/libndctl.h.in    |    1 +
 3 files changed, 13 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 5f354ac0fa7a..205fef17a151 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -139,6 +139,7 @@ struct ndctl_dimm {
 	char *unique_id;
 	char *dimm_path;
 	char *dimm_buf;
+	int health_eventfd;
 	int buf_len;
 	int id;
 	union {
@@ -591,6 +592,8 @@ static void free_dimm(struct ndctl_dimm *dimm)
 	free(dimm->dimm_path);
 	if (dimm->module)
 		kmod_module_unref(dimm->module);
+	if (dimm->health_eventfd > -1)
+		close(dimm->health_eventfd);
 	free(dimm);
 }
 
@@ -1169,6 +1172,7 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	dimm->vendor_id = -1;
 	dimm->device_id = -1;
 	dimm->revision_id = -1;
+	dimm->health_eventfd = -1;
 	dimm->subsystem_vendor_id = -1;
 	dimm->subsystem_device_id = -1;
 	dimm->subsystem_revision_id = -1;
@@ -1250,6 +1254,8 @@ static int add_dimm(void *parent, int id, const char *dimm_base)
 	sprintf(path, "%s/nfit/flags", dimm_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		parse_nfit_mem_flags(dimm, buf);
+
+	dimm->health_eventfd = open(path, O_RDONLY|O_CLOEXEC);
  out:
 	list_add(&bus->dimms, &dimm->list);
 	free(path);
@@ -1429,6 +1435,11 @@ NDCTL_EXPORT int ndctl_dimm_is_cmd_supported(struct ndctl_dimm *dimm,
 	return !!(dimm->dsm_mask & (1ULL << cmd));
 }
 
+NDCTL_EXPORT int ndctl_dimm_get_health_eventfd(struct ndctl_dimm *dimm)
+{
+	return dimm->health_eventfd;
+}
+
 NDCTL_EXPORT unsigned int ndctl_dimm_handle_get_node(struct ndctl_dimm *dimm)
 {
 	return dimm->handle >> 16 & 0xfff;
diff --git a/ndctl/lib/libndctl.sym b/ndctl/lib/libndctl.sym
index b5d286683732..dfc44ae51362 100644
--- a/ndctl/lib/libndctl.sym
+++ b/ndctl/lib/libndctl.sym
@@ -62,6 +62,7 @@ global:
 	ndctl_dimm_failed_restore;
 	ndctl_dimm_smart_pending;
 	ndctl_dimm_failed_flush;
+	ndctl_dimm_get_health_eventfd;
 	ndctl_dimm_is_cmd_supported;
 	ndctl_dimm_handle_get_node;
 	ndctl_dimm_handle_get_socket;
diff --git a/ndctl/libndctl.h.in b/ndctl/libndctl.h.in
index 451466aedb7e..00bce4298958 100644
--- a/ndctl/libndctl.h.in
+++ b/ndctl/libndctl.h.in
@@ -143,6 +143,7 @@ int ndctl_dimm_failed_arm(struct ndctl_dimm *dimm);
 int ndctl_dimm_failed_restore(struct ndctl_dimm *dimm);
 int ndctl_dimm_smart_pending(struct ndctl_dimm *dimm);
 int ndctl_dimm_failed_flush(struct ndctl_dimm *dimm);
+int ndctl_dimm_get_health_eventfd(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_handle_get_node(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_handle_get_socket(struct ndctl_dimm *dimm);
 unsigned int ndctl_dimm_handle_get_imc(struct ndctl_dimm *dimm);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

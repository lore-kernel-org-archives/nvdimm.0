Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCF1E21D0B67E
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 11:37:53 -0700 (PDT)
Subject: [ndctl PATCH 5/6] daxctl,
 list: clarify output when multiple regions share an id
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 11:33:22 -0700
Message-ID: <150048920249.12895.6274906882005240312.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <150048917662.12895.15953645444185664230.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The region id is meant to uniquely identify a host memory range, but in
the case of the libnvdimm namespace the host memory range may be
sub-divided into multiple namespaces leading to ambiguous output like
the following

    # daxctl list -R
    [
      {
        "id":1,
        "size":1054867456,
        "align":2097152
      },
      {
        "id":1,
        "size":1054867456,
        "align":2097152
      },
      {
        "id":1,
        "size":1054867456,
        "align":2097152
      },
      {
        "id":1,
        "size":1054867456,
        "align":2097152
      }
    ]

Teach util_dax_region_to_json() to emit the host device path, but be
careful to only do this when it is not being called through ndctl. In
the 'ndctl list -X' case including the host path information is
redundant. Note, we use the path rather than the device-name since the
name is not descriptive enough to disambiguate dax-regions.

    # daxctl list -R
    [
      {
        "path":"\/LNXSYSTM:00\/LNXSYBUS:00\/ACPI0012:00\/ndbus1\/region1\/dax1.3",
        "id":1,
        "size":1054867456,
        "align":2097152
      },
      {
        "path":"\/LNXSYSTM:00\/LNXSYBUS:00\/ACPI0012:00\/ndbus1\/region1\/dax1.1",
        "id":1,
        "size":1054867456,
        "align":2097152
      },
      {
        "path":"\/LNXSYSTM:00\/LNXSYBUS:00\/ACPI0012:00\/ndbus1\/region1\/dax1.2",
        "id":1,
        "size":1054867456,
        "align":2097152
      },
      {
        "path":"\/LNXSYSTM:00\/LNXSYBUS:00\/ACPI0012:00\/ndbus1\/region1\/dax1.4",
        "id":1,
        "size":1054867456,
        "align":2097152
      }
    ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c   |    5 +++++
 daxctl/lib/libdaxctl.sym |    5 +++++
 daxctl/libdaxctl.h       |    2 ++
 daxctl/list.c            |    2 +-
 ndctl/list.c             |    2 +-
 ndctl/namespace.c        |    2 +-
 util/json.c              |   20 +++++++++++++++++++-
 util/json.h              |    3 ++-
 8 files changed, 36 insertions(+), 5 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 0919ea47d817..89f8cc8e69ff 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -378,6 +378,11 @@ DAXCTL_EXPORT const char *daxctl_region_get_devname(struct daxctl_region *region
 	return region->devname;
 }
 
+DAXCTL_EXPORT const char *daxctl_region_get_path(struct daxctl_region *region)
+{
+	return region->region_path;
+}
+
 DAXCTL_EXPORT unsigned long long daxctl_region_get_available_size(
 		struct daxctl_region *region)
 {
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index 1b1104dbe74c..84d3a6909165 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -45,3 +45,8 @@ global:
 	daxctl_region_get_first;
 	daxctl_region_get_next;
 } LIBDAXCTL_3;
+
+LIBDAXCTL_5 {
+global:
+	daxctl_region_get_path;
+} LIBDAXCTL_4;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index b65dc3083048..77f6a25d2e30 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -49,6 +49,8 @@ unsigned long long daxctl_region_get_available_size(
 unsigned long long daxctl_region_get_size(struct daxctl_region *region);
 unsigned long daxctl_region_get_align(struct daxctl_region *region);
 const char *daxctl_region_get_devname(struct daxctl_region *region);
+const char *daxctl_region_get_path(struct daxctl_region *region);
+
 struct daxctl_dev *daxctl_region_get_dev_seed(struct daxctl_region *region);
 
 struct daxctl_dev;
diff --git a/daxctl/list.c b/daxctl/list.c
index 678ef6ce4c13..254f0ac9be79 100644
--- a/daxctl/list.c
+++ b/daxctl/list.c
@@ -34,7 +34,7 @@ static unsigned long listopts_to_flags(void)
 	unsigned long flags = 0;
 
 	if (list.devs)
-		flags |= UTIL_JSON_DAX;
+		flags |= UTIL_JSON_DAX_DEVS;
 	if (list.idle)
 		flags |= UTIL_JSON_IDLE;
 	if (list.human)
diff --git a/ndctl/list.c b/ndctl/list.c
index 7f8db6630b51..c910c776c61d 100644
--- a/ndctl/list.c
+++ b/ndctl/list.c
@@ -49,7 +49,7 @@ static unsigned long listopts_to_flags(void)
 	if (list.media_errors)
 		flags |= UTIL_JSON_MEDIA_ERRORS;
 	if (list.dax)
-		flags |= UTIL_JSON_DAX;
+		flags |= UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 	if (list.human)
 		flags |= UTIL_JSON_HUMAN;
 	return flags;
diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index a9576cefa2ce..4734ebdb22b0 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -401,7 +401,7 @@ static int setup_namespace(struct ndctl_region *region,
 		error("%s: failed to enable\n",
 				ndctl_namespace_get_devname(ndns));
 	} else {
-		unsigned long flags = UTIL_JSON_DAX;
+		unsigned long flags = UTIL_JSON_DAX | UTIL_JSON_DAX_DEVS;
 		struct json_object *jndns;
 
 		if (isatty(1))
diff --git a/util/json.c b/util/json.c
index 25188a61064f..559a022ae405 100644
--- a/util/json.c
+++ b/util/json.c
@@ -306,6 +306,24 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 	if (!jregion)
 		return NULL;
 
+	/*
+	 * The flag indicates when we are being called by an agent that
+	 * already knows about the parent device information.
+	 */
+	if (!(flags & UTIL_JSON_DAX)) {
+		/* trim off the redundant /sys/devices prefix */
+		const char *path = daxctl_region_get_path(region);
+		int len = strlen("/sys/devices");
+		const char *trim = &path[len];
+
+		if (strncmp(path, "/sys/devices", len) != 0)
+			goto err;
+		jobj = json_object_new_string(trim);
+		if (!jobj)
+			goto err;
+		json_object_object_add(jregion, "path", jobj);
+	}
+
 	jobj = json_object_new_int(daxctl_region_get_id(region));
 	if (!jobj)
 		goto err;
@@ -335,7 +353,7 @@ struct json_object *util_daxctl_region_to_json(struct daxctl_region *region,
 		json_object_object_add(jregion, "align", jobj);
 	}
 
-	if (!(flags & UTIL_JSON_DAX))
+	if (!(flags & UTIL_JSON_DAX_DEVS))
 		return jregion;
 
 	jobj = util_daxctl_devs_to_list(region, NULL, ident, flags);
diff --git a/util/json.h b/util/json.h
index d885ead2b916..d934b2e660d4 100644
--- a/util/json.h
+++ b/util/json.h
@@ -20,7 +20,8 @@ enum util_json_flags {
 	UTIL_JSON_IDLE = (1 << 0),
 	UTIL_JSON_MEDIA_ERRORS = (1 << 1),
 	UTIL_JSON_DAX = (1 << 2),
-	UTIL_JSON_HUMAN = (1 << 3),
+	UTIL_JSON_DAX_DEVS = (1 << 3),
+	UTIL_JSON_HUMAN = (1 << 4),
 };
 
 struct json_object;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

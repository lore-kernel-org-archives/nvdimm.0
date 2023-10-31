Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EA9225CD
	for <nvdimm@lists.linux.dev>; Tue, 31 Oct 2023 21:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="M20vTla8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698787247; x=1730323247;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eaaNHAKc3qzYecY+CBu5UqPJXE/+6KT5/W41ndHAMWE=;
  b=M20vTla8nEVdQHptRAYm4UmYEhTWbfaNlMWXEHSYY3YY9Vw9Rym1zROP
   bKD7Fpe4NR1gJxMRiQARCa7qCLvtX7Kn30GlbgDtr0aGxvaFfD/sU9+p4
   Gqrd214gvykyzuJM/AC7G5IfnsoHr7LY0aQo5qCRI4uB2ilmaa10MUWgX
   7H8abKLlBsyHdmlbnvI8E+YK2L2M6uxn5PPV9KAUEk9gtf8PPvUP5SAgB
   lLDhW1TUpqNe+Pen4W0GT39F/gD3kqN33Y5tqMcv04wqWF0UvdJ404a6w
   uSg+8cSyMZ8Cb/vmYy6C+MLJuWwQgSqVq8/chcMBoSLWK5znR8qxpgWS+
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="474615050"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="474615050"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 14:20:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10880"; a="831173766"
X-IronPort-AV: E=Sophos;i="6.03,266,1694761200"; 
   d="scan'208";a="831173766"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.213.179.50])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Oct 2023 14:20:46 -0700
Subject: [NDCTL PATCH v3] cxl/region: Add -f option for disable-region
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, yangx.jy@fujitsu.com
Date: Tue, 31 Oct 2023 14:20:45 -0700
Message-ID: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The current operation for disable-region does not check if the memory
covered by a region is online before attempting to disable the cxl region.
Have the tool attempt to offline the relevant memory before attempting to
disable the region(s). If offline fails, stop and return error.

Provide a -f option for the region to continue disable the region even if
the memory is not offlined. Add a warning to state that the physical
memory is being leaked and unrecoverable unless reboot due to disable without
offline.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>

---
v3:
- Remove movable check. (Dan)
- Attempt to offline if not offline. -f will disable region anyways even
  if memory not offline. (Dan)
v2:
- Update documentation and help output. (Vishal)
---
 Documentation/cxl/cxl-disable-region.txt |   10 ++++++
 cxl/region.c                             |   54 +++++++++++++++++++++++++++++-
 2 files changed, 63 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
index 4b0625e40bf6..9abf19e96094 100644
--- a/Documentation/cxl/cxl-disable-region.txt
+++ b/Documentation/cxl/cxl-disable-region.txt
@@ -14,6 +14,10 @@ SYNOPSIS
 
 include::region-description.txt[]
 
+If there are memory blocks that are still online, the operation will attempt to
+offline the relevant blocks. If the offlining fails, the operation fails when not
+using the -f (force) parameter.
+
 EXAMPLE
 -------
 ----
@@ -27,6 +31,12 @@ OPTIONS
 -------
 include::bus-option.txt[]
 
+-f::
+--force::
+	Attempt to disable-region even though memory cannot be offlined successfully.
+	Will emit warning that operation will permanently leak phiscal address space
+	and cannot be recovered until a reboot.
+
 include::decoder-option.txt[]
 
 include::debug-option.txt[]
diff --git a/cxl/region.c b/cxl/region.c
index bcd703956207..5cbbf2749e2d 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -14,6 +14,7 @@
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/short_types/short_types.h>
+#include <daxctl/libdaxctl.h>
 
 #include "filter.h"
 #include "json.h"
@@ -95,6 +96,8 @@ static const struct option enable_options[] = {
 
 static const struct option disable_options[] = {
 	BASE_OPTIONS(),
+	OPT_BOOLEAN('f', "force", &param.force,
+		    "attempt to offline memory before disabling the region"),
 	OPT_END(),
 };
 
@@ -789,13 +792,62 @@ static int destroy_region(struct cxl_region *region)
 	return cxl_region_delete(region);
 }
 
+static int disable_region(struct cxl_region *region)
+{
+	const char *devname = cxl_region_get_devname(region);
+	struct daxctl_region *dax_region;
+	struct daxctl_memory *mem;
+	struct daxctl_dev *dev;
+	int failed = 0, rc;
+
+	dax_region = cxl_region_get_daxctl_region(region);
+	if (!dax_region)
+		goto out;
+
+	daxctl_dev_foreach(dax_region, dev) {
+		mem = daxctl_dev_get_memory(dev);
+		if (!mem)
+			return -ENXIO;
+
+		/*
+		 * If memory is still online and user wants to force it, attempt
+		 * to offline it.
+		 */
+		if (daxctl_memory_is_online(mem)) {
+			rc = daxctl_memory_offline(mem);
+			if (rc < 0) {
+				log_err(&rl, "%s: unable to offline %s: %s\n",
+					devname,
+					daxctl_dev_get_devname(dev),
+					strerror(abs(rc)));
+				if (!param.force)
+					return rc;
+
+				failed++;
+			}
+		}
+	}
+
+	if (failed) {
+		log_err(&rl, "%s: Forcing region disable without successful offline.\n",
+			devname);
+		log_err(&rl, "%s: Physical address space has now been permanently leaked.\n",
+			devname);
+		log_err(&rl, "%s: Leaked address cannot be recovered until a reboot.\n",
+			devname);
+	}
+
+out:
+	return cxl_region_disable(region);
+}
+
 static int do_region_xable(struct cxl_region *region, enum region_actions action)
 {
 	switch (action) {
 	case ACTION_ENABLE:
 		return cxl_region_enable(region);
 	case ACTION_DISABLE:
-		return cxl_region_disable(region);
+		return disable_region(region);
 	case ACTION_DESTROY:
 		return destroy_region(region);
 	default:



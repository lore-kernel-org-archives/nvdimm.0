Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B698D1350EF
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 20:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129698; cv=none; b=tKLIddI1UZFxXXZAZA0HA5N7JsSMc21maSLj2TRbCWa61mzvGQXKMPzKM7qhDxLSrEbYVN7aiOgtdEeE8v5RhX+/lHBSnU8Gw53iKUUGI07srtlEwKgcunourEG85Ca2PEwmm4yn5TN27fKxq29F2Usr35uBTeIq4f8VL3h9p1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129698; c=relaxed/simple;
	bh=TQh0gLZcVHOscEUZ7WQ90vJ/X1HrzAGoDghtc/r2lMQ=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L/xUaJEDsdsPtDZcgi6HE87w91BBeCYkxyqR/YbDkk9B0xHnky0hS25Sik0Q+ka2xEWv6NOdCoknDSAy6T6XIpnBV1ar/S86Utnk/zoYATCEvWitD55878d0hQyir1KcsnnqDGs/GFSSBvVQbj161br6uTkIHt1Vaqtw1WLOI6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ESn0VwY0; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ESn0VwY0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706129696; x=1737665696;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TQh0gLZcVHOscEUZ7WQ90vJ/X1HrzAGoDghtc/r2lMQ=;
  b=ESn0VwY0MprQoehpkinAhHJY++l8MSD3iYK1xj8ACVNHVroNClaI4Ev9
   ZuqmlZRw+3/fTHn7V0kSo4x/xkgXawjUgKe8dEG95tV3YPQ87RBbz0UtI
   dCi3VQGc3TkZJUkPOk7lp588FAdZrMyA7bJwSEP1hu5m91oiaRjxEByvR
   hVq4RkkwTjCKxrrJDVDCs9XHzeWA00aV/VvLAM9i5SspH2U2OIlKvZNdg
   9S3dohypQasqdDMRkF0DWOrgIYEfOl8JjaD3dNcnwWH9IWTpuwXqsf3lB
   ZjXQFlRWqTTsUTm1i/KBocEaP2thZERB8wQn/d8JY/JIVszU7X214wQL5
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="20524182"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="20524182"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 12:54:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="786538980"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="786538980"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.209.164.29])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 12:54:54 -0800
Subject: [NDCTL PATCH v3 3/3] ndctl: cxl: add QoS class check for CXL region
 creation
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 24 Jan 2024 13:54:54 -0700
Message-ID: <170612969410.2745924.538640158518770317.stgit@djiang5-mobl3>
In-Reply-To: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The CFMWS provides a QTG ID. The kernel driver creates a root decoder that
represents the CFMWS. A qos_class attribute is exported via sysfs for the root
decoder.

One or more QoS class tokens are retrieved via QTG ID _DSM from the ACPI0017
device for a CXL memory device. The input for the _DSM is the read and write
latency and bandwidth for the path between the device and the CPU. The
numbers are constructed by the kernel driver for the _DSM input. When a
device is probed, QoS class tokens  are retrieved. This is useful for a
hot-plugged CXL memory device that does not have regions created.

Add a check for config check during region creation. Emit a warning if the
QoS class token from the root decoder is different than the mem device QoS
class token. User parameter options are provided to fail instead of just
warning.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v3:
- Rebase to pending branch
---
 Documentation/cxl/cxl-create-region.txt |    9 ++++
 cxl/region.c                            |   67 +++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index f11a412bddfe..9ab2e0fee152 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -105,6 +105,15 @@ include::bus-option.txt[]
 	supplied, the first cross-host bridge (if available), decoder that
 	supports the largest interleave will be chosen.
 
+-e::
+--strict::
+	Enforce strict execution where any potential error will force failure.
+	For example, if QTG ID mismatches will cause failure.
+
+-q::
+--no-enforce-qtg::
+	Parameter to bypass QTG ID mismatch failure. Will only emit warning.
+
 include::human-option.txt[]
 
 include::debug-option.txt[]
diff --git a/cxl/region.c b/cxl/region.c
index 3a762db4800e..00dd63e160df 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -32,6 +32,8 @@ static struct region_params {
 	bool force;
 	bool human;
 	bool debug;
+	bool strict;
+	bool no_qtg;
 } param = {
 	.ways = INT_MAX,
 	.granularity = INT_MAX,
@@ -49,6 +51,8 @@ struct parsed_params {
 	const char **argv;
 	struct cxl_decoder *root_decoder;
 	enum cxl_decoder_mode mode;
+	bool strict;
+	bool no_qtg;
 };
 
 enum region_actions {
@@ -81,7 +85,9 @@ OPT_STRING('U', "uuid", &param.uuid, \
 	   "region uuid", "uuid for the new region (default: autogenerate)"), \
 OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
 	    "non-option arguments are memdevs"), \
-OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
+OPT_BOOLEAN('e', "strict", &param.strict, "strict execution enforcement"), \
+OPT_BOOLEAN('q', "no-enforce-qtg", &param.no_qtg, "no enforce of QTG ID")
 
 static const struct option create_options[] = {
 	BASE_OPTIONS(),
@@ -360,6 +366,9 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 		}
 	}
 
+	p->strict = param.strict;
+	p->no_qtg = param.no_qtg;
+
 	return 0;
 
 err:
@@ -467,6 +476,60 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 		p->mode = CXL_DECODER_MODE_PMEM;
 }
 
+static bool region_qos_match_decoder(struct qos_class *qos_class, int decoder_qc)
+{
+	int i;
+
+	for (i = 0; i < qos_class->nr; i++) {
+		if (qos_class->qos[i] == decoder_qc)
+			return true;
+	}
+
+	return false;
+}
+
+static int create_region_validate_qtg_id(struct cxl_ctx *ctx,
+					 struct parsed_params *p)
+{
+	struct qos_class *qos_class;
+	int root_qos_class, i;
+
+	root_qos_class = cxl_root_decoder_get_qos_class(p->root_decoder);
+	if (root_qos_class == CXL_QOS_CLASS_NONE)
+		return 0;
+
+	for (i = 0; i < p->ways; i++) {
+		struct json_object *jobj =
+			json_object_array_get_idx(p->memdevs, i);
+		struct cxl_memdev *memdev = json_object_get_userdata(jobj);
+
+		if (p->mode == CXL_DECODER_MODE_RAM)
+			qos_class = cxl_memdev_get_ram_qos_class(memdev);
+		else
+			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
+
+		/* No qos_class entries. Possibly no kernel support */
+		if (qos_class->nr == 0)
+			break;
+
+		if (!region_qos_match_decoder(qos_class, root_qos_class)) {
+			if (p->strict && !p->no_qtg) {
+				log_err(&rl, "%s QoS Class mismatches %s\n",
+					cxl_decoder_get_devname(p->root_decoder),
+					cxl_memdev_get_devname(memdev));
+
+				return -ENXIO;
+			}
+
+			log_notice(&rl, "%s QoS Class mismatches %s\n",
+				   cxl_decoder_get_devname(p->root_decoder),
+				   cxl_memdev_get_devname(memdev));
+		}
+	}
+
+	return 0;
+}
+
 static int create_region_validate_config(struct cxl_ctx *ctx,
 					 struct parsed_params *p)
 {
@@ -507,6 +570,8 @@ found:
 		return rc;
 
 	collect_minsize(ctx, p);
+	create_region_validate_qtg_id(ctx, p);
+
 	return 0;
 }
 



Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564D224EAA
	for <nvdimm@lists.linux.dev>; Thu, 25 May 2023 21:40:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685050851; x=1716586851;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=h5+BYTn34dKRvjo01UvMzf0XfpcyIImS3ZYUZuVu0mQ=;
  b=IyzhtKmEf1p68NTiooB6wDJwYZBXUZWzzi6zEdcDABvdlX0/PCaS26an
   iobRYMfLlvd4I93yZRG+F4gCzVZy0ju/gKqbBmDLifnV76juo533ZNzoq
   IkeoArO4rABAEomRbkLbvv96lOpoXnshKywzCim3f6iw2Nwmmtpi/q9I1
   gf/u8alIhW02RdOd02l5aoNE5WNZZceUuIYMfaJfQDi371cvH+5CeQdFQ
   Tw75PPo+Bdz6bVNFtcN10Vzva1R3kC5NU/bGGCoKkT7oobBn4azZZf/ky
   BYL6CA76gT1MH7zmJoFGkGT6QY0KHawAObdCKgZ2EMI5ZFmSCyUFUQMBq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351544793"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="351544793"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 14:40:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="879297386"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="879297386"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.212.85.172])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 14:40:50 -0700
Subject: [ndctl PATCH v2 3/3] ndctl: cxl: add QoS class check for CXL region
 creation
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 25 May 2023 14:40:49 -0700
Message-ID: <168505084955.2768411.12826239064018270742.stgit@djiang5-mobl3>
In-Reply-To: <168505076089.2768411.10498775803334230215.stgit@djiang5-mobl3>
References: <168505076089.2768411.10498775803334230215.stgit@djiang5-mobl3>
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
 Documentation/cxl/cxl-create-region.txt |    9 ++++
 cxl/region.c                            |   63 +++++++++++++++++++++++++++++++
 2 files changed, 71 insertions(+), 1 deletion(-)

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
index 45f0c6a3771c..03fd862afc89 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -31,6 +31,8 @@ static struct region_params {
 	bool force;
 	bool human;
 	bool debug;
+	bool strict;
+	bool no_qtg;
 } param = {
 	.ways = INT_MAX,
 	.granularity = INT_MAX,
@@ -48,6 +50,8 @@ struct parsed_params {
 	const char **argv;
 	struct cxl_decoder *root_decoder;
 	enum cxl_decoder_mode mode;
+	bool strict;
+	bool no_qtg;
 };
 
 enum region_actions {
@@ -80,7 +84,9 @@ OPT_STRING('U', "uuid", &param.uuid, \
 	   "region uuid", "uuid for the new region (default: autogenerate)"), \
 OPT_BOOLEAN('m', "memdevs", &param.memdevs, \
 	    "non-option arguments are memdevs"), \
-OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats")
+OPT_BOOLEAN('u', "human", &param.human, "use human friendly number formats"), \
+OPT_BOOLEAN('e', "strict", &param.strict, "strict execution enforcement"), \
+OPT_BOOLEAN('q', "no-enforce-qtg", &param.no_qtg, "no enforce of QTG ID")
 
 static const struct option create_options[] = {
 	BASE_OPTIONS(),
@@ -357,6 +363,9 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 		}
 	}
 
+	p->strict = param.strict;
+	p->no_qtg = param.no_qtg;
+
 	return 0;
 }
 
@@ -460,6 +469,56 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
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
@@ -500,6 +559,8 @@ found:
 		return rc;
 
 	collect_minsize(ctx, p);
+	create_region_validate_qtg_id(ctx, p);
+
 	return 0;
 }
 



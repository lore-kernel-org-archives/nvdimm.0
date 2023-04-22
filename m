Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EC2633
	for <nvdimm@lists.linux.dev>; Sat, 22 Apr 2023 03:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682133005; x=1713669005;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=clo6OSob1Maw48Q8f5r4bj+OpAvWu1wDKgUzbfgm/a0=;
  b=MqkEB4pdbTd7CpMm+awClMS8mxoR+XnPkKcbpxp5MRD6yBwr6tnnRnRB
   kFVzXnTIk7/7Xx0UbBcxd4Rn+oDe5dskIKOmAAxtjC3OUWpJ0ia8M82AS
   BziQZQR3od8DMJ6Km1pnT5sgQOLncDtBy8VyQiqDORrURZ3WNr8VtLD0e
   0Uh1UEpUIQyplaMBV/cioVho8lYcD71DtmD7j7cYeCQIiVG7AvH66IPZC
   xcAfGxjaW3npfXz16THN4fR90Hn99eyO8E4j0UZfdLbBNtkZJSGQJe9Bz
   R/YiVrb6SH6SBN9CmwKe6cBqXNebHmJZib3Hqn1m+2WNkDFQyoHF9XpT5
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="343609098"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="343609098"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 20:10:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10687"; a="757092354"
X-IronPort-AV: E=Sophos;i="5.99,216,1677571200"; 
   d="scan'208";a="757092354"
Received: from jwostman-mobl2.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.111.101])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2023 20:10:03 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 21 Apr 2023 21:09:59 -0600
Subject: [PATCH ndctl 1/5] cxl/memdev.c: allow filtering memdevs by bus
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-vv-fw_update-v1-1-722a7a5baea3@intel.com>
References: <20230405-vv-fw_update-v1-0-722a7a5baea3@intel.com>
In-Reply-To: <20230405-vv-fw_update-v1-0-722a7a5baea3@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-2eb1a
X-Developer-Signature: v=1; a=openpgp-sha256; l=6014;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=clo6OSob1Maw48Q8f5r4bj+OpAvWu1wDKgUzbfgm/a0=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCnOAVz7StNqf6j9XFTzbD/n7L7nFkvdjyhMUAu1W7JyZ
 vqW5QxlHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjI+2hGhquld5MWd/6f/Ubr
 yi/ZhY/n6z3wFz30yMWWe+aceQprhEsZGSb/8D6xN5FT63+Jwu3mdRNPPTztsUSq/tSlJVHlJun
 PL3ACAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The family of memdev based commands implemented in memdev.c lacked an
option to filter the operation by bus. Add a helper to filter memdevs by
the bus they're under, and use it in memdev_action() which loops through
the requested memdevs. Update the man pages for all the affected
commands as well to include the bus filter option.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-disable-memdev.txt |  2 ++
 Documentation/cxl/cxl-enable-memdev.txt  |  2 ++
 Documentation/cxl/cxl-free-dpa.txt       |  2 ++
 Documentation/cxl/cxl-read-labels.txt    |  2 ++
 Documentation/cxl/cxl-reserve-dpa.txt    |  2 ++
 Documentation/cxl/cxl-set-partition.txt  |  2 ++
 Documentation/cxl/cxl-write-labels.txt   |  3 +++
 cxl/filter.h                             |  2 ++
 cxl/filter.c                             | 19 +++++++++++++++++++
 cxl/memdev.c                             |  4 ++++
 10 files changed, 40 insertions(+)

diff --git a/Documentation/cxl/cxl-disable-memdev.txt b/Documentation/cxl/cxl-disable-memdev.txt
index edd5385..d397802 100644
--- a/Documentation/cxl/cxl-disable-memdev.txt
+++ b/Documentation/cxl/cxl-disable-memdev.txt
@@ -18,6 +18,8 @@ OPTIONS
 <memory device(s)>::
 include::memdev-option.txt[]
 
+include::bus-option.txt[]
+
 -f::
 --force::
 	DANGEROUS: Override the safety measure that blocks attempts to disable
diff --git a/Documentation/cxl/cxl-enable-memdev.txt b/Documentation/cxl/cxl-enable-memdev.txt
index 088d5e0..5b5ed66 100644
--- a/Documentation/cxl/cxl-enable-memdev.txt
+++ b/Documentation/cxl/cxl-enable-memdev.txt
@@ -23,6 +23,8 @@ OPTIONS
 <memory device(s)>::
 include::memdev-option.txt[]
 
+include::bus-option.txt[]
+
 -v::
 	Turn on verbose debug messages in the library (if libcxl was built with
 	logging and debug enabled).
diff --git a/Documentation/cxl/cxl-free-dpa.txt b/Documentation/cxl/cxl-free-dpa.txt
index 73fb048..506fafd 100644
--- a/Documentation/cxl/cxl-free-dpa.txt
+++ b/Documentation/cxl/cxl-free-dpa.txt
@@ -24,6 +24,8 @@ OPTIONS
 <memory device(s)>::
 include::memdev-option.txt[]
 
+include::bus-option.txt[]
+
 -d::
 --decoder::
 	Specify the decoder to free. The CXL specification
diff --git a/Documentation/cxl/cxl-read-labels.txt b/Documentation/cxl/cxl-read-labels.txt
index 143f296..a96e7a4 100644
--- a/Documentation/cxl/cxl-read-labels.txt
+++ b/Documentation/cxl/cxl-read-labels.txt
@@ -20,6 +20,8 @@ OPTIONS
 -------
 include::labels-options.txt[]
 
+include::bus-option.txt[]
+
 -o::
 --output::
 	output file
diff --git a/Documentation/cxl/cxl-reserve-dpa.txt b/Documentation/cxl/cxl-reserve-dpa.txt
index 5e79ef2..58cc93e 100644
--- a/Documentation/cxl/cxl-reserve-dpa.txt
+++ b/Documentation/cxl/cxl-reserve-dpa.txt
@@ -24,6 +24,8 @@ OPTIONS
 <memory device(s)>::
 include::memdev-option.txt[]
 
+include::bus-option.txt[]
+
 -d::
 --decoder::
 	Specify the decoder to attempt the allocation. The CXL specification
diff --git a/Documentation/cxl/cxl-set-partition.txt b/Documentation/cxl/cxl-set-partition.txt
index f0126da..bed7f76 100644
--- a/Documentation/cxl/cxl-set-partition.txt
+++ b/Documentation/cxl/cxl-set-partition.txt
@@ -35,6 +35,8 @@ OPTIONS
 <memory device(s)>::
 include::memdev-option.txt[]
 
+include::bus-option.txt[]
+
 -t::
 --type=::
 	Type of partition, 'pmem' or 'ram' (volatile), to modify.
diff --git a/Documentation/cxl/cxl-write-labels.txt b/Documentation/cxl/cxl-write-labels.txt
index 75f42a5..8f2d139 100644
--- a/Documentation/cxl/cxl-write-labels.txt
+++ b/Documentation/cxl/cxl-write-labels.txt
@@ -21,6 +21,9 @@ not allow write access to the device's label data area.
 OPTIONS
 -------
 include::labels-options.txt[]
+
+include::bus-option.txt[]
+
 -i::
 --input::
 	input file
diff --git a/cxl/filter.h b/cxl/filter.h
index c486514..595cde7 100644
--- a/cxl/filter.h
+++ b/cxl/filter.h
@@ -36,6 +36,8 @@ struct cxl_filter_params {
 struct cxl_memdev *util_cxl_memdev_filter(struct cxl_memdev *memdev,
 					  const char *__ident,
 					  const char *serials);
+struct cxl_memdev *util_cxl_memdev_filter_by_bus(struct cxl_memdev *memdev,
+						 const char *__ident);
 struct cxl_port *util_cxl_port_filter_by_memdev(struct cxl_port *port,
 						const char *ident,
 						const char *serial);
diff --git a/cxl/filter.c b/cxl/filter.c
index 90b13be..d2ab899 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -243,6 +243,25 @@ static struct cxl_port *util_cxl_port_filter_by_bus(struct cxl_port *port,
 	return NULL;
 }
 
+struct cxl_memdev *util_cxl_memdev_filter_by_bus(struct cxl_memdev *memdev,
+						 const char *__ident)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_bus *bus;
+
+	if (!__ident)
+		return memdev;
+
+	cxl_bus_foreach(ctx, bus) {
+		if (!util_cxl_bus_filter(bus, __ident))
+			continue;
+		if (bus == cxl_memdev_get_bus(memdev))
+			return memdev;
+	}
+
+	return NULL;
+}
+
 static struct cxl_decoder *
 util_cxl_decoder_filter_by_bus(struct cxl_decoder *decoder, const char *__ident)
 {
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 0b3ad02..807e859 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -44,6 +44,8 @@ enum cxl_setpart_type {
 };
 
 #define BASE_OPTIONS() \
+OPT_STRING('b', "bus", &param.bus, "bus name", \
+	   "Limit operation to the specified bus"), \
 OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug"), \
 OPT_BOOLEAN('S', "serial", &param.serial, "use serial numbers to id memdevs")
 
@@ -753,6 +755,8 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			if (!util_cxl_memdev_filter(memdev, memdev_filter,
 						    serial_filter))
 				continue;
+			if (!util_cxl_memdev_filter_by_bus(memdev, param.bus))
+				continue;
 			found = true;
 
 			if (action == action_write) {

-- 
2.40.0


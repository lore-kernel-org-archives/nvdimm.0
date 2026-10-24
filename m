Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792816526;
	b=T/ZNepJyXMz9Tu8nlCHQ1Xufw4KOSzxP5Hx8eCBY1CAtgO7k/iBh3pXI8do1CoQa+19j
	 FwJP7zhNgskPv6t//KbYP+gzI+MkOhZjSXj6hQTWP4q79RoV5bMdvqh3QEGYR4JsmPnBI
	 RnWkZuAO14zQzi3/FQ824RfvMsWPEG+lwI/i/ZJoK1/QZIt7xTOThYbL3kBZp1y/2MIVx
	 23YOSQh6kM4KA9FfJOYG3l1OChiXgp4GeuO8sThvbB/fw+2n9ArOy3J5WPLbjl9Fy26Gt
	 wvF9LinEvKju0FpumPT8jgDzGbOKPBBq8jQFp5Dxindbl3vR0kzLWIfIlTj4uo0zAuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792816526;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=acZspWQ45Lni5iFUcI4NVyzN82GeHAPcaRBS+SFt96Q=;
	b=ZHxpD4j4cUhcgfgQVBQ/yFsD0NVrUswZ1WKgV9WwAvkgAMrAJwYtn0NDjaNTa6HeJYGd
	 hg+8eBYtF/fVotrKLTZCr39Gn8uqfE/+H+Kw1w28ZVXW0yVumjYBDuYtP3tSwdLNgVV7n
	 aGedw3jxPTwqzPsw3ezQZrKhLDg4u+NQOGx4C/j5kdbotOdUKtBNH6APtnBiujjqRDr1Y
	 PJnG1TTseeEI3Zxhu9PZlfHPRb/v7+3CKfB1zA4Y4WFDz/P1c2F2b3KECBEW7zmfauklv
	 77zrrZUSo2/mw5nQLN7F4NAvKJK2c5NyI85d/na1W0LAHA+Bq6pitra6RWKnU5QB+ig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mpaxj5TM;
	arc=none smtp.remote-ip=198.175.65.20
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4A4A606A31A
	for <nvdimm@lists.linux.dev>; Sat, 24 Oct 2026 04:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C4A4A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=mpaxj5TM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1792816524; x=1824352524;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=RP+CvxYzK1Vc7hnZ3Z8fC8dLf7zLR30V5iATXTDKtNU=;
  b=mpaxj5TMK/VNfmoMwcxqpkRcVYY7WHPlbULHe7FIveXsu5f9xca9zb6w
   al6N53VNMepGNl+5JKjj/w+cyjHu2qrXs8C/clF7JTrqp3B+wDLMqV5ES
   /TkItbtiq2SmfwjiWI6lwi/upWv+3ahrczzWLfq7DFjZhzyr5xHimIGjC
   t5iMHLAUQhOKwA9CPOb5B+HsREdjWE1a47tsFuNJIwG5bAVXtEKqlUvuD
   hVtzhS6GEossLzrNjuXVIQ/S7fr4sxWYa6Jnc9OY3uXkMsz91EhLnCmEt
   0S2ADo5Szqzis9hCNqLi+P1eyxGHvCR8nc5fxPAiH39IB2+aP6iXP9bVg
   Q==;
X-CSE-ConnectionGUID: cwA8qim8QcCOhz8kVcAgkA==
X-CSE-MsgGUID: RRodjog7QvSaz9CngI1OWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11944"; a="1590099"
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="1590099"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 21:35:24 -0700
X-CSE-ConnectionGUID: Lw36hWHxTcCUMp/HJpKHgA==
X-CSE-MsgGUID: 0p+1psMhRJahx+ZVm8HuqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,175,1787036400"; 
   d="scan'208";a="3722026"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.108.51])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Oct 2026 21:35:24 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Alison Schofield <alison.schofield@intel.com>,
	Cristian Rodriguez <yo@cristianrodriguez.net>
Subject: [ndctl PATCH] ndctl/lib: embed a fixed-size nd_cmd_pkg header in command packages
Date: Fri, 23 Oct 2026 21:35:19 -0700
Message-ID: <20261024043521.560745-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vendor and NFIT bus command packages embed struct nd_cmd_pkg before
their payloads. Since struct nd_cmd_pkg ends in a flexible array member,
Clang reports -Wgnu-variable-sized-type-not-at-end for these definitions.

A flexible array member is expected to be at the end of a structure.
Placing it before another member may cause problems with stricter
compiler bounds checking or future compiler optimizations. Incorrect
payload accesses could result in ndctl reporting bad device data or
sending malformed commands to a device.

Add struct nd_cmd_pkg_hdr containing only the fixed fields of
struct nd_cmd_pkg. Use it in the vendor and NFIT bus command packages
in place of the flexible-array structure, keeping the header at offset
zero and the existing payload definitions unchanged. Update the few
call sites that explicitly reference struct nd_cmd_pkg to use the new
type. Build-time assertions ensure the header's size, alignment, and
field offsets match the kernel UAPI definition.

Validation confirmed that the package layouts are unchanged, including
sizes, alignment, payload offsets, variable-length tails, and the
ndctl_cmd union layout. With the version string held constant, all 153
compiled objects were byte-identical to the originals under GCC and
Clang at both -O0 and -O2.

Both GCC and Clang builds pass, with all 72 Clang flexible-array warnings
eliminated. The ndctl unit test suite also passes.

Reported-by: Cristian Rodriguez <yo@cristianrodriguez.net>
Closes: https://github.com/pmem/ndctl/issues/296
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 ndctl/nd-cmd-pkg.h    | 48 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/lib/hpe1.h      |  2 +-
 ndctl/lib/hyperv.h    |  2 +-
 ndctl/lib/intel.h     |  2 +-
 ndctl/lib/msft.h      |  2 +-
 ndctl/lib/nfit.c      |  2 +-
 ndctl/lib/papr.c      |  6 +++---
 ndctl/lib/papr.h      |  2 +-
 ndctl/lib/private.h   |  1 +
 ndctl/libndctl-nfit.h |  3 ++-
 10 files changed, 60 insertions(+), 10 deletions(-)
 create mode 100644 ndctl/nd-cmd-pkg.h

diff --git a/ndctl/nd-cmd-pkg.h b/ndctl/nd-cmd-pkg.h
new file mode 100644
index 000000000000..c945467fbf70
--- /dev/null
+++ b/ndctl/nd-cmd-pkg.h
@@ -0,0 +1,48 @@
+/* SPDX-License-Identifier: LGPL-2.1 */
+/* Copyright (C) 2026 Intel Corporation. All rights reserved. */
+#ifndef __NDCTL_ND_CMD_PKG_H__
+#define __NDCTL_ND_CMD_PKG_H__
+
+#include <stddef.h>
+#include <linux/types.h>
+#include <ndctl/ndctl.h>
+
+/*
+ * struct nd_cmd_pkg ends in a flexible array, so it cannot be embedded
+ * ahead of a typed payload in ISO C. This copy of the fixed header
+ * can be. It must match the kernel uapi definition of struct nd_cmd_pkg,
+ * which the assertions below check against ndctl/ndctl.h.
+ */
+struct nd_cmd_pkg_hdr {
+	__u64   nd_family;
+	__u64   nd_command;
+	__u32   nd_size_in;
+	__u32   nd_size_out;
+	__u32   nd_reserved2[9];
+	__u32   nd_fw_size;
+};
+
+#define ND_CMD_PKG_HDR_ASSERT_OFFSET(m)					\
+	_Static_assert(offsetof(struct nd_cmd_pkg_hdr, m) ==		\
+		       offsetof(struct nd_cmd_pkg, m),			\
+		       "nd_cmd_pkg_hdr." #m " offset mismatch")
+
+ND_CMD_PKG_HDR_ASSERT_OFFSET(nd_family);
+ND_CMD_PKG_HDR_ASSERT_OFFSET(nd_command);
+ND_CMD_PKG_HDR_ASSERT_OFFSET(nd_size_in);
+ND_CMD_PKG_HDR_ASSERT_OFFSET(nd_size_out);
+ND_CMD_PKG_HDR_ASSERT_OFFSET(nd_reserved2);
+ND_CMD_PKG_HDR_ASSERT_OFFSET(nd_fw_size);
+
+#undef ND_CMD_PKG_HDR_ASSERT_OFFSET
+
+_Static_assert(sizeof(struct nd_cmd_pkg_hdr) ==
+	       offsetof(struct nd_cmd_pkg, nd_payload),
+	       "nd_cmd_pkg_hdr size mismatch");
+_Static_assert(sizeof(struct nd_cmd_pkg_hdr) == sizeof(struct nd_cmd_pkg),
+	       "nd_cmd_pkg_hdr size mismatch");
+_Static_assert(_Alignof(struct nd_cmd_pkg_hdr) ==
+	       _Alignof(struct nd_cmd_pkg),
+	       "nd_cmd_pkg_hdr alignment mismatch");
+
+#endif /* __NDCTL_ND_CMD_PKG_H__ */
diff --git a/ndctl/lib/hpe1.h b/ndctl/lib/hpe1.h
index bc19f72ca8d0..abaf1e5206e4 100644
--- a/ndctl/lib/hpe1.h
+++ b/ndctl/lib/hpe1.h
@@ -321,7 +321,7 @@ union ndn_hpe1_cmd {
 };
 
 struct ndn_pkg_hpe1 {
-	struct nd_cmd_pkg gen;
+	struct nd_cmd_pkg_hdr gen;
 	union ndn_hpe1_cmd u;
 } __attribute__((packed));
 
diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
index 45741c7cdd17..9b7432a1b74b 100644
--- a/ndctl/lib/hyperv.h
+++ b/ndctl/lib/hyperv.h
@@ -31,7 +31,7 @@ union nd_hyperv_cmd {
 } __attribute__((packed));
 
 struct nd_pkg_hyperv {
-	struct nd_cmd_pkg	gen;
+	struct nd_cmd_pkg_hdr	gen;
 	union  nd_hyperv_cmd	u;
 } __attribute__((packed));
 
diff --git a/ndctl/lib/intel.h b/ndctl/lib/intel.h
index 5aee98062a84..d59e46851a37 100644
--- a/ndctl/lib/intel.h
+++ b/ndctl/lib/intel.h
@@ -141,7 +141,7 @@ struct nd_intel_lss {
 } __attribute__((packed));
 
 struct nd_pkg_intel {
-	struct nd_cmd_pkg gen;
+	struct nd_cmd_pkg_hdr gen;
 	union {
 		struct nd_intel_smart smart;
 		struct nd_intel_smart_inject inject;
diff --git a/ndctl/lib/msft.h b/ndctl/lib/msft.h
index 8d246a5ed137..f60eb2597c74 100644
--- a/ndctl/lib/msft.h
+++ b/ndctl/lib/msft.h
@@ -41,7 +41,7 @@ union ndn_msft_cmd {
 } __attribute__((packed));
 
 struct ndn_pkg_msft {
-	struct nd_cmd_pkg	gen;
+	struct nd_cmd_pkg_hdr	gen;
 	union ndn_msft_cmd	u;
 } __attribute__((packed));
 
diff --git a/ndctl/lib/nfit.c b/ndctl/lib/nfit.c
index d85682f94406..5f8a1098197c 100644
--- a/ndctl/lib/nfit.c
+++ b/ndctl/lib/nfit.c
@@ -48,7 +48,7 @@ static int bus_has_translate_spa(struct ndctl_bus *bus)
 static struct ndctl_cmd *ndctl_bus_cmd_new_translate_spa(struct ndctl_bus *bus)
 {
 	struct ndctl_cmd *cmd;
-	struct nd_cmd_pkg *pkg;
+	struct nd_cmd_pkg_hdr *pkg;
 	struct nd_cmd_translate_spa *translate_spa;
 	size_t size, spa_length;
 
diff --git a/ndctl/lib/papr.c b/ndctl/lib/papr.c
index 7a1d5595b12e..d380e86c7bd7 100644
--- a/ndctl/lib/papr.c
+++ b/ndctl/lib/papr.c
@@ -62,7 +62,7 @@ static int papr_xlat_firmware_status(struct ndctl_cmd *cmd)
 /* Verify if the given command is supported and valid */
 static bool cmd_is_valid(struct ndctl_cmd *cmd)
 {
-	const struct nd_cmd_pkg  *ncmd = NULL;
+	const struct nd_cmd_pkg_hdr *ncmd = NULL;
 
 	if (cmd == NULL)
 		return false;
@@ -111,8 +111,8 @@ static struct ndctl_cmd *allocate_cmd(struct ndctl_dimm *dimm,
 	cmd->status = 0;
 	cmd->get_firmware_status = &papr_get_firmware_status;
 
-	/* Populate the nd_cmd_pkg contained in nd_pkg_pdsm */
-	*to_ndcmd(cmd) =  (struct nd_cmd_pkg) {
+	/* Populate the generic command header */
+	*to_ndcmd(cmd) = (struct nd_cmd_pkg_hdr) {
 		.nd_family = NVDIMM_FAMILY_PAPR,
 		.nd_command = pdsm_cmd,
 		.nd_size_in = 0,
diff --git a/ndctl/lib/papr.h b/ndctl/lib/papr.h
index 77579396a7bd..9e33823ddd47 100644
--- a/ndctl/lib/papr.h
+++ b/ndctl/lib/papr.h
@@ -8,7 +8,7 @@
 
 /* Wraps a nd_cmd generic header with pdsm header */
 struct nd_pkg_papr {
-	struct nd_cmd_pkg gen;
+	struct nd_cmd_pkg_hdr gen;
 	struct nd_pkg_pdsm pdsm;
 };
 
diff --git a/ndctl/lib/private.h b/ndctl/lib/private.h
index 46bc8908bd90..87e3747cf858 100644
--- a/ndctl/lib/private.h
+++ b/ndctl/lib/private.h
@@ -15,6 +15,7 @@
 #include <ccan/array_size/array_size.h>
 
 #include <ndctl/ndctl.h>
+#include <ndctl/nd-cmd-pkg.h>
 #include <ndctl/libndctl.h>
 #include <ndctl/libndctl-nfit.h>
 #include <ccan/endian/endian.h>
diff --git a/ndctl/libndctl-nfit.h b/ndctl/libndctl-nfit.h
index 9ec0db55776d..68fc44252910 100644
--- a/ndctl/libndctl-nfit.h
+++ b/ndctl/libndctl-nfit.h
@@ -6,6 +6,7 @@
 
 #include <linux/types.h>
 #include <ndctl/ndctl.h>
+#include <ndctl/nd-cmd-pkg.h>
 
 /*
  * libndctl-nfit.h : definitions for NFIT related commands/functions.
@@ -77,7 +78,7 @@ struct nd_cmd_ars_err_inj_stat {
 } __attribute__((packed));
 
 struct nd_cmd_bus {
-	struct nd_cmd_pkg gen;
+	struct nd_cmd_pkg_hdr gen;
 	union {
 		struct nd_cmd_ars_err_inj_stat err_inj_stat;
 		struct nd_cmd_ars_err_inj_clr err_inj_clr;
-- 
2.37.3


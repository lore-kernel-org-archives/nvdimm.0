Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C83131815E
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 10:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755167729; cv=none; b=hsnoK41rLHCOcmWoVHfv+GsTo2MAhLh9kkpgaT2Q1pm6LBJo1q4PoQvzZkGWBvf3Arq2oj0mKdb/SxLVxB+3n7oz0Ak/oTw2RtRBLHLLtBqUtjXpocznbcyu96wlmWslWqSDmESyCzkzHpeFlZ/lMCBL3/sgN9Vl1LY0YT7uJR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755167729; c=relaxed/simple;
	bh=5KY/6Z88xG7WpJfG8wj9f/E8kmUWNLlh5y12Oy3L1Jo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:content-type; b=fdutZjt1GUQH17NVmFMs8mmq4ptX86iiN+JEJVYp5SGmreC7kr5ZpX/4x4M1QJY1K7suOm5itu5n2KQ4WiuVE1v4amL3hjt4Kl9JQ7T246eXnXhvDmVJCjNOmaJbRTdd0vBPds3Qk5pxChrjDlFnFa58jCWHJh3AaiT3HvWM6UM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ejtQTp9o; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ejtQTp9o"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755167726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5tuftH4Jby4W6v9QLUI9M9VH/qC8GTi6wgPWA8Blp4g=;
	b=ejtQTp9ov2dDOUJoKQBb5ci7k+tTCwYgCsflvTgWm3Y7L2MAXhwCzP+EDMes8Cc/27NTGg
	7xWZ4qSSwKj6G9BqKDKGnBeCKOFnSVp5FJ48majpDJ+uT7NUlUWNeqdsjRWrJb/4N7CrHs
	1C+z3o62HSXuSbZbUlkdNvlrpgGG7qc=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-196--DrsSdiWPI--4L0a1zPJCw-1; Thu,
 14 Aug 2025 06:35:23 -0400
X-MC-Unique: -DrsSdiWPI--4L0a1zPJCw-1
X-Mimecast-MFC-AGG-ID: -DrsSdiWPI--4L0a1zPJCw_1755167721
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1AE1D18004A7;
	Thu, 14 Aug 2025 10:35:21 +0000 (UTC)
Received: from vm-10-0-76-146.hosted.upshift.rdu2.redhat.com (vm-10-0-76-146.hosted.upshift.rdu2.redhat.com [10.0.76.146])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3821418003FC;
	Thu, 14 Aug 2025 10:35:19 +0000 (UTC)
From: Yi Zhang <yi.zhang@redhat.com>
To: nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	linux-cxl@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>
Subject: [ndctl PATCH v3] ndctl: fix user visible spelling errors
Date: Thu, 14 Aug 2025 06:07:01 -0400
Message-ID: <20250814100701.2056883-1-yi.zhang@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: M4DH5OSMihZQONqdjHp_A8Mi7L6QyMembv7aLCTyU7A_1755167721
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true

The spelling errors are from
- log_err(), fprintf(), dbg() output messages
- echo statemetns in test scripts
- Documentation/*.txt files

Corrected user-visible spelling errors include:
- identifer -> identifier (log_err in cxl/bus.c)
- santize -> sanitize (fprintf in ndctl/dimm.c)
- sucessfully -> successfully (dbg in ndctl/lib/ars.c, ndctl/lib/libndctl.c)
- succeded -> succeeded (echo in test/daxctl-devices.sh)
- Documentation fixes in 4 .txt files

All the spelling errors were identified by the codespell project:
https://github.com/codespell-project/codespell

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
---
changes from v2:
- Only fix the user visible spelling errors
changes from v1:
- Add reviewed-by tag
- Add more details about the typos and how they were caught
---
 Documentation/cxl/cxl-reserve-dpa.txt          | 2 +-
 Documentation/cxl/lib/libcxl.txt               | 2 +-
 Documentation/daxctl/daxctl-create-device.txt  | 2 +-
 Documentation/ndctl/ndctl-create-namespace.txt | 4 ++--
 cxl/bus.c                                      | 2 +-
 ndctl/dimm.c                                   | 2 +-
 ndctl/lib/ars.c                                | 4 ++--
 ndctl/lib/libndctl.c                           | 4 ++--
 test/daxctl-devices.sh                         | 4 ++--
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/cxl/cxl-reserve-dpa.txt b/Documentation/cxl/cxl-reserve-dpa.txt
index 58cc93e..d51ccd6 100644
--- a/Documentation/cxl/cxl-reserve-dpa.txt
+++ b/Documentation/cxl/cxl-reserve-dpa.txt
@@ -38,7 +38,7 @@ include::bus-option.txt[]
 -t::
 --type::
 	Select the partition for the allocation. CXL devices implement a
-	partition that divdes 'ram' and 'pmem' capacity, where 'pmem' capacity
+	partition that divides 'ram' and 'pmem' capacity, where 'pmem' capacity
 	consumes the higher DPA capacity above the partition boundary. The type
 	defaults to 'pmem'. Note that given CXL DPA allocation constraints, once
 	any 'pmem' allocation is established then all remaining 'ram' capacity
diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 2a512fd..ce311b1 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -296,7 +296,7 @@ use generic port APIs on root objects.
 Ports are hierarchical. All but the a root object have another CXL port
 as a parent object retrievable via cxl_port_get_parent().
 
-The root port of a hiearchy can be retrieved via any port instance in
+The root port of a hierarchy can be retrieved via any port instance in
 that hierarchy via cxl_port_get_bus().
 
 The host of a port is the corresponding device name of the PCIe Root
diff --git a/Documentation/daxctl/daxctl-create-device.txt b/Documentation/daxctl/daxctl-create-device.txt
index 05f4dbd..b774b86 100644
--- a/Documentation/daxctl/daxctl-create-device.txt
+++ b/Documentation/daxctl/daxctl-create-device.txt
@@ -62,7 +62,7 @@ DESCRIPTION
 -----------
 
 Creates dax device in 'devdax' mode in dynamic regions. The resultant can also
-be convereted to the 'system-ram' mode which arranges for the dax range to be
+be converted to the 'system-ram' mode which arranges for the dax range to be
 hot-plugged into the system as regular memory.
 
 'daxctl create-device' expects that the BIOS or kernel defines a range in the
diff --git a/Documentation/ndctl/ndctl-create-namespace.txt b/Documentation/ndctl/ndctl-create-namespace.txt
index afb085e..3d0a2dd 100644
--- a/Documentation/ndctl/ndctl-create-namespace.txt
+++ b/Documentation/ndctl/ndctl-create-namespace.txt
@@ -31,7 +31,7 @@ OPTIONS
 -m::
 --mode=::
 	- "raw": expose the namespace capacity directly with
-	  limitations. A raw pmem namepace namespace does not support
+	  limitations. A raw pmem namespace does not support
 	  sector atomicity (see "sector" mode below). A raw pmem
 	  namespace may have limited to no dax support depending the
 	  kernel. In other words operations like direct-I/O targeting a
@@ -95,7 +95,7 @@ OPTIONS
 	suffixes "k" or "K" for KiB, "m" or "M" for MiB, "g" or "G" for
 	GiB and "t" or "T" for TiB.
 
-	For pmem namepsaces the size must be a multiple of the
+	For pmem namespaces the size must be a multiple of the
 	interleave-width and the namespace alignment (see
 	below).
 
diff --git a/cxl/bus.c b/cxl/bus.c
index 3321295..9ef04bc 100644
--- a/cxl/bus.c
+++ b/cxl/bus.c
@@ -100,7 +100,7 @@ static int bus_action(int argc, const char **argv, struct cxl_ctx *ctx,
 		if (sscanf(argv[i], "%lu", &id) == 1)
 			continue;
 
-		log_err(&bl, "'%s' is not a valid bus identifer\n", argv[i]);
+		log_err(&bl, "'%s' is not a valid bus identifier\n", argv[i]);
 		err++;
 	}
 
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index aaa0abf..533ab04 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -1074,7 +1074,7 @@ static int action_sanitize_dimm(struct ndctl_dimm *dimm,
 	if (!param.crypto_erase && !param.overwrite) {
 		param.crypto_erase = true;
 		if (param.verbose)
-			fprintf(stderr, "No santize method passed in, default to crypto-erase\n");
+			fprintf(stderr, "No sanitize method passed in, default to crypto-erase\n");
 	}
 
 	if (param.crypto_erase) {
diff --git a/ndctl/lib/ars.c b/ndctl/lib/ars.c
index d50c283..b705cf0 100644
--- a/ndctl/lib/ars.c
+++ b/ndctl/lib/ars.c
@@ -70,7 +70,7 @@ static bool __validate_ars_cap(struct ndctl_cmd *ars_cap)
 ({ \
 	bool __valid = __validate_ars_cap(ars_cap); \
 	if (!__valid) \
-		dbg(ctx, "expected sucessfully completed ars_cap command\n"); \
+		dbg(ctx, "expected successfully completed ars_cap command\n"); \
 	__valid; \
 })
 
@@ -224,7 +224,7 @@ static bool __validate_ars_stat(struct ndctl_cmd *ars_stat)
 ({ \
 	bool __valid = __validate_ars_stat(ars_stat); \
 	if (!__valid) \
-		dbg(ctx, "expected sucessfully completed ars_stat command\n"); \
+		dbg(ctx, "expected successfully completed ars_stat command\n"); \
 	__valid; \
 })
 
diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index f75dbd4..0925d6d 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -3184,7 +3184,7 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_read(struct ndctl_cmd *cfg
 
 	if (cfg_size->type != ND_CMD_GET_CONFIG_SIZE
 			|| cfg_size->status != 0) {
-		dbg(ctx, "expected sucessfully completed cfg_size command\n");
+		dbg(ctx, "expected successfully completed cfg_size command\n");
 		return NULL;
 	}
 
@@ -3275,7 +3275,7 @@ NDCTL_EXPORT struct ndctl_cmd *ndctl_dimm_cmd_new_cfg_write(struct ndctl_cmd *cf
 	/* enforce rmw */
 	if (cfg_read->type != ND_CMD_GET_CONFIG_DATA
 		       || cfg_read->status != 0) {
-		dbg(ctx, "expected sucessfully completed cfg_read command\n");
+		dbg(ctx, "expected successfully completed cfg_read command\n");
 		return NULL;
 	}
 
diff --git a/test/daxctl-devices.sh b/test/daxctl-devices.sh
index dfce74b..659428d 100755
--- a/test/daxctl-devices.sh
+++ b/test/daxctl-devices.sh
@@ -117,7 +117,7 @@ daxctl_test()
 	if ! "$NDCTL" disable-namespace "$testdev"; then
 		echo "disable-namespace failed as expected"
 	else
-		echo "disable-namespace succeded, expected failure"
+		echo "disable-namespace succeeded, expected failure"
 		echo "reboot required to recover from this state"
 		return 1
 	fi
@@ -130,7 +130,7 @@ daxctl_test()
 	if ! "$DAXCTL" reconfigure-device -N -m system-ram "$daxdev"; then
 		echo "reconfigure failed as expected"
 	else
-		echo "reconfigure succeded, expected failure"
+		echo "reconfigure succeeded, expected failure"
 		restore_online_policy
 		return 1
 	fi
-- 
2.50.1


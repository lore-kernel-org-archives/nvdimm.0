Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE3D3173A
	for <nvdimm@lists.linux.dev>; Wed, 15 Nov 2023 17:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lrCOnkaB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700068819; x=1731604819;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=CBevsL09VJ6h/2O4HK+a+2mgOzW+IynQwh6NLCdC7mU=;
  b=lrCOnkaBkbAXmYFB+phd3JtS2AfZlhnJ5H7+5Nsll7dwncvXtj3dgi+t
   O5qB6JCFWs3EYIiMnqfOQybWul+lb4NP8Bn6SVK7E6ykawmCJI7/iAh7Q
   YdcWIhEt18vA2kwZ6aJaxAWRVjgeaxjix0ld1ybSSAltoBusUyNjtRUmP
   1F49318j2MS2A66rTINdDrCAs49i5NTcKp0rKmGYHmNT9U+l2JFFG34KZ
   e+a5Ilj9oZiOfBmeNGgp41sSshIMzISyH1oEr4erPM8qPFmcuFTQEINgv
   un6FtarQMQsXi07y3pNYAtJztX1tpqxVDC+TtdB2dJjkKaaZ/f3YiLusF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="390713559"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="390713559"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 09:20:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10895"; a="768648509"
X-IronPort-AV: E=Sophos;i="6.03,305,1694761200"; 
   d="scan'208";a="768648509"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.213.188.179])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Nov 2023 09:20:18 -0800
Subject: [NDCTL PATCH v2] cxl/Documentation: Clarify that no-op is a success
 for xable commands
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com, caoqq@fujitsu.com
Date: Wed, 15 Nov 2023 10:20:18 -0700
Message-ID: <170006881824.2006509.7910685162281243122.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

If a cxl enable or disable operation is executed resulting in no-op, the
tool will still emit the number of targets the operation has succeeded on.
For example, if disable-region is issued and the region is already
disabled, the tool will still report 1 region disabled. Add verbiage to
man pages to document the behavior.

Reviewed-by: Quanquan Cao <caoqq@fujitsu.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v2:
- Update subject and commit log (Vishal)
- Remove region example to make it generic (Vishal)
- Fixup documentation verbiage. (Vishal)
---
 Documentation/cxl/cxl-disable-bus.txt    |    2 ++
 Documentation/cxl/cxl-disable-memdev.txt |    1 +
 Documentation/cxl/cxl-disable-port.txt   |    2 ++
 Documentation/cxl/cxl-disable-region.txt |    2 ++
 Documentation/cxl/cxl-enable-memdev.txt  |    2 ++
 Documentation/cxl/cxl-enable-port.txt    |    2 ++
 Documentation/cxl/cxl-enable-region.txt  |    2 ++
 Documentation/cxl/meson.build            |    1 +
 Documentation/cxl/xable-no-op.txt        |    8 ++++++++
 9 files changed, 22 insertions(+)
 create mode 100644 Documentation/cxl/xable-no-op.txt

diff --git a/Documentation/cxl/cxl-disable-bus.txt b/Documentation/cxl/cxl-disable-bus.txt
index 65f695cd06c8..fd645c3233d7 100644
--- a/Documentation/cxl/cxl-disable-bus.txt
+++ b/Documentation/cxl/cxl-disable-bus.txt
@@ -15,6 +15,8 @@ SYNOPSIS
 For test and debug scenarios, disable a CXL bus and any associated
 memory devices from CXL.mem operations.
 
+include::xable-no-op.txt[]
+
 OPTIONS
 -------
 -f::
diff --git a/Documentation/cxl/cxl-disable-memdev.txt b/Documentation/cxl/cxl-disable-memdev.txt
index d39780250939..c4edb93ee94a 100644
--- a/Documentation/cxl/cxl-disable-memdev.txt
+++ b/Documentation/cxl/cxl-disable-memdev.txt
@@ -12,6 +12,7 @@ SYNOPSIS
 [verse]
 'cxl disable-memdev' <mem0> [<mem1>..<memN>] [<options>]
 
+include::xable-no-op.txt[]
 
 OPTIONS
 -------
diff --git a/Documentation/cxl/cxl-disable-port.txt b/Documentation/cxl/cxl-disable-port.txt
index 7a22efc3b821..37bdd11c9a3f 100644
--- a/Documentation/cxl/cxl-disable-port.txt
+++ b/Documentation/cxl/cxl-disable-port.txt
@@ -15,6 +15,8 @@ SYNOPSIS
 For test and debug scenarios, disable a CXL port and any memory devices
 dependent on this port being active for CXL.mem operation.
 
+include::xable-no-op.txt[]
+
 OPTIONS
 -------
 -e::
diff --git a/Documentation/cxl/cxl-disable-region.txt b/Documentation/cxl/cxl-disable-region.txt
index 6a39aee6ea69..34f3fa06d4dd 100644
--- a/Documentation/cxl/cxl-disable-region.txt
+++ b/Documentation/cxl/cxl-disable-region.txt
@@ -21,6 +21,8 @@ EXAMPLE
 disabled 2 regions
 ----
 
+include::xable-no-op.txt[]
+
 OPTIONS
 -------
 include::bus-option.txt[]
diff --git a/Documentation/cxl/cxl-enable-memdev.txt b/Documentation/cxl/cxl-enable-memdev.txt
index 5b5ed66eadc5..e2a2e8420966 100644
--- a/Documentation/cxl/cxl-enable-memdev.txt
+++ b/Documentation/cxl/cxl-enable-memdev.txt
@@ -18,6 +18,8 @@ it again. This involves detecting the state of the HDM (Host Managed
 Device Memory) Decoders and validating that CXL.mem is enabled for each
 port in the device's hierarchy.
 
+include::xable-no-op.txt[]
+
 OPTIONS
 -------
 <memory device(s)>::
diff --git a/Documentation/cxl/cxl-enable-port.txt b/Documentation/cxl/cxl-enable-port.txt
index 50b53d1f48d1..00c40509f09e 100644
--- a/Documentation/cxl/cxl-enable-port.txt
+++ b/Documentation/cxl/cxl-enable-port.txt
@@ -18,6 +18,8 @@ again. This involves detecting the state of the HDM (Host Managed Device
 Memory) Decoders and validating that CXL.mem is enabled for each port in
 the device's hierarchy.
 
+include::xable-no-op.txt[]
+
 OPTIONS
 -------
 -e::
diff --git a/Documentation/cxl/cxl-enable-region.txt b/Documentation/cxl/cxl-enable-region.txt
index f6ef00fb945d..541d2c7de172 100644
--- a/Documentation/cxl/cxl-enable-region.txt
+++ b/Documentation/cxl/cxl-enable-region.txt
@@ -21,6 +21,8 @@ EXAMPLE
 enabled 2 regions
 ----
 
+include::xable-no-op.txt[]
+
 OPTIONS
 -------
 include::bus-option.txt[]
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index c5533572ef75..3e8f2030c3e0 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -25,6 +25,7 @@ filedeps = [
   'debug-option.txt',
   'region-description.txt',
   'decoder-option.txt',
+  'xable-no-op.txt',
 ]
 
 cxl_manpages = [
diff --git a/Documentation/cxl/xable-no-op.txt b/Documentation/cxl/xable-no-op.txt
new file mode 100644
index 000000000000..4046f49b78db
--- /dev/null
+++ b/Documentation/cxl/xable-no-op.txt
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: gpl-2.0
+
+Given any enable or disable command, if the operation is a no-op due to the
+current state of a target, it is still considered successful when executed
+even if no actual operation is performed. The target can be a bus, decoder,
+memdev, or region. The operation will still succeed with the number of
+bus/decoder/memdev/region operated on reported, even if the operation is a
+non-action.



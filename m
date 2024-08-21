Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3242B9AF
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 22:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724277757; cv=none; b=UTMgcQXbpx4WreKsKLABa8FtQyaQK0hWSnPyeFHJMRV8PhlSuo3WJk/aSK9pa9vQPmjzT0w5Nc0eudtDjiHf60zjoFH29Iz/VMIIR0gWGLtng1bPlWNZWiUd9vxF9U3hlwnolLkGku3PLmO3JOv3fAmrLslMtMCJcbRiRRrGHRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724277757; c=relaxed/simple;
	bh=XpcIYFxdMfiXVwVMl70LjR7IwRuJQ+nY6Ji7PjxQTgc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ebeIG1QPF+tlaZ16Vq2eNpA6HIIPJOIkSWN6IidWaAfsLV3GBVo490zfa68i6Ix3e8o/SpFi7zQMVasviAHeOFL2U0u3kYg97I2UPmUkldRJexqACnQUMyHEHwy5CnPcNs0MbYgEggwvZBW0XNc1vGZe7xI6lz9jBHG28V8rhy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lf4Vfhbt; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lf4Vfhbt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724277756; x=1755813756;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XpcIYFxdMfiXVwVMl70LjR7IwRuJQ+nY6Ji7PjxQTgc=;
  b=Lf4Vfhbt0OSGkZ1VZaOCVV6g36QaKT6LvYKYjZtQogKsCejwZnhMjS4L
   PlK1KSrsd7kNzI9bOzYh9dAVLaQwjPz0/lbYwzs+/ggNioQS1UwRnUFAr
   5/0yafBdeRgwEbDAfgio3Nylmvup/GLJBU7w+/RB7JKtvBOVxSchUas3e
   FmL8nTyG7bh8XOj46UsBi5tePDUcQGwRcjTRxCGSbapmNRS8cyXmF+xvI
   d9iiu38wyv5QI19Eg2hbLvbSftA+QXFW9n0/lNthqL31nvi5OYivCWmiE
   DiwTiIhCRC79qAs9MFNsgDL/mmtuT2fQr4VvcBEK6C2CA3yyK+Xsgmptx
   A==;
X-CSE-ConnectionGUID: gsyJPkpmQ9Wbsy7wW9AZJg==
X-CSE-MsgGUID: QT6PQK25SBahoRG9/rk/AA==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="22476018"
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="22476018"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 15:02:35 -0700
X-CSE-ConnectionGUID: sGFWKFpgQU2gXvL43iVT+g==
X-CSE-MsgGUID: yu6Vj+vfS3uB2x+dmRhJ/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="91964229"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.108.221])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 15:02:35 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	nvdimm@lists.linux.dev
Cc: Miroslav Suchy <mirek+github@lomenotecka.cz>
Subject: [ndctl PATCH] ndctl.spec.in: use SPDX formula for license
Date: Wed, 21 Aug 2024 15:02:29 -0700
Message-ID: <20240821220232.105990-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Miroslav Suchy <mirek+github@lomenotecka.cz>

According to SPEC v2, the operator has to be in the upper case.

Reposted here from github pull request:
https://github.com/pmem/ndctl/pull/265/

Signed-off-by: Miroslav Suchy <mirek+github@lomenotecka.cz>
---
 ndctl.spec.in | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index ea9fadc266d8..ae9466c45192 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -2,7 +2,7 @@ Name:		ndctl
 Version:	VERSION
 Release:	1%{?dist}
 Summary:	Manage "libnvdimm" subsystem devices (Non-volatile Memory)
-License:	GPL-2.0-only and LGPL-2.1-only and CC0-1.0 and MIT
+License:	GPL-2.0-only AND LGPL-2.1-only AND CC0-1.0 AND MIT
 Url:		https://github.com/pmem/ndctl
 Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
 
@@ -98,7 +98,7 @@ mappings of performance / feature-differentiated memory.
 
 %package -n LNAME
 Summary:	Management library for "libnvdimm" subsystem devices (Non-volatile Memory)
-License:	LGPL-2.1-only and CC0-1.0 and MIT
+License:	LGPL-2.1-only AND CC0-1.0 AND MIT
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 
 
@@ -107,7 +107,7 @@ Libraries for %{name}.
 
 %package -n DAX_LNAME
 Summary:	Management library for "Device DAX" devices
-License:	LGPL-2.1-only and CC0-1.0 and MIT
+License:	LGPL-2.1-only AND CC0-1.0 AND MIT
 
 %description -n DAX_LNAME
 Device DAX is a facility for establishing DAX mappings of performance /
@@ -116,7 +116,7 @@ control API for these devices.
 
 %package -n CXL_LNAME
 Summary:	Management library for CXL devices
-License:	LGPL-2.1-only and CC0-1.0 and MIT
+License:	LGPL-2.1-only AND CC0-1.0 AND MIT
 
 %description -n CXL_LNAME
 libcxl is a library for enumerating and communicating with CXL devices.
-- 
2.37.3


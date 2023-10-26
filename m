Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D8EC3AC20
	for <nvdimm@lists.linux.dev>; Thu, 26 Oct 2023 19:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b0xKoYsQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698347067; x=1729883067;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=nkWVK2rTP404AfGFt5q3WiFkw5xU0BEM8yR7YlY5Tb4=;
  b=b0xKoYsQh0TZHe2qyQ7R1HuspP8dzzwB4dN9QOVrnMT4Nsk4a246Gotq
   udUXIFZKWiE38ehRdXnmTiktti5CmA+DLCJ5epjcw8OfX9urhDKD0Un+v
   67j4jkZWzOblh9kjHyhsEIsMOj0fEuHAukAHSK4jAjT93CW/hEJN7ElZf
   MCmqjtodZ0GLl6sAGukPcZyBseCD/c2d8tUC0oORkEkTMdXws5l/r05MB
   dh+6aGi5Bi0Enj+LmZeYaCDrJrn8rloZEqR0JlZb3PNw+JMmDid+xcV2M
   Dp9JGL7DILdmAC7TUJCU8Eeu+LRjGn9J9XzGm4iS0eoKdpCL/RjpB1NZZ
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="454090791"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="454090791"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 12:04:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10875"; a="1090686683"
X-IronPort-AV: E=Sophos;i="6.03,254,1694761200"; 
   d="scan'208";a="1090686683"
Received: from lsingh-mobl2.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.110.60])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2023 12:04:26 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Thu, 26 Oct 2023 13:04:19 -0600
Subject: [PATCH ndctl] ndctl.spec.in: Use SPDX identifiers in License
 fields
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231026-spec_license_fix-v1-1-45e4c7866cd3@intel.com>
X-B4-Tracking: v=1; b=H4sIADK4OmUC/x2M4QpAQBAGX0X729XdKeJVJLG+Y0tHtyUl7+7yc
 6ZmHlIkgVJXPJRwicoRM7iyIN6muMLIkpm89ZWzvjZ6gsddGFExBrkNBzTczsFNNlDOzoSs/2U
 /vO8HDwlN6WIAAAA=
To: nvdimm@lists.linux.dev
Cc: Jeff Moyer <jmoyer@redhat.com>, Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12.4
X-Developer-Signature: v=1; a=openpgp-sha256; l=3275;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=nkWVK2rTP404AfGFt5q3WiFkw5xU0BEM8yR7YlY5Tb4=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKlWO6wuTba6nGiVUlPrHMX5Yet5iWy5zZoKjCHZEZalX
 +319XZ0lLIwiHExyIopsvzd85HxmNz2fJ7ABEeYOaxMIEMYuDgFYCKXGBj++39cIcN92PCS9dGN
 RfkF554V+gSxCzK4VJ3gnLzN+r2vOyPDh2mVUhu5/8imxPUIRnX81WZes6aK499y3hVcDl/2ZLi
 yAwA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

There's a push to use SPDX license IDs in .spec files:
  https://docs.fedoraproject.org/en-US/legal/update-existing-packages/

Update the various License: fields in the spec to conform to this.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Jeff Moyer <jmoyer@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2243847
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 7702f95..cb9cb6f 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -2,7 +2,7 @@ Name:		ndctl
 Version:	VERSION
 Release:	1%{?dist}
 Summary:	Manage "libnvdimm" subsystem devices (Non-volatile Memory)
-License:	GPLv2
+License:	GPL-2.0-only and LGPL-2.1-only and CC0-1.0 and MIT
 Url:		https://github.com/pmem/ndctl
 Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
 
@@ -48,7 +48,7 @@ Firmware Interface Table).
 
 %package -n DNAME
 Summary:	Development files for libndctl
-License:	LGPLv2
+License:	LGPL-2.1-only
 Requires:	LNAME%{?_isa} = %{version}-%{release}
 
 %description -n DNAME
@@ -57,7 +57,7 @@ developing applications that use %{name}.
 
 %package -n daxctl
 Summary:	Manage Device-DAX instances
-License:	GPLv2
+License:	GPL-2.0-only
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 
 %description -n daxctl
@@ -68,7 +68,7 @@ filesystem.
 
 %package -n cxl-cli
 Summary:	Manage CXL devices
-License:	GPLv2
+License:	GPL-2.0-only
 Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
 
 %description -n cxl-cli
@@ -77,7 +77,7 @@ the Linux kernel CXL devices.
 
 %package -n CXL_DNAME
 Summary:	Development files for libcxl
-License:	LGPLv2
+License:	LGPL-2.1-only
 Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
 
 %description -n CXL_DNAME
@@ -86,7 +86,7 @@ that use libcxl, a library for enumerating and communicating with CXL devices.
 
 %package -n DAX_DNAME
 Summary:	Development files for libdaxctl
-License:	LGPLv2
+License:	LGPL-2.1-only
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 
 %description -n DAX_DNAME
@@ -98,7 +98,7 @@ mappings of performance / feature-differentiated memory.
 
 %package -n LNAME
 Summary:	Management library for "libnvdimm" subsystem devices (Non-volatile Memory)
-License:	LGPLv2
+License:	LGPL-2.1-only and CC0-1.0 and MIT
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 
 
@@ -107,7 +107,7 @@ Libraries for %{name}.
 
 %package -n DAX_LNAME
 Summary:	Management library for "Device DAX" devices
-License:	LGPLv2
+License:	LGPL-2.1-only and CC0-1.0 and MIT
 
 %description -n DAX_LNAME
 Device DAX is a facility for establishing DAX mappings of performance /
@@ -116,7 +116,7 @@ control API for these devices.
 
 %package -n CXL_LNAME
 Summary:	Management library for CXL devices
-License:	LGPLv2
+License:	LGPL-2.1-only and CC0-1.0 and MIT
 
 %description -n CXL_LNAME
 libcxl is a library for enumerating and communicating with CXL devices.

---
base-commit: d32dc015ad5b18fc37d3d7f10dd1f0a5442d3b7c
change-id: 20231026-spec_license_fix-cfe7c9bf1a0f

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>


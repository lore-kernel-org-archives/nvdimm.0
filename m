Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A461B211C2822
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 16:35:36 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] ndctl.spec.in: remove obsolete Group tag
Date: Wed, 30 Jan 2019 17:35:18 -0700
Message-Id: <20190131003518.10934-2-vishal.l.verma@intel.com>
In-Reply-To: <20190131003518.10934-1-vishal.l.verma@intel.com>
References: <20190131003518.10934-1-vishal.l.verma@intel.com>
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
Cc: Igor Gnatenko <ignatenkobrain@fedoraproject.org>
List-ID: <linux-nvdimm@lists.01.org>

From: Igor Gnatenko <ignatenkobrain@fedoraproject.org>

Pulled in via Fedora packaging.

References: https://fedoraproject.org/wiki/Changes/Remove_Group_Tag
Signed-off-by: Igor Gnatenko <ignatenkobrain@fedoraproject.org>
[vishal: update patch so it applies to ndctl.spec.in]
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index 25d5296..e14a538 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -3,7 +3,6 @@ Version:	VERSION
 Release:	1%{?dist}
 Summary:	Manage "libnvdimm" subsystem devices (Non-volatile Memory)
 License:	GPLv2
-Group:		System Environment/Base
 Url:		https://github.com/pmem/ndctl
 Source0:	https://github.com/pmem/%{name}/archive/v%{version}.tar.gz#/%{name}-%{version}.tar.gz
 
@@ -32,7 +31,6 @@ Firmware Interface Table).
 %package -n DNAME
 Summary:	Development files for libndctl
 License:	LGPLv2
-Group:		Development/Libraries
 Requires:	LNAME%{?_isa} = %{version}-%{release}
 
 %description -n DNAME
@@ -42,7 +40,6 @@ developing applications that use %{name}.
 %package -n daxctl
 Summary:	Manage Device-DAX instances
 License:	GPLv2
-Group:		System Environment/Base
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 
 %description -n daxctl
@@ -54,7 +51,6 @@ filesystem.
 %package -n DAX_DNAME
 Summary:	Development files for libdaxctl
 License:	LGPLv2
-Group:		Development/Libraries
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 
 %description -n DAX_DNAME
@@ -67,7 +63,6 @@ mappings of performance / feature-differentiated memory.
 %package -n LNAME
 Summary:	Management library for "libnvdimm" subsystem devices (Non-volatile Memory)
 License:	LGPLv2
-Group:		System Environment/Libraries
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 
 
@@ -77,7 +72,6 @@ Libraries for %{name}.
 %package -n DAX_LNAME
 Summary:	Management library for "Device DAX" devices
 License:	LGPLv2
-Group:		System Environment/Libraries
 
 %description -n DAX_LNAME
 Device DAX is a facility for establishing DAX mappings of performance /
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

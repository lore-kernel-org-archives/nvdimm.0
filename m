Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC56439908
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 20:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752145; cv=none; b=eKIcQpHClVMmUAJolspoWa8q82r/Ir9lGAVH8viTIC+C8DEIIXo2QRnK4TvkuAtmUoZHD2LIXPf0jbc4LelenUWHXD/a9NW7hOSA61pPVz1NGFabx03chdZTbRGqwVHtNAZOt6bucnKkINuFkVtj0Wz7SmrNXMYzgiak0rLJIJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752145; c=relaxed/simple;
	bh=DDuNSugUVWAs9cGUztFhvIixg5tqrWqNoDVCoytEdIw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ayfS76GjxvooCMLRWpchPQByygbKHO3LeoUtTygzUjlFlDF7gwrHPPuqiFVllgRrT8zkn82GVi6aRSPhUXdxXQJPf44ZjHyR3B5/dh58ONfvU3WqCCJHye9FCmNp1aXaXuoPBUBbm30Tmb2B1t7Tca5GhiLJS9SupuHlTuNyvmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aJe/sEGb; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aJe/sEGb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784752143; x=1816288143;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DDuNSugUVWAs9cGUztFhvIixg5tqrWqNoDVCoytEdIw=;
  b=aJe/sEGbdzBwVG4o+Oab3wU1p6aszi47DJqGL8jGh2/PoPS+EZ8ueP/0
   MYuIBTMP8mGkOjyXG5dRj52xOieqI5bsyzJHEwibE7OmzS0MRaQz2/BMJ
   jy+jrVulkkbYyLtPGN7joktgVqqR9O2dCL59xS1PhRGkAJetLFTeXtQUV
   HEWos3HnGODULCfutkdRfBSe4CuQWlzZNMElGIvAsHbrtPT4w7vZ4EEVC
   CODONcENCOZmd00zf89b9wX8bh/GHam1WhhYPimy9tUPAJgSqptee6LPB
   fwRZAO5trxqHMGRSpnr6er8GCbcQgglsGeDGHhowFALxgHxPR+C8H0arN
   g==;
X-CSE-ConnectionGUID: OGRIFuezQuqpwCwzR/uYdA==
X-CSE-MsgGUID: 8deXNeryQ5qkHlhwGW8ozA==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="85489548"
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="85489548"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:29:03 -0700
X-CSE-ConnectionGUID: 8zq+euP0Trm+7n2SqcN5GA==
X-CSE-MsgGUID: u8TGJMpwTDimVVMmeRfLYQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,179,1779174000"; 
   d="scan'208";a="262524041"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.63])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 13:29:02 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev
Cc: Michal Schorm <mshorm@redhat.com>,
	Claude AI <noreply@anthropic.com>,
	Michal Schorm <mschorm@redhat.com>,
	Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] ndctl.spec.in: make xmlto BuildRequires depend on rhel < 9
Date: Wed, 22 Jul 2026 13:28:58 -0700
Message-ID: <20260722202859.2021117-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Michal Schorm <mshorm@redhat.com>

'xmlto' is only needed alongside 'asciidoc' on RHEL < 9. On Fedora
and RHEL >= 9, documentation is built with 'rubygem-asciidoctor'
via '-Dasciidoctor=enabled', which does not require 'xmlto'. Move
the dependency inside the existing RHEL < 9 conditional.

Related: rhbz#2503124

Reposted from:
https://src.fedoraproject.org/rpms/ndctl/pull-request/4#

Assisted-by: Claude AI <noreply@anthropic.com>
Signed-off-by: Michal Schorm <mschorm@redhat.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
---

Michal, ndctl tool operates via mailing list, not PRs, so reposted
your fixup here.


 ndctl.spec.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index ae9466c45192..f6c0f6992249 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -12,6 +12,7 @@ Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
 BuildRequires:	autoconf
 %if 0%{?rhel} && 0%{?rhel} < 9
 BuildRequires:	asciidoc
+BuildRequires:	xmlto
 %define asciidoctor -Dasciidoctor=disabled
 %define libtracefs -Dlibtracefs=disabled
 %else
@@ -21,7 +22,6 @@ BuildRequires:	libtracefs-devel
 %define asciidoctor -Dasciidoctor=enabled
 %define libtracefs -Dlibtracefs=enabled
 %endif
-BuildRequires:	xmlto
 BuildRequires:	automake
 BuildRequires:	libtool
 BuildRequires:	pkgconfig
-- 
2.37.3


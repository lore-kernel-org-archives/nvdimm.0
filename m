Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17D71531C3
	for <nvdimm@lists.linux.dev>; Wed, 21 Aug 2024 21:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724276735; cv=none; b=UtKQsIt/u0+fyynj7UVt2yLk7TEIiSxWeAll1iy7Ewnl2OyOa6dxXosTmJDq1EJF9hnIx1aaCg/XOOOrrtZwqlUD49ajr0o+Ok5N1CRpoVREK2gxTZM1DFtxtiS7w2N5lvAruk8/XdKy/8IbBTCo8//nAFP1OJL+W3Kzn7nxK6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724276735; c=relaxed/simple;
	bh=9RIvBFSTCfBdvUTU73nR0ZgtoIvlZf1vM/K/bMTzhCs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SeaVeDnAIBZTAwEGzwbeL/fa4V4CnjHj9KFH4x+2kNHioeL8+ZlcAd1LKIJuAUu3uzMMr5SrL42pDL3CRo+pF6oIK+hQib8PRzskrkcKIyA8ZV03QjM/ZyCG4Zerv8ORg9J/SE6CkGrWhkNGpUI5wIx6neqdJ7940hPBQHRpUBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ieBFMsFi; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ieBFMsFi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1724276734; x=1755812734;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=9RIvBFSTCfBdvUTU73nR0ZgtoIvlZf1vM/K/bMTzhCs=;
  b=ieBFMsFieHMuME+xziW/U8g0sznGIiRbaaYggm+TVTT7cgZSNpgM9Vdk
   gQ62I+UoONwGB29qrmIkVInjeJHy+mrCPB0zeSEG/Jmii6013WwReBltv
   h5pJ105mdu4+OSXGIR7UWmlKNfunqfWF/JsMAYXRwwqpXsnM/YBFODtdi
   fVNnBwOJxPBtiChN7/8nYc2y1TpiVZ7aiauoA8WYy17ulP560SrYP5lci
   wG58DWIluP/cpTh1y5oNvvwYCCf8cqt6eCJhLMlva3ELWmToInwgdNktS
   YQ6i8iCnZNe8kui66UlZ+e5W3biLKlxAT2OhASzcy4isMI6fPPde56WfH
   w==;
X-CSE-ConnectionGUID: QI7pq4O3RMKq75hdMeMgpw==
X-CSE-MsgGUID: +Lis9aNBSy63H85Y/Gg7bg==
X-IronPort-AV: E=McAfee;i="6700,10204,11171"; a="22545500"
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="22545500"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 14:45:33 -0700
X-CSE-ConnectionGUID: 63ygEpPYQ8+t8LyMsxceiA==
X-CSE-MsgGUID: SWabdXb3TSmpYR4OzLz7rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,165,1719903600"; 
   d="scan'208";a="66048260"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.108.221])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2024 14:45:32 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	nvdimm@lists.linux.dev
Cc: Jerry James <loganjerry@gmail.com>
Subject: [ndctl PATCH] ndctl.spec.in: enable libtrace{event|fs} support for Fedora
Date: Wed, 21 Aug 2024 14:45:24 -0700
Message-ID: <20240821214529.96966-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jerry James <loganjerry@gmail.com>

As noted in https://src.fedoraproject.org/rpms/ndctl/pull-request/2,
the expression "0%{?rhel}" evaluates to zero on Fedora, so the
conditional "%if 0%{?rhel} < 9" evaluates to true, since 0 is less
than 9. The result is that ndctl builds for Fedora lack support for
libtraceevent and libtracefs. Correct the expression.

Reposted here from github pull request:
https://github.com/pmem/ndctl/pull/266/

Signed-off-by: Jerry James <loganjerry@gmail.com>
---
 ndctl.spec.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index cb9cb6fe0b86..ea9fadc266d8 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -10,7 +10,7 @@ Requires:	LNAME%{?_isa} = %{version}-%{release}
 Requires:	DAX_LNAME%{?_isa} = %{version}-%{release}
 Requires:	CXL_LNAME%{?_isa} = %{version}-%{release}
 BuildRequires:	autoconf
-%if 0%{?rhel} < 9
+%if 0%{?rhel} && 0%{?rhel} < 9
 BuildRequires:	asciidoc
 %define asciidoctor -Dasciidoctor=disabled
 %define libtracefs -Dlibtracefs=disabled
-- 
2.37.3


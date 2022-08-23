Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A43E9A3B
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:21:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661239271; x=1692775271;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+bAm66mVTsrkUhFwkgCp2pQKGp1jx2WlAystbymshh8=;
  b=GekTkULQIFldYoOEvg2hrdGcmFuNo/gW75Tb/zuKcw97HfGqL/b9ivux
   CVgcWiJPpVUTTFmPq6Y+GRWZxyiIEHIJqkC7ryz3F3kofprBMRm/3UNnO
   V38vPxZGA7cdEe2dRPnmKta1GwjTytCbm5be1YfCz1oJiqP3nWvwZxp0i
   k2PMOtEMPNraBrMbAzdCZ/QX+d92117QuHvQqc9TK57+ZiA7Gy1zSZ1S9
   SUeJsZAubnW7QrXYLJ+mka5RQLgNaBTNA1jcgikl8NvsM6vj4U+svy5Nl
   9P3fHQd349ziMWDQeVfjIk5jBS/7IJtC38Gf6uh33EnJlut2IdlLfLKrw
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="293612572"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="293612572"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:21:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="735388581"
Received: from skummith-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.54.206])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:21:10 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/3] cxl: static analysis fixes
Date: Tue, 23 Aug 2022 01:21:03 -0600
Message-Id: <20220823072106.398076-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=494; h=from:subject; bh=+bAm66mVTsrkUhFwkgCp2pQKGp1jx2WlAystbymshh8=; b=owGbwMvMwCXGf25diOft7jLG02pJDMks9feMbG9M95mg8eJ8ivfWpEWCq/l/hjxYpMj4zZORNdb8 w26ejlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAFxkJyPDscKi7mP1J24U3jzdIRZbZ/ MpWXbm4XOC9T/ExC+tVD/+meG/7/64OX4e/x5+OH8z35f9dLYXl8yZi27XV+Vd3rZm9U19PgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Fix a small handful of issues reported by scan.coverity.com for the
recent region management additions.

Vishal Verma (3):
  cxl/region: fix a dereferecnce after NULL check
  libcxl: fox a resource leak and a forward NULL check
  cxl/filter: Fix an uninitialized pointer dereference

 cxl/lib/libcxl.c | 3 ++-
 cxl/filter.c     | 2 +-
 cxl/region.c     | 2 --
 3 files changed, 3 insertions(+), 4 deletions(-)


base-commit: 9a993ce24fdd5de45774b65211570dd514cdf61d
-- 
2.37.2


Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043A2168
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 05:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641445815; x=1672981815;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bzZbdVdL1Sy6I9Wd5BuNX9oiKzqSIU8uGsP0jehmiZ4=;
  b=k+1mqsx0oa+j8We9uG8KBWVekgsrMotOGnLIGD1ZKr+rYWNcvFIuA2ZQ
   CamkzyRmORH58Jj49ajb5sjh+Da0R1/p3Ln7/8zOL1TxHu5sBqs9otnea
   csenFal+hqtLP2Fd2C2Azs0JBQ2kVzhxwpuFJ/3G6f5oKqdRDagtzkY1j
   hhMAQjpm/ifax3Yh3FePBip+h7SME9xgYF2/GVlWPI9w/nhVgXbOyHKlu
   MZozeyMXWGXwaEVpuCbGuyrIgirf20ZXt6BEZ92uMYCnE4ALldCHgBPHN
   zXFiN3tywDSW8HyV6T+Z7ipDVX1slUx0ReN/eBpIdOMM4K8+8ZwT5N4K2
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240138577"
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="240138577"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 21:09:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="689272614"
Received: from asamymu-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.136.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 21:09:50 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/3] misc updates for release scripts
Date: Wed,  5 Jan 2022 22:09:37 -0700
Message-Id: <20220106050940.743232-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=697; h=from:subject; bh=bzZbdVdL1Sy6I9Wd5BuNX9oiKzqSIU8uGsP0jehmiZ4=; b=owGbwMvMwCXGf25diOft7jLG02pJDInXKifPjeWX8HKK3Cak+0xFOTbbkemg/N3fmReuTNv8V2zv hZgrHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZhI4UKGf6aTzExbktUy3VN7fn1zSq i+NVFh/Xmjsi0TFs6qL4uo/srI0PD/f8lzq5ne3AvP97FMKr5zvWP7rzPnb/ucPvfB+uESHU4A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

A few updates to the release helper scripts that fix fedpkg invocation,
move the scripts to the new scripts/ directory, and teach them about cxl
and libcxl.

Vishal Verma (3):
  scripts: fix contrib/do_abidiff for updated fedpkg
  scripts: move 'prepare-release.sh' and 'do_abidiff' into scripts/
  scripts: teach release helper scripts about cxl and libcxl

 {contrib => scripts}/do_abidiff         | 5 +++--
 {contrib => scripts}/prepare-release.sh | 5 +++--
 2 files changed, 6 insertions(+), 4 deletions(-)
 rename {contrib => scripts}/do_abidiff (97%)
 rename {contrib => scripts}/prepare-release.sh (97%)


base-commit: addc5fd8511b8436d89dcef3dd12131147236b09
-- 
2.33.1


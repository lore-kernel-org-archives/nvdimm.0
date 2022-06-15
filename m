Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D075523A6
	for <nvdimm@lists.linux.dev>; Wed, 15 Jun 2022 22:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655333296; x=1686869296;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Spa6pX2M1Geo/2Tw3tc6qEbYNqZfBVs3RhfyVj2ArGQ=;
  b=Rp/PLHyH741gOV41PNt9LMz1v/6fRw9yzCUhfbsopPjY5dF6c0We4CZn
   ognXekmPhr9Zrk2foIovheaazHqh8FiBxJGhMjv3yV+ql3R2dbFJQpUgY
   bG0Wl27zTne2Bs/ElokXr3+Umcy3syM3i6Zkjtc4Q4crnKze1f0yJVwwi
   mgf7XhD7IPXv7hjgUX8UtqS1plrvxNtbBz7ZDRULz+MVdb0zRkaoGPPh3
   w7K3zd49pFTv0c2XqRKhRsXlId7vGsqbeIETGTHEIz1Fat87lnZ+2tSi/
   k4YTzsfeGczNiEXnujgZ+i4f5/ePoxGMe1Gn/6wntNSDe6Xw0cWW9GMGT
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280150960"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280150960"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="911896775"
Received: from rshirckx-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.81.6])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:15 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 0/5] misc updates for release scripts
Date: Wed, 15 Jun 2022 16:48:08 -0600
Message-Id: <20220615224813.523053-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1266; h=from:subject; bh=Spa6pX2M1Geo/2Tw3tc6qEbYNqZfBVs3RhfyVj2ArGQ=; b=owGbwMvMwCXGf25diOft7jLG02pJDEmrElew8gnf+bKIg5H1ZtrxF8ZrSzfF7VfR2J1/PVz+8H7z bRcOdJSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAiUocY/kq6WpuoRq/Zsvui7OvvG8 RuP98i3PxVgFHnvaRWo75+oSXDf2eGFzzRbZtTnHhey/6rC0/mvyCxZKbZkvNnKw+++aAgyAsA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Cleaning up pending branches, I noticed I had missed this series in the
last release, so resending it with some updates.

Changes since v1[1]:
- Add a gitignore update
- Update for the meson conversion

[1]: https://lore.kernel.org/nvdimm/20220106050940.743232-1-vishal.l.verma@intel.com/

---

A few updates to the release helper scripts that fix fedpkg invocation,
move the scripts to the new scripts/ directory, and teach them about cxl
and libcxl.

Vishal Verma (5):
  ndctl: move developer scripts from contrib/ to scripts/
  ndctl: remove obsolete m4 directory
  ndctl: update .gitignore
  scripts: fix contrib/do_abidiff for updated fedpkg
  scripts: update release helper scripts for meson and cxl

 .gitignore                                  | 3 +++
 m4/.gitignore                               | 6 ------
 {contrib => scripts}/daxctl-qemu-hmat-setup | 0
 {contrib => scripts}/do_abidiff             | 5 +++--
 {contrib => scripts}/prepare-release.sh     | 5 +++--
 5 files changed, 9 insertions(+), 10 deletions(-)
 delete mode 100644 m4/.gitignore
 rename {contrib => scripts}/daxctl-qemu-hmat-setup (100%)
 rename {contrib => scripts}/do_abidiff (97%)
 rename {contrib => scripts}/prepare-release.sh (97%)

-- 
2.36.1


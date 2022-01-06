Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4572CAC
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641445817; x=1672981817;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=knA9L0JV1q5gtOzAaRwc0SNbswMXJu2IiJ/H3h7ej44=;
  b=V4Ip/mx+1g6fnYkzMFeM6SdYnzBqMxSD2YKMRFZME3WYHBJs1UZ/yKvY
   FnWUfqvSVeJwy4MeW8QH/8gbahPu1VS8Jp1JKNMyzE56WOAh/0bzrBpZH
   B3486sbr8i8WnHHtNTGCpe/JCvYVrXeVSFbo+YoKih1TXLEzumbtXXPy5
   y0UjqDjnLUVQ84DOdaflqwqpuQw16C9ioixCHJs3eD9SPGKHPTEmFsmJl
   r8PotHHrbU3OxVNrDhzfi+dpcmjE4N9h9bXeS55HS/7F9RtWhAx31/JRx
   Sc56INCMx+QiV9XXiZ5DMo66QrsDZa3KQNYz7ypv1adGK/TLsRaIsvc7M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240138580"
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="240138580"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 21:09:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="689272626"
Received: from asamymu-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.136.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 21:09:51 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/3] scripts: move 'prepare-release.sh' and 'do_abidiff' into scripts/
Date: Wed,  5 Jan 2022 22:09:39 -0700
Message-Id: <20220106050940.743232-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106050940.743232-1-vishal.l.verma@intel.com>
References: <20220106050940.743232-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1296; h=from:subject; bh=knA9L0JV1q5gtOzAaRwc0SNbswMXJu2IiJ/H3h7ej44=; b=owGbwMvMwCXGf25diOft7jLG02pJDInXKqeEPZD9qtN5Z9XbpWz8H3O+/dz/+1qSU/vrXJ+4+aeV 2hR2dZSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAiIVsZGSasPr/2o41pwS2W6zPXem 7275hiIvCR98DUa4FKaxc19C1nZHi89tO3mIY1rjHZzZ12qbGvah//NQsW1rBjZq29pCLryAwA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

The scripts directory in the ndctl tree is designated as the place for
useful developer scripts that don't need to get packaged or distributed.
Move the above out of contrib/ which does contain files that get
packaged.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 {contrib => scripts}/do_abidiff         | 0
 {contrib => scripts}/prepare-release.sh | 2 +-
 2 files changed, 1 insertion(+), 1 deletion(-)
 rename {contrib => scripts}/do_abidiff (100%)
 rename {contrib => scripts}/prepare-release.sh (99%)

diff --git a/contrib/do_abidiff b/scripts/do_abidiff
similarity index 100%
rename from contrib/do_abidiff
rename to scripts/do_abidiff
diff --git a/contrib/prepare-release.sh b/scripts/prepare-release.sh
similarity index 99%
rename from contrib/prepare-release.sh
rename to scripts/prepare-release.sh
index fb5cfe3..97ab964 100755
--- a/contrib/prepare-release.sh
+++ b/scripts/prepare-release.sh
@@ -186,7 +186,7 @@ check_libtool_vers "libdaxctl"
 gen_lists ${last_ref}..HEAD~1
 
 # For ABI diff purposes, use the latest fixes tag
-contrib/do_abidiff ${last_fix}..HEAD
+scripts/do_abidiff ${last_fix}..HEAD
 
 # once everything passes, update the git-version
 sed -i -e "s/DEF_VER=[0-9]\+.*/DEF_VER=${next_ref#v}/" git-version
-- 
2.33.1


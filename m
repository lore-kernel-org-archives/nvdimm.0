Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600D62902
	for <nvdimm@lists.linux.dev>; Wed, 15 Jun 2022 22:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655333298; x=1686869298;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rg1xVaXuh+EZ3wuydqZXQxCDboU/B/Aw6yTV4A4bjgI=;
  b=FwGoDvbA8JEa4ZQVFPpg8mXtSNxeT7gK83YNBhNxMj7mH8RkxbaA5i0z
   yN+sRCGITHTbJOSrddOwaKUXChocMJ1lDda31VEp6U4LhLXb73qZZwbWj
   ppvmoqv4IJW7dbwpVyzW0ndNzZv+641kDbmwe8XmwHzH8d9TMPNMucbOW
   ze5a1AaP2CailPE3lFcJRlOGWIlt/C1NFOOv50IpOdWfrsWuj+O2jr+Gi
   CLYEzt9yHidleguyEK4bv/jn60DikOVoANXyWr7rJCyXGaiuNCkDUXVZL
   NHdvRDy5jO/Ernzqe9dpKS5o66DemiRbLwWzVGychE3LUoJzZWdceVIPr
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280150961"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280150961"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:16 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="911896780"
Received: from rshirckx-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.81.6])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:15 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 1/5] ndctl: move developer scripts from contrib/ to scripts/
Date: Wed, 15 Jun 2022 16:48:09 -0600
Message-Id: <20220615224813.523053-2-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615224813.523053-1-vishal.l.verma@intel.com>
References: <20220615224813.523053-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1638; h=from:subject; bh=rg1xVaXuh+EZ3wuydqZXQxCDboU/B/Aw6yTV4A4bjgI=; b=owGbwMvMwCXGf25diOft7jLG02pJDEmrEtfEPWlYYRpgvZL7XprCBMfSWP93Eo0CK+5L3NS0XhC9 Kbqpo5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABMR2cLwV+Ttm8L12a6r7x9SjjydwV 15//D+kuOZL2/Ol/Gb0pk5/x8jw9nPhtuj10dt8fiwMNHiR1vbk+nzw2UeTTrcuDVDtLRhPR8A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Allow for scripts/ to be the defacto location for scripts and tooling
that may be useful for developers of ndctl, but isn't distributed or
installed. Move such scripts currently in contrib/ to scripts/.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 {contrib => scripts}/daxctl-qemu-hmat-setup | 0
 {contrib => scripts}/do_abidiff             | 0
 {contrib => scripts}/prepare-release.sh     | 2 +-
 3 files changed, 1 insertion(+), 1 deletion(-)
 rename {contrib => scripts}/daxctl-qemu-hmat-setup (100%)
 rename {contrib => scripts}/do_abidiff (100%)
 rename {contrib => scripts}/prepare-release.sh (99%)

diff --git a/contrib/daxctl-qemu-hmat-setup b/scripts/daxctl-qemu-hmat-setup
similarity index 100%
rename from contrib/daxctl-qemu-hmat-setup
rename to scripts/daxctl-qemu-hmat-setup
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
2.36.1


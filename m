Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC3D3206
	for <nvdimm@lists.linux.dev>; Thu, 16 Jun 2022 19:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655408136; x=1686944136;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=GXeP2o/jGWCYaf6LnvC5bI0sC4cW2WqwSbdFkmcEbiI=;
  b=PCTvPr8VO3vlzY5ZSuMX2pp+avRxXpXt91GmqWAgZZp0ewyTunWKiFFs
   NC2rwHwqyS/Noho//DbjlaB0/buoBEFS4dA5GvuhqQ03pIBYzxgm3b/jb
   QMlCmFvqaEGeC9wC05gK4D2SF6O2ls4sCrSqB+jGuK+fYuRA/SIUBnP6z
   KRea+DgLejHgPTBfMk3UQclpC0SIsW7kVCAtx7MfCUShICou8uQjgGxnq
   cZFMeoPvsXSM1Rns0VKnXgWaRfJgRcHKH1C+ertqjCaNxw3W+b7ycQ6US
   Hii0PGp/34Z/F76VpqlV5SOp/ru2hCuD2eLw1WNKtb0U0xuS8lSJYQhk3
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="365687617"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="365687617"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 12:35:35 -0700
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="912300073"
Received: from scrieder-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.213.188.218])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2022 12:35:35 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] util/wrapper.c: Fix gcc warning in xrealloc()
Date: Thu, 16 Jun 2022 13:35:29 -0600
Message-Id: <20220616193529.56513-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=1399; h=from:subject; bh=GXeP2o/jGWCYaf6LnvC5bI0sC4cW2WqwSbdFkmcEbiI=; b=owGbwMvMwCXGf25diOft7jLG02pJDEmrW/+ynrj1vk+FpVrngc2MbV+8Zzw+XjY1RrWc/VDrtj8M +gfnd5SyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAikgGMDLvKjcu4i/lqjl/q+Lptcc 9dxSMC/1UXeMzPy0i2tdndI8XI0Ces9zM1b9vUFw/ELsqeTtJIdjmi4DXjUKZP65x/s16s5wQA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

A GCC update (12.1.1) now produces a warning in the xrealloc() wrapper
(originally copied from git, and used in strbuf operations):

  ../util/wrapper.c: In function ‘xrealloc’:
  ../util/wrapper.c:34:31: warning: pointer ‘ptr’ may be used after ‘realloc’ [-Wuse-after-free]
     34 |                         ret = realloc(ptr, 1);
        |                               ^~~~~~~~~~~~~~~

Pull in an updated definition for xrealloc() from the git project to fix this.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/wrapper.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/util/wrapper.c b/util/wrapper.c
index 026a54f..6adfde6 100644
--- a/util/wrapper.c
+++ b/util/wrapper.c
@@ -25,15 +25,15 @@ char *xstrdup(const char *str)
 
 void *xrealloc(void *ptr, size_t size)
 {
-	void *ret = realloc(ptr, size);
-	if (!ret && !size)
-		ret = realloc(ptr, 1);
-	if (!ret) {
-		ret = realloc(ptr, size);
-		if (!ret && !size)
-			ret = realloc(ptr, 1);
-		if (!ret)
-			die("Out of memory, realloc failed");
+	void *ret;
+
+	if (!size) {
+		free(ptr);
+		return malloc(1);
 	}
+
+	ret = realloc(ptr, size);
+	if (!ret)
+		die("Out of memory, realloc failed");
 	return ret;
 }

base-commit: 3e17210345482ec9795f1046c766564d3b8a0795
-- 
2.36.1


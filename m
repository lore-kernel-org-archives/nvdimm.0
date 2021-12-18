Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91A00168
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 03:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639799971; x=1671335971;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=4t4cAz973YojRKMJmOvLs0g3EsipgnLQLo8VyiTedBY=;
  b=YQQacoqS9hnNEaGE38I+RVGm3rjX6hPAjXrQovZKxLX85UjnR4vP4aRi
   UPq1pui8qmBAm9N0QI4uDvrWX/JrM2wsa2YqbBEZ3jwcz0WrVD/UnSb7U
   LU1H85PJwnJvLdHv0eonAmu8sxHAt+adtYUAEVUHndNtYuGSXuLJfs1Y2
   ZkgPC1+Mufq/QM1KyNyfi95/50CM/uh1auTkjWuATdeW8RdudHE+jlBIe
   m7qbzFKgkl1OGaztZCksQ0cx3AoZV9JBF/WAm03ddJ85OP16PiO07HAC5
   Fqe/8bO03U0PZur24XsU9BGEf9RHmEffnQHQBlzaUtKGmAdszn7cbvuU1
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="226741074"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="226741074"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 19:59:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="520030688"
Received: from dalbrigh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.35.246])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 19:59:30 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: [ndctl PATCH] util/parse-configs: Fix a resource leak in search_section_kv()
Date: Fri, 17 Dec 2021 20:59:22 -0700
Message-Id: <20211218035922.347380-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=915; h=from:subject; bh=4t4cAz973YojRKMJmOvLs0g3EsipgnLQLo8VyiTedBY=; b=owGbwMvMwCXGf25diOft7jLG02pJDIl7Y2YxT6wRqGuudJn8cuMfJ8tLaRO2/fwp/uko04HIozHz 5aemdpSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAiyrcY/ge2Fltm5fGpuxv7TXN1X/ RqctrhqtSXO2Os7+3SzTFX72X4K8eWwvdPrLHl1Z2Nszie3ejcuvHF4VjHnq8zGKJk3PPTuQA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Static analysis points out that the memory pointed to by 'cur_sec' may
be leaked. Fix the missed goto error; vs return NULL; exit path for an
error condition here.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 util/parse-configs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/parse-configs.c b/util/parse-configs.c
index 49ee4e0..1b7ffa6 100644
--- a/util/parse-configs.c
+++ b/util/parse-configs.c
@@ -57,7 +57,7 @@ static const char *search_section_kv(dictionary *d, const struct config *c)
 			return NULL;
 		if (!c->section || !c->search_key || !c->search_val || !c->get_key) {
 			fprintf(stderr, "warning: malformed config query, skipping\n");
-			return NULL;
+			goto out_sec;
 		}
 
 		cur = strtok_r(cur_sec, delim, &save);

base-commit: c55b18181281b2fffadb9e0e8955d74b8b719349
-- 
2.33.1


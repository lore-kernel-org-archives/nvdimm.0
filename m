Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD69A2560
	for <nvdimm@lists.linux.dev>; Thu,  2 Jun 2022 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1654184674; x=1685720674;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nAhEz1djCOAWhxdW97lUdRn+XYH7LvOIlcq3JtiHRDc=;
  b=LWqvtK4EhN4qYcjr/a3KVbiSv1PcIRpNHuwzq3nGL4fR6mMUe7U4CU8m
   jyqRJV04VezIytBFMgsr6FHvKqj+AvnMmiWUayhyMkg21ge3lLbHR33jE
   iXesKGbTUoYM1DlFkuF+l5UfFxQZuhcPL3KXWa/5Wd+zmytS3e3SsCjkM
   laUeXMA60yObndQCyumJ1Gfr21NlPg6tbVHEFQHSXfWsPiKyBLFctmHqG
   hX3h3awMC7gZtYCufrQKQy1GWir3Gl+iINcHgHDKUhnV9YI9n6QicFrQn
   jKeagqdZLX/Qbp/EhShZ1HBWBvjUAi7ZrVLfTVZk4v1/SGyC7Nnj+AJ1z
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10366"; a="258058705"
X-IronPort-AV: E=Sophos;i="5.91,271,1647327600"; 
   d="scan'208";a="258058705"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 08:44:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,271,1647327600"; 
   d="scan'208";a="757042153"
Received: from sebanner-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.99.17])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2022 08:44:30 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Steven Garcia <steven.garcia@intel.com>
Subject: [ndctl PATCH] libcxl: fix a segfault when memdev->pmem is absent
Date: Thu,  2 Jun 2022 09:44:27 -0600
Message-Id: <20220602154427.462852-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1136; h=from:subject; bh=nAhEz1djCOAWhxdW97lUdRn+XYH7LvOIlcq3JtiHRDc=; b=owGbwMvMwCXGf25diOft7jLG02pJDEkzbt0OZkn3i2N8fc0ygeXxligvBlmvNVqtZ/i0Y8wEzS6+ DjnZUcrCIMbFICumyPJ3z0fGY3Lb83kCExxh5rAygQxh4OIUgIl8PcrwP4Xxo2ivtqs9Z7INb//MA6 snW16dlVsVceLsZFfOiDWikgz/k/Z+O6h7yPXoiWl5Z2udz9uszDXSKz/yW4bTfqHsUdNJDAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

A CXL memdev may not have any persistent capacity, and in this case it
is possible that a 'pmem' object never gets instantiated. Such a
scenario would cause free_pmem () to dereference a NULL pointer and
segfault.

Fix this by only proceeding in free_pmem() if 'pmem' was valid.

Fixes: cd1aed6cefe8 ("libcxl: add representation for an nvdimm bridge object")
Reported-by: Steven Garcia <steven.garcia@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/libcxl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 1ad4a0b..2578a43 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -50,9 +50,11 @@ struct cxl_ctx {
 
 static void free_pmem(struct cxl_pmem *pmem)
 {
-	free(pmem->dev_buf);
-	free(pmem->dev_path);
-	free(pmem);
+	if (pmem) {
+		free(pmem->dev_buf);
+		free(pmem->dev_path);
+		free(pmem);
+	}
 }
 
 static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)

base-commit: 4229f2694e8887a47c636a54130cff0d65f2e995
-- 
2.36.1


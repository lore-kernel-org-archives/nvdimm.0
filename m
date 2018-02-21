Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 672092034D8CB
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 10:06:57 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 2/2] ndctl: add test files to .gitignore
Date: Wed, 21 Feb 2018 11:12:48 -0700
Message-Id: <20180221181248.13351-2-ross.zwisler@linux.intel.com>
In-Reply-To: <20180221181248.13351-1-ross.zwisler@linux.intel.com>
References: <20180221181248.13351-1-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 .gitignore | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/.gitignore b/.gitignore
index 3c2de0e..20a04de 100644
--- a/.gitignore
+++ b/.gitignore
@@ -32,3 +32,24 @@ version.m4
 cscope.files
 cscope*.out
 tags
+test/*.log
+test/*.trs
+test/blk-ns
+test/dax-dev
+test/dax-errors
+test/dax-pmd
+test/daxdev-errors
+test/device-dax
+test/dpa-alloc
+test/dsm-fail
+test/hugetlb
+test/image
+test/libndctl
+test/mmap
+test/multi-pmem
+test/parent-uuid
+test/pmem-ns
+test/smart-listen
+test/smart-notify
+test/fio.job
+test/local-write-0-verify.state
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

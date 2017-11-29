Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D940E221660EE
 for <linux-nvdimm@lists.01.org>; Wed, 29 Nov 2017 09:06:39 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] rpmbuild: check for rpmbuild working directories
Date: Wed, 29 Nov 2017 10:11:00 -0700
Message-Id: <20171129171100.6654-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The rpmbuild and make-git-snapshot assume that the various ~/rpmbuild/*
directories are present. In case they weren't, git-archive would fail
with something like:

  /root/rpmbuild/SOURCES/ndctl-58.2.38.g8ad8f4c.tar.gz: No such file or directory

Add a check to make sure they are present, and exit out with a relevant
message.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 rpmbuild.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rpmbuild.sh b/rpmbuild.sh
index 4535b46..fe4154b 100755
--- a/rpmbuild.sh
+++ b/rpmbuild.sh
@@ -1,5 +1,6 @@
 #!/bin/bash
 pushd $(dirname $0) >/dev/null
+[ ! -d ~/rpmbuild/SOURCES ] && echo "rpmdev tree not found" && exit 1
 ./make-git-snapshot.sh
 popd > /dev/null
 rpmbuild -ba $(dirname $0)/rhel/ndctl.spec
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

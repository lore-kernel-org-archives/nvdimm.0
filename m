Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B745321197040
 for <linux-nvdimm@lists.01.org>; Thu,  7 Jun 2018 15:31:23 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [qemu PATCH 1/5] gitignore: ignore generated qapi job files
Date: Thu,  7 Jun 2018 16:31:07 -0600
Message-Id: <20180607223111.27792-1-ross.zwisler@linux.intel.com>
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
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Kevin Wolf <kwolf@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Stefan Hajnoczi <stefanha@redhat.com>, Igor Mammedov <imammedo@redhat.com>, Eric Blake <eblake@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

With a fully built QEMU I currently see the following with "git status":

  Untracked files:
    (use "git add <file>..." to include in what will be committed)

  	qapi/qapi-commands-job.c
  	qapi/qapi-commands-job.h
  	qapi/qapi-events-job.c
  	qapi/qapi-events-job.h
  	qapi/qapi-types-job.c
  	qapi/qapi-types-job.h
  	qapi/qapi-visit-job.c
  	qapi/qapi-visit-job.h

These are all generated files.  Ignore them.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kevin Wolf <kwolf@redhat.com>
Cc: Eric Blake <eblake@redhat.com>
Fixes: commit bf42508f24ee ("job: Introduce qapi/job.json")
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 81e1f2fb0f..2980090f0a 100644
--- a/.gitignore
+++ b/.gitignore
@@ -100,6 +100,7 @@
 /qapi/qapi-visit-ui.[ch]
 /qapi/qapi-visit.[ch]
 /qapi/qapi-doc.texi
+/qapi/qapi-*-job.[ch]
 /qemu-doc.html
 /qemu-doc.info
 /qemu-doc.txt
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

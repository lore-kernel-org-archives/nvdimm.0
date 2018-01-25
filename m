Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B958A21E256AB
 for <linux-nvdimm@lists.01.org>; Thu, 25 Jan 2018 15:21:12 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH 1/2] ndctl: update .gitignore
Date: Thu, 25 Jan 2018 16:26:37 -0700
Message-Id: <20180125232638.6585-1-ross.zwisler@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

I noticed that my 'git status' output was quite noisy.  Here's what I get
with a full build using the suggested
./configure CFLAGS='-g -O0' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64
command and with some cscope files built:

  $ git status
  On branch pending
  Your branch is up-to-date with 'github/pending'.

  Untracked files:
    (use "git add <file>..." to include in what will be committed)

  	Documentation/daxctl/asciidoc.conf
  	Documentation/daxctl/daxctl-io.1
  	Documentation/daxctl/daxctl-list.1
  	Documentation/daxctl/daxctl.1
  	Documentation/ndctl/asciidoc.conf
  	Documentation/ndctl/ndctl-check-labels.1
  	Documentation/ndctl/ndctl-check-namespace.1
  	Documentation/ndctl/ndctl-create-namespace.1
  	Documentation/ndctl/ndctl-destroy-namespace.1
  	Documentation/ndctl/ndctl-disable-dimm.1
  	Documentation/ndctl/ndctl-disable-namespace.1
  	Documentation/ndctl/ndctl-disable-region.1
  	Documentation/ndctl/ndctl-enable-dimm.1
  	Documentation/ndctl/ndctl-enable-namespace.1
  	Documentation/ndctl/ndctl-enable-region.1
  	Documentation/ndctl/ndctl-init-labels.1
  	Documentation/ndctl/ndctl-inject-error.1
  	Documentation/ndctl/ndctl-list.1
  	Documentation/ndctl/ndctl-read-labels.1
  	Documentation/ndctl/ndctl-write-labels.1
  	Documentation/ndctl/ndctl-zero-labels.1
  	Documentation/ndctl/ndctl.1
  	ccan/list/.dirstamp
  	ccan/str/.dirstamp
  	cscope.files
  	cscope.out
  	daxctl/daxctl
  	daxctl/lib/libdaxctl.la
  	daxctl/lib/libdaxctl.lo
  	daxctl/lib/libdaxctl.pc
  	libccan.a
  	libutil.a
  	ndctl/lib/libndctl.pc
  	ndctl/ndctl
  	ndctl/util/.dirstamp
  	rhel/
  	sles/ndctl.spec
  	util/.dirstamp
  	util/log.lo
  	util/sysfs.lo
  	version.m4

  nothing added to commit but untracked files present (use "git add" to track)

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 .gitignore | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/.gitignore b/.gitignore
index 4899534..64e58fa 100644
--- a/.gitignore
+++ b/.gitignore
@@ -12,3 +12,22 @@ Makefile.in
 /configure
 /libtool
 /stamp-h1
+*.1
+Documentation/daxctl/asciidoc.conf
+Documentation/ndctl/asciidoc.conf
+.dirstamp
+daxctl/daxctl
+daxctl/lib/libdaxctl.la
+daxctl/lib/libdaxctl.lo
+daxctl/lib/libdaxctl.pc
+*.a
+ndctl/lib/libndctl.pc
+ndctl/ndctl
+rhel/
+sles/ndctl.spec
+util/log.lo
+util/sysfs.lo
+version.m4
+*.swp
+cscope.files
+cscope.out
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B11CF21959CB2
 for <linux-nvdimm@lists.01.org>; Wed, 27 Mar 2019 13:44:24 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2] ndctl: enable 'travis-ci'
Date: Wed, 27 Mar 2019 14:44:20 -0600
Message-Id: <20190327204421.24618-1-vishal.l.verma@intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a .travis.yml config to enable Travis CI.
Also add the Travis CI  status 'badge' to README.md

For now, this only does a compile test. It can be built upon in the
future to do more runtime testing. Since the travis environment uses
Ubuntu, this is useful regardless, as it will immediately catch any
build failures in an Ubuntu environment.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---

v2: Fix the 'badge' to point to the pmem/ndctl repo instead of a
personal one used for testing.

 .travis.yml | 23 +++++++++++++++++++++++
 README.md   |  2 ++
 2 files changed, 25 insertions(+)
 create mode 100644 .travis.yml

diff --git a/.travis.yml b/.travis.yml
new file mode 100644
index 0000000..eb0c665
--- /dev/null
+++ b/.travis.yml
@@ -0,0 +1,23 @@
+dist: xenial
+language: c
+sudo: required
+ccache: ccache
+
+git:
+  depth: 5
+  quiet: true
+
+before_install:
+  - sudo apt-get update -qq
+  - sudo apt-get install -qq --no-install-recommends -y systemd dh-systemd libkmod2 libkmod-dev libudev1 libudev-dev keyutils libkeyutils-dev libjson-c-dev libuuid1 asciidoctor jq kmod dracut build-essential git-core libelf-dev asciidoc binutils-dev
+  - sudo apt-get build-dep linux-image-$(uname -r)
+
+install:
+  - ./autogen.sh
+  - ./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib
+  - make -j$(nproc --all)
+  - sudo make install
+
+jobs:
+  include:
+      script: true
diff --git a/README.md b/README.md
index 7c420d5..690d152 100644
--- a/README.md
+++ b/README.md
@@ -1,4 +1,6 @@
 # ndctl
+[![Build Status](https://travis-ci.org/pmem/ndctl.svg?branch=master)](https://travis-ci.org/pmem/ndctl)
+
 Utility library for managing the libnvdimm (non-volatile memory device)
 sub-system in the Linux kernel
   
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE63B538B
	for <nvdimm@lists.linux.dev>; Tue, 30 Aug 2022 21:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661894623; x=1693430623;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zbZdZAKRlqjPDqC6oGf0MtEjbg47qQRjslqUVXMbkLI=;
  b=IxXsxuzV9Ig0FbbOmz2Z+U4xDdWhBGzsmrdvIbcVN19ZmxrtjdOOsgC/
   yJKCS4qdJFxMxqieyaxCjVvvvG3n8x2g9NVIaulLEDIQVP7LbgptIlOPh
   2Rz3eDXihoEvh5hR7xXgtNphseJZWU0j/RUfgox2193JnRyYz+XidUR0R
   O5yUVH1KWoDuxLv/K2UeYSU7Hsr6bDvRvr725lQPzgSR7sUk9aA29XByI
   JIkbfA/SV1nsYcAvSuBYYYZoc3D0/bObDjmmqasMnjCE6TndGommON3TU
   WzFnlz3gF7vEc/FSz4IM1bo3JXwWokgSkkTyQRgCxwi/Z38PKc9SOLChG
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="381599511"
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="381599511"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 14:23:43 -0700
X-IronPort-AV: E=Sophos;i="5.93,276,1654585200"; 
   d="scan'208";a="737889499"
Received: from malfaroa-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.49.188])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 14:23:42 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: remove travis-ci
Date: Tue, 30 Aug 2022 15:23:38 -0600
Message-Id: <20220830212338.413104-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1955; h=from:subject; bh=zbZdZAKRlqjPDqC6oGf0MtEjbg47qQRjslqUVXMbkLI=; b=owGbwMvMwCXGf25diOft7jLG02pJDMl89WeYn81eFhIVqvMiSmntEZmbF90PR0k9O/Vwr/nJ+ilK rcWOHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiI8xKG/wVrnYI3q9jaZS0Pcw/Y+L zoUuOe86d/b7iw18FqYtNboXWMDM0fviSabpAOCeE9vj/BjvHkxYlXtkbuUvqoNWdmas56fj4A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Drop the Travis CI integration. Their switch to '.com' and the
corresponding rework to billing plans and OSS 'credits' has introduced
unnecessary complexity to something that Just Worked before.

The only thing the CI was testing was builds on Ubuntu, but there
appears to be Debian (unstable) automation now to pick up and build new
upstream releases automatically [1], so we have some replacement coverage
by way of that.

[1]: https://packages.debian.org/source/sid/ndctl

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .travis.yml | 23 -----------------------
 README.md   |  1 -
 2 files changed, 24 deletions(-)
 delete mode 100644 .travis.yml

diff --git a/.travis.yml b/.travis.yml
deleted file mode 100644
index eb0c665..0000000
--- a/.travis.yml
+++ /dev/null
@@ -1,23 +0,0 @@
-dist: xenial
-language: c
-sudo: required
-ccache: ccache
-
-git:
-  depth: 5
-  quiet: true
-
-before_install:
-  - sudo apt-get update -qq
-  - sudo apt-get install -qq --no-install-recommends -y systemd dh-systemd libkmod2 libkmod-dev libudev1 libudev-dev keyutils libkeyutils-dev libjson-c-dev libuuid1 asciidoctor jq kmod dracut build-essential git-core libelf-dev asciidoc binutils-dev
-  - sudo apt-get build-dep linux-image-$(uname -r)
-
-install:
-  - ./autogen.sh
-  - ./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib
-  - make -j$(nproc --all)
-  - sudo make install
-
-jobs:
-  include:
-      script: true
diff --git a/README.md b/README.md
index e5c4940..8e91322 100644
--- a/README.md
+++ b/README.md
@@ -1,5 +1,4 @@
 # ndctl
-[![Build Status](https://travis-ci.org/pmem/ndctl.svg?branch=master)](https://travis-ci.org/pmem/ndctl)
 
 Utility library for managing the libnvdimm (non-volatile memory device)
 sub-system in the Linux kernel

base-commit: c9c9db39354ea0c3f737378186318e9b7908e3a7
-- 
2.37.2


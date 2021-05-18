Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A295C72
	for <nvdimm@lists.linux.dev>; Tue, 18 May 2021 22:25:32 +0000 (UTC)
IronPort-SDR: fmnnfLNUfqlAgP91DjYR1tccaMElZ2wjOiJkGBx3y+wzXt+PwMjheT0KHV0WUA6V5WjjF29zPH
 Dv7eiEz+UcRQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9988"; a="180437432"
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="180437432"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 15:25:31 -0700
IronPort-SDR: C1HjXMhdbcMUJUgfDc7TgNIj5rtK9sV7Pj3mPPklRbk5oZhJ12I6mSmMf5vDuwEQBMYaXaT53S
 NeaAvurfuBfQ==
X-IronPort-AV: E=Sophos;i="5.82,310,1613462400"; 
   d="scan'208";a="542154866"
Received: from rong2-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.2.111])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 May 2021 15:25:31 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: <linux-nvdimm@lists.01.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: Update nvdimm mailing list address
Date: Tue, 18 May 2021 16:25:27 -0600
Message-Id: <20210518222527.550730-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The 'nvdimm' mailing list has moved from lists.01.org to
lists.linux.dev. Update CONTRIBUTING.md and configure.ac to reflect
this.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 configure.ac    | 2 +-
 CONTRIBUTING.md | 7 ++++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 5ec8d2f..dc39dbe 100644
--- a/configure.ac
+++ b/configure.ac
@@ -2,7 +2,7 @@ AC_PREREQ(2.60)
 m4_include([version.m4])
 AC_INIT([ndctl],
         GIT_VERSION,
-        [linux-nvdimm@lists.01.org],
+        [nvdimm@lists.linux.dev],
         [ndctl],
         [https://github.com/pmem/ndctl])
 AC_CONFIG_SRCDIR([ndctl/lib/libndctl.c])
diff --git a/CONTRIBUTING.md b/CONTRIBUTING.md
index 4c29d31..4f4865d 100644
--- a/CONTRIBUTING.md
+++ b/CONTRIBUTING.md
@@ -6,13 +6,14 @@ The following is a set of guidelines that we adhere to, and request that
 contributors follow.
 
 1. The libnvdimm (kernel subsystem) and ndctl developers primarily use
-   the [linux-nvdimm](https://lists.01.org/postorius/lists/linux-nvdimm.lists.01.org/)
+   the [nvdimm](https://subspace.kernel.org/lists.linux.dev.html)
    mailing list for everything. It is recommended to send patches to
-   **```linux-nvdimm@lists.01.org```**
+   **```nvdimm@lists.linux.dev```**
+   An archive is available on [lore](https://lore.kernel.org/nvdimm/)
 
 1. Github [issues](https://github.com/pmem/ndctl/issues) are an acceptable
    way to report a problem, but if you just have a question,
-   [email](mailto:linux-nvdimm@lists.01.org) the above list.
+   [email](mailto:nvdimm@lists.linux.dev) the above list.
 
 1. We follow the Linux Kernel [Coding Style Guide][cs] as applicable.
 

base-commit: a2a6fda4d7e93044fca4c67870d2ff7e193d3cf1
prerequisite-patch-id: 8fc5baaf64b312b2459acea255740f79a23b76cd
-- 
2.31.1


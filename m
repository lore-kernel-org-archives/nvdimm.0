Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB486138F
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183816; x=1682719816;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wTOhNnGM4fH3f48hOp4pX+ub4ekvi2i7bAZMl9dNetU=;
  b=Eys17iY6pkZR7sJ1hg4r40bSrnMooKU8KxOLz3d2Hq/tMdPR5tEXbvRp
   G7snrdNP9ll9G+X8taLP+x1bBU/GhBwQjqEBfYv2HZUtOJ0gbo9mTgSsT
   FVxIFlemJ2olu1Q00aeSfDgwPjO4fUo7VP/Sqd+XXjwViTvmeWyxIRQ38
   RYuc7DcoZwpgOAyLk8sShZ4+TDW1Nc08ZqyI25jdL+kYR1Q59rH5f8YdT
   Mg8pkfWFCyDJOY0OggK2PDHombRgY7m6tIe/q3fexjnaLw9ThaJo+AQqC
   9G/IHpXmqCTgTvp9Od7o2DX52/pGHBlGbBV+UoelJ21NgnAM8uDYb+m7o
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265967584"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265967584"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:06 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="534122457"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:06 -0700
Subject: [ndctl PATCH 01/10] build: Move utility helpers to libutil.a
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:05 -0700
Message-ID: <165118380572.1676208.16232543117821121022.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Stop listing util/json.c and util/log.c per command, just add them to
the common libutil.a object.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/meson.build    |    2 --
 daxctl/meson.build |    1 -
 ndctl/meson.build  |    2 --
 util/meson.build   |    2 ++
 4 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/cxl/meson.build b/cxl/meson.build
index 87cfea73e40b..671c8e1626ef 100644
--- a/cxl/meson.build
+++ b/cxl/meson.build
@@ -3,8 +3,6 @@ cxl_src = [
   'list.c',
   'port.c',
   'memdev.c',
-  '../util/json.c',
-  '../util/log.c',
   'json.c',
   'filter.c',
 ]
diff --git a/daxctl/meson.build b/daxctl/meson.build
index 8474d02f2c0d..8f27dd71b965 100644
--- a/daxctl/meson.build
+++ b/daxctl/meson.build
@@ -4,7 +4,6 @@ daxctl_src = [
   'list.c',
   'migrate.c',
   'device.c',
-  '../util/json.c',
   'json.c',
   'filter.c',
 ]
diff --git a/ndctl/meson.build b/ndctl/meson.build
index c7889af36084..050d5769c384 100644
--- a/ndctl/meson.build
+++ b/ndctl/meson.build
@@ -6,11 +6,9 @@ ndctl_src = [
   'check.c',
   'region.c',
   'dimm.c',
-  '../util/log.c',
   '../daxctl/filter.c',
   'filter.c',
   'list.c',
-  '../util/json.c',
   '../daxctl/json.c',
   'json.c',
   'json-smart.c',
diff --git a/util/meson.build b/util/meson.build
index 695037a924b9..a6ded7ee1473 100644
--- a/util/meson.build
+++ b/util/meson.build
@@ -3,6 +3,8 @@ util = static_library('util', [
   'parse-configs.c',
   'usage.c',
   'size.c',
+  'json.c',
+  'log.c',
   'main.c',
   'help.c',
   'strbuf.c',


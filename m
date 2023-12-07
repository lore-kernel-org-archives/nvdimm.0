Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4354115B9
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 01:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YyM61AO4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701914385; x=1733450385;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1KHDi3sJdG2+6WP+dz9Fwqez53nUTBtFNNJ+lOXtNfA=;
  b=YyM61AO4b3vQ+iM0r+1FUXh+vv7fHfF8buVY8ObrVKvl5k2fTBp5fz8H
   GKHEa1Hop+alzerDHrEAcUR0XvwJ8CKpBuVmS0fexeCthULM8UGJHteZX
   FvA5t6A3kOHWrwcveIyGEpo860t+vBXpGSEBuGfhZfGpmcK87SrWX62Jl
   rA5WqVexUu3IjuVJv7VcMuXk+QfqbXhoU2ltO1JHSeNWfYI5BdSVX7YFr
   J7v1CchqHigK33amLtMyP9P3RZf8u/rCT1uCSdxOfMAwwjaw45Qmff8kv
   H81mdkNj3ruNI6ylcuRd2wCu6/LjPhKCqp7jupfqS1g8nnqrRVjEpyADX
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="398039797"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="398039797"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 17:59:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="17405782"
Received: from dpdesmon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.70.214])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 17:59:39 -0800
Subject: [PATCH] tools/testing/nvdimm: Add compile-test coverage for ndtest
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Greg KH <gregkh@linuxfoundation.org>, Yi Zhang <yi.zhang@redhat.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Date: Wed, 06 Dec 2023 17:59:38 -0800
Message-ID: <170191437889.426826.15528612879942432918.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Greg lamented:
"Ick, sorry about that, obviously this test isn't actually built by any
bots :("

A quick and dirty way to prevent this problem going forward is to always
compile ndtest.ko whenever nfit_test is built. While this still does not
expose the test code to any of the known build bots, it at least makes
it the case that anyone that runs the x86 tests also compiles the
powerpc test.

I.e. the Intel NVDIMM maintainers are less likely to fall into this hole
in the future.

Link: http://lore.kernel.org/r/2023112729-aids-drainable-5744@gregkh
Cc: Greg KH <gregkh@linuxfoundation.org>
Cc: Yi Zhang <yi.zhang@redhat.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/nvdimm/test/Kbuild |    1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/nvdimm/test/Kbuild b/tools/testing/nvdimm/test/Kbuild
index 197bcb2b7f35..003d48f5f24f 100644
--- a/tools/testing/nvdimm/test/Kbuild
+++ b/tools/testing/nvdimm/test/Kbuild
@@ -7,6 +7,7 @@ obj-m += nfit_test_iomap.o
 
 ifeq  ($(CONFIG_ACPI_NFIT),m)
 	nfit_test-y := nfit.o
+	obj-m += ndtest.o
 else
 	nfit_test-y := ndtest.o
 endif


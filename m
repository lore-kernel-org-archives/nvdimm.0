Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D0C863AD
	for <nvdimm@lists.linux.dev>; Mon, 24 Apr 2023 19:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682366373; x=1713902373;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=l11voNp+QvHC/19k47wwy/r3eUgsJyAk0++aTZiTUDY=;
  b=NrqemXGOVYxdzWU5GvktIBQilPtVuJHiUtXxMwmLNpvv2+u7DVzKoy6D
   TACnz6tkbed4BSH8Gxqnw8T8gJNnrEBceWAk24PbDV7251XZAEOoPNf/e
   Uw+7F1QGY6WSd4zXS0AScQH9eTjJTnnVvD+Sv8dS4nGDRE/kssgi17RaE
   L9S9CsE/lMv6Qoa/P5pFfTDz5hsygxW31wu850NQeV/6ofddHHWmam/Zx
   jXb0LFXaq4DkADc25Qqny70SIB1rUtctcV3fVsoXrNunnZAh2UrOlDEgr
   LVen5ogpdfbgJbNxvY6GFB7agzKJEzRcJzlKI7kmUyG6WuIgI4UBJ2Kss
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="330754620"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="330754620"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 12:59:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="757834697"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="757834697"
Received: from fbirang-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.88.12])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 12:59:32 -0700
Subject: [ndctl PATCH 0/4] cxl list and test fixes
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 24 Apr 2023 12:59:31 -0700
Message-ID: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Hi Vishal,

These fixups are mostly unrelated, but sending them as a series to make
them easier to pull with b4.

The cxl-list fixups are some nice to haves I found while playing with
the tool on hardware. The test fixups are necessary for executing on
latest kernels and avoiding a compilation warning with latest compilers.

---

Dan Williams (4):
      cxl/list: Fix filtering RCDs
      cxl/list: Filter root decoders by region
      test: Support test modules located in 'updates' instead of 'extra'
      test: Fix dangling pointer warning


 cxl/filter.c     |    6 ++++++
 cxl/lib/libcxl.c |   19 ++++++++++++++++---
 test/core.c      |    2 +-
 test/libndctl.c  |    4 +++-
 4 files changed, 26 insertions(+), 5 deletions(-)

base-commit: b830c4af984e72e5849c0705669aad2ffa19db13

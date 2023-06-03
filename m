Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B6F290A
	for <nvdimm@lists.linux.dev>; Sat,  3 Jun 2023 06:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685772830; x=1717308830;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bQ2sTiLYprZK8QMBY7IeWzPFLq+yf23bR+mPekJMNgY=;
  b=Kk5ModYAs632eRaruNirDHedxkhdVDcX4bELz6+RoczBJNTgOLPNEVRX
   at5H39Ujt0CbxuG97OZCT+FCSiZahVRS7LN9D3b8pSQubl7wousV76bc3
   QIrXBdzaC12ure0Ic4D365hizOfeASGoxo1odz1mHQA+waKHxvcAG1oBI
   C9f173BByKMcY+qaHi1iNZwRs3UYQiJfr/9Yl29rNDfLMaNnhDB1hTYdm
   MjbDzRjPWFZ2eORx+vRYHW5+INLSVQv/uauWknxV9X0jbSqpftAxrmDPx
   AzzAVQR1rELWC4Q8nguenGhIQusT0/mP5KCwhBebtrMZS9u4yFFJmfQN6
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="354892833"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="354892833"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:13:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10729"; a="708078430"
X-IronPort-AV: E=Sophos;i="6.00,215,1681196400"; 
   d="scan'208";a="708078430"
Received: from rjkoval-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.230.247])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2023 23:13:48 -0700
Subject: [PATCH 0/4] dax: Fix use after free and other cleanups
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Yongqiang Liu <liuyongqiang13@huawei.com>, Paul Cassella <cassella@hpe.com>,
 Ira Weiny <ira.weiny@intel.com>, linux-cxl@vger.kernel.org
Date: Fri, 02 Jun 2023 23:13:48 -0700
Message-ID: <168577282846.1672036.13848242151310480001.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

As mentioned in patch3, the reference counting of dax_region objects is
needlessly complicated, has lead to confusion [1], and has hidden a bug
[2]. While testing the cleanup for those issues, a
CONFIG_DEBUG_KOBJECT_RELEASE test run uncovered a use-after-free in
dax_mapping_release(). Clean all of that up.

Thanks to Yongqiang, Paul, and Ira for their analysis.

[1]: http://lore.kernel.org/r/20221203095858.612027-1-liuyongqiang13@huawei.com
[2]: http://lore.kernel.org/r/3cf0890b-4eb0-e70e-cd9c-2ecc3d496263@hpe.com

---

Dan Williams (4):
      dax: Fix dax_mapping_release() use after free
      dax: Use device_unregister() in unregister_dax_mapping()
      dax: Introduce alloc_dev_dax_id()
      dax: Cleanup extra dax_region references


 drivers/dax/bus.c         |   64 +++++++++++++++++++++++++++------------------
 drivers/dax/bus.h         |    1 -
 drivers/dax/cxl.c         |    8 +-----
 drivers/dax/dax-private.h |    4 ++-
 drivers/dax/hmem/hmem.c   |    8 +-----
 drivers/dax/pmem.c        |    7 +----
 6 files changed, 44 insertions(+), 48 deletions(-)

base-commit: ac2263b588dffd3a1efd7ed0b156ea6c5aea200d

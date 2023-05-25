Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B312F1EA8B
	for <nvdimm@lists.linux.dev>; Thu, 25 May 2023 21:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685050833; x=1716586833;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bOpdYX6qCACVzsTl+M7OWZ/zO40ZppVDQsYXBw1pJO4=;
  b=LQTnqMZ3fFvQkrAyP4WlW807sJEp1Z7r2tBkq8BfFCUl4jXeiMMtlp02
   NQUqSl2N2NZNFi8ORwfitEIAEUX3zRC62IfE/DvzHY3SBzdy6IPxMPVsM
   GU2MqnE9Ql1mNXEe5q7YSgYL3TRxrSq/NCAtw23Ns7bUMwZ2LAHktCyxz
   eY5Bb9wb1Zy1DS+0xm1BNJeyE/jnZivUuk3WMDJTZQAXBV3IOGkZ3bp6W
   ShfpdaSFh+nNdHZWq6I6ZyKV3RtuJwdiQZmnO3jAYDAUTDoQuYhNolUMQ
   2X4b5ep7ZC0CItmR9GIER7whJkpCR5pDiG3lsMXFOYoS1yjFvpaBxihMc
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351544740"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="351544740"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 14:40:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="879297327"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="879297327"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.212.85.172])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 14:40:32 -0700
Subject: [ndctl PATCH v2 0/3] ndctl: Add support of QoS Throttling Group (QTG)
 id for CXL CLI                                                                                                         
v2: 
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 25 May 2023 14:40:31 -0700
Message-ID: <168505076089.2768411.10498775803334230215.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

- Updated against changed kernel sysfs attributes.
- See individual commit logs for detailed changes.

The series adds support for the kernel enabling [1] of QoS Throttling Group
(QTG) id. The kernel exports a QTG id for the root decoders (CFMWS) and as
well as for the CXL memory devices. The QTG id exported for a device is
calculated by the driver during device probe. Currently one or more QTG ids are       
exported for the volatile partition and another for the persistent partition.       
In the future QTG id(s) will be exported for DCD regions. Display of QTG id is
through the CXL CLI list command as qos_class.

A QTG id check as also been added for region creation. A warning is emitted
when the QTG id of a memory range of a CXL memory device being included in
the CXL region assembly does not match the QTG id of the root decoder. Options
are available to suppress the warning or to fail the region creation. This
enabling provides a guidance on flagging memory ranges being used is not
optimal for performance for the CXL region to be formed.

[1]: https://lore.kernel.org/linux-cxl/168451588868.3470703.3527256859632103687.stgit@djiang5-mobl3/T/#t  

---

Dave Jiang (3):
      ndctl: cxl: Add QoS class retrieval for the root decoder
      ndctl: cxl: Add QoS class support for the memory device
      ndctl: cxl: add QoS class check for CXL region creation


 Documentation/cxl/cxl-create-region.txt |  9 ++++
 cxl/filter.h                            |  4 ++
 cxl/json.c                              | 46 +++++++++++++++++-
 cxl/lib/libcxl.c                        | 64 +++++++++++++++++++++++++
 cxl/lib/libcxl.sym                      |  6 +++
 cxl/lib/private.h                       |  3 ++
 cxl/libcxl.h                            | 10 ++++
 cxl/list.c                              |  1 +
 cxl/region.c                            | 63 +++++++++++++++++++++++-
 util/json.h                             |  1 +
 10 files changed, 205 insertions(+), 2 deletions(-)

--
Signature


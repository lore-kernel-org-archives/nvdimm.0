Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 835BA2035D6C8
 for <linux-nvdimm@lists.01.org>; Tue,  1 May 2018 11:00:31 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/4] Error injection reworks
Date: Tue,  1 May 2018 12:00:19 -0600
Message-Id: <20180501180023.30193-1-vishal.l.verma@intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Updates to the error injection facilities in libndctl and ndctl that:
1. Inject fewer bytes per injected block:
  It is sufficient to inject even a single byte (cache line) for Linux
  to mark the entire block as a badblock. Reduce the number of injected
  bytes per block to the unit reported by clear_err_unit

2. Provide a --saturate option:
  If the old behavior of injecting the whole block for every block is
  desired, provide a --saturate option to get that.


Vishal Verma (4):
  libndctl, ars: add an API to retrieve clear_err_unit
  libndctl, inject: inject fewer bytes per block by default
  libndctl, inject: add 'v2' APIs for inject and uninject
  ndctl, inject-error: add a --saturate option

 Documentation/ndctl/ndctl-inject-error.txt |  14 ++
 ndctl/inject-error.c                       |  40 +++---
 ndctl/lib/ars.c                            |  15 +++
 ndctl/lib/inject.c                         | 201 ++++++++++++++++++++++-------
 ndctl/lib/libndctl.sym                     |   7 +
 ndctl/libndctl.h                           |  11 ++
 6 files changed, 222 insertions(+), 66 deletions(-)

-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

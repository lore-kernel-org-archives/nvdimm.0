Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DCA40212377E1
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 12:08:43 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/4] static analysis fixes
Date: Fri, 10 May 2019 13:08:35 -0600
Message-Id: <20190510190839.29637-1-vishal.l.verma@intel.com>
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

This series just contains a handful of static analysis fixes in
preparation for the v65 release.

Vishal Verma (4):
  ndctl/namespace.c: fix resource leak
  ndctl/namespace.c: fix an unchecked return value
  libndctl: Fix an unhandled return in ndctl_bus_poll_scrub_completion()
  ndctl/namespace.c: Fix a potential integer overflow

 ndctl/lib/libndctl.c |  2 ++
 ndctl/namespace.c    | 28 ++++++++++++++++------------
 2 files changed, 18 insertions(+), 12 deletions(-)

-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

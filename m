Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9DCA1210F48D8
 for <linux-nvdimm@lists.01.org>; Wed, 22 Aug 2018 15:23:00 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 0/2] xaction-namespace counting reworks
Date: Wed, 22 Aug 2018 16:22:47 -0600
Message-Id: <20180822222249.30838-1-vishal.l.verma@intel.com>
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
Cc: Steve Scargal <steve.scargall@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

There have been several reports of the counts printed for namespace
actions such as enable, disable, and especially destroy being incorrect
and confusing. These patches are an attempt to clean up and bring
greater consistency to these operations.

Patch 1 lays some groundwork for testing whether a namespace (under
destroy-namespace) that is supposed to have metadata due to its
personality (btt, pfn, dev-dax) has already had its info-blocks zeroed.
If that is the case, then allow for skipping the zeroing, and
communicate the fact. This is really only applicable for legacy
namespaces as in the labeled case, the label would have been
inconsistent if the metadata had been previously wiped.

Patch 2 builds on the above by creating a harder separation between the
result of an action vs. the number of objects (namespaces) the action
actually processed. Making the result independent of the number
processed allows us to make a cleaner decision on what exactly was done,
and print errors and/or counts accordingly.

Vishal Verma (2):
  ndctl, destroy-namespace: check for an already-zeroed info block
  ndctl, namespace: rework namespace action accounting

 ndctl/namespace.c | 197 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 116 insertions(+), 81 deletions(-)

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

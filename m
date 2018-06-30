Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F1FD202E540B
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 20:56:25 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [ndctl PATCH v2 0/2] always output array without --human
Date: Fri, 29 Jun 2018 21:55:50 -0600
Message-Id: <20180630035552.27049-1-ross.zwisler@linux.intel.com>
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, "Kani, Toshi" <toshi.kani@hpe.com>, Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

If "ndctl list" is only printing a single object it currently does not
print it in an array.  When printing multiple objects, though, an array is
used.  This simplifies the output for single objects when a human is
looking at it but it creates complications for parsers like jq.  jq
wants to know whether it is trying to parse an object or an array of
objects.

The first patch in this series is cleanup I noticed while fixing the
above issue with the second patch.

---

Changes since v1:
 * Dropped patch 2 that dealt with cleaning up the way flags are handled
   in ndctl/list.c. (Dan)

 * Added Dan's Ack to patch 1.

Ross Zwisler (2):
  ndctl: simplify JSON print flag handling
  ndctl list: always output array without --human

 daxctl/list.c        | 12 +++++++-----
 ndctl/bus.c          |  3 +--
 ndctl/dimm.c         |  3 +--
 ndctl/inject-smart.c |  3 +--
 ndctl/list.c         | 11 +++++------
 util/json.c          |  6 ++++--
 util/json.h          |  3 ++-
 7 files changed, 21 insertions(+), 20 deletions(-)

-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

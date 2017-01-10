Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6CA7F81B01
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jan 2017 17:11:32 -0800 (PST)
Subject: [PATCH 0/9] ndctl, create-namespace: updates and fixes
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 09 Jan 2017 17:07:25 -0800
Message-ID: <148401044568.16217.6942951063735168785.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Close some holes in namespace creation that allowed invalid
configurations to leak through to the kernel rather than trapping and
warning about them earlier.

Add a man page and rpm specfile support for the recently added daxctl
utility.

---

Dan Williams (9):
      ndctl, create-namespace: skip idle regions when scanning for capacity
      ndctl, create-namespace: skip blk regions when scanning for memory or dax mode
      ndctl, create-namespace: improve failure message
      ndctl, create-namespace: add an 'align' option
      daxctl, list: add man page
      daxctl: add daxctl to rpm spec
      ndctl: return unit size from parse_size64()
      ndctl: fix ndctl_region_get_interleave_ways(), set minimum
      ndctl, create-namespace: enforce --size must be even multiple of interleave-width


 Documentation/Makefile.am                |    3 -
 Documentation/daxctl-list.txt            |   78 ++++++++++++++++
 Documentation/ndctl-create-namespace.txt |   13 +++
 ndctl.spec.in                            |    8 +-
 ndctl/builtin-xaction-namespace.c        |  143 +++++++++++++++++++++++++-----
 ndctl/lib/libndctl.c                     |    7 +
 ndctl/lib/libndctl.sym                   |    1 
 ndctl/libndctl.h.in                      |    1 
 util/size.c                              |   17 +++-
 util/size.h                              |    2 
 10 files changed, 243 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/daxctl-list.txt
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

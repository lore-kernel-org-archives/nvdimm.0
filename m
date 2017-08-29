Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF4C121E70D39
 for <linux-nvdimm@lists.01.org>; Tue, 29 Aug 2017 13:05:13 -0700 (PDT)
Subject: [ndctl PATCH 0/7] ndctl: automatically initialize labels
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 29 Aug 2017 13:01:30 -0700
Message-ID: <150403689024.8240.10207637569759874850.stgit@dwillia2-desk3.amr.corp.intel.com>
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

The QEMU-KVM enabling for a virtual NVDIMM is an example of a
configuration where label-less namespaces are created by default. I.e.
the ACPI NFIT produced by SeaBIOS publishes un-aliased pmem regions. The
first operation an administrator is likely to perform is to reconfigure
the namespace into "memory" mode to enable full-featured DAX support.

The reconfiguration of the label-less namespace into "memory" mode is an
opportunity to also enable labels. This series effectively runs the
following sequence:

    ndctl disable-region all
    ndctl init-labels
    ndctl enabled-region all

...in 'create-namespace' whenever a label-less namespace is encountered.
The implementation is careful to try v1.2 labels and validate that the
kernel supports that scheme. Otherwise, it falls back to v1.1 labels.

For other utilities built on top of libndctl, the following new helpers
are provided to enable a similar flow:

    ndctl_dimm_read_labels()
    ndctl_dimm_validate_labels()
    ndctl_dimm_init_labels()

...where 'read_labels' enables the other apis, 'validate_labels' checks
whether the data retrieved from the read corresponds to a valid set of
namespace label index blocks, and 'init_labels' writes namespace index
blocks to the dimm. In order to check that the kernel supports a given
index block version / format the result from
ndctl_dimm_get_available_labels() can be compared to the result from
ndctl_dimm_init_labels() to make sure the kernel sees the same number of
available slots as userspace.

---

Dan Williams (7):
      ndctl, init-labels: fix '--label-version' option
      ndctl: drop the "libndctl-" prefix on library source files
      ndctl: move label manipulation routines to their own file
      ndctl: consolidate namespace definitions in namespace.h
      ndctl: refactor read_labels() helper into a library call
      ndctl: introduce ndctl_dimm_{validate_labels,init_labels}
      ndctl: auto initialize labels


 Documentation/ndctl/ndctl-create-namespace.txt |    7 
 Makefile.am                                    |    1 
 ndctl/check.c                                  |   52 ++
 ndctl/check.h                                  |  130 ------
 ndctl/dimm.c                                   |  547 +----------------------
 ndctl/lib/Makefile.am                          |   11 
 ndctl/lib/ars.c                                |    2 
 ndctl/lib/dimm.c                               |  565 ++++++++++++++++++++++++
 ndctl/lib/hpe1.c                               |    4 
 ndctl/lib/hpe1.h                               |    0 
 ndctl/lib/libndctl.c                           |  154 -------
 ndctl/lib/libndctl.sym                         |    4 
 ndctl/lib/msft.c                               |    4 
 ndctl/lib/msft.h                               |    0 
 ndctl/lib/private.h                            |  151 +++---
 ndctl/lib/smart.c                              |    2 
 ndctl/libndctl.h.in                            |    9 
 ndctl/namespace.c                              |  101 ++++
 ndctl/namespace.h                              |  163 +++++++
 util/fletcher.c                                |   35 -
 util/fletcher.h                                |   19 +
 21 files changed, 1021 insertions(+), 940 deletions(-)
 delete mode 100644 ndctl/check.h
 rename ndctl/lib/{libndctl-ars.c => ars.c} (99%)
 create mode 100644 ndctl/lib/dimm.c
 rename ndctl/lib/{libndctl-hpe1.c => hpe1.c} (99%)
 rename ndctl/lib/{ndctl-hpe1.h => hpe1.h} (100%)
 rename ndctl/lib/{libndctl-msft.c => msft.c} (98%)
 rename ndctl/lib/{ndctl-msft.h => msft.h} (100%)
 rename ndctl/lib/{libndctl-private.h => private.h} (69%)
 rename ndctl/lib/{libndctl-smart.c => smart.c} (99%)
 create mode 100644 ndctl/namespace.h
 delete mode 100644 util/fletcher.c
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

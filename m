Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 29B911A1E45
 for <linux-nvdimm@lists.01.org>; Tue, 13 Sep 2016 10:43:46 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH v2 0/4] ndctl: add support for HPE type N SMART health
 data
Date: Tue, 13 Sep 2016 12:41:36 -0500
Message-Id: <20160913174140.10810-1-brian.boylston@hpe.com>
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

This set of patches adds support for the HPE SMART DSM functions and enables
ndctl to report DIMM health data for HPE type N NVDIMMs.  The relevant
firmware interfaces are described in [1].

The first patch virtualizes the ndctl_cmd_smart*() family of libndctl
interfaces into a set of ndctl_smart_ops, allowing runtime implementation
differentiation depending on the firmware support provided by a DIMM.

The second and third patches add miscellaneous pieces needed for the
final patch:

The fourth patch adds a set of ndctl_smart_ops for the HPE1 DSM family,
based on the firmware interfaces defined in [1].  These ndctl_smart_ops
translate the HPE1 DSM output to match the interface of the existing
Intel DSM-inspired smart_ops.  This delivers health reporting parity for
HPE type N NVDIMMs, however:

When evaluating this ndctl_smart_ops approach, please consider our goal of
adding JSON exports for some of the additional health data defined in [1].
I expect this would entail adding additional accessor functions to
ndctl_smart_ops, but it's not clear whether or how to extend the existing
get_flags()/check flags/get_data() model used by util_dimm_health_to_json().

If you'd like to test these changes, note the following:

. Some of the DSM functions for HPE type N NVDIMMs, including the ones used
  by this patch, require the acpi_ipmi kernel module to be loaded, and you
  may need to manually modprobe it.

. Without [2], you'll need to include '--idle' in your ndctl invocation as
  ndctl will consider type Ns to be disabled and will otherwise omit them.

. Without [3], "alarm_temperature" and "alarm_spares" will be inaccurate.

[1] https://github.com/HewlettPackard/hpe-nvm/raw/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v84s.pdf
[2] https://lists.01.org/pipermail/linux-nvdimm/2016-August/006619.html
[3] https://lists.01.org/pipermail/linux-nvdimm/2016-September/006810.html

Changes in v2:
  New approach: taught libndctl how to translate between the HPE1 DSM
  family and the existing ndctl_cmd_smart*() libndctl interfaces
  (as suggested by Dan).

Brian Boylston (4):
  libndctl: introduce ndctl_smart_ops
  libndctl: record dsm family in add_dimm()
  libndctl: enable ND_CMD_CALL
  libndctl: add support for the HPE1 family of DSM SMART functions

 ndctl/Makefile.am            |   1 +
 ndctl/lib/libndctl-hpe1.c    | 303 ++++++++++++++++++++++++++++++++++++++
 ndctl/lib/libndctl-private.h |  22 +++
 ndctl/lib/libndctl-smart.c   | 111 +++++++++++---
 ndctl/lib/libndctl.c         |  20 ++-
 ndctl/lib/ndctl-hpe1.h       | 335 +++++++++++++++++++++++++++++++++++++++++++
 ndctl/libndctl.h.in          |   1 +
 7 files changed, 769 insertions(+), 24 deletions(-)
 create mode 100644 ndctl/lib/libndctl-hpe1.c
 create mode 100644 ndctl/lib/ndctl-hpe1.h

-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

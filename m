Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37DEF1A1DFC
 for <linux-nvdimm@lists.01.org>; Fri,  2 Sep 2016 06:33:59 -0700 (PDT)
From: Brian Boylston <brian.boylston@hpe.com>
Subject: [ndctl PATCH 0/2] ndctl: add support for HPE type N SMART health data
Date: Fri,  2 Sep 2016 08:32:36 -0500
Message-Id: <20160902133238.22200-1-brian.boylston@hpe.com>
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

This pair of patches adds support for the HPE SMART DSM functions and enables
ndctl to report DIMM health data for HPE type N NVDIMMs.  The relevant
firmware interfaces are described in [1].

The first patch simply makes the existing parse_smart_temperature() function
global so that it can be used by the new HPE-specific code.

The second patch adds an HPE equivalent for the existing
util_dimm_health_to_json().  util_hpe_dimm_health_to_json() calls the HPE
DSM functions and populates a JSON object with health data.  This patch
delivers health reporting parity for HPE type N NVDIMMs, but we are planning
a future patch to export JSON for some of the additional health data defined
in [1].

If you'd like to test these changes, note the following:

. Some of the DSM functions for HPE type N NVDIMMs, including the ones used
  by this patch, require the acpi_ipmi kernel module to be loaded, and you
  may need to manually modprobe it.

. Without [2], you'll need to include '--idle' in your ndctl invocation as
  ndctl will consider type Ns to be disabled and will otherwise omit them.

[1] https://github.com/HewlettPackard/hpe-nvm/raw/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v84s.pdf
[2] https://lists.01.org/pipermail/linux-nvdimm/2016-August/006619.html

Brian Boylston (2):
  util: make parse_smart_temperature() global
  ndctl, util: add support for HPE DSM SMART interfaces

 ndctl/Makefile.am       |   1 +
 ndctl/builtin-list.c    |   2 +
 ndctl/util/json-hpe.c   | 283 ++++++++++++++++++++++++++++++++++++++++
 ndctl/util/json-smart.c |   2 +-
 ndctl/util/json.h       |  11 ++
 ndctl/util/ndctl-hpe1.h | 335 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 633 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/util/json-hpe.c
 create mode 100644 ndctl/util/ndctl-hpe1.h

-- 
2.8.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

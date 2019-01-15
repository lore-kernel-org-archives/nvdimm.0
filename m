Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8C74621C8EFB5
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 18:09:41 -0800 (PST)
Subject: [PATCH v2 0/2] acpi/nfit: Fix command-supported detection
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jan 2019 17:57:04 -0800
Message-ID: <154751742416.1617064.8252289468130584022.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Sujith Pandel <sujith_pandel@dell.com>, stuart hayes <stuart.w.hayes@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

Changes since v1 [1]:
* Include another patch make sure that function-number zero can be
  safely used as an invalid function number (Jeff)
* Add a comment clarifying why zero is an invalid function number (Jeff)
* Pass nfit_mem to cmd_to_func() (Jeff)
* Collect a Tested-by from Sujith
[1]: https://lists.01.org/pipermail/linux-nvdimm/2019-January/019435.html

---

Quote patch2 changelog:

The _DSM function number validation only happens to succeed when the
generic Linux command number translation corresponds with a
DSM-family-specific function number. This breaks NVDIMM-N
implementations that correctly implement _LSR, _LSW, and _LSI, but do
not happen to publish support for DSM function numbers 4, 5, and 6.

Recall that the support for _LS{I,R,W} family of methods results in the
DIMM being marked as supporting those command numbers at
acpi_nfit_register_dimms() time. The DSM function mask is only used for
ND_CMD_CALL support of non-NVDIMM_FAMILY_INTEL devices.

---

Dan Williams (2):
      acpi/nfit: Block function zero DSMs
      acpi/nfit: Fix command-supported detection


 drivers/acpi/nfit/core.c |   53 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 14 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

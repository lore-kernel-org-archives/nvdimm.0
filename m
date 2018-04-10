Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C06112261815F
 for <linux-nvdimm@lists.01.org>; Tue, 10 Apr 2018 15:49:05 -0700 (PDT)
Subject: [PATCH 0/5] libnvdimm: fix locked status detection
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 10 Apr 2018 15:39:09 -0700
Message-ID: <152339994885.16061.1760220735664848631.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The new ACPI _LSx methods moved the 'dimm locked' error status from the
result of ND_CMD_GET_CONFIG_SIZE to an error status result of
ND_CMD_GET_CONFIG_DATA. Error code translation prevents the proper error
code from making it back to the 'nd_dimm' driver.

Fix the error code propagation and add some unit test infrastructure for
regression testing this case.

---

Dan Williams (5):
      libnvdimm, dimm: handle EACCES failures from label reads
      tools/testing/nvdimm: allow custom error code injection
      tools/testing/nvdimm: support nfit_test_dimm attributes under nfit_test.1
      tools/testing/nvdimm: fix missing newline in nfit_test_dimm 'handle' attribute
      tools/testing/nvdimm: enable labels for nfit_test.1 dimms


 drivers/nvdimm/dimm_devs.c       |   22 +++++-----
 tools/testing/nvdimm/test/nfit.c |   84 +++++++++++++++++++++++++++++---------
 2 files changed, 77 insertions(+), 29 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

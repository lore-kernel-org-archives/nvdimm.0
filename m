Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hp.com (g4t3425.houston.hp.com [15.201.208.53])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D62301A1EE5
 for <linux-nvdimm@lists.01.org>; Mon, 25 Apr 2016 14:43:44 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 0/2] Support ACPI 6.1 update in NFIT Control Region
 Structure
Date: Mon, 25 Apr 2016 15:34:57 -0600
Message-Id: <1461620099-11933-1-git-send-email-toshi.kani@hpe.com>
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
To: rjw@rjwysocki.net, dan.j.williams@intel.com
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, robert.moore@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

ACPI 6.1, Table 5-133, updates NVDIMM Control Region Structure as
follows.
 - Valid Fields, Manufacturing Location, and Manufacturing Date
   are added from reserved range.  No change in the structure size.
 - IDs (SPD values) are stored as arrays of bytes (i.e. big-endian
   format).  The spec clarifies that they need to be represented
   as arrays of bytes as well.

Patch 1 changes the NFIT driver to comply with ACPI 6.1.
Patch 2 adds a new sysfs file "id" to show NVDIMM ID defined in ACPI 6.1.

The patch-set applies on linux-pm.git acpica.

link: http://www.uefi.org/sites/default/files/resources/ACPI_6_1.pdf

---
v3:
 - Need to coordinate with ACPICA update (Bob Moore, Dan Williams)
 - Integrate with ACPICA changes in struct acpi_nfit_control_region.
   (commit 138a95547ab0)

v2:
 - Remove 'mfg_location' and 'mfg_date'. (Dan Williams)
 - Rename 'unique_id' to 'id' and make this change as a separate patch.
   (Dan Williams)

---
Toshi Kani (3):
 1/2 acpi/nfit: Update nfit driver to comply with ACPI 6.1
 2/3 acpi/nfit: Add sysfs "id" for NVDIMM ID

---
 drivers/acpi/nfit.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E78B6256E
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 22:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670366803; x=1701902803;
  h=subject:mime-version:content-transfer-encoding:from:date:
   message-id:to:cc;
  bh=LfnGne5nqpKqVmYbhyqRfp+t/XhB6rxG8HipNM237sc=;
  b=J4K8szFDP9GarrZ1Me6/cFXfG41ZXxG5dLtyf7fjPCshT1tsJBXk6NYq
   lWJCQ687EtRsOlUMOVXZf3gfym42krAzjQ4POQFIWNTrpRCFTsrmssth3
   WcbyQjjN0q8wVV05+Sv1N2fcNr1iyIaZxHzI+R72FC2ke0xI73/PEbpqr
   0rP1U9kiJYDBs+mfIwK0FHh1u7j4gnFJEUtP6KFfvPPQIkxWWL921YisU
   5T8vsHM5Gis7g3tcA+hbKwgeBQ/9EFhtDu8Pp4OxC27RUV7PS5f67Yiuf
   MPuhzq740fZanIwlaZdJJnjHHdADWn2x05RbhRiAthPYIna64HDTv2uLZ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="315462737"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="315462737"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 14:46:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="714967825"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="714967825"
Received: from yguo-mobl1.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.82.140])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 14:46:26 -0800
Subject: [PATCH ndctl 0/2] misc meson.build and clang-format updates
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAD7Gj2MC/x2NMQrDMAwAvxI0V2BpyNCvhA6OLSeCVA1WMYWQv8
 fpeNzBHeBSVRyewwFVmrp+rAM9BkhrtEVQc2fgwEwcRmwN3+oJiUvJFEaSEKHXc3TBuUZL693vYl
 ltuc1epejv/5jAcvpu8DrPC53/9ap6AAAA
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 06 Dec 2022 15:46:22 -0700
Message-Id: <20221206-vv-misc-v1-0-4c5bd58c90ca@intel.com>
To: nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
X-Mailer: b4 0.11.0-dev-b6525
X-Developer-Signature: v=1; a=openpgp-sha256; l=662;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=LfnGne5nqpKqVmYbhyqRfp+t/XhB6rxG8HipNM237sc=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMn9xxxvTFqTp7Tg5FODLzG3fBhc9aL0V5krfu/hSxEsd/bT
 d+LrKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwEQmf2Rk2HCg0TDWrv5j6xarwlNbfX
 8dcTNrKnkT75hSuZXly+upfIwM37I5/kSs3h63eP2fLTfWSjxPiq5WvfFq5rQ19bFs2fti2AA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Patch 1 adds a .clang-format option to reformat macros for aligning

Patch 2 squelches a warning from a meson update.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

---
Vishal Verma (2):
      clang-format: Align consecutive macros and #defines
      meson.build: add a check argument to run_command

 .clang-format | 1 +
 meson.build   | 1 +
 2 files changed, 2 insertions(+)
---
base-commit: 3591a1bea2bd90349963b02aeb9064dc3fbd3d83
change-id: 20221206-vv-misc-12ffd1061e0a

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

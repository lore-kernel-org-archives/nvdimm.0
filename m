Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6C3315C9A
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 23:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668642088; x=1700178088;
  h=subject:mime-version:content-transfer-encoding:from:date:
   message-id:to;
  bh=gcknXCLuemBiw6QyYPT0m60B03ddAIIJISsWvFv8N2A=;
  b=gvC8nGezjg2vJC8Y/Pz/9r3y13zbtrwNeatmAvIPAC8aBeBVM6MI7H2k
   Yz49o4s2mFNMG5q3k063JV1d5mkNgbw6KiYGQm5m6jRf+Ndr7Wsx7zC0d
   KwXT2vVp3/9/308iT92lbvwvchPp4hRHC87MWExmQOGe6cNOEXPh35j3G
   +Hdv4xHI9JE2wtWo8DxJFTVybiuL+0UTEq6T/sbsMmbtvB3PDP5CML+rg
   hgVOdSzRb7iKMiFd/dGk5dyLn7D/81kdLr9OEJzB/0AbIjDJKSHz7tPYR
   KvMquCKmVkVRjdO5cZjWsJS0XAVT9XrcyUq+nOOcOkcQsphiqx4tx/8BS
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="339519700"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="339519700"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:28 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="641848518"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="641848518"
Received: from jjeyaram-mobl1.amr.corp.intel.com (HELO [192.168.1.28]) ([10.212.1.223])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 15:41:27 -0800
Subject: [PATCH v2 0/2] ACPI: HMAT: fix single-initiator target registrations
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-b4-tracking: H4sIAD90dWMC/z2OwQrCMBBEf6Xs2YQk1YZ68j9EynZNzUKaSFKLUvrvBg+ehhl4M7NBcZldgXOzQX
 YrF06xGnNogDzGhxN8rx6MMkZr3QmkJw9+xmWY+C0s0nQcCVtLCiozYnFizBjJVyq+Qqih57Kk/Plt
 rLrK9V+n7Mm2ndS96rteCS3qA49BBrm6POOF4+KCpDTDbd/3L3hSabKuAAAA
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 16 Nov 2022 16:37:35 -0700
Message-Id: <20221116-acpi_hmat_fix-v2-0-3712569be691@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Vishal Verma <vishal.l.verma@intel.com>,
 linux-kernel@vger.kernel.org, Chris Piper <chris.d.piper@intel.com>, nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
 "Rafael J. Wysocki" <rafael@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Liu Shixin <liushixin2@huawei.com>, stable@vger.kernel.org
X-Mailer: b4 0.11.0-dev-d1636
X-Developer-Signature: v=1; a=openpgp-sha256; l=1380;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=gcknXCLuemBiw6QyYPT0m60B03ddAIIJISsWvFv8N2A=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmlpeqLbCaqG/ZfYnqxx+nhqoR3PKfqXh/hYqsqXyDMtOJO
 9MGfHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiInCzDP4Vfyk9MrX5umfrqYflbtu
 meV6foTm1bxyRpUbljS4mbyXKG/9X2l2XXX1yVdbupbdVGjmTG6hWRbzaWzyzmclKJEpdjYwYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Patch 1 is an obvious cleanup found while fixing this problem.

Patch 2 Fixes a bug with initiator registration for single-initiator
systems. More details on this in its commit message.

Rafael - I didn't retain your ack for patch 2 since it seemed like a
nontrivial change.

Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: <stable@vger.kernel.org>
Cc: Chris Piper <chris.d.piper@intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

---
Changes in v2:
- Collect Acks for patch 1.
- Separate out the bitmask generation from the comparision helper to make
  it more explicit and easier to follow (Kirill)
- Link to v1: https://lore.kernel.org/r/20221116075736.1909690-1-vishal.l.verma@intel.com

---
Vishal Verma (2):
      ACPI: HMAT: remove unnecessary variable initialization
      ACPI: HMAT: Fix initiator registration for single-initiator systems

 drivers/acpi/numa/hmat.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)
---
base-commit: 9abf2313adc1ca1b6180c508c25f22f9395cc780
change-id: 20221116-acpi_hmat_fix-7acf4bca37c0

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

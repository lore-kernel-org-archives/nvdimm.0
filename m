Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91DB5699
	for <nvdimm@lists.linux.dev>; Tue,  6 Dec 2022 22:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670366805; x=1701902805;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=ToqmKAyyRaJ6ZoX99Yt1guKhk5QExAnBdA7MsFAd2mc=;
  b=loUUb24gvVA2gbpT9CLg6OTroFem6v5tDWkXvNX8z33dnHjd+mw4PNMk
   oAw0lzHFikvR7uYDTzF8E938rqhe655supNPWtEpOw65z0q/Ec9crD5np
   ZVpmbVRqshiAe0gTgXcZK2khLF9AbS+/+ESpBzrqbbsDB2nL1A6myTdRK
   B/vp7siO913o5MrSwCe6/UJUkwvkJUiX95x49W2XGell9s/PQ4i1BqOIa
   t5SWk7fOzhAguRxfedKd+I/Urgpw6OD4UzuQDxNS/xaU/pQyJYttmAFBe
   FVWqlwXmEoS+P0DrFEq3SAh22wngQgjGyACnneuDHCIY9Jikdp9l+o6ph
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="315462741"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="315462741"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 14:46:26 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10553"; a="714967830"
X-IronPort-AV: E=Sophos;i="5.96,223,1665471600"; 
   d="scan'208";a="714967830"
Received: from yguo-mobl1.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.82.140])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2022 14:46:26 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 06 Dec 2022 15:46:23 -0700
Subject: [PATCH ndctl 1/2] clang-format: Align consecutive macros and #defines
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20221206-vv-misc-v1-1-4c5bd58c90ca@intel.com>
References: <20221206-vv-misc-v1-0-4c5bd58c90ca@intel.com>
In-Reply-To: <20221206-vv-misc-v1-0-4c5bd58c90ca@intel.com>
To: nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org
X-Mailer: b4 0.11.0-dev-b6525
X-Developer-Signature: v=1; a=openpgp-sha256; l=748;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=ToqmKAyyRaJ6ZoX99Yt1guKhk5QExAnBdA7MsFAd2mc=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMn9x5zaKuuNhYW47TcmeDFzfWqL5AnSae13VFCw/iCg6Pbk
 z9OOUhYGMS4GWTFFlr97PjIek9uezxOY4Agzh5UJZAgDF6cATIRDkpFhlstvaznps2y3G/8zaMjK3b
 LZnPXDSnOBdLjeT6kZqq8zGBn2vfV3+ufLMiPX+sHvV06vNi8IEzj12PG8bZ3JZ6O9CxRZAQ==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add AlignConsecutiveMacros: true so that blocks of consecutive #defines
can be neatly aligned.

Cc: Dan Williams <dan.j.williams@intel.com>
Reported-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 .clang-format | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.clang-format b/.clang-format
index b6169e1..9ea49bf 100644
--- a/.clang-format
+++ b/.clang-format
@@ -13,6 +13,7 @@ AccessModifierOffset: -4
 AlignAfterOpenBracket: Align
 AlignConsecutiveAssignments: false
 AlignConsecutiveDeclarations: false
+AlignConsecutiveMacros: true
 #AlignEscapedNewlines: Left # Unknown to clang-format-4.0
 AlignOperands: true
 AlignTrailingComments: false

-- 
2.38.1

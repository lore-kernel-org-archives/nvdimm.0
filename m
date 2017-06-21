Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A5F5021BBC409
 for <linux-nvdimm@lists.01.org>; Wed, 21 Jun 2017 13:29:23 -0700 (PDT)
From: "Luck, Tony" <tony.luck@intel.com>
Subject: RE: [PATCH] mm/hwpoison: Clear PRESENT bit for kernel 1:1 mappings
 of poison pages
Date: Wed, 21 Jun 2017 20:30:46 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F612DCCAF@ORSMSX114.amr.corp.intel.com>
References: <20170616190200.6210-1-tony.luck@intel.com>
 <20170621021226.GA18024@hori1.linux.bs1.fc.nec.co.jp>
 <20170621175403.n5kssz32e2oizl7k@intel.com>
 <AT5PR84MB0082AF4EDEB05999494CA62FABDA0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
In-Reply-To: <AT5PR84MB0082AF4EDEB05999494CA62FABDA0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
Content-Language: en-US
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
To: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Vaden, Tom (HPE Server OS Architecture)" <tom.vaden@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Hansen,
List-ID: <linux-nvdimm@lists.01.org>

> Persistent memory does have unpoisoning and would require this inverse
> operation - see drivers/nvdimm/pmem.c pmem_clear_poison() and core.c
> nvdimm_clear_poison().

Nice.  Well this code will need to cooperate with that ... in particular if the page
is in an area that can be unpoisoned ... then we should do that *instead* of marking
the page not present (which breaks up huge/large pages and so affects performance).

Instead of calling it "arch_unmap_pfn" it could be called something like arch_handle_poison()
and do something like:

void arch_handle_poison(unsigned long pfn)
{
	if this is a pmem page && pmem_clear_poison(pfn)
		return
	if this is a nvdimm page && nvdimm_clear_poison(pfn)
		return
	/* can't clear, map out from 1:1 region */
	... code from my patch ...
}

I'm just not sure how those first two "if" bits work ... particularly in terms of CONFIG dependencies and system
capabilities.  Perhaps each of pmem and nvdimm could register their unpoison functions and this code could
just call each in turn?

-Tony


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

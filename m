Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F2AAB2095D214
 for <linux-nvdimm@lists.01.org>; Fri, 23 Jun 2017 15:19:26 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] mm/hwpoison: Clear PRESENT bit for kernel 1:1 mappings of
 poison pages
Date: Fri, 23 Jun 2017 22:19:35 +0000
Message-ID: <AT5PR84MB00823EB30BD7BF0EA3DAFF0BABD80@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170616190200.6210-1-tony.luck@intel.com>
 <20170619180147.qolal6mz2wlrjbxk@pd.tnic>
 <20170621174740.npbtg2e4o65tyrss@intel.com>
In-Reply-To: <20170621174740.npbtg2e4o65tyrss@intel.com>
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
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Yazen Ghannam <yazen.ghannam@amd.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> > > +	if (set_memory_np(decoy_addr, 1))
> > > +		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map \n",

Another concept to consider is mapping the page as UC rather than
completely unmapping it.

The uncorrectable error scope could be smaller than a page size, like:
* memory ECC width (e.g., 8 bytes)
* cache line size (e.g., 64 bytes)
* block device logical block size (e.g., 512 bytes, for persistent memory)

UC preserves the ability to access adjacent data within the page that
hasn't gone bad, and is particularly useful for persistent memory.

---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

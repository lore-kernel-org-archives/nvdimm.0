Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6C9721AE263B
 for <linux-nvdimm@lists.01.org>; Wed, 21 Jun 2017 12:46:38 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] mm/hwpoison: Clear PRESENT bit for kernel 1:1 mappings of
 poison pages
Date: Wed, 21 Jun 2017 19:47:57 +0000
Message-ID: <AT5PR84MB0082AF4EDEB05999494CA62FABDA0@AT5PR84MB0082.NAMPRD84.PROD.OUTLOOK.COM>
References: <20170616190200.6210-1-tony.luck@intel.com>
 <20170621021226.GA18024@hori1.linux.bs1.fc.nec.co.jp>
 <20170621175403.n5kssz32e2oizl7k@intel.com>
In-Reply-To: <20170621175403.n5kssz32e2oizl7k@intel.com>
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
To: "Luck, Tony" <tony.luck@intel.com>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "Vaden, Tom (HPE Server OS Architecture)" <tom.vaden@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "x86@kernel.org" <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, Borislav Petkov <bp@suse.de>
List-ID: <linux-nvdimm@lists.01.org>


> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Luck, Tony
> Sent: Wednesday, June 21, 2017 12:54 PM
> To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: Borislav Petkov <bp@suse.de>; Dave Hansen <dave.hansen@intel.com>;
> x86@kernel.org; linux-mm@kvack.org; linux-kernel@vger.kernel.org

(adding linux-nvdimm list in this reply)

> Subject: Re: [PATCH] mm/hwpoison: Clear PRESENT bit for kernel 1:1
> mappings of poison pages
> 
> On Wed, Jun 21, 2017 at 02:12:27AM +0000, Naoya Horiguchi wrote:
> 
> > We had better have a reverse operation of this to cancel the unmapping
> > when unpoisoning?
> 
> When we have unpoisoning, we can add something.  We don't seem to have
> an inverse function for "set_memory_np" to just flip the _PRESENT bit
> back on again. But it would be trivial to write a set_memory_pp().
> 
> Since we'd be doing this after the poison has been cleared, we wouldn't
> need to play games with the address.  We'd just use:
> 
> 	set_memory_pp((unsigned long)pfn_to_kaddr(pfn), 1);
> 
> -Tony

Persistent memory does have unpoisoning and would require this inverse
operation - see drivers/nvdimm/pmem.c pmem_clear_poison() and core.c
nvdimm_clear_poison().

---
Robert Elliott, HPE Persistent Memory




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

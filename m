Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 951E82244E410
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 16:02:01 -0700 (PDT)
Date: Mon, 16 Apr 2018 17:02:00 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v2] dax: Change return type to vm_fault_t
Message-ID: <20180416230200.GB24742@linux.intel.com>
References: <20180416185044.GA29337@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180416185044.GA29337@jordon-HP-15-Notebook-PC>
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
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: rdunlap@infradead.org, willy@infradead.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 17, 2018 at 12:20:44AM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault and huge_fault
> handler. For now, this is just documenting that the
> function returns a VM_FAULT value rather than an errno.
> Once all instances are converted, vm_fault_t will become
> a distinct type.

I'm not sure what you mean by "vm_fault_t will become a distinct type"?  Do
you mean you'll make it into an enum, i.e.: 

enum vm_fault_t {
	VM_FAULT_OOM		= 0x0001,
	VM_FAULT_SIGBUS		= 0x0002,
	VM_FAULT_MAJOR		= 0x0004,
	VM_FAULT_WRITE		= 0x0008,
	VM_FAULT_HWPOISON	= 0x0010,
	VM_FAULT_HWPOISON_LARGE	= 0x0020,
	VM_FAULT_NOPAGE		= 0x0100,
	VM_FAULT_LOCKED		= 0x0200,
	VM_FAULT_RETRY		= 0x0400,
	VM_FAULT_FALLBACK	= 0x0800,
	VM_FAULT_DONE_COW	= 0x1000,
	VM_FAULT_NEEDDSYNC	= 0x2000,
};

If so, I think that would be great for readability.  Right now I look up the
definition of vm_fault_t and see it's typedef'd to an int, and that doesn't
give me as much info as the above enum would.

If this is the plan, I don't understand why you need to make all the site
conversions first?

> Reference id -> 1c8f422059ae ("mm: change return type to
> vm_fault_t")
> 
> Previously vm_insert_mixed() returns err which driver
> mapped into VM_FAULT_* type. The new function 
> vmf_insert_mixed() will replace this inefficiency by
> returning VM_FAULT_* type.
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
> Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
> ---
> v2: Modified the change log
> 
> v3: Updated the change log

You've only got a v2. :)  

Sure, the code looks correct. You can add:
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

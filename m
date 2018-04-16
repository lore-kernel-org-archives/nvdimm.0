Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D7B32244E410
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 16:21:56 -0700 (PDT)
Date: Mon, 16 Apr 2018 16:21:55 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2] dax: Change return type to vm_fault_t
Message-ID: <20180416232155.GA25048@bombadil.infradead.org>
References: <20180416185044.GA29337@jordon-HP-15-Notebook-PC>
 <20180416230200.GB24742@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180416230200.GB24742@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: rdunlap@infradead.org, Souptick Joarder <jrdr.linux@gmail.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 16, 2018 at 05:02:00PM -0600, Ross Zwisler wrote:
> I'm not sure what you mean by "vm_fault_t will become a distinct type"?  Do
> you mean you'll make it into an enum, i.e.: 
> 
> enum vm_fault_t {
> 	VM_FAULT_OOM		= 0x0001,
> 	VM_FAULT_SIGBUS		= 0x0002,
> 	VM_FAULT_MAJOR		= 0x0004,
> 	VM_FAULT_WRITE		= 0x0008,
> 	VM_FAULT_HWPOISON	= 0x0010,
> 	VM_FAULT_HWPOISON_LARGE	= 0x0020,
> 	VM_FAULT_NOPAGE		= 0x0100,
> 	VM_FAULT_LOCKED		= 0x0200,
> 	VM_FAULT_RETRY		= 0x0400,
> 	VM_FAULT_FALLBACK	= 0x0800,
> 	VM_FAULT_DONE_COW	= 0x1000,
> 	VM_FAULT_NEEDDSYNC	= 0x2000,
> };

My current tree has this in it:

+/*
+ * Different kinds of faults, as returned from fault handlers.
+ * Used to decide whether a process gets delivered SIGBUS or
+ * just gets major/minor fault counters bumped up.
+ */
+typedef __bitwise unsigned int vm_fault_t;
+enum {
+       VM_FAULT_OOM            = (__force vm_fault_t)0x000001, /* Out Of Memory */
+       VM_FAULT_SIGBUS         = (__force vm_fault_t)0x000002, /* Bad access */
+       VM_FAULT_MAJOR          = (__force vm_fault_t)0x000004, /* Page read from storage */
+       VM_FAULT_WRITE          = (__force vm_fault_t)0x000008, /* Special case for get_user_pages */
+       VM_FAULT_HWPOISON       = (__force vm_fault_t)0x000010, /* Hit poisoned small page */
+       VM_FAULT_HWPOISON_LARGE = (__force vm_fault_t)0x000020, /* Hit poisoned large page. Index encoded in upper bits */
+       VM_FAULT_SIGSEGV        = (__force vm_fault_t)0x000040,
+       VM_FAULT_NOPAGE         = (__force vm_fault_t)0x000100, /* ->fault installed the pte, not return page */
+       VM_FAULT_LOCKED         = (__force vm_fault_t)0x000200, /* ->fault locked the returned page */
+       VM_FAULT_RETRY          = (__force vm_fault_t)0x000400, /* ->fault blocked, must retry */
+       VM_FAULT_FALLBACK       = (__force vm_fault_t)0x000800, /* huge page fault failed, fall back to small */
+       VM_FAULT_DONE_COW       = (__force vm_fault_t)0x001000, /* ->fault has fully handled COW */
+       VM_FAULT_NEEDDSYNC      = (__force vm_fault_t)0x002000, /* ->fault did not modify page tables
+                                        * and needs fsync() to complete (for
+                                        * synchronous page faults in DAX) */
+       VM_FAULT_HINDEX_MASK    = (__force vm_fault_t)0x0f0000,
+};

However, I'm hoping to get a better syntax into sparse ;-)

> If so, I think that would be great for readability.  Right now I look up the
> definition of vm_fault_t and see it's typedef'd to an int, and that doesn't
> give me as much info as the above enum would.
> 
> If this is the plan, I don't understand why you need to make all the site
> conversions first?

Changing it from a signed to an unsigned int causes GCC to warn about
an assignment from an incompatible type -- int foo(void) is incompatible
with unsigned int foo(void).

> Sure, the code looks correct. You can add:
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Thanks, Ross.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

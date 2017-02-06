Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D16E28203F
 for <linux-nvdimm@lists.01.org>; Mon,  6 Feb 2017 06:36:52 -0800 (PST)
Date: Mon, 6 Feb 2017 06:36:48 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] mm: replace FAULT_FLAG_SIZE with parameter to huge_fault
Message-ID: <20170206143648.GA461@infradead.org>
References: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <148615748258.43180.1690152053774975329.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: mawilcox@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@linux.intel.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kirill.shutemov@linux.intel.com, jack@suse.com, akpm@linux-foundation.org, linux-ext4@vger.kernel.org, vbabka@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 03, 2017 at 02:31:22PM -0700, Dave Jiang wrote:
> Since the introduction of FAULT_FLAG_SIZE to the vm_fault flag, it has
> been somewhat painful with getting the flags set and removed at the
> correct locations. More than one kernel oops was introduced due to
> difficulties of getting the placement correctly. Removing the flag
> values and introducing an input parameter to huge_fault that indicates
> the size of the page entry. This makes the code easier to trace and
> should avoid the issues we see with the fault flags where removal of the
> flag was necessary in the fallback paths.

Why is this not in struct vm_fault?  Also can be use this opportunity
to fold ->huge_fault into ->fault?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

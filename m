Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB34821A16EED
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 11:23:10 -0700 (PDT)
Date: Wed, 17 May 2017 12:23:09 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 1/2] mm: avoid spurious 'bad pmd' warning messages
Message-ID: <20170517182309.GA30704@linux.intel.com>
References: <20170517171639.14501-1-ross.zwisler@linux.intel.com>
 <9c45c769-2f5e-9327-c39e-1df7744fa633@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <9c45c769-2f5e-9327-c39e-1df7744fa633@intel.com>
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, Matthew Wilcox <mawilcox@microsoft.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Eryu Guan <eguan@redhat.com>, Christoph Hellwig <hch@lst.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 17, 2017 at 10:33:58AM -0700, Dave Hansen wrote:
> On 05/17/2017 10:16 AM, Ross Zwisler wrote:
> > @@ -3061,7 +3061,7 @@ static int pte_alloc_one_map(struct vm_fault *vmf)
> >  	 * through an atomic read in C, which is what pmd_trans_unstable()
> >  	 * provides.
> >  	 */
> > -	if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
> > +	if (pmd_devmap(*vmf->pmd) || pmd_trans_unstable(vmf->pmd))
> >  		return VM_FAULT_NOPAGE;
> 
> I'm worried we are very unlikely to get this right in the future.  It's
> totally not obvious what the ordering requirement is here.
> 
> Could we move pmd_devmap() and pmd_trans_unstable() into a helper that
> gets the ordering right and also spells out the ordering requirement?

Sure, I'll fix this for v2.

Thanks for the review.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

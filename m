Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 06C2B21A16EEE
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 10:34:03 -0700 (PDT)
Subject: Re: [PATCH 1/2] mm: avoid spurious 'bad pmd' warning messages
References: <20170517171639.14501-1-ross.zwisler@linux.intel.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <9c45c769-2f5e-9327-c39e-1df7744fa633@intel.com>
Date: Wed, 17 May 2017 10:33:58 -0700
MIME-Version: 1.0
In-Reply-To: <20170517171639.14501-1-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Eryu Guan <eguan@redhat.com>, Matthew Wilcox <mawilcox@microsoft.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, stable@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/17/2017 10:16 AM, Ross Zwisler wrote:
> @@ -3061,7 +3061,7 @@ static int pte_alloc_one_map(struct vm_fault *vmf)
>  	 * through an atomic read in C, which is what pmd_trans_unstable()
>  	 * provides.
>  	 */
> -	if (pmd_trans_unstable(vmf->pmd) || pmd_devmap(*vmf->pmd))
> +	if (pmd_devmap(*vmf->pmd) || pmd_trans_unstable(vmf->pmd))
>  		return VM_FAULT_NOPAGE;

I'm worried we are very unlikely to get this right in the future.  It's
totally not obvious what the ordering requirement is here.

Could we move pmd_devmap() and pmd_trans_unstable() into a helper that
gets the ordering right and also spells out the ordering requirement?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41D6C222EDCF5
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 00:11:27 -0800 (PST)
Date: Thu, 4 Jan 2018 09:16:29 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 01/18] mm, dax: introduce pfn_t_special()
Message-ID: <20180104081629.GB2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407696622.38751.4716967585354728059.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151407696622.38751.4716967585354728059.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, hch@lst.de, linux-xfs@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 23, 2017 at 04:56:06PM -0800, Dan Williams wrote:
> In support of removing the VM_MIXEDMAP indication from DAX VMAs,
> introduce pfn_t_special() for drivers to indicate that _PAGE_SPECIAL
> should be used for DAX ptes. This also helps identify drivers like
> dccssblk that only want to use DAX in a read-only fashion without
> get_user_pages() support.
> 
> Ideally we could delete axonram and dcssblk DAX support, but if we need
> to keep it better make it explicit that axonram and dcssblk only support
> a sub-set of DAX due to missing _PAGE_DEVMAP support.

I'd suggest to just delete it for now.  If the powerpc and S/390
people have an interest in it they should resurrect it properly and
fully.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

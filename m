Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AD2CA21E47D53
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 00:07:34 -0700 (PDT)
Date: Fri, 25 Aug 2017 09:10:08 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 1/3] iomap: return VM_FAULT_* codes from iomap_page_mkwrite
Message-ID: <20170825071008.GA9191@lst.de>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-2-hch@lst.de> <20170824192624.GA20489@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170824192624.GA20489@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 01:26:24PM -0600, Ross Zwisler wrote:
> On Thu, Aug 24, 2017 at 05:22:05PM +0200, Christoph Hellwig wrote:
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> This is obviously correct, but the lack of changelog makes it unclear why the
> change is being made.  Does a later patch in the series depend on
> iomap_page_mkwrite() returning VM_FAULT_* codes?  Is this just cleanup so you
> can hide the block_page_mkwrite_return() call inside of iomap_page_mkwrite()?
> 
> I think it's the former, so the logic in __xfs_filemap_fault() is simpler?

Yes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

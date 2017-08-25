Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6FD4621E47D48
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 23:48:17 -0700 (PDT)
Date: Fri, 25 Aug 2017 08:50:51 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 3/3] xfs: support for synchronous DAX faults
Message-ID: <20170825065051.GA8866@lst.de>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-4-hch@lst.de>
 <CAPcyv4i0kNowtfDQpjJPU+o1xnsAskB+-O8cFzdLivdeoEEJkw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i0kNowtfDQpjJPU+o1xnsAskB+-O8cFzdLivdeoEEJkw@mail.gmail.com>
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
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-xfs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 05:13:54PM -0700, Dan Williams wrote:
> 
> So this behaves differently than ext4 that returns EOPNOTSUP in the !DAX case.
> 
> Are we generally documenting MAP_SYNC to be ignored in the pagecache
> case? Or should we explicitly fail MAP_SYNC for the !DAX case on all
> filesystems?

It's just me being lazy for now until we've settled on the exact mmap
interface.  With your new ->mmap signature we can do proper flags
checking, and I would add it.  But with only Jans patches it seems
like we'd silently support MAP_SYNC for all other file systems
anyway.

> Another option is to finish block allocations at fault time in the
> pagecache+MAP_SYNC case, but still require fsync to writeback dirty
> pages, but that seems pointless.

Agreed.

> Whatever we do I think all implementations should agree.

Sure.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

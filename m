Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C3A232095AE55
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 14:39:52 -0700 (PDT)
Date: Thu, 24 Aug 2017 15:42:26 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/3] xfs: support for synchronous DAX faults
Message-ID: <20170824214226.GC20489@linux.intel.com>
References: <20170824152207.30729-1-hch@lst.de>
 <20170824152207.30729-4-hch@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170824152207.30729-4-hch@lst.de>
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
To: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 05:22:07PM +0200, Christoph Hellwig wrote:
> Return IOMAP_F_NEEDDSYNC from xfs_file_iomap_begin() for a synchronous
> write fault when inode is pinned, and has dirty fields other than the
> timestamps.  In xfs_filemap_huge_fault() we then detect this case and
		  __xfs_filemap_fault()

Otherwise this looks good to me:

Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

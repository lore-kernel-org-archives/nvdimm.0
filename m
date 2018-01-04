Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1615C21CB2E3A
 for <linux-nvdimm@lists.01.org>; Thu,  4 Jan 2018 00:28:34 -0800 (PST)
Date: Thu, 4 Jan 2018 09:33:36 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v4 18/18] xfs, dax: wire up dax_flush_dma support via a
 new xfs_sync_dma helper
Message-ID: <20180104083336.GN2548@lst.de>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
 <151407705701.38751.6157642918168721562.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180102230027.GV5858@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180102230027.GV5858@dastard>
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
To: Dave Chinner <david@fromorbit.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, "Darrick J. Wong" <darrick.wong@oracle.com>, hch@lst.de, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 03, 2018 at 10:00:27AM +1100, Dave Chinner wrote:
> AFAIC, these DMA references are just another external layout
> reference that needs to be broken.  IOWs, this "sync DMA" complexity
> needs to go inside xfs_break_layouts() as it is part of breaking the
> external reference to the file layout - it does not replace the
> layout breaking abstraction and so the implementation needs to
> reflect that.

Agreed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

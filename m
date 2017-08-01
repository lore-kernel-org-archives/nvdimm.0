Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC25921AEB0DB
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 03:54:01 -0700 (PDT)
Date: Tue, 1 Aug 2017 03:56:08 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 5/7] dax, iomap: Add support for synchronous faults
Message-ID: <20170801105608.GD6742@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-6-jack@suse.cz>
 <20170727224245.GF22000@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170727224245.GF22000@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andy Lutomirski <luto@kernel.org>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 04:42:45PM -0600, Ross Zwisler wrote:
> I wonder if we should name this flag something a little stronger and more
> specific to its usage with respect to DAX and sync faults?  Maybe
> "VM_FAULT_NEEDDSYNC" for consistency with the iomap flag?

Agreed.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4958A21AEB0DB
 for <linux-nvdimm@lists.01.org>; Tue,  1 Aug 2017 03:52:21 -0700 (PDT)
Date: Tue, 1 Aug 2017 03:54:27 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/7] dax: Simplify arguments of dax_insert_mapping()
Message-ID: <20170801105427.GC6742@infradead.org>
References: <20170727131245.28279-1-jack@suse.cz>
 <20170727131245.28279-4-jack@suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170727131245.28279-4-jack@suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 27, 2017 at 03:12:41PM +0200, Jan Kara wrote:
> dax_insert_mapping() has lots of arguments and a lot of them is actuall
> duplicated by passing vm_fault structure as well. Change the function to
> take the same arguments as dax_pmd_insert_mapping().

Some of this is probably for historic reasons, when I did the initial
pass at iomap based DAX dax_insert_mapping still had to be usable for
the non-DAX case.

Either way this looks like a great cleanup:

Reviewed-by: Christoph Hellwig <hch@lst.de>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

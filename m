Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA5A381F30
 for <linux-nvdimm@lists.01.org>; Wed, 25 Jan 2017 03:19:55 -0800 (PST)
Date: Wed, 25 Jan 2017 03:19:52 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5] DAX: enable iostat for read/write
Message-ID: <20170125111952.GA11978@infradead.org>
References: <20170112183848.23159-1-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170112183848.23159-1-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk, Joe Perches <joe@perches.com>, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 12, 2017 at 11:38:48AM -0700, Toshi Kani wrote:
> DAX IO path does not support iostat, but its metadata IO path does.
> Therefore, iostat shows metadata IO statistics only, which has been
> confusing to users.
> 
> Add iostat support to the DAX read/write path.
> 
> Note, iostat still does not support the DAX mmap path as it allows
> user applications to access directly.

NAK.  DAX I/O should not be accounted for block device statistics.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

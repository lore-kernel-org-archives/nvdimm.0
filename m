Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF96A20957465
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 08:10:40 -0700 (PDT)
Date: Thu, 5 Apr 2018 08:10:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
Message-ID: <20180405151038.GB11834@infradead.org>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
 <20180405080118.GA32396@infradead.org>
 <x49efjtwvgh.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49efjtwvgh.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 05, 2018 at 10:59:10AM -0400, Jeff Moyer wrote:
> So, I also hate this (note that this is already in place today for fs
> dax).  You have an operation to make things persistent, and another one
> to *really* make things persistent.  It makes no sense to me.  I have no
> idea how to communicate that to application developers.  When do you
> force things out to the smallest failure domain?
> 
> The arguments I've heard are that ADR failures may happen due to a
> variety of factors, and that an application (or file system) can make
> sure that critical (meta)data is available after a crash by flushing to
> the smallest failure domain.  Presumably, this would be a
> lower-frequency event (only for metadata changes, etc).

Which meansit should not abuse fsync but have a special interface
just for that IFF we trust ADR.  IFF we don't trust it anyway fsync
absolutely is the right interface, but then we shouldn't offer MAP_SYNC.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

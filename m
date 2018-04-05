Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB49C21E08164
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 00:23:18 -0700 (PDT)
Date: Thu, 5 Apr 2018 00:23:17 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
Message-ID: <20180405072317.GA2855@infradead.org>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 04, 2018 at 05:03:07PM -0700, Dan Williams wrote:
> "Currently, fsdax applications can assume that if they call fsync or
> msync on a dax mapped file that any pending writes that have been
> flushed out of the cpu cache will be also be flushed to the lowest
> possible persistence / failure domain available on the platform. In
> typical scenarios the platform ADR capability handles marshaling
> writes that have reached global visibility to persistence. In
> exceptional cases where ADR fails to complete its operation software
> can detect that scenario the the "last shutdown" health status check
> and otherwise mitigate the effects of an ADR failure by protecting
> metadata with the WPQ flush. In other words, enabling device-dax to
> optionally trigger WPQ Flush on msync() allows applications to have
> common implementation for persistence domain handling across fs-dax
> and device-dax."

This sounds totally bogus.  Either ADR is reliable and we can rely on
it all the time (like we assume for say capacitors on ssds with non-
volatile write caches), or we can't rely on it and the write through
store model is a blatant lie.  In other words - msync/fsync is what
we use for normal persistence, not for working around broken hardware.

In many ways this sounds like a plot to make normal programming models
not listening to the pmem.io hype look bad in benchmarks..
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

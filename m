Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0092D22526481
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 00:03:11 -0700 (PDT)
Date: Fri, 6 Apr 2018 00:03:10 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
Message-ID: <20180406070310.GA16984@infradead.org>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
 <20180405080118.GA32396@infradead.org>
 <CAPcyv4i3iVyQN+uCOihR9+qpk9AcVUB1YJLjDJ-DQv3afuJxYw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i3iVyQN+uCOihR9+qpk9AcVUB1YJLjDJ-DQv3afuJxYw@mail.gmail.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 05, 2018 at 03:17:17PM -0700, Dan Williams wrote:
> > That means IFF ADR can fail like this we can't treat it as stable
> > storage and we must not support MAP_SYNC or equivalent device dax
> > behavior, period.
> 
> Makes sense, we won't pursue *sync() support on device-dax it doesn't fit.

We still have other bits of this way of thinking in the tree as far as
I can tell, e.g. the nvdimm_flush calls in pmem_make_request and thus
should come up with a coherent strategy if we trust ADR, and if we don't
fully trust it how to mitigate it.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

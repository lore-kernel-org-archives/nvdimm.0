Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 44BA322526490
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 01:01:19 -0700 (PDT)
Date: Thu, 5 Apr 2018 01:01:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
Message-ID: <20180405080118.GA32396@infradead.org>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
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

On Thu, Apr 05, 2018 at 12:56:02AM -0700, Dan Williams wrote:
> Yes, I think it is unfortunate that the failure mode is exposed to
> software at all. The problem is that ADR is a platform feature that
> depends on power supply requirements external to the NVDIMM device. An
> SSD is different. It is a self contained system that can arrange for
> the whole device to fail if the internal energy source fails and
> otherwise hide this detail from software. My personal take, a system
> designer that can specify and qualify an entire stack of components
> can certainly opt-out of advertising the flush capability to the OS
> because, like the SSD vendor, they control the integrated solution. A
> platform vendor that allows off the shelf power supplies would in my
> opinion be remiss not to give the OS the option to mitigate the
> quality of some random power supply. It then follow that if the OS has
> the ability to mitigate ADR failure it should be through a common
> interface between fsdax and devdax.

That means IFF ADR can fail like this we can't treat it as stable
storage and we must not support MAP_SYNC or equivalent device dax
behavior, period.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BCCF422526483
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 07:59:13 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
 <20180405080118.GA32396@infradead.org>
Date: Thu, 05 Apr 2018 10:59:10 -0400
In-Reply-To: <20180405080118.GA32396@infradead.org> (Christoph Hellwig's
 message of "Thu, 5 Apr 2018 01:01:18 -0700")
Message-ID: <x49efjtwvgh.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
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
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Christoph Hellwig <hch@infradead.org> writes:

> On Thu, Apr 05, 2018 at 12:56:02AM -0700, Dan Williams wrote:
>> Yes, I think it is unfortunate that the failure mode is exposed to
>> software at all. The problem is that ADR is a platform feature that
>> depends on power supply requirements external to the NVDIMM device. An
>> SSD is different. It is a self contained system that can arrange for
>> the whole device to fail if the internal energy source fails and
>> otherwise hide this detail from software. My personal take, a system
>> designer that can specify and qualify an entire stack of components
>> can certainly opt-out of advertising the flush capability to the OS
>> because, like the SSD vendor, they control the integrated solution. A
>> platform vendor that allows off the shelf power supplies would in my
>> opinion be remiss not to give the OS the option to mitigate the
>> quality of some random power supply. It then follow that if the OS has
>> the ability to mitigate ADR failure it should be through a common
>> interface between fsdax and devdax.
>
> That means IFF ADR can fail like this we can't treat it as stable
> storage and we must not support MAP_SYNC or equivalent device dax
> behavior, period.

So, I also hate this (note that this is already in place today for fs
dax).  You have an operation to make things persistent, and another one
to *really* make things persistent.  It makes no sense to me.  I have no
idea how to communicate that to application developers.  When do you
force things out to the smallest failure domain?

The arguments I've heard are that ADR failures may happen due to a
variety of factors, and that an application (or file system) can make
sure that critical (meta)data is available after a crash by flushing to
the smallest failure domain.  Presumably, this would be a
lower-frequency event (only for metadata changes, etc).

I don't buy it.

What remains to be seen is whether ADR actually is reliable.  And, if it
turns out that it isn't, will there be industry pressure to fix the
hardware, will applications adapt to always call fsync, or will we do as
Christoph suggests, and get rid of fallacy of flush from userspace?

I don't have the answers.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

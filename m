Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22f.google.com (mail-ot0-x22f.google.com
 [IPv6:2607:f8b0:4003:c0f::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C8CF22526482
 for <linux-nvdimm@lists.01.org>; Thu,  5 Apr 2018 00:56:04 -0700 (PDT)
Received: by mail-ot0-x22f.google.com with SMTP id m22-v6so26215301otf.10
 for <linux-nvdimm@lists.01.org>; Thu, 05 Apr 2018 00:56:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180405072317.GA2855@infradead.org>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Apr 2018 00:56:02 -0700
Message-ID: <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
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

On Thu, Apr 5, 2018 at 12:23 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Apr 04, 2018 at 05:03:07PM -0700, Dan Williams wrote:
>> "Currently, fsdax applications can assume that if they call fsync or
>> msync on a dax mapped file that any pending writes that have been
>> flushed out of the cpu cache will be also be flushed to the lowest
>> possible persistence / failure domain available on the platform. In
>> typical scenarios the platform ADR capability handles marshaling
>> writes that have reached global visibility to persistence. In
>> exceptional cases where ADR fails to complete its operation software
>> can detect that scenario the the "last shutdown" health status check
>> and otherwise mitigate the effects of an ADR failure by protecting
>> metadata with the WPQ flush. In other words, enabling device-dax to
>> optionally trigger WPQ Flush on msync() allows applications to have
>> common implementation for persistence domain handling across fs-dax
>> and device-dax."
>
> This sounds totally bogus.  Either ADR is reliable and we can rely on
> it all the time (like we assume for say capacitors on ssds with non-
> volatile write caches), or we can't rely on it and the write through
> store model is a blatant lie.  In other words - msync/fsync is what
> we use for normal persistence, not for working around broken hardware.
>

Yes, I think it is unfortunate that the failure mode is exposed to
software at all. The problem is that ADR is a platform feature that
depends on power supply requirements external to the NVDIMM device. An
SSD is different. It is a self contained system that can arrange for
the whole device to fail if the internal energy source fails and
otherwise hide this detail from software. My personal take, a system
designer that can specify and qualify an entire stack of components
can certainly opt-out of advertising the flush capability to the OS
because, like the SSD vendor, they control the integrated solution. A
platform vendor that allows off the shelf power supplies would in my
opinion be remiss not to give the OS the option to mitigate the
quality of some random power supply. It then follow that if the OS has
the ability to mitigate ADR failure it should be through a common
interface between fsdax and devdax.

> In many ways this sounds like a plot to make normal programming models
> not listening to the pmem.io hype look bad in benchmarks..

No, just no.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

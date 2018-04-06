Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3340B22620E68
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 15:41:40 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id p33-v6so2835283otp.11
 for <linux-nvdimm@lists.01.org>; Fri, 06 Apr 2018 15:41:40 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180406070310.GA16984@infradead.org>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
 <20180405080118.GA32396@infradead.org>
 <CAPcyv4i3iVyQN+uCOihR9+qpk9AcVUB1YJLjDJ-DQv3afuJxYw@mail.gmail.com>
 <20180406070310.GA16984@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Apr 2018 15:41:39 -0700
Message-ID: <CAPcyv4g7kzRQqR63BFQXww5axjaZzdBb+pAGzC6TvfpxoTq+Sg@mail.gmail.com>
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

On Fri, Apr 6, 2018 at 12:03 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, Apr 05, 2018 at 03:17:17PM -0700, Dan Williams wrote:
>> > That means IFF ADR can fail like this we can't treat it as stable
>> > storage and we must not support MAP_SYNC or equivalent device dax
>> > behavior, period.
>>
>> Makes sense, we won't pursue *sync() support on device-dax it doesn't fit.
>
> We still have other bits of this way of thinking in the tree as far as
> I can tell, e.g. the nvdimm_flush calls in pmem_make_request and thus
> should come up with a coherent strategy if we trust ADR, and if we don't
> fully trust it how to mitigate it.

Yes, but the trust interface definition is what is missing, especially
when we consider memmap=ss!nn and qemu-kvm. For example do we turn off
DAX and/or MAP_SYNC on all platforms that don't provide a positive "I
have ADR" indication (ACPI 6.2 Section 5.2.25.9 NFIT Platform
Capabilities Structure)? Require opt-in when the user has trust in the
hardware config that the kernel can't verify?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 693DA22742AA3
 for <linux-nvdimm@lists.01.org>; Wed, 11 Apr 2018 09:27:24 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id v6-v6so2656838otj.12
 for <linux-nvdimm@lists.01.org>; Wed, 11 Apr 2018 09:27:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49d0z5pw13.fsf@segfault.boston.devel.redhat.com>
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
 <20180405080118.GA32396@infradead.org>
 <CAPcyv4i3iVyQN+uCOihR9+qpk9AcVUB1YJLjDJ-DQv3afuJxYw@mail.gmail.com>
 <20180406070310.GA16984@infradead.org>
 <CAPcyv4g7kzRQqR63BFQXww5axjaZzdBb+pAGzC6TvfpxoTq+Sg@mail.gmail.com>
 <20180409093211.GA30549@infradead.org>
 <x49d0z5pw13.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Apr 2018 09:27:22 -0700
Message-ID: <CAPcyv4guech76UWc7xo+SAzKOv8dT83HTUoUPVUCx5Kjuxy5Vg@mail.gmail.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 11, 2018 at 9:06 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Christoph Hellwig <hch@infradead.org> writes:
>
>> On Fri, Apr 06, 2018 at 03:41:39PM -0700, Dan Williams wrote:
>>> Yes, but the trust interface definition is what is missing, especially
>>> when we consider memmap=ss!nn and qemu-kvm. For example do we turn off
>>> DAX and/or MAP_SYNC on all platforms that don't provide a positive "I
>>> have ADR" indication (ACPI 6.2 Section 5.2.25.9 NFIT Platform
>>> Capabilities Structure)?
>>
>> Sounds like a default.
>
> Which do you turn off?  DAX or MAP_SYNC (or both)?

Only MAP_SYNC I would say, because then userspace can't opt out of
fsync/msync and it gives us a chance to "Do The Right Thing (TM)" with
respect to WPQ flush.

> Systems that support ACPI versions earlier than 6.2 could provide
> flush hint addresses.  In that case, we could assume no ADR, and turn
> off MAP_SYNC, but still allow DAX.  Note that I'm not aware of any
> hardware that actually falls into this category.
>
> Platforms prior to 6.2 that don't support flush hints are currently
> assumed to implement ADR.  This proposal would change that default.
>
>>> Require opt-in when the user has trust in the hardware config that
>>> the kernel can't verify?
>>
>> And that sounds like a good config nob ontop of that default.
>
> Well, we could also make a white-list for known good platforms.  I
> assume HPE's systems would be on that list.  Otherwise we'd have to cook
> up udev rules, I guess?

udev rules sound good. We can distribute them in the ndctl package. I
think I would handle this by making
/sys/bus/nd/devices/regionX/persistence_domain writable to opt-in to a
user specified persistence_domain. If the persistence_domain attribute
file is not writable then you know you're on a kernel that blindly
trusts all pmem descriptions as MAP_SYNC capable.

> Dan, is this something you're working on now?

No, it's behind finalizing dax-dma-vs-truncate and memcpy_mcsafe for
user copies in my queue...
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

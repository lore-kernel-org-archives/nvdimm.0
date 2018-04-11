Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22873225FA064
 for <linux-nvdimm@lists.01.org>; Wed, 11 Apr 2018 09:06:50 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] dax: adding fsync/msync support for device DAX
References: <152287929452.28903.15383389230749046740.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4hZfNOG15guKE0Lq=QoFr8DZerEH=1=OjnrEY2trPXNcw@mail.gmail.com>
 <20180405072317.GA2855@infradead.org>
 <CAPcyv4jn2DHu9HGH=XPr9VHP0gyENFKEiXr=w5hO2UR_tRWc0A@mail.gmail.com>
 <20180405080118.GA32396@infradead.org>
 <CAPcyv4i3iVyQN+uCOihR9+qpk9AcVUB1YJLjDJ-DQv3afuJxYw@mail.gmail.com>
 <20180406070310.GA16984@infradead.org>
 <CAPcyv4g7kzRQqR63BFQXww5axjaZzdBb+pAGzC6TvfpxoTq+Sg@mail.gmail.com>
 <20180409093211.GA30549@infradead.org>
Date: Wed, 11 Apr 2018 12:06:48 -0400
In-Reply-To: <20180409093211.GA30549@infradead.org> (Christoph Hellwig's
 message of "Mon, 9 Apr 2018 02:32:11 -0700")
Message-ID: <x49d0z5pw13.fsf@segfault.boston.devel.redhat.com>
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

> On Fri, Apr 06, 2018 at 03:41:39PM -0700, Dan Williams wrote:
>> Yes, but the trust interface definition is what is missing, especially
>> when we consider memmap=ss!nn and qemu-kvm. For example do we turn off
>> DAX and/or MAP_SYNC on all platforms that don't provide a positive "I
>> have ADR" indication (ACPI 6.2 Section 5.2.25.9 NFIT Platform
>> Capabilities Structure)?
>
> Sounds like a default.

Which do you turn off?  DAX or MAP_SYNC (or both)?

Systems that support ACPI versions earlier than 6.2 could provide
flush hint addresses.  In that case, we could assume no ADR, and turn
off MAP_SYNC, but still allow DAX.  Note that I'm not aware of any
hardware that actually falls into this category.

Platforms prior to 6.2 that don't support flush hints are currently
assumed to implement ADR.  This proposal would change that default.

>> Require opt-in when the user has trust in the hardware config that
>> the kernel can't verify?
>
> And that sounds like a good config nob ontop of that default.

Well, we could also make a white-list for known good platforms.  I
assume HPE's systems would be on that list.  Otherwise we'd have to cook
up udev rules, I guess?

Dan, is this something you're working on now?

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

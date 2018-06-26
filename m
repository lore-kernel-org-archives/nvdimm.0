Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 494F1202E544F
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 12:19:03 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id b5-v6so7941865oiy.11
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 12:19:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180626191346.GA7233@redhat.com>
References: <20180626175932.8899-1-ross.zwisler@linux.intel.com>
 <20180626175932.8899-2-ross.zwisler@linux.intel.com>
 <CAPcyv4iWgPnHmBKhUvhManC6UL9CkLqN_d8vBo6KmcPJdPzuUw@mail.gmail.com>
 <20180626185830.GA7171@redhat.com>
 <CAPcyv4h6HO6fs6k7QMD77jkz2djCeWCtWomCdNb0-1Q4VKanqw@mail.gmail.com>
 <20180626191346.GA7233@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Jun 2018 12:19:02 -0700
Message-ID: <CAPcyv4iC9AvzC3z_g3DQL_2mzR5Z3C898QjPB0JZn6-HRbsuoQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] pmem: only set QUEUE_FLAG_DAX for fsdax mode
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26, 2018 at 12:13 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Tue, Jun 26 2018 at  3:07pm -0400,
> Dan Williams <dan.j.williams@intel.com> wrote:
>
>> On Tue, Jun 26, 2018 at 11:58 AM, Mike Snitzer <snitzer@redhat.com> wrote:
>> > On Tue, Jun 26 2018 at  2:52pm -0400,
>> > Dan Williams <dan.j.williams@intel.com> wrote:
>> >
>> >> On Tue, Jun 26, 2018 at 10:59 AM, Ross Zwisler
>> >> <ross.zwisler@linux.intel.com> wrote:
>> >> > QUEUE_FLAG_DAX is an indication that a given block device supports
>> >> > filesystem DAX and should not be set for PMEM namespaces which are in "raw"
>> >> > or "sector" modes.  These namespaces lack struct page and are prevented
>> >> > from participating in filesystem DAX.
>> >> >
>> >> > Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> >> > Suggested-by: Mike Snitzer <snitzer@redhat.com>
>> >> > Cc: stable@vger.kernel.org
>> >>
>> >> Why is this cc: stable? What is the user visible impact of this change
>> >> especially given the requirement to validate QUEUE_FLAG_DAX with
>> >> bdev_dax_supported()? Patch looks good, but it's just a cosmetic fixup
>> >> afaics.
>> >
>> > This isn't cosmetic when you consider that stacking up a DM device is
>> > looking at this flag to determine whether a table does or does _not_
>> > support DAX.
>> >
>> > So this patch, in conjunction with the other changes in the series, is
>> > certainly something I'd consider appropriate for stable.
>>
>> I think this classifies as something that never worked correctly and
>> is not a regression. It does not identify which commit it is repairing
>> or the user visible failure mode.
>
> So you're taking issue with making stacked dax configs work in older
> kernels?  That's fine.  We can drop the stable cc if you like.
>
> But I mean we intended for this to work.. so the Fixes commit references
> can easily be added, e.g.: 545ed20e6df68a4d2584a29a2a28ee8b2f7e9547
> ("dm: add infrastructure for DAX support")

...but to be clear stacked DAX configs are not broken, right? They
just happen not to work in this corner case of pmem devices without
pages. Given we dropped DAX support for page less devices what
configurations are repaired by this change? Am I missing something? Is
it a data corruption scenario if this DM gets the wrong idea about DAX
support. I could be convinced to recommend this for -stable, but the
changelog as written does not make a strong case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

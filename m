Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CBF221A04E1D
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 08:39:34 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id l18so34840679oig.2
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 08:39:34 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1494516683.30303.88.camel@hpe.com>
References: <149446050265.19998.6594654322891878230.stgit@djiang5-desk3.ch.intel.com>
 <149446059426.19998.8536490603388756669.stgit@djiang5-desk3.ch.intel.com>
 <1494516683.30303.88.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 May 2017 08:39:32 -0700
Message-ID: <CAPcyv4iTF0S1JgqTc04CJRkO7243AmNyr_kiPhPZq9a5+LLT-g@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] ndctl: add list --media-errors support
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 11, 2017 at 8:31 AM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Wed, 2017-05-10 at 16:57 -0700, Dave Jiang wrote:
>> ACPI NFIT enabled platforms provide media errors as absolute phyiscal
>> address offsets. Add an option to ndctl to display those media errors
>> tranlsated to region and namespace device level offsets in an "ndctl
>> list" listing. BTT badblocks show is not supported in this iteration
>> and will come later.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>
>> v2: added fix to badblocks display from Toshi's testing result.
>> v3: fixed naming issues from Dan's comments.
>>     fixed badblocks boundary offset calculations from Toshi's
>> testing.
>> v4: Add indicator to show badblocks exist or not, per Toshi's
>> comments.
>
> This version works pretty good, except that it does not show
> "has_badblocks" for sector mode.
>
> # ndctl list -M -m sector
> {
>   "dev":"namespace0.0",
>   "mode":"sector",
>   "size":17162027008,
>   "uuid":"7742dff3-3edd-4a28-894d-9ac1aede6b2c",
>   "sector_size":4096,
>   "blockdev":"pmem0s"
> }

Since we're going to spin the patch to fix this up... Toshi, what do
you think about changing "has_badblocks" to "badblock_count". My
concern is that for the btt case it will also count badblocks that are
on the free list or in metadata, but it at least gives you a better
indication of the damage level of the underlying namespace.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 360B021A04839
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 06:54:15 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id f193so60997127oib.2
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 06:54:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170331133123.GC3848@linux-x5ow.site>
References: <cover.1488921944.git.linda.knippers@hpe.com>
 <20170331090135.GB3848@linux-x5ow.site>
 <58DE5755.1090900@hpe.com> <20170331133123.GC3848@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 31 Mar 2017 06:54:13 -0700
Message-ID: <CAPcyv4jAQoJwTc6a9KvYQc4TnD4ZDRdaf82DXPqtb=fDgMNBDQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] apci, nfit: DSM improvements
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 31, 2017 at 6:31 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> On Fri, Mar 31, 2017 at 09:19:17AM -0400, Linda Knippers wrote:
>> On 03/31/2017 05:01 AM, Johannes Thumshirn wrote:
>> > On Tue, Mar 07, 2017 at 04:35:11PM -0500, Linda Knippers wrote:
>> >> The first two patches in this series are motivated by feedback
>> >> from distribution developers, test engineers, and management tool
>> >> developers.  We need the ability to test and support Linux and
>> >> management tools on systems that support more than one DSM family
>> >> for NVDIMM-N.
>> >>
>> >> We also need the ability to test and support new functions without
>> >> requiring users to update their kernel.  These changes will also
>> >> facilate development as we move toward DSM standardization.
>> >> The ability to restrict DSM functions to the currently documented
>> >> set is still in place.
>> >>
>> >> The third patch cleans up a cosmetic/modinfo parsing issue with one
>> >> of the existing module parameters.
>> >
>> > Hi Linda and Dan,
>> >
>> > Can you tell me the status of this series? I haven't seen it in Dan's
>> > tree and can't remember a reason why it's not merged.
>>
>> I assume/hope it's just waiting for the next merge window.
>> At this point I think Dan is just pulling in critical fixes.
>> If there's some other reason, I'd like to hear about it too.
>
> OK.
>
> Dan is it possible to do a for-next branch or a for-4.12 branch?
> That'll make my life a _much_ easier.

Yes, it's queued. I had been holding back updating my for-next branch
while debugging some test regressions in other for-4.12 patches.
However, I'll just kick those other patches out of the branch and post
these. Thanks for the nudge.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

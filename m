Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 38A1921197376
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 12:51:52 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] acpi/nfit: Fix command-supported detection
References: <154725096972.1367907.12968253382302127133.stgit@dwillia2-desk3.amr.corp.intel.com>
 <x49sgxvclmu.fsf@redhat.com>
 <CAPcyv4hLGB-=UcHykgAO5X3Oakp_erw_62_gpUD2cqXLXKpJVQ@mail.gmail.com>
 <CAPcyv4hANufJYNnu+tc5yaun3xG8Ht6MirobG4Fj_CaafXE+7g@mail.gmail.com>
Date: Mon, 14 Jan 2019 15:51:49 -0500
In-Reply-To: <CAPcyv4hANufJYNnu+tc5yaun3xG8Ht6MirobG4Fj_CaafXE+7g@mail.gmail.com>
 (Dan Williams's message of "Mon, 14 Jan 2019 08:47:49 -0800")
Message-ID: <x498sznaroa.fsf@redhat.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sujith Pandel <sujith_pandel@dell.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Mon, Jan 14, 2019 at 8:43 AM Dan Williams <dan.j.williams@intel.com> wrote:
>> On Mon, Jan 14, 2019 at 7:19 AM Jeff Moyer <jmoyer@redhat.com> wrote:
> [..]
>> > > +
>> > > +     if (cmd == ND_CMD_CALL) {
>> > > +             int i;
>> > > +
>> > > +             if (call_pkg && nfit_mem->family != call_pkg->nd_family)
>> > > +                     return -ENOTTY;
>> > > +
>> > > +             for (i = 0; i < ARRAY_SIZE(call_pkg->nd_reserved2); i++)
>> > > +                     if (call_pkg->nd_reserved2[i])
>> > > +                             return -EINVAL;
>> > > +             return call_pkg->nd_command;
>> > > +     }
>> > > +
>> > > +     /* Linux ND commands == NVDIMM_FAMILY_INTEL function numbers */
>> > > +     if (nfit_mem->family == NVDIMM_FAMILY_INTEL)
>> > > +             return cmd;
>> > > +     return 0;
>> >
>> > Function zero?  Is that really the right thing to return here?
>>
>> Yes, function zero is never set in n
>
> ...whoops fumble fingered "send"
>
> Function zero should never be set in nfit_mem->dsm_mask, although the
> NVDIMM_FAMILY_MSFT mask violates this assumption. I'll fix that up.

OK, I think I see how it all fits together now, thanks.  It would be
nice if you documented this magical 0 return somehow.

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

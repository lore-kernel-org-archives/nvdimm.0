Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22a.google.com (mail-oi0-x22a.google.com
 [IPv6:2607:f8b0:4003:c06::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24CBB21A10979
 for <linux-nvdimm@lists.01.org>; Mon, 27 Nov 2017 10:40:48 -0800 (PST)
Received: by mail-oi0-x22a.google.com with SMTP id r190so20107011oie.6
 for <linux-nvdimm@lists.01.org>; Mon, 27 Nov 2017 10:45:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <x49bmjnlhck.fsf@segfault.boston.devel.redhat.com>
References: <1510238453-7713-1-git-send-email-lukasz.plewa@intel.com>
 <CAOSf1CFMsPwFcO6Mp4fV+faEBdG5wwi3d1nGK+n-MDGF4v0oLw@mail.gmail.com>
 <x498tfe8820.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4jJ0J4EkD95OXRWOogyV0tbY_WaO9WyQULL3bs+rShQBA@mail.gmail.com>
 <x49375m5blz.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4ieVYyrLgL4khMkqW-Rf36Ptzmnj0nAvoog0+zd_G3shg@mail.gmail.com>
 <91626014A8500F418F35F9EB590D2531AA96A9A8@IRSMSX106.ger.corp.intel.com>
 <CAPcyv4jmTfMw-UZxa6Fhoy7bZXqbTZc84CLby440pq72NtSGCA@mail.gmail.com>
 <91626014A8500F418F35F9EB590D2531AA96F5C6@IRSMSX106.ger.corp.intel.com>
 <CAPcyv4gv4UiqDTEqc1NKcG6vbcyKDSrmAqSbcRdq2u+smTzQzg@mail.gmail.com>
 <x49bmjnlhck.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 27 Nov 2017 10:45:09 -0800
Message-ID: <CAPcyv4gVR1O4XMOvmOaKhuTkDbP7HeGTj_zbjvuR48aQ+Jm1ow@mail.gmail.com>
Subject: Re: [PATCH] daxctl: remove libpmem dependency
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 27, 2017 at 10:14 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Dan Williams <dan.j.williams@intel.com> writes:
>
>> On Mon, Nov 27, 2017 at 9:33 AM, Czurylo, Krzysztof
>> <krzysztof.czurylo@intel.com> wrote:
>
>>> If we choose this option, do we need to implement "daxctl list" command?
>>> Since "list" is also supported by ndctl (though the output is slightly
>>> different), I'd prefer to only implement "daxctl io" in nvml.
>>
>> I'm fine with just implementing the "io" the command as a singular
>> command when this moves over, maybe just call it 'daxio'?
>>
>>> Anything else this tool should be able to do besides the "io"?
>>> Are there any plans for other features/commands?
>>
>> Yes, daxctl will continue to be enhanced for the non-nvdimm/pmem use
>> cases for device-dax.
>
> I think Krzysztof was asking whether dax_io was going to grow any new
> features.

Nothing more on the horizon that I can see.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

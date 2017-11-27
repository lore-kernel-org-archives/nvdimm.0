Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 321B321A10979
 for <linux-nvdimm@lists.01.org>; Mon, 27 Nov 2017 10:09:43 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] daxctl: remove libpmem dependency
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
Date: Mon, 27 Nov 2017 13:14:03 -0500
In-Reply-To: <CAPcyv4gv4UiqDTEqc1NKcG6vbcyKDSrmAqSbcRdq2u+smTzQzg@mail.gmail.com>
 (Dan Williams's message of "Mon, 27 Nov 2017 09:36:36 -0800")
Message-ID: <x49bmjnlhck.fsf@segfault.boston.devel.redhat.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Mon, Nov 27, 2017 at 9:33 AM, Czurylo, Krzysztof
> <krzysztof.czurylo@intel.com> wrote:

>> If we choose this option, do we need to implement "daxctl list" command?
>> Since "list" is also supported by ndctl (though the output is slightly
>> different), I'd prefer to only implement "daxctl io" in nvml.
>
> I'm fine with just implementing the "io" the command as a singular
> command when this moves over, maybe just call it 'daxio'?
>
>> Anything else this tool should be able to do besides the "io"?
>> Are there any plans for other features/commands?
>
> Yes, daxctl will continue to be enhanced for the non-nvdimm/pmem use
> cases for device-dax.

I think Krzysztof was asking whether dax_io was going to grow any new
features.

-Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

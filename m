Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com
 [IPv6:2607:f8b0:4864:20::32f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DA5522131D576
 for <linux-nvdimm@lists.01.org>; Wed,  7 Aug 2019 15:30:17 -0700 (PDT)
Received: by mail-ot1-x32f.google.com with SMTP id b7so60519298otl.11
 for <linux-nvdimm@lists.01.org>; Wed, 07 Aug 2019 15:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <x49k1bw7dqn.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4js-dZWFyRM7=JgC31uJUyxVzuwrderFrWf5p=z82E+WA@mail.gmail.com>
 <x49ef1whcjq.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49ef1whcjq.fsf@segfault.boston.devel.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 7 Aug 2019 15:27:35 -0700
Message-ID: <CAPcyv4hUsbFP3=7RFLuHWWnZ+jkUfNFq9YRPKVGk22O7NuP8pA@mail.gmail.com>
Subject: Re: [patch] nfit: report frozen security state
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Aug 7, 2019 at 2:48 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>
> Dan Williams <dan.j.williams@intel.com> writes:
>
> > On Thu, Aug 1, 2019 at 2:55 PM Jeff Moyer <jmoyer@redhat.com> wrote:
> >>
> >> If a dimm is frozen, it is currently reported as being "locked".  While
> >> that's not technically wrong, it is misleading as the dimm can't be
> >> unlocked.  Fix the confusion.
> >
> > This looks ok, but now I wonder about the case where the DIMM is
> > unlocked, but frozen?
>
> Hah, forgot that was even a possibility.  :)
>
> > I think it makes more sense to show "frozen" when the DIMM is
> > frozen-locked, and show "unlocked" when frozen-unlocked. I.e. if the
> > DIMM is frozen the user should assume it's disabled for general
> > purpose operation, and if it's unlocked the fact that it will fail
> > some security operations is a constrained error case. Thoughts?
>
> I think that adds confusion.

It does...

>  I think we should print out both whether
> or not it's locked and whether or not it's frozen.  Maybe:
>
> unlocked, not frozen:  "unlocked"
> locked, not frozen:    "locked"
> unlocked, frozen:      "unlocked (frozen)"
> locked, frozen:        "locked (frozen)"
>
> Something like that?  I think nvdimm_security_state should be a bitmask,
> not an enum.  That may be a part of the problem.

It should...


...but ABIs are forever, and ndctl has shipped:

        if (strcmp(buf, "disabled") == 0)
                return NDCTL_SECURITY_DISABLED;
        else if (strcmp(buf, "unlocked") == 0)
                return NDCTL_SECURITY_UNLOCKED;
        else if (strcmp(buf, "locked") == 0)
                return NDCTL_SECURITY_LOCKED;
        else if (strcmp(buf, "frozen") == 0)
                return NDCTL_SECURITY_FROZEN;
        else if (strcmp(buf, "overwrite") == 0)
                return NDCTL_SECURITY_OVERWRITE;
        return NDCTL_SECURITY_INVALID;


I think we could break out the frozen state to its own new attribute
and leave security state to only show "locked" / "unlocked". Then go
teach new ndctl to go somewhere else to report frozen.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

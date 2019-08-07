Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A36AB21314744
 for <linux-nvdimm@lists.01.org>; Wed,  7 Aug 2019 14:51:13 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [patch] nfit: report frozen security state
References: <x49k1bw7dqn.fsf@segfault.boston.devel.redhat.com>
 <CAPcyv4js-dZWFyRM7=JgC31uJUyxVzuwrderFrWf5p=z82E+WA@mail.gmail.com>
Date: Wed, 07 Aug 2019 17:48:41 -0400
In-Reply-To: <CAPcyv4js-dZWFyRM7=JgC31uJUyxVzuwrderFrWf5p=z82E+WA@mail.gmail.com>
 (Dan Williams's message of "Wed, 7 Aug 2019 14:36:50 -0700")
Message-ID: <x49ef1whcjq.fsf@segfault.boston.devel.redhat.com>
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams <dan.j.williams@intel.com> writes:

> On Thu, Aug 1, 2019 at 2:55 PM Jeff Moyer <jmoyer@redhat.com> wrote:
>>
>> If a dimm is frozen, it is currently reported as being "locked".  While
>> that's not technically wrong, it is misleading as the dimm can't be
>> unlocked.  Fix the confusion.
>
> This looks ok, but now I wonder about the case where the DIMM is
> unlocked, but frozen?

Hah, forgot that was even a possibility.  :)

> I think it makes more sense to show "frozen" when the DIMM is
> frozen-locked, and show "unlocked" when frozen-unlocked. I.e. if the
> DIMM is frozen the user should assume it's disabled for general
> purpose operation, and if it's unlocked the fact that it will fail
> some security operations is a constrained error case. Thoughts?

I think that adds confusion.  I think we should print out both whether
or not it's locked and whether or not it's frozen.  Maybe:

unlocked, not frozen:  "unlocked"
locked, not frozen:    "locked"
unlocked, frozen:      "unlocked (frozen)"
locked, frozen:        "locked (frozen)"

Something like that?  I think nvdimm_security_state should be a bitmask,
not an enum.  That may be a part of the problem.

-Jeff

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

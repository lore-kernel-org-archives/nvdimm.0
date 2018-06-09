Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 20F32211BB392
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jun 2018 08:17:29 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id 188-v6so998720oid.12
 for <linux-nvdimm@lists.01.org>; Sat, 09 Jun 2018 08:17:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+55aFyTXHxaRQhsCwgicFw6=xk80Bjw92tgfmmRP4HQ-AhSvw@mail.gmail.com>
References: <1528502307.25740.14.camel@intel.com>
 <CA+55aFy_fiF2bwW=0gL4g8uL5099hWarL4+Q9djmDEuwRR2KKw@mail.gmail.com>
 <CA+55aFyTXHxaRQhsCwgicFw6=xk80Bjw92tgfmmRP4HQ-AhSvw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 9 Jun 2018 08:17:27 -0700
Message-ID: <CAPcyv4hPTyfSO5pncQ84cPrTe4sUJ+jA6cMHXm-6ocvLGKr65A@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm for 4.18
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 8, 2018 at 5:26 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, Jun 8, 2018 at 5:19 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> If I get stuff that looks at all complex at the end of the merge
>> window, I will just cackle unpleasantly while I press the big 'D' key
>> on my keyboard.
>
> Side note: looking at what I just pulled, there was close to a D key here too.
>
> Dammit, the top commit in your tree is a merge. And the merge message
> for that merge is this:
>
>     Merge branch 'for-4.18/mcsafe' into libnvdimm-for-next
>
> That's it. One line. That doesn't say anything at all.
>
> That kind of uninformative commit message wouldn't be remotely
> acceptable for a regular simple one-liner patch.
>
> WHY THE HELL DO PEOPLE CONTINUE TO THINK THAT IT'S OK FOR MERGES?
>
> Dammit. Merges are *more* complex than random usual patches. They need
> proper commit messages. Yet you have two merges there with absolutely
> *no* information in the commit message.
>
> If you can't be bothered to write an informative commit message for a
> merge, you damn well shouldn't do the merge.
>
> It really is that simple.

Well, crap. I've been doing it the wrong way for a while. Do you have
a preference for more pull requests or just splitting what is now a
top level tag message into a summary changelog per branch when I merge
the ready branches for the merge window? I had been assuming that the
arrangement you have with Ingo / Thomas to pull individual topics was
a privilege for the tip tree and not necessarily something everyone
that sends you pulls should be doing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

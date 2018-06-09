Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x242.google.com (mail-it0-x242.google.com
 [IPv6:2607:f8b0:4001:c0b::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90E32211CAF43
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jun 2018 09:26:23 -0700 (PDT)
Received: by mail-it0-x242.google.com with SMTP id l6-v6so6188808iti.2
 for <linux-nvdimm@lists.01.org>; Sat, 09 Jun 2018 09:26:23 -0700 (PDT)
MIME-Version: 1.0
References: <1528502307.25740.14.camel@intel.com>
 <CA+55aFy_fiF2bwW=0gL4g8uL5099hWarL4+Q9djmDEuwRR2KKw@mail.gmail.com>
 <CA+55aFyTXHxaRQhsCwgicFw6=xk80Bjw92tgfmmRP4HQ-AhSvw@mail.gmail.com>
 <CAPcyv4hPTyfSO5pncQ84cPrTe4sUJ+jA6cMHXm-6ocvLGKr65A@mail.gmail.com>
In-Reply-To: <CAPcyv4hPTyfSO5pncQ84cPrTe4sUJ+jA6cMHXm-6ocvLGKr65A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 9 Jun 2018 09:26:11 -0700
Message-ID: <CA+55aFzW_2iMYDRsz2-z6VvOcFwyuB5_72BAEARzpdG60h0=Zw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 9, 2018 at 8:17 AM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Well, crap. I've been doing it the wrong way for a while.

.. you're not the only one ;*(

I only really catch it when it's very obvious, like it was now when
the last merge was just before so it stood out like a sore thumb when
I looked at the resulting "git log".

.. or then I catch it in the (happily rare) case when a merge causes
issues, and then I curse.

> Do you have a preference for more pull requests or just splitting what
> is now a top level tag message into a summary changelog per branch
> when I merge the ready branches for the merge window? I had been
> assuming that the arrangement you have with Ingo / Thomas to pull
> individual topics was a privilege for the tip tree and not necessarily
> something everyone that sends you pulls should be doing.

Oh, the -tip tree arrangement is absolutely not a "privilege" for the
-tip tree. In fact, there are a few other trees that I have basically
_required_ do the same because not doing it was too messy. So now I
pull the security subsystem trees as 4-5 different separate branches
too, for example. (And obviously the ARM tree is the "historically
nasty" one that hasn't actually been a problem for several years, but
the solution was the same: split it up.

So I'm perfectly happy getting more than one pull request from everybody.

That said, I also don't want to get _pointless_ pull requests. I don't
want people to split their pulls "just because". It needs to make
sense.

And I *am* perfectly happy with you doing your merges too - I actually
like seeing submaintainers using topic branches for the different
things they do, and do their own merges. Because if I see splits, I
want them to be along some "broader" more generic thing, not - for
example - some "per driver pull request".

But I do ask that when people do their own merges, they actually write
a merge message for that local merge. I will still want the pull
request to talk about the *whole* thing I'm pulling (so you having
details in a local small merge doesn't mean that they shouldn't be
mentioned when then asking me to pull the whole result), so there may
be some duplication in commit messages as things get merged "up the
stack", but that's fine.

Also, the merge message really doesn't have to be extensive. But it
should at least talk about what the topic branch you merged was doing.
Just a sentence or two is fine, unless there's something subtle going
on, in which case that subtle thing needs to be explained.

Examples of "something subtle going on" is when the merge isn't just
for normal development on your own, but is (for example) merging a
common branch that you are also sharing with some other tree, or if
the merge is a back-merge that has some important reason for it.
Hopefully those back-merges don't even happen in the first place, but
if they do, I _really_ want an explanation for _why_ they happened.

For a regular topic branch merge, the "why" is not needed, because
it's "obvious". You're merging development. Then just a short sentence
of two of what the development is. Sometimes the topic branch name
itself *might* be enough, but usually just a _bit_ more information.

So for example, in that

    Merge branch 'for-4.18/mcsafe' into libnvdimm-for-next

merge, even just then adding below that a few sentences saying something like

 "Introduce new machine-check safe copy iterator to dax and make pmem
  use it.

  Add a test-case"

would have been appreciated.

It really doesn't need to be much. Just a "when people do 'git log',
they see what each commit does without having to know the big
picture".

Because imagine doing just 'git log' on my tree. You won't see just
the libnvdimm commits - you'll see tons of random other commits too,
and the commits that get merged by that merge commit are *not* obvious
(because they are probably way down deep in the history, and it's not
so easy to find them in the output of "git log" among all the other
thousands of  commits).

So just making each commit - whether it's a regular commit or a merge
- say what it does without the reader having to know the whole context
really makes it much more understandable.

So to re-iterate: you *can* send those branches individually to me,
and I'll just do three merges instead of one. That works too. But
libnvdimm isn't big enough of a subsystem for me to really necessarily
care at that level, so you doing your own topic branch merges is
*also* good.

But when you do your topic branch merges, imagine that you are me, and
that you're a maintainer that is merging something from a
submaintainer, and write the commit message as if you were a bit of an
outsider that had the submaintainer explain to you what you're
merging.

And simplifying and abstracting is good. Don't try to explain the
commits that get merged at an individual commit level - that's what
the commit messages _in_ those commits are for. The merge should have
a more high-level view of what gets merged.

             Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

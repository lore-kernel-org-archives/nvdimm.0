Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3C09C211BB8CD
 for <linux-nvdimm@lists.01.org>; Sat,  2 Feb 2019 12:38:24 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id x23so8673513oix.3
 for <linux-nvdimm@lists.01.org>; Sat, 02 Feb 2019 12:38:24 -0800 (PST)
MIME-Version: 1.0
References: <f0086a11a40fb97503fb559b53dcc94c9f873e32.camel@intel.com>
 <CAHk-=wgXh57rgtmSEvbKd69QYtBTRzU3QH36rKcFGiETRj45Sg@mail.gmail.com>
In-Reply-To: <CAHk-=wgXh57rgtmSEvbKd69QYtBTRzU3QH36rKcFGiETRj45Sg@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 2 Feb 2019 12:38:12 -0800
Message-ID: <CAPcyv4g2-DtUPE3MHKXgR9=Gbs9RoC=k2YY1-7wWukUHEZMGnA@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm fixes for v5.0-rc4
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
Cc: Dave Hansen <dave.hansen@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Feb 2, 2019 at 11:12 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sat, Jan 26, 2019 at 3:31 PM Williams, Dan J
> <dan.j.williams@intel.com> wrote:
> >
> > Hi Linus, please pull from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm tags/libnvdimm-fixes-5.0-rc4
>
> Hmm. One more pr-tracker-bot note: going through the pull requests
> from the last week, I notice that this one didn't get a pr-tracker
> response.
>
> It looks like lkml still hates you, so your pull request email never
> made it to the list despite being cc'd. And thus it never makes it to
> the lore and pr-tracker-bot infrastructure either.
>
> Have you tried looking into why lkml has that red-hot hatred of your emails?
>
> Because it does seem to be personal - you have pissed off the email
> gods some way. Did you get a bounce?

No bounce, but I at least have good company in the shunned group.
Mel's analysis of the impact of page-allocator randomization [1]
somehow also missed lore.kernel.org, but lkml.org caught it [2]. Add
Dave Hansen on the outside chance his mail scripts have caught other
instances of patches sent to the list but not archived in
lore.kernel.org.

[1]: <20181012082213.GE5819@techsingularity.net>
[2]: https://lkml.org/lkml/2018/10/12/309
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

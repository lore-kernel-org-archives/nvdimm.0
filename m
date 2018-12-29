Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 49BEE2118FF2F
 for <linux-nvdimm@lists.01.org>; Sat, 29 Dec 2018 10:05:11 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id j21so19506858oii.8
 for <linux-nvdimm@lists.01.org>; Sat, 29 Dec 2018 10:05:11 -0800 (PST)
MIME-Version: 1.0
References: <4880b31d0d32c38a675048be903814a062907125.camel@intel.com>
 <CAHk-=wgMfBXdiaeAxYrdTq9VoaVgN26T8MU7+3EnvJP_e0byuw@mail.gmail.com>
 <20181229153608.GA21173@pure.paranoia.local>
In-Reply-To: <20181229153608.GA21173@pure.paranoia.local>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 29 Dec 2018 10:04:59 -0800
Message-ID: <CAPcyv4h_J6fmkrf2rjwcDjfZitmgAmxn11KBk2YeVNgH3ma9PA@mail.gmail.com>
Subject: Re: [GIT PULL] libnvdimm for 4.21
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
To: Linus Torvalds <torvalds@linux-foundation.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Dec 29, 2018 at 7:36 AM Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> On Fri, Dec 28, 2018 at 09:57:28PM -0800, Linus Torvalds wrote:
> > Hmm.
> >
> > This pull request doesn't seem to have gotten an automatic pr-tracker
> > reply, even though I pulled it, and even though it was cc'd to lkml.
> >
> > Konstantin, any idea why the automation didn't trigger? I'm not seeing
> > anything all that odd about it.
>
> As you've noticed, it's not on lore, and it's also not on any other LKML
> archive out there (I've checked lkml.org, lkml.iu.edu, marc.info). So,
> I'm not sure precisely what happened, but it would appear that despite
> the CC in the headers, the mail never actually passed vger.
>
> > Does lkml hate Dan?

I suspect this is the case, or more specifically this is likely one of
those times where vger needed to put the Intel mail servers in a
time-out for bouncing too many mails.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

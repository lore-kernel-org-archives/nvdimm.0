Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00E73211D230E
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 16:54:42 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id z14so2262990oid.0
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 16:54:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4he0q_FdqqiXarp0bXjcggs8QZX8Od560E2iFxzCU3Qag@mail.gmail.com>
 <CAHk-=wjvmwD_0=CRQtNs5RBh8oJwrriXDn+XNWOU=wk8OyQ5ew@mail.gmail.com>
In-Reply-To: <CAHk-=wjvmwD_0=CRQtNs5RBh8oJwrriXDn+XNWOU=wk8OyQ5ew@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 10 Mar 2019 16:54:29 -0700
Message-ID: <CAPcyv4hafLUr2rKdLG+3SHXyWaa0d_2g8AKKZRf2mKPW+3DUSA@mail.gmail.com>
Subject: Re: [GIT PULL] device-dax for 5.1: PMEM as RAM
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
Cc: Linux MM <linux-mm@kvack.org>, "Luck, Tony" <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ add Tony, who has wrestled with how to detect rep; movs recover-ability ]

On Sun, Mar 10, 2019 at 1:02 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Mar 10, 2019 at 12:54 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > Hi Linus, please pull from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm
> > tags/devdax-for-5.1
> >
> > ...to receive new device-dax infrastructure to allow persistent memory
> > and other "reserved" / performance differentiated memories, to be
> > assigned to the core-mm as "System RAM".
>
> I'm not pulling this until I get official Intel clarification on the
> whole "pmem vs rep movs vs machine check" behavior.
>
> Last I saw it was deadly and didn't work, and we have a whole "mc-safe
> memory copy" thing for it in the kernel because repeat string
> instructions didn't work correctly on nvmem.
>
> No way am I exposing any users to something like that.
>
> We need a way to know when it works and when it doesn't, and only do
> it when it's safe.

Unfortunately this particular b0rkage is not constrained to nvmem.
I.e. there's nothing specific about nvmem requiring mc-safe memory
copy, it's a cpu problem consuming any poison regardless of
source-media-type with "rep; movs".
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

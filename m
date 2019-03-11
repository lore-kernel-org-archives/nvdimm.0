Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com
 [IPv6:2a00:1450:4864:20::142])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6A60211D0C8A
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 17:22:17 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id h6so2080905lfc.2
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 17:22:17 -0700 (PDT)
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com.
 [209.85.167.49])
 by smtp.gmail.com with ESMTPSA id b21sm863823lfi.7.2019.03.10.17.22.12
 for <linux-nvdimm@lists.01.org>
 (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
 Sun, 10 Mar 2019 17:22:13 -0700 (PDT)
Received: by mail-lf1-f49.google.com with SMTP id k136so2075646lfg.5
 for <linux-nvdimm@lists.01.org>; Sun, 10 Mar 2019 17:22:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4he0q_FdqqiXarp0bXjcggs8QZX8Od560E2iFxzCU3Qag@mail.gmail.com>
 <CAHk-=wjvmwD_0=CRQtNs5RBh8oJwrriXDn+XNWOU=wk8OyQ5ew@mail.gmail.com>
 <CAPcyv4hafLUr2rKdLG+3SHXyWaa0d_2g8AKKZRf2mKPW+3DUSA@mail.gmail.com>
In-Reply-To: <CAPcyv4hafLUr2rKdLG+3SHXyWaa0d_2g8AKKZRf2mKPW+3DUSA@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 10 Mar 2019 17:21:56 -0700
Message-ID: <CAHk-=wiTM93XKaFqUOR7q7133wvzNS8Kj777EZ9E8S99NbZhAA@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, "Luck, Tony" <tony.luck@intel.com>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Mar 10, 2019 at 4:54 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Unfortunately this particular b0rkage is not constrained to nvmem.
> I.e. there's nothing specific about nvmem requiring mc-safe memory
> copy, it's a cpu problem consuming any poison regardless of
> source-media-type with "rep; movs".

So why is it sold and used for the nvdimm pmem driver?

People told me it was a big deal and machines died.

You can't suddenly change the story just because you want to expose it
to user space.

You can't have it both ways. Either nvdimms have more likelihood of,
and problems with, machine checks, or it doesn't.

The end result is the same: if intel believes the kernel needs to
treat nvdimms specially, then we're sure as hell not exposing those
snowflakes to user space.

And if intel *doesn't* believe that, then we're removing the mcsafe_* functions.

There's no "oh, it's safe to show to user space, but the kernel is
magical" middle ground here that makes sense to me.

                Linus
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

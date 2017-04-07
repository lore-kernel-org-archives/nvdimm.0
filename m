Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x234.google.com (mail-io0-x234.google.com
 [IPv6:2607:f8b0:4001:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 14E0B2194233D
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 14:25:37 -0700 (PDT)
Received: by mail-io0-x234.google.com with SMTP id t68so23588110iof.0
 for <linux-nvdimm@lists.01.org>; Fri, 07 Apr 2017 14:25:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
References: <x49shlk700k.fsf@segfault.boston.devel.redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 7 Apr 2017 14:25:35 -0700
Message-ID: <CAGXu5jJ-Pny8_rrEBtO8W86zjw2Edk7a-My4EfRf7jePS4sQeg@mail.gmail.com>
Subject: Re: KASLR causes intermittent boot failures on some systems
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
Cc: Baoquan He <bhe@redhat.com>, linux-nvdimm@lists.01.org, LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Thomas Garnier <thgarnie@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 7, 2017 at 7:41 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Hi,
>
> commit 021182e52fe01 ("x86/mm: Enable KASLR for physical mapping memory
> regions") causes some of my systems with persistent memory (whether real
> or emulated) to fail to boot with a couple of different crash
> signatures.  The first signature is a NMI watchdog lockup of all but 1
> cpu, which causes much difficulty in extracting useful information from
> the console.  The second variant is an invalid paging request, listed
> below.

Just to rule out some of the stuff in the boot path, does booting with
"nokaslr" solve this? (i.e. I want to figure out if this is from some
of the rearrangements done that are exposed under that commit, or if
it is genuinely the randomization that is killing the systems...)

> On some systems, I haven't hit this problem at all.  Other systems
> experience a failed boot maybe 20-30% of the time.  To reproduce it,
> configure some emulated pmem on your system.  You can find directions
> for that here: https://nvdimm.wiki.kernel.org/
>
> Install ndctl (https://github.com/pmem/ndctl).
> Configure the namespace:
> # ndctl create-namespace -f -e namespace0.0 -m memory
>
> Then just reboot several times (5 should be enough), and hopefully
> you'll hit the issue.
>
> I've attached both my .config and the dmesg output from a successful
> boot at the end of this mail.

Thanks! Considering I know nothing about pmem (yet), I bet there is
some oversight in what's happening with how KASLR scans for available
memory areas. I'll carve out some time next week to look into this.

-Kees

-- 
Kees Cook
Pixel Security
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <CAPcyv4he0q_FdqqiXarp0bXjcggs8QZX8Od560E2iFxzCU3Qag@mail.gmail.com>
 <CAHk-=wjvmwD_0=CRQtNs5RBh8oJwrriXDn+XNWOU=wk8OyQ5ew@mail.gmail.com>
 <CAPcyv4hafLUr2rKdLG+3SHXyWaa0d_2g8AKKZRf2mKPW+3DUSA@mail.gmail.com> <CAHk-=wiTM93XKaFqUOR7q7133wvzNS8Kj777EZ9E8S99NbZhAA@mail.gmail.com>
In-Reply-To: <CAHk-=wiTM93XKaFqUOR7q7133wvzNS8Kj777EZ9E8S99NbZhAA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Mar 2019 08:37:19 -0700
Message-ID: <CAPcyv4hMZMuSEtUkKqL067f4cWPGivzn9mCtv3gZsJG2qUOYvg@mail.gmail.com>
Subject: Re: [GIT PULL] device-dax for 5.1: PMEM as RAM
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, "Luck, Tony" <tony.luck@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Mar 10, 2019 at 5:22 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, Mar 10, 2019 at 4:54 PM Dan Williams <dan.j.williams@intel.com> wrote:
> >
> > Unfortunately this particular b0rkage is not constrained to nvmem.
> > I.e. there's nothing specific about nvmem requiring mc-safe memory
> > copy, it's a cpu problem consuming any poison regardless of
> > source-media-type with "rep; movs".
>
> So why is it sold and used for the nvdimm pmem driver?
>
> People told me it was a big deal and machines died.
>
> You can't suddenly change the story just because you want to expose it
> to user space.
>
> You can't have it both ways. Either nvdimms have more likelihood of,
> and problems with, machine checks, or it doesn't.
>
> The end result is the same: if intel believes the kernel needs to
> treat nvdimms specially, then we're sure as hell not exposing those
> snowflakes to user space.
>
> And if intel *doesn't* believe that, then we're removing the mcsafe_* functions.
>
> There's no "oh, it's safe to show to user space, but the kernel is
> magical" middle ground here that makes sense to me.

I don't think anyone is trying to claim both ways... the mcsafe memcpy
is not implemented because NVDIMMs have a higher chance of
encountering poison, it's implemented because the pmem driver affords
an error model that just isn't possible in other kernel poison
consumption paths. Even if this issue didn't exist there would still
be a rep; mov based mcsafe memcpy for the driver to use on the
expectation that userspace would prefer EIO to a reboot for
kernel-space consumed poison.

That said, I agree with the argument that a kernel mcsafe copy is not
sufficient when DAX is there to arrange for the bulk of
memory-mapped-I/O to be issued from userspace.

Another feature the userspace tooling can support for the PMEM as RAM
case is the ability to complete an Address Range Scrub of the range
before it is added to the core-mm. I.e at least ensure that previously
encountered poison is eliminated. The driver can also publish an
attribute to indicate when rep; mov is recoverable, and gate the
hotplug policy on the result. In my opinion a positive indicator of
the cpu's ability to recover rep; mov exceptions is a gap that needs
addressing.

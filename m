Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Thu, 28 May 2015 00:36:11 +0200
Message-ID: <CAJZ5v0h2RpkFRHbGxGRbVXCeySkSZLm71YG16ToiaXg_XgacDQ@mail.gmail.com>
Subject: Re: [GIT PULL v4 00/21] libnd: non-volatile memory device support
From: "Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: axboe@kernel.dk, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, hch@lst.de, sfr@canb.auug.org.au, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Ingo Molnar <mingo@kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, jmoyer@redhat.com, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi,

On Thu, May 28, 2015 at 12:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> Jens, please pull from...
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm tags/libnd-for-jens
>
> ...to receive the libnd sub-system for the next merge window.  This has
> been through 3 rounds of review.  Incremental diffstats and links to
> previous postings:
>
> v1: 39 files changed, 13102 insertions(+), 36 deletions(-)
>     https://lists.01.org/pipermail/linux-nvdimm/2015-April/000484.html
>
> v2: 30 files changed, 3166 insertions(+), 3935 deletions(-)
>     https://lists.01.org/pipermail/linux-nvdimm/2015-April/000574.html
>
> v3: 33 files changed, 2202 insertions(+), 1233 deletions(-)
>     https://lists.01.org/pipermail/linux-nvdimm/2015-May/000804.html
>
> v4: Full diffstat since v3
>
>     Documentation/blockdev/libnd.txt  |   2 +-
>     arch/x86/Kconfig                  |   4 ++
>     arch/x86/kernel/pmem.c            |  92 +++++++++++++++++++++++------------
>     drivers/acpi/nfit.c               |  20 ++++----
>     drivers/acpi/nfit.h               |   4 +-
>     drivers/block/Kconfig             |   8 ---
>     drivers/block/Makefile            |   1 -
>     drivers/block/e820_pmem.c         | 100 --------------------------------------
>     drivers/block/nd/Kconfig          |  10 ++++
>     drivers/block/nd/btt.h            |   2 +-
>     drivers/block/nd/namespace_devs.c |   5 +-
>     drivers/block/nd/pmem.c           |   2 +-
>     drivers/block/nd/test/nfit.c      |  10 ++--
>     include/acpi/acuuid.h             |  16 +++---
>     14 files changed, 105 insertions(+), 171 deletions(-)
>     delete mode 100644 drivers/block/e820_pmem.c
>
>     1/ Kill drivers/block/e820_pmem.c, we can just register pmem
>        regions directly from arch/x86/kernel/pmem.c without need for an
>        intermediary driver (Christoph).
>
>     2/ Update to latest NFIT UUID definitions (Toshi).  This
>        merges cleanly with, and is identical to the include/acpi/
>        NFIT enabling in Rafael's linux-pm.git/bleeding-edge branch.

Well, I didn't expect you to send a pull request for this right away
to be honest.

Can you please pull from my acpica branch and rebase your patches on
top of that by any chance?

And no, the "merges cleanly" part isn't sufficient as it'll create a
mess of a history if merged together like that.  Can we do that
properly instead?

Thanks,
Rafael

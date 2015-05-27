Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4h9TWe0dNwiZ8PWvQAoJsHTih0dhdM7D+pMyjDVrixPsw@mail.gmail.com>
References: <20150527210155.17965.74864.stgit@dwillia2-desk3.amr.corp.intel.com>
	<CAJZ5v0h2RpkFRHbGxGRbVXCeySkSZLm71YG16ToiaXg_XgacDQ@mail.gmail.com>
	<CAPcyv4h9TWe0dNwiZ8PWvQAoJsHTih0dhdM7D+pMyjDVrixPsw@mail.gmail.com>
Date: Thu, 28 May 2015 01:17:01 +0200
Message-ID: <CAJZ5v0jxLTX3U7L_KSHCKW0GTeWfDS7ZaJP=wK96y3_Cio976A@mail.gmail.com>
Subject: Re: [GIT PULL v4 00/21] libnd: non-volatile memory device support
From: "Rafael J. Wysocki" <rafael@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Stephen Rothwell <sfr@canb.auug.org.au>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Ingo Molnar <mingo@kernel.org>, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 28, 2015 at 12:52 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Wed, May 27, 2015 at 3:36 PM, Rafael J. Wysocki <rafael@kernel.org> wrote:
>> Hi,
>>
>> On Thu, May 28, 2015 at 12:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> Jens, please pull from...
>>>
>>>    git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm tags/libnd-for-jens
>>>
>>> ...to receive the libnd sub-system for the next merge window.  This has
>>> been through 3 rounds of review.  Incremental diffstats and links to
>>> previous postings:
>>>
>>> v1: 39 files changed, 13102 insertions(+), 36 deletions(-)
>>>     https://lists.01.org/pipermail/linux-nvdimm/2015-April/000484.html
>>>
>>> v2: 30 files changed, 3166 insertions(+), 3935 deletions(-)
>>>     https://lists.01.org/pipermail/linux-nvdimm/2015-April/000574.html
>>>
>>> v3: 33 files changed, 2202 insertions(+), 1233 deletions(-)
>>>     https://lists.01.org/pipermail/linux-nvdimm/2015-May/000804.html
>>>
>>> v4: Full diffstat since v3
>>>
>>>     Documentation/blockdev/libnd.txt  |   2 +-
>>>     arch/x86/Kconfig                  |   4 ++
>>>     arch/x86/kernel/pmem.c            |  92 +++++++++++++++++++++++------------
>>>     drivers/acpi/nfit.c               |  20 ++++----
>>>     drivers/acpi/nfit.h               |   4 +-
>>>     drivers/block/Kconfig             |   8 ---
>>>     drivers/block/Makefile            |   1 -
>>>     drivers/block/e820_pmem.c         | 100 --------------------------------------
>>>     drivers/block/nd/Kconfig          |  10 ++++
>>>     drivers/block/nd/btt.h            |   2 +-
>>>     drivers/block/nd/namespace_devs.c |   5 +-
>>>     drivers/block/nd/pmem.c           |   2 +-
>>>     drivers/block/nd/test/nfit.c      |  10 ++--
>>>     include/acpi/acuuid.h             |  16 +++---
>>>     14 files changed, 105 insertions(+), 171 deletions(-)
>>>     delete mode 100644 drivers/block/e820_pmem.c
>>>
>>>     1/ Kill drivers/block/e820_pmem.c, we can just register pmem
>>>        regions directly from arch/x86/kernel/pmem.c without need for an
>>>        intermediary driver (Christoph).
>>>
>>>     2/ Update to latest NFIT UUID definitions (Toshi).  This
>>>        merges cleanly with, and is identical to the include/acpi/
>>>        NFIT enabling in Rafael's linux-pm.git/bleeding-edge branch.
>>
>> Well, I didn't expect you to send a pull request for this right away
>> to be honest.
>
> No worries, we can address these concerns now...
>
>> Can you please pull from my acpica branch and rebase your patches on
>> top of that by any chance?
>
> I noticed that bleeding-edge rebased from the last time I checked is
> that branch stable enough to use as a baseline?

There is a separate acpica branch (called "acpica") that's not going
to be rebased.  Please use that one.

>> And no, the "merges cleanly" part isn't sufficient as it'll create a
>> mess of a history if merged together like that.  Can we do that
>> properly instead?
>
> If I merge 'bleeding-edge' on top of v4.1-rc5 followed by this branch
> and do a "git log include/acpi/acuuid.h" then the full history from
> the 'bleeding-edge' branch shows up.
>
> I'm fine with doing the rebase, but I don't quite see the mess to
> which you are referring.  Especially compared to the thrash of moving
> our test baseline.

People will not be running your test baseline, mind you.  They will be
running the product of merging that with other stuff and for example
the same change showing as two different commits in the history is not
a particularly clean thing.

Thanks,
Rafael

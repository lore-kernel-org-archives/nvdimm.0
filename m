Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151025212247.GI19199@dastard>
References: <20151022064142.12700.11849.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151022064211.12700.77105.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151022093549.GE14445@quack.suse.cz>
	<1445529945.17208.4.camel@intel.com>
	<20151022210818.GC8670@quack.suse.cz>
	<20151025212247.GI19199@dastard>
Date: Mon, 26 Oct 2015 11:48:06 +0900
Message-ID: <CAPcyv4hjGYYPRyPjZc3CymmnSObB7mULRbeMZFjnKdoCD_m7pw@mail.gmail.com>
Subject: Re: [PATCH 5/5] block: enable dax for raw block devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "hch@lst.de" <hch@lst.de>, "axboe@fb.com" <axboe@fb.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "willy@linux.intel.com" <willy@linux.intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 26, 2015 at 6:22 AM, Dave Chinner <david@fromorbit.com> wrote:
> On Thu, Oct 22, 2015 at 11:08:18PM +0200, Jan Kara wrote:
>> Ugh2: Now I realized that DAX mmap isn't safe wrt fs freezing even for
>> filesystems since there's nothing which writeprotects pages that are
>> writeably mapped. In normal path, page writeback does this but that doesn't
>> happen for DAX. I remember we once talked about this but it got lost.
>> We need something like walk all filesystem inodes during fs freeze and
>> writeprotect all pages that are mapped. But that's going to be slow...
>
> fsync() has the same problem - we have no record of the pages that
> need to be committed and then write protected when fsync() is called
> after write()...

I know Ross is still working on that implementation.  However, I had a
thought on the flight to ksummit that maybe we shouldn't worry about
tracking dirty state on a per-page basis.  For small / frequent
synchronizations an application really should be using the nvml
library [1] to issue cache flushes and pcommit from userspace on a
per-cacheline basis.  That leaves unmodified apps that want to be
correct in the presence of dax mappings.  Two things we can do to
mitigate that case:

1/ Make DAX mappings opt-in with a new MMAP_DAX (page-cache bypass)
flag.  Applications shouldn't silently become incorrect simply because
the fs is mounted with -o dax.  If an app doesn't understand DAX
mappings it should get page-cache semantics.  This also protects apps
that are not expecting DAX semantics on raw block device mappings.

2/ Even if we get a new flag that lets the kernel know the app
understands DAX mappings, we shouldn't leave fsync broken.  Can we
instead get by with a simple / big hammer solution?  I.e.

    on_each_cpu(sync_cache, ...);

...where sync_cache is something like:

    cache_disable();
    wbinvd();
    pcommit();
    cache_enable();

Disruptive, yes, but if an app cares about efficient persistent memory
synchronization fsync is already the wrong api.

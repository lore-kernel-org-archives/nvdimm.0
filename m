Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ipmail06.adl2.internode.on.net (ipmail06.adl2.internode.on.net
 [150.101.137.129]) by ml01.01.org (Postfix) with ESMTP id C306B1A1DF7
 for <linux-nvdimm@lists.01.org>; Fri,  5 Aug 2016 04:27:42 -0700 (PDT)
Date: Fri, 5 Aug 2016 21:27:39 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Subtle races between DAX mmap fault and write path
Message-ID: <20160805112739.GG16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz>
 <20160727211039.GA20278@linux.intel.com>
 <20160727221949.GU16044@dastard>
 <20160728081033.GC4094@quack2.suse.cz>
 <20160729022152.GZ16044@dastard>
 <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com>
 <20160730001249.GE16044@dastard> <579F20D9.80107@plexistor.com>
 <20160802002144.GL16044@dastard>
 <1470335997.8908.128.camel@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1470335997.8908.128.camel@hpe.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "jack@suse.cz" <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

[ cut to just the important points ]
On Thu, Aug 04, 2016 at 06:40:42PM +0000, Kani, Toshimitsu wrote:
> On Tue, 2016-08-02 at 10:21 +1000, Dave Chinner wrote:
> > If I drop the fsync from the
> > buffered IO path, bandwidth remains the same but runtime drops to
> > 0.55-0.57s, so again the buffered IO write path is faster than DAX
> > while doing more work.
> =

> I do not think the test results are relevant on this point because both
> buffered and dax write() paths use uncached copy to avoid clflush. =A0The
> buffered path uses cached copy to the page cache and then use uncached co=
py to
> PMEM via writeback. =A0Therefore, the buffered IO path also benefits from=
 using
> uncached copy to avoid clflush.

Except that I tested without the writeback path for buffered IO, so
there was a direct comparison for single cached copy vs single
uncached copy.

The undenial fact is that a write() with a single cached copy with
all the overhead of dirty page tracking is /faster/ than a much
shorter, simpler IO path that uses an uncached copy. That's what the
numbers say....

> Cached copy (req movq) is slightly faster than uncached copy,

Not according to Boaz - he claims that uncached is 20% faster than
cached. How about you two get together, do some benchmarking and get
your story straight, eh?

> and should be
> used for writing to the page cache. =A0For writing to PMEM, however, addi=
tional
> clflush can be expensive, and allocating cachelines for PMEM leads to evi=
ct
> application's cachelines.

I keep hearing people tell me why cached copies are slower, but
no-one is providing numbers to back up their statements. The only
numbers we have are the ones I've published showing cached copies w/
full dirty tracking is faster than uncached copy w/o dirty tracking.

Show me the numbers that back up your statements, then I'll listen
to you.

-Dave.
-- =

Dave Chinner
david@fromorbit.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

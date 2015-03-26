Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 27 Mar 2015 08:31:13 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
Message-ID: <20150326213113.GF28129@dastard>
References: <54F82CE0.4040502@plexistor.com>
 <54F830D4.7030205@plexistor.com>
 <54F84420.40209@plexistor.com>
 <CALCETrXsQsoa0qfzM-o+kz6Af2EtvJR7Er6OwxjZ5JegMYxpFg@mail.gmail.com>
 <54FD901A.3030905@plexistor.com>
 <CALCETrVt9KiWsT37Z_90gBREK1NoSJ2ruT48uv-7QWumYz+TNg@mail.gmail.com>
 <94D0CD8314A33A4D9D801C0FE68B40295A84453E@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B40295A84453E@G9W0745.americas.hpqcorp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Boaz Harrosh <boaz@plexistor.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Dan Williams <dan.j.williams@intel.com>, Ingo Molnar <mingo@redhat.com>, "Roger C. Pao" <rcpao.enmotus@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-kernel <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>, "Kani, Toshimitsu" <toshi.kani@hp.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 26, 2015 at 04:00:57AM +0000, Elliott, Robert (Server Storage) wrote:
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Andy Lutomirski
> > Sent: Wednesday, March 18, 2015 1:07 PM
> > To: Boaz Harrosh
> > Cc: Matthew Wilcox; Ross Zwisler; X86 ML; Thomas Gleixner; Dan Williams;
> > Ingo Molnar; Roger C. Pao; linux-nvdimm; linux-kernel; H. Peter Anvin;
> > Christoph Hellwig
> > Subject: Re: [PATCH 1/8] pmem: Initial version of persistent memory driver
> > 
> > On Mar 9, 2015 8:20 AM, "Boaz Harrosh" <boaz@plexistor.com> wrote:
> > >
> > > On 03/06/2015 01:03 AM, Andy Lutomirski wrote:
> > > <>
> > > >
> > > > I think it would be nice to have control over the caching mode.
> > > > Depending on the application, WT or UC could make more sense.
> > > >
> > >
> > > Patches are welcome. say
> > >         map=sss@aaa:WT,sss@aaa:CA, ...
> > >
> > > But for us, with direct_access(), all benchmarks show a slight advantage
> > > for the cached mode.
> > 
> > I'm sure cached is faster.  The question is: who flushes the cache?
> > 
> > --Andy
> 
> Nobody.

There is another discussion going on about ensuring we have
mechanisms to flush the cpu caches correctly when DAX is enabled and
data integrity operations are run.  i.e. fsync and sync will provide
cache flush triggers for DAX enabled devices once we get everything
in place.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

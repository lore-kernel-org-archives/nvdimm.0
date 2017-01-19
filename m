Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Thu, 19 Jan 2017 14:17:19 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in
 filesystems
Message-ID: <20170119211719.GG4880@omniknight.lm.intel.com>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <20170117063355.GL14033@birch.djwong.org>
 <20170117213549.GB4880@omniknight.lm.intel.com>
 <CAOvWMLYMR-VvAVNuVjXPC-woxY6afQX5-hMC=Vj2p=3AGj9tyA@mail.gmail.com>
 <20170117223705.GD4880@omniknight.lm.intel.com>
 <20170118093801.GA24789@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170118093801.GA24789@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, Andiry Xu <andiry@gmail.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 01/18, Jan Kara wrote:
> On Tue 17-01-17 15:37:05, Vishal Verma wrote:
> > I do mean that in the filesystem, for every IO, the badblocks will be
> > checked. Currently, the pmem driver does this, and the hope is that the
> > filesystem can do a better job at it. The driver unconditionally checks
> > every IO for badblocks on the whole device. Depending on how the
> > badblocks are represented in the filesystem, we might be able to quickly
> > tell if a file/range has existing badblocks, and error out the IO
> > accordingly.
> > 
> > At mount the the fs would read the existing badblocks on the block
> > device, and build its own representation of them. Then during normal
> > use, if the underlying badblocks change, the fs would get a notification
> > that would allow it to also update its own representation.
> 
> So I believe we have to distinguish three cases so that we are on the same
> page.
> 
> 1) PMEM is exposed only via a block interface for legacy filesystems to
> use. Here, all the bad blocks handling IMO must happen in NVDIMM driver.
> Looking from outside, the IO either returns with EIO or succeeds. As a
> result you cannot ever ger rid of bad blocks handling in the NVDIMM driver.

Correct.

> 
> 2) PMEM is exposed for DAX aware filesystem. This seems to be what you are
> mostly interested in. We could possibly do something more efficient than
> what NVDIMM driver does however the complexity would be relatively high and
> frankly I'm far from convinced this is really worth it. If there are so
> many badblocks this would matter, the HW has IMHO bigger problems than
> performance.

Correct, and Dave was of the opinion that once at least XFS has reverse
mapping support (which it does now), adding badblocks information to
that should not be a hard lift, and should be a better solution. I
suppose should try to benchmark how much of a penalty the current badblock
checking in the NVVDIMM driver imposes. The penalty is not because there
may be a large number of badblocks, but just due to the fact that we
have to do this check for every IO, in fact, every 'bvec' in a bio.

> 
> 3) PMEM filesystem - there things are even more difficult as was already
> noted elsewhere in the thread. But for now I'd like to leave those aside
> not to complicate things too much.

Agreed that that merits consideration and a whole discussion  by itself,
based on the points Audiry raised.

> 
> Now my question: Why do we bother with badblocks at all? In cases 1) and 2)
> if the platform can recover from MCE, we can just always access persistent
> memory using memcpy_mcsafe(), if that fails, return -EIO. Actually that
> seems to already happen so we just need to make sure all places handle
> returned errors properly (e.g. fs/dax.c does not seem to) and we are done.
> No need for bad blocks list at all, no slow down unless we hit a bad cell
> and in that case who cares about performance when the data is gone...

Even when we have MCE recovery, we cannot do away with the badblocks
list:
1. My understanding is that the hardware's ability to do MCE recovery is
limited/best-effort, and is not guaranteed. There can be circumstances
that cause a "Processor Context Corrupt" state, which is unrecoverable.
2. We still need to maintain a badblocks list so that we know what
blocks need to be cleared (via the ACPI method) on writes.

> 
> For platforms that cannot recover from MCE - just buy better hardware ;).
> Seriously, I have doubts people can seriously use a machine that will
> unavoidably randomly reboot (as there is always a risk you hit error that
> has not been uncovered by background scrub). But maybe for big cloud providers
> the cost savings may offset for the inconvenience, I don't know. But still
> for that case a bad blocks handling in NVDIMM code like we do now looks
> good enough?

The current handling is good enough for those systems, yes.

> 
> 								Honza
> -- 
> Jan Kara <jack@suse.com>
> SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

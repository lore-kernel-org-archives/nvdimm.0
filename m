Return-Path: <linux-nvdimm-bounces@lists.01.org>
Date: Wed, 18 Jan 2017 13:02:41 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Badblocks checking/representation in
 filesystems
Message-ID: <20170118210241.GE10498@birch.djwong.org>
References: <at1mp6pou4lenesjdgh22k4p.1484345585589@email.android.com>
 <b9rbflutjt10mb4ofherta8j.1484345610771@email.android.com>
 <SN2PR04MB2191756EABCB0E9DAA3B5328887B0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170114004910.GA4880@omniknight.lm.intel.com>
 <SN2PR04MB2191A6EDB7203AF86600FD25887D0@SN2PR04MB2191.namprd04.prod.outlook.com>
 <20170117143703.GP2517@quack2.suse.cz>
 <20170117221421.GC4880@omniknight.lm.intel.com>
 <20170118101641.GD24789@quack2.suse.cz>
 <x49r3406r2i.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49r3406r2i.fsf@segfault.boston.devel.redhat.com>
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
Cc: Jan Kara <jack@suse.cz>, Slava Dubeyko <Vyacheslav.Dubeyko@wdc.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, Viacheslav Dubeyko <slava@dubeyko.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 18, 2017 at 03:39:17PM -0500, Jeff Moyer wrote:
> Jan Kara <jack@suse.cz> writes:
> 
> > On Tue 17-01-17 15:14:21, Vishal Verma wrote:
> >> Your note on the online repair does raise another tangentially related
> >> topic. Currently, if there are badblocks, writes via the bio submission
> >> path will clear the error (if the hardware is able to remap the bad
> >> locations). However, if the filesystem is mounted eith DAX, even
> >> non-mmap operations - read() and write() will go through the dax paths
> >> (dax_do_io()). We haven't found a good/agreeable way to perform
> >> error-clearing in this case. So currently, if a dax mounted filesystem
> >> has badblocks, the only way to clear those badblocks is to mount it
> >> without DAX, and overwrite/zero the bad locations. This is a pretty
> >> terrible user experience, and I'm hoping this can be solved in a better
> >> way.
> >
> > Please remind me, what is the problem with DAX code doing necessary work to
> > clear the error when it gets EIO from memcpy on write?
> 
> You won't get an MCE for a store;  only loads generate them.
> 
> Won't fallocate FL_ZERO_RANGE clear bad blocks when mounted with -o dax?

Not necessarily; XFS usually implements this by punching out the range
and then reallocating it as unwritten blocks.

--D

> 
> Cheers,
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

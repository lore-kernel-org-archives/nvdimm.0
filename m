Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 804963FC8
	for <nvdimm@lists.linux.dev>; Thu, 23 Sep 2021 09:57:16 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9647B6124C;
	Thu, 23 Sep 2021 09:57:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1632391036;
	bh=wZghjeZMmeRhet9HPhnAN6w0LewUCrC6CdWlnBZb/Mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PcJ/45EPIxi5D0pJE0jiBUxa2jnVJC9G8dc9k3Qf8d/bwY8Z67JIU8ygTClmwULSh
	 uA7HmqIldXbjs1nQw0E1CeQMw3s9O4NtorBJCSK0jaQdlKAgXxE4jFra9zsDPsBjdI
	 1T7Nog4LQswRF/LB5mISAFzaWVgB8+nfNXKbTMic=
Date: Thu, 23 Sep 2021 11:57:13 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Coly Li <colyli@suse.de>, linux-kernel@vger.kernel.org,
	linux-block@vger.kernel.org, linux-raid@vger.kernel.org,
	nvdimm@lists.linux.dev, antlists@youngman.org.uk,
	Dan Williams <dan.j.williams@intel.com>,
	Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
	Richard Fan <richard.fan@suse.com>,
	Vishal L Verma <vishal.l.verma@intel.com>, rafael@kernel.org
Subject: Re: Too large badblocks sysfs file (was: [PATCH v3 0/7] badblocks
 improvement for multiple bad block ranges)
Message-ID: <YUxPeQR/k5AGO2RH@kroah.com>
References: <20210913163643.10233-1-colyli@suse.de>
 <a0f7b021-4816-6785-a9a4-507464b55895@suse.de>
 <6bd61a93-6fb6-2bd5-c1a6-b782e87845a4@suse.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6bd61a93-6fb6-2bd5-c1a6-b782e87845a4@suse.de>

On Thu, Sep 23, 2021 at 11:40:30AM +0200, Hannes Reinecke wrote:
> On 9/23/21 7:59 AM, Coly Li wrote:
> > Hi all the kernel gurus, and folks in mailing lists,
> > 
> > This is a question about exporting 4KB+ text information via sysfs
> > interface. I need advice on how to handle the problem.
> > 
> > Recently I work on the bad blocks API (block/badblocks.c) improvement,
> > there is a sysfs file to export the bad block ranges for me raid. E.g
> > for a md raid1 device, file
> >     /sys/block/md0/md/rd0/bad_blocks
> > may contain the following text content,
> >     64 32
> >    128 8
> > The above lines mean there are two bad block ranges, one starts at LBA
> > 64, length 32 sectors, another one starts at LBA 128 and length 8
> > sectors. All the content is generated from the internal bad block
> > records with 512 elements. In my testing the worst case only 185 from
> > 512 records can be displayed via the sysfs file if the LBA string is
> > very long, e.g.the following content,
> >   17668164135030776 512
> >   17668164135029776 512
> >   17668164135028776 512
> >   17668164135027776 512
> >   ... ...
> > The bad block ranges stored in internal bad blocks array are correct,
> > but the output message is truncated. This is the problem I encountered.
> > 
> > I don't see sysfs has seq_file support (correct me if I am wrong), and I
> > know it is improper to transfer 4KB+ text via sysfs interface, but the
> > code is here already for long time.
> > 
> > There are 2 ideas to fix showing up in my brain,
> > 1) Do not fix the problem
> >     Normally it is rare that a storage media has 100+ bad block ranges,
> > maybe in real world all the existing bad blocks information won't exceed
> > the page size limitation of sysfs file.
> > 2) Add seq_file support to sysfs interface if there is no
> > 
> > It is probably there is other better solution to fix. So I do want to
> > get hint/advice from you.
> > 
> > Thanks in advance for any comment :-)
> > 
> > Coly Li
> > 
> > On 9/14/21 12:36 AM, Coly Li wrote:
> >> This is the second effort to improve badblocks code APIs to handle
> >> multiple ranges in bad block table.
> >>
> >> There are 2 changes from previous version,
> >> - Fixes 2 bugs in front_overwrite() which are detected by the user
> >>    space testing code.
> >> - Provide the user space testing code in last patch.
> >>
> >> There is NO in-memory or on-disk format change in the whole series, all
> >> existing API and data structures are consistent. This series just only
> >> improve the code algorithm to handle more corner cases, the interfaces
> >> are same and consistency to all existing callers (md raid and nvdimm
> >> drivers).
> >>
> >> The original motivation of the change is from the requirement from our
> >> customer, that current badblocks routines don't handle multiple ranges.
> >> For example if the bad block setting range covers multiple ranges from
> >> bad block table, only the first two bad block ranges merged and rested
> >> ranges are intact. The expected behavior should be all the covered
> >> ranges to be handled.
> >>
> >> All the patches are tested by modified user space code and the code
> >> logic works as expected. The modified user space testing code is
> >> provided in last patch. The testing code detects 2 defects in helper
> >> front_overwrite() and fixed in this version.
> >>
> >> The whole change is divided into 6 patches to make the code review more
> >> clear and easier. If people prefer, I'd like to post a single large
> >> patch finally after the code review accomplished.
> >>
> >> This version is seriously tested, and so far no more defect observed.
> >>
> >>
> >> Coly Li
> >>
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Cc: Hannes Reinecke <hare@suse.de>
> >> Cc: Jens Axboe <axboe@kernel.dk>
> >> Cc: NeilBrown <neilb@suse.de>
> >> Cc: Richard Fan <richard.fan@suse.com>
> >> Cc: Vishal L Verma <vishal.l.verma@intel.com>
> >> ---
> >> Changelog:
> >> v3: add tester Richard Fan <richard.fan@suse.com>
> >> v2: the improved version, and with testing code.
> >> v1: the first completed version.
> >>
> >>
> >> Coly Li (6):
> >>    badblocks: add more helper structure and routines in badblocks.h
> >>    badblocks: add helper routines for badblock ranges handling
> >>    badblocks: improvement badblocks_set() for multiple ranges handling
> >>    badblocks: improve badblocks_clear() for multiple ranges handling
> >>    badblocks: improve badblocks_check() for multiple ranges handling
> >>    badblocks: switch to the improved badblock handling code
> >> Coly Li (1):
> >>    test: user space code to test badblocks APIs
> >>
> >>   block/badblocks.c         | 1599 ++++++++++++++++++++++++++++++-------
> >>   include/linux/badblocks.h |   32 +
> >>   2 files changed, 1340 insertions(+), 291 deletions(-)
> >>
> > 
> 
> Please have a look at the patchset 'start switching sysfs attributes to
> expose the seq_file' from Christoph Hellwig on linux-block; that seems
> to be the approach you are looking for.

No, I rejected the seq_file api for sysfs files, as it encourages abuse
like this, sorry.

greg k-h

Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FE7387
	for <nvdimm@lists.linux.dev>; Tue, 10 Oct 2023 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZlYl3imq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82758C433C7;
	Tue, 10 Oct 2023 17:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696960280;
	bh=uE/KA3/xwyb4Z/BNdd2QZJTz3oALBz6gA7/EzGFkeLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZlYl3imq6eHQDrYC5PMugfQ4TMG+jmibRRwNsJpm6XcNIxxcBBPCktbCkfYeI65nN
	 qLdiMIAtmfzfk1VTsJMIkep0WOtwQywy7N/bdTJ3Bxdvk9teyl3ymzSK4R6NDv+BXA
	 nxbUzVVqepVMibCXFzK3XWuifmRR7J5Yi79JEcOFjXtPBa++LDHbigBYpKlkAW6J2s
	 m8KNUEsS4QDH8eCSAu3nU1GlWqBXizAV85ZOQ/FvaUPjgEbiVyslwiklmU8YUorofa
	 H42Ps4swpIS3vN2xtcYT9GyiAAFQ1RsNZSahYrASI3j4L6trLXlgxfEQeHgjydlYNn
	 bs91cTASHnDnw==
Date: Tue, 10 Oct 2023 10:51:19 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Chandan Babu R <chandanbabu@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <20231010175119.GG21298@frogsfrogsfrogs>
References: <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
 <651718a6a6e2c_c558e2943e@dwillia2-xfh.jf.intel.com.notmuch>
 <ec2de0b9-c07d-468a-bd15-49e83cba1ad9@fujitsu.com>
 <87y1gltcvg.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20231005000809.GN21298@frogsfrogsfrogs>
 <ce9ef1dc-d62b-466d-882f-d7bf4350582d@fujitsu.com>
 <20231005160530.GO21298@frogsfrogsfrogs>
 <28613f6e-2ed2-4c9a-81e3-3dcfdbba867c@fujitsu.com>
 <20231009164721.GC21298@frogsfrogsfrogs>
 <019bc83b-7f94-476b-95cb-280f1045057d@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <019bc83b-7f94-476b-95cb-280f1045057d@fujitsu.com>

On Tue, Oct 10, 2023 at 11:53:02AM +0800, Shiyang Ruan wrote:
> 
> 
> 在 2023/10/10 0:47, Darrick J. Wong 写道:
> > On Mon, Oct 09, 2023 at 10:14:12PM +0800, Shiyang Ruan wrote:
> > > 
> > > 
> > > 在 2023/10/6 0:05, Darrick J. Wong 写道:
> > > > On Thu, Oct 05, 2023 at 04:53:12PM +0800, Shiyang Ruan wrote:
> > > > > 
> > > > > 
> > > > > 在 2023/10/5 8:08, Darrick J. Wong 写道:
> > > > > > > > 
> > > > > > > > Sorry, I sent the list below to Chandan, didn't cc the maillist
> > > > > > > > because it's just a rough list rather than a PR:
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 1. subject: [v3]  xfs: correct calculation for agend and blockcount
> > > > > > > >       url:
> > > > > > > >       https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com/
> > > > > > > >       note:    This one is a fix patch for commit: 5cf32f63b0f4 ("xfs:
> > > > > > > >       fix the calculation for "end" and "length"").
> > > > > > > >                It can solve the fail of xfs/55[0-2]: the programs
> > > > > > > >                accessing the DAX file may not be notified as expected,
> > > > > > > >               because the length always 1 block less than actual.  Then
> > > > > > > >              this patch fixes this.
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 2. subject: [v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
> > > > > > > >       url:
> > > > > > > >       https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u
> > > > > > > >       note:    This is a feature patch.  It handles the pre-remove event
> > > > > > > >       of DAX device, by notifying kernel/user space before actually
> > > > > > > >      removing.
> > > > > > > >                It has been picked by Andrew in his
> > > > > > > >                mm-hotfixes-unstable. I am not sure whether you or he will
> > > > > > > >               merge this one.
> > > > > > > > 
> > > > > > > > 
> > > > > > > > 3. subject: [v1]  xfs: drop experimental warning for FSDAX
> > > > > > > >       url:
> > > > > > > >       https://lore.kernel.org/linux-xfs/20230915063854.1784918-1-ruansy.fnst@fujitsu.com/
> > > > > > > >       note:    With the patches mentioned above, I did a lot of tests,
> > > > > > > >       including xfstests and blackbox tests, the FSDAX function looks
> > > > > > > >      good now.  So I think the experimental warning could be dropped.
> > > > > > > 
> > > > > > > Darrick/Dave, Could you please review the above patch and let us know if you
> > > > > > > have any objections?
> > > > > > 
> > > > > > The first two patches are ok.  The third one ... well I was about to say
> > > > > > ok but then this happened with generic/269 on a 6.6-rc4 kernel and those
> > > > > > two patches applied:
> > > > > 
> > > > > Hi Darrick,
> > > > > 
> > > > > Thanks for testing.  I just tested this case (generic/269) on v6.6-rc4 with
> > > > > my 3 patches again, but it didn't fail.  Such WARNING message didn't show in
> > > > > dmesg too.
> > > > > 
> > > > > My local.config is shown as below:
> > > > > [nodax_reflink]
> > > > > export FSTYP=xfs
> > > > > export TEST_DEV=/dev/pmem0
> > > > > export TEST_DIR=/mnt/test
> > > > > export SCRATCH_DEV=/dev/pmem1
> > > > > export SCRATCH_MNT=/mnt/scratch
> > > > > export MKFS_OPTIONS="-m reflink=1,rmapbt=1"
> > > > > 
> > > > > [dax_reflink]
> > > > > export FSTYP=xfs
> > > > > export TEST_DEV=/dev/pmem0
> > > > > export TEST_DIR=/mnt/test
> > > > > export SCRATCH_DEV=/dev/pmem1
> > > > > export SCRATCH_MNT=/mnt/scratch
> > > > > export MKFS_OPTIONS="-m reflink=1,rmapbt=1"
> > > > > export MOUNT_OPTIONS="-o dax"
> > > > > export TEST_FS_MOUNT_OPTS="-o dax"
> > > > > 
> > > > > And tools version are:
> > > > >    - xfstests (v2023.09.03)
> > > > 
> > > > Same here.
> > > > 
> > > > >    - xfsprogs (v6.4.0)
> > > > 
> > > > I have a newer branch, though it only contains resyncs with newer kernel
> > > > versions and bugfixes.
> > > > 
> > > > > Could you show me more info (such as kernel config, local.config) ?  So that
> > > > > I can find out what exactly is going wrong.
> > > > 
> > > > The full xml output from fstests is here:
> > > > 
> > > > https://djwong.org/fstests/output/.fa9f295c6a2dd4426aa26b4d74e8e0299ad2307507547d5444c157f0e883df92/.2e718425eda716ad848ae05dfab82a670af351f314e26b3cb658a929331bf2eb/result.xml
> > > > 
> > > > I think the key difference between your setup and mine is that
> > > > MKFS_OPTIONS includes '-d daxinherit=1' and MOUNT_OPTIONS do not include
> > > > -o dax.  That shouldn't make any difference, though.
> 
> A little strange thing I found:
> According to the result.xml, the MKFS_OPTIONS didn't include -m rmapbt=1:
>     <property name="MKFS_OPTIONS" value=" -d daxinherit=1,"/>
> mkfs.xfs will turn on reflink by default, but won't turn on rmapbt. Then
> xfs/55[0-2] should be "not run" because they have
> _require_xfs_scratch_rmapbt.

Oh.  Yeah.  mkfs is from the xfsprogs for-next branch, with 6.6 kernel
libxfs stuff backported, as well as the defaults changed to turn on
rmapbt by default.  Sorry about that omission.

> Also, this alert message didn't show in my tests:
> [ 6047.876110] XFS (pmem1): xlog_verify_grant_tail: space >
> BBTOB(tail_blocks)
> But I don't think it is related.

Probably not.  FWIW the simulated pmem is a ~9.8GB tmpfs file that's
passed through to qemu via the libvirt xml stuff that sets up pmem.
If your pmem is larger (or real pmem!) then you likely get a bigger log
and hence lower chance of that message.

> > > > 
> > > > Also: In the weeks leading up to me adding the PREREMOVE patches a
> > > > couple of days ago, no test (generic/269 or otherwise) hit that ASSERT.
> 
> Has it failed again since this time?  If so, please sent me the result.xml
> because it is needed for analyze.  Thank you~

Nope.  Last night's run was clean.

> > > > I'm wondering if that means that the preremove code isn't shooting down
> > > > a page mapping or something?
> > > > 
> > > > Grepping through the result.xml reveals:
> > > > 
> > > > $ grep -E '(generic.269|xfs.55[012])' /tmp/result.xml
> > > > 563:    <testcase classname="xfstests.global" name="xfs/550" time="2">
> > > > 910:    <testcase classname="xfstests.global" name="xfs/552" time="2">
> > > > 1685:   <testcase classname="xfstests.global" name="generic/269" time="23">
> > > > 1686:           <failure message="_check_dmesg: something found in dmesg (see /var/tmp/fstests/generic/269.dmesg)" type="TestFail"/>
> > > > 1689:[ 6046.844058] run fstests generic/269 at 2023-10-04 15:26:57
> > > > 2977:   <testcase classname="xfstests.global" name="xfs/551" time="2">
> > > > 
> > > > So it's possible that 550 or 552 messed this up for us. :/
> > > > 
> > > > See attached kconfig.
> > > 
> > > Thanks for the info.  I tried to make my environment same as yours, but
> > > still couldn't reproduce the fail.  I also let xfs/550 & xfs/552 ran before
> > > generic/269.
> > > 
> > > [root@f38 xfst]# ./check -s nodax_reflink -r xfs/550 xfs/552 generic/269
> > > SECTION       -- nodax_reflink
> > > FSTYP         -- xfs (debug)
> > > PLATFORM      -- Linux/x86_64 f38 6.6.0-rc4 #365 SMP PREEMPT_DYNAMIC Sun Oct
> > > 8 15:19:36 CST 2023
> > > MKFS_OPTIONS  -- -f -m reflink=1,rmapbt=1 -d daxinherit=1 /dev/pmem1
> > > MOUNT_OPTIONS -- -o usrquota,grpquota,prjquota, /dev/pmem1 /mnt/scratch
> > > 
> > > xfs/550 2s ...  2s
> > > xfs/552 2s ...  1s
> > > generic/269 22s ...  23s
> > > Ran: xfs/550 xfs/552 generic/269
> > > Passed all 3 tests
> > > 
> > > SECTION       -- nodax_reflink
> > > =========================
> > > Ran: xfs/550 xfs/552 generic/269
> > > Passed all 3 tests
> > > 
> > > 
> > > And xfs/269 is testing fsstress & dd on a scratch device at the same time.
> > > It won't reach the PREREMOVE code or xfs' notify failure code.

Hmm.  I'm theorizing that generic/269 was merely tripping over some
pmem page that has corrupted state.

> > > I'd like to know what your git tree looks like, is it *v6.6-rc4 + my patches
> > > only* ?  Does it contain other patches?
> > 
> > No other patches, aside from turning on selected W=123e warnings.
> 
> I don't know what does this mean: "selected W=123e warnings".  How could I
> turn on this config?

$ make vmlinux W=123e

You probably don't want the 'e' part since that'll fail the build on
any warning.  The actual warnings turned on by levels 1-3 vary depending
on the compiler (gcc 12.3.0 here).

--D

> 
> 
> --
> Thanks,
> Ruan.
> 
> > 
> > --D
> > 
> > > 
> > > --
> > > Thanks,
> > > Ruan.
> > > 
> > > > 
> > > > --D
> > > > 
> > > > > 
> > > > > 
> > > > > --
> > > > > Thanks,
> > > > > Ruan.

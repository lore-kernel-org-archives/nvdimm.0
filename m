Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F3E7F
	for <nvdimm@lists.linux.dev>; Thu,  5 Oct 2023 00:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioQMsZw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 381AEC433C8;
	Thu,  5 Oct 2023 00:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696464490;
	bh=e+4RYPMgihWsBZFcXfd9IJHbJF2Pxbx7+pZejyHBjFk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ioQMsZw3/csulno6jSmNXyDoGQtG94bWucy3F/jLfOb1Gn9U7fih/sGl/Ch39P+Ub
	 bpa1Y8RRF7im716D3BOcKrepxrqN3nXFpTwedwvUCuwZTToZqSXvJlxMLbnDmPkRiO
	 uZXVeQkvV5B0cPmiusoFUSZkkCFnZgT3+bGgmYDf/UXu4Vf2Q7Fh4KnjshPWhsV0VY
	 bZKcsF9lLlfkbCZ+C8VBbbMHvir8UNftSeanhvInlG8/eByyiulvQkzgJprk0VJOZe
	 PA8c6Vs+qLIK5RM959aED4R5NV87+411YxnNbOG3jMOEsOzOLwbJymze9X6FLbo5Gd
	 CHU9Eh+C1QTVQ==
Date: Wed, 4 Oct 2023 17:08:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Chandan Babu R <chandanbabu@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Shiyang Ruan <ruansy.fnst@fujitsu.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH] xfs: drop experimental warning for FSDAX
Message-ID: <20231005000809.GN21298@frogsfrogsfrogs>
References: <bc29af15-ae63-407d-8ca0-186c976acce7@fujitsu.com>
 <87y1gs83yq.fsf@debian-BULLSEYE-live-builder-AMD64>
 <20230927083034.90bd6336229dd00af601e0ef@linux-foundation.org>
 <9c3cbc0c-7135-4006-ad4a-2abce0a556b0@fujitsu.com>
 <20230928092052.9775e59262c102dc382513ef@linux-foundation.org>
 <20230928171339.GJ11439@frogsfrogsfrogs>
 <99279735-2d17-405f-bade-9501a296d817@fujitsu.com>
 <651718a6a6e2c_c558e2943e@dwillia2-xfh.jf.intel.com.notmuch>
 <ec2de0b9-c07d-468a-bd15-49e83cba1ad9@fujitsu.com>
 <87y1gltcvg.fsf@debian-BULLSEYE-live-builder-AMD64>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87y1gltcvg.fsf@debian-BULLSEYE-live-builder-AMD64>

On Mon, Oct 02, 2023 at 06:09:56PM +0530, Chandan Babu R wrote:
> On Mon, Oct 02, 2023 at 08:15:57 PM +0800, Shiyang Ruan wrote:
> > 在 2023/9/30 2:34, Dan Williams 写道:
> >> Shiyang Ruan wrote:
> >>>
> >>>
> >>> 在 2023/9/29 1:13, Darrick J. Wong 写道:
> >>>> On Thu, Sep 28, 2023 at 09:20:52AM -0700, Andrew Morton wrote:
> >>>>> On Thu, 28 Sep 2023 16:44:00 +0800 Shiyang Ruan <ruansy.fnst@fujitsu.com> wrote:
> >>>>>
> >>>>>> But please pick the following patch[1] as well, which fixes failures of
> >>>>>> xfs55[0-2] cases.
> >>>>>>
> >>>>>> [1]
> >>>>>> https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com
> >>>>>
> >>>>> I guess I can take that xfs patch, as it fixes a DAX patch.  I hope the xfs team
> >>>>> are watching.
> >>>>>
> >>>>> But
> >>>>>
> >>>>> a) I'm not subscribed to linux-xfs and
> >>>>>
> >>>>> b) the changelog fails to describe the userspace-visible effects of
> >>>>>      the bug, so I (and others) are unable to determine which kernel
> >>>>>      versions should be patched.
> >>>>>
> >>>>> Please update that changelog and resend?
> >>>>
> >>>> That's a purely xfs patch anyways.  The correct maintainer is Chandan,
> >>>> not Andrew.
> >>>>
> >>>> /me notes that post-reorg, patch authors need to ask the release manager
> >>>> (Chandan) directly to merge their patches after they've gone through
> >>>> review.  Pull requests of signed tags are encouraged strongly.
> >>>>
> >>>> Shiyang, could you please send Chandan pull requests with /all/ the
> >>>> relevant pmem patches incorporated?  I think that's one PR for the
> >>>> "xfs: correct calculation for agend and blockcount" for 6.6; and a
> >>>> second PR with all the non-bugfix stuff (PRE_REMOVE and whatnot) for
> >>>> 6.7.
> >>>
> >>> OK.  Though I don't know how to send the PR by email, I have sent a list
> >>> of the patches and added description for each one.
> >> If you want I can create a signed pull request from a git.kernel.org
> >> tree.
> >> Where is that list of patches? I see v15 of preremove.
> >
> > Sorry, I sent the list below to Chandan, didn't cc the maillist
> > because it's just a rough list rather than a PR:
> >
> >
> > 1. subject: [v3]  xfs: correct calculation for agend and blockcount
> >    url:
> >    https://lore.kernel.org/linux-xfs/20230913102942.601271-1-ruansy.fnst@fujitsu.com/
> >    note:    This one is a fix patch for commit: 5cf32f63b0f4 ("xfs:
> >    fix the calculation for "end" and "length"").
> >             It can solve the fail of xfs/55[0-2]: the programs
> >             accessing the DAX file may not be notified as expected,
> >            because the length always 1 block less than actual.  Then
> >           this patch fixes this.
> >
> >
> > 2. subject: [v15] mm, pmem, xfs: Introduce MF_MEM_PRE_REMOVE for unbind
> >    url:
> >    https://lore.kernel.org/linux-xfs/20230928103227.250550-1-ruansy.fnst@fujitsu.com/T/#u
> >    note:    This is a feature patch.  It handles the pre-remove event
> >    of DAX device, by notifying kernel/user space before actually
> >   removing.
> >             It has been picked by Andrew in his
> >             mm-hotfixes-unstable. I am not sure whether you or he will
> >            merge this one.
> >
> >
> > 3. subject: [v1]  xfs: drop experimental warning for FSDAX
> >    url:
> >    https://lore.kernel.org/linux-xfs/20230915063854.1784918-1-ruansy.fnst@fujitsu.com/
> >    note:    With the patches mentioned above, I did a lot of tests,
> >    including xfstests and blackbox tests, the FSDAX function looks
> >   good now.  So I think the experimental warning could be dropped.
> 
> Darrick/Dave, Could you please review the above patch and let us know if you
> have any objections?

The first two patches are ok.  The third one ... well I was about to say
ok but then this happened with generic/269 on a 6.6-rc4 kernel and those
two patches applied:

[ 6046.844058] run fstests generic/269 at 2023-10-04 15:26:57
[ 6047.479351] XFS (pmem0): Mounting V5 Filesystem e9b327cb-ea4d-4cf8-8310-f7a2922ec934
[ 6047.487228] XFS (pmem0): Ending clean mount
[ 6047.663228] XFS (pmem1): Mounting V5 Filesystem 3c882433-356a-48d2-9670-65f09ab9da7e
[ 6047.669433] XFS (pmem1): Ending clean mount
[ 6047.671261] XFS (pmem1): Quotacheck needed: Please wait.
[ 6047.673825] XFS (pmem1): Quotacheck: Done.
[ 6047.876110] XFS (pmem1): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
[ 6054.851738] ------------[ cut here ]------------
[ 6054.852580] WARNING: CPU: 1 PID: 2221403 at fs/dax.c:372 dax_insert_entry+0x2b8/0x2f0
[ 6054.853924] Modules linked in: dm_snapshot dm_bufio dm_zero xfs btrfs blake2b_generic xor lzo_compress lzo_decompress zlib_deflate raid6_pq zstd_compress ext2 nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set nft_compat ip_set_hash_mac bfq ip_set nf_tables libcrc32c nfnetlink pvpanic_mmio nd_pmem pvpanic nd_btt dax_pmem sch_fq_codel fuse configfs ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
[ 6054.864248] CPU: 1 PID: 2221403 Comm: fsstress Tainted: G        W          6.6.0-rc4-djwx #rc4 68f7123368bf2829d3bd2005887c1dd86a2c541a
[ 6054.866092] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[ 6054.867358] RIP: 0010:dax_insert_entry+0x2b8/0x2f0
[ 6054.868137] Code: e0 48 83 c4 20 5b 5d 41 5c 41 5d 41 5e 41 5f c3 48 8b 58 20 48 8d 7b 01 e9 58 ff ff ff 48 8b 58 20 48 8d 7b 01 e9 43 ff ff ff <0f> 0b e9 64 ff ff ff 31 f6 48 89 ef e8 67 50 4a 00 eb 99 48 81 e6
[ 6054.870854] RSP: 0000:ffffc9000659bb18 EFLAGS: 00010082
[ 6054.871648] RAX: ffffea000e5aa8c0 RBX: 0000000000000001 RCX: ffffea000e5aa900
[ 6054.872770] RDX: ffff88801d100d20 RSI: 000000000000015f RDI: ffff888032b5f0b8
[ 6054.874007] RBP: ffffc9000659bc00 R08: 0000000000000000 R09: 0000000000000000
[ 6054.875249] R10: ffff88801d08c920 R11: 0000000000000001 R12: 0000000000000011
[ 6054.876484] R13: ffff88801d08c920 R14: ffffc9000659be00 R15: 0000000000000000
[ 6054.877768] FS:  00007efcfc356740(0000) GS:ffff88803ed00000(0000) knlGS:0000000000000000
[ 6054.879209] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6054.881903] CR2: 00007efcfc34d000 CR3: 000000000ba0d002 CR4: 00000000001706e0
[ 6054.883120] Call Trace:
[ 6054.883638]  <TASK>
[ 6054.884128]  ? dax_insert_entry+0x2b8/0x2f0
[ 6054.884912]  ? __warn+0x7d/0x130
[ 6054.885550]  ? dax_insert_entry+0x2b8/0x2f0
[ 6054.886348]  ? report_bug+0x189/0x1c0
[ 6054.887058]  ? handle_bug+0x3c/0x60
[ 6054.887733]  ? exc_invalid_op+0x13/0x60
[ 6054.888469]  ? asm_exc_invalid_op+0x16/0x20
[ 6054.889260]  ? dax_insert_entry+0x2b8/0x2f0
[ 6054.890025]  ? dax_insert_entry+0x12c/0x2f0
[ 6054.890812]  dax_fault_iter+0x29d/0x710
[ 6054.891517]  dax_iomap_pte_fault+0x1a5/0x3e0
[ 6054.892296]  __xfs_filemap_fault+0x26a/0x2f0 [xfs 94197186ac3b5465301609afaec7e93d309e0865]
[ 6054.893936]  __do_fault+0x31/0x240
[ 6054.894623]  do_fault+0x18d/0x6f0
[ 6054.895279]  __handle_mm_fault+0x587/0xd60
[ 6054.896057]  handle_mm_fault+0x193/0x300
[ 6054.896829]  do_user_addr_fault+0x2d1/0x6a0
[ 6054.897584]  exc_page_fault+0x63/0x130
[ 6054.898350]  asm_exc_page_fault+0x22/0x30
[ 6054.899106] RIP: 0033:0x7efcfc4fa24a
[ 6054.899827] Code: c5 fe 7f 07 c5 fe 7f 47 20 c5 fe 7f 47 40 c5 fe 7f 47 60 c5 f8 77 c3 66 0f 1f 84 00 00 00 00 00 40 0f b6 c6 48 89 d1 48 89 fa <f3> aa 48 89 d0 c5 f8 77 c3 66 66 2e 0f 1f 84 00 00 00 00 00 66 90
[ 6054.902981] RSP: 002b:00007ffd99309648 EFLAGS: 00010202
[ 6054.903930] RAX: 00000000000000bd RBX: 000000000015e000 RCX: 0000000000008cad
[ 6054.905157] RDX: 00007efcfc34c000 RSI: 00000000000000bd RDI: 00007efcfc34d000
[ 6054.906405] RBP: 000000001dcd6500 R08: 0000000000000000 R09: 000000000015e000
[ 6054.907643] R10: 0000000000000008 R11: 0000000000000246 R12: 0000563889c81280
[ 6054.908919] R13: 028f5c28f5c28f5c R14: 0000000000009cad R15: 0000563889c78790
[ 6054.910092]  </TASK>
[ 6054.912372] ---[ end trace 0000000000000000 ]---
[ 6068.755372] ------------[ cut here ]------------
[ 6068.757860] WARNING: CPU: 3 PID: 2221631 at fs/dax.c:396 dax_disassociate_entry+0x4e/0xb0
[ 6068.761773] Modules linked in: dm_snapshot dm_bufio dm_zero xfs btrfs blake2b_generic xor lzo_compress lzo_decompress zlib_deflate raid6_pq zstd_compress ext2 nft_chain_nat xt_REDIRECT nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip6t_REJECT nf_reject_ipv6 ipt_REJECT nf_reject_ipv4 xt_tcpudp ip_set_hash_ip ip_set_hash_net xt_set nft_compat ip_set_hash_mac bfq ip_set nf_tables libcrc32c nfnetlink pvpanic_mmio nd_pmem pvpanic nd_btt dax_pmem sch_fq_codel fuse configfs ip_tables x_tables overlay nfsv4 af_packet [last unloaded: xfs]
[ 6068.784925] CPU: 3 PID: 2221631 Comm: umount Tainted: G        W          6.6.0-rc4-djwx #rc4 68f7123368bf2829d3bd2005887c1dd86a2c541a
[ 6068.788837] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[ 6068.791451] RIP: 0010:dax_disassociate_entry+0x4e/0xb0
[ 6068.793121] Code: ba 00 00 00 00 00 ea ff ff 48 c1 e0 06 48 8d 9e 00 02 00 00 48 01 d0 48 89 f2 4c 8d 5e 01 eb 24 49 39 ca 74 07 48 85 c9 74 02 <0f> 0b 48 c7 40 18 00 00 00 00 48 c7 40 20 00 00 00 00 48 83 c2 01
[ 6068.798256] RSP: 0018:ffffc9000ac4fb60 EFLAGS: 00010082
[ 6068.799729] RAX: ffffea000e5aa8c0 RBX: 0000000000396ca3 RCX: ffff88801d08c920
[ 6068.801596] RDX: 0000000000396aa3 RSI: 0000000000396aa3 RDI: 0000000000000000
[ 6068.803386] RBP: ffff88801d100d20 R08: 0000000000000001 R09: 0000000000000000
[ 6068.806999] R10: ffff88801d100d20 R11: 0000000000396aa4 R12: 0000000000000001
[ 6068.809420] R13: 0000000000000002 R14: 00000000072d5461 R15: ffffc9000ac4fca8
[ 6068.811841] FS:  00007f98572ac800(0000) GS:ffff88807e100000(0000) knlGS:0000000000000000
[ 6068.814630] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 6068.816056] CR2: 00007fe472696000 CR3: 0000000040e92002 CR4: 00000000001706e0
[ 6068.817763] Call Trace:
[ 6068.818516]  <TASK>
[ 6068.819186]  ? dax_disassociate_entry+0x4e/0xb0
[ 6068.820356]  ? __warn+0x7d/0x130
[ 6068.821266]  ? dax_disassociate_entry+0x4e/0xb0
[ 6068.822452]  ? report_bug+0x189/0x1c0
[ 6068.823449]  ? handle_bug+0x3c/0x60
[ 6068.824403]  ? exc_invalid_op+0x13/0x60
[ 6068.825418]  ? asm_exc_invalid_op+0x16/0x20
[ 6068.826463]  ? dax_disassociate_entry+0x4e/0xb0
[ 6068.827574]  __dax_invalidate_entry+0x94/0x140
[ 6068.828632]  dax_delete_mapping_entry+0xf/0x20
[ 6068.829683]  truncate_folio_batch_exceptionals.part.0+0x206/0x270
[ 6068.831037]  truncate_inode_pages_range+0xf6/0x680
[ 6068.832148]  ? xfs_bmapi_read+0x1c8/0x460 [xfs 94197186ac3b5465301609afaec7e93d309e0865]
[ 6068.834281]  evict+0x1ad/0x1c0
[ 6068.835042]  dispose_list+0x48/0x70
[ 6068.837561]  evict_inodes+0x167/0x1c0
[ 6068.838731]  generic_shutdown_super+0x37/0x100
[ 6068.840095]  kill_block_super+0x16/0x40
[ 6068.841307]  xfs_kill_sb+0xe/0x20 [xfs 94197186ac3b5465301609afaec7e93d309e0865]
[ 6068.843723]  deactivate_locked_super+0x29/0xa0
[ 6068.844685]  cleanup_mnt+0xbd/0x150
[ 6068.845479]  task_work_run+0x56/0x90
[ 6068.846281]  exit_to_user_mode_prepare+0xf5/0x100
[ 6068.847290]  syscall_exit_to_user_mode+0x1d/0x40
[ 6068.848285]  do_syscall_64+0x40/0x80
[ 6068.849091]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[ 6068.850144] RIP: 0033:0x7f98574d0c2b
[ 6068.850958] Code: 0b 32 0f 00 f7 d8 64 89 01 48 83 c8 ff c3 90 f3 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 d1 31 0f 00 f7 d8
[ 6068.854524] RSP: 002b:00007fffde7b3678 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
[ 6068.856034] RAX: 0000000000000000 RBX: 0000555a6bcdcf20 RCX: 00007f98574d0c2b
[ 6068.857374] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000555a6bcea090
[ 6068.858701] RBP: 0000555a6bcdccf0 R08: 0000000000000000 R09: 0000555a6bce9a90
[ 6068.859998] R10: 00007f98575c5010 R11: 0000000000000246 R12: 0000000000000000
[ 6068.861296] R13: 0000555a6bcea090 R14: 0000555a6bcdce00 R15: 0000555a6bcdccf0
[ 6068.862572]  </TASK>
[ 6068.863066] ---[ end trace 0000000000000000 ]---
[ 6068.885696] XFS (pmem1): Unmounting Filesystem 3c882433-356a-48d2-9670-65f09ab9da7e
[ 6069.019027] XFS (pmem0): Unmounting Filesystem e9b327cb-ea4d-4cf8-8310-f7a2922ec934

--D

> -- 
> Chandan

Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E79A33A713
	for <nvdimm@lists.linux.dev>; Fri, 10 Apr 2026 18:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775846333; cv=none; b=sIU+aVgzaSDAyNfIGQnnCIw8AKGSxblRPVBk7c4DWo90vkIJZnEjGx0Wz9hMMoZuSMDe5Xe38hrbyCez4zHMcAhcLfs7Oa6D6Azul2z2vnx5HsBB/Nk5CgRM2fQXfB6EBKiTTcClBKMe764hW6OJcsVSnwMgLtz2bJo6td0++Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775846333; c=relaxed/simple;
	bh=pqJn72Znc1C4P/7l9PYEOENTHaseCzvr4mTs1LcvhLE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OG79XAvZ16/bLQWRWyQaXc5leAm7ATBKQq3ObPIxGYOInj1tG3wIvMlEXDGk4m2BX9Gpg2U87M9ZWrwFO/cAlviy2f942oOa4454eL9IAAKCKku+ip0M/42lGHIIiFnixjj4olTDaSkK5wBHsNbLQHS8XnWgj+TjqIsaGwxWaQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06194E32B7;
	Fri, 10 Apr 2026 18:38:38 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf14.hostedemail.com (Postfix) with ESMTPA id 084232D;
	Fri, 10 Apr 2026 18:38:27 +0000 (UTC)
Date: Fri, 10 Apr 2026 13:38:26 -0500
From: John Groves <John@groves.net>
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Joanne Koong <joannelkoong@gmail.com>, 
	John Groves <john@jagalactic.com>, Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, 
	"venkataravis@micron.com" <venkataravis@micron.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	djbw@kernel.org
Subject: Re: [PATCH V10 00/10] famfs: port into fuse
Message-ID: <adlBcwJjLOQDAR65@groves.net>
References: <20260331123702.35052-1-john@jagalactic.com>
 <0100019d43e5f632-f5862a3e-361c-4b54-a9a6-96c242a8f17a-000000@email.amazonses.com>
 <CAJnrk1ZRTGWjNzkMxS3UkeZMmrpadJDtWKontMx2=d-smXYq=w@mail.gmail.com>
 <adkDq0m5Wt9YhJ8A@groves.net>
 <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <38744253-efa3-41c5-a491-b177a4a4c835@bsbernd.com>
X-Stat-Signature: sncacz3wyo319nit7qgoqo1fd9kfx5pu
X-Rspamd-Server: rspamout04
X-Rspamd-Queue-Id: 084232D
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX19KM57QPgT7EDl9aA/ygQ/9tbSZtH0EMu4=
X-HE-Tag: 1775846307-3906
X-HE-Meta: U2FsdGVkX19yU+88sW7NtlzLP65s1bZY4ABRPQc5pHhrul3urc5Oixe56BSFGZqyYxvb5FXoUKymq0NpnKuNZNpqrM+0yqC96xkVKQU3y5Z39iTkpv0menhSJv4ojqPngVoW//S2X+nSqzqG/FSuHPjgB3re8lr525XVWU24g0cf/bhjDQ6saEtAr9XymThevVJiNmITdAi6Lq5X38J1oT4/z2LraU/RXeUvL7x+HvxR4116IGGpYP2pPhZhJG0neMqPJje4FJWJyH+bOu3EWvloPQHr7OPJif0vX5Jji+sfMHcgWfP8gUOT22R5ky3dAwe6xs84un7raQSJlNzCh8NNmG3oePs6RZFGevV+YNOhZRnLHYwns3h28E31j8Mu/N8dbE0wPxmvU/bYH2zorZlZS3oSxeQv8S5VzOykW0/9EQfPdYYboxzbpE9qXVNQQ5OsfQe0g2lUfxz4nbN8iXs0gJMngNjCRbBCijC2zagx6lmmHs1G3NluVS0UrYs3Ezr2YLzr9tdVvDKatzKL/9MVDeg1JyuL1JXk7yd57I5IzcTS6wuOlqLuEcTejfKRfXVJ3EZ8que/B51eiHETknkXYW764s+1VLAB06ZlZp+vXkq02cIaR8DCHsMzCUzG

On 26/04/10 05:24PM, Bernd Schubert wrote:
> 
> 
> On 4/10/26 16:46, John Groves wrote:
> > On 26/04/06 10:43AM, Joanne Koong wrote:
> >> On Tue, Mar 31, 2026 at 5:37 AM John Groves <john@jagalactic.com> wrote:
> >>>
> >>> From: John Groves <john@groves.net>
> >>>
> >>> NOTE: this series depends on the famfs dax series in Ira's for-7.1/dax-famfs
> >>> branch [0]
> >>>
> >>> Changes v9 -> v10
> >>> - Rebased to Ira's for-7.1/dax-famfs branch [0], which contains the required
> >>>   dax patches
> >>> - Add parentheses to FUSE_IS_VIRTIO_DAX() macro, in case something bad is
> >>>   passed in as fuse_inode (thanks Jonathan's AI)
> >>>
> >>> Description:
> >>>
> >>> This patch series introduces famfs into the fuse file system framework.
> >>> Famfs depends on the bundled dax patch set.
> >>>
> >>> The famfs user space code can be found at [1].
> >>>
> >>> Fuse Overview:
> >>>
> >>> Famfs started as a standalone file system, but this series is intended to
> >>> permanently supersede that implementation. At a high level, famfs adds
> >>> two new fuse server messages:
> >>>
> >>> GET_FMAP   - Retrieves a famfs fmap (the file-to-dax map for a famfs
> >>>              file)
> >>> GET_DAXDEV - Retrieves the details of a particular daxdev that was
> >>>              referenced by an fmap
> >>>
> >>> Famfs Overview
> >>>
> >>> Famfs exposes shared memory as a file system. Famfs consumes shared
> >>> memory from dax devices, and provides memory-mappable files that map
> >>> directly to the memory - no page cache involvement. Famfs differs from
> >>> conventional file systems in fs-dax mode, in that it handles in-memory
> >>> metadata in a sharable way (which begins with never caching dirty shared
> >>> metadata).
> >>>
> >>> Famfs started as a standalone file system [2,3], but the consensus at
> >>> LSFMM was that it should be ported into fuse [4,5].
> >>>
> >>> The key performance requirement is that famfs must resolve mapping faults
> >>> without upcalls. This is achieved by fully caching the file-to-devdax
> >>> metadata for all active files. This is done via two fuse client/server
> >>> message/response pairs: GET_FMAP and GET_DAXDEV.
> >>>
> >>> Famfs remains the first fs-dax file system that is backed by devdax
> >>> rather than pmem in fs-dax mode (hence the need for the new dax mode).
> >>>
> >>> Notes
> >>>
> >>> - When a file is opened in a famfs mount, the OPEN is followed by a
> >>>   GET_FMAP message and response. The "fmap" is the full file-to-dax
> >>>   mapping, allowing the fuse/famfs kernel code to handle
> >>>   read/write/fault without any upcalls.
> >>>
> >>> - After each GET_FMAP, the fmap is checked for extents that reference
> >>>   previously-unknown daxdevs. Each such occurrence is handled with a
> >>>   GET_DAXDEV message and response.
> >>>
> >>> - Daxdevs are stored in a table (which might become an xarray at some
> >>>   point). When entries are added to the table, we acquire exclusive
> >>>   access to the daxdev via the fs_dax_get() call (modeled after how
> >>>   fs-dax handles this with pmem devices). Famfs provides
> >>>   holder_operations to devdax, providing a notification path in the
> >>>   event of memory errors or forced reconfiguration.
> >>>
> >>> - If devdax notifies famfs of memory errors on a dax device, famfs
> >>>   currently blocks all subsequent accesses to data on that device. The
> >>>   recovery is to re-initialize the memory and file system. Famfs is
> >>>   memory, not storage...
> >>>
> >>> - Because famfs uses backing (devdax) devices, only privileged mounts are
> >>>   supported (i.e. the fuse server requires CAP_SYS_RAWIO).
> >>>
> >>> - The famfs kernel code never accesses the memory directly - it only
> >>>   facilitates read, write and mmap on behalf of user processes, using
> >>>   fmap metadata provided by its privileged fuse server. As such, the
> >>>   RAS of the shared memory affects applications, but not the kernel.
> >>>
> >>> - Famfs has backing device(s), but they are devdax (char) rather than
> >>>   block. Right now there is no way to tell the vfs layer that famfs has a
> >>>   char backing device (unless we say it's block, but it's not). Currently
> >>>   we use the standard anonymous fuse fs_type - but I'm not sure that's
> >>>   ultimately optimal (thoughts?)
> >>>
> >>> Changes v8 -> v9
> >>> - Kconfig: fs/fuse/Kconfig:CONFIG_FUSE_FAMFS_DAX now depends on the
> >>>   new CONFIG_DEV_DAX_FSDEV (from drivers/dax/Kconfig) rather than
> >>>   just CONFIG_DEV_DAX and CONFIG_FS_DAX. (CONFIG_FUSE_FAMFS_DAX
> >>>   depends on those...)
> >>>
> >>> Changes v7 -> v8
> >>> - Moved to inline __free declaration in fuse_get_fmap() and
> >>>   famfs_fuse_meta_alloc(), famfs_teardown()
> >>> - Adopted FIELD_PREP() macro rather than manual bitfield manipulation
> >>> - Minor doc edits
> >>> - I dropped adding magic numbers to include/uapi/linux/magic.h. That
> >>>   can be done later if appropriate
> >>>
> >>> Changes v6 -> v7
> >>> - Fixed a regression in famfs_interleave_fileofs_to_daxofs() that
> >>>   was reported by Intel's kernel test robot
> >>> - Added a check in __fsdev_dax_direct_access() for negative return
> >>>   from pgoff_to_phys(), which would indicate an out-of-range offset
> >>> - Fixed a bug in __famfs_meta_free(), where not all interleaved
> >>>   extents were freed
> >>> - Added chunksize alignment checks in famfs_fuse_meta_alloc() and
> >>>   famfs_interleave_fileofs_to_daxofs() as interleaved chunks must
> >>>   be PTE or PMD aligned
> >>> - Simplified famfs_file_init_dax() a bit
> >>> - Re-ran CM's kernel code review prompts on the entire series and
> >>>   fixed several minor issues
> >>>
> >>> Changes v4 -> v5 -> v6
> >>> - None. Re-sending due to technical difficulties
> >>>
> >>> Changes v3 [9] -> v4
> >>> - The patch "dax: prevent driver unbind while filesystem holds device"
> >>>   has been dropped. Dan Williams indicated that the favored behavior is
> >>>   for a file system to stop working if an underlying driver is unbound,
> >>>   rather than preventing the unbind.
> >>> - The patch "famfs_fuse: Famfs mount opt: -o shadow=<shadowpath>" has
> >>>   been dropped. Found a way for the famfs user space to do without the
> >>>   -o opt (via getxattr).
> >>> - Squashed the fs/fuse/Kconfig patch into the first subsequent patch
> >>>   that needed the change
> >>>   ("famfs_fuse: Basic fuse kernel ABI enablement for famfs")
> >>> - Many review comments addressed.
> >>> - Addressed minor kerneldoc infractions reported by test robot.
> >>>
> >>> Changes v2 [7] -> v3
> >>> - Dax: Completely new fsdev driver (drivers/dax/fsdev.c) replaces the
> >>>   dev_dax_iomap modifications to bus.c/device.c. Devdax devices can now
> >>>   be switched among 'devdax', 'famfs' and 'system-ram' modes via daxctl
> >>>   or sysfs.
> >>> - Dax: fsdev uses MEMORY_DEVICE_FS_DAX type and leaves folios at order-0
> >>>   (no vmemmap_shift), allowing fs-dax to manage folio lifecycles
> >>>   dynamically like pmem does.
> >>> - Dax: The "poisoned page" problem is properly fixed via
> >>>   fsdev_clear_folio_state(), which clears stale mapping/compound state
> >>>   when fsdev binds. The temporary WARN_ON_ONCE workaround in fs/dax.c
> >>>   has been removed.
> >>> - Dax: Added dax_set_ops() so fsdev can set dax_operations at bind time
> >>>   (and clear them on unbind), since the dax_device is created before we
> >>>   know which driver will bind.
> >>> - Dax: Added custom bind/unbind sysfs handlers; unbind return -EBUSY if a
> >>>   filesystem holds the device, preventing unbind while famfs is mounted.
> >>> - Fuse: Famfs mounts now require that the fuse server/daemon has
> >>>   CAP_SYS_RAWIO because they expose raw memory devices.
> >>> - Fuse: Added DAX address_space_operations with noop_dirty_folio since
> >>>   famfs is memory-backed with no writeback required.
> >>> - Rebased to latest kernels, fully compatible with Alistair Popple
> >>>   et. al's recent dax refactoring.
> >>> - Ran this series through Chris Mason's code review AI prompts to check
> >>>   for issues - several subtle problems found and fixed.
> >>> - Dropped RFC status - this version is intended to be mergeable.
> >>>
> >>> Changes v1 [8] -> v2:
> >>>
> >>> - The GET_FMAP message/response has been moved from LOOKUP to OPEN, as
> >>>   was the pretty much unanimous consensus.
> >>> - Made the response payload to GET_FMAP variable sized (patch 12)
> >>> - Dodgy kerneldoc comments cleaned up or removed.
> >>> - Fixed memory leak of fc->shadow in patch 11 (thanks Joanne)
> >>> - Dropped many pr_debug and pr_notice calls
> >>>
> >>>
> >>> References
> >>>
> >>> [0] - https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/
> >>> [1] - https://famfs.org (famfs user space)
> >>> [2] - https://lore.kernel.org/linux-cxl/cover.1708709155.git.john@groves.net/
> >>> [3] - https://lore.kernel.org/linux-cxl/cover.1714409084.git.john@groves.net/
> >>> [4] - https://lwn.net/Articles/983105/ (lsfmm 2024)
> >>> [5] - https://lwn.net/Articles/1020170/ (lsfmm 2025)
> >>> [6] - https://lore.kernel.org/linux-cxl/cover.8068ad144a7eea4a813670301f4d2a86a8e68ec4.1740713401.git-series.apopple@nvidia.com/
> >>> [7] - https://lore.kernel.org/linux-fsdevel/20250703185032.46568-1-john@groves.net/ (famfs fuse v2)
> >>> [8] - https://lore.kernel.org/linux-fsdevel/20250421013346.32530-1-john@groves.net/ (famfs fuse v1)
> >>> [9] - https://lore.kernel.org/linux-fsdevel/20260107153244.64703-1-john@groves.net/T/#mb2c868801be16eca82dab239a1d201628534aea7 (famfs fuse v3)
> >>>
> >>>
> >>> John Groves (10):
> >>>   famfs_fuse: Update macro s/FUSE_IS_DAX/FUSE_IS_VIRTIO_DAX/
> >>>   famfs_fuse: Basic fuse kernel ABI enablement for famfs
> >>>   famfs_fuse: Plumb the GET_FMAP message/response
> >>>   famfs_fuse: Create files with famfs fmaps
> >>>   famfs_fuse: GET_DAXDEV message and daxdev_table
> >>>   famfs_fuse: Plumb dax iomap and fuse read/write/mmap
> >>>   famfs_fuse: Add holder_operations for dax notify_failure()
> >>>   famfs_fuse: Add DAX address_space_operations with noop_dirty_folio
> >>>   famfs_fuse: Add famfs fmap metadata documentation
> >>>   famfs_fuse: Add documentation
> >>>
> >>>  Documentation/filesystems/famfs.rst |  142 ++++
> >>>  Documentation/filesystems/index.rst |    1 +
> >>>  MAINTAINERS                         |   10 +
> >>>  fs/fuse/Kconfig                     |   13 +
> >>>  fs/fuse/Makefile                    |    1 +
> >>>  fs/fuse/dir.c                       |    2 +-
> >>>  fs/fuse/famfs.c                     | 1180 +++++++++++++++++++++++++++
> >>>  fs/fuse/famfs_kfmap.h               |  167 ++++
> >>>  fs/fuse/file.c                      |   45 +-
> >>>  fs/fuse/fuse_i.h                    |  116 ++-
> >>>  fs/fuse/inode.c                     |   35 +-
> >>>  fs/fuse/iomode.c                    |    2 +-
> >>>  fs/namei.c                          |    1 +
> >>>  include/uapi/linux/fuse.h           |   88 ++
> >>>  14 files changed, 1790 insertions(+), 13 deletions(-)
> >>>  create mode 100644 Documentation/filesystems/famfs.rst
> >>>  create mode 100644 fs/fuse/famfs.c
> >>>  create mode 100644 fs/fuse/famfs_kfmap.h
> >>>
> >>>
> >>> base-commit: 2ae624d5a555d47a735fb3f4d850402859a4db77
> >>> --
> >>> 2.53.0
> >>>
> >>
> >> Hi John,
> >>
> >> I’m curious to hear your thoughts on whether you think it makes sense
> >> for the famfs-specific logic in this series to be moved to a bpf
> >> program that goes through a generic fuse iomap dax layer.
> >>
> >> Based on [1], this gives feature-parity with the famfs logic in this
> >> series. In my opinion, having famfs go through a generic fuse iomap
> >> dax layer makes the fuse kernel code more extensible for future
> >> servers that will also want to use dax iomap, and keeps the fuse code
> >> cleaner by not having famfs-specific logic hardcoded in and having to
> >> introduce new fuse uapis for something famfs-specific. In my
> >> understanding of it, fuse is meant to be generic and it feels like
> >> adding server-specific logic goes against that design philosophy and
> >> sets a precedent for other servers wanting similar special-casing in
> >> the future. I'd like to explore whether the bpf and generic fuse iomap
> >> dax layer approach can preserve that philosophy while still giving
> >> famfs the flexibility it needs.
> >>
> >> I think moving the famfs logic to bpf benefits famfs as well:
> >> - Instead of needing to issue a FUSE_GET_FMAP request after a file is
> >> opened, the server can directly populate the metadata map from
> >> userspace with the mapping info when it processes the FUSE_OPEN
> >> request, which gets rid of the roundtrip cost
> >> - The server can dynamically update the metadata / bpf maps during
> >> runtime from userspace if any mapping info needs to change
> >> - Future code changes / updates for famfs are all server-side and can
> >> be deployed immediately instead of needing to go through the upstream
> >> kernel mailing list process
> >> - Famfs updates / new releases can ship independently of kernel releases
> >>
> >> I'd appreciate the chance to discuss tradeoffs or if you'd rather
> >> discuss this at the fuse BoF at lsf, that sounds great too.
> >>
> >> Thanks,
> >> Joanne
> >>
> > 
> > Hi Joanne,
> > 
> > I'm definitely up for discussing it, and talking before LSFMM would be
> > good because then I'd have some time to think about before we discuss
> > at LSFMM.
> > 
> > I have not had a chance to really study this, in part since I've never even
> > written a "hello world" BPF program.
> > 
> > I'll ping off-list about times to talk.
> > 
> > However... 
> > 
> > I would object vehemently to this sort of re-write prior to going upstream, 
> > as would users and vendors who need famfs now that the memory products it 
> > enables have started to ship.
> > 
> > This work started over 3 years ago, initial patches over 2 years ago, 
> > community decision that it should go into fuse 2 years ago, first fuse 
> > patches a year ago.
> > 
> > This implementation is pretty much exactly in line with expectation-setting
> > starting two years ago. Famfs is a complicated orchestration between dax, 
> > fuse, ndctl (for daxctl), libfuse and the extensive famfs user space. Famfs 
> > has a fairly small kernel footprint, but its user space is much larger.
> > This could set it back a year if we re-write now.
> > 
> > Two things are true at once: I think this is a serious idea worth 
> > considering, and I think it's too late to make this sort of change before
> > going upstream. Products need this enablement, and quite a long process has
> > run in order to make it available in a timely fashion (which means soon 
> > now). I hope we can avoid making the perfect the enemy of the good.
> > 
> > I believe the risk of merging famfs soon is quite low, because famfs will 
> > not affect anybody who doesn't use it. I hope we can run this discussion and
> > analysis in parallel with merging the current implementation of famfs soon.
> 
> 
> Hi John,
> 
> one question, assuming most of these things can be done with eBPF, would
> you convert to eBPF after the merge?

Hi Bernd,

Stipulating that I've never even written 'hello world' with BPF, if it's 
a nicer solution with no downsides we would migrate there. I don't know
enough yet to put a time frame on it, but I'll certainly understand more
by LSFMM. Will you be there?

I'm hoping for a call with Joanne and Darrick in the next few days to get
better educated on it.

> 
> (I also need to find the time to review at least all of your libfuse
> changes, I feel guilty that still haven't done it.).
> 
> 
> Thanks,
> Bernd

The libfuse changes are pretty small now. Two new messages - GET_FMAP and 
GET_DAXDEV - plus a few more bits and bobs. If a future BPF migration took 
place, there is a chance that those message numbers could be retired and 
reused in the future.

Watch this space...

Thanks,
John


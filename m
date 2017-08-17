Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C371F21E79001
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:14:04 -0700 (PDT)
Date: Thu, 17 Aug 2017 18:08:09 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
Message-ID: <20170817160809.GA28850@quack2.suse.cz>
References: <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz>
 <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
 <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
 <20170811100327.GD7064@infradead.org>
 <CAPcyv4hgqh8tHeWDNRnJnvwDh7hiFU8+3O0VWAHFQOEvPna11Q@mail.gmail.com>
 <20170813092556.GA19019@infradead.org>
 <ccf82f19-7693-25da-eaa6-a654830ca81e@netapp.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <ccf82f19-7693-25da-eaa6-a654830ca81e@netapp.com>
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
To: Boaz Harrosh <boazh@netapp.com>
Cc: linux-xfs@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Amit Golander <amitg@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon 14-08-17 17:04:17, Boaz Harrosh wrote:
> 
> Thank you Jan, I'm patiently waiting for this MAP_SYNC flag since I asked for
> it in 2014. I'm so glad its time is finally do.
> 
> Thank you for working on this. Please CC me on future patches.
> (note the new Netapp email)
> 
> On 13/08/17 12:25, Christoph Hellwig wrote:
> > On Sat, Aug 12, 2017 at 07:44:14PM -0700, Dan Williams wrote:
> >> How about MAP_SYNC == (MAP_SHARED|MAP_PRIVATE)? On older kernels that
> >> should get -EINVAL, and on new kernels it means SYNC+SHARED.
> > 
> > Cute trick, but I'd hate to waster it just for our little flag.
> > 
> > How about:
> > 
> > #define __MAP_VALIDATE		MAP_SHARED|MAP_PRIVATE
> > #define MAP_SYNC		0x??? | __MAP_VALIDATE
> > 
> > so that we can reuse that trick for any new flag?
> > 
> 
> YES! And please create a mask for all new flags and in validation
> code if ((m_flags & __MAP_VALIDATE) == __MAP_VALIDATE) then you
> want that (m_flags & __MAP_NEWFLAGS) does not come empty, this
> way you actually preserve the old check that SHARED and PRIVATE
> do not co exist.

For now I did just a crude hack. Dan is working on new mmap syscall which
checks flags which will be cleaner...

> Few Comments on this new MAP_ flag
> 
> 0] The name at least needs to be MAP_MSYNC because only meta-data is
>     synced not the data pointed to. That is the responsibility of the app

So we actually do normal fdatasync() call so we do flush data as well. This
way we don't have to be afraid of stale data exposure or other strange
effects. So I've kept the name to be MAP_SYNC.

> 1] This flag you have named MAP_SYNC but it is very much related to
>    dax and the ability for user-mode to "flush" the data pointed by this
>    now "synced" meta data.
>    For example in ext4, this flag set on an inode that is *not* IS_DAX
>    should fail the mmap. Because there is no point of synced meta if the
>    data is actually in page-cache and we know for sure it was not yet synced,
>    And there is no way for user-mode to directly "sync" the data as well.

Yes, done.

> 2] The code should be constructed that the default check for the MAP_SYNC
>    should fail, and only Hopped in FSs are allowed.
>    (So not to modify all Implementations of file_operations->mmap() )

Agreed but for now I've skipped this as I wait for new mmap syscall and
how Dan implements flag checking there.

> 3] /dev/pmem could start serving DAX pages in mmap, if asked for MAP_MSYNC
>    (which is also an API that says "I know I need to cl_flush". See 1. )

MAP_SYNC is rather more like: I can also use clflush instead of
fdatasync(2). And this is rather important as all legacy applications are
100% safe in the new scheme.
 
> 4] Once we have this flag. And properly implemented at least in one FS
>    and optionally in /dev/pmemX we no longer have any justification for
>    /dev/daxX and it can die a slow and happy death.

This will be more complex I guess - see MAP_DIRECT proposal...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

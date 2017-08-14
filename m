Return-Path: <linux-ext4-owner@vger.kernel.org>
Subject: Re: [RFC PATCH 0/7] dax, ext4: Synchronous page faults
References: <20170727131245.28279-1-jack@suse.cz>
 <x49zibq3rb0.fsf@segfault.boston.devel.redhat.com>
 <20170727215713.GA22000@linux.intel.com>
 <CALCETrVzxrQ76BXEfo4kcRFyQmxbrMwCLE17yPyTJzz0tUs+Dg@mail.gmail.com>
 <20170728093821.GB29433@quack2.suse.cz> <20170801110241.GE6742@infradead.org>
 <20170801112603.GG4215@quack2.suse.cz>
 <CAPcyv4hdOsuA6cqRCnOZMLMXvycwZevg06xOVZz3u0kupm2Drw@mail.gmail.com>
 <20170811100327.GD7064@infradead.org>
 <CAPcyv4hgqh8tHeWDNRnJnvwDh7hiFU8+3O0VWAHFQOEvPna11Q@mail.gmail.com>
 <20170813092556.GA19019@infradead.org>
From: Boaz Harrosh <boazh@netapp.com>
Message-ID: <ccf82f19-7693-25da-eaa6-a654830ca81e@netapp.com>
Date: Mon, 14 Aug 2017 17:04:17 +0300
MIME-Version: 1.0
In-Reply-To: <20170813092556.GA19019@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-ext4-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Dan Williams <dan.j.williams@intel.com>, Jan Kara <jack@suse.cz>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Amit Golander <amitg@netapp.com>
List-ID: <linux-nvdimm@lists.01.org>


Thank you Jan, I'm patiently waiting for this MAP_SYNC flag since I asked for
it in 2014. I'm so glad its time is finally do.

Thank you for working on this. Please CC me on future patches.
(note the new Netapp email)

On 13/08/17 12:25, Christoph Hellwig wrote:
> On Sat, Aug 12, 2017 at 07:44:14PM -0700, Dan Williams wrote:
>> How about MAP_SYNC == (MAP_SHARED|MAP_PRIVATE)? On older kernels that
>> should get -EINVAL, and on new kernels it means SYNC+SHARED.
> 
> Cute trick, but I'd hate to waster it just for our little flag.
> 
> How about:
> 
> #define __MAP_VALIDATE		MAP_SHARED|MAP_PRIVATE
> #define MAP_SYNC		0x??? | __MAP_VALIDATE
> 
> so that we can reuse that trick for any new flag?
> 

YES! And please create a mask for all new flags and in validation
code if ((m_flags & __MAP_VALIDATE) == __MAP_VALIDATE) then you
want that (m_flags & __MAP_NEWFLAGS) does not come empty, this
way you actually preserve the old check that SHARED and PRIVATE
do not co exist.

Few Comments on this new MAP_ flag

0] The name at least needs to be MAP_MSYNC because only meta-data is
    synced not the data pointed to. That is the responsibility of the app

1] This flag you have named MAP_SYNC but it is very much related to
   dax and the ability for user-mode to "flush" the data pointed by this
   now "synced" meta data.
   For example in ext4, this flag set on an inode that is *not* IS_DAX
   should fail the mmap. Because there is no point of synced meta if the
   data is actually in page-cache and we know for sure it was not yet synced,
   And there is no way for user-mode to directly "sync" the data as well.

2] The code should be constructed that the default check for the MAP_SYNC
   should fail, and only Hopped in FSs are allowed.
   (So not to modify all Implementations of file_operations->mmap() )

3] /dev/pmem could start serving DAX pages in mmap, if asked for MAP_MSYNC
   (which is also an API that says "I know I need to cl_flush". See 1. )

4] Once we have this flag. And properly implemented at least in one FS
   and optionally in /dev/pmemX we no longer have any justification for
   /dev/daxX and it can die a slow and happy death.

Thanks, Cheers
Boaz

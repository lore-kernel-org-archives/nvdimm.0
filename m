From: Xiong Zhou <xzhou@redhat.com>
Subject: Re: LTP rwtest01 blocks on DAX mountpoint
Date: Tue, 3 Jan 2017 14:49:22 +0800
Message-ID: <20170103064922.o6v5dlq7pylhir36@XZHOUW.usersys.redhat.com>
References: <20161224110714.mp2mevzwkhlxm7zw@xzhoul.usersys.redhat.com>
 <20161230093352.efidonh4btdbtaze@XZHOUW.usersys.redhat.com>
 <20170102171617.GA23612@quack2.suse.cz>
 <20170102214941.GA2813@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170102214941.GA2813@linux.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>, Jan Kara <jack@suse.cz>, Xiong Zhou <xzhou@redhat.com>, linux-fsdevel@vger.kernel.org, linux-nvdimm@ml01.01.org, linux-kernel@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Mon, Jan 02, 2017 at 02:49:41PM -0700, Ross Zwisler wrote:
> On Mon, Jan 02, 2017 at 06:16:17PM +0100, Jan Kara wrote:
> > On Fri 30-12-16 17:33:53, Xiong Zhou wrote:
> > > On Sat, Dec 24, 2016 at 07:07:14PM +0800, Xiong Zhou wrote:
> > > > Hi lists,
snip
> > I was trying to reproduce this but for me rwtest01 completes just fine on
> > dax mountpoint (I've used your reproducer). So can you sample several
> > kernel stack traces to get a rough idea where the kernel is running?
> > Thanks!
> > 
> > 								Honza
> 
> I'm also unable to reproduce this issue.  I've tried with both the blamed
> commit:
> 4b4bb46 (HEAD) dax: clear dirty entry tags on cache flush
> and with v4.9-rc2.  Both pass the test in my setup.
> Perhaps the variable is the size of your PMEM partitions?
> # fdisk -l /dev/pmem0
> Disk /dev/pmem0: 16 GiB, 17179869184 bytes, 33554432 sectors
> Units: sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 4096 bytes
> I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> Disklabel type: dos
> Disk identifier: 0xfe50c900
> Device       Boot    Start      End  Sectors Size Id Type
> /dev/pmem0p1          4096 25165823 25161728  12G 83 Linux
> /dev/pmem0p2      25165824 33550335  8384512   4G 83 Linux
> 
> What does your setup look like?
> I'm using the current tip of the LTP tree:
> 8cc4165  waitid02: define _XOPEN_SOURCE 500
> Thanks,
> - Ross

Thanks all for looking into it.

Turns out the rc2 relative updates fix this issue, so does
an old issue i reported a while ago:
multi-threads libvmmalloc fork test hang
https://lists.01.org/pipermail/linux-nvdimm/2016-October/007602.html

I'm able to reproduce these issues before rc2, now it
passes on current Linus tree:
c8b4ec8 Merge tag 'fscrypt-for-stable'

Thanks,
Xiong

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

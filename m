From: Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: LTP rwtest01 blocks on DAX mountpoint
Date: Wed, 4 Jan 2017 17:48:34 +0800
Message-ID: <20170104094834.siixhljtbuniopi2@XZHOUW.usersys.redhat.com>
References: <20161224110714.mp2mevzwkhlxm7zw@xzhoul.usersys.redhat.com>
 <20161230093352.efidonh4btdbtaze@XZHOUW.usersys.redhat.com>
 <20170102171617.GA23612@quack2.suse.cz>
 <20170102214941.GA2813@linux.intel.com>
 <20170103064922.o6v5dlq7pylhir36@XZHOUW.usersys.redhat.com>
 <20170103165710.GC13904@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170103165710.GC13904-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Xiong Zhou <xzhou-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Jan 03, 2017 at 09:57:10AM -0700, Ross Zwisler wrote:
> On Tue, Jan 03, 2017 at 02:49:22PM +0800, Xiong Zhou wrote:
> > On Mon, Jan 02, 2017 at 02:49:41PM -0700, Ross Zwisler wrote:
> > > On Mon, Jan 02, 2017 at 06:16:17PM +0100, Jan Kara wrote:
> > > > On Fri 30-12-16 17:33:53, Xiong Zhou wrote:
> > > > > On Sat, Dec 24, 2016 at 07:07:14PM +0800, Xiong Zhou wrote:
> > > > > > Hi lists,
> > snip
> > > > I was trying to reproduce this but for me rwtest01 completes just fine on
> > > > dax mountpoint (I've used your reproducer). So can you sample several
> > > > kernel stack traces to get a rough idea where the kernel is running?
> > > > Thanks!
> > > > 
> > > > 								Honza
> > > 
> > > I'm also unable to reproduce this issue.  I've tried with both the blamed
> > > commit:
> > > 4b4bb46 (HEAD) dax: clear dirty entry tags on cache flush
> > > and with v4.9-rc2.  Both pass the test in my setup.
> > > Perhaps the variable is the size of your PMEM partitions?
> > > # fdisk -l /dev/pmem0
> > > Disk /dev/pmem0: 16 GiB, 17179869184 bytes, 33554432 sectors
> > > Units: sectors of 1 * 512 = 512 bytes
> > > Sector size (logical/physical): 512 bytes / 4096 bytes
> > > I/O size (minimum/optimal): 4096 bytes / 4096 bytes
> > > Disklabel type: dos
> > > Disk identifier: 0xfe50c900
> > > Device       Boot    Start      End  Sectors Size Id Type
> > > /dev/pmem0p1          4096 25165823 25161728  12G 83 Linux
> > > /dev/pmem0p2      25165824 33550335  8384512   4G 83 Linux
> > > 
> > > What does your setup look like?
> > > I'm using the current tip of the LTP tree:
> > > 8cc4165  waitid02: define _XOPEN_SOURCE 500
> > > Thanks,
> > > - Ross
> > 
> > Thanks all for looking into it.
> > 
> > Turns out the rc2 relative updates fix this issue, so does
> > an old issue i reported a while ago:
> > multi-threads libvmmalloc fork test hang
> > https://lists.01.org/pipermail/linux-nvdimm/2016-October/007602.html
> > 
> > I'm able to reproduce these issues before rc2, now it
> > passes on current Linus tree:
> > c8b4ec8 Merge tag 'fscrypt-for-stable'
> 
> Hmm...I'm able to reproduce the other libvmmalloc issue with both v4.10-rc2
> and with "c8b4ec8 Merge tag 'fscrypt-for-stable'".  I'm debugging that issue
> today.
> 
> It's interesting that both tests started passing for you.  Did you change
> something in your test setup?

Hi,

Quick update:
  Ross's new patch fixed the vmmaloc_fork issue, not the rc2 update.
  Regression tests is going on, so far so good.

I'm able to reproduce the vmmalloc_fork issue on rc2 kernel
	c8b4ec8 Merge tag 'fscrypt-for-stable'
with nvml commit to
	77c2a5a Merge pull request #1554 from krzycz/win-libvmem_rc

My previous statement about rc2 fixed old vmmalloc_fork issue
was wrong, my mistake. I have changed my test setup.

Now after some tests, Ross's patch
	[PATCH] dax: fix deadlock with DAX 4k holes
on top of Linus tree c8b4ec8 have fixed this vmmalloc_fork issue.
My DAX regression tests is going on, looks good so far. Gonna
update once it have finished.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Ross Zwisler <ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: LTP rwtest01 blocks on DAX mountpoint
Date: Mon, 2 Jan 2017 14:49:41 -0700
Message-ID: <20170102214941.GA2813@linux.intel.com>
References: <20161224110714.mp2mevzwkhlxm7zw@xzhoul.usersys.redhat.com>
 <20161230093352.efidonh4btdbtaze@XZHOUW.usersys.redhat.com>
 <20170102171617.GA23612@quack2.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170102171617.GA23612-4I4JzKEfoa/jFM9bn6wA6Q@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Mon, Jan 02, 2017 at 06:16:17PM +0100, Jan Kara wrote:
> On Fri 30-12-16 17:33:53, Xiong Zhou wrote:
> > On Sat, Dec 24, 2016 at 07:07:14PM +0800, Xiong Zhou wrote:
> > > Hi lists,
> > > 
> > > Since around 20161129 tag, LTP rwtest01 on dax mountpoint blocks
> > > on linux-next tree, now on Linus tree.
> > > 
> > > In "normal", rwtest01 subcase ends in a few minutes, now it keeps
> > > running for hours on dax mountpoint, both ext4 and xfs. Ctrl + c
> > > can interrupt it.
> > 
> > Test programme is waiting for a memcpy call to return.
> > 
> > From sysrq output, kernel code is not blocking on somewhere,
> > it just wont return.
> 
> I was trying to reproduce this but for me rwtest01 completes just fine on
> dax mountpoint (I've used your reproducer). So can you sample several
> kernel stack traces to get a rough idea where the kernel is running?
> Thanks!
> 
> 								Honza

I'm also unable to reproduce this issue.  I've tried with both the blamed
commit:

4b4bb46 (HEAD) dax: clear dirty entry tags on cache flush

and with v4.9-rc2.  Both pass the test in my setup.

Perhaps the variable is the size of your PMEM partitions?

# fdisk -l /dev/pmem0
Disk /dev/pmem0: 16 GiB, 17179869184 bytes, 33554432 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
Disklabel type: dos
Disk identifier: 0xfe50c900

Device       Boot    Start      End  Sectors Size Id Type
/dev/pmem0p1          4096 25165823 25161728  12G 83 Linux
/dev/pmem0p2      25165824 33550335  8384512   4G 83 Linux

What does your setup look like?

I'm using the current tip of the LTP tree:

8cc4165  waitid02: define _XOPEN_SOURCE 500

Thanks,
- Ross

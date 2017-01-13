From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v6] DAX: enable iostat for read/write
Date: Fri, 13 Jan 2017 15:16:35 -0800
Message-ID: <20170113151635.ef2a4559fd8bfc5b268141c1@linux-foundation.org>
References: <20170113233418.32252-1-toshi.kani@hpe.com>
 <20170113145406.b1f065fb7fda67fd18830969@linux-foundation.org>
 <1484352338.2029.7.camel@hpe.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <1484352338.2029.7.camel-ZPxbGqLxI0U@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
Cc: "linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org" <linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>, "david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org" <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org" <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, "joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org" <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Fri, 13 Jan 2017 23:09:58 +0000 "Kani, Toshimitsu" <toshi.kani-ZPxbGqLxI0U@public.gmane.org> wrote:

> On Fri, 2017-01-13 at 14:54 -0800, Andrew Morton wrote:
> > On Fri, 13 Jan 2017 16:34:18 -0700 Toshi Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>
> > wrote:
> > 
> > > DAX IO path does not support iostat, but its metadata IO path does.
> > > Therefore, iostat shows metadata IO statistics only, which has been
> > > confusing to users.
> > > 
> > > Add iostat support to the DAX read/write path.
> > > 
> > > Note, iostat still does not support the DAX mmap path as it allows
> > > user applications to access directly.
> > > 
> > > ...
> > > 
> > > --- a/fs/dax.c
> > > +++ b/fs/dax.c
> > > @@ -1058,12 +1058,24 @@ dax_iomap_rw(struct kiocb *iocb, struct
> > > iov_iter *iter,
> > > __{
> > > __	struct address_space *mapping = iocb->ki_filp->f_mapping;
> > > __	struct inode *inode = mapping->host;
> > > +	struct gendisk *disk = inode->i_sb->s_bdev->bd_disk;
> > > __	loff_t pos = iocb->ki_pos, ret = 0, done = 0;
> > > __	unsigned flags = 0;
> > > +	unsigned long start = 0;
> > > +	int do_acct = blk_queue_io_stat(disk->queue);
> > 
> > (The poorly named) blk_queue_io_stat() actually returns a bool.____This
> > is well concealed because blk_queue_io_stat() is unnecessarily
> > implemented as a macro (why oh why).
> 
> It was unclear to me what type I needed to use.  test_bit() is 'bool'
> in arch/x86/include/asm/bitops.h but is 'int' in  include/asm-
> generic/bitops/non-atomic.h.  So, I used 'int' for safe... 

Yes, x86 does appear to be an outlier.  Mess.

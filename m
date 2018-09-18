Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 18 Sep 2018 11:59:52 -0600
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180918175952.GJ11367@ziepe.ca>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath>
 <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180918175108.GF35251@wrath>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org, platform-driver-x86@vger.kernel.org, linux-remoteproc@vger.kernel.org, sparclinux@vger.kernel.org, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, linux-fbdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> >  
> > > Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
> > > 
> > > As for a longer term solution, would it be possible to init fops in such
> > > a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
> > > so we don't have to duplicate this boilerplate for every ioctl fops
> > > structure?
> > 
> > 	Bad idea, that...  Because several years down the road somebody will add
> > an ioctl that takes an unsigned int for argument.  Without so much as looking
> > at your magical mystery macro being used to initialize file_operations.
> 
> Fair, being explicit in the declaration as it is currently may be
> preferable then.

It would be much cleaner and safer if you could arrange things to add
something like this to struct file_operations:

  long (*ptr_ioctl) (struct file *, unsigned int, void __user *);

Where the core code automatically converts the unsigned long to the
void __user * as appropriate.

Then it just works right always and the compiler will help address
Al's concern down the road.

Cheers,
Jason

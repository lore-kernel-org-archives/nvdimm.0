Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 24 Sep 2018 14:35:05 -0600
From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180924203505.GC6008@ziepe.ca>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath>
 <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath>
 <20180918175952.GJ11367@ziepe.ca>
 <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: Darren Hart <dvhart@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, gregkh <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>, driverdevel <devel@driverdev.osuosl.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, qat-linux@intel.com, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Linux Media Mailing List <linux-media@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org, "open list:HID CORE LAYER" <linux-input@vger.kernel.org>, linux-iio@vger.kernel.org, linux-rdma <linux-rdma@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-pci <linux-pci@vger.kernel.org>, Platform Driver <platform-driver-x86@vger.kernel.org>, linux-remoteproc@vger.kernel.org, sparclinux <sparclinux@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, linux-fbdev@vger.kernel.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, ceph-devel <ceph-devel@vger.kernel.org>, linux-wireless <linux-wireless@vger.kernel.org>, Networking <netdev@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 24, 2018 at 10:18:52PM +0200, Arnd Bergmann wrote:
> On Tue, Sep 18, 2018 at 7:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> >
> > On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> > > On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > > > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> > > >
> > > > > Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
> > > > >
> > > > > As for a longer term solution, would it be possible to init fops in such
> > > > > a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
> > > > > so we don't have to duplicate this boilerplate for every ioctl fops
> > > > > structure?
> > > >
> > > >     Bad idea, that...  Because several years down the road somebody will add
> > > > an ioctl that takes an unsigned int for argument.  Without so much as looking
> > > > at your magical mystery macro being used to initialize file_operations.
> > >
> > > Fair, being explicit in the declaration as it is currently may be
> > > preferable then.
> >
> > It would be much cleaner and safer if you could arrange things to add
> > something like this to struct file_operations:
> >
> >   long (*ptr_ioctl) (struct file *, unsigned int, void __user *);
> >
> > Where the core code automatically converts the unsigned long to the
> > void __user * as appropriate.
> >
> > Then it just works right always and the compiler will help address
> > Al's concern down the road.
> 
> I think if we wanted to do this with a new file operation, the best
> way would be to do the copy_from_user()/copy_to_user() in the caller
> as well.
>
> We already do this inside of some subsystems, notably drivers/media/,
> and it simplifies the implementation of the ioctl handler function
> significantly. We obviously cannot do this in general, both because of
> traditional drivers that have 16-bit command codes (drivers/tty and others)
> and also because of drivers that by accident defined the commands
> incorrectly and use the wrong type or the wrong direction in the
> definition.

That could work well, but the first idea could be done globally and
mechanically, while this would require very careful per-driver
investigation. 

Particularly if the core code has worse performance.. ie due to
kmalloc calls or something.

I think it would make more sense to start by having the core do the
case to __user and then add another entry point to have the core do
the copy_from_user, and so on.

Jason

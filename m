Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-f195.google.com (mail-qt1-f195.google.com
 [209.85.160.195])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC1D921A02937
 for <linux-nvdimm@lists.01.org>; Mon, 24 Sep 2018 13:19:10 -0700 (PDT)
Received: by mail-qt1-f195.google.com with SMTP id z8-v6so10940054qto.9
 for <linux-nvdimm@lists.01.org>; Mon, 24 Sep 2018 13:19:10 -0700 (PDT)
MIME-Version: 1.0
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath> <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath> <20180918175952.GJ11367@ziepe.ca>
In-Reply-To: <20180918175952.GJ11367@ziepe.ca>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 24 Sep 2018 22:18:52 +0200
Message-ID: <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
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
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-fbdev@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci <linux-pci@vger.kernel.org>, linux-remoteproc@vger.kernel.org, linux-nvme@lists.infradead.org, Platform Driver <platform-driver-x86@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, driverdevel <devel@driverdev.osuosl.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvdimm@lists.01.org, linux-rdma <linux-rdma@vger.kernel.org>, qat-linux@intel.com, amd-gfx@lists.freedesktop.org, "open list:HID CORE LAYER" <linux-input@vger.kernel.org>, Darren Hart <dvhart@infradead.org>, Linux Media Mailing List <linux-media@vger.kernel.org>, linaro-mm-sig@lists.linaro.org, dri-devel <dri-devel@lists.freedesktop.org>, ceph-devel <ceph-devel@vger.kernel.org>, gregkh <gregkh@linuxfoundation.org>, USB list <linux-usb@vger.kernel.org>, linux-wireless <linux-wireless@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>, Networking <netdev@vger.kernel.org>, Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, David Miller <davem@davemloft.net>, linux-btrfs <linux-btrfs@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 18, 2018 at 7:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> > On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> > >
> > > > Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
> > > >
> > > > As for a longer term solution, would it be possible to init fops in such
> > > > a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
> > > > so we don't have to duplicate this boilerplate for every ioctl fops
> > > > structure?
> > >
> > >     Bad idea, that...  Because several years down the road somebody will add
> > > an ioctl that takes an unsigned int for argument.  Without so much as looking
> > > at your magical mystery macro being used to initialize file_operations.
> >
> > Fair, being explicit in the declaration as it is currently may be
> > preferable then.
>
> It would be much cleaner and safer if you could arrange things to add
> something like this to struct file_operations:
>
>   long (*ptr_ioctl) (struct file *, unsigned int, void __user *);
>
> Where the core code automatically converts the unsigned long to the
> void __user * as appropriate.
>
> Then it just works right always and the compiler will help address
> Al's concern down the road.

I think if we wanted to do this with a new file operation, the best
way would be to do the copy_from_user()/copy_to_user() in the caller
as well.

We already do this inside of some subsystems, notably drivers/media/,
and it simplifies the implementation of the ioctl handler function
significantly. We obviously cannot do this in general, both because of
traditional drivers that have 16-bit command codes (drivers/tty and others)
and also because of drivers that by accident defined the commands
incorrectly and use the wrong type or the wrong direction in the
definition.

       Arnd
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt1-f193.google.com (mail-qt1-f193.google.com
 [209.85.160.193])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2007F210EFAEA
 for <linux-nvdimm@lists.01.org>; Mon, 24 Sep 2018 14:17:18 -0700 (PDT)
Received: by mail-qt1-f193.google.com with SMTP id h22-v6so3173060qtr.13
 for <linux-nvdimm@lists.01.org>; Mon, 24 Sep 2018 14:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath> <20180914205748.GC19965@ZenIV.linux.org.uk>
 <20180918175108.GF35251@wrath> <20180918175952.GJ11367@ziepe.ca>
 <CAK8P3a17GY89in7PeLk1F2T-0Xq=sCrwwntM+Y4BCpXheUC+qQ@mail.gmail.com>
 <20180924203505.GC6008@ziepe.ca>
In-Reply-To: <20180924203505.GC6008@ziepe.ca>
From: Arnd Bergmann <arnd@arndb.de>
Date: Mon, 24 Sep 2018 23:17:01 +0200
Message-ID: <CAK8P3a1Bh9NnncbcT0X4fKWC7B0FnqYyEMUwB6MvmzaNO7VhFQ@mail.gmail.com>
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

On Mon, Sep 24, 2018 at 10:35 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Mon, Sep 24, 2018 at 10:18:52PM +0200, Arnd Bergmann wrote:
> > On Tue, Sep 18, 2018 at 7:59 PM Jason Gunthorpe <jgg@ziepe.ca> wrote:
> > > On Tue, Sep 18, 2018 at 10:51:08AM -0700, Darren Hart wrote:
> > > > On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> > > > > On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
> > We already do this inside of some subsystems, notably drivers/media/,
> > and it simplifies the implementation of the ioctl handler function
> > significantly. We obviously cannot do this in general, both because of
> > traditional drivers that have 16-bit command codes (drivers/tty and others)
> > and also because of drivers that by accident defined the commands
> > incorrectly and use the wrong type or the wrong direction in the
> > definition.
>
> That could work well, but the first idea could be done globally and
> mechanically, while this would require very careful per-driver
> investigation.
>
> Particularly if the core code has worse performance.. ie due to
> kmalloc calls or something.
>
> I think it would make more sense to start by having the core do the
> case to __user and then add another entry point to have the core do
> the copy_from_user, and so on.

Having six separate callback pointers to implement a single
system call seems a bit excessive though.

        Arnd
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

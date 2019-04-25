From: Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH v3 12/26] compat_ioctl: move more drivers to
 compat_ptr_ioctl
Date: Thu, 25 Apr 2019 16:35:34 +0100
Message-ID: <20190425153534.GS2217@ZenIV.linux.org.uk>
References: <20190416202013.4034148-1-arnd@arndb.de>
 <20190416202701.127745-1-arnd@arndb.de>
 <20190425122153.450fc094@coco.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190425122153.450fc094@coco.lan>
Sender: linux-kernel-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-fsdevel@vger.kernel.org, y2038@lists.linaro.org, linux-kernel@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Daniel Vetter <daniel.vetter@ffwll.ch>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Sterba <dsterba@suse.com>, Darren Hart <dvhart@infradead.org>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, devel@driverdev.osuosl.org, qat-linux@intel.com, linux-crypto@vger.kernel.org, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-iio@vger.kernel.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-pci@vger.kernel.org
List-Id: linux-nvdimm@lists.01.org

On Thu, Apr 25, 2019 at 12:21:53PM -0300, Mauro Carvalho Chehab wrote:

> If I understand your patch description well, using compat_ptr_ioctl
> only works if the driver is not for s390, right?

No; s390 is where "oh, just set ->compat_ioctl same as ->unlocked_ioctl
and be done with that; compat_ptr() is a no-op anyway" breaks.  IOW,
s390 is the reason for having compat_ptr_ioctl() in the first place;
that thing works on all biarch architectures, as long as all stuff
handled by ->ioctl() takes pointer to arch-independent object as
argument.  IOW,
	argument ignored => OK
	any arithmetical type => no go, compat_ptr() would bugger it
	pointer to int => OK
	pointer to string => OK
	pointer to u64 => OK
	pointer to struct {u64 addr; char s[11];} => OK
	pointer to long => needs explicit handler
	pointer to struct {void *addr; char s[11];} => needs explicit handler
	pointer to struct {int x; u64 y;} => needs explicit handler on amd64
For "just use ->unlocked_ioctl for ->ioctl" we have
	argument ignored => OK
	any arithmetical type => OK
	any pointer => instant breakage on s390, in addtion to cases that break
with compat_ptr_ioctl().

Probably some form of that ought to go into commit message for compat_ptr_ioctl()
introduction...

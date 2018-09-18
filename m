Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F8CE21A07A82
 for <linux-nvdimm@lists.01.org>; Tue, 18 Sep 2018 10:51:22 -0700 (PDT)
Date: Tue, 18 Sep 2018 10:51:08 -0700
From: Darren Hart <dvhart@infradead.org>
Subject: Re: [PATCH v2 05/17] compat_ioctl: move more drivers to
 generic_compat_ioctl_ptrarg
Message-ID: <20180918175108.GF35251@wrath>
References: <20180912150142.157913-1-arnd@arndb.de>
 <20180912151134.436719-1-arnd@arndb.de>
 <20180914203506.GE35251@wrath>
 <20180914205748.GC19965@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180914205748.GC19965@ZenIV.linux.org.uk>
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fbdev@vger.kernel.org, linux-iio@vger.kernel.org, linux-pci@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-nvme@lists.infradead.org, platform-driver-x86@vger.kernel.org, sparclinux@vger.kernel.org, devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, qat-linux@intel.com, amd-gfx@lists.freedesktop.org, linux-input@vger.kernel.org, linux-media@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>, linaro-mm-sig@lists.linaro.org, dri-devel@lists.freedesktop.org, ceph-devel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, "David S. Miller" <davem@davemloft.net>, linux-btrfs@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 14, 2018 at 09:57:48PM +0100, Al Viro wrote:
> On Fri, Sep 14, 2018 at 01:35:06PM -0700, Darren Hart wrote:
>  
> > Acked-by: Darren Hart (VMware) <dvhart@infradead.org>
> > 
> > As for a longer term solution, would it be possible to init fops in such
> > a way that the compat_ioctl call defaults to generic_compat_ioctl_ptrarg
> > so we don't have to duplicate this boilerplate for every ioctl fops
> > structure?
> 
> 	Bad idea, that...  Because several years down the road somebody will add
> an ioctl that takes an unsigned int for argument.  Without so much as looking
> at your magical mystery macro being used to initialize file_operations.

Fair, being explicit in the declaration as it is currently may be
preferable then.

-- 
Darren Hart
VMware Open Source Technology Center
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

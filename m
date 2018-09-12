Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6EF5D2112A2B1
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 14:58:03 -0700 (PDT)
Date: Wed, 12 Sep 2018 23:57:59 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uio: fix is_source param for check_copy_size() in
 copy_to_iter_mcsafe()
Message-ID: <20180912215759.GA3000@kroah.com>
References: <153617950046.33664.13445188581267552601.stgit@djiang5-desk3.ch.intel.com>
 <20180912074850.GA362@kroah.com>
 <CAPcyv4j9CooFiUpJnQvp2tP26u_Sys4AP4JmGtNBZf5R5ug8xg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4j9CooFiUpJnQvp2tP26u_Sys4AP4JmGtNBZf5R5ug8xg@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 12, 2018 at 02:51:53PM -0700, Dan Williams wrote:
> On Wed, Sep 12, 2018 at 12:48 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Sep 05, 2018 at 01:31:40PM -0700, Dave Jiang wrote:
> >> copy_to_iter_mcsafe() is passing in the is_source parameter as "false"
> >> to check_copy_size(). This is different than what copy_to_iter() does.
> >> Also, the addr parameter passed to check_copy_size() is the source so
> >> therefore we should be passing in "true" instead.
> >>
> >> Fixes: 8780356ef630 ("x86/asm/memcpy_mcsafe: Define copy_to_iter_mcsafe()")
> >> Cc: Fan Du <fan.du@intel.com>
> >> Reported-by: Wenwei Tao <wenwei.tww@alibaba-inc.com>
> >> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> >> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> >> Cc: stable <stable@vger.kernel.org>
> >> ---
> >>  include/linux/uio.h |    2 +-
> >
> > I am not the maintainer of this file, sorry, please work with the -mm
> > developers for this.
> 
> Likely this is get_maintainer.pl's fault:
> 
> $ ./scripts/get_maintainer.pl  -f include/linux/uio.h
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> (maintainer:USERSPACE I/O (UIO))
> linux-kernel@vger.kernel.org (open list)
> 
> Maybe a MAINTAINERS update like the following is warranted, because I
> don't think -mm developers are right either, Al seems to be authority
> on iov_iter apis:
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d870cb57c887..0018e19b4d8e 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -15344,13 +15344,18 @@ F:    arch/x86/um/
>  F:     fs/hostfs/
>  F:     fs/hppfs/
> 
> +USERSPACE ACCESS (uaccess, copy_{to,from}_iter)
> +M:     Alexander Viro <viro@zeniv.linux.org.uk>
> +S:     Maintained
> +F:     include/linux/uio*.h
> +F:     lib/iov_iter.c
> +
>  USERSPACE I/O (UIO)
>  M:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  S:     Maintained
>  T:     git git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
>  F:     Documentation/driver-api/uio-howto.rst
>  F:     drivers/uio/
> -F:     include/linux/uio*.h

Don't drop that line, uio_driver.h is what it should just say, right?

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 92F2821B02822
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 00:48:54 -0700 (PDT)
Date: Wed, 12 Sep 2018 09:48:50 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] uio: fix is_source param for check_copy_size() in
 copy_to_iter_mcsafe()
Message-ID: <20180912074850.GA362@kroah.com>
References: <153617950046.33664.13445188581267552601.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153617950046.33664.13445188581267552601.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 05, 2018 at 01:31:40PM -0700, Dave Jiang wrote:
> copy_to_iter_mcsafe() is passing in the is_source parameter as "false"
> to check_copy_size(). This is different than what copy_to_iter() does.
> Also, the addr parameter passed to check_copy_size() is the source so
> therefore we should be passing in "true" instead.
> 
> Fixes: 8780356ef630 ("x86/asm/memcpy_mcsafe: Define copy_to_iter_mcsafe()")
> Cc: Fan Du <fan.du@intel.com>
> Reported-by: Wenwei Tao <wenwei.tww@alibaba-inc.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> Cc: stable <stable@vger.kernel.org>
> ---
>  include/linux/uio.h |    2 +-

I am not the maintainer of this file, sorry, please work with the -mm
developers for this.

thanks,

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

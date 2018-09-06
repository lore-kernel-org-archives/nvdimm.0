Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 55D5C2111FE6E
 for <linux-nvdimm@lists.01.org>; Thu,  6 Sep 2018 08:46:03 -0700 (PDT)
Subject: Re: [PATCH] uio: fix is_source param for check_copy_size() in
 copy_to_iter_mcsafe()
From: Dave Jiang <dave.jiang@intel.com>
References: <153617950046.33664.13445188581267552601.stgit@djiang5-desk3.ch.intel.com>
Message-ID: <c81d5d9d-4d9f-917f-d7f5-4d9a4dc6e146@intel.com>
Date: Thu, 6 Sep 2018 08:45:58 -0700
MIME-Version: 1.0
In-Reply-To: <153617950046.33664.13445188581267552601.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
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
To: gregkh@linuxfoundation.org
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Wenwei Tao <wenwei.tww@alibaba-inc.com>
List-ID: <linux-nvdimm@lists.01.org>



On 09/05/2018 01:31 PM, Dave Jiang wrote:
> copy_to_iter_mcsafe() is passing in the is_source parameter as "false"
> to check_copy_size(). This is different than what copy_to_iter() does.
> Also, the addr parameter passed to check_copy_size() is the source so
> therefore we should be passing in "true" instead.
> 
> Fixes: 8780356ef630 ("x86/asm/memcpy_mcsafe: Define copy_to_iter_mcsafe()")
> 
> Reported-by: Fan Du <fan.du@intel.com>
Slight correction:
Reported-by: Wenwei Tao <wenwei.tww@alibaba-inc.com>

> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  include/linux/uio.h |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/linux/uio.h b/include/linux/uio.h
> index 409c845d4cd3..422b1c01ee0d 100644
> --- a/include/linux/uio.h
> +++ b/include/linux/uio.h
> @@ -172,7 +172,7 @@ size_t copy_from_iter_flushcache(void *addr, size_t bytes, struct iov_iter *i)
>  static __always_inline __must_check
>  size_t copy_to_iter_mcsafe(void *addr, size_t bytes, struct iov_iter *i)
>  {
> -	if (unlikely(!check_copy_size(addr, bytes, false)))
> +	if (unlikely(!check_copy_size(addr, bytes, true)))
>  		return 0;
>  	else
>  		return _copy_to_iter_mcsafe(addr, bytes, i);
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

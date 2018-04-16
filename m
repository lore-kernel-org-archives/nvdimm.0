Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BF7E92263DD78
 for <linux-nvdimm@lists.01.org>; Mon, 16 Apr 2018 10:05:53 -0700 (PDT)
Subject: Re: [ndctl PATCH] ndctl: fix ordering of closing vs invalidating
 flush_fd
References: <20180416170338.32734-1-vishal.l.verma@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <226933df-5dd7-6f30-e919-78b82b868aa3@intel.com>
Date: Mon, 16 Apr 2018 10:05:52 -0700
MIME-Version: 1.0
In-Reply-To: <20180416170338.32734-1-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 04/16/2018 10:03 AM, Vishal Verma wrote:
> Static analysis warns that we may be closing a negative 'fd'. Fix this
> by closing before invalidating the flush_fd with a -1 in add_region()
> 
> Fixes: commit c64cc15 ("ndctl: add support in libndctl to provide deep flush")
> Cc: Dave Jiang <dave.jiang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Good catch!

Acked-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  ndctl/lib/libndctl.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index ad5ab9a..59ea82a 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -1929,8 +1929,8 @@ static void *add_region(void *parent, int id, const char *region_base)
>  
>  	perm = strtol(buf, NULL, 0);
>  	if (perm == 0) {
> -		region->flush_fd = -1;
>  		close(region->flush_fd);
> +		region->flush_fd = -1;
>  	}
>  
>   out:
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

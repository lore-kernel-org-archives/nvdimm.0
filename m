Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0B9D52035D0F5
 for <linux-nvdimm@lists.01.org>; Tue, 31 Oct 2017 12:18:48 -0700 (PDT)
Date: Tue, 31 Oct 2017 13:20:26 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [ndctl patch] btt_check_arenas: fix use of uninitialized variable
Message-ID: <20171031192026.GA5253@omniknight.lm.intel.com>
References: <x49376ikhuy.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <x49376ikhuy.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 10/16, Jeff Moyer wrote:
> Coverity complains that rc, passed to btt_xlat_status, may be
> used uninitialized.  In that case, we may also dereference a
> NULL pointer.  Fix it by only calling btt_xlat_status with a
> valid arena.
> 
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

Good catch!
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
> 
> diff --git a/ndctl/check.c b/ndctl/check.c
> index 915bb9d..93f95c6 100644
> --- a/ndctl/check.c
> +++ b/ndctl/check.c
> @@ -582,9 +582,10 @@ static int btt_check_arenas(struct btt_chk *bttc)
>  			break;
>  	}
>  
> -	btt_xlat_status(a, rc);
> -	if (rc)
> +	if (a && rc != BTT_OK) {
> +		btt_xlat_status(a, rc);
>  		return -ENXIO;
> +	}
>  	return 0;
>  }
>  
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2ED2F2194EB75
 for <linux-nvdimm@lists.01.org>; Fri, 15 Feb 2019 09:55:46 -0800 (PST)
Date: Fri, 15 Feb 2019 09:55:40 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [ndctl PATCH v2 1/3] autoconf: print more possible package names
 for <keyutils.h>
Message-ID: <20190215175539.GB26988@iweiny-DESK2.sc.intel.com>
References: <20190214163422.15221-1-elliott@hpe.com>
 <20190215025725.19366-1-elliott@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190215025725.19366-1-elliott@hpe.com>
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
To: Robert Elliott <elliott@hpe.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 08:57:23PM -0600, Robert Elliott wrote:
> The distro package names providing <keyutils.h> are inconsistent, so
> print more than just one suggestion:
>     keyutils-libs-devel (Red Hat)
>     keyutils-devel (SUSE)
>     libkeyutils-dev (Ubuntu)
> 
> Fixes: 86b078b44275 ("ndctl: add passphrase management commands")
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Robert Elliott <elliott@hpe.com>

V2
Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  configure.ac | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index d27a2b1..8e57a53 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -170,8 +170,7 @@ AC_ARG_WITH([keyutils],
>  
>  if test "x$with_keyutils" = "xyes"; then
>  	AC_CHECK_HEADERS([keyutils.h],,[
> -		AC_MSG_ERROR([keyutils.h not found, consider installing
> -			      keyutils-libs-devel.])
> +		AC_MSG_ERROR([keyutils.h not found, consider installing the keyutils library development package (variously named keyutils-libs-devel, keyutils-devel, or libkeyutils-dev).])
>  		])
>  fi
>  AS_IF([test "x$with_keyutils" = "xyes"],
> -- 
> 2.20.1
> 
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

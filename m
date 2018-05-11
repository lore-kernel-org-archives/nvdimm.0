Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D3EF203BEA2D
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 11:02:47 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: remove warning caused by -D_FORTIFY_SOURCE=2 and
 -O0 compile flags
Date: Fri, 11 May 2018 18:02:45 +0000
Message-ID: <1526061763.4429.14.camel@intel.com>
References: <152605735888.60453.10483504271205064345.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152605735888.60453.10483504271205064345.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <DE64724B99353E4EB5FBD63736B8EE8E@intel.com>
MIME-Version: 1.0
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2018-05-11 at 09:49 -0700, Dave Jiang wrote:
> Compiler spits out warning with -D_FORTIFY_SOURCE=2 and -O0. Moving to
> -O2
> to remove warnings.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> 
> -v2: Add -O2 option to configure.ac as well. (Vishal)

Thanks for the update, applied.

> 
>  README.md    |    2 +-
>  autogen.sh   |    2 +-
>  configure.ac |    3 ++-
>  3 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/README.md b/README.md
> index 899dcbb8..e0bc5b7b 100644
> --- a/README.md
> +++ b/README.md
> @@ -6,7 +6,7 @@ sub-system in the Linux kernel
>  Build
>  =====
>  `./autogen.sh`  
> -`./configure CFLAGS='-g -O0' --prefix=/usr --sysconfdir=/etc --
> libdir=/usr/lib64`  
> +`./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --
> libdir=/usr/lib64`  
>  `make`  
>  `make check`  
>  `sudo make install`  
> diff --git a/autogen.sh b/autogen.sh
> index a23cf53c..2a52688b 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -24,5 +24,5 @@ echo "-------------------------------------------------
> ---------------"
>  echo "Initialized build system. For a common configuration please run:"
>  echo "----------------------------------------------------------------"
>  echo
> -echo "./configure CFLAGS='-g -O0' $args"
> +echo "./configure CFLAGS='-g -O2' $args"
>  echo
> diff --git a/configure.ac b/configure.ac
> index 6dbfcee8..a1e4e837 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -149,7 +149,8 @@ my_CFLAGS="\
>  -Wtype-limits \
>  -Wmaybe-uninitialized \
>  -Wunused-result \
> --D_FORTIFY_SOURCE=2
> +-D_FORTIFY_SOURCE=2 \
> +-O2
>  "
>  AC_SUBST([my_CFLAGS])
>  
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

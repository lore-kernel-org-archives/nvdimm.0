Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 06AD520971758
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 09:00:23 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl: remove warning caused by -D_FORTIFY_SOURCE=2 and
 -O0 compile flags
Date: Fri, 11 May 2018 16:00:21 +0000
Message-ID: <1526054420.4429.7.camel@intel.com>
References: <152599606288.49950.18061098495140664365.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <152599606288.49950.18061098495140664365.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
Content-ID: <2EDD70EED1DC714BA59991D679096ED4@intel.com>
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

On Thu, 2018-05-10 at 16:47 -0700, Dave Jiang wrote:
> Compiler spits out warning with -D_FORTIFY_SOURCE=2 and -O0. Moving to
> -O2
> to remove warnings.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  README.md  |    2 +-
>  autogen.sh |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
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

Should we also add -O2 to my_CFLAGS in configure.ac, or leave that to the
user?

> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

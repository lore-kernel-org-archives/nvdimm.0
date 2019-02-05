Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ED02D211C3F68
 for <linux-nvdimm@lists.01.org>; Tue,  5 Feb 2019 13:50:03 -0800 (PST)
Subject: Re: [ndctl PATCH] ndctl: fix ndctl linking with libkeyutils
References: <20190205214705.1009-1-vishal.l.verma@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <253309eb-3efe-86f2-47e1-4860437a015c@intel.com>
Date: Tue, 5 Feb 2019 14:49:48 -0700
MIME-Version: 1.0
In-Reply-To: <20190205214705.1009-1-vishal.l.verma@intel.com>
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
Cc: Piotr Balcer <piotr.balcer@intel.com>
List-ID: <linux-nvdimm@lists.01.org>



On 2/5/19 2:47 PM, Vishal Verma wrote:
> From: Piotr Balcer <piotr.balcer@intel.com>
> 
> Compilation on Ubuntu 18.04 fails with:
> 
>   /usr/bin/ld: util/keys.o: undefined reference to symbol 'keyctl_read_alloc@@KEYUTILS_0.3'
>   /lib/x86_64-linux-gnu/libkeyutils.so.1: error adding symbols: DSO missing from command line
> 
> Seems like libkeyutils is incorrectly linked against libndctl,
> where in reality it's the ndctl application that uses keyutils.
> 
> Cc: Dave Jiang <dave.jiang@intel.com>
> Fixes: 86b078b44275 ("ndctl: add passphrase management commands")
> Signed-off-by: Piotr Balcer <piotr.balcer@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Ah yeah it used to be in libndctl, but in the last round of changes it
was moved to ndctl/utils.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  ndctl/Makefile.am     | 4 ++++
>  ndctl/lib/Makefile.am | 4 ----
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
> index 3287dbb..502271e 100644
> --- a/ndctl/Makefile.am
> +++ b/ndctl/Makefile.am
> @@ -47,6 +47,10 @@ ndctl_LDADD =\
>  	$(KMOD_LIBS) \
>  	$(JSON_LIBS)
>  
> +if ENABLE_KEYUTILS
> +ndctl_LDADD += -lkeyutils
> +endif
> +
>  if ENABLE_TEST
>  ndctl_SOURCES += ../test/libndctl.c \
>  		 ../test/dsm-fail.c \
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index 99eaae0..7797039 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -30,10 +30,6 @@ libndctl_la_LIBADD =\
>  	$(UUID_LIBS) \
>  	$(KMOD_LIBS)
>  
> -if ENABLE_KEYUTILS
> -libndctl_la_LIBADD += -lkeyutils
> -endif
> -
>  EXTRA_DIST += libndctl.sym
>  
>  libndctl_la_LDFLAGS = $(AM_LDFLAGS) \
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

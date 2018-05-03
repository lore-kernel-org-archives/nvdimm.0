Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 157C0203BEA30
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 12:06:09 -0700 (PDT)
Received: by mail-oi0-x241.google.com with SMTP id n65-v6so17067140oig.6
 for <linux-nvdimm@lists.01.org>; Thu, 03 May 2018 12:06:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180503185050.7559-4-vishal.l.verma@intel.com>
References: <20180503185050.7559-1-vishal.l.verma@intel.com>
 <20180503185050.7559-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 May 2018 12:06:07 -0700
Message-ID: <CAPcyv4hPpbQLd0TP20T08t5Rku5qRFAu-RaA7moekhQGU0ZZNg@mail.gmail.com>
Subject: Re: [ndctl PATCH 4/4] configure: add -Wunused-result and
 -D_FORTIFY_SOURCE=2 to cflags
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 3, 2018 at 11:50 AM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> rpmbuild had these flags enabled, and reported a couple of errors that
> local builds otherwise didn't. The errors hav now been fixed, and we

*have

> can enable these flags to catch future warnings and errors through
> these flags.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  configure.ac | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/configure.ac b/configure.ac
> index cddad16..6dbfcee 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -147,7 +147,9 @@ my_CFLAGS="\
>  -Wsign-compare \
>  -Wstrict-prototypes \
>  -Wtype-limits \
> --Wmaybe-uninitialized
> +-Wmaybe-uninitialized \
> +-Wunused-result \
> +-D_FORTIFY_SOURCE=2
>  "
>  AC_SUBST([my_CFLAGS])

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

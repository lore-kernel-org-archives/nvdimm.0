Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 62E412095DC9F
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 07:57:09 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id t75so5816026oie.3
 for <linux-nvdimm@lists.01.org>; Mon, 28 Aug 2017 07:59:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150370131716.22272.497887557604909999.stgit@djiang5-desk3.ch.intel.com>
References: <150370131716.22272.497887557604909999.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 28 Aug 2017 07:59:47 -0700
Message-ID: <CAPcyv4hzyj3zoZVj8fKyDGR6N7r+5LTx1zNen+V=1Co61Tp8eA@mail.gmail.com>
Subject: Re: [PATCH v4] ndctl: daxctl: Adding io option for daxctl
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 25, 2017 at 3:50 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The daxctl io option allows I/Os to be performed between file descriptor to
> and from device dax files. It also provides a way to zero a device dax
> device.
>
> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v4:
> - Added documentation on size suffix suggested by Ross.
>
> v3:
> - Added support for size suffix suggested by Ross.
> - Fixed the checking of __do_io() return value >32bit problem.
>
> v2:
> - Removed dependency on ndctl to match device and address other comments
> by Dan.
>
>  Documentation/daxctl/Makefile.am   |    3
>  Documentation/daxctl/daxctl-io.txt |   72 +++++
>  daxctl/Makefile.am                 |    5
>  daxctl/daxctl.c                    |    2
>  daxctl/io.c                        |  576 ++++++++++++++++++++++++++++++++++++
>  5 files changed, 656 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/daxctl/daxctl-io.txt
>  create mode 100644 daxctl/io.c
>
[..]
> diff --git a/daxctl/Makefile.am b/daxctl/Makefile.am
> index fe467d0..1ba1f07 100644
> --- a/daxctl/Makefile.am
> +++ b/daxctl/Makefile.am
> @@ -5,10 +5,13 @@ bin_PROGRAMS = daxctl
>  daxctl_SOURCES =\
>                 daxctl.c \
>                 list.c \
> +               io.c \
>                 ../util/json.c
>
>  daxctl_LDADD =\
>         lib/libdaxctl.la \
> +       ../ndctl/lib/libndctl.la \
>         ../libutil.a \
>         $(UUID_LIBS) \
> -       $(JSON_LIBS)
> +       $(JSON_LIBS) \
> +       -lpmem

Replace this with "$(PMEM_LIBS)" with a line like the following in configure.ac:

    PKG_CHECK_MODULES([PMEM], [pmem])

You should also update the daxctl depdendencies in the spec file with
a line like:

    BuildRequires:  pkgconfig(pmem)

...you can double check the rpm build with the "rpmbuild.sh" script in
the top-level of the source tree.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

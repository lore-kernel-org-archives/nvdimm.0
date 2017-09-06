Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 654E421E97804
 for <linux-nvdimm@lists.01.org>; Wed,  6 Sep 2017 12:44:22 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id r20so18657537oie.0
 for <linux-nvdimm@lists.01.org>; Wed, 06 Sep 2017 12:47:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <150420355300.6418.16181413869611049451.stgit@djiang5-desk3.ch.intel.com>
References: <150420355300.6418.16181413869611049451.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Sep 2017 12:47:11 -0700
Message-ID: <CAPcyv4g9N57y1aTrGy2=f883w6jdv+2=A0NzHRCy+j860u84FQ@mail.gmail.com>
Subject: Re: [PATCH v5] ndctl: daxctl: Adding io option for daxctl
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

On Thu, Aug 31, 2017 at 11:20 AM, Dave Jiang <dave.jiang@intel.com> wrote:
> The daxctl io option allows I/Os to be performed between file descriptor to
> and from device dax files. It also provides a way to zero a device dax
> device.
>
> i.e. daxctl io --input=/home/myfile --output=/dev/dax1.0
>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
[..]
> diff --git a/configure.ac b/configure.ac
> index 316f5b7..a16d555 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -93,6 +93,7 @@ PKG_CHECK_MODULES([KMOD], [libkmod])
>  PKG_CHECK_MODULES([UDEV], [libudev])
>  PKG_CHECK_MODULES([UUID], [uuid])
>  PKG_CHECK_MODULES([JSON], [json-c])
> +PKG_CHECK_MODULES([PMEM], [libpmem])

Ok, one last build comment. I think we should put the "daxctl io"
command support behind an explicit "--with-daxctl-io" option to
configure. The reason being that ndctl is a base level system system
package and libpmem is higher order application functionality. Ideally
libpmem would be using some of the libndctl helpers internally. In
order to bootstrap a configuration where libpmem depends on libndctl
and the daxctl utility depends on libpmem you need a way to disable
the libpmem dependency when initially building daxctl.

Also some environments may not want or be prepared to satisfy the
libpmem dependency, so let's default "daxctl io" to disabled. This
also means the spec file template needs to specify this option.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

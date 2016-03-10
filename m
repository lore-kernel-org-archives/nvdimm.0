Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 047671A1EC6
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 10:57:58 -0800 (PST)
Received: by mail-oi0-x22e.google.com with SMTP id m82so68488720oif.1
 for <linux-nvdimm@lists.01.org>; Thu, 10 Mar 2016 10:57:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1457620089-28984-1-git-send-email-jthumshirn@suse.de>
References: <1457620089-28984-1-git-send-email-jthumshirn@suse.de>
Date: Thu, 10 Mar 2016 10:57:42 -0800
Message-ID: <CAPcyv4h62dZs=82Vb3E3s85jazAeVWUCf=6Mc=jTDsVzPZ92qw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: Grab kernel version from utsname()
From: Dan Williams <dan.j.williams@intel.com>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 10, 2016 at 6:28 AM, Johannes Thumshirn <jthumshirn@suse.de> wrote:
> Grab the kernel version used for tests dynamically via utsname() instead of
> hardcoding the version of the build host.
>
> Otherwise tests will be skipped if the build host had a too old kernel
> version.
>
> flodin:~ # ./ndctl test
> __ndctl_test_attempt: skip test_libndctl:1950 requires: 4.2.0 current: 4.1.0
> test-libndctl: SKIP
> __ndctl_test_attempt: skip test_dpa_alloc:300 requires: 4.2.0 current: 4.1.0
> test-dpa-alloc: SKIP
> __ndctl_test_attempt: skip test_parent_uuid:230 requires: 4.3.0 current: 4.1.0
> test-parent-uuid: SKIP
> attempted: 3 skipped: 3
>
> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  test/core.c |   15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>
> --- a/test/core.c
> +++ b/test/core.c
> @@ -1,4 +1,5 @@
>  #include <linux/version.h>
> +#include <sys/utsname.h>
>  #include <stdlib.h>
>  #include <stdio.h>
>  #include <test.h>
> @@ -11,6 +12,18 @@ struct ndctl_test {
>         int skip;
>  };
>
> +static unsigned int get_system_kver(void)
> +{
> +       struct utsname utsname;
> +       int a, b, c;
> +
> +       uname(&utsname);
> +
> +       sscanf(utsname.version, "%d.%d.%d", &a, &b, &c);
> +
> +       return KERNEL_VERSION(a,b,c);
> +}

Hmm, on my workstation utsname.version is "#1 SMP Fri Feb 26 18:45:40
UTC 2016" while utsname.release is "4.4.3-300.fc23.x86_64".  Do
different distros define release and version differently?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

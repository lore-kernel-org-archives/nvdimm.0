Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 93FC4203BEA5D
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 20:25:52 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id n1-v6so23043382otf.7
 for <linux-nvdimm@lists.01.org>; Thu, 03 May 2018 20:25:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180426113050.11424-2-qi.fuli@jp.fujitsu.com>
References: <20180426113050.11424-1-qi.fuli@jp.fujitsu.com>
 <20180426113050.11424-2-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 May 2018 20:25:50 -0700
Message-ID: <CAPcyv4jPkp9acqfs57b4rTQkDSy4a3hm=02WGQLOMnmgxBKWzg@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] ndctl, util: add OPTION_FILENAME to parse_opt_type
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 26, 2018 at 4:30 AM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch borrows the OPTION_FILENAME from git to ndctl to make sure
> filename is correct. Some related refactoring is also included:
>   - adds parse_options_prefix() interface
>   - moves is_absolute from util/help.c to util/util.c
>   - adds a new file util/abspath.c
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
>
[..]
> diff --git a/util/abspath.c b/util/abspath.c
> new file mode 100644
> index 0000000..fdf4090
> --- /dev/null
> +++ b/util/abspath.c
> @@ -0,0 +1,28 @@
> +/* originally copied from git */

Lets say the source file name that it came from in and get and add the license.

/* SPDX-License-Identifier: GPL-2.0 */
/* originally copied from git/abspath.c */

Otherwise, this patch looks good to me.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

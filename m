Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448122C80
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 16:48:30 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 133so6097443pgb.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 09:48:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1RwGIFYqIcTa4h7PEF9eSckj/8EEJrGq1do1E24wPDg=;
        b=fXs02Ecy0zNBoaQ/S/ON33Glt1oyRADv0YHdmLLBrNF4BM/O5Kz1y5GJTvkXcFyQOe
         5d8dh8XPCbz12wQFIRx9vHoEJD7nnEkOt9ZuW6hbhxFjL0XuYm0xRUiRus5w1DvPCaVZ
         452Q0SSgsZmEJhgLVj8BUcfnbuOC5ubumYtXxRtcfFlflVHUT7zJujMTH068yVRBAr8Q
         SehXk5trabX0x0D43nON8rkTGhFYCz/qUv5mCzMII8RoCrvcStTv/p6ZTnsv4oQpJc3W
         D/ycj8RlNzcFYZk0vuhMZ+np/r3kYZrKENyqgVy+AjTvRzzeKzcetetmZTKv+1/sMVgj
         /RlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1RwGIFYqIcTa4h7PEF9eSckj/8EEJrGq1do1E24wPDg=;
        b=vjcnHTPgWglANoUDclGP6v9XPHuzkBvaFUZ+65TDJ1sT7ClmV1PLom+zKBkHoycaIK
         Z2nZjvAD3s0+mZeRFFzS8SXD/xN+pWSaXCuNmSau7dI1PO3iiMfwy/WZ2cHVTFVgoeqf
         Jy9jyTyDYhRxdO06c7+AFVlIxFynRf2kqcfXZFD/04Xwd0MfnDb7nBwdnh3daXs8RMPy
         ERPRlMqcOtKxAVcQzb5qkgUxq51fJDOhH5rwkzwXap2bp6XMYypRgdBp0kNN7HNf9jGa
         QHxpUQ1uP+d3O607/VmMr0aYlB+edWOjRm7akLK2pDZq9iQpyqx2znQrVcMhsR/ZLLQW
         EHCw==
X-Gm-Message-State: AOAM531JHib4NNgi6sURBbb7UGRx8k74Ki4dhEJTJUZuE4lz2yoAjjD5
	+YN5E+J675OSx+aTNNhmU/i7lseK3OEJshWeuD8hbw==
X-Google-Smtp-Source: ABdhPJzhwOQcDTklJnUiXHmt0mYtwIR5itIrTG7nLK/3IfH20FNjtS9cnabwkC5qSseYoVL15mFmSQquHO03SlT8cb4=
X-Received: by 2002:a62:1b92:0:b0:3eb:3f92:724 with SMTP id
 b140-20020a621b92000000b003eb3f920724mr6158723pfb.3.1634230109724; Thu, 14
 Oct 2021 09:48:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20211007082139.3088615-1-vishal.l.verma@intel.com> <20211007082139.3088615-10-vishal.l.verma@intel.com>
In-Reply-To: <20211007082139.3088615-10-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Oct 2021 09:48:19 -0700
Message-ID: <CAPcyv4gRM_3UxQkKxLg_up-zNecyTjrvG1CAuJyF1Wd+9bwfUA@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 09/17] util/hexdump: Add a util helper to print a
 buffer in hex
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 7, 2021 at 1:22 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> In preparation for tests that may need to set, retrieve, and display
> opaque data, add a hexdump function in util/
>
> Cc: Ben Widawsky <ben.widawsky@intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  util/hexdump.h |  8 ++++++++
>  util/hexdump.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++

If this is just for tests shouldn't it go in tests/ with the other
common test helpers? If it stays in util/ I would kind of expect it to
use the log infrastructure, no?

Other than that looks ok to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

>  2 files changed, 61 insertions(+)
>  create mode 100644 util/hexdump.h
>  create mode 100644 util/hexdump.c
>
> diff --git a/util/hexdump.h b/util/hexdump.h
> new file mode 100644
> index 0000000..d322b6a
> --- /dev/null
> +++ b/util/hexdump.h
> @@ -0,0 +1,8 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (C) 2021 Intel Corporation. All rights reserved. */
> +#ifndef _UTIL_HEXDUMP_H_
> +#define _UTIL_HEXDUMP_H_
> +
> +void hex_dump_buf(unsigned char *buf, int size);
> +
> +#endif /* _UTIL_HEXDUMP_H_*/
> diff --git a/util/hexdump.c b/util/hexdump.c
> new file mode 100644
> index 0000000..1ab0118
> --- /dev/null
> +++ b/util/hexdump.c
> @@ -0,0 +1,53 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright (C) 2015-2021 Intel Corporation. All rights reserved. */
> +#include <stdio.h>
> +#include <util/hexdump.h>
> +
> +static void print_separator(int len)
> +{
> +       int i;
> +
> +       for (i = 0; i < len; i++)
> +               fprintf(stderr, "-");
> +       fprintf(stderr, "\n");
> +}
> +
> +void hex_dump_buf(unsigned char *buf, int size)
> +{
> +       int i;
> +       const int grp = 4;  /* Number of bytes in a group */
> +       const int wid = 16; /* Bytes per line. Should be a multiple of grp */
> +       char ascii[wid + 1];
> +
> +       /* Generate header */
> +       print_separator((wid * 4) + (wid / grp) + 12);
> +
> +       fprintf(stderr, "Offset    ");
> +       for (i = 0; i < wid; i++) {
> +               if (i % grp == 0) fprintf(stderr, " ");
> +               fprintf(stderr, "%02x ", i);
> +       }
> +       fprintf(stderr, "  Ascii\n");
> +
> +       print_separator((wid * 4) + (wid / grp) + 12);
> +
> +       /* Generate hex dump */
> +       for (i = 0; i < size; i++) {
> +               if (i % wid == 0) fprintf(stderr, "%08x  ", i);
> +               ascii[i % wid] =
> +                   ((buf[i] >= ' ') && (buf[i] <= '~')) ? buf[i] : '.';
> +               if (i % grp == 0) fprintf(stderr, " ");
> +               fprintf(stderr, "%02x ", buf[i]);
> +               if ((i == size - 1) && (size % wid != 0)) {
> +                       int j;
> +                       int done = size % wid;
> +                       int grps_done = (done / grp) + ((done % grp) ? 1 : 0);
> +                       int spaces = wid / grp - grps_done + ((wid - done) * 3);
> +
> +                       for (j = 0; j < spaces; j++) fprintf(stderr, " ");
> +               }
> +               if ((i % wid == wid - 1) || (i == size - 1))
> +                       fprintf(stderr, "  %.*s\n", (i % wid) + 1, ascii);
> +       }
> +       print_separator((wid * 4) + (wid / grp) + 12);
> +}
> --
> 2.31.1
>

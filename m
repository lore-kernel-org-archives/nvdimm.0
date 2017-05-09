Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x241.google.com (mail-it0-x241.google.com
 [IPv6:2607:f8b0:4001:c0b::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE19C219516BF
 for <linux-nvdimm@lists.01.org>; Tue,  9 May 2017 07:21:31 -0700 (PDT)
Received: by mail-it0-x241.google.com with SMTP id 67so378362itx.2
 for <linux-nvdimm@lists.01.org>; Tue, 09 May 2017 07:21:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149427743028.38205.11259335580114937340.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149427742346.38205.12361226658239922137.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149427743028.38205.11259335580114937340.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 9 May 2017 16:21:30 +0200
Message-ID: <CAMuHMdXL-nWk7nWkjJL9Zd9ObeAdjLH-OTKGWxFHFvLOPo_WmQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] device-dax: kill NR_DEV_DAX
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-block@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 8, 2017 at 11:03 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> There is no point to ask how many device-dax instances the kernel should
> support. Since we are already using a dynamic major number, just allow
> the max number of minors by default and be done. This also fixes the
> fact that the proposed max for the NR_DEV_DAX range was larger than what
> could be supported by alloc_chrdev_region().
>
> Fixes: ba09c01d2fa8 ("dax: convert to the cdev api")
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

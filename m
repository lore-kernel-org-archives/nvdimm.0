Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22a.google.com (mail-yb0-x22a.google.com
 [IPv6:2607:f8b0:4002:c09::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A10B42095A6CC
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 19:06:44 -0700 (PDT)
Received: by mail-yb0-x22a.google.com with SMTP id s15so80601ybe.2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Jun 2017 19:08:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170624021758.26815-1-vishal.l.verma@intel.com>
References: <20170624021758.26815-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Jun 2017 19:08:16 -0700
Message-ID: <CAPcyv4j9vFT7SWuWTAkC4QRJ_+LikNoX=rKqbqgbMvZPEwrTjw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl,
 test: unit test updates for the BTT 2.0 format
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 23, 2017 at 7:17 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> With the BTT 2.0 update, a couple of minor updates to the unit tests are
> needed:
> test/libndctl: Update expected BTT sizes
> test/libndctl: in btt_autodetect, when wiping an old BTT, wipe the first
> two 4K pages instead of one.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/libndctl.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/test/libndctl.c b/test/libndctl.c
> index 24aff36..89c4c02 100644
> --- a/test/libndctl.c
> +++ b/test/libndctl.c
> @@ -994,16 +994,16 @@ static int check_btt_size(struct ndctl_btt *btt)
>         int size_select, sect_select;
>         unsigned long long expect_table[][2] = {
>                 [0] = {
> -                       [0] = 0x11b4400,
> -                       [1] = 0x8da2000,
> +                       [0] = 0x11b5400,
> +                       [1] = 0x8daa000,
>                 },
>                 [1] = {
> -                       [0] = 0x13b0400,
> -                       [1] = 0x9d82000,
> +                       [0] = 0x13b1400,
> +                       [1] = 0x9d8a000,
>                 },
>                 [2] = {
> -                       [0] = 0x1aa2600,
> -                       [1] = 0xd513000,
> +                       [0] = 0x1aa3600,
> +                       [1] = 0xd51b000,

I think we need to have different expectations for different BTT
versions. We should be able to check for v1.2 labels before picking
the expectation, or just have a new ndctl_test_attempt() gate on the
4.13 kernel for the new sizes.

>                 },
>         };
>
> @@ -1517,12 +1517,19 @@ static int check_btt_autodetect(struct ndctl_bus *bus,
>         }
>
>         memset(buf, 0, 4096);
> +       /* Delete both the first and second 4K pages */
>         rc = pwrite(fd, buf, 4096, 4096);
>         if (rc < 4096) {
>                 rc = -ENXIO;
>                 fprintf(stderr, "%s: failed to overwrite btt on %s\n",
>                                 devname, bdev);
>         }
> +       rc = pwrite(fd, buf, 4096, 0);
> +       if (rc < 4096) {
> +               rc = -ENXIO;
> +               fprintf(stderr, "%s: failed to overwrite btt on %s\n",
> +                               devname, bdev);
> +       }

How about just change the first one to: "rc = pwrite(fd, buf, 8192, 0);"?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

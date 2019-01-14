Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7B75E21197376
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 10:17:54 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id a77so18660471oii.5
 for <linux-nvdimm@lists.01.org>; Mon, 14 Jan 2019 10:17:54 -0800 (PST)
MIME-Version: 1.0
References: <20190114181115.11983-1-vishal.l.verma@intel.com>
 <20190114181115.11983-5-vishal.l.verma@intel.com>
In-Reply-To: <20190114181115.11983-5-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 14 Jan 2019 10:17:41 -0800
Message-ID: <CAPcyv4j7R6_V4fkoOYavswCSZGXVLnAD=3E3gZy+RSedsuTgVA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 4/4] ndctl: clean up usage of ndctl_cmd_submit
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

On Mon, Jan 14, 2019 at 10:11 AM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> It is possible for ndctl_cmd_submit to return a positive number,
> indicating a buffer underrun. It is only truly an error if it returns a
> negative number. Several places in the library, the ndctl utility, and
> in test/ were simply checking for an error with "if (rc)". Fix these to
> only error out for negative returns.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/lib/dimm.c              |  6 +++---
>  ndctl/lib/inject.c            |  8 ++++----
>  ndctl/lib/nfit.c              |  2 +-
>  ndctl/util/json-firmware.c    |  2 +-
>  test/ack-shutdown-count-set.c |  8 ++------
>  test/daxdev-errors.c          |  8 ++++----
>  test/libndctl.c               | 32 ++++++++++++++++----------------
>  test/smart-notify.c           |  8 ++++----
>  8 files changed, 35 insertions(+), 39 deletions(-)
>
> diff --git a/ndctl/lib/dimm.c b/ndctl/lib/dimm.c
> index 79e2ca0..12dc74a 100644
> --- a/ndctl/lib/dimm.c
> +++ b/ndctl/lib/dimm.c
> @@ -332,7 +332,7 @@ static int nvdimm_set_config_data(struct nvdimm_data *ndd, size_t offset,
>                 goto out;
>
>         rc = ndctl_cmd_submit(cmd_write);
> -       if (rc || ndctl_cmd_get_firmware_status(cmd_write))
> +       if ((rc < 0) || ndctl_cmd_get_firmware_status(cmd_write))

With ndctl_cmd_submit_xlat() the ndctl_cmd_get_firmware_status() can
be dropped, right?

    rc = ndctl_cmd_submit_xlat(cmd_write);
    if (rc < 0)
        rc = -ENXIO;


...or are you saving that conversion for a follow on patch?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

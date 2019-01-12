Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com
 [IPv6:2607:f8b0:4864:20::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 21B362119C8BB
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 16:32:42 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id u18so13685546oie.10
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 16:32:42 -0800 (PST)
MIME-Version: 1.0
References: <20190111225339.6939-1-vishal.l.verma@intel.com>
 <20190111225339.6939-4-vishal.l.verma@intel.com>
In-Reply-To: <20190111225339.6939-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 Jan 2019 16:32:30 -0800
Message-ID: <CAPcyv4gTQkVLieBtfdAZPtk4w9T7wKgt96-xnZY_HoHwiY0YcA@mail.gmail.com>
Subject: Re: [ndctl PATCH 3/3] ndctl, monitor: switch to ndctl_cmd_submit_xlat
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
Cc: Ami Pathak <ami.g.pathak@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 11, 2019 at 2:53 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> The ndctl monitor command was neglecting to check the 'firmware_status'
> field that is set by the platform firmware to indicate failure. Use
> the new ndctl_cmd_submit_xlat facility to include the firmware_status
> check as part of the command submission.
>
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/monitor.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 233f2bb..01af338 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -226,7 +226,7 @@ static int enable_dimm_supported_threshold_alarms(struct ndctl_dimm *dimm)
>                 err(&monitor, "%s: no smart threshold command support\n", name);
>                 goto out;
>         }
> -       if (ndctl_cmd_submit(st_cmd)) {
> +       if (ndctl_cmd_submit_xlat(st_cmd)) {

Same comment about fixing this up to explicitly check for '< 0'.

>                 err(&monitor, "%s: smart threshold command failed\n", name);
>                 goto out;
>         }
> @@ -246,7 +246,7 @@ static int enable_dimm_supported_threshold_alarms(struct ndctl_dimm *dimm)
>                 alarm |= ND_SMART_CTEMP_TRIP;
>         ndctl_cmd_smart_threshold_set_alarm_control(sst_cmd, alarm);
>
> -       rc = ndctl_cmd_submit(sst_cmd);
> +       rc = ndctl_cmd_submit_xlat(sst_cmd);
>         if (rc) {

Ditto.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

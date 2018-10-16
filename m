Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A705D21173C72
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 17:23:45 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id p23so20742397otf.11
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 17:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20180713233350.7148-1-qi.fuli@jp.fujitsu.com>
 <20180713233350.7148-3-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180713233350.7148-3-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 15 Oct 2018 17:23:33 -0700
Message-ID: <CAPcyv4h4VaLXV2Mj8VcZmvREyn=YtgC0AtBV1SEdDJ3YDKY5=Q@mail.gmail.com>
Subject: Re: [ndctl PATCH v13 2/5] ndctl, monitor: add main ndctl monitor
 configuration file
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: Keiichiro Tokunaga <tokunaga.keiich@jp.fujitsu.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 13, 2018 at 4:34 PM QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
>
> This patch adds the main configuration file(/etc/ndctl/monitor.conf)
> of ndctl monitor. It contains the configuration directives that give
> ndctl monitor instructions. Users can change the configuration by
> editing this file or using [--config-file] option to override this
> file. The changed value will work after restart ndctl monitor service.
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
[..]
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 12317d0..8300250 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
[..]
> @@ -454,6 +454,108 @@ dimm_event_all:
>         return 0;
>  }
>
> +static void parse_config(const char **arg, char *key, char *val, char *ident)
> +{
> +       struct strbuf value = STRBUF_INIT;
> +       size_t arg_len = *arg ? strlen(*arg) : 0;
> +
> +       if (!ident || !key || (strcmp(ident, key) != 0))
> +               return;
> +
> +       if (arg_len) {
> +               strbuf_add(&value, *arg, arg_len);
> +               strbuf_addstr(&value, " ");
> +       }
> +       strbuf_addstr(&value, val);
> +       *arg = strbuf_detach(&value, NULL);
> +}
> +
> +static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
> +               struct util_filter_params *_param)
> +{

Hi,

I have a future cleanup request. I've just come across, ciniparser
[1]. It would be great if we could drop the open coded implementation
and just use that library. We use ccan modules for other portions of
ndctl.

[1]: https://ccodearchive.net/info/ciniparser.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

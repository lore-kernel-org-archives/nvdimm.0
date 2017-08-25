Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB33C21E11D3C
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 16:44:14 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id k77so10589709oib.2
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 16:46:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170818133430.8EB1.E1E9C6FF@jp.fujitsu.com>
References: <20170818133124.8EAB.E1E9C6FF@jp.fujitsu.com>
 <20170818133430.8EB1.E1E9C6FF@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 Aug 2017 16:46:50 -0700
Message-ID: <CAPcyv4iVVgBsWCd=-Wh-+Whx0UpNMv_9cYCxJ_vDZJQbubQ=Hw@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/4] allow ND_CMD_CALL for bus
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
To: Yasunori Goto <y-goto@jp.fujitsu.com>
Cc: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 17, 2017 at 9:34 PM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
>
> Currently ndctl supports ND_CMD_CALL only for DIMM,
> but Translate SPA is the feature of bus.
> So ND_CMD_CALL must be allowed bus's ioctl().
>
>
> Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> ---
>  ndctl/lib/libndctl.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 93692e5..b3535f0 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -2330,6 +2330,7 @@ static int to_ioctl_cmd(int cmd, int dimm)
>  #ifdef HAVE_NDCTL_CLEAR_ERROR
>                 case ND_CMD_CLEAR_ERROR:     return ND_IOCTL_CLEAR_ERROR;
>  #endif
> +               case ND_CMD_CALL:            return ND_IOCTL_CALL;
>                 default:
>                                                        return 0;
>                 };
>

Looks good.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

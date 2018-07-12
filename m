Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EB5F22096AEDC
 for <linux-nvdimm@lists.01.org>; Thu, 12 Jul 2018 09:44:16 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl, documentation: fix the manpage of
 inject-smart
Date: Thu, 12 Jul 2018 16:43:46 +0000
Message-ID: <1531413824.7574.61.camel@intel.com>
References: <20180712054000.18519-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180712054000.18519-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <D258C40D27B44340B2E19C8F12EC18F9@intel.com>
MIME-Version: 1.0
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2018-07-12 at 14:40 +0900, QI Fuli wrote:
> The ndctl inject-smart doesn't have a [-H | --health] option.
> This patch replaces [-H | --health] in the manpage of inject-smart
> with [-f | --fatal].
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  Documentation/ndctl/ndctl-inject-smart.txt | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/ndctl/ndctl-inject-smart.txt
> b/Documentation/ndctl/ndctl-inject-smart.txt
> index 0dc6481..06710ec 100644
> --- a/Documentation/ndctl/ndctl-inject-smart.txt
> +++ b/Documentation/ndctl/ndctl-inject-smart.txt
> @@ -50,6 +50,7 @@ OPTIONS
>  --media-temperature-threshold=::
>  	Set <value> for the smart media temperature threshold.
>  
> +-x::
>  --media-temperature-alarm=::
>  	Enable or disable the smart media temperature alarm. Options
> are
>  	'on' or 'off'.
> @@ -62,6 +63,7 @@ OPTIONS
>  --ctrl-temperature-threshold=::
>  	Set <value> for the smart controller temperature threshold.
>  
> +-y::
>  --ctrl-temperature-alarm=::
>  	Enable or disable the smart controller temperature alarm.
> Options are
>  	'on' or 'off'.
> @@ -74,16 +76,16 @@ OPTIONS
>  --spares-threshold=::
>  	Set <value> for the smart spares threshold.
>  
> +-z::
>  --spares-alarm=::
>  	Enable or disable the smart spares alarm. Options are 'on'
> or 'off'.

Hi Qi,

For the x, y, and z short options, I left them undocumented since they
don't exactly match the actual field being set.

>  
> --H::
> ---health=::
> -	Smart attribute for health status. Provide either 'fatal' or
> 'nominal'
> -	to set the state of the attribute.

This was a leftover from a previous iteration, and does need to be
fixed. However, I am reworking this man page along with the smart
injection utility to also provide a way to 'uninject' or disable
injected values, and go back to reporting actual current status. I have
this fix in that series.

> +-f::
> +--fatal::
> +	Inject fatal for the health state attribute.
>  
>  -U::
> ---unsafe-shutdown=::
> +--unsafe-shutdown::
>  	Set the flag to spoof an unsafe shutdown on the next power
> down.
>  
>  -v::
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

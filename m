Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 917F8211EC0FE
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 10:37:30 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] monitor: removing the requirement of default config
Date: Fri, 29 Mar 2019 17:37:28 +0000
Message-ID: <cda88d4b0faf32de5ed449bc648f1a684337154d.camel@intel.com>
References: <20190329110150.3725-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20190329110150.3725-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <E8E4FA74262E564186214E6DF5FCF730@intel.com>
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


On Fri, 2019-03-29 at 20:01 +0900, QI Fuli wrote:
> Removing the requirement of default configuration file.
> If "-c, --config-file" option is not specified, default configuration
> file should be dispensable.
> 
> Link: https://github.com/pmem/ndctl/issues/83
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> 
> ---
>  ndctl/monitor.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 346a6df..6829a6b 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -484,8 +484,11 @@ static int read_config_file(struct ndctl_ctx *ctx, struct monitor *_monitor,
>  
>  	f = fopen(config_file, "r");
>  	if (!f) {
> -		err(&monitor, "config-file: %s cannot be opened\n", config_file);
> -		rc = -errno;
> +		if (_monitor->config_file) {
> +			err(&monitor, "config-file: %s cannot be opened\n",
> +				config_file);
> +			rc = -errno;
> +		}
>  		goto out;
>  	}
>  
Hi Qi,

Thanks for the quick patch. However, this makes it so that the only way
in which a config file gets used is by explicitly specifying it with a
-c option, and that kind of makes a 'default' config file pointless..

The ideal scenario would be:
1. Check if default config exists
   a. if it does, use options from there
   b. if any cli options provided, use those to override the ones in
config file (if any)

2. If default config file is missing, only use cli options

3. If -c <file> provided, use that, but perform the same treatment as 1b
above, i.e. any cli options override anything in the config file from -c
as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

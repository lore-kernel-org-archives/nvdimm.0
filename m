Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x243.google.com (mail-qk0-x243.google.com
 [IPv6:2607:f8b0:400d:c09::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99B3F208F7CB5
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 12:05:35 -0700 (PDT)
Received: by mail-qk0-x243.google.com with SMTP id b5-v6so12233934qkg.6
 for <linux-nvdimm@lists.01.org>; Tue, 07 Aug 2018 12:05:35 -0700 (PDT)
Subject: Re: [ndctl PATCH 1/4] ndctl, monitor: fix the lack of detection of
 invalid path of log file
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
 <20180807131756.23673-2-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <49365d81-6695-1c67-8026-d4ccb81285b0@gmail.com>
Date: Tue, 7 Aug 2018 15:05:31 -0400
MIME-Version: 1.0
In-Reply-To: <20180807131756.23673-2-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
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
To: qi.fuli@jp.fujitsu.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Qi,

On 08/07/2018 09:17 AM, QI Fuli wrote:
> Currently the monitor can be started even with an invalid path of log file.
> This patch adds a detection of invalid path of log file when starting monitor.
> If the path of log file is invalid, the monitor will refuse to be started.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/monitor.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index f10384b..bf1f1d3 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -603,6 +603,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  	struct util_filter_ctx fctx = { 0 };
>  	struct monitor_filter_arg mfa = { 0 };
>  	int i, rc;
> +	FILE *f;
>  
>  	argc = parse_options_prefix(argc, argv, prefix, options, u, 0);
>  	for (i = 0; i < argc; i++) {
> @@ -630,8 +631,16 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
>  		else if (strncmp(monitor.log, "./standard", 10) == 0)
>  			; /*default, already set */
> -		else
> +		else {
> +			f = fopen(monitor.log, "a+");
> +			if (!f) {
> +				error("open %s failed\n", monitor.log);
> +				rc = -errno;
> +				goto out;
> +			}
> +			fclose(f);
>  			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
> +		}

In log_file(), the log file does fallback to syslog if the fopen() fails.
In my understanding here is that the fallback is needed to save in case of
the monitor.log in trouble for example, the parent directory is removed.
And, the new fopen() check, you have added by this patch, to inform the
invalid log path for users.

Is my understanding correct? If so, make sense to me. 
Please feel free to add:

    Reviewed-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Thanks,
Masa

>  	}
>  
>  	if (monitor.daemon) {
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

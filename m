Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 181062098EABD
 for <linux-nvdimm@lists.01.org>; Wed,  1 Aug 2018 11:14:36 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id b15-v6so20930712qtp.11
 for <linux-nvdimm@lists.01.org>; Wed, 01 Aug 2018 11:14:36 -0700 (PDT)
Subject: Re: [ndclt PATCH] ndctl, monitor: Fix duplicate prefix in monitor.log
References: <20180731051503.30719-1-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <533dc62c-bac1-15aa-0e8d-bc444e8ef06b@gmail.com>
Date: Wed, 1 Aug 2018 14:14:36 -0400
MIME-Version: 1.0
In-Reply-To: <20180731051503.30719-1-qi.fuli@jp.fujitsu.com>
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

Hi QI,

On 07/31/2018 01:15 AM, QI Fuli wrote:
> When a monitor runs with [--log] option, the prefix will be dually
> added to monitor.log. Therefore, the monitor cannot log the smart
> notification to syslog. This patch is used to prevent prefix from
> being dually added to monitor.log.
> 
> Fixes: fdf6b6844ccf ("ndctl, monitor: add a new command - monitor")
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/monitor.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index c6419ad..4e5daf5 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -614,7 +614,8 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  		goto out;
>  
>  	if (monitor.log) {
> -		fix_filename(prefix, (const char **)&monitor.log);
> +		if (strncmp(monitor.log, "./", 2) != 0)
> +			fix_filename(prefix, (const char **)&monitor.log);

prefix is not needed to 'syslog' and 'standard', so why don't you move the strncmp()
before fix_filename(), like as:

@@ -614,13 +619,14 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
                goto out;
 
        if (monitor.log) {
-               fix_filename(prefix, (const char **)&monitor.log);
                if (strncmp(monitor.log, "./syslog", 8) == 0)
                        ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
                else if (strncmp(monitor.log, "./standard", 10) == 0)
                        ; /*default, already set */
-               else
+               else {
+                       fix_filename(prefix, (const char **)&monitor.log);
                        ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_file);
+               }
        }
 
        if (monitor.daemon) {

Thanks,
Masa

>  		if (strncmp(monitor.log, "./syslog", 8) == 0)
>  			ndctl_set_log_fn((struct ndctl_ctx *)ctx, log_syslog);
>  		else if (strncmp(monitor.log, "./standard", 10) == 0)
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

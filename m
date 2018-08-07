Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x243.google.com (mail-qt0-x243.google.com
 [IPv6:2607:f8b0:400d:c0d::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 31F95210DA7A8
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 11:39:51 -0700 (PDT)
Received: by mail-qt0-x243.google.com with SMTP id f18-v6so19030303qtp.10
 for <linux-nvdimm@lists.01.org>; Tue, 07 Aug 2018 11:39:51 -0700 (PDT)
Subject: Re: [ndctl PATCH 3/4] ndctl, monitor: add timestamp and pid to log
 messages in log_file()
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
 <20180807131756.23673-4-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <bed6c181-1316-4506-c2b6-113eea1f13ce@gmail.com>
Date: Tue, 7 Aug 2018 14:39:47 -0400
MIME-Version: 1.0
In-Reply-To: <20180807131756.23673-4-qi.fuli@jp.fujitsu.com>
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
> This patch is used to add timestamp and process id to log messages when logging
> messages to a file.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/monitor.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c
> index 2f3d751..d29e378 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -84,6 +84,8 @@ static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
>  {
>  	FILE *f;
>  	char *buf;
> +	struct timespec ts;
> +	char timestamp[32];
>  
>  	if (vasprintf(&buf, format, args) < 0) {
>  		fail("vasprintf error\n");
> @@ -99,7 +101,14 @@ static void log_file(struct ndctl_ctx *ctx, int priority, const char *file,
>  		notice(ctx, "%s\n", buf);
>  		goto end;
>  	}
> -	fprintf(f, "%s", buf);
> +
> +	if (priority != LOG_NOTICE) {

Why is the timestamp not needed in case of LOG_NOTICE...?

> +		clock_gettime(CLOCK_REALTIME, &ts);
> +		sprintf(timestamp, "%10ld.%09ld", ts.tv_sec, ts.tv_nsec);
> +		fprintf(f, "[%s] [%d] %s", timestamp, getpid(), buf);

What is the pid for...?

Thanks,
Masa

> +	} else
> +		fprintf(f, "%s", buf);
> +>  	fflush(f);
>  	fclose(f);
>  end:
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

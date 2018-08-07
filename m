Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 990BA210DA7A8
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 11:41:50 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id d4-v6so19026076qtn.13
 for <linux-nvdimm@lists.01.org>; Tue, 07 Aug 2018 11:41:50 -0700 (PDT)
Subject: Re: [ndctl PATCH 4/4] ndctl, monitor: add [Install] Section to
 systemd unit file of ndctl-monitor
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
 <20180807131756.23673-5-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <73987eec-074b-9965-5d05-b5bdf31a7b6c@gmail.com>
Date: Tue, 7 Aug 2018 14:41:47 -0400
MIME-Version: 1.0
In-Reply-To: <20180807131756.23673-5-qi.fuli@jp.fujitsu.com>
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

Looks good to me. Please free to add:

    Reviewed-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Thanks,
Masa

On 08/07/2018 09:17 AM, QI Fuli wrote:
> This patch is used to add "[Install]" section to systemd unit file of
> ndctl-monitor. Therefore, users can set ndctl-monitor unit enable.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/ndctl-monitor.service | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
> index 44f9326..342a1b1 100644
> --- a/ndctl/ndctl-monitor.service
> +++ b/ndctl/ndctl-monitor.service
> @@ -5,3 +5,6 @@ Description=Ndctl Monitor Daemon
>  Type=forking
>  ExecStart=/usr/bin/ndctl monitor --daemon
>  ExecStop=/bin/kill ${MAINPID}
> +
> +[Install]
> +WantedBy=multi-user.target
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8BD41211E2EF3
 for <linux-nvdimm@lists.01.org>; Mon,  1 Apr 2019 12:30:53 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] monitor: removing the requirement of default config
Date: Mon, 1 Apr 2019 19:30:51 +0000
Message-ID: <37ead1c68bee8618e235dca3f0059ed83f84af5c.camel@intel.com>
References: <20190329110150.3725-1-qi.fuli@jp.fujitsu.com>
 <cda88d4b0faf32de5ed449bc648f1a684337154d.camel@intel.com>
 <OSAPR01MB49936987822E8585110E83D0F7550@OSAPR01MB4993.jpnprd01.prod.outlook.com>
In-Reply-To: <OSAPR01MB49936987822E8585110E83D0F7550@OSAPR01MB4993.jpnprd01.prod.outlook.com>
Content-Language: en-US
Content-ID: <2396D09AA3D778479387F1F15B3A34FE@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2019-04-01 at 06:20 +0000, qi.fuli@fujitsu.com wrote:
> 
> Hi Vishal,
> 
> Thanks for your comment.
> I think it might be misunderstood.
> 
> Current scenario is:
> 1. Check if "-c <file>" option is provided
>   a. if it is, make the <file> as config_file
>   b. if it is not, make default configuration file(/etc/ndctl/monitor.conf) as config_file
> 2. Try to read options from config_file
>   a. if config_file cannot be opened, then check if "-c" option is provided
>    (1) if it is, stop starting monitor (user may make a wrong <file> in "-c" option)
>    (2) if it is not, finish read_config_file (default configuration file(/etc/ndctl/monitor.conf) is missing)
>   b. if config_file can be opened successfully, merge the options from config_file with cli options
> 
> It is consistent with the ideal scenario as you mentioned.

Hi Qi,

Looking at it in more detail, I see you're right.
I've applied the patch - thanks for the explanation.

> 
> Thanks,
> QI Fuli

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm

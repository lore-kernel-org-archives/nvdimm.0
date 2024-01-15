Received: from esa2.hc1455-7.c3s2.iphmx.com (esa2.hc1455-7.c3s2.iphmx.com [207.54.90.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2114622
	for <nvdimm@lists.linux.dev>; Mon, 15 Jan 2024 00:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
X-IronPort-AV: E=McAfee;i="6600,9927,10953"; a="146087837"
X-IronPort-AV: E=Sophos;i="6.04,195,1695654000"; 
   d="scan'208";a="146087837"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa2.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2024 09:12:51 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 1EDEFD4F60
	for <nvdimm@lists.linux.dev>; Mon, 15 Jan 2024 09:12:48 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 547AFD5EA5
	for <nvdimm@lists.linux.dev>; Mon, 15 Jan 2024 09:12:47 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id E5EC3200988C9
	for <nvdimm@lists.linux.dev>; Mon, 15 Jan 2024 09:12:46 +0900 (JST)
Received: from [10.167.214.93] (unknown [10.167.214.93])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 4A5CF1A0072;
	Mon, 15 Jan 2024 08:12:46 +0800 (CST)
Message-ID: <9f986f79-8e6f-1878-2210-dd06455108c2@fujitsu.com>
Date: Mon, 15 Jan 2024 08:12:46 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [NDCTL PATCH 1/2] daxctl: Don't check param.no_movable when
 param.no_online is set
To: "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>
Cc: "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>
References: <20230810053958.14992-1-yangx.jy@fujitsu.com>
 <TYCPR01MB10023816C66F638C16336F35383CEA@TYCPR01MB10023.jpnprd01.prod.outlook.com>
From: Xiao Yang <yangx.jy@fujitsu.com>
In-Reply-To: <TYCPR01MB10023816C66F638C16336F35383CEA@TYCPR01MB10023.jpnprd01.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28120.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28120.003
X-TMASE-Result: 10--16.383000-10.000000
X-TMASE-MatchedRID: 4RkzoBnX1FuPvrMjLFD6eN5x7RpGJf1aNr21mij50NtWjSWvFszxq8Lm
	p4jPUF8tPxyQpyShsoOGj0VkVb9wHTmpL9mXE1+sHmtCXih7f9PRTRRZJlWEClGJGXffuLdvkrI
	9/WPu3jdqw4mhfH/Cj+affHI8kAmiHY/bzRmIaZHNgrlT5Ajc7sMKxxeacM3vU4mv3PbL0POjxY
	yRBa/qJQYnglAWdCYbt7DW3B48kkH9YSi3l/zUQwU5rQ/jDZbqjoczmuoPCq2U1ZAiT2qRgc0+A
	RBQn3H1Ov4eNYcnsJHc51O5xqd32nTRp0/jatHS
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Hi All,

Ping, is there any feedback on this patchset?

Best Regards,
Xiao Yang

On 2023/10/9 17:40, Yang, Xiao/杨 晓 wrote:
> Ping
> 
> -----Original Message-----
> From: Xiao Yang <yangx.jy@fujitsu.com>
> Sent: 2023年8月10日 13:40
> To: vishal.l.verma@intel.com; nvdimm@lists.linux.dev
> Cc: linux-cxl@vger.kernel.org; Yang, Xiao/杨 晓 <yangx.jy@fujitsu.com>
> Subject: [NDCTL PATCH 1/2] daxctl: Don't check param.no_movable when param.no_online is set
> 
> param.no_movable is used to online memory in ZONE_NORMAL but param.no_online is used to not online memory. So it's unnecessary to check param.no_movable when param.no_online is set.
> 
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
> ---
>   daxctl/device.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/daxctl/device.c b/daxctl/device.c index 360ae8b..ba31eb6 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -711,7 +711,7 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
>   	const char *devname = daxctl_dev_get_devname(dev);
>   	int rc, skip_enable = 0;
>   
> -	if (param.no_online || !param.no_movable) {
> +	if (param.no_online) {
>   		if (!param.force && daxctl_dev_will_auto_online_memory(dev)) {
>   			fprintf(stderr,
>   				"%s: error: kernel policy will auto-online memory, aborting\n",
> --
> 2.40.1
> 

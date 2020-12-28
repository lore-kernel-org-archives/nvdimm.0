Return-Path: <SRS0=loEu=GA=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_40,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFFBC433DB
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Dec 2020 17:43:12 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 592D520684
	for <linux-nvdimm@archiver.kernel.org>; Mon, 28 Dec 2020 17:43:12 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 592D520684
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 11EE9100EBB6E;
	Mon, 28 Dec 2020 09:43:12 -0800 (PST)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=134.134.136.31; helo=mga06.intel.com; envelope-from=ira.weiny@intel.com; receiver=<UNKNOWN> 
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id DFC36100EBB63
	for <linux-nvdimm@lists.01.org>; Mon, 28 Dec 2020 09:43:09 -0800 (PST)
IronPort-SDR: hdSanteGqEJfjkGY5yWSpzTkc8D3BA2iICu8c8Mpld1rmAA5ZyVi+Ke1fhJxJqmfpuykR9D668
 A7xoXhD9I+jg==
X-IronPort-AV: E=McAfee;i="6000,8403,9848"; a="237960342"
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400";
   d="scan'208";a="237960342"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2020 09:43:08 -0800
IronPort-SDR: F5CMZyuHAD4hnshPmL9bZfxt4ZF2jfJzT3LYS4YeeTIXxUumlDvvaC5pcGxSHLmg4wfsQznNrG
 hLTAG0bRRItQ==
X-IronPort-AV: E=Sophos;i="5.78,455,1599548400";
   d="scan'208";a="347068078"
Received: from iweiny-desk2.sc.intel.com (HELO localhost) ([10.3.52.147])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Dec 2020 09:43:04 -0800
Date: Mon, 28 Dec 2020 09:43:04 -0800
From: Ira Weiny <ira.weiny@intel.com>
To: Tian Tao <tiantao6@hisilicon.com>
Subject: Re: [PATCH] nvdimm: Switch to using the new API kobj_to_dev()
Message-ID: <20201228174304.GP1563847@iweiny-DESK2.sc.intel.com>
References: <1608867065-52320-1-git-send-email-tiantao6@hisilicon.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1608867065-52320-1-git-send-email-tiantao6@hisilicon.com>
User-Agent: Mutt/1.11.1 (2018-12-01)
Message-ID-Hash: HOLEZSRJQRXA4ES35CKLFY6WVGENJPH6
X-Message-ID-Hash: HOLEZSRJQRXA4ES35CKLFY6WVGENJPH6
X-MailFrom: ira.weiny@intel.com
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
CC: linux-nvdimm@lists.01.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/HOLEZSRJQRXA4ES35CKLFY6WVGENJPH6/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Fri, Dec 25, 2020 at 11:31:05AM +0800, Tian Tao wrote:
> fixed the following coccicheck:
> drivers/nvdimm//namespace_devs.c:1626:60-61: WARNING opportunity for
> kobj_to_dev().
> drivers/nvdimm//region_devs.c:762:60-61: WARNING opportunity for
> kobj_to_dev().
> 
> since container_of(kobj, typeof(*dev), kobj) and
> container_of(kobj, struct device, kobj) are the same, so also
> replace container_of(kobj, typeof(*dev), kobj) with the new kobj_to_dev.
> 
> Signed-off-by: Tian Tao <tiantao6@hisilicon.com>

Reviewed-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  drivers/nvdimm/bus.c            | 2 +-
>  drivers/nvdimm/core.c           | 2 +-
>  drivers/nvdimm/dimm_devs.c      | 4 ++--
>  drivers/nvdimm/namespace_devs.c | 2 +-
>  drivers/nvdimm/region_devs.c    | 4 ++--
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
> index 2304c61..cf2b70b 100644
> --- a/drivers/nvdimm/bus.c
> +++ b/drivers/nvdimm/bus.c
> @@ -713,7 +713,7 @@ static struct attribute *nd_numa_attributes[] = {
>  static umode_t nd_numa_attr_visible(struct kobject *kobj, struct attribute *a,
>  		int n)
>  {
> -	struct device *dev = container_of(kobj, typeof(*dev), kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  
>  	if (!IS_ENABLED(CONFIG_NUMA))
>  		return 0;
> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index 7de592d..431e47a 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -503,7 +503,7 @@ static DEVICE_ATTR_ADMIN_RW(activate);
>  
>  static umode_t nvdimm_bus_firmware_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
> -	struct device *dev = container_of(kobj, typeof(*dev), kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  	struct nvdimm_bus *nvdimm_bus = to_nvdimm_bus(dev);
>  	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
>  	enum nvdimm_fwa_capability cap;
> diff --git a/drivers/nvdimm/dimm_devs.c b/drivers/nvdimm/dimm_devs.c
> index b59032e..76ee2c3 100644
> --- a/drivers/nvdimm/dimm_devs.c
> +++ b/drivers/nvdimm/dimm_devs.c
> @@ -418,7 +418,7 @@ static struct attribute *nvdimm_attributes[] = {
>  
>  static umode_t nvdimm_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
> -	struct device *dev = container_of(kobj, typeof(*dev), kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  	struct nvdimm *nvdimm = to_nvdimm(dev);
>  
>  	if (a != &dev_attr_security.attr && a != &dev_attr_frozen.attr)
> @@ -534,7 +534,7 @@ static struct attribute *nvdimm_firmware_attributes[] = {
>  
>  static umode_t nvdimm_firmware_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
> -	struct device *dev = container_of(kobj, typeof(*dev), kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
>  	struct nvdimm_bus_descriptor *nd_desc = nvdimm_bus->nd_desc;
>  	struct nvdimm *nvdimm = to_nvdimm(dev);
> diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
> index 6da67f4..1d11ca7 100644
> --- a/drivers/nvdimm/namespace_devs.c
> +++ b/drivers/nvdimm/namespace_devs.c
> @@ -1623,7 +1623,7 @@ static struct attribute *nd_namespace_attributes[] = {
>  static umode_t namespace_visible(struct kobject *kobj,
>  		struct attribute *a, int n)
>  {
> -	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  
>  	if (a == &dev_attr_resource.attr && is_namespace_blk(dev))
>  		return 0;
> diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
> index ef23119..92adfaf 100644
> --- a/drivers/nvdimm/region_devs.c
> +++ b/drivers/nvdimm/region_devs.c
> @@ -644,7 +644,7 @@ static struct attribute *nd_region_attributes[] = {
>  
>  static umode_t region_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
> -	struct device *dev = container_of(kobj, typeof(*dev), kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  	struct nd_region *nd_region = to_nd_region(dev);
>  	struct nd_interleave_set *nd_set = nd_region->nd_set;
>  	int type = nd_region_to_nstype(nd_region);
> @@ -759,7 +759,7 @@ REGION_MAPPING(31);
>  
>  static umode_t mapping_visible(struct kobject *kobj, struct attribute *a, int n)
>  {
> -	struct device *dev = container_of(kobj, struct device, kobj);
> +	struct device *dev = kobj_to_dev(kobj);
>  	struct nd_region *nd_region = to_nd_region(dev);
>  
>  	if (n < nd_region->ndr_mappings)
> -- 
> 2.7.4
> 
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

Received: from CY3PR05CU001.outbound.protection.outlook.com (mail-westcentralusazon11013010.outbound.protection.outlook.com [40.93.201.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A17377A83
	for <nvdimm@lists.linux.dev>; Fri,  7 Aug 2026 05:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.201.10
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786079463; cv=fail; b=RGfGnFMN1r8ufa4iwhqkfRX8X4d2QNL7cDYMH53jF9hZSiDGnBSz1/WEYKQe4JqSiIvfxy+0k1Qt83BIAR5ohH8kMrzJLruH/tDle76nIAUm0VBgSwWRuOcHT8C3yfxJSJMRzXqT3Ym5EqtIVzEbXpMLbV5lZvWJyxBr0AzsdRQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786079463; c=relaxed/simple;
	bh=RdXyW1uTKq3/y33EYw0a+4SdcMq6mv0JD58Cjf6Layc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Y4CGNCD4huZEX9gHUXsEi9pmgU3iu5VPHlPwarg2k3jnaFNSGCr0vXT+AaeHkbOyGwm3p3knAQ4knJgd6fOTBbIt6XrdOvm/uCYl9ubEGI0r1b9YUAPHnzEMKGQ01Xi0Gzmyk/wdXKSurN5Jj6IThOlKH/Kc23UVJgMuJY6kPQQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=mnk8DPPj; arc=fail smtp.client-ip=40.93.201.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="mnk8DPPj"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=bOvp6gfuadJYBdqklz8cTjkstf+HltJOeC2tLIoCiiTOPvwPNbFZIbOXTQOXJrW0+SNJBVjojOPvfLKVw/4y1nhtsvPrwUvNXqdXuyMXN4HRQBSupIiimJDOKhrx0LpgOLib6qUlx4bUqf9F8XxQKkhUzRvteKSKvgjshc2ciZBQUtae13PzpKERz34P7mBv1JWtsT4IQUb901iv/TXr9YdtuhbrF1ajC9bmONvc6+iazaKzrd4cE7vXm90VJGsfCoe3vgib0gqx/PFaViHexTtb59WmX7EngW6NtmMMetHbHWQMIvgCjOw+vqBsOYwuHDlR31cpu0iFAzOQ1tpIeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=eOa5zj0k48853Znjmj+qHJmlyQgIr0lrNKNfIQT2GtQ=;
 b=HPSYzUUwlxBWdNsCA0wjfteb6YDahDY6+NJaDrbqSMsYeUXghhPxp/hioITkLpDjXUpipWHCxkkt5itVxi7qJwJYqvL6iXixYDFwb7eID0Vj3+VlopJYhG1jcI5bzwPq4Gxq6xwrLJpW2N3Caw1tIBXnIJs1w8ci6knUlOqJMRJQSUxQFv2ky1SlLCf3ZQz0dfbPfTK3z4xe3APZbn9qh8vGdvgwQauL2qlqZUg9/PYxC1ogI644pKJpl2/ekXB5oKKKRhuamCtFlJvJBS58A6RyU2tKuvyMCb8keMwaZcCxHHOlxT4tAKbOEwcVCJa7tzy4UKMjubO6mZsE8hlgyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eOa5zj0k48853Znjmj+qHJmlyQgIr0lrNKNfIQT2GtQ=;
 b=mnk8DPPj2iSpD7POWpUNFU2FVbzF69x6L3Ek7Cc7MSGQe5I5FzPmxoQM47+eAh4tk5s58cEo2+0vz1Ag40bBEC8Js0S+Gbzm5EFDvplbhRDwK7KsayZA/xj4KUj+152RRMgQZHCsAtMCyQlWppRtBlEwaLStjgOwVVaqdg4nWkMzy4ud9BAW6J+l9WVvf0GWDKbdGDLaq6reTWwN/iY0uelL+gS+iskQ6awbClZAz+mf0AXCCTcLFWs7OuQ0hll6zqJhqstKH4qeZXw4DPZK97ErFy1fI5iKBd2HgiZP6KaexL7LpOVXp2lWBvzS27zCfAgDszYiIWuP2LcX9qIOLw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by BY5PR12MB4099.namprd12.prod.outlook.com (2603:10b6:a03:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 05:10:53 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 05:10:53 +0000
Date: Fri, 7 Aug 2026 13:10:47 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 2/2] cxl/list: list locked zero-sized decoders
Message-ID: <anVoHcsukSEELpCi@MWDK4CY14F>
References: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
 <018112d2f7890f3a3f38cc96aee5cf98cf5f3a9d.1785462417.git.alison.schofield@intel.com>
 <af3d9c4b-749a-4146-be80-210e6a1c0643@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3d9c4b-749a-4146-be80-210e6a1c0643@intel.com>
X-ClientProxiedBy: SI1PR02CA0039.apcprd02.prod.outlook.com
 (2603:1096:4:1f6::9) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|BY5PR12MB4099:EE_
X-MS-Office365-Filtering-Correlation-Id: 8dbf1805-36f1-4416-a608-08def4424124
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|11063799006|5023799004|56012099006|4143699003|10067099003;
X-Microsoft-Antispam-Message-Info:
	ekm38Gsu8u+lk25lz9Y0eOrZexi7cCXEBbPsIKv3XxQs6k7/Vu1PY98fzs3RJ/7NtUVy0rt4AQpyDBNs6bKdUlRsHsc6iS2+e7si8yomKWPLyYw8exFA4NhxYxBuFaSq2IVoF3gaHrTuFZrzJsrqs6cI8kLz2pMOcLyW5fN5Qey6iuyZtNMYXHLcbOAnHCbl88hfA2GQnFunHC5Mxy+i1CHUE5b+h5r2M0pZ2AYD23crXLwuukRMrhVXAsBfFzd12dcjZAW2+TFNblE/4yA7SZ8XQoMPcvMI90WChfEW2o8+mPEIeNrmB6RNGQ1i4cmcqQkhsfj5fpaA6+xDn3Sk5rUMhE/9i7XNfa8bdwK1Rnbyt7NFdnd9fUGxUkXTpgymej8KdSlxm9Y7JhYfQKy1ogg8pSwe+6GS/JxpWQkicetXbWDKyC9iqIBJZCi73wxaJvhzHOmzy9ap/ywT2mSPoaCmY4LMmNFvm4emdfgmJNuFEqoRNRrqazjf2/VUhg6kHRcVV94rbWNI339W433DTDZ8jDMmQt4U7uReXxRvx6zJt9J7nFSjHr//EQp9atLWDsvh8k2NXKT1/Fzx2swjHiMQTT86Ugp9uaIfw5ISdv2aaWTZPSUsXvKOoI6xYeChLjMxrCSu7uXk7f18tsby/etHdN6vDzutarxlk/GFvC0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(11063799006)(5023799004)(56012099006)(4143699003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0r8s0fXNlTyMILBVDOQt1jm8ADn3d6bZD343TvY7VI6ZbmPi+QhG41RemGJ0?=
 =?us-ascii?Q?fqc/VZvRMyCcKHKWIWvoZYIQhu4OCr3YoQCxHv5+GwNAKJD44mrqn81rkbMW?=
 =?us-ascii?Q?acPPszZZQgxZJmZ4jl4tnBszLO0oeDZYYNPjenLSFz0ExOco9DdqSbabhQd0?=
 =?us-ascii?Q?0KypEi8bo88E8xhEex/O9gMzKlDBJMk69a1aCY1/BnakLPtWSspOZ4CrUQqG?=
 =?us-ascii?Q?qcTZKqqrFmlPztk7cl6PruJ7DHbrzM2rx7+atPR3IPL43+UYi+f7Hb8Kfcyn?=
 =?us-ascii?Q?HdOpY6c7vy+rBBMXuuWJgRLe3WjJeKTpSZc6ou9CEAdxytItfBuKt5kPRSsX?=
 =?us-ascii?Q?ZyNMS2p0WxGaXIGMyPdlqiHiCWD2GKKQzPA/VzsQI3MUhshySsI5f8gBg6sp?=
 =?us-ascii?Q?l7KyX1GuRlfljo3mlQ9FiHWyWiEiQSp67fqxh7+npotcqwc/L2fo4uDjKM3s?=
 =?us-ascii?Q?Q0eaj0Csy7xvfzrB6lRHxolB+HapcoT/g06qOQx8m2ZDIOsW3J9Q7qv5hGxN?=
 =?us-ascii?Q?8WX/CpBnnTSdeYQlzNcLf+kyJX4VsO8teXqoWLyRdy3vjjiiWyCTTaiAOtZb?=
 =?us-ascii?Q?TFfXIBJA7msaj1EP+CPxyzLHNYWke293t0tDO/nt4iDk5qXzOpi76vBHWlmH?=
 =?us-ascii?Q?m78q4Kn3xwMrYfZDQ25toBaovjVfiv5s6b7TTqJ8vnutcmotWl0CwkHG3lZY?=
 =?us-ascii?Q?wbOFvSp1zKBJpPYy6zj55nh+PtLFh4woV56g/vwDdLp8fz1eRQvnPx85WQ3d?=
 =?us-ascii?Q?At5hxRyTwwCqHh48BfOxge8zgnukos6ZjBgAH+opvCSc3S0fbBsngFS6h+Sb?=
 =?us-ascii?Q?OEITHVJyUOX2H3ybikYvd1kr+kbxIoDam1t9Pw3BCdKQNmZY7BPcOgVp/yxq?=
 =?us-ascii?Q?u3KsBcpP+RI7KSCt0qN7qjgw/8ayAOY2faSFrboy4SQMKu1yErmTTnEPEBfg?=
 =?us-ascii?Q?wW4v2QuGpAdfzI7Nm/JfILHaOIFRMYkQYiATwO1u0MiR13iyHAhC74gYv87J?=
 =?us-ascii?Q?Qvr/7wixolZ2AUYEhQtseVDdj/f63r80J0JHVI4FEZUWp14FwkdIt1txrlEE?=
 =?us-ascii?Q?vfoyD3auE4ZsjUJCQ1yJsKJt4bs1zZ/sPSDAN2Yx9S78tA2HqRfTZqofWhUE?=
 =?us-ascii?Q?KaZh0iEUHTNk17GrDQZ+oVPK8d6857+E6h+nVjYEPl55wePPyj7pKPICdngg?=
 =?us-ascii?Q?Vq0oI+7cRcLXLnQ0J46F0++EiwCIszNzGMFXv6kDXItnQ2aZRytJA6hH6eqs?=
 =?us-ascii?Q?IK2rYlSch2m6kRXBN8kkN5FVLUh16ytVhg7Atq/XFcl6iq0FwsC+vA4F+4Nm?=
 =?us-ascii?Q?tEmcbawAzukIv6W0eCyO60j59hdsOIvI5DFqh/BRi2ugVi0L3mrkHMuvGCAw?=
 =?us-ascii?Q?uoBe2c/VmckkidgvBeOhtzvAsR+Oigxp5CLwJgieixud8LUPTE8U2jwtvtrp?=
 =?us-ascii?Q?4PquPsCduzWavjSkb3DvxxKR/3LkKBtUg4awq+BY2ss+x7wPuo0PwJpkpNS0?=
 =?us-ascii?Q?XvHrLcj3T+/mTmWcGHgj//2dBbkT4XO3vWgJ09HD7/hYp3okCB4I43ZvK8Wf?=
 =?us-ascii?Q?mDP1OE7xYZdA4kc4GwQrkHzOSx1zJK50pexEw3hrZtx4Vy8qEomFXSqFA+j/?=
 =?us-ascii?Q?8g81F8Fzv6BE5PM0WN0E+l1+7+Ovrc5OyBC9pRZWYODV8x7o7dWYbvoxo+9N?=
 =?us-ascii?Q?ZqQkL1z/tm1HP+nuK1lo1YW63zQsgycu6hlZitpZQwGTouOEw/6052tT1gXe?=
 =?us-ascii?Q?LgIR0OQ+lA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8dbf1805-36f1-4416-a608-08def4424124
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 05:10:53.5350
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h7DZq0krpy8AtOqdzCIRMth4BETwfRMNMxPUIPGevKXIBcvw7j73xj5Hs9QQ0jHeCyNPYRd9bBAHxCfxl0/yqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4099

On Fri, Jul 31, 2026 at 08:40:24AM +0800, Dave Jiang wrote:
> 
> 
> On 7/30/26 6:55 PM, Alison Schofield wrote:
> > 'cxl list' hides zero-sized decoders unless --idle is given, assuming
> > they are unconfigured idle slots. That assumption does not hold for
> > locked HDM decoders, which may legitimately report size 0 while being
> > committed by firmware.
> > 
> > Do not suppress locked zero-sized decoders from the default listing.
> > Combined with the "locked" field in the decoder JSON, they are visible
> > and distinguishable from idle, unlocked slots that remain hidden
> > without --idle.
> >

Hi Alison,

patch looks good to me, just one small question,
what if the zero size decoder is programmed by userspace, not from FW.

in which case cxl_decoder_is_locked() won't return true, can we handle that situation ?

Reviewed-by: Richard Cheng <icheng@nvidia.com>
 
Best regards,
Richard Cheng.

> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
> > ---
> >  cxl/filter.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/cxl/filter.c b/cxl/filter.c
> > index 5d634d3b2512..e6d45ac7b9e6 100644
> > --- a/cxl/filter.c
> > +++ b/cxl/filter.c
> > @@ -847,7 +847,8 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
> >  		if (!util_cxl_decoder_filter_by_region(decoder,
> >  						       p->region_filter))
> >  			goto walk_children;
> > -		if (!p->idle && cxl_decoder_get_size(decoder) == 0)
> > +		if (!p->idle && cxl_decoder_get_size(decoder) == 0 &&
> > +		    !cxl_decoder_is_locked(decoder))
> >  			continue;
> >  		jdecoder = util_cxl_decoder_to_json(decoder, flags);
> >  		if (!decoder) {
> 

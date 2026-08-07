Received: from BN1PR04CU002.outbound.protection.outlook.com (mail-eastus2azon11010018.outbound.protection.outlook.com [52.101.56.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFAB37BE99
	for <nvdimm@lists.linux.dev>; Fri,  7 Aug 2026 05:07:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.56.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786079277; cv=fail; b=dnAGW6FKI7Lwe/al45oLZNRVgARjCVOsFfYYye54ZibNEoiKOTRfwdVLfVqiXHBQcxKM3rEpnenXholmG/CSW1DOIMDARc6qw/eY+8vlOFtrqALdk5OiCcGG7HZhtFgABJvW9hgeyFuDLeFkTGI+7lIXbjh5VgpZWPzG7MoVdjo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786079277; c=relaxed/simple;
	bh=qTdbppuUTId/SSL3kWJ+20dFoboQ+TMidyTDjmKoDaM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=EyFkyteXYiLUlCV4LXOMLuzooT22I5RT9Pkfs13P8jrL9r2gTWh65TpCdHfH3zm4meSANANhMFzVaawisKJW0JV6pTEGCxAi2j9nChkI9tc0PIN/ofvUKAbfzEvI4cwLEhsslMVB46u3s/j6MV6WO40U1y+3NjSkLoTJ2ICRNaE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=G7+jmeSy; arc=fail smtp.client-ip=52.101.56.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="G7+jmeSy"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nO7+ROmj+kxTVHb+lBULhIABBAcBijid5yZ0TOwSH1Q8LQif4H9y8Pr3+8LKKJvpbV/BIz81ba4ugJ7xvwjq03JY14wC5BnxHal08q51goLzpmCX6AuU7TvKyqpnipKRET++0drpPlnPeo200S/V/Fasg3gsYRm4mfESE5y4qTelItLa5nbwWqjv4LLDxxEZAsxwia9yJ/72SGJCZ+R+sRHCl8nrQsodHN7djhfbeEkoIjpmN9ZzE3BSb5sd5rbadsbfxtFif/HPKsbiONwgq1lCHpGA0xcuk/3dvOqi9Dy8Vyyh7Q7/H0Btm8AOTPqjWtmIty2UHZoCZmarScQjTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pN5tQ7GqyR95u9RSEMy50/SXg5NVaZntLZkrwDuoMUM=;
 b=yLBGeDwdazmqhktIh5kv5oLcoo5eyz1u6Z4vyFYjPEQH8TDZ/WPpfJkpYg+4JCUiB89WR7AxrfOvSeKVpgQR7wHzjzmZ+Ee2lI9RRew9PhqNgYh5uzv4Fe91uaeqc3ebAMv+sl4GSoIFeGvU+tn9pp5lS4XILYB26HbiGqZae2O2MB6dFPXz+7Qy4hc4blQ6Yf3Cip/LM6EnrWx1EGiTAceFo8xm0e9yHxRfFZqQkEQZTO6yGB5K8L60P02vgGmuwbyUnA34OIwGouqFNpiBOD8OyLR3hAIJSWrOu7/nRqRW8gZzyN3G7k5RgvA6S3Sfz/BJt8QX24PG4XgkrGpRuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pN5tQ7GqyR95u9RSEMy50/SXg5NVaZntLZkrwDuoMUM=;
 b=G7+jmeSyJ0GtNn8pRUWn9GTqo5Pum6hZZM5GB8r8Zh6GSYD4AqstHUGJom9ov54/dkD9jF7VYYdBHDnEUoD2emQNBRHs+QrLSkG2PhS1w/NzigOfxZhyKkKqmWmdGYkVe8u6rPWtfSqDMFj+Wvz/QohW+opcV+J9sprmefC6Br2jLPJrJH0Xf6aPgcs5v6h6sG/9JedpHELm2O2ZTBc8D5pMiQEmjRf15bCvJ0rxjfh7paAv1HbL8CNOuEkzP76c+1/n3EknQZpoQBhImsmhT7RD9ow39IYyb1N2gieQOfQTzM/wamDWMCAHTs32cwZ54ZuBJs+LTQbnPnO3gKCYKg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by BY5PR12MB4099.namprd12.prod.outlook.com (2603:10b6:a03:20f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 05:07:39 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0292.018; Fri, 7 Aug 2026
 05:07:39 +0000
Date: Fri, 7 Aug 2026 13:07:31 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH 1/2] cxl/list: emit decoder locked status
Message-ID: <anVn1VThm2j9s7hZ@MWDK4CY14F>
References: <e144468706798fc68df3be13d1e3321486aca901.1785462417.git.alison.schofield@intel.com>
 <e08b5930-df89-48e6-8288-f0e3e1bd752a@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e08b5930-df89-48e6-8288-f0e3e1bd752a@intel.com>
X-ClientProxiedBy: SI2P153CA0001.APCP153.PROD.OUTLOOK.COM (2603:1096:4:140::7)
 To BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|BY5PR12MB4099:EE_
X-MS-Office365-Filtering-Correlation-Id: 209e44e9-369f-42e1-1c4f-08def441cd63
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|22082099003|18002099003|11063799006|56012099006|4143699003|3023799007|6133799003|10067099003;
X-Microsoft-Antispam-Message-Info:
	cyURKm+3i+PLJnWN+aKEY1P9JFEcknjtoFSlmmZfmIhS7GgN5FseunJnK1O5qfoJUYBejIcUJXMvjhhSda8EzMNVAZvQ6NXnmT38n7UFXo7unisdra44viUc+cto9/4/5f4HPAoD5qN65eGPecCMHO6ns1E41Mwr+NmJ2H8ff+4RHm/wRBjvaXWIJ4ZsIp2r4DVhHMkLutpTDYltjm/vK/cGcintBVxlE3aa0ZVtoECmZNHW/PzelvLisg2fAwrH6nbR/y0l6MSWlyzdx4poVQ9cEymo2ZGUy0pep8bqGwKsrRH/sUQszqLPpRU/PnZCOeXNBILYy28HZvaUhihat9Nfqf+1AylZd/uzn9h3SMRgy7Vq3s1g4TnYh7BpTlMogTVybBfXJZbgZaFWZ5cfcwSAt6Rk2JZDymbO0c8RWOGHyjQux5+sxC5BrDX7xOKRCpKP7WIwKvwNtVvLzY59TjTL1D1Giq+MgFx9hILb/a9iAOf4Bz1/YG+aF+3bmVZIhbKhnUUk38vt2qMt+TZi25+sJg6VAF/FhcX1xGr56nrs40NODCwQ4RA4W65c8XgiI3mH/mPByTcQcXCxw0lxHlbyuIMg/h0buU2P0gzBew/yISOmB1yK/WYfUOIEmeZ/OewFpQ2e5pkCZnfqDTUeW5y2NiADuC8rJnqebBMMrGo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(22082099003)(18002099003)(11063799006)(56012099006)(4143699003)(3023799007)(6133799003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cLJtKM0t/Dy+SQJM+M1zxCissCzEuc5c4VdE9Hk5/Z302OrWXv+DZtrB0+EU?=
 =?us-ascii?Q?523vDVu6piZx3Qc/D8oEWK0imj5DRqEVPJ5gVS7Y1gG3kC3Y0MZlNFBriA5/?=
 =?us-ascii?Q?C1do3sU25pGmfOugjVRMIeLKI2OuiX7f3Tx4R8z5ogVZEwm2Kr8aBZIR2smN?=
 =?us-ascii?Q?dM7fUpkeNlW35yxk0555MqzWuiyD5Q+aCxiKmTtd2bDx1hc/39lKupuWMc38?=
 =?us-ascii?Q?iorN8gEh7YP3JbK1OxsEA4bLJUxrlXen6XhEEvXx946r6rdk1UIpoUkufhJm?=
 =?us-ascii?Q?fyawQu9aHMw9xt/EUCKqDABkjtzlENTkAP/rhfUNt5aWQpRKSsjN18Gu1DuT?=
 =?us-ascii?Q?LXMNuTgZnnZHvX5B1S4aqQH5nky7wERyqc6lt76xqNmlcNDghD3dKB4Jo2UA?=
 =?us-ascii?Q?B1nb03TGnHtCAwaUKZbtc4jFQGKg2cPWxbICSDe2trl85KCM/Yy+PK8B5W91?=
 =?us-ascii?Q?LxhlIvFZXlukwhkGnSGDn+/YL+WF5p6wGb8t1C5TXSM55No0mnRmvnQq6CiU?=
 =?us-ascii?Q?X9NKEjwLcm/cMsjfeOL1hhSS6s94d5lAASzmjn4NfUd3pLz/7rUYil4c6CGv?=
 =?us-ascii?Q?gXxZJ8yqTa89di76zdeCcWaxNL6sf1wrMphG9uvRYLPsoPRRut/vCiU7op9U?=
 =?us-ascii?Q?LYKJDO6yJibWvQSRa0ZqPZjnaGUBnd4s6nS8DTObG6wGBfngS1a2P3mvJnMl?=
 =?us-ascii?Q?hFnXIqBpcx07ohVEazUXOM+yf98klnqwiDeDdCVm/aGpn878p/vJ6foGYolL?=
 =?us-ascii?Q?l3Jn9gt8Y8lDPth+YX22adODU8ICJR3MI2PxtscT5s7zv7g67Qi3cC4Aq5SS?=
 =?us-ascii?Q?y57fLGJxwe/XP/uQ+WlbqASL2ur9SgDBaDSShsi7hFKnPivCGFzpIi4M4Gts?=
 =?us-ascii?Q?FpPpIj0Gl91YfFZSNDjqfm4fIJpJJV6bjATaDYEgleEKoSRhSs/Rut0U2wnU?=
 =?us-ascii?Q?QhPTwJt5j0/orayGiKZZ9m8PiOiexDq61+R5z0QstwUJulzZlG21rTdXcCkH?=
 =?us-ascii?Q?lGiU6tMyJNJ+97pXwiJT/otR1spI72+2JQ3BjkuRf7pGAoNqPiFe73rYOwox?=
 =?us-ascii?Q?Rf7cRdqo9WL4RscwLMvQySTprTZ2KHCs51QfuxWTjXsMraP3I8K8vF46YC8c?=
 =?us-ascii?Q?09qwEJBtvFcu/eO/bHwAhINZj54G/saiZzjVPrCZMYMWjPO1B02QL0DSDPNd?=
 =?us-ascii?Q?hlCe2nQLQxB1qpA5FAcwQX0aBU3T5OpIPaO9yUR82oE9FhWizbS1QN2eIHRi?=
 =?us-ascii?Q?U2ajng0xSr01XO03fioHQbINqSs8mXMTEueXazW72eRieabQ3zvP88zIeC4X?=
 =?us-ascii?Q?xBxx7OXkdO8r0QAsw8q5LzBTlQ6d20qAgKGCEniD+Kx4HEJeqlcZqoTcACvT?=
 =?us-ascii?Q?ylRHA3IKrgdSmwFXB6EydYwoN/yxCyQjbeZJIgvcPQkKWb3dypwVZiFFtLVc?=
 =?us-ascii?Q?BAR42yA27xNmeptnzlBn7RkavaP8nW5oAJkpJ6okmAO+Vu7e8R4hUTGlrLnp?=
 =?us-ascii?Q?eWQgWck5OGUw1Sff5iwEkNfroAJsfQgWvyi1vsKzFeW4vOySgTC4uhK9+Rbq?=
 =?us-ascii?Q?IEeImG8jJwivxnPn8XhNW22aQuRVFs9f6AF14FQREpCJVhwgI6uhfjnMBXW9?=
 =?us-ascii?Q?6sdR5Z9QS93f1jqCMTpYffHDFIRnylIuDW8u76+94894K2Wa7lapiSB1CfFT?=
 =?us-ascii?Q?FOC+EAevEBVAQpkKWLKxbIUwIjVz5CpM3MKTQFcRMI9+ydoOoxa9m7DU0MB1?=
 =?us-ascii?Q?9Fq2pa/ZSQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 209e44e9-369f-42e1-1c4f-08def441cd63
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 05:07:39.5890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uWd3sEKVHFxW744OpuaBnacusu5an7ohvaCHJqtPy/j3w8RY5oL82TWulvnLJBu95ZiSPhbsQfe+NayewtX8JQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4099

On Fri, Jul 31, 2026 at 08:40:08AM +0800, Dave Jiang wrote:
> 
> 
> On 7/30/26 6:55 PM, Alison Schofield wrote:
> > A committed zero-sized HDM decoder reports size 0, so 'cxl list'
> > renders it identically to an ordinary unconfigured decoder ("state":
> > "disabled"). The locked attribute that distinguishes firmware-committed
> > decoders is not included in the JSON output.
> > 
> > The library already reads the decoder's locked attribute and exports
> > cxl_decoder_is_locked(); it was simply never emitted. Add a "locked"
> > field to the decoder JSON, following the emit-only-when-true idiom used
> > by the capability flags so existing output is unchanged for the common
> > unlocked case.
> > 
> > Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
>

Thanks alot !

Reviewed-by: Richard Cheng <icheng@nvidia.com>

Best regards,
Richard Cheng.
 
> > ---
> >  cxl/json.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/cxl/json.c b/cxl/json.c
> > index a92548828582..2214f7027d91 100644
> > --- a/cxl/json.c
> > +++ b/cxl/json.c
> > @@ -870,6 +870,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
> >  			json_object_object_add(jdecoder, "state", jobj);
> >  	}
> >  
> > +	if (cxl_decoder_is_locked(decoder)) {
> > +		jobj = json_object_new_boolean(true);
> > +		if (jobj)
> > +			json_object_object_add(jdecoder, "locked", jobj);
> > +	}
> > +
> >  	if (cxl_port_is_endpoint(port)) {
> >  		enum cxl_decoder_mode mode = cxl_decoder_get_mode(decoder);
> >  
> 

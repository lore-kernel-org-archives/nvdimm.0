Received: from CY7PR03CU001.outbound.protection.outlook.com (mail-westcentralusazon11010000.outbound.protection.outlook.com [40.93.198.0])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501483537E8
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 23:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.198.0
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779233256; cv=fail; b=f0M0FJjEXqmHEaIfkrMLj+S+YkH6SXDc7ci8nMjY8qrOWkS3lDX0xSRcPxLxm47pbeEr4ZwdvS/gkLMCIeag5aTxfqH6YwVeCF8JxT9nJVNgE5BgmOlzndaH2yjSSzzXiqkJ/XxQup8ofRlPo1cHBtbUMMYRA+vsXO3bsQG6D5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779233256; c=relaxed/simple;
	bh=FLrA3E9KTFWMyoeVdKxWeQnb2p8JhXmQRT3PAalpKzw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=Qi7FqYUombmDm+7GLzRDp5NNgCy89Z5OZU9dtvwcFQvYZg03YRxG7C7kvqgarD4acA+xR/HUCeYXeaNzygN8PHx+YVyR7zPzeN/R6CQEwgUBu3Ip4iImpNXd5HQWzaSVCDolBuVLkx/Tk0aqt8ToMTuhUy9qW2cSs/MRxqWR7ZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=PR0it+Yp; arc=fail smtp.client-ip=40.93.198.0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="PR0it+Yp"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iJ/vfPyQ4HIfEKiWFsacYoAKWaQ9/pKCzuR45qNfhk4fixmHC1aEt/9+Dr0KueXkQYXQhCWYNp2N8cpoGtLf2zv9CcxrwM2IwEf13F98ImSYpVSRXi2Jj8gcy9b0gt5UtK/kQAe5dylsPdwhnk3RA3si2Lfxej2E5+xvPj5jv3hVf9ZL4vQxFuqjhIinh05LRYoc1xkRMm1879yAfg7egAIECtk1HMwF1sWJeUxykB8rPLvHKUBdVdeAOwqleklLdtckc5MiYZtwRd9O6RKEtFKhGyyWWdTUdLDOpy/NtqazKGX7Vr8ZcxeZYW+K+vhuVWwHRqDkDBTgPnddd5EmZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LOetwIP4V+9giSsAmCJx/KStgLOfOFf/6Rp4EXrm9qg=;
 b=RFPHVMjEJ7Htlxc2ldWgBsaywBVoqzLijKgvIxii6WO4+z1aQx9kMRX6jmOsTkAG9HJad28kJPz7vP5d2tEfUztVS3bZ3wva9nneBK2gFUnOqHbBJ7253rNQD2mTYhrSgyYIANUuFxmssDmyDnNtJwNlQ0acoxFHfWXahLM0b61FThnMisydC9dL6ZyplQ4ygLSG8sigznVUOi0GZlFw6mZx4GTeAd6+A5lIf4oZ34/+3jqMSFWOt1GtOjcUIQ6yMwwAyIG+cef+jhpyZY8krDuinNLHdO25Syb3iwusJjweGCPiGOsb28gy2/rL8Nl1l2Fpmqe6GqXLR7fNImybEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOetwIP4V+9giSsAmCJx/KStgLOfOFf/6Rp4EXrm9qg=;
 b=PR0it+YpKqcCDwDxCm+Anmryksm65xLcKfylltFolPRaKFUE2OLl6V9HHaf1s2FnplmHKXWdcY2xZyO7f4yDP3I6F4Bgp33jgbFR3L83st8Ep0oDtSwcFzVNs0lUsypgPSE/2XEcCk7mtYshOd7M3ukNu8Xm2ow0XH5GKchNOvhK+rbm2Q9aaHlbNVrZKMUGC1NicwrDCw+2I7ApvnXuO94wv9VUXZgQgyDeVVacZUqXUujgA6QNcRKPSGLN7FA5TQflQKdN2tHimYPJfO0r4Fx1JxHjiJO8fb31gzwwDGXZoqcQXygKTP2ICj/5T9U5TuypN3putqbjjgcXZogm2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by CH2PR12MB4263.namprd12.prod.outlook.com (2603:10b6:610:a6::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.48.14; Tue, 19 May
 2026 23:27:29 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0048.013; Tue, 19 May 2026
 23:27:29 +0000
Date: Wed, 20 May 2026 07:27:22 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Tomasz Wolski <tomasz.wolski@fujitsu.com>, 
	smita.koralahallichannabasappa@amd.com, alison.schofield@intel.com, dan.j.williams@intel.com, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pm@vger.kernel.org, nvdimm@lists.linux.dev, ardb@kernel.org, 
	benjamin.cheatham@amd.com, dave.jiang@intel.com, jonathan.cameron@huawei.com
Subject: Re: [PATCH v2] dax/bus: Upgrade resource conflict message to
 dev_err() in alloc_dax_region()
Message-ID: <agzxpMOOT0Mv-Eqz@MWDK4CY14F>
References: <20260519101832.31988-1-tomasz.wolski@fujitsu.com>
 <20260519123112.5b5d34cd@jic23-huawei>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260519123112.5b5d34cd@jic23-huawei>
X-ClientProxiedBy: SI2PR06CA0008.apcprd06.prod.outlook.com
 (2603:1096:4:186::23) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|CH2PR12MB4263:EE_
X-MS-Office365-Filtering-Correlation-Id: ac02d692-e689-4012-8927-08deb5fe319b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|11063799006|56012099003|22082099003|18002099003|4143699003;
X-Microsoft-Antispam-Message-Info:
	NVy4iS6O93NkfFQFVnekSGNu0dxPNuaHFgay/NkdZC87N5NnEK4er7Sr3cjfxp3jPLFYc7VHa29pAmNguFz0EjkHqar19s52ehIt+v4hf3hNTqtNM6AZCNhWAulAiFEjz2oVmP3iM7JG6JnCY1CI+yvMwM8e3sj5eZYItqLD/ldR7LFxCZM69PWHxzab0OW9L8+gFkJFthSMKmYQPrArRrN2hH5brfVFjA8tZHwPtdvLq5ljJ0vT7wvSSKSX09w5kt1Vz/bduo0UvKuGBTdu28tXAmNMax0nMv1cWxFSEwH30uUKesgSRYGvvBo2v347+MODvlRILMSAaHpLUglBFWVr4YfQ3HeiTuuD6ONSMt5uPF/nlyKlHh5Xg3ijg0Eoa0Q3WG+2TzJohXaSpPpt6BcD/B0Jt+eZd0fsFm+VR1HLjL+tu3cmR1FsgOf3/Xily7QX+hOmKiwsfoYo7vaQbDwOZu127X0CcxOMubEBgLbLkztbphP7isatsgTbEAJSDJ/z/PgglhMWWbiZ24YzYV6Y2x98qtiDaO/J8fzi9MfG3SwO+KAyOlLc8roIDULJDzcECiuzDB/Ee4/9h2KUZsMG0mxvjqiYfPPZW+3uGJJr4jfJf3TSoYkVlS9mw2oz/ibys4aeb2h6uoLjz2p6qKwsPJvE5y/qenDwqUexMZR2p79Q38uf+16XlOSruX+SO0Xp21tRkOg7Lc+hho1dYw==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(11063799006)(56012099003)(22082099003)(18002099003)(4143699003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?eko2TXhwRXhSaXdmb2FWeWJQUmc5eHNjaVkweVdyNWFtWWVNbFZsbUVReXhu?=
 =?utf-8?B?THhnY292NFNUNUJYZDZsTFZIMlc0dFdBYkxSM25TWjc2U0k0eVgrOHdWUWZD?=
 =?utf-8?B?VUF0SnhTZ1ZjNyt2QUwxT2JEWkhxOXpLUVZtZk15eTdvMlN3WG9ZVm5FTzlr?=
 =?utf-8?B?dUJkTVFyT2VtVzdTYm9aSXlPaStiRmNGREtReHErcUQxQitZOFR5TXJ1K3M4?=
 =?utf-8?B?emZSQ2ovckNqTENXM0ZJMkdNcEJ1TUw3c1c4Q2lXclhlRC9hazlneENQMGpN?=
 =?utf-8?B?RExFNC9lR0VGdThPWFQ4WEVQS1ZsK1dqTkIxS3JxKzFheG5hVE1XaHNKRFQw?=
 =?utf-8?B?OGVyTEY4MmkzNmZOL3pWMGxRVitQMDJYSEJHcEcvNXFHcFR1WTBoOFRFUTVv?=
 =?utf-8?B?emlwSG9RTFpCZWRrYkQwU2VhcmdOY1V3RjZ3Rmp4Y1M3TXhLdWo0ek5XZFhP?=
 =?utf-8?B?MW9QeWdlTnpUV0xuYmMwajFYV1pkTDMxUm41YmhUdDBoMlA3dTBLclFsNVll?=
 =?utf-8?B?ZWlnVSt6SFNvNExsUVVxVHdmV1RWeFBNbnMyUUNUVDRMSnBlL2NJWUt2VnhG?=
 =?utf-8?B?Z09JMHNYekR0MUdUZkNteVFUeGVzbTh1UkpFOThpcDFqcWdHQlM3aDN6Zkx6?=
 =?utf-8?B?Ums3dTY4d0NsVnZxcjBhMWpHQ3Jycy9LTjlyOVRMeUZwRWx4OFBKL0hETmlx?=
 =?utf-8?B?TWtRMjM2Q1hHNEIzN0ovcm9meENzc29MSkhNMzRYYkI5VEM2NEpRczR2YitM?=
 =?utf-8?B?ZUFOSmFaZUVRUlRJR3J5TGhkQnpoNlVsM0NsSVFJYk44aTlMV29HbHU3eTZi?=
 =?utf-8?B?UTFxSVBpMzMrb1UyN0NxUGYwZ1ZxejY2RUowalVQVGFJZ1RzRHc1WEJaWHFr?=
 =?utf-8?B?ckd6bXZmOGlKUGNVd1AvdWRXYk9nbHkxWDZNbUphQlZoT3BCRjdsc25ObTJr?=
 =?utf-8?B?UTJ1OXljYXhQOS9ibUhiaDRFQkZjSEwwZWxjc01jMmpoc2RZRmxuQTNTckN1?=
 =?utf-8?B?UXhIL250Vnp5bDkvVmsweXNaVjZnZ0tzSDZEY2hVQlkzZzdwa24vQTRPNEdk?=
 =?utf-8?B?TDNzZkVBMzNpYUZmbU41VjFuYXhYTGZieTlINGtBQ1ZFVzEyZ2pMVlNXeEQ1?=
 =?utf-8?B?N3pmcnFyTWdIM2JTYjhGY1BtbU1ZTXU3QWJEQWJpaDRpTmFPbEhDOXVNdFRP?=
 =?utf-8?B?WHN0RWJZMktDM3g0WVpTcThMS1VlSmQyRzl3Mjh6eHF1SlNGaXZVaXB2RUpx?=
 =?utf-8?B?NjMrdUlzeHkxWGdxcTBObS8rMU96NTczLzRxMFlrYlVKbFJZb1MxUW9CNHhi?=
 =?utf-8?B?RVBaN3JrK2QzS3cyYmZoVHlJeGpjcGRjcmJqRTdLZVB2bjNMUlIzSkZ4RHNS?=
 =?utf-8?B?bU9URzdwaXNtZFdIaDM4OWlZNmxUdUh2S3JIZFFHSlhGV2o1cndyZ0lqdmxC?=
 =?utf-8?B?UDBnS3hmQ1B4RHBmL0hBTHkrSEtCYW1HdENxNVh5LzlQK0R6ZW5qOGhReE52?=
 =?utf-8?B?TGMycGZqcFNNSmdEUmxSQWdUSHZ5YnFWQ0NMN2JINGwzWVphUUo0bStZSWlX?=
 =?utf-8?B?dXFWNTBkU2U0MG9ENnlTVWtFcU5udDJXdStSM1JOazYxWVQxQTZaUUwrdUhO?=
 =?utf-8?B?T25wVkpYSExEK200L3FOM0YxUzZCaysyVWwvQUtIZ0d4dFc1NlE5enJqN2Q4?=
 =?utf-8?B?UHlqUVlDNmJDU2xObWIrVGtjU2lsdElSdnA1dWZCQWl5Ymk0UVRqalNJTkw0?=
 =?utf-8?B?SnczNFRvaHNxUlByOVg3a011cDlnbmlqZmlXMnVmZmJBWlRoY2hCT1Ixb0FU?=
 =?utf-8?B?WERoUjBRRkxvMlNXcUFqYldmMk5jR1M4ckJydVltR2JUN1ViMlRzMjYyTElS?=
 =?utf-8?B?UE8rWHhLbHB1d2dOQW92a0FjUGg3NVoyTGVTSjU1SGttR252VGwydkpMbFZT?=
 =?utf-8?B?UDF5SVR3bktFRm1KazlmSm8zaUZ6RDBEbFJFR1h3cXJSRmQxeGxaYnc2TWl6?=
 =?utf-8?B?QitFd0NuZ1EyUEtaUGo3THJGU2JkdVVnVTg1NHIrbkI3TmVPUURlQ1NHV0hZ?=
 =?utf-8?B?KzJETkc4cVJ3SkQ0cEs4djJsOUMyeUpUM0twdEw0dDc4QnVsZm9CR0FxZmsw?=
 =?utf-8?B?Y2RKMUg3S3JTN3N3c3pxSWxZNDlhdjhmbGxZVDNQU0xqYTV1NUd2VHUrcXo3?=
 =?utf-8?B?aFAra2tZRzcxOTlSQnVzRmZtMXFuaWJ6d3M3TmQ4OHBOeVNUUlo3SEdGTFFi?=
 =?utf-8?B?L1NkTS84OStSVEN0V3dQaFd2cW9GZ0hvL1g0QS9XcDZpTlk4dUhjT0FWSkd6?=
 =?utf-8?B?S1k4cmtkNm1rbHhGb2wzUGhlbnJmSjVkRENaODBPa3R0Sm1VSnFadz09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac02d692-e689-4012-8927-08deb5fe319b
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2026 23:27:29.3925
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilpPnwuSeC+CP4g8FNOwmROSS7rqeM1zYRGZZj2WqazvDo2rH2oTfay3SgDSpSOQ2j1N8Ui7KzZ9iR1wmz92DA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4263

On Tue, May 19, 2026 at 12:31:12PM +0800, Jonathan Cameron wrote:
> On Tue, 19 May 2026 12:18:32 +0200
> Tomasz Wolski <tomasz.wolski@fujitsu.com> wrote:
> 
> > The dax_region resource conflict in alloc_dax_region() indicates a
> > serious configuration problem — two subsystems (e.g. dax_hmem and
> > dax_cxl) are attempting to register overlapping address ranges. This is
> > not a transient or debug-level condition; it represents a genuine
> > resource conflict that an administrator needs to be aware of.
> > 
> > Switch from request_resource() + dev_dbg() to
> > request_resource_conflict() + dev_err() so that the conflict is visible
> > by default and the colliding resource is identified in the message.
> > 
> > Suggested-by: Dan Williams <dan.j.williams@intel.com>
> > Link: https://lore.kernel.org/linux-cxl/69c1a8d1c0fa9_7ee3100a1@dwillia2-mobl4.notmuch/
> > Signed-off-by: Tomasz Wolski <tomasz.wolski@fujitsu.com>
> Seems reasonable to me
> Reviewed-by: Jonathan Cameron <jic23@kernel.org>

Reviewed-by: Richard Cheng <icheng@nvidia.com>

Best regards,
Richard Cheng.

> > ---
> >  drivers/dax/bus.c | 11 ++++++-----
> >  1 file changed, 6 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
> > index 68437c05e21d..66413c6c2ba0 100644
> > --- a/drivers/dax/bus.c
> > +++ b/drivers/dax/bus.c
> > @@ -637,7 +637,7 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
> >  		unsigned long flags)
> >  {
> >  	struct dax_region *dax_region;
> > -	int rc;
> > +	struct resource *conflict;
> >  
> >  	/*
> >  	 * The DAX core assumes that it can store its private data in
> > @@ -670,10 +670,11 @@ struct dax_region *alloc_dax_region(struct device *parent, int region_id,
> >  		.flags = IORESOURCE_MEM | flags,
> >  	};
> >  
> > -	rc = request_resource(&dax_regions, &dax_region->res);
> > -	if (rc) {
> > -		dev_dbg(parent, "dax_region resource conflict for %pR\n",
> > -			&dax_region->res);
> > +	conflict = request_resource_conflict(&dax_regions, &dax_region->res);
> > +	if (conflict) {
> > +		dev_err(parent,
> > +			"dax_region: can't claim %pR: address conflict with %s %pR\n",
> > +			&dax_region->res, conflict->name, conflict);
> >  		goto err_res;
> >  	}
> >  
> 

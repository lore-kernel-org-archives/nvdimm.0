Received: from PA4PR04CU001.outbound.protection.outlook.com (mail-francecentralazon11013019.outbound.protection.outlook.com [40.107.162.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D5E23A3834
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 02:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.162.19
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791428180; cv=fail; b=ExmK8fWNZY2PEi+BJ72wiVo/vv3ypEn8H0qG0kyO4i5tJrvgowlw9ZhrZYVBBCMXoWv2r3tod80NQSu7uZ64PHZhjNKufP//iDY9GrIC60kRfEktnr/xOliZlOc5o9ecJlEf3HQnPiBFJOXG53CDqxIE6eMMVbv1re+uPD0JUJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791428180; c=relaxed/simple;
	bh=4qnsmJVdPlyIbcgDtSgBkAX9R8IR+JltEzxIu72AkAM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=TxcPnuu5ltXE/h4mJfPI0Kv/W3myQFMoPh5VQJqhioRhDUf88OP/lMAngeqFNDt+rh4siWPNTHa+3wAPeHMq/Q6lVwAOh/Ztsn5OIyCcz8h2WSLary+R9gRszNDajuzCPF34P3HyNO3JD2t/XPWX64DXMQGtQtDWOA02NpnZl5s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com; spf=pass smtp.mailfrom=oss.nxp.com; dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b=xutFQUdb; arc=fail smtp.client-ip=40.107.162.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.nxp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=NXP1.onmicrosoft.com header.i=@NXP1.onmicrosoft.com header.b="xutFQUdb"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=qPyIhd+kXVre0EM6gmdIffTlv3Oh82TT8o7mRxCLEqxG2GScQi87MdsbvEpo4S5kgxs/ncfxlbJqVl7VD50fBjNLD7qSRTeJGBkGYtqff3LF8dQqHYH81v3k2nofLJs02kC8TUUbvIkueovoYJIM9CU55z80Y2amihGXDm7HVsTGgR62WR1Gj6wjOpDXCYwK6ufzG0w1lbSRxfcbpmOVUwn6843Q5wEyPhXsCupyM9VSC4sh1mJhZicubUlt7H+sjH+K6FMmeiBh0D+m13b7mw8u8tUIVTzhPm6qfVAr3jZ4gVY8NPvjpdJBG/NzVf0D09vatqg4kKk2EBRvrSkH6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vWdjA6rPCFw0mkiCc7ymMjv/MDAphL636XIZWH86Ltg=;
 b=E/fjyP+gPCvxtOT7JG0Ka0bl3BEdpj4CWs/rZhSYjCYxSxpisnpmSZywqi6Yfq54CqX3GTc0+csBvcf3IpQwLUNXRWP77QxjT2yhZQEc/G75KOM6a15LxCxXzFq21q4IFQhyYfhUotjQJiyrpTHp+5wPn6qEq4MaTPl5kOoOE2txgki9Wedi8ktIB8BdrU5CIGFqC5duepAcQ+s9gwJKm2LRCbGVps/I1VD6DY0BU21jOXpOCMzHjiBIFRciZzOe2431U7PtHnvtpZmQzK57V4jSGRroh7+oy5iaT01pUEr4bb+vOrVVRWvaR2FHdWZLXpQ6KEABDvYPNUuUdMkvWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector1-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vWdjA6rPCFw0mkiCc7ymMjv/MDAphL636XIZWH86Ltg=;
 b=xutFQUdb+acsvKY8NX3fEOT6wuR5ddAxFuq7pUAxe8hk/X29zXxPyPLrfmtx+TDwPiRCB4pxv3gQI1kLQK5k4FIYZpZAvyoJAjTdJaBO8YoMwqG2UFwt+vb8iA4JA6/fLMCruxtqVFgJb92VNjjs+CXlXTYOXU5/85+Xed3fXtB3UciMTuZIzat4gwEY1MvAA3tdZQ36HC4CdDd/wLU2oQyjEbun5jz0x23hPx0qyjp5EX6g9322qTW7tuf2ryRDMSyPmr/Pv/Ues4mcQ+KZVkX8r2o3RhtPndILV3pB/AK9/vtVoYC2KFGAzZiQSEU+L4qaQan/MVxXQonEHvk3eg==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oss.nxp.com;
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com (2603:10a6:20b:24d::9)
 by AS1PR04MB9360.eurprd04.prod.outlook.com (2603:10a6:20b:4da::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.496.15; Thu, 8 Oct
 2026 02:56:14 +0000
Received: from AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9]) by AM8PR04MB7874.eurprd04.prod.outlook.com
 ([fe80::ac38:1699:6f18:c5d9%6]) with mapi id 15.21.0451.022; Thu, 8 Oct 2026
 02:56:07 +0000
Date: Thu, 8 Oct 2026 11:00:40 +0800
From: Peng Fan <peng.fan@oss.nxp.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: Jonathan Cameron <jic23@kernel.org>,
	"Gupta, Pankaj" <pankaj.gupta@amd.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org,
	Peng Fan <peng.fan@nxp.com>, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [PATCH] dax: use assign_bit() where applicable
Message-ID: <ascHWPHVlaeH0/pi@shlinux89>
References: <20260919130750.3041470-1-peng.fan@oss.nxp.com>
 <34be3233-87a7-4dbd-bf4a-56116f4e8cdb@amd.com>
 <20260922000813.3299a72d@jic23-hlaptop>
 <asb5FDTzTHyayd6U@aschofie-mobl2.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <asb5FDTzTHyayd6U@aschofie-mobl2.lan>
X-ClientProxiedBy: SG2PR02CA0136.apcprd02.prod.outlook.com
 (2603:1096:4:188::16) To AM8PR04MB7874.eurprd04.prod.outlook.com
 (2603:10a6:20b:24d::9)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM8PR04MB7874:EE_|AS1PR04MB9360:EE_
X-MS-Office365-Filtering-Correlation-Id: 36111a47-2c30-4c96-200c-08df24e7b32b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|1800799024|376014|19092799006|23010399003|366016|22082099003|10067099003|18002099003|4143699003|11063799006|56012099006;
X-Microsoft-Antispam-Message-Info:
	LHMhbU5ZqmQ8e6nH6347A9J7V5LJyYS7aVPjCHxDt0eJY5DKWUJHae5G9+N94EF9KxzlJ+JkziAe5GLMPxebPdikK0ID6gjr58E5kS5rwWjRoFxtbGy3lJUbhfvtU4B6yMXC0mZuCpXkhwapcXZihvp5pkUcufn86zplOGUjyQ9z4OcGdqS8ZyfeYUE7hsSnPwot/OwP3O4dOrj0vMUKSsL2HQ4Stw20VL4lciV5HLJ2qkbDDlW20qEW+xm5Tb+ueu9T6l+BzcmZ0aX13s05EtCaPV5f+bM7WZhJAmd5PL/2+7ymFgqWdLl3Z4eUoq3oS8WOwSVm6UtG6GvUfF6ec8CwjMnoHFrZ57tIEBIhykk7mmqXSpSEUbePEtb4/XVQnNends/0KP5JhPQhLfZz7tJtX9G3NMvjEXzhaxi+GJCBCvZBc81RqZ4Rstx84iTEWGH4DIcaQCMLW/Ai93v7ZI4dbdcC9LVVne8qOAjaN8ttzbTmnXkw8/IytzfKAyPCMDY5ZB8OK7zgFPnl9APujmyUYVRsCfZyqbVDatZ1xB0MLMvw/gbnvskXIu0x6813MhYaj6SeNLVtlql/FVsWluxyR0USBVkoXGJUKWle/FHr34pDeXGEXHDbNn9kfMnymM6TkWhl9oXPvqpLJVqhaMYhTAXCDDklKy4DNv+KO+0=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM8PR04MB7874.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(19092799006)(23010399003)(366016)(22082099003)(10067099003)(18002099003)(4143699003)(11063799006)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RL6IP9IiClHMAfrXdaM3OXyYq1swXjUs54TvTMW1Y5UFZGeY5d4ybyUXZwNt?=
 =?us-ascii?Q?cMnT+CB0Qb90QfewmpA0IRzMdabzG+Yob+n/Vcvdu4kah+ylinp/2y0YxBCW?=
 =?us-ascii?Q?t4B+ovSG9Glz2lpZpG0IAkhRvtbFtSfDdKng5SaAV637Fp4k7kMV3hs4vyr5?=
 =?us-ascii?Q?BVdUoEWQfma8Iynt7j7GOKupORek2DrU8RwNJBrCXnDjEpBBcYKV/qTeRWCG?=
 =?us-ascii?Q?S0t1D046oyHvofLjIzCJ/AcNrefujiSv2G+XqJkyZcDNZOuko2IYvDOd20fp?=
 =?us-ascii?Q?JDbFkEPMqEvZVcxBeSKPv8oWwDONr01cFfmVKA3+egJmtyTHD51pIxPOYI57?=
 =?us-ascii?Q?UUje01izN1wH4kB1QKxgXkD5Oak0ImJC6x2o+LIbzUwUwJARARySrh1d6uky?=
 =?us-ascii?Q?05+3u8Z6pe/g9LAHZWZTeyaDNmefloNPCUfWmwwhF3zVDOE9JB9CZJl+ZQuf?=
 =?us-ascii?Q?MRiB17mJRlTvHlgdYL1G7gNTfCMVqlfaEevGKJUcH7GkvOSD3JaLTlLnFLoS?=
 =?us-ascii?Q?HOaPkHc2Al4i6ZNFmGOGlEZWZHpvGRTmkW+cSXKCYdoVk140o2cb6B++jcIs?=
 =?us-ascii?Q?s1hJ1svGusv0XjGcTgmqjy6lK2FrT0tTVSCc51HzWPt9Z2uEtp0uEN5ZLu6r?=
 =?us-ascii?Q?LzgH619JWwTfSq6WFojal4lOHnrAO38Q+8YBk9CKJL2PNkCLw55ogf4aXm60?=
 =?us-ascii?Q?4DFRSjkcXzcuxa2BLWPSDbMmhcahnSfNIL6xm1R7PPhc7SD5Zrl0hI2inWNF?=
 =?us-ascii?Q?MsSaRttSj5Gzvoh3bm2mSb4A76/Ji4gkW0DqrDqJi8tq+FWhhCf0GReK1eoz?=
 =?us-ascii?Q?QeRD9HvOGLYNzAwUZQ2NAUpw9lq5xVbSCbMma53eLYo/IvQiczeRB4hcB1Ct?=
 =?us-ascii?Q?OzJ+W7SIS3975iePumpD6+gMF59fLiIeK4BeZU3h5Dx6dZ+aGJITYPYoJ4VV?=
 =?us-ascii?Q?50JCe75FGk/sCbZfO7XOg0qfDqPedFq0tVpRV14z8EBb1+ADXD7U7+9ZCuTy?=
 =?us-ascii?Q?y51plh92OGECfYVI/1V4GTqgf5NXbaMdwtgiDzlJLtz8kiBgGWTPYWz9lx2M?=
 =?us-ascii?Q?+Ig2tpNNlCPh/25hLBfVVTZYQFSwBpn8LwVy4i0ISG91U3I/3j8D2LBPKb5v?=
 =?us-ascii?Q?5z11QyNH2I/hZFff4J/vY5FPoxbeXTSGmieT4T0mHqHyB+AoqGGIBI/JFFVJ?=
 =?us-ascii?Q?WkZlX7Xf8yu1OdpkZ5Kq9eE1kZM3DLxwZUm32pmIxEpSQfXL7KO/6b4KFrSc?=
 =?us-ascii?Q?Jl5VjKI4ey3fpakFiZNw0J7k0/zXtU4w4kPoHvhEu/0ajVF1wysCF0I8Ye+C?=
 =?us-ascii?Q?vqxXr4Ny0zJONus+ubmtK70Ow5bg+/rpTqp2QCXLRBIZvYbM8G+y1m5UZ+Us?=
 =?us-ascii?Q?jeP58SsH9Tk04S7K/PKJjYg9/o1oJFdo5o90roJqLJQtK49rT3283deNPDli?=
 =?us-ascii?Q?KVCJhxX0thAcPh32qO7jz9KFJVQZv8mszzcKp95Pla8WqEMYfSvFOTw0pIES?=
 =?us-ascii?Q?C8m7tLslC7x6jYFAckIs9ye0rb6k92JCBvVLx3hFxjA05l5QEJrUy8a86il6?=
 =?us-ascii?Q?qQ0MIFrdLLluIihzzb91mgH30H/cQWtoAPQxtaINVYXo121pVC3qkUGEYV/c?=
 =?us-ascii?Q?Ke1b3ycWYAH88FrvB9OoLgESOf+dg7Uw2+RAxZEOzAOZiajbToOdFoczPIlW?=
 =?us-ascii?Q?1dK/BCIv1Xcs5I+qGZsfTkakZRdicbhWqySMRTweCt8BSZLh5kDaaniQ7i06?=
 =?us-ascii?Q?eU83G2COzRIeDWDamixEZ6i9O2r0f2Qy8PnDPp8zf16QC3CJEnGK?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36111a47-2c30-4c96-200c-08df24e7b32b
X-MS-Exchange-CrossTenant-AuthSource: AM8PR04MB7874.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Oct 2026 02:56:07.3211
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5fvDv100+nSKq2H3zlWiJh830uVcPXAtaEG16D3PE1Xq4TLf6d7AHXJiAZR9jNpITf1yh4YaYk3uHML+U2HpnMGoR6FyTi4PUzTTtbq7vVgjrcmMFC7zo9Hr22O5+Oaf
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9360

Hi Alison,

On Wed, Oct 07, 2026 at 06:59:48PM -0700, Alison Schofield wrote:
>On Tue, Sep 22, 2026 at 12:08:13AM +0100, Jonathan Cameron wrote:
>> On Mon, 21 Sep 2026 10:24:51 +0200
>> "Gupta, Pankaj" <pankaj.gupta@amd.com> wrote:
>> 
>> > > [You don't often get email from peng.fan@oss.nxp.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
>> > >
>> > > From: Peng Fan <peng.fan@nxp.com>
>> > >
>> > > Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.
>> > >
>> > > Signed-off-by: Peng Fan <peng.fan@nxp.com>  
>> > 
>> > Reviewed-by: Pankaj Gupta <pankaj.gupta@amd.com>
>> 
>> A bit marginal wrt to churn but a good change in general.
>> Up to DAX maintainers on whether they want this type of small
>> focused improvement.
>
>I didn't see the improvement. When I peruse the file I see set_bit and
>clear_bit, and now I see a couple of those obfuscated by a new
>assign_bit, needlessly.
>
>If Peng wants to come back around with a 'why' then I'd take another
>look. I shared my NAK story here:
>
>https://lore.kernel.org/lkml/asb3hGpSWVQk93cX@aschofie-mobl2.lan/

Thanks for taking the time to explain, and for the link to your
earlier reply - that was useful context.

This patch was done by a cocci rule.
sorry for not providing a justification for this particular conversion or
making the intent clearer. Converting only some of the call sites leaves the
file with a mix of styles.

Free to drop the patch.

Thanks
Peng

>
>
>> 
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
>> 
>> > 
>> > > ---
>> > >   drivers/dax/super.c | 5 +----
>> > >   1 file changed, 1 insertion(+), 4 deletions(-)
>> > >
>> > > diff --git a/drivers/dax/super.c b/drivers/dax/super.c
>> > > index 45f84b0eb909..60c4aec52ae1 100644
>> > > --- a/drivers/dax/super.c
>> > > +++ b/drivers/dax/super.c
>> > > @@ -385,10 +385,7 @@ EXPORT_SYMBOL_GPL(dax_flush);
>> > >
>> > >   void dax_write_cache(struct dax_device *dax_dev, bool wc)
>> > >   {
>> > > -       if (wc)
>> > > -               set_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
>> > > -       else
>> > > -               clear_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags);
>> > > +       assign_bit(DAXDEV_WRITE_CACHE, &dax_dev->flags, wc);
>> > >   }
>> > >   EXPORT_SYMBOL_GPL(dax_write_cache);
>> > >
>> > > --
>> > > 2.51.0
>> > >
>> > >  
>> > 
>> 
>

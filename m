Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4DC111BF
	for <nvdimm@lists.linux.dev>; Fri, 13 Jun 2025 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749823575; cv=fail; b=RYMMRiUfgf7FXfhLxwlf5I4POaXYX0NkDj0A2Rwq2a3uTxcwJdG/qj//nOpaIBGXaEsQrovWIYLSQqVrkjeX4f4WZiT86tYSCIYDPfqCMbTmearKZ+SF0QBdbKIunsolUh4avS6Bozv+kKzu6GsyVnRuC3MclmArbpprRbqEmOQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749823575; c=relaxed/simple;
	bh=WyPMSPH4lrA0Cq7Xq2hICJDOEqEbxBZE63YPgGHw2Es=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=jOmO68oZAHNKad6OD/lUmfKti/EnRkBBvebPjOXmSgTX3e/3w+7iP8g1i30Whu81pgNmZj7qJnl+/hWPeBQb8zRad3zvEwAfuvxSOwzas9J+l+SsnJmE9bJzzGoV/YQ36rbqvLOaZMc+phbtFOu5nJeka5YfDduENei9TJoZKFQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nASwucZ3; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=d9KQ/YUC; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nASwucZ3";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="d9KQ/YUC"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55DCtbEW032653;
	Fri, 13 Jun 2025 14:00:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=WyPMSPH4lrA0Cq7Xq2
	hICJDOEqEbxBZE63YPgGHw2Es=; b=nASwucZ3aJqu5mpns8WtszH7BrhZ04CHOq
	r/Zv6fgV1YtwAO5OuRzPPir9xsLRsiUHfiEA0pvdYb3wQI07IvMJITEOj78pFo4Y
	GkAbEFSZhITWBFuyv1/qpQEUI2XqdQBOoWEsP7vw9D7MbRtJgXg3ezKREkAecLdP
	YWQG7SZgdwQXbMD3VYJ3QzIHXPJYU+P0LsxXSOSb2XN4af/HbjADcHxyIddFJ2ue
	DD66Cv/dudOzPvjdhbMPrCKFwtSxA3W71/K/tzfpP6oFBH3el7TDLXGAyd9+D6NC
	GVqNivNP4oBGdrxSCUgq1Rs0dGsZdiHcJ9fomcVe7bz0rhqvzcdw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474d1vbnhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 14:00:53 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55DCknhO037765;
	Fri, 13 Jun 2025 14:00:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10on2080.outbound.protection.outlook.com [40.107.94.80])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvk61eg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Jun 2025 14:00:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=N1cEUg6GByqxoK095ElOvtc/j687h5jxdkDedcZ1ZRQy9b2La66MsNG1x6k2BRxKR4D6oot3wOqIdnIq8iCZafkWylOWg8QAfovp8dw/ZPmKX1EIjHYEuvHswoO3VGERL3fTJtSO903niWLcSWx82MU/pbMrPlOfyqX2XOMHH5nf49ozP2YzfFTAsYFTiamuw0SwZIQPynqthGzdTGJNHGMK3ToQJvYu5y1EjzWRpJRKbaNRvBEm8PBlJtmJbjXFpnHYawNTVJnffPR8eFnmtpXuSN1VtwF7d8DUxRo4AgyaruWqOqU+rOU4YUBre5uh/iLuYoZjLZ2R/1/Ke7OC2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WyPMSPH4lrA0Cq7Xq2hICJDOEqEbxBZE63YPgGHw2Es=;
 b=lOvJBJYvtywPEsIAP4CNxzNljw4t4x8NzOF/8yMKx09l2NBQbQkiAPUWNT0XDzjReKSSI0TwtYdmv3AhIvfyXRreHrJ7aga95c+mbEtfQqVpmg1zAqJflMUIt57MOMSoB6OWexNh9ngNewKdZHp+TOQRK2Bf0zJXlqLFR9bJvCdtmLwVtA/8l3uT+7ZeBJFdoSI9/odeIcIUHeVulogYSdr6alATJVelhLDZHWyhbAF0qxxt/kkRbDuq+Bk5KlvXkVcct6SJpjgnyBZyndSpXTaoj3kFRhyvr2WiXwUqOO+332ZQU6UJOfmRcn1D/1AHkoOicsBjGLppKGcNusLPPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WyPMSPH4lrA0Cq7Xq2hICJDOEqEbxBZE63YPgGHw2Es=;
 b=d9KQ/YUCUC8I7p1rppS6K8i+ZD33ZNr4JQ5c0YCjUh15dw4sQT46va+zaTa28aLEt9pk0w4m7QvelWY+kkvC23PCX94/L/orOyBvP0Z5WZEVCELJW3O9dm3DR8x0cT5lgOq+1lzU9Rjzj8PHn6u2Os2tl0Aoy8BnFjUynHuN8zs=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by SA1PR10MB7636.namprd10.prod.outlook.com (2603:10b6:806:376::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.27; Fri, 13 Jun
 2025 14:00:49 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Fri, 13 Jun 2025
 14:00:49 +0000
Date: Fri, 13 Jun 2025 15:00:46 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: Oscar Salvador <osalvador@suse.de>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alistair Popple <apopple@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [PATCH v3 2/3] mm/huge_memory: don't mark refcounted folios
 special in vmf_insert_folio_pmd()
Message-ID: <fec14df9-da28-4717-8e4c-e5997a4c32cb@lucifer.local>
References: <20250613092702.1943533-1-david@redhat.com>
 <20250613092702.1943533-3-david@redhat.com>
 <aEwseqmFrpNO5NJC@localhost.localdomain>
 <4acaa46f-f856-4116-917e-08e7c1f3156a@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4acaa46f-f856-4116-917e-08e7c1f3156a@redhat.com>
X-ClientProxiedBy: LO2P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::16) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|SA1PR10MB7636:EE_
X-MS-Office365-Filtering-Correlation-Id: dbe74ea1-57a4-4373-215d-08ddaa82b3c7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|366016|7053199007;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?jEPKvUIc94zb2+hKmdZe+xZ+OPET3lOBDlvGQ396oZbKfEtvdR3mwpeKYVKm?=
 =?us-ascii?Q?JWJuBiEL/APcDIlGNdOjhRIhSy8We0jMsr1x9t1ITs7sV4Iibfn62h3BDKsX?=
 =?us-ascii?Q?+cep/rQZG29+hngvqkOlzQsFF0glD3UFBaCcGOUKJbRSAG7ri0tNcQUVT2Ge?=
 =?us-ascii?Q?Q1LMA7M1ZeBGuRNIAxqmIuGH/sYq62Pv2V5u/+r6sMcYbUVGJkA70YitkXwx?=
 =?us-ascii?Q?+BnWIY+XIXhjo7IVJNN+MScjml+mPDnf7WJ9gRReoc/wFOQ9WxqZ11AMmyOR?=
 =?us-ascii?Q?SY9OMnML7H6sIWj66ljCaUckI4zMF0/7DHy0P7FIYzL1huzvnl6/K/gC6rGG?=
 =?us-ascii?Q?RVG6w36BTd92/cO1UPanwzuuumxUDIvHpNwt/NhJvFjidlJi9PWyUSJM1KRn?=
 =?us-ascii?Q?uniDMx2s1+B+KFliD/D6Zxx7vcQYHwWPuuuLPQGCFmFkI0wiCCn4p5e0Ug0b?=
 =?us-ascii?Q?i27HXoNaVFdtAqCH8OuDaTP/KM4Oq1QoHoxC9ivXEql2rjFasAfDVfozhkKo?=
 =?us-ascii?Q?O+ypPNKOinjeSKCBlNCzgzuoJ6z7bTK5Uh1er4Cfy7yQAgsxaLHi7IgbNLYc?=
 =?us-ascii?Q?3N13lHSaVGYX3z/CoAPGCbNmZpVefiwi1e4myO0MWvHN8HxhKpZl7iWwFTC4?=
 =?us-ascii?Q?rZkMkiUEgbT2WuG7D7Xyd4ILFWHz/WRYiN1qetT5cFuu8BAzhYXnVinahyX6?=
 =?us-ascii?Q?9Es5yEJ2zrAJGdiIAAckno2d8/jb7fe3ZsVlEjsOTmzF1YWBx+8Bs7YKNo8n?=
 =?us-ascii?Q?cl0VAm4dnYPmJr6i6l26WdpExCBeo8E7pX6t0PJZUV4heT4lrx3a/IpGkCQW?=
 =?us-ascii?Q?OysMaBX3RhG0Hcmqc5VRyvWyONPTPLDDWP7vqmz9RErMffUSxxL1hQzMCaOn?=
 =?us-ascii?Q?See/x+uvQl23BAwU8A83hNpCJTVnndab5ntGn67JtC5VGvAQhWYbPArQdD7R?=
 =?us-ascii?Q?nisUijP4gPKZJKVdq+yt6aOSarJ5wMhXVlGE5hY4rBFY/Eatm4Bh6yRrjEWA?=
 =?us-ascii?Q?6+TcfjniFzY7sUglNGDhHckYNSt5LA400qL9Orv/VisgGXoOgTdB6qVS1M0t?=
 =?us-ascii?Q?e9noRk+BezgxPCab0c1cs4frzYJGck1TB56XcINSEvEqymfJFYiZgcvB9xbX?=
 =?us-ascii?Q?gJBrLAPw7WhSL0fwQE87H3FYfkMddLH2kAMx6qHAmJ4/QAzaxOv/5YyGEhtQ?=
 =?us-ascii?Q?GNUMKQJYISd/hrzUQ8UNfVeoyqWlwMGiX2pIMz6v0xDaZ5XldbX0GXdrkzob?=
 =?us-ascii?Q?bl1E82VT/6EZw4YTqELdcD28HtvPw1qY8tcPrJQX5ujmwqBfc+V1itYI/sfo?=
 =?us-ascii?Q?k9vCYk5m8Kh0nFafs+MnuYVO7c7Wk5fNJ/AXFsMGHKU1cgbL6NrSOtEOFxTr?=
 =?us-ascii?Q?wwrGg58JziVpLd34ywKWhDkOha83oTH/rUgbdRcYlXeQgiWOIemiPMf/uTrY?=
 =?us-ascii?Q?/fYVEl11GGs=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(366016)(7053199007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?wSdRabpNhZK0b6s06LQYdpwWAwtXerzFyfsWo2/EdmRdZXJ/0zTWOJ3aeyig?=
 =?us-ascii?Q?7RFj+91rLOy18pLYVarsPXFUcPvGqsJ6RPP/7ARhIl3lus8UajMfrgxtdtkq?=
 =?us-ascii?Q?Bupv3ZQvCWp2x4OmvjfdqK82lZGCcJKfpWeqobEEgSYc7Ww36SD2p7x61sbB?=
 =?us-ascii?Q?H0TBclFXxjPm9dX+qrCdnolDxEowJcMcgDee/ntV8a4qzY3IvT8RkruFQWFQ?=
 =?us-ascii?Q?dSuJ2yS77FbwWSnzJal+cqS2/SBRcT5UM5Z4oLD/FuHoTWPAXYRPJG/A2GQW?=
 =?us-ascii?Q?LNAEGxOzCOzI9sV3C79VC9YVyXORLWvQgKlBzElNCQ4IVyUT9y5ct7s0g6gY?=
 =?us-ascii?Q?PsiQVYg4Pw/G3AiDdQafJ44tGCpdI0JPLstytfaMOqbETQjgoN083cskQIx3?=
 =?us-ascii?Q?o6sbH9s78LfMU+cVlvfI6I9OPlxnkgEU+vmWttI23gKFOG7vAfqZa9sKpoLL?=
 =?us-ascii?Q?tJ82dN+rtMola5SSRJO9o93tQ3VZ0PCmjbt8/YALuLwtlw2kmBd0N2EZLpHh?=
 =?us-ascii?Q?Sxb59jPIpqPlZV7+cPURwGpj8PjOOUOMevBUdS31VqhWn/wzmkwt+Ce1oUb/?=
 =?us-ascii?Q?501F1pfgeJy0/JhnN01q6AMce/a0NivVdg3z9vj204DQLPf9I3EcoqIYZeic?=
 =?us-ascii?Q?1CzNax5BEiWDbynVo/y2xv+wZvW7O1dvXxjIojbNaCit7kwFfIpbhb+HeJNi?=
 =?us-ascii?Q?flENOI/KoT5Fsp0AYv7u+Zti6y2y3Iz8yIY+XtNoWhCX2AqqqgUUNjZ2ON4Z?=
 =?us-ascii?Q?iEzGSUTEBekKferUtvk8YIAGA+T7iWpcSNBqW+N4K46oXWsa2a0q8y5qQC45?=
 =?us-ascii?Q?0+PEeAkQmb7eOWPaCTGauRXQJfzZmV2RcpT47GJCiwCG4EJlXRJELrVSq2Fp?=
 =?us-ascii?Q?U2t6yp4JVZDcMiWd3NNP1SCJbF6e7a2t6n5dgSC5oTFKUTTZ2Dw66v8duc+r?=
 =?us-ascii?Q?MxEi11HEHnqz/SXWo6a+gM7eiFlaaAiHIOKId6GU1kkgX0hjKPFJmMAqEQe7?=
 =?us-ascii?Q?j/SjOWIAbTW+fWz7LrcLgPFAmLSVPuyucIPs9cv56wX1/uTXMnL89nsXCaHD?=
 =?us-ascii?Q?N9CBz+l6zJtUi3sTTCKHzOuVGF1FE7dGHtUS16wDVPChGfBnqE6L4e3xgSPW?=
 =?us-ascii?Q?NdCNhBAvSO9Ij71LAb2D6o+H5lwV61XKtFNeRUVLvWaoc0vHmkdiSsm87KyG?=
 =?us-ascii?Q?4vAldBR5ij39u8ptFRHAYqeF2D/Bb5DGdWoNm/1ClGwD/3J3x8spuoLwGUk9?=
 =?us-ascii?Q?mvn690w1balZRxDIMszEjzGiJbansnUOSL1Ae5v5H/OqXLiflmWtzVWqall4?=
 =?us-ascii?Q?3gZFL+3D461U2JjwmOPsieNx+K7noKcRWkJh8uqtjf84hWpi6yvQtKgCoQOQ?=
 =?us-ascii?Q?DWoGCfbWuUX6aEsIP+RKT/FBA9Q0KkhCc+HI3YKwKBdP+UHO2g+QHK9gUQl3?=
 =?us-ascii?Q?yvbt+F7M0emoXAzOoEHDzO/9cSVDEL9/HQ0NAxv1jS5IW1YJv9nBOB5VyXMN?=
 =?us-ascii?Q?mG996Dk6cep6esN534bmkrtKOtPXsfbT3KsvbchuxLBqdkTaLo1T/bo0/Hud?=
 =?us-ascii?Q?pTHleIpKzvETcBjuxb90OFW3QJ4KA76LlzGNnZ9fGofgLGhS0QTffA+u8EOo?=
 =?us-ascii?Q?Tg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	8UUji7NAnml/y7mMvtuDX0+I7Q2GlOcgFA4T6njs7bLCdn5xKv8boXq3XjXoEZmFHjHaWATt0cDlz+RLeEya7zjnECeR2rGec6UUyVQLDBRU/XCzyKfIlaeHZI2OzrW1kGCpFYoVROsERaeWoBek3IxMO05IabaBspmb+Bf1HM0hPRDVzBcgMzzlJ3S797H/qhQuX0XYmOn0RRXdxGVmPiNoItoNBmqRNum5ibCjavDsXS6iV2DFC5KZHQ768E4XtRx3UofcDqjHarxa1qvESDeHHxB7A/BpwZPxyuJAiqgLD7DpZuRk0qU9IZsUNvJ/mc/DvLtimSeJup9aCVCCqIFxfsKl+S2z6ScXz5GP+3HUnBzFlMh/3O7fOU8EElG5vXeFVw9hI+OPQZNHEjw3rg7TPlZRAAChmIJx/+eUioeSUWriY4sYQ7kT9Vr8HPbG7gf9o3Swx/9Lj0aTX0m+D8Ip6yahENRPF0HbwVSDnIs7h0NDLhDdxDGTPd6F/65WCyj9gEMYcVwOlBpJHN+C3PcCeGlRczfMBIm31cce+sWXMqIHcWYYUc3pGzqDezNv9FHJHCGmvsTCaJVsRPMsliV0wMs+x6F3IdHcCMS0rqk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dbe74ea1-57a4-4373-215d-08ddaa82b3c7
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2025 14:00:49.5861
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e8AOXbLdQjIY6HBQPXv1tv44ToVCi2UV6lZXo/W891peYuhVLsFh1BimlbTm1VFdEKrT4PPQDwiTnkb+RjQg7VPJidVUAQI6ks8+8WwM7Ag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7636
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-13_01,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 mlxlogscore=999
 bulkscore=0 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506130102
X-Proofpoint-GUID: 4JO8bM7QVfueqJxqahwNab5QEO-XhEGM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEzMDEwMiBTYWx0ZWRfX/VWi0Vrelt7q Y3THw8yj6aIf5lwXvitvm7tLAY1yijWbW0ejJLj0UBSl0eZ62XwVtUTW8gtzT7WlEMlF9WHL5ZZ zNZzGuV4mGAnOh+xl3taRqnkfcRPcYYlahkJDVAlf1d+bAQEAwQ/wzLqYuS0tNtZ2cvbGzc5w7K
 rD1MKAO2+FPw9hzPTyK2svLONQXiQAkcdICq9CuuSwu1t8s0W6lK1J9pfkt98L0xbZccAVEqrfT 7OSkFEGt0K3hWeZTLmuhICqIjCxME8aMvdAfMVoLUItUzg6c90LM7OupBLCRv/NijLYJzBtXduL +6+c2hUjb+pKl6Hw0k0jX9HPveOpoGSe7KQp+fEGjnEJhzMIB1QKhakk0Ns1zMJpO+k5jSQiAIw
 AUGM1mDrrplZwwAD3Dw3ML2I1oAfISIt3C6t3ci2/hpDksCfZbT7Ul4TyWICPEkFeKkwr6mv
X-Proofpoint-ORIG-GUID: 4JO8bM7QVfueqJxqahwNab5QEO-XhEGM
X-Authority-Analysis: v=2.4 cv=d731yQjE c=1 sm=1 tr=0 ts=684c2f15 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=QyXUC8HyAAAA:8 a=20KFwNOVAAAA:8 a=JQGE8yVYJrqDanC0N8YA:9 a=CjuIK1q_8ugA:10 cc=ntf awl=host:13207

On Fri, Jun 13, 2025 at 03:53:58PM +0200, David Hildenbrand wrote:
> On 13.06.25 15:49, Oscar Salvador wrote:
> > On Fri, Jun 13, 2025 at 11:27:01AM +0200, David Hildenbrand wrote:
> > > Marking PMDs that map a "normal" refcounted folios as special is
> > > against our rules documented for vm_normal_page(): normal (refcounted)
> > > folios shall never have the page table mapping marked as special.
> > >
> > > Fortunately, there are not that many pmd_special() check that can be
> > > mislead, and most vm_normal_page_pmd()/vm_normal_folio_pmd() users that
> > > would get this wrong right now are rather harmless: e.g., none so far
> > > bases decisions whether to grab a folio reference on that decision.
> > >
> > > Well, and GUP-fast will fallback to GUP-slow. All in all, so far no big
> > > implications as it seems.
> > >
> > > Getting this right will get more important as we use
> > > folio_normal_page_pmd() in more places.
> > >
> > > Fix it by teaching insert_pfn_pmd() to properly handle folios and
> > > pfns -- moving refcount/mapcount/etc handling in there, renaming it to
> > > insert_pmd(), and distinguishing between both cases using a new simple
> > > "struct folio_or_pfn" structure.
> > >
> > > Use folio_mk_pmd() to create a pmd for a folio cleanly.
> > >
> > > Fixes: 6c88f72691f8 ("mm/huge_memory: add vmf_insert_folio_pmd()")
> > > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> > > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> > > Tested-by: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: David Hildenbrand <david@redhat.com>
> >
> > Altough we have it quite well explained here in the changelog, maybe
> > having a little comment in insert_pmd() noting why pmds mapping normal
> > folios cannot be marked special would be nice.
>
> Well, I don't think we should be replicating that all over the place. The
> big comment above vm_normal_page() is currently our source of truth (which I
> will teak soon further).

Suggestion:

"Kinda self-explanatory (special means don't touch) unless you use museum piece
hardware OR IF YOU ARE XEN!"

;)

>
> Thanks!
>
> --
> Cheers,
>
> David / dhildenb
>

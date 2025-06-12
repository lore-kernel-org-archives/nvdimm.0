Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 651941E5B68
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 16:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749745833; cv=fail; b=HdlsFVaT9U8dZk1TcqrYMAUT8Jsr/J+vPk6eP6w8rV4q0JgPuGFo9z5a6D/UejafJ1h92jeWT+yjVYyGi+BsvzgbMm+aX7RRxfjj1MtbaWY/McEnPAEivg/gwVFELlsNQi84M8Ms14VTw26XrpiiE6Eb5IQvqxRpclWyiYL4w7Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749745833; c=relaxed/simple;
	bh=u9Ox6Qly02CfhikjMI3ccthuJ8bsuVqFERfYy1z6rrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=PVnCYrRp6iqkRaj4Pz9iM9+RBuL7v4GDU2jgXn/ajML6V1S3HC346Z+YkKUBaxAY/TapAsTC8YHJBnwrYnP3n6YmYWAe1KM6DM6sx6jceCwg+Ko5ax27rMivrC71atPoFVLuIhRA6A60M7bCrsTO0XouOAQzTz9wW/xvDbym3Ok=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Udfmpf5A; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=vS/wRY2W; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Udfmpf5A";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="vS/wRY2W"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CEtej9024725;
	Thu, 12 Jun 2025 16:30:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=u9Ox6Qly02CfhikjMI
	3ccthuJ8bsuVqFERfYy1z6rrw=; b=Udfmpf5ANcOxotRCYEnuMFGMJIrbZm6pJT
	flPpV56pNYTG3R/auA3/1rHIz69CSqzS6uTuWlkGc7bXsmrDz3NR905bJsBCE1Ev
	Tr/nb01PCdL9hiRe0eVzFP8NZf5dlOaw//nSQC7zYzqHLXLvFoSAsAL3+KL69PAn
	HzkoLvvO9fiboJm1clFOa50PtCjZnHDAHwBqDMds77xYiLm8OaO73n+F2tNqAUHL
	UmvycqsGMACfZPGo3yTIrU8Ie1FyVR5D97gxZNFo4DgJ0l/yCidSdU2wXnG9C2pj
	gtzPoSivixPphhIsOMnRAlzBg0WgKyighqGBgg+OGa7PJ4LKKWiQ==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474bufa1na-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 16:30:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CFt3jv016717;
	Thu, 12 Jun 2025 16:30:16 GMT
Received: from bn8pr05cu002.outbound.protection.outlook.com (mail-eastus2azon11011001.outbound.protection.outlook.com [52.101.57.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 474bvbtyf7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 16:30:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NxOkZdr/iPg3cUquV58HiOAA6BreCqf5qsL29o3uHzvASHozCmgHG13MBquRzoXliCysc6qWSiSJeHAV6WYOPNxpJp8hT+um6+tuLiklFP2/QXkkL4Fe0+eMBXUMB5lgBvecsEppVT3cG/4PMfdCNcNDL4AkTE/rBlldLeknQ+1kKOOxvHAEkvICtp6DKXB5f/pnfnYJFj6lScNtueWGSqY7tRibbleaCFh4vknlJb0h2HAefT/5carlxlxY73fp7efUt6u4kyqhgaKgGjoxFZMgGh2xu2dK8vS/3ZvayIqxqTj/da4n7j3iE7XmtdaYaHhp8ZkhXqGAs1oGeK9psQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u9Ox6Qly02CfhikjMI3ccthuJ8bsuVqFERfYy1z6rrw=;
 b=iNmcGYjy+yKYx00wlp1JAkq/H7ekP/9Rec/4ix1Zb63dMSFzZEeA+gchkB5DDn4Fdm+DZxC0Mt5aXLY1fdxy657Wz27+vSDwKbYS2pOnP84bMWJ5+9kkFKvis6PK3eJl8H28yvx/pYkerX7TqdRUmdxIpHE60gjUXoOK12/UEMvI5lXn7f12SP7CHx6V9xxzlYNMn4FImjFumTIfMPD7UMKO9UapqNiwsjSs4Hh9nsXTi2+GSzj3JvWpEROUlyzQ0e8XT4wUWJekbj42kHeY9NoCmzP0gC96kj38tKYTr0SeToT7mKnClATFwkvVvvdSXiT8T1uVTrOHiUzpsZupZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u9Ox6Qly02CfhikjMI3ccthuJ8bsuVqFERfYy1z6rrw=;
 b=vS/wRY2WdELOe1dPurWfqehKzPepEJor6x5ezIbEBnCYYZ8PPADBljN4tMm4CxyEXfefWfxH8hq5LzleKQkPVA0Uuure7q/strczAMh3FzbPpCh+mmCyVpPFrE+FqKO/lKN/RSWfTHrYXj8Roe3QqmQhEBHN4mboE6ir/RzNRVk=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by IA1PR10MB7167.namprd10.prod.outlook.com (2603:10b6:208:3f1::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.26; Thu, 12 Jun
 2025 16:30:13 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 16:30:13 +0000
Date: Thu, 12 Jun 2025 17:30:11 +0100
From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, nvdimm@lists.linux.dev,
        linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alistair Popple <apopple@nvidia.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
        Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
        Dev Jain <dev.jain@arm.com>, Dan Williams <dan.j.williams@intel.com>,
        Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH v2 0/3] mm/huge_memory: vmf_insert_folio_*() and
 vmf_insert_pfn_pud() fixes
Message-ID: <948cf313-adb2-408e-a5c2-8ebc1d47cfe5@lucifer.local>
References: <20250611120654.545963-1-david@redhat.com>
 <6ae86037-69bc-4329-9a0f-4ecc815f645d@lucifer.local>
 <0340de74-1cc8-4760-9741-2d9c96bcfd17@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0340de74-1cc8-4760-9741-2d9c96bcfd17@redhat.com>
X-ClientProxiedBy: LO2P265CA0023.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:62::35) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|IA1PR10MB7167:EE_
X-MS-Office365-Filtering-Correlation-Id: f2611298-67de-4574-8082-08dda9ce6864
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vKBJq9aYsGkXe6N5VtcWurfThUzMG0k3oWH5cwPdBWCaF7Kf0P1qZDNzaYH7?=
 =?us-ascii?Q?kt8oS8DGIPg3WPN7zGHzSTqGsQuEM6Czy08SnuwPpl6TZR6rdQwOc5ZOrnxW?=
 =?us-ascii?Q?Vy1/F7Jdcu6fL5kqecwOh0pIeuM3BZ5mXU/no1f5r3okGlo49YqREHJxXV1W?=
 =?us-ascii?Q?yC2hx+oXwAOnuBfnSM3HLIYX2SZiaWjfU+3xVUqkZ+jEs+m848uMZfZNUt5v?=
 =?us-ascii?Q?0v/bvMuzLvhV9BH0xe9ZugISFPSaA881JHHvCQzGmmpV+7rHiYlLDFO8Guw5?=
 =?us-ascii?Q?DZA2+gYUSLqQhjJazajykuk84d6mpHxQELMXbAv8y9gBxT1yHyLEmK8Uj8Rc?=
 =?us-ascii?Q?hpBTR4qoOsF6wsovjNbQsQKdXz9CPbznmcFyazsRHhDEiTkwJOxb3jApTLQs?=
 =?us-ascii?Q?JOC2fBrSeOvqIRgtu4/jEyqyqfhhLPjq82kCbUdYDDXkl0GVJ7BHPqebbTvv?=
 =?us-ascii?Q?nQPD1AxvtUddpasmZXhLL+h3z5281J4Ds3pGfzVUhjqtytIveiIXlNLcDjxZ?=
 =?us-ascii?Q?IUBzt3CyuMoO23kPRkrtnzqIINKuI6y/N53fpp9nbf4CEEvNrPU4GGsEavES?=
 =?us-ascii?Q?CRiGYmfItyhUUoU4F4U0U/aUDeAIx06gwQiwEAJVn+AFIIrQ0+NLaXb9SWOh?=
 =?us-ascii?Q?dmDEWSqu4zdAmo+OyVW4YAMjbgFPp9TUV9DQjV4jzCa8cT6rQil/Eb07mEPX?=
 =?us-ascii?Q?xa/o9IFDoWYSus6//JIji7jCWb/Uci5tm3bK3MZqdjjOqaA/wvFZIM23ilrG?=
 =?us-ascii?Q?7Zh924fwE8gAwZi81ALlEBOCxko2bTmGzb5sjpreWyenbazI6ZNvKj8Dr53X?=
 =?us-ascii?Q?Jw3llNuwKqc3KCNAP6oQnbBOuiGP5NlHYv9A2z4vmMX8mDGZyqSfZDUTWutI?=
 =?us-ascii?Q?7I1gOPl2ecBJzpcLDzgMUviYX4MXxeZM50PXPLb45b5JBuR2AihFSZzdKfwe?=
 =?us-ascii?Q?WVdohkm5Ha0zsS6LhYMiSe0WoahjqgOx1qHrNthJmNy4mSOH5KtdaSWMA7Mo?=
 =?us-ascii?Q?j4/GCOs4qDZYQk+X9whBG1mM1xdDNI6i/pN2tcmZW2AtJ6Dm/SdCV+6EB0+4?=
 =?us-ascii?Q?mMNOTQZGuXLpLmBtVTmp5JUADZLY5mxr8UrnfHgquUBdo6WZk85sipArPUTk?=
 =?us-ascii?Q?vvfxaNE/Iwnvin6ZldTbjKlnmbtGIms5wJcSguV1MrzeizF8vt2Z3YEFJpSe?=
 =?us-ascii?Q?PR6x/uIfmPZPiAkLROJA+AxmL9w4F7RIU7NGL6UeXiGxBuEoQf3/WiwzIj14?=
 =?us-ascii?Q?8YhJpUmPTttTvLCdoKYdfaleec2syDnbIEAenN8fz7kxuVygTjTn5ALjoixH?=
 =?us-ascii?Q?FxfDsfWJYM39XETW7UrHw2eyl0YveGife22jl4pQromhfg+aKhh1nTQyq4iM?=
 =?us-ascii?Q?0RZopwJAGbKofRIQk5tXvfglY1zuV/yapkAYeYg8EzH+SZeT/Rs860n0twhX?=
 =?us-ascii?Q?WOwZjPwZ4gI=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8iEeuENGpGoUG8RiAoTnlnyDVHcI1F+73la1Ia1i6yEtNNzYsbXsatGCsVr1?=
 =?us-ascii?Q?juT3GlQjNV1az7QbrjQPQ6UE2ZzrJuM5llXVVJmXGjeGMMVDflyCgky3eYuH?=
 =?us-ascii?Q?b+3kYD0m1jB9gavtmc5fS+Jlf+QrNYLZM8Wc8Pd3pq2U4oOFRRHSrIfi5WeH?=
 =?us-ascii?Q?nlMRxB511iEA0HxXH5IyfXAOwXBesKaEpQzOLxitZhd5AzYYzmyuNp7A7SLO?=
 =?us-ascii?Q?Lm3Ef89wJRSs+BvpWpbadSqqL45AfdZsfkndvnt79Y3eNyhxrj1A2QI+d7Qr?=
 =?us-ascii?Q?VKWX8rcGDWmBHjBjz2dQeBgKASrePEnlfGNXvS94jocMOfy9e2vyyscRkXBO?=
 =?us-ascii?Q?vz7WfgqdJkxl7MhQjBTXB2cr7d9zOeyTM1lD1/Qub7NmxTwR64M6ZXLweUDf?=
 =?us-ascii?Q?gerBVtn/TPhQ5winTW3nZ0r+qnL1dyimVYQgXyCwMiM2l92tNPqN8vLg6rKR?=
 =?us-ascii?Q?nQKqN7Ymbxvbfi+NYtdbDjfWNz1q8sSATgkdtTzs/GfVB/cFjsuHtH0psNFY?=
 =?us-ascii?Q?rwZ3DJkf4MGl1aNY+oGdTmj/s2qaU3zsYsijs7bMLpZz1oHxHiE+hHd3Ljo1?=
 =?us-ascii?Q?iMaDhDkC4nc403WFyHwUfhI7qAJUH4xG6VNKYkyqjygMta54biT3IZBpUjWq?=
 =?us-ascii?Q?fzrLqF2I8IVZ5M7e9jQN96CbdMCCldha0HpkX9xem/rweE6FzXrvnVgvwAeW?=
 =?us-ascii?Q?oBGhaZ0K6IBtqMRhpAB0yTK81yz+j6z2QmwrR2gs7u8Wh8GSPN53naT3Bf97?=
 =?us-ascii?Q?MREP7TEH6HKenulTJfjVLqfjlDTzftNcgi0Obk1NK8ZOqd3mOScMfBB1xzKK?=
 =?us-ascii?Q?GBiqCm78sR5qVsiPKDRntVBn6Vx4pn6/GZkr9YHp7XKYkHZmkMNz7+REAkPV?=
 =?us-ascii?Q?JrakhCQekWERLEnkcbhH5yEGNz57tidJgVZf2sgMQAWQVKQI6Rvvb1zH3V1+?=
 =?us-ascii?Q?je7jo7qAzsphCQtUaKEwY/g4Gy9l3YLyjzc9vefqEicFqmhWp3VTKEQeRVjJ?=
 =?us-ascii?Q?WwBmP6WaLV1RfyouG9HNODOcgfOvcQRqKrtldTpKzFAhqeoC8QN3wMcqXh+1?=
 =?us-ascii?Q?bBGoJJHRb2Opc+fnfq/++k+QbiV38G2f+7hkUT2mC4/VEXX10DG6OG9/J3IS?=
 =?us-ascii?Q?aV0okSV3sLC/QlR1Bs6muy+8ekfNbvru9Cjz82Ib16l8J7BuIUCFmsLFAWAd?=
 =?us-ascii?Q?GDwrzOwFmexFH+rRRCzsVr7tg10lLN59NsCwNLI4C8/dJQ6Rh4dngKTYUCnQ?=
 =?us-ascii?Q?i5ooVN84qEjzD72PeUYhGgM/1qcwIo6lmsZvqAyXD3G9fvdCJzGpFv1zWJSH?=
 =?us-ascii?Q?rZnNsoN9RBmYS6C00MVu5IAzWzgfXEUcyjEoBqjhlnSeoMcWq6ofbQMDFm9H?=
 =?us-ascii?Q?/k2H16MyD8r2jsoPfXS1LzPW5W/E+kIOydRMTkYaE29dq4VU+ps2DNcrbW2f?=
 =?us-ascii?Q?p8i/xK4R/1ihFApP1ZSSa7w/O9nZ8eW/L/k99xkw3xbfSaxPo7ia31Ce6eBn?=
 =?us-ascii?Q?cQxcHvBVlDpP0YmJetmpxoBySyBVP/PdNAvWCk3J8AXdxTAt9+VXDDfRfOMM?=
 =?us-ascii?Q?y20CBtztercs3jBWNRyvsxK/QUd89+WXDgeTvwiy3WnA1O5khf0NgVi1P3aE?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	34ixyUw6Ggjb+76jcdx2+w8YUehW3vPXu07VLZpcm7Cmwb0nHvm7uOS+wsl0H0TMbhvpK6i+WH8mnmqjIhECl7fsto+jnR17SW4J9DowW2dihGtG7LBW0vJNJrgJxZtrLbFISDs1inI5bqvvIKMdzGDZ3J3A2BADoNA7t7umveWrSdrM4K9JM2d7lVT0yeScEw5StHhDF0AIv2vKctVMgkPzFyturi/MBAkE4yWyveAqvOXyE8bOC3zWx6d/kvPgeWh9asaRsQnr0cr6ZZjMPQ/Mc61Lj6yGLjFrROFSw//J8LTYzKh75cnn8bq90qT9UzynmDR8nOrxG5txaL+M54e6/wNJgDF5zRaUHfq5ki0SwbPxFLcqOwNzSGeNyYs10v+4tiFr495Dj1H9fG0Wz9Rrf5hrC8+vT4an75Cgft7XvdfB59653WGnp/QugYXhc54s0e33hMNvxacTG4jAlpU34qDNjCFsH49/rbaR5rwY6TDS6ee5pBObRM9KzMf+dKeATveMSuKYHp3kGESa6BC3dN8YxoSntsNUXVrr6eGQlS1q5UQf5NFPHJGxwOoP2206LvvXL/7cch0z5PRnQpRj+caPnBMjgZ+dhhRLeB8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2611298-67de-4574-8082-08dda9ce6864
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 16:30:13.7378
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bPAq6ecZS0ifYTz8RJnjAey5LhJ/jvYVVnf/nmqpklyKqKpbfUNY+d9EOiM3YjgD7XWQAwma2atvgWEi+66lV3K1DW5esg80G2pvTzdSqx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7167
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 phishscore=0 spamscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120126
X-Authority-Analysis: v=2.4 cv=RZGQC0tv c=1 sm=1 tr=0 ts=684b0098 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=zeWl8pnoE9DlUiHRzXQA:9 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=CjuIK1q_8ugA:10 cc=ntf awl=host:14714
X-Proofpoint-GUID: NfphO41zr5T49trYxHWqbWZ76uS9T6DM
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEyNiBTYWx0ZWRfX+cC+zG92ws7W gl2Sa/zp1UxOQwnser6NqShnMng8LGn/oNxdfinLngDTnbpmtCx0Kzo3YzqqWPzrCM6DbMMw9SL l/6BkCNx95xoDSiopNq5vbeH5F+FpbE25kZcwwOmrK9VBKXZkfrmCPqA6TbDbaWR4Uudufu6tHa
 Hr2xkm2o5WJPogIqT9ZZ57+8vK8Ir+uJdS3+vMoUyWGBICuqqtCVaF0FMby/FREc8Ha0e6Bh7Vq SVzfGtenE3dUcyUp0a4BtyVoSN/eTKxmQcClYgMHuBKiNaiO7s3cAX0vSt6ykPkQ9JOXnF8y6UZ O4KclMBX5Ez7bKuKKlkKb455YyTEHaPvFgaXYRfyPJniQZPSCfKn8DReNffSZOJdN3bSW7smDI0
 ddmZRu3N3kn/gxgWT35MDtXP9wX1euucYW9fyLwT1JN4IsZaOvQMvC8RCVwmWzgAv1PJexZi
X-Proofpoint-ORIG-GUID: NfphO41zr5T49trYxHWqbWZ76uS9T6DM

On Thu, Jun 12, 2025 at 06:22:32PM +0200, David Hildenbrand wrote:
> On 12.06.25 18:19, Lorenzo Stoakes wrote:
> > FWIW I did a basic build/mm self tests run locally and all looking good!
>
> Thanks! I have another series based on this series coming up ... but
> struggling to get !CONFIG_ARCH_HAS_PTE_SPECIAL tested "easily" :)

Hm which arches don't set it?

Filtering through:

arm - If !ARM_LPAE
csky
hexagon
m68k
microblaze
mips - If 32-bit or !CPU_HAS_RIXI
nios2
openrisc
um
xtensa

So the usual suspects of museum pieces and museum pieces on life-support for
some reason but also... usermode linux?

Might that be the easiest to play with?

I got this list from a basic grep for 'select ARCH_HAS_PTE_SPECIAL' so I'm not
sure if um imports some other arch's kconfig or there is some other way to set
it but probably this criteria is accurate...

IMO: criteria for arch removal (or in case of um - adjustment :) - 32-bit
(kernel), !ARCH_HAS_PTE_SPECIAL, nommu

Of course, pipe dreams...

>
> --
> Cheers,
>
> David / dhildenb
>

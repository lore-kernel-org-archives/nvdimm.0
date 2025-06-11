Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2084.outbound.protection.outlook.com [40.107.220.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFB83C1F
	for <nvdimm@lists.linux.dev>; Wed, 11 Jun 2025 08:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.220.84
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749632321; cv=fail; b=IqLHCYuDyOU6OoeV54dZo0F1wihT0cHNzFKsD22ni/yER9C9vYAAnaGE6Vk5GY4vjxqVXvrThC6M6kNDvQdDtYZHcAdXxlMbLcX1Qw7lsZ8AOunJNq9txxlO96w7Szm51tkuJyKUW7o3H66yTomBY5UFYu+paYF3a/gPF4mhZKI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749632321; c=relaxed/simple;
	bh=eDrkrWAyRxRLnIgvlEDSnuwRFw++BgDhOA9EvOj0Y78=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=REfqtxvNfQnymskprNcr+Ajb60NJ3qhdYUmFKyrLLFe9kkp9FJ6jjPqAkvH2RUzi4LD9SAKJL7oqwKvUaUWUxSCyvlMxBx4X3EbNoufOBmCYpdKsyweurxz57GUpkDMcRIwtYbw0lrU29+5puBDFfC5yuOlfP1NJVw9ngiuqyXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=fail (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=iUXmMnFR reason="signature verification failed"; arc=fail smtp.client-ip=40.107.220.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="iUXmMnFR"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=XZi32YSPr1Z2Q0qgnwRWquMBGKlYLRvgxLmtTjQQKC9CWkMXGm96oTQWkOgbHNr8zfgywBQq+MWTu0c12wSTfKlBPrFBc+d+6Y81smAHJOtvwG857IhxZilbiXr22qu+0EJ2NFLYEBuJB8RwveUQfoIAr1l2pRypV6Q8t9Y5mx7+v5drJXGSjkoMrwAe+Shiq/dk1zWCBvUs6XV9uPVy0pU21f8PkobVlGUowgIHJ46YK6eK8IwNJ8b6ufqJf85LRqLX65j9nZi9mgMtqp0qd7g5WndKeEj1KInETTwG3qeztkwV2M0USJcdxTLGPRK5bkIwwYvDonlBapW1jMz7bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VFw/DJGbEp1zukbUOtjMNWw5Vw9Wi6JZj63DZ+/F9EQ=;
 b=iGVXwp4eo4X/HvLu8RL8ZxjBcKbH6K2dxE08kAGcuh9pjFQ6ZgO4JeIQe/mWDeiLpyyuWPJqPLQDOuTUiAsQs9uiwGUj0xuU+UF+SiDzW6uFWCoI6l1Hd21nD76rf9PPi3HyD+7VWU7a7ev4PAmEOlZ5GQS1fPDJwU+PMGAUfJFRNdQ+YdfV0f9mDeAdvaIkk53goPKA14rqPDOw6utygaTl7EMfvqQ8m9EfBL2g6entbRuuku8IyHlfDUpS855GWwZRGD6bmh4tAsFysCzyj78f1ha8o1gqzPLZhzf4HD3WQh8JW4iQsfjvI7cqvJBzcJFbv2z0qwMxCeTtvL4B+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VFw/DJGbEp1zukbUOtjMNWw5Vw9Wi6JZj63DZ+/F9EQ=;
 b=iUXmMnFRMHkVNlIQtiIiXfOdJTMu8XeFACwyU/qQMilcd5wZuxy8FVhg6E5qM8+/PBXi2n+9SMmr6A3aLaGxZ4cNfn+hvBocHwoN6FiMzAHKUA+sQ+aSjXhHdbAD53irUmEI4OVc1U1r64tNATQ5f3KeFBd9R87xlr68mjsuyjjiH1Gj3e9px7vGB6AJG01li2tCt6XD1k+ovrQYIgvDVSoR4OPmXThOXxZvQObHjYk8R0lbYQcuY2BEIk5neYHAESmVSnKn62E5pew+pgJRFwctymDiAsGKP5VuehScQHb/wZeyRb3PxgSdxolv45d+DdCv3FLb1SlYxu+ML7ftGQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA0PR12MB7723.namprd12.prod.outlook.com (2603:10b6:208:431::10)
 by MN2PR12MB4357.namprd12.prod.outlook.com (2603:10b6:208:262::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8792.41; Wed, 11 Jun
 2025 08:58:34 +0000
Received: from IA0PR12MB7723.namprd12.prod.outlook.com
 ([fe80::ef74:9335:2c5b:2bc7]) by IA0PR12MB7723.namprd12.prod.outlook.com
 ([fe80::ef74:9335:2c5b:2bc7%5]) with mapi id 15.20.8792.034; Wed, 11 Jun 2025
 08:58:34 +0000
Date: Wed, 11 Jun 2025 18:58:29 +1000
From: Alistair Popple <apopple@nvidia.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org, 
	akpm@linux-foundation.org, 
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>, Christoph Hellwig <hch@lst.de>, Jason Gunthorpe <jgg@nvidia.com>, 
	gerald.schaefer@linux.ibm.com, dan.j.williams@intel.com, jgg@ziepe.ca, willy@infradead.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, jhubbard@nvidia.com, 
	zhang.lyra@gmail.com, debug@rivosinc.com, bjorn@kernel.org, balbirs@nvidia.com, 
	lorenzo.stoakes@oracle.com, John@groves.net
Subject: Re: [PATCH] mm: Remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and
 PFN_SG_LAST
Message-ID: <tnaqespmxakrudv6qg5d73fbts6kfvixourtab7wsfigcfx4cc@ep6elmkephtd>
References: <20250604032145.463934-1-apopple@nvidia.com>
 <CGME20250610161811eucas1p18de4ba7b320b6d6ff7da44786b350b6e@eucas1p1.samsung.com>
 <957c0d9d-2c37-4d5f-a8b8-8bf90cd0aedb@samsung.com>
 <hczxxu3txopjnucjrttpcqtkkfnzrqh6sr4v54dfmjbvf2zcfs@ocv6gqddyavn>
 <1daeaf4e-5477-40cb-bca0-e4cd5ad8a224@samsung.com>
 <52b746ae-82cc-428e-8e88-a05a6b738cd0@redhat.com>
 <4e53d612-534c-46b5-9746-a4a9814d41c3@samsung.com>
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e53d612-534c-46b5-9746-a4a9814d41c3@samsung.com>
X-ClientProxiedBy: SY2PR01CA0033.ausprd01.prod.outlook.com
 (2603:10c6:1:15::21) To IA0PR12MB7723.namprd12.prod.outlook.com
 (2603:10b6:208:431::10)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: IA0PR12MB7723:EE_|MN2PR12MB4357:EE_
X-MS-Office365-Filtering-Correlation-Id: d4a7e29d-7173-4056-a480-08dda8c62548
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?iso-8859-1?Q?45LbaGknEPPx2C9mhlHJdHBpvrwfEvjMWWTg1U8ibp3XFvrAmkHvrfOaiD?=
 =?iso-8859-1?Q?mJKXruKhrTAzpLmWLKM8hIXP/FA93sAe0YP+h42pDK8IJATsvO6e+mf7j/?=
 =?iso-8859-1?Q?u3x7kduwFuQ0uLCgH0j5UZxLuCxx1WyuQmXxxk0jKq/HLs+BanFNWJqYCL?=
 =?iso-8859-1?Q?g9MhYe8bs+bklFnQ3cySdOVNBzniSemEa7r+eUDkykSFslo/AvFAOsk7Wf?=
 =?iso-8859-1?Q?5+0fnFqcJnVKTaNtn9/muocwk6L6DX4JGW8+HgXQ/YRmR24pnrE9QJ4WZQ?=
 =?iso-8859-1?Q?1vinvEP908HUS6TuCctlcOK1bOprf24b7JG7wTEfRuHLJTLM5JhNVyuUUC?=
 =?iso-8859-1?Q?wEXOHedPIkl21Lt9eddc3BG7PxtypIx5VQ2EixEkZLLf/Z8Dq0snyeBlZJ?=
 =?iso-8859-1?Q?rwO5dJACvUOKikUxHPqeUmvZh8K329l8cNS0y2TeQ0ZZN58GHiCI1w6IkK?=
 =?iso-8859-1?Q?tIYw4PqYslb65AHo+RiW7a/rRpUIxx4MUmhZlYNepp8Lj3zvD6+PzxvauF?=
 =?iso-8859-1?Q?dnxy9ZW94EmnjCrmTMLy1oKZi7uVqUQk9XfdrkZW5vi6oNDqjts12DBCnA?=
 =?iso-8859-1?Q?A+MNsk2Mi8DTcX+pORxIX2D45jOrNoHc8+tIShicHU+ThgZTujTppE0tv3?=
 =?iso-8859-1?Q?Xu6DiOjPILUJMwVUiUHU6VoLPnUgg8hxYQgeMHHE1dCFzywOr0Dsc1rcds?=
 =?iso-8859-1?Q?aTcbPNEx6t2AbnXK6fbE2iNHlbDjFcbLMolX0Df2MGvPH7C41XJWq4wyUT?=
 =?iso-8859-1?Q?tDsaiSel1OhT0JL2eOXFSvkoeBNNdyK9gcEYHhL+08eolzvqvUX7DguWpR?=
 =?iso-8859-1?Q?+vk0yVg7c3KH1YPQaaRZ0U0U4NXg+peV3ha9XZ55fGBQnL7/wkMnLk+RDb?=
 =?iso-8859-1?Q?fRyMrrodbTyxhPPME5f5o1raSXclF0G4bAkShSGSGLmjygRctCgQOfaeVW?=
 =?iso-8859-1?Q?0yg+sGzvd9rrgzP/CsYQ03io3gHfYOWPRsCWl6xplA2B2hYdTvvE+/6Q7z?=
 =?iso-8859-1?Q?xvJ8KwlzuX0xQngTtAf6mRwW3BcyUNisF/S3dp4qjsas2m4pelgzhHTkmG?=
 =?iso-8859-1?Q?AMaiZrj7McyRrpyl8vnKGMuw7mZa2jhygEBb7ArJJmCrRE2NcgfCEZqDvs?=
 =?iso-8859-1?Q?gRmrj82hZpP0GE6YrY3XYuljZxhvi9PI7F2zRVNPOnt6LufVhhwlEuyGM3?=
 =?iso-8859-1?Q?VQqfjkMJNQfODgXucO99HM/74dNA1o8JpSwvnB6hd7sUJgg2Pl3d0YDa8I?=
 =?iso-8859-1?Q?p8dY/rlJZOZh7UFhC39a7fALj+z8O/34YE4o9dMjgrWZojSotxyvTtVhD2?=
 =?iso-8859-1?Q?9fZklhnGs3Kx3p1ZeBM/6qC/GmBvxn6uFDZNfgECle/G/jraDe1cX4FpiK?=
 =?iso-8859-1?Q?VUv5Hm80sB/p/GegRe7ZFGA/3wjqY7CPZDZSc5NzyYBQeYVPUYS9992IIK?=
 =?iso-8859-1?Q?dJSD2Tv3LSx7uWyyJ2gcRK6+Oi5U5Tfe6V2t2g=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA0PR12MB7723.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?iso-8859-1?Q?r7JsrDrVEPBqJU/nomcAYtbf4+Ki7mOjhqdAkEnRlYiE4dkEkpIlMFk6mc?=
 =?iso-8859-1?Q?2EjHW0gFd/OCft9AjNElYnBP4vl568/6KO319Yf3m5pM0LtkhE0/wgeD/N?=
 =?iso-8859-1?Q?3FLIkK85+yNq3uLOWggkqinXGVH73Xl3rQMI1WXCZJJy7sxsBzcNUQBOYr?=
 =?iso-8859-1?Q?6HdGBKgLypiX4G7uZp8fcP4hCUnD5Ips7siqL2LNUyBPGtjr091jq/ZbEj?=
 =?iso-8859-1?Q?9nHT1SssGUSLs5NYCROIGvC6NkKEYJbiqcRFpKOwqCNOKIWgmb6mE66gxx?=
 =?iso-8859-1?Q?u7V6ky7A5rC2AQeQ6Wl/OII+MB0Ky3P6+TOx4xcN/2n2UL0iopvVn2f+8d?=
 =?iso-8859-1?Q?ZirvPHU6YLTLPRoVuEakHrxXQ402CnmWogv+GXyhPVFmRNtan3RCSFX6X3?=
 =?iso-8859-1?Q?F8NQNyc2jOzPIQoocFhVvUplCe2V7ZniNFo30HQ/2DqwDcztGnySN8wgjj?=
 =?iso-8859-1?Q?bRQQELZUBJaBWx3IfAAxcLO2r0QwpLIldxRLFp1o/b+Je70nEalf8qOzT1?=
 =?iso-8859-1?Q?N1Q0lC36Io/M5R9Z7FprxDL+/64+OcaLT5klulwvCaRc0xAUUib4S/atZv?=
 =?iso-8859-1?Q?eZ7B29aJNCx8IVaWDd1yp37is9G/SmDcjF+hQbnJ+9JLd1IVPBBp0AZHjo?=
 =?iso-8859-1?Q?hAQnorb0OnVwLZYlH2qPfMNnzM27lZ5NdNRa+47xtZsWOI4E3yqrTiqgIC?=
 =?iso-8859-1?Q?4IsSorMozo61PMdffQjQDET8lOvJoGXSUgv6YVySsp1qqCHJoiJkIt44ER?=
 =?iso-8859-1?Q?I6f0vBHkB8M/E4/At2GCxQ62ShbRqQIGALCVRTRpKKptZEw2NMaM6dZvpp?=
 =?iso-8859-1?Q?yG1UD965u9a/e3TXlf0crtJjZvyDr0sHEgoWNj9y/fDwLCgA/I84XjtX09?=
 =?iso-8859-1?Q?nesPfRqjU1UyAa3U9lXLRGPGmDqxO+mKIibXsOXUb1VgOVHpR8FCTe6OPF?=
 =?iso-8859-1?Q?RHG61WOsE7RoUb9kfWsdARBGpDCQoXvjsyQ6FIfCwXuiNHL97T1GexY+kk?=
 =?iso-8859-1?Q?4WYEkrVIqTVE12/KGA8+fh7CQoDaTCh1ea+a+PjjgU4S7FqMD1MhPkA87Y?=
 =?iso-8859-1?Q?I1qwGEpwgd2/QDvidqVjp2BRfSrvXNtzDW9yNGb4j8YX40FdRH04Z8n7Tx?=
 =?iso-8859-1?Q?fU4Y8C0AtS2iio1nqsAMxjp5gglJp6+P5RcvTGJRBJU9pXmV5nHBezjtBC?=
 =?iso-8859-1?Q?hwO0mJ5ihfKHNz556rsqZDsBRdqCVwlIFaZEnxHMAOBQNpXleV9Nx8qNxm?=
 =?iso-8859-1?Q?h4ZZILG9PXe/nIPcpw/d9MhpSeiPWsgQ0YHrrFVSgHQx0uVS+oRg1OVWMp?=
 =?iso-8859-1?Q?XglJhm2+0vkxC6OGW1ur9Mvr+YXmYh8RJJVQqxrCj/99u90yflNGXJXDyz?=
 =?iso-8859-1?Q?LbRb3517DAJCUIoo/638Yv/YQIfalARQ05gYhPM7dD9jUaN/xWLEspNWTb?=
 =?iso-8859-1?Q?H4cvvzsEZyF/xqiXdDdTwpy80ka7XL89CF4QV0kXxMUMpFY4KOL4BeeAB8?=
 =?iso-8859-1?Q?RBSg/JeAQY0Grp57exTBijf39JAFsdojYUstZscgspVqV7cB1bTNuzP6UC?=
 =?iso-8859-1?Q?bzxT1uSrxIG4Kq4VGDf9XaTKF2l+zGJGY+/1ldK958fx+MOvJvc/QvGE6P?=
 =?iso-8859-1?Q?JBnUeIOSI64m7qOxpKHKezi6xl6yH2gNs8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4a7e29d-7173-4056-a480-08dda8c62548
X-MS-Exchange-CrossTenant-AuthSource: IA0PR12MB7723.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2025 08:58:34.2581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KpNlhhxsytJGe/DRqdfpIyMowXTZ40g5aioU5ijD9DqgdIvs/c5eqmMmutBfl7LOJkj0QHTCloafeKFbCYP/Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4357

On Wed, Jun 11, 2025 at 10:42:16AM +0200, Marek Szyprowski wrote:
> On 11.06.2025 10:23, David Hildenbrand wrote:
> > On 11.06.25 10:03, Marek Szyprowski wrote:
> >> On 11.06.2025 04:38, Alistair Popple wrote:
> >>> On Tue, Jun 10, 2025 at 06:18:09PM +0200, Marek Szyprowski wrote:
> >>>> On 04.06.2025 05:21, Alistair Popple wrote:
> >>>>> The PFN_MAP flag is no longer used for anything, so remove it.
> >>>>> The PFN_SG_CHAIN and PFN_SG_LAST flags never appear to have been
> >>>>> used so also remove them. The last user of PFN_SPECIAL was removed
> >>>>> by 653d7825c149 ("dcssblk: mark DAX broken, remove FS_DAX_LIMITED
> >>>>> support").
> >>>>>
> >>>>> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> >>>>> Acked-by: David Hildenbrand <david@redhat.com>
> >>>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >>>>> Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> >>>>> Cc: gerald.schaefer@linux.ibm.com
> >>>>> Cc: dan.j.williams@intel.com
> >>>>> Cc: jgg@ziepe.ca
> >>>>> Cc: willy@infradead.org
> >>>>> Cc: david@redhat.com
> >>>>> Cc: linux-kernel@vger.kernel.org
> >>>>> Cc: nvdimm@lists.linux.dev
> >>>>> Cc: jhubbard@nvidia.com
> >>>>> Cc: hch@lst.de
> >>>>> Cc: zhang.lyra@gmail.com
> >>>>> Cc: debug@rivosinc.com
> >>>>> Cc: bjorn@kernel.org
> >>>>> Cc: balbirs@nvidia.com
> >>>>> Cc: lorenzo.stoakes@oracle.com
> >>>>> Cc: John@Groves.net
> >>>>>
> >>>>> ---
> >>>>>
> >>>>> Splitting this off from the rest of my series[1] as a separate 
> >>>>> clean-up
> >>>>> for consideration for the v6.16 merge window as suggested by 
> >>>>> Christoph.
> >>>>>
> >>>>> [1] - 
> >>>>> https://lore.kernel.org/linux-mm/cover.541c2702181b7461b84f1a6967a3f0e823023fcc.1748500293.git-series.apopple@nvidia.com/
> >>>>> ---
> >>>>>     include/linux/pfn_t.h             | 31 
> >>>>> +++----------------------------
> >>>>>     mm/memory.c                       |  2 --
> >>>>>     tools/testing/nvdimm/test/iomap.c |  4 ----
> >>>>>     3 files changed, 3 insertions(+), 34 deletions(-)
> >>>> This patch landed in today's linux-next as commit 28be5676b4a3 ("mm:
> >>>> remove PFN_MAP, PFN_SPECIAL, PFN_SG_CHAIN and PFN_SG_LAST"). In my 
> >>>> tests
> >>>> I've noticed that it breaks operation of all RISC-V 64bit boards on my
> >>>> test farm (VisionFive2, BananaPiF3 as well as QEMU's Virt machine). 
> >>>> I've
> >>>> isolated the changes responsible for this issue, see the inline 
> >>>> comments
> >>>> in the patch below. Here is an example of the issues observed in the
> >>>> logs from those machines:
> >>> Thanks for the report. I'm really confused by this because this 
> >>> change should
> >>> just be removal of dead code - nothing sets any of the removed PFN_* 
> >>> flags
> >>> AFAICT.
> >>>
> >>> I don't have access to any RISC-V hardwdare but you say this 
> >>> reproduces under
> >>> qemu - what do you run on the system to cause the error? Is it just 
> >>> a simple
> >>> boot and load a module or are you running selftests or something else?
> >>
> >> It fails a simple boot test. Here is a detailed instruction how to
> >> reproduce this issue with the random Debian rootfs image found on the
> >> internet (tested on Ubuntu 22.04, with next-20250610
> >> kernel source):
> >
> > riscv is one of the archs where pte_mkdevmap() will *not* set the pte 
> > as special. (I
> > raised this recently in the original series, it's all a big mess)
> >
> > So, before this change here, pfn_t_devmap() would have returned 
> > "false" if only
> > PFN_DEV was set, now it would return "true" if only PFN_DEV is set.

Ugh, what a mess. Thanks for pointing that out (I had seen your earlier response
to the original series but hadn't found the time to look into it more deeply).

> > Consequently, in insert_pfn() we would have done a pte_mkspecial(), 
> > now we do a
> > pte_mkdevmap() -- again, which does not imply "special" on riscv.
> >
> > riscv selects CONFIG_ARCH_HAS_PTE_SPECIAL, so if !pte_special(), it's 
> > considered as
> > normal.
> >
> > Would the following fix your issue?
> >
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 8eba595056fe3..0e972c3493692 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -589,6 +589,10 @@ struct page *vm_normal_page(struct vm_area_struct 
> > *vma, unsigned long addr,
> >  {
> >         unsigned long pfn = pte_pfn(pte);
> >
> > +       /* TODO: remove this crap and set pte_special() instead. */
> > +       if (pte_devmap(pte))
> > +               return NULL;
> > +
> >         if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
> >                 if (likely(!pte_special(pte)))
> >                         goto check_pfn;
> > @@ -598,16 +602,6 @@ struct page *vm_normal_page(struct vm_area_struct 
> > *vma, unsigned long addr,
> >                         return NULL;
> >                 if (is_zero_pfn(pfn))
> >                         return NULL;
> > -               if (pte_devmap(pte))
> > -               /*
> > -                * NOTE: New users of ZONE_DEVICE will not set 
> > pte_devmap()
> > -                * and will have refcounts incremented on their struct 
> > pages
> > -                * when they are inserted into PTEs, thus they are 
> > safe to
> > -                * return here. Legacy ZONE_DEVICE pages that set 
> > pte_devmap()
> > -                * do not have refcounts. Example of legacy 
> > ZONE_DEVICE is
> > -                * MEMORY_DEVICE_FS_DAX type in pmem or virtio_fs 
> > drivers.
> > -                */
> > -                       return NULL;
> >
> >                 print_bad_pte(vma, addr, pte, NULL);
> >                 return NULL;
> >
> >
> > But, I would have thought the later patches in Alistairs series would 
> > sort that out
> > (where we remove pte_devmap() ... )
> >

Yes, I think Marek confirmed that it did in his earlier reply.

> The above change fixes the issues observed on RISCV boards.

Thanks for testing. Andrew has already removed this from the -mm tree so I'll
reincorporate this back into the series and see if I can figure something out
when I respin it.

- Alistair

> Best regards
> -- 
> Marek Szyprowski, PhD
> Samsung R&D Institute Poland
> 

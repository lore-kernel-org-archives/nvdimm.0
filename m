Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785962C80
	for <nvdimm@lists.linux.dev>; Thu, 14 Oct 2021 18:07:00 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Refu4eSV0qm5NmH3ktHWGA8zQ5XWT7Zl/ocvHRjUO4mZy9rU26VogUwAcZkA7fYXJ24mgLa2bCqk4r/xEU0QJbpV7qCgFQoddamb5IENkomOcZLgQnyz2HPL8oWh/7ItXEQH9C6DMr3AX5WmS9SHqA/F08znXrcXpk5Px6D9OC/xonhWTh7G4brU/thPZADT20+6wrSZwepPeSav52ZFfsBzEJv8QT1h4HJ/WR+rDnJanxqIISAEa/H2CsAzyirVbihHlxvt71KlWT4OA3hAuFXrgul39ToYA1nUjECWKO8HKaoNxLsyWLzhOMv+OK5kBClfCzJ0Gnz7mv/F78Q+bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9/m+NmYQ8FbFZWhFzS3pICdk1XyLjZrt4s24hxzupSY=;
 b=c81ZG5UHVwUAqp2VMnADSGe6mNurqShF1ELNUH/Xv/zgnJBvT9MzgNsZKBwEL18wcnrVTWtHnQgEn4ZY9ulqjEZFVP7bYWWQcnQpja8mj2VECq40ed97gUg4DLz/+9b59PBowZsnkzB5O/MbEWaKgfWB7+c+BN/6AUEQ6ZswaTfgvn8SCC8Sx44bHZhz/j35tHeaJORFJBmdpHfukUcfqYvQFpnR3OETZWi8T2l4RBEghtvfzCaJtA+8tpKpdcYKVcFlgC6hWnKC2XnDaId8QqEKHOdt6jftJaiauQHeQyFnFsH/Chsz/w+z+JyqtlbV0X9bZnsNRU4VDEJj8bGTkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9/m+NmYQ8FbFZWhFzS3pICdk1XyLjZrt4s24hxzupSY=;
 b=Yt64+NCMuTkmCzU1vAtYSLOMcYbDgiuOdp7xwyFJrhyebxWPwMPvpNCS/YQyYhjkPLkptZ/KsmwZjO3F2XsF5LsKdXd4BivaWhgl4zZhHvSK97cUltBhCNW9Ao/qFzrW/Eb/IbzZWZNbWOv9qCR2Jm0nicR2CANMCFNAfrw+Eo9ZlidZmVlGR0QfgsJj/cn7EwP61qBEc0pYrdv0hynt0JZv9mjmurfbs3d+DSYseYJ+ISLKsvjRPMrjmZcqbH3bxU+zqOEEsfhgk1HcztRAv0VsNoA2usDcP8AzZxLpkEnqSAP0qmAbEdSc5Masp6DFiYgi3fHB9TK1e+6yGx2FWA==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5141.namprd12.prod.outlook.com (2603:10b6:208:309::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Thu, 14 Oct
 2021 18:06:58 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%6]) with mapi id 15.20.4608.017; Thu, 14 Oct 2021
 18:06:58 +0000
Date: Thu, 14 Oct 2021 15:06:57 -0300
From: Jason Gunthorpe <jgg@nvidia.com>
To: Joao Martins <joao.m.martins@oracle.com>
Cc: linux-mm@kvack.org, Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>,
	Matthew Wilcox <willy@infradead.org>,
	John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
	Muchun Song <songmuchun@bytedance.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
	nvdimm@lists.linux.dev, linux-doc@vger.kernel.org
Subject: Re: [PATCH v4 08/14] mm/gup: grab head page refcount once for group
 of subpages
Message-ID: <20211014180657.GB3567687@nvidia.com>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-9-joao.m.martins@oracle.com>
 <20211008115448.GA2976530@nvidia.com>
 <01bf81a4-04f0-2ca3-0391-fceb1e557174@oracle.com>
 <20211013174140.GJ2744544@nvidia.com>
 <20e2472f-736a-be3a-6f3a-5dfcb85f4cfb@oracle.com>
 <20211013194345.GO2744544@nvidia.com>
 <9a9dccc8-81b0-f3dd-60ea-130406791e64@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a9dccc8-81b0-f3dd-60ea-130406791e64@oracle.com>
X-ClientProxiedBy: BL1PR13CA0288.namprd13.prod.outlook.com
 (2603:10b6:208:2bc::23) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.162.113.129) by BL1PR13CA0288.namprd13.prod.outlook.com (2603:10b6:208:2bc::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.8 via Frontend Transport; Thu, 14 Oct 2021 18:06:58 +0000
Received: from jgg by mlx with local (Exim 4.94)	(envelope-from <jgg@nvidia.com>)	id 1mb585-00F0LV-JW; Thu, 14 Oct 2021 15:06:57 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ca254175-5f0c-4331-22ed-08d98f3d69f3
X-MS-TrafficTypeDiagnostic: BL1PR12MB5141:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS:
	<BL1PR12MB5141E3179C7ED7A3434C6B0FC2B89@BL1PR12MB5141.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	By0EzjyPb3Bf17+DyJyzaYaP4UvCtYIT/ObkkCEEbo4vQvIJhtEZCd6colpZ/yQXpb7q33A6E0TYZ37Yuwln5HTcYAsU4rPNhkD1uVVETgDU/IGZJ5tN3o0Szdgncyi+83mxNqa2EdZru2J/PSfGgrZsfVWa9i9hOUiWwD/QN92uQG0r8YecxKkBQvK5ZSS44RNWQe4Y43VzSoOwCbOJiAaKv+qfcWEFIP3OGPqpZTBk4A6ttLqKOnTeLu38WEKlv24NFTH+QRzuY0F7izypYS0ordvBHWAxHwYShL7jNHfYJeIwARvId+XsEBTfuiS6/WiUZ3Q/qdqv4L/bpEi/5rb/p6wjewx+yZ5u2RYkU3xQpwdJUKESMrO7SvFxt71F0qT3snSnG+wV2gqUENsDhdye9UgHr41zA8hsSb01B5Hox9ppUpUNOxgnIBjAZ6FbOi/iWUzfsLtqr5apgIdRjmmzgOCGFRWgGeV8QZPzs8izBhm+z/O893kinIiwlCr/41qs5S8DkZogQB/PyffHq/Q5JURxxzthV/0CGrSxg9WHgFfsEgaKDhXLGlbtElitu3rjPNz0R6Qbcir2RiHLd/zkOa0FMW5il5Hn2kaiN7isLstPIr+08+SS6xT5AFuwaPdnIxRPuPyhqVtsnQye1g==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(8936002)(66946007)(66476007)(9786002)(186003)(8676002)(2906002)(54906003)(9746002)(316002)(6916009)(5660300002)(7416002)(508600001)(4326008)(36756003)(86362001)(38100700002)(1076003)(33656002)(426003)(2616005)(26005)(83380400001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5eehCHgvdKup543K9835WYbvOfFq7KUPDo8gjY+iMCdnOtG66svEowQtG2QD?=
 =?us-ascii?Q?QT0C0YK9DimXRxM7GAYMIycUOf6IpRpktHVQGdPXdiZYp5vyCCi/t3Ml0BmQ?=
 =?us-ascii?Q?XrG/A7L4/+IBOzbSGLVwyXHLYajZWmWD+hhVtDHn8p5nb/J9FXfpUnixfU7+?=
 =?us-ascii?Q?3+wo2OAFNZEyOyigupVXPOwSSq7mEVcoBYjGJ8C92r8EFFPshh5kiBDNNmov?=
 =?us-ascii?Q?FbiENQd0QUJcIaE8DL91fPNJytW41TaGLwnk+SaUQt6ETlbVA16zJPsrt1Rj?=
 =?us-ascii?Q?46qZx3OFrj6SCQ6dcCh3NPgDJwN9QUhvbUaKQG/ETlnpw8KNNOzIiKUDqmcx?=
 =?us-ascii?Q?vhgL/e8PDpHYGMIRFq1xs6eVbYHCSIRr0BSiUYjBoXcjeElQZF8bqDechC6X?=
 =?us-ascii?Q?My0B8ahfoTj1Mw697Rx0Sk3GstX02NgPJy5E9hlzdUBUy/rnzSovtwTuTwBB?=
 =?us-ascii?Q?HUeMYACP30igO6CmWVMdQiBcKDSvqxwSf8vLZbxlQMQZV++IuX01BQlt3UD6?=
 =?us-ascii?Q?GC8nj2PgrH5mPVoucc0fsVW4/UrHOvjDPWKSwDQZcKDv9qvdnQo0DFCKoLoG?=
 =?us-ascii?Q?G+tVFRndi6Bv389z3iM/INCkK5jwgRgUPj7Q/1lAQlIr3M8bAtxcfb8OZAVw?=
 =?us-ascii?Q?PYx0eeiCUvi0PW8UUcPfCFA9g78gXbTB00kbFpCEeaiW4YVkR2FSIcga2SFe?=
 =?us-ascii?Q?FmgA5TRPLS93s9wRWm60oQEcKrQEfQjDczxuXx30TN/Tm5Spu/ru25NV+h1/?=
 =?us-ascii?Q?R5NSOxgzrNSP6e9k1FfoC1TRSY0/ndQHfxcDEigPhm3GjQvqSnPVUEaTfQo1?=
 =?us-ascii?Q?e6SDMQa5UO9uUAK4LU8jGXgWJF/iq141z7tH3PO9XWkjynEy/OliwFs5wWZE?=
 =?us-ascii?Q?3yN8JyDup6gdURMZYnIubzwJ5+hgxaXMm2mVk23a4IsNbaAqzTEwROHyIDqP?=
 =?us-ascii?Q?5TOfOpksI6kcBBwqbHOrGJEYGK++Z/uywaJ/odrGBTVc5hwvbfvkPhV6eMeq?=
 =?us-ascii?Q?FSEFkGb2Re5rS4TUaFee8Exeb9zdqANoY+rQHaIPObiiVULmvI37RzPFzebO?=
 =?us-ascii?Q?2vHB7Uxq7wpU1siDqzKd8UqryEBshhdU/wiAPeLBUakrq/PVWymgO9/Mpjuo?=
 =?us-ascii?Q?DkwHesRlYojnS/uaukzQrGP6R6KsMQ87T2WRZYciikd4mOtePmlSMhCx6579?=
 =?us-ascii?Q?E3ldrgUI6apwKycv86N7NyT2EhyPGFcGHoFQe4aE4lBleBBl63bSBfxGLNPM?=
 =?us-ascii?Q?fjruXFj/y8IMOzH8YNHR7oE9lH4iNRt6Eg5tqniYwS5FSwQ/HtdVsTb3nnyQ?=
 =?us-ascii?Q?pvjzvu70TnV73RPaXAujH/x4xJiPuCBv/Fid6RVoZoi4Bg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca254175-5f0c-4331-22ed-08d98f3d69f3
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2021 18:06:58.3960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m+axPUrEygphVT4oSBftJ2Fsn3zJ1EFNZfQ64u0yOhSaRPCDDRwkkKOyAoOudqjq
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5141

On Thu, Oct 14, 2021 at 06:56:51PM +0100, Joao Martins wrote:

> > And I would document this relationship in the GUP side "This do/while
> > is required because insert_pfn_pmd/pud() is used with compound pages
> > smaller than the PUD/PMD size" so it isn't so confused with just
> > "devmap"
> 
> Also, it's not that PMDs span compound heads, it's that PMDs/PUDs use
> just base pages. Compound pages/head in devmap are only introduced by
> series and for device-dax only.

I think it all makes sense, I just want to clarify what I mean by
compound_head:

  compound_head(base_page) == base_page

Ie a PMD consisting only of order 0 pages would have N 'compound_heads'
within it even though nothing is a compound page.

Which is relavent because the GUP algorithms act on the compound_head

Jason

Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F5219B3CB
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 16:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749745168; cv=fail; b=VhzXg9RCBpcBVuKpU0IBfraoCnw7mQ97N+tD/ul/tO/KTEmvOSu8w2q9NPUTcaWBnj7LG6W6LKBnvHnvTwA98m0jWNe8Qyaktb+Jjm3uacewhbqrk8XPkTVj90B1vAsG+gntQoKsx88ZNsq5L4P2TmkKfq/jmTLl1GKr/JK1boU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749745168; c=relaxed/simple;
	bh=bC+tbmFrjutZ1pXmQ40npFPBZFevtM+dtwVI90lrmAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=pvezTYgYLPcolAE+nyoLjmRMFoFBDF/+NVYgcn9kRYitkBr/cNkHA+bsw5zv4JLd3wMb2C2dy3TlKrSipnx/Tk/OELJraEPiRZtbXBCumAfYKEQskTyxxOgCNPyCrNLZQfoQ1s3UAI/QHrjbXfdjNjZiPdVlpATfb4m/2nD327Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fd5Lo1Uf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=eOqg10P/; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fd5Lo1Uf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="eOqg10P/"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55CEtcBL003369;
	Thu, 12 Jun 2025 16:19:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=A0iKMajYcWVA6ateq4
	5v2D87KkXadQBUo2ok/jOkptA=; b=fd5Lo1UfxF/GIHgK2hgjhDhW4TDrUxc5Gs
	3lh6f+5UZoSACA3BBqfWLqIRDm9B9FE5j8UjQyQTHwQ5KP/Pp07NPrT81eoxmZcG
	VlR6BxcDW0/I4UTzCZrNxMEVYbJaeGnz4CwnaJAyg++Rl/hHP5IYdKwzAk51nnCu
	f4iBRf7/BxEhHMor4fp41mv7+9lWDLKrRLJlTNheSQ7sU01XYFxHyqLB2Sjc+tMH
	V2j0Wu2HMAobXZQnjb/NpH6JBtBCD7XBgKOZSAxqlqdgGVrFB7COjdwM4rLzCC1c
	+w5Hzh0dVy12ecL7zgVClv8vjlyIzHDUYNvZmFYrLLyjPOoyyP2g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 474c14j33w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 16:19:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55CFHgNE031827;
	Thu, 12 Jun 2025 16:19:08 GMT
Received: from cy7pr03cu001.outbound.protection.outlook.com (mail-westcentralusazon11012006.outbound.protection.outlook.com [40.93.200.6])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 474bvbt6gg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 12 Jun 2025 16:19:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oz6Zy5z01f9m6lpmtKe1uV51oCAYrKnkcIIv0m6opIHsvtqCGeEbmOA8dL3pG5Tce8DmBV/6s6weVnW18JoRHi5vMEqKDOqvwBsHIPqu84sxDX2/jdeCDXlpIDENrMqthaHGlW2xX2oeLEQXjIvr+Utq3MlH2611HqrNTgTQet0V0MzuWNuSO3Hi9Hk99Oj6vfuZmQwkJksgDd9Ou3O/2ED3glB/HmLUCe0wddM9FdY1b7muCPnt2uEFHSpQKxENAR8mEMTV/gsrAjbgztyWGRx4MDBe0lvh5ugtHrZU0yvdBfNeI2MIJbBm0Ngcjhc9deyqBQdImKYEKa0J6udyMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0iKMajYcWVA6ateq45v2D87KkXadQBUo2ok/jOkptA=;
 b=hNDHeTxuC4ss8KAEGp+cXOxjAobzWco0j+8OMAM/2Qa9FrqD7xQlfcYSqMcUYVK5Ncd5DuT1drGqBAPx9ZzD7SHIeZXuatG3McZgNHRkTH0mtgpR3Zlceg4B4KcYB3lTJdaV7spX0rCLqLV7UoBB33J5WWmJ77b6KofGrjwPj9c+/hsj471qeVTlndxssl8YinOsdSG1urubhsBgj1GYsvkMyotitsbtutvDtG0ZJOQY2SmfDSDN4MPJ610bXbJKjQrxLcrvzbdEyF+yCTQhTxKMmtlKXLtqvOcynwNseLJkVy6lkTga5y/xHI3Z/qJ4N8ZXI4AMkhXWsCZfcisuIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0iKMajYcWVA6ateq45v2D87KkXadQBUo2ok/jOkptA=;
 b=eOqg10P/QAi96pwpqd7Kiq9XRw7BljU2WyoVuZJhQ6Ywc8+mYQNiTkIqf+L/XozJ5r+uT7jIREjGr890FjnWQAgZpn71F9kD+Y2ayNUobnBmfUVhZNikkgq9PlCvLS3MK4zTLl0rrY4zqE3WCdl+mpZD/ry7q0u5n8dQZ3GsJDY=
Received: from DM4PR10MB8218.namprd10.prod.outlook.com (2603:10b6:8:1cc::16)
 by CY8PR10MB6442.namprd10.prod.outlook.com (2603:10b6:930:52::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8813.31; Thu, 12 Jun
 2025 16:19:04 +0000
Received: from DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2]) by DM4PR10MB8218.namprd10.prod.outlook.com
 ([fe80::2650:55cf:2816:5f2%6]) with mapi id 15.20.8813.024; Thu, 12 Jun 2025
 16:19:04 +0000
Date: Thu, 12 Jun 2025 17:19:02 +0100
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
Message-ID: <6ae86037-69bc-4329-9a0f-4ecc815f645d@lucifer.local>
References: <20250611120654.545963-1-david@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250611120654.545963-1-david@redhat.com>
X-ClientProxiedBy: LO4P265CA0114.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2c3::18) To DM4PR10MB8218.namprd10.prod.outlook.com
 (2603:10b6:8:1cc::16)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB8218:EE_|CY8PR10MB6442:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ae0fb5b-1876-45fa-3710-08dda9ccd986
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|7416014|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?OVeeovVrILqxuIjWKNyIh/jK/tgJIh9+C8SWA/JWhkBqRbW6kl7qZmqA8Qrj?=
 =?us-ascii?Q?xSff/qUfsX+HZFLTxW9FctwM87b6yfSgPmHPxtPXicu5KEEi42hgBqe7+waN?=
 =?us-ascii?Q?CA+5+p3b2GLGd+C28Ge1TduCno+C4Lb3C2cRnR9MZSOUZpwcZZEpBYPo8lUr?=
 =?us-ascii?Q?wMWZPArZQOXnUvJw/mnwqVtdVHvd4GsXJgShsDN/PpOeO568IoA+7NmCjp06?=
 =?us-ascii?Q?gjMZy3/AzXWJjOAXvKlMT3c6bTmug1T0iQbX/QU8YIzixQLmlVvTOoda6EFp?=
 =?us-ascii?Q?wyEklaKY8UKk8uylkroGv+Fp3nLv2icnmXTdrHVgv8AAQDo8T/A4crCRRhwt?=
 =?us-ascii?Q?eK+r3RAbdKdyg6CrWjDQLUBvjc+5MDa84e8HXs6dLCqJuSHtaAQzxjm+CMeX?=
 =?us-ascii?Q?a/wb1vvrkAIRJx+lD9hs9GHzOTI14oESksA3vIYSL0ITwS5WYEeVWxEK0GRA?=
 =?us-ascii?Q?p7pXQv4ZRi38PSgrxvZP8yqwcv1WJuPQi8CWNB9uyEyeHP6Gs/0moqDvS7Al?=
 =?us-ascii?Q?ShMPq+IBvpcY/SzqbJg5oSRToEJC03wyDZtW1iuMLN/XRIuuX1/1opUkB1Wp?=
 =?us-ascii?Q?9bQVBw0FYjRWiIM2FN/9cKEBszKXW+ClZeDRP+bJrdnY7087N1nc3z7KpbBV?=
 =?us-ascii?Q?j6WF243pGOoPMBGhSRWrJB+1ZdBaU1HZjNip6B420qG1UtasL0DNyoc4+RPS?=
 =?us-ascii?Q?VU5qD4uKIKhjfcMdQoaHjm3/rDYqXOy1ntF9iruTnQRGaqni8QQ2vrPXm398?=
 =?us-ascii?Q?nlqjRC9eQ1Um1L30bE/p4u9DghNfr6jWZrUdm/S3/tSkcZ4lHN6BDQ+DH2Be?=
 =?us-ascii?Q?9ZxCgRNfX8SLphNC59nylBpU2Mb0O4DoPLgv2sWBYl9pd/lNkfUFK+Zf7AG9?=
 =?us-ascii?Q?pyumw7iygw4JqGjnp0zf/ufgfkji0iymziHdkEHb+flJV6611s29Hy4Cexx+?=
 =?us-ascii?Q?OjMhqg40U70n+KXZ/+i6l/dl4/h+lMQPXxvsd5a3m+aL/iqeliYyhqrieCye?=
 =?us-ascii?Q?u7DBBXGGQnCxcyegKZF81T1ttYnbrgrd5hkxYqVZEw+1GqIvK6XGsTElaZnK?=
 =?us-ascii?Q?yLWhgCe6JJ6LBDSbq4/aOI08I8pehEA3lYBwI3RInx/20oxk41+ctpU91O1g?=
 =?us-ascii?Q?wTQE23LbQp6i3Eq3cQ42/5zsdMVPCmHsRjiKpNaDPEXldJlX7i3rfKufLo5T?=
 =?us-ascii?Q?KvMJS6kEHOI3uv2OF8p4zIdu2FmphD3FfTNtSB+pBg1CpBLwdK0FBOVtPRKQ?=
 =?us-ascii?Q?23cuOy7l9xoZIaPDa1LsVWryfT3UK8B6tMxKfX7OuxDxZ0ux2csAYB/neXCV?=
 =?us-ascii?Q?eirKekcADwe9blebb8g9ILIFXHQ8MoId+T43EhnVXfbDZJxfZ2fQBr+VtP5y?=
 =?us-ascii?Q?Oly3R08Hk7Z5pkLVlpK6VvPNoclFulw9ADItlOU1XaYWBSutd/HHF3bXw69j?=
 =?us-ascii?Q?fa+ji0hGfRw=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB8218.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?TfEUqfD2QqgEj5Yxzbe+1/XBZFg+ehclyNm42B51mne8zm3SEifzU/dR55ab?=
 =?us-ascii?Q?038myL1/7gs0njK1txxcSpyn4Ao1U1KmCs1AbG4W5xBJjX3CC5VQ90ahQVKj?=
 =?us-ascii?Q?rCyFSqJHY84WKlW8BYCTnvSZNnaxbPEy6ZpG8Z3IhbawRBpegGPzi0PrycKR?=
 =?us-ascii?Q?IFOYs4NqGdqCF5Q2j6wDJLWrc6SjW3nVMRjTGlpOoJ1DNgsBq9RpPQ4bKp8J?=
 =?us-ascii?Q?vXJ3xHOcDf8Nt+FBdoR7kC0OsKEt0EcAvvTszs5TplqS1hV2JetQvFE74Jr8?=
 =?us-ascii?Q?V2dt2rg3+SbRhScpI35gprDlfYxoAuxEQ0OLAMh1+Xne/ixYhplO3b3Z+vZX?=
 =?us-ascii?Q?c8Gpu38xMrE2DMgAMH3r/W6QWaTOzfBmEMfczfiDzN1IOgWclsoMU/46Vqcq?=
 =?us-ascii?Q?7ZPV/NkwVsNqAUfk/hfaTfhcpcp0YiDcuGT6UP2FgInX4K7ni4oidy6NXaGm?=
 =?us-ascii?Q?KNNCjNUKoQWM9W62tPXVtyP0xBF3utCQKpELKLiFpC98IWlJODEZALM5TZrf?=
 =?us-ascii?Q?leMWdwUiKfxa6DVnRmjRUzB/n/CcQDdnDLfhtZbgX0RE+epO07cTKM51Vm0J?=
 =?us-ascii?Q?6QpzvYsbEHJgrQA79KKuNlS/LQB5c3rwiz3ooBN+eUcB4rh3tcGY40anAOnN?=
 =?us-ascii?Q?dGRmss5j9xFoU4ugE8dYkhDnlEqrBTDItwQjUK8xAGlUoxiwCNRvQ8pzxCVf?=
 =?us-ascii?Q?zOJm2dBiwg18yHUNuN89QJC975HiEMw0cSC7Iz7QO7cwxoRPRdZsD09i/sXE?=
 =?us-ascii?Q?eR/JjNPezSygu3LWXW/dZEaxYi3efidBWBQWefJdoWMoyvUXjWkfi8D9LRz4?=
 =?us-ascii?Q?WIrhL9Na1WZrv4WZsdkmD9XYj+NZXsawGJZcAWpfRDcUNlgqlPAyNbqTJgQ4?=
 =?us-ascii?Q?/lKdXO32lbnfsERLANBRUfKAuMuXd/NdZ/0jnz95SR5jkuHVitGNAtX25U/L?=
 =?us-ascii?Q?XT3suLThIxdBTp4CTAr/tK1XQgxCYHKc12aTx9K36kpYiGTVgsepQzzYv9Bw?=
 =?us-ascii?Q?mhO2CWkvwjyVr1jO7quBRDkdKa4fpr3L99Xn4LLTg1NWHnc/863qEmiB9Pas?=
 =?us-ascii?Q?O+JRvVxsjLbiiBOViia9v/xfGi5mzpwhRxEVEWIPdBWdXeF7MFbSHVkJXHQB?=
 =?us-ascii?Q?MeV994xFjTfiHaRQ2TiuI1QV4V0gpvKPpgKIGx7QIGxkH47vbYJpsSyPG/VA?=
 =?us-ascii?Q?NoJJ6br1g5c9849V7cjPXmSayTgzJ7fos5SA7dAJqD/oRbM52Mmmtd/4J3bR?=
 =?us-ascii?Q?SexnIaUWsq9YnTGJzf16L7jfTvsKbmVGsqxbFz2FCBGhlIrlKmdP6+SAYD51?=
 =?us-ascii?Q?ApMjBZdTCE2virH/cPuiQs8fVZz/z8CjNbJ0mifLkc9laCLBZNid0hSct+pA?=
 =?us-ascii?Q?oxNBlRRHr1J1WRmtejj3iK5aEWI48qc6aoZ3Fi7wHhXGQDIm9ltaSLlYi/p7?=
 =?us-ascii?Q?qfyUxPka49x+ra1hIIW36t5RB9AdgvZhgYwnKxu3L/XDmALmTdsP0PC5x5jX?=
 =?us-ascii?Q?yGQ5yKpTTSvwPajUpzM5ECwjAYDPLHoG2cl3DRhQilA3OwrJw+8fGhjwJmYK?=
 =?us-ascii?Q?MeXULeHkGsHSyglrxBunDfAkIcvHzMFpEIMQ/CTOzDzZouJtqAxzFfIQIF2+?=
 =?us-ascii?Q?sA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	5wdXW8XXqSSb3fzGQaLTOzxbMfAwJPq1hGOPNPJ0xKppk6h0uf4gCytYvhbdyQekGuiYRWaGKeiCEQFMyxVyYCOOUvucZVqWMak97Wd0D3ssc+MQoQX0Jby1ihkvAFLeOcPykxmSDQjFqMyAnr3fREzTewazTElQx+XMnY05aGVHccukxwCi/0eueJlLJZRAqM62fAvhrPP2SNcQ+Tqt1apWYpgeCp5sd6KVQIKJFv0NwVNxMj1W2d00jzw5yIHg61BkdLaVDINqeUIbk4sj4SCJ8ALTqk5aRLIzkdDopaCd4JhnSmh9UuMzN/iD7Inh+TFEN4lENvuL69l311hyI37xR6iiHwxzK9YSUN+G01QsMnAPvAIyHisufkfNO2ZI8q0MPMrIWfnikrp2UPBHXuYM83A4wtzmGVlhEgaOCNZl9OSrx4BuvCDz2TZ/NoM2QsXDX3P0WTy4+4z7XyyydhwFzSubx5LayfAX9WBT9eD9+8x7KRqXPZ6BTw8y35JiuJURetrPgyCMa/P8XhSxRCt9QTl3bR58MgGS92HaPKXfr97N5g/BjBLACoiWcyD2UbqrpDWNuMUWuPF3c4qTCLd1RCSrElwivaRfJde8vdA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ae0fb5b-1876-45fa-3710-08dda9ccd986
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB8218.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2025 16:19:04.5408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i/0pYkTr/t8QrauCp01PB4/LFFaVHxeB1TrDzWCAOjd9w4zw63kZ5kFedvd94J0LQ2AlEwvnN2f/nheRqresiyOA1bmuO3rlo+wlr6sk1uY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6442
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-12_09,2025-06-12_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 suspectscore=0
 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2506120123
X-Proofpoint-GUID: 79KZNca3fhWVOQaTD05q4TgAc17KUxFW
X-Authority-Analysis: v=2.4 cv=GcEXnRXL c=1 sm=1 tr=0 ts=684afdfe cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=GoEa3M9JfhUA:10 a=Z4Rwk6OoAAAA:8 a=Ikd4Dj_1AAAA:8 a=yPCof4ZbAAAA:8 a=VwQbUJbxAAAA:8 a=1XWaLZrsAAAA:8 a=iox4zFpeAAAA:8 a=SRrdq9N9AAAA:8 a=20KFwNOVAAAA:8
 a=7CQSdrXTAAAA:8 a=QyXUC8HyAAAA:8 a=YHZSYJ_IQiXAA7_1X5wA:9 a=CjuIK1q_8ugA:10 a=HkZW87K1Qel5hWWM3VKY:22 a=WzC6qhA0u3u7Ye7llzcV:22 a=a-qgeE7W1pNrGK8U0ZQC:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjEyMDEyNCBTYWx0ZWRfX1Wm5NAd3tY8z Z7gbQpeQa9fw/UQJ3hpjTvkkp3ff2srHq1p+6K1nKdcP3z6kqqMYVaj6PoaqHGxjznkthLRjHuV eln3+wnYyowpE+AmNNtDsrdnRNrRsq+tZW9wqd7GbXy3IHpnJfg3iNMyuXXZWq4q5APctNb6nwY
 gZ+ILMPkNTs5pOONyW9Ei4QxU2LqHuv4fA4Q4CiOoHGEjG1dF13rHJ963CoYOFaYVC7u7NKHc2V K4HEUCk8SXr4ReLEr5pBTAcJ87L9lA8YHGZfk3dUMiUt+yDLyJ6RlczawrUbAMxL47MGjUgjaKi ZoCYVH2Cg7VmKjtO0FbnIodN84TNN7yrSVuEwxDJA3/G52Q9Yyxqt0Lh3yxTYleYSHC9lSoeaRa
 HbRPtPSOKo0dxY9WCO/dtdrSAlzBBGpEjfrnGp02qsDDsk28omX7FQpmexWn2Gvv5kXlmwQZ
X-Proofpoint-ORIG-GUID: 79KZNca3fhWVOQaTD05q4TgAc17KUxFW

FWIW I did a basic build/mm self tests run locally and all looking good!

On Wed, Jun 11, 2025 at 02:06:51PM +0200, David Hildenbrand wrote:
> This is v2 of
> 	"[PATCH v1 0/2] mm/huge_memory: don't mark refcounted pages special
> 	 in vmf_insert_folio_*()"
> Now with one additional fix, based on mm/mm-unstable.
>
> While working on improving vm_normal_page() and friends, I stumbled
> over this issues: refcounted "normal" pages must not be marked
> using pmd_special() / pud_special().
>
> Fortunately, so far there doesn't seem to be serious damage.
>
> I spent too much time trying to get the ndctl tests mentioned by Dan
> running (.config tweaks, memmap= setup, ... ), without getting them to
> pass even without these patches. Some SKIP, some FAIL, some sometimes
> suddenly SKIP on first invocation, ... instructions unclear or the tests
> are shaky. This is how far I got:
>
> # meson test -C build --suite ndctl:dax
> ninja: Entering directory `/root/ndctl/build'
> [1/70] Generating version.h with a custom command
>  1/13 ndctl:dax / daxdev-errors.sh          OK              15.08s
>  2/13 ndctl:dax / multi-dax.sh              OK               5.80s
>  3/13 ndctl:dax / sub-section.sh            SKIP             0.39s   exit status 77
>  4/13 ndctl:dax / dax-dev                   OK               1.37s
>  5/13 ndctl:dax / dax-ext4.sh               OK              32.70s
>  6/13 ndctl:dax / dax-xfs.sh                OK              29.43s
>  7/13 ndctl:dax / device-dax                OK              44.50s
>  8/13 ndctl:dax / revoke-devmem             OK               0.98s
>  9/13 ndctl:dax / device-dax-fio.sh         SKIP             0.10s   exit status 77
> 10/13 ndctl:dax / daxctl-devices.sh         SKIP             0.16s   exit status 77
> 11/13 ndctl:dax / daxctl-create.sh          FAIL             2.61s   exit status 1
> 12/13 ndctl:dax / dm.sh                     FAIL             0.23s   exit status 1
> 13/13 ndctl:dax / mmap.sh                   OK             437.86s
>
> So, no idea if this series breaks something, because the tests are rather
> unreliable. I have plenty of other debug settings on, maybe that's a
> problem? I guess if the FS tests and mmap test pass, we're mostly good.
>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Suren Baghdasaryan <surenb@google.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Oscar Salvador <osalvador@suse.de>
>
>
> v1 -> v2:
> * "mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()"
>  -> Added after stumbling over that
> * Modified the other tests to reuse the existing function by passing a
>   new struct
> * Renamed the patches to talk about "folios" instead of pages and adjusted
>   the patch descriptions
> * Dropped RB/TB from Dan and Oscar due to the changes
>
> David Hildenbrand (3):
>   mm/huge_memory: don't ignore queried cachemode in vmf_insert_pfn_pud()
>   mm/huge_memory: don't mark refcounted folios special in
>     vmf_insert_folio_pmd()
>   mm/huge_memory: don't mark refcounted folios special in
>     vmf_insert_folio_pud()
>
>  include/linux/mm.h |  19 +++++++-
>  mm/huge_memory.c   | 110 +++++++++++++++++++++++++++------------------
>  2 files changed, 85 insertions(+), 44 deletions(-)
>
> --
> 2.49.0
>

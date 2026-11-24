Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.2
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795554025;
	b=lL+6Mv6ptD1zH+w+MgAjGdOU7Je6d6299T0VwYZvu6OyrWXfLLOFi17kh9UYh/w2c0La
	 dyZne1nnh3EwLVetamLTt3vDpBAHPUj6gnPifSgH1XbrDRg4Y38DQbZ9S1kH6+KiCZg/f
	 5C1h8vFiwA708E6kPLz0pHsqeLeyYsSobqFNQoQWpNekzKxIlRB2002catcpTvy1ZpE3i
	 tZMk8VNya/xdmNTrSqup4jtx4jcJ8H9YL+VVYWV1O2Vp7OfdmqDpBtCdDTKf0isK8hhyQ
	 UQvi+DIPKnLscwA9VK8jYygDwNKqOacMNuB983W45eyBnfqIRlWff0AOTuYyEwODRpg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795554025;
	h=DMARC-Filter:DKIM-Signature:Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:Content-Type:Content-Disposition:
	 In-Reply-To:X-ClientProxiedBy:MIME-Version:X-MS-PublicTrafficType:
	 X-MS-TrafficTypeDiagnostic:X-MS-Office365-Filtering-Correlation-Id:
	 X-MS-Exchange-SenderADCheck:X-MS-Exchange-AntiSpam-Relay:
	 X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
	 X-Forefront-Antispam-Report:
	 X-MS-Exchange-AntiSpam-MessageData-ChunkCount:
	 X-MS-Exchange-AntiSpam-MessageData-0:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-AuthSource:X-MS-Exchange-CrossTenant-AuthAs:
	 X-MS-Exchange-CrossTenant-OriginalArrivalTime:
	 X-MS-Exchange-CrossTenant-FromEntityHeader:
	 X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
	 X-MS-Exchange-CrossTenant-UserPrincipalName:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=jjv1mIIKh04y4Zd7iYGk4WPmgR8svfKmyDKnirK3Tdw=;
	b=W4XJMzLeIWAr36QScw1a+0FQR4JqfJczgzKxO/Ply+5KY6D6hI3PyjavhNyYYyQhvIFT
	 eXan52JzhYa/mQKYJ6C50ziQsrnnQ0rMPPW6+9Rj9/MiZZPPx5g9HfqZ4EWEI/JkH3nVd
	 8N6DbWURXAQg+4LuwnoSQTIlfudYheFyevCQ+Mn32tPHWfGbEssr7ro0a2ThmHv2p/Ux9
	 Jy1EjSGUdVGP030fs+IUw62ljjavEwwDYbQEQUzP8pplM553G5CwDsxMedc4EE0hu8nN+
	 ZPBhTMK58LYAJi87D36L04GJg9d02xbF8kiA4Wv/obvoymBvC2z81mVuJVs7i04tzJA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nvidia.com;
	spf=fail smtp.mailfrom=nvidia.com;
	dkim=pass header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=s3l6xpxK;
	arc=pass header.oldest-pass=0 smtp.remote-ip=40.93.194.2
Received: from SN4PR0501CU005.outbound.protection.outlook.com (mail-southcentralusazon11011002.outbound.protection.outlook.com [40.93.194.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A314C606A33C;
	Tue, 24 Nov 2026 21:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A314C606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=Nvidia.com header.i=@Nvidia.com header.a=rsa-sha256 header.s=selector2 header.b=s3l6xpxK
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=wzA/PFwNEYjYE62OyeMNBApiaqqduK4V0Ev1iac1jZtoH43rkf9+gtjXfkyHxK1FcWGYnVPvs8O8+a+iNMfZpLiedmxE5Lkr50pYF1bZ1QTQOpkc+yj0YibUvpuPOf+X2S69o8KBgc5v/Xh8Z/sCHUc4WI6Ub+fLp5Cdq5Dgc+Dfq/w3s3tNzGxPWBsIzIAs1RNzeC3mgrCiimK7gOHgBq7qV+uiqPWKiwkH+i06naZcd6kl60xbc3gzWPaeqrC2MLzyQ1NNhLX7WrJD0ZChSYKXRia3Swo0Pb5RYFkrVHs20D5UFNEWBRdITKM7fSdTzGMS2XH2q22FBAux/8K+GA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jjv1mIIKh04y4Zd7iYGk4WPmgR8svfKmyDKnirK3Tdw=;
 b=YQwppcOu7iMkg+OsEZ05kUkzpStC4NKsxmcJGLjWtB+rkAChL8O8xNd+Ut/MlfaYxLM4wD+ir8CrKh6M3HAGgofF7s3o76/lrsAOFzjaKAEvn5OoUDch/Pf996KQ8UqItFL90Vz+XRUF0KXEoxy9ZYvkB1QOEJWRWsJg6Gv6WhIespinTRUZBD3872Km3FTKq1iKv1nrz9FsprKGr9k04nlgWyI7nAj5rp+uch41VZTtrd+VehhxAvdi1EcqhjWN+v10vxFXLd+GPqITqss21askUl7UdTGUF3AFHgihMfJJKTmb/XY4K5WigASIburqiIsIKpQu0sV1KQ4c5ip7zw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjv1mIIKh04y4Zd7iYGk4WPmgR8svfKmyDKnirK3Tdw=;
 b=s3l6xpxKdMnMnkuz9VhhUc/A7JThxawOeRqHcd7Ixq0xbwJPnOdbmmtgUk0XpkxFycDyfsWCGCUrEx7QSAEQY1650XvNOUBogVd1AcW+3PYPM/ecQMh8WxRGRh/H+qzJfztlgYbORrlF1zizIw7LWMuIfoeBVHuvmByF8khzQ6iwiwY3j4RFiBq3xQTLJYaJQ8HX7e60BXhKG4JHLctBPVnzCry7h8xIW6VxCdGS6gKTw3TW4ulq3nJfkwAtWmMPUxhk8Kp3/ohh3Ou2cUHDtNPGXT0MjljKwAkYrr2q9VTEJc3TUZNh+5AAdE9z0b/q0ABhSWL89uBgT1TQ/FcasQ==
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from SN6PR12MB2814.namprd12.prod.outlook.com (2603:10b6:805:72::33)
 by SA1PR12MB9245.namprd12.prod.outlook.com (2603:10b6:806:3a7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.639.12; Tue, 24 Nov
 2026 21:00:12 +0000
Received: from SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59]) by SN6PR12MB2814.namprd12.prod.outlook.com
 ([fe80::9a18:413c:9702:8f59%6]) with mapi id 15.21.0639.012; Tue, 24 Nov 2026
 21:00:12 +0000
Date: Tue, 24 Nov 2026 16:00:10 -0500
From: Yury Norov <ynorov@nvidia.com>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>, Johan Hovold <johan@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Byungchul Park <byungchul@sk.com>,
	Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Michal Hocko <mhocko@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
	Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, driver-core@lists.linux.dev,
	damon@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 01/60] nodemask: add node-state iterators
Message-ID: <awX62m6zlghC05jo@yury>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
 <20261120-private_nodes_v6-v1-1-74f5f9a115c2@gourry.net>
 <awMK9V6TbU9Xtzn9@yury>
 <179544248227.412063.16491857533875192357.b4-reply@b4>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179544248227.412063.16491857533875192357.b4-reply@b4>
X-ClientProxiedBy: BN9P220CA0004.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:408:13e::9) To SN6PR12MB2814.namprd12.prod.outlook.com
 (2603:10b6:805:72::33)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR12MB2814:EE_|SA1PR12MB9245:EE_
X-MS-Office365-Filtering-Correlation-Id: 9347f340-d6f3-4f83-827a-08df4a6dee49
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|1800799024|10070799003|366016|23010399003|10067099003|56012099006|11063799006|4143699003|261021121427099003|261102123227099003|22082099003|6133799003|18002099003;
X-Microsoft-Antispam-Message-Info:
	fgkd3OzRnSAvoGcdjsAe3uNhI9s9Pbkslz2vW2/gxCqtyreRamJ2IEIGocp7bKFVCUUzwImeXhoOXqEjICUQZ+0VS3YTaggEXQ+ybQ71vhmLLKVAHIcqh7vW3BLVckhC53mQNhJWjauP3V6U2QyWEuY7pcYJYZYHEh6tBsgTO2gPGVhZE6FcRsF0hdhrhvbGE2v+5gZdQOPMy7R/owlf4rFWCDcN59R4js1v/nxYDlYZhWMnSkUlPY7K6oFxlWZLncFaOLvlSvzxtbL+odvJ+CzN7PdYy152kBxZRKzEK2HAWmlCg9XZJ4ArbJYWl/OtTPulx4FbMpR+DXT9ap9Pm5KGiLoE0FTmrWgeVLA2IccXTPWWS36bbEnkf6WLno8kipjQ0/w1PuGUYGwVX7oE3XBdjCwbtphnpnFaC1hBEMbxvgbefy3FWMdMOWhbKX2BbHoTrTOW18UtQrvLaRgYlFs599BEGbUANwRgljg+JObzxx1B4SoHLkmWY+OupVOvFDzeXxsvF2n4PwtbyhmZeeSi50RBU+SM4+ZQ0MWr4/8qDCm/L4J0KDSZvdZZIwxQKlx+xVtMUmSigligQmC8FgKSW3nAwKfQDf0VylGNB10clDcd4CtzmxKGDB0vWO8Gt46ur31yp68z5h7u8LHSw1yVzLOOuQ/Y/syaFKYKVxY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR12MB2814.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(1800799024)(10070799003)(366016)(23010399003)(10067099003)(56012099006)(11063799006)(4143699003)(261021121427099003)(261102123227099003)(22082099003)(6133799003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?lyl85Xv3fhesIPLeycCkaFybRKJ34uQuDibWvKU5AY6uZlXfBQ65O1p7YvAG?=
 =?us-ascii?Q?PkyYgYLe7iNzqCCPgouRZrXlsuUaxZWn/pg6HOmqNZZj0h83jSf2cP/uxgIW?=
 =?us-ascii?Q?CCW86034F5qiPat10OCStCeS8Pmw+N9phXIdZscpIhYGYlmc7/TDqWPV0Xa4?=
 =?us-ascii?Q?Ay/4f0zLF5jAdeXsTenIkBeOiv/ut4olLduwNbNSJl2TTgPkzSaLYRWP0/kA?=
 =?us-ascii?Q?hOb4NZDxEi6vaq8bbwPoBI9R0MpPOM0atXpQ2M+DAgxNj9mdVesy1b4R3xRe?=
 =?us-ascii?Q?Q93KsVu0zUbKxGKE6Z7hvzWVFMEk+xor0nppHHmV6xIFev/WGys4uWD7DdAl?=
 =?us-ascii?Q?4lLNoiMxqHNl+RZ4FGZzc+OtiRRxYRPwT96Aw2QArtjLH5h/uxUFnIIzn7Rc?=
 =?us-ascii?Q?scJJqyETQUmL5ah4aV7Q7Vif//BGaeeQuwBWjQqU6LxkVh4jZ5RUb4YGMiQp?=
 =?us-ascii?Q?Kpln2LC+2ABGY2qgLKdT5kCqlbODnNbD8+nEuLEFMnciIOzh3yUFDoa7C5jc?=
 =?us-ascii?Q?DbTFnKCKtAhpZxEYRCtFWTGcVQToTwWKT7NrUoTCsfnMFK1pX6jEw3RRueha?=
 =?us-ascii?Q?X0svnLqYHz5u4LYrR0oWMcn+gzkF5Vp9HEZdkCFNhgg5Hl5wbxhFsjs358vH?=
 =?us-ascii?Q?qa8+l8k2v4d1TXGv1t+R0SYRN0be2/+/oSZrdEmtxqStWYay53nm/MsRb18n?=
 =?us-ascii?Q?p3/oYrKkxuORNlvDS8QItuWk2ajNrLlYz3Gvg5tspRPyk8lgeyuwV9xZ897M?=
 =?us-ascii?Q?ONO3Gai7AbbsN15couN2omI5YeVUCXtKU1aL1L37Ii36SnXZi2THlk9ceKZL?=
 =?us-ascii?Q?wvur6EzfSvWZt4kdtZc/6gpTjUd+e5q9obOzoC0KiNBfkqPBv9vkMl/Pf/7L?=
 =?us-ascii?Q?eepALf6IZ30Loo7UPUyyje+Gt7x6kAffBTxUYbjGI/4pPkW9oKaVKo8LibOY?=
 =?us-ascii?Q?Ln9jPBAk8ilf6MMeZTdGUTfWxInVn90V4LtpLM9AZkS8DOhYWukNSv3ldb7I?=
 =?us-ascii?Q?6J+sfvHqn7e/qWlxunjU+4HyyygCQjKApug2uTMwDKWrxOuYS1/XQA1hXkV8?=
 =?us-ascii?Q?V2qs7+i1zHykjxqKc2R4ptj5vKrXOzEWe+GPbHWVO51OnKW2NPxqlP57h21J?=
 =?us-ascii?Q?KwfHVSDevPLTvE1SX1qbbkUSAKl25oRpxc2rjZSmSmapwEbRdCItTwAN6x+1?=
 =?us-ascii?Q?Cq2dwAZf7jP4KgTbeBY98+CM6dFeDgbOE8EUlEoEDYxulnVaU79MJKpWXCD2?=
 =?us-ascii?Q?oGlYkVTbl/ElTR8Y4cEpDWh5BgInuYr31HXSrDr24oEmmd94wTUHBfxIo5KI?=
 =?us-ascii?Q?7Jf4N7tpUdAUl9rrJHcuTCDmOhualHiC7p8OoWo8rMouvSXKObFrQwvR3Ynj?=
 =?us-ascii?Q?twIRQ2At4jyhqolbnUbAOE+yka0pcYEqb3DSOk/oMzti9YviNMtNPN0Sw/m2?=
 =?us-ascii?Q?MTZo9pE4mgiuTUjJ+XIUGFN3oJ2RJuA1TJs/nrTDFzkpjhG5lq4ekFeR5M+n?=
 =?us-ascii?Q?dMFiskhcVUHefgqFrW2wcLDnqRKwqRSczA3CRily70aAWDXGN18AsPF1Txq3?=
 =?us-ascii?Q?Jy4PIWNhDR0XSDr8al9oxwjbG0vdvv6oMzF+Vn4GynRVnqILtthkDd7Fen7U?=
 =?us-ascii?Q?H9GRUbN5AMU5sNEtUickR07I0RbYVlUtBJV2eWldR/9CS/aOCqJoSv4P9JrX?=
 =?us-ascii?Q?7Y2jWpAs6jwzDijrncu+unJVOGm4mtQHgzjnGVq2SePKHry8SQgJq/rqXjpT?=
 =?us-ascii?Q?DgnIhSzHDbmmsMeba/3xSNfuhWNJ6TxcCs90NEspDOvzRA5+6TB8?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9347f340-d6f3-4f83-827a-08df4a6dee49
X-MS-Exchange-CrossTenant-AuthSource: SN6PR12MB2814.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2026 21:00:12.1844
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7d9nWnGlSsha9Mzyfzuo8O1ajjPwmA5+pwYtPFzuTfGiKubPpUn4hBTm3tooE3DqsNdJIJImecJef72UZzrs3g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB9245

On Mon, Nov 23, 2026 at 09:01:22AM -0500, Gregory Price (Meta) wrote:
> On 2026-11-22 10:32 -0500, Yury Norov wrote:
> > On Fri, Nov 20, 2026 at 01:08:52PM -0500, Gregory Price via B4 Relay wrote:
> > > From: "Gregory Price (Meta)" <gourry@gourry.net>

...

> for_each_node_mask_and() would be more consistent, change just requires
> passing node_state[N_MEMORY_X] instead of just the node state bit.
> 
> > > +	for_each_and_bit(node, nodes_addr(mask),			\
> > > +			 nodes_addr(node_states[state]), MAX_NUMNODES)
> > > +
> > 
> > Please use nr_node_ids instead of MAX_NUMNODES.
> > 
> 
> I followed for_each_node_mask() which uses MAX_NUMANODES but let me
> look.

This is my glitch - I have a series switching the codebase to the
runtime nr_node_ids, but didn't merge it yet. So please continue using
MAX_NUMNODES. I'll add you in CC for that series, so you'll be aware.

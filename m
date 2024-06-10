Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9D6BA53;
	Mon, 10 Jun 2024 12:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718020924; cv=fail; b=CYMUPnRxNbo6I0gu2L+KQH1dlyjqEG3LEGF9dg+zUQ6swkVyQdEBcPq3HKMQZyPHztRND7AtrG0bXpPfhr9/ebAZALDF1bDPb1I8DLO6E+dXCT1AjH3wkCn9rILYpvvSeay428mluVs8w3kpWJ2OyRv43NkKSRrhayZS7nCInxk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718020924; c=relaxed/simple;
	bh=+WwqoU1EfoyiJQiJDfJBhGUumRrLtQX/Otq3XZcIBZc=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=p59se9OKIerrsMAP90N4kq3+opLRKVelekjz26uxh2L/aomN3i7oMHuuEdOInX64TqA/b3hzwJjjIdgTczQrS71q8vyuNSCQ5qFGylDBjg9RvPqmhcp7R7gjO7aubeKD8r3sj78tzAVd0Lsqm/BilXtQyhSc+ynJ+rQdJtHjeGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=epDsSsNO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Cl3w3gdn; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="epDsSsNO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Cl3w3gdn"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45A4BRqv011435;
	Mon, 10 Jun 2024 12:01:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=OTAP4YMFbHMsoj
	BQ82IZcf83fSLJJVLsZE9VQXkZfWQ=; b=epDsSsNOR3IAVdlY8WAzCtLXTwcCf6
	EhvLCl2dEhQuubmcEFF2U9HYTG3ovKb+/J0qktlBX6Q3/8yQhIbd77azXGN4Dcsr
	KaevlJv/t4S4gpkK+WePrMaHgRH8tQxBXhxDFCxxq4vsU8yNsyyFKffy04wGB+8Q
	HUNOAkpsTBlIFhymWNMNwvJWqWYFxgjAMZmoXVD5Xegyh+xItQHybkgPYbAcOJM5
	bwiPeyVfWe661y86BVV7upByo4J5S+D/bCafUJ53+79oPe3aVM/XqfUqO3jaLgBw
	h6rhc+UhoQKpUDsWlDtWJr/slo2aQGc233ANujPjHkbv7dpPfm2cn/5A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh3p2cpk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:01:44 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45AA2huC036460;
	Mon, 10 Jun 2024 12:01:43 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2100.outbound.protection.outlook.com [104.47.58.100])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3yncdunx1e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 10 Jun 2024 12:01:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/pBRUA4beGVyxtclzqMCtrmlNIDZceRo0JWRZ/qvs2fLeLwX3RbXtDJOPTtxeyxaUdht9O48bXNmsEfalGgBD+yXiUAo8BGSlfaRo+7RxwVdfjbFwJZrscTWKNLhGFTxGuT8BB1QoBsuA8tBMif57cAnrgI7MnM0yvbeRpiWTlJD8RnS4IGBLhLjTNKgtE7rhGLjJREVMcydOKD4TUnefp6gg7HImeY+KWx3Gf93PuZSVL6aw0SuT9PIAPfcqmhAAtNXUv0TauKQ0WKU57lkZiurpW+9DQQE+lz/+w2D/t+W5rWdqEsn7Il0EnMcGCZRCfgBlaTujAK08HGDy1/rA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OTAP4YMFbHMsojBQ82IZcf83fSLJJVLsZE9VQXkZfWQ=;
 b=RoYl2rT3xWrqvn6c7PAlj6aa0ip1u+/GGvjNokj4JOmnPPGdPcy+d/jnhpjDcdaX+3gU5smDc1VmS/yblPskICeDUFEebAGK34c/vYvk4qejWgz2jqTOL4ttONoNdgW+irzZkfZ2IFL9pNugnCb/SLaXHXlkLzOFyCEVNzKI0PgQsz3Rv9pSoDKZIrYHOlaHj4cOU+LMREw2x3AQGTNQNvukFWTvbcDoBMq48fcn0VfV7Eb/u3kQIqeT6aCGQLZtRPZZSuklulMeNJW30qzC72M57c3nsyvJ2f3/Obk+Idt5GXSci1JWQyZVl91TrMr+cvEsR/SXj4Fn6cHnEyvoVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OTAP4YMFbHMsojBQ82IZcf83fSLJJVLsZE9VQXkZfWQ=;
 b=Cl3w3gdnsOJH2UxiXkLr+fYMkARlRuolTvPxlTfs5M3LECqt6U/Ilkt/O4LSs6ChgywPIgS05zZSOGdgXc1/Z3BA5mUIuKa1n+m74nSmbKw1HYhZLJdlNPMvOGCYse8V2o94UokaH+Qtg7uS6n9Ro7xDZY6vM9KwtjipoGZvniE=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB7285.namprd10.prod.outlook.com (2603:10b6:208:3fe::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Mon, 10 Jun
 2024 12:01:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7633.036; Mon, 10 Jun 2024
 12:01:40 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Mike Snitzer <snitzer@kernel.org>,
        Mikulas
 Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
        Yu Kuai
 <yukuai3@huawei.com>, Dan Williams <dan.j.williams@intel.com>,
        Vishal
 Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>, Ira
 Weiny <ira.weiny@intel.com>,
        Keith Busch <kbusch@kernel.org>, Sagi
 Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
        dm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
        nvdimm@lists.linux.dev, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 06/11] block: factor out flag_{store,show} helper for
 integrity
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240607055912.3586772-7-hch@lst.de> (Christoph Hellwig's
	message of "Fri, 7 Jun 2024 07:59:00 +0200")
Organization: Oracle Corporation
Message-ID: <yq1y17d2ehu.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-7-hch@lst.de>
Date: Mon, 10 Jun 2024 08:01:39 -0400
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0055.namprd20.prod.outlook.com
 (2603:10b6:208:235::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB7285:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f4e28a4-9ce8-407d-2734-08dc894516b6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|1800799015|7416005|366007|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?ZlJZEg9c6I/YilgcWlheMHA7wxpf/wQOYwzJtJKt0zxV9kYq9dwEKbqTslzw?=
 =?us-ascii?Q?uQzVW4svzFOFR4O1RsEZJ75VnSdOdGTVzT/E5oT3PNTnfuMd2p6EZi3lzXb9?=
 =?us-ascii?Q?ocZ7txsE+fUVZsqQDeeBRA5uwH3L5fUQEBMawictTMOLccZKUgVZ+kuYumMB?=
 =?us-ascii?Q?VnTeISaOvGa6YwGO4cDGEj4tEtRW2MFKQpgL/m4dC/ubfjM7/RIS55vUnppw?=
 =?us-ascii?Q?BC3I2HRqispc4/oshY6nytWpJbiP4ZDZxtSmwzT/WnqPveNSj76lgKJKixmQ?=
 =?us-ascii?Q?iZ29hW6ISB+OM7iJvvwxXUJVIQjvkhUsW+XIaszFy2hVo62ywfEi4Flslpw6?=
 =?us-ascii?Q?el1TBaZHQQyBDvOmwziNUJ9KZCw+3PmmCprJKZXvs7z85h7T3zqvJVEoeiEj?=
 =?us-ascii?Q?MJJKIK6+2dGuTm5UC3Pl6gwvgcwUDbQDpQLsQ9onlVED47CVW+7hnK/hul0n?=
 =?us-ascii?Q?mmuYI6mN0CmrhBOa3D/a4Y8xB6s7a46MmqAlqBNxKnpszq2Qp1mBfRHLc8s/?=
 =?us-ascii?Q?77E+ZStoPLq7qrH5dl3u0SQ/ayJjPO3IxyFNz/6izs7KCgt1BRys9w4tgALx?=
 =?us-ascii?Q?5MUaY5OLiAQfawbZBZMrlsO/H+PcuA2yP5FqZpjmHDUU7AbzGQ72ZwUElhml?=
 =?us-ascii?Q?URSJXiEYdJ3Y8N1EwTtedznXu/48uLcyBkFMTAZUfOoMBBayJ9q5PkBUprIF?=
 =?us-ascii?Q?VFJwozVBFwjhUkCXocZPH+G8p5PgU0ikUktJpPjg2wC40iYcoK0qJ6zlri3q?=
 =?us-ascii?Q?cv94CqVOdo9uPafBE7XmWGAD6qRvzjwkXwcs128Dq+XGgaP9k3hM99mvYoD9?=
 =?us-ascii?Q?NdqrPaKPqUw/MGdmBJbrh4ZBFCbU3Tq8lWSM0HxjT/HdaxeWDqahr55KAoAB?=
 =?us-ascii?Q?L0ToUOlG+8yBoRhtx4mrSc4E0Xy1v5vzxwycgxBpo5kUTqf50uP/IaVRL1G5?=
 =?us-ascii?Q?eJJAnpd8RsPbDTd0JTiBOjy/BYVxKsxOUrA2w0aolkgK0c+uSgGA+qoG8dd8?=
 =?us-ascii?Q?2Rg0YIKRLO6wz3JSeqbBiUnGQ69hHyJrb61eL7NAsYS6W3FiU75jN6h7uk/e?=
 =?us-ascii?Q?3beURwsH0FVdc7X0DhG6OpxVku4NqNfrYVg0TZIcsGtaWC0+3IeC1ZBrRZZi?=
 =?us-ascii?Q?e5XDKllI3wA4Ic7KBA2paJTZZGVNzlpRHsngBKz2sX3JtaQiVampjGdbgUIY?=
 =?us-ascii?Q?wxIFk/vkP/AEeEGJ5JE8FFM/rGie1ddIIDLT45MEQ5t+Gu7IF77GG8n479kH?=
 =?us-ascii?Q?98qPtHjqZxEciU/xSy1dJ/frytoUEoCxVn4iu5TXs6hLaYIoWJQmxQOyVMac?=
 =?us-ascii?Q?nUafWohmRE7Itk0pz0ltV3fF?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(1800799015)(7416005)(366007)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?wTlYNCGCO0jtRUYOI3ipTwKoypbge4CUtjMwdBYwuYHQD2SdpznmvNEBrynK?=
 =?us-ascii?Q?K+ir5CMTgugqnHt/Vo1hC8evnB0kiymv5dW08EwLJfXnpaExOKibkQwd5AbI?=
 =?us-ascii?Q?VtATdImPhiRhcN5TqZ37IHd3QFkXQ1glJzMITAVKNicYQW6Sy8PMhG49OPgJ?=
 =?us-ascii?Q?7tGjf0MXPqNNnI7/zD4j7eLA884HLooKTF3PL72zbL/yvtI3roZmHD8gFIo8?=
 =?us-ascii?Q?1T+NXJS2N+MBz1rJVTFJK8mctQnOTOBHHQykxrwAK7oQFn4Vit7reS+Fuvw7?=
 =?us-ascii?Q?RU2NLS6RVKrwHbYLMwBT342wRz4mr/ZtyW9IzGNtth+lJnm8Aj5piGa6FOn7?=
 =?us-ascii?Q?K3Tz6X8BWYhYDfYM7K0QeIpi5fhYKRuUe4MfjSkzNVSpwUHjnAgCPUlxNNgw?=
 =?us-ascii?Q?HLk2uP3AxcmnqHkAtZwaRYoxs6YR9nBmSmOZ49NPZyiLyJB2xX4dWudQktX1?=
 =?us-ascii?Q?yP0OKV3ewwjRfeGQ6anXBQo7Lq/HFeJqPafi4m32e+jZaIosdjdxnIInPx1L?=
 =?us-ascii?Q?DmDfU++2SIIiVwW2EhXIu/FyJAQaQOFe14O4z8LWL30QDXeihKaPel2BgTTA?=
 =?us-ascii?Q?hRAwlOaHMNjezFuLfSFHL0ReZ7RdhwRArE0wG4ZsEEpr+WJwNPTG5D+XjBOV?=
 =?us-ascii?Q?wU55AYv9/TWWaMzDXHPr7nP6qr4K0hBlf6R6GjUTYBG/tDkdo9VaHHLbjE+0?=
 =?us-ascii?Q?ZbJ7fn9fMrjgeQ18ucde410xYSU4Z8BMV90ovTnYZBEUdaXxVM14vE7TGq+y?=
 =?us-ascii?Q?9Q3efl0QUSsQ9DLd0Y9S8d4AEQrTZH3+0s28cZRM2MYTzSmqygYy5R+5zjCT?=
 =?us-ascii?Q?Pfg/LqBWzBdu8ilgstmcMWMybs2iIljOGNZPydzteFLmUX+NK84ImmsGWysP?=
 =?us-ascii?Q?0KNYM/3zcAK6JX61xDEEtMNMdBiXEsYJrHLydgQbv6uUibi68E5C7mAbLTLk?=
 =?us-ascii?Q?rJOQB0ihlk7DSOduR2DAN7Pk5CGrFqBN5EIJiPx+URCJEof/vWsh3xCylbCz?=
 =?us-ascii?Q?Yj3c6lfCRc6UCj0LNsGegckJOQw/W+0bY+Vks5lEGdu0Hrm330xnh2GyD27w?=
 =?us-ascii?Q?9H9Heo1GVprPv5dV0uXok7FLQRMHKowcY/9LwNQE4VocjhuuxjpmR3gQOE1H?=
 =?us-ascii?Q?2ttcEXFSV/2rUXv4WBrqrIsaZ8YZiw1LzWThOO1vjDwOT/1hO2dgozWFj2lu?=
 =?us-ascii?Q?1xGg+jcKUk8R1aora6dDm2I4nsAIiM2NTe9ZjT9kvufQJFfetD7X4RoV39ob?=
 =?us-ascii?Q?6ucsYZX/5TkZ54Dd6XX3XmJfJiLs55YnN1jEdkWNmG8ZVWGU/l3ATjucRCg3?=
 =?us-ascii?Q?N2Gs8J40c1Zh9aKwGRm9kyc+dApUs0ziisthn9CZRF32gt+18+V7RK4wYu5Z?=
 =?us-ascii?Q?Ky+3TQPKpSe1F4I07F5ZYMci7YduCMoC7VN6p1pwLbI7Si3QYcS9Y4DNjDvd?=
 =?us-ascii?Q?eLiRsE++b1m1i623OFINSzabpgjkWZU1eZhlBxmZYwJXJm80IQA8oQEFOnvC?=
 =?us-ascii?Q?mKuTY+UetUCZ7+G3UpUATqpYHbvF3hhIHnghT9xGSUQl/Jjf/4wqJ6AQF/JR?=
 =?us-ascii?Q?o0S7HDlFEsXE37WF6P4rqMV+fKA6BzUw/cqoaV+OiYk1HYRYKvGYpOud3MG5?=
 =?us-ascii?Q?OA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Kfuh6v3J3Cryp8gVT/qu2L9V3GKCpJKNplLtUiYYiTwv/oTWmDgMk9MBHlTLVDKzbs7sm1ZFb5hXFNJLNo9OUSbVyB7WtsPmuzsVC9DIegtVso1VsJh6HBiBW1be0GpzSWlL8CoMkYucrMmSDzUZdtXWt46+UmR74vqGAVidKxREEW1wYUoPQ5u9e4yFGcnl7jmbmu5YsG2AydUwTxhdJjVpQlPTcpB1wbqAf+aRTnpahvkhFAUtpFNwCgy5MJr4OkIQWStUmV9jFJ4LYvNLlNNZXBb4XssJIcj+X9ZrMJxmNIjRURnxX57jOTxbPWwtzwz5kngXlLsRf4dT3rI0ghTI+iDoO2OOnqlff61/O/TYYNWyoc8el5am1FZpGyxbFcqcneyru/IEhEdpJ133hFPgivVH+okAfYGmAPkx5aNQcLRzj7YNbnahIP5ziLDhhs+h0jX15c9DLmo4AV9x8razrV0NLhddFR+MvstefE7RGQ2n87SZ7hGV9hfjJkXleoMhI3lryNFmmZYTTb6srWdQb82H/fgTgGWnPnhQ8TedwsvBwoR5ngegClY/GWGhybzlZJqF0P0hfatxUImHM/k2w6LOoMbJFcDqMSgLg84=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f4e28a4-9ce8-407d-2734-08dc894516b6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2024 12:01:40.7645
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SwbzkuBKJtp+/IW0H/oH7TjUbBk7aAc0vjHM0mFIHWSYkyLLIldkjVRZem1G9dyVSvs4ZRbmXz5xF5wZjqxr1uu7HPu2pmQL1AEUSdJ8pog=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB7285
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-10_02,2024-06-10_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 adultscore=0
 mlxscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2406100091
X-Proofpoint-GUID: 6GJqqV20xZjDah3HracT_GVSRfARGd8K
X-Proofpoint-ORIG-GUID: 6GJqqV20xZjDah3HracT_GVSRfARGd8K


Christoph,

> Factor the duplicate code for the generate and verify attributes into
> common helpers.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering

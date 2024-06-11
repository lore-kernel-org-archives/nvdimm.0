Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364092628D;
	Tue, 11 Jun 2024 20:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718136156; cv=fail; b=o7xtyvoj4CUzO3PZIoa3r/nPff5Yv51YLvhQE34x5kHq8Ngnmlg0Fbx6Xgo29MHzvtQ5TYp/alUamvQPkx60Hb360mnTRMlOspyGj+OJcU3mQEM1mw8k1IkJNaDRieqUr9ol6MXEuQLZrzIpHbokESyy6H31eih+rewwaBy/pmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718136156; c=relaxed/simple;
	bh=oBXn28EMZWJjF3yGLDKrJOtuvCvdtPdudBIIlW3Xfr0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DX7Srs3/Q9mO1eBT/BH/VIEBwkr0Fyuve0LY2Ro4HeoId3iZKvuK/sSlaQsUpfkEsjLu6T4HjTYCUl8fcD2Cc0kTJUiX636QYPj3GVd3ZIfRBO2nWUyMmFJcV7bAzxnSV5MHMTdxwNxnRWGa8N5iOZ8D+gvw8U+3gX3G1VtYmJE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EXcD5O1/; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KCSGw8rj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EXcD5O1/";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KCSGw8rj"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45BFmr53004116;
	Tue, 11 Jun 2024 20:02:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=U0NpVtQJfH0mme
	ACESbf2d8IbnEMeB5hYK0P65W/Lfg=; b=EXcD5O1/I6Xt9UKvn2l/2mZzMpBjA5
	pM63wcs1JRIK/tPujPsmNT5irEFmiD69KDBEf+ALT1gKD/ifio8ESMBbBKMxrBfI
	ehuwC1cKEcwsxR9AqrEZ/LGXDVQEbvBnKgXUKtkA31hLtqJagY/W4H7S8phYrGmj
	1SeVVG37UhdvLcbEYpXvfQCdqTS1+f6WlBCyOrZk7dQwzPAkWVoJuPEVVFXpNAmM
	07XUkzf5rAsSFackmsT6IHd+Ct5ZicTWL7CbwwbYxgLCtMaMU800IaAwaVtq+Wvx
	rinBO1fE0C989fgjMgcBpD3jMksGOEixzE3SEj3cyMgpTvAwVLVw48xA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7dnq03-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 20:02:19 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45BJt2iO014229;
	Tue, 11 Jun 2024 20:02:18 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2168.outbound.protection.outlook.com [104.47.57.168])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynceuf319-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 11 Jun 2024 20:02:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LLzLYSmC/3RNw+9N1qMDVIOx4p08taznsYk5ufqIWo1zdjdL1mDPwC/zUoYr0mjFRFqokal/xb6yIZQ6QYDdu1wH69eBRFa1a3Fc2uFWsCwTSqR9cbipXFzCAvrvn/F5TAPu/HtdOFcB8abw7kkGW2LgytLNle+Gu9hRqQxtqSiD/XFcQZevGbLZSTjKFmxdSfzowbooQmqaLyXVzCafDaYQmoak6C13e5Gg5WCL2baao8DS8RFP/Eoo67M8DcPryrpjA3+GZFQfdnU5dLavdelYltshDK0g7W5rcYvLeXyIBz2TXOT0iGnmoSNLW8sNZqOG+Wlgg7Jl5ccPF6PG3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U0NpVtQJfH0mmeACESbf2d8IbnEMeB5hYK0P65W/Lfg=;
 b=Sz4KnKtnzREtOR+/glCY2q9WwATVn5y10buyYPMuVo/LN5O++YfJQOP7/VZ+wsSiQGNXix5yGTqK/9oZiUsO0LU1H8y9gqxnFQrfUyiSl6bQoHxJdMgTZ8PDbLUidUqpswxqb9wgfhLxjiYCKK0Am0W3gUo+KFIWXyl+iddQyZFVqdFF7+AtP2Qn/q29wREM110jtDPMTak9avW53i9imZk4JRDemXjKAtC4NZUB6ammNapHJopHangYVmvGvMqt1Qc/d1ERe+voqJlR0LdIUcDeiLC4t5lIMV0rnkCR+gMG4oYJSoqwS6TFvU+tPqltKrxFz4f6PbPyQaUFx+nCeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0NpVtQJfH0mmeACESbf2d8IbnEMeB5hYK0P65W/Lfg=;
 b=KCSGw8rjsFimBc7+oC4teefe1W/2NQ6SwM2kDKnngDRnYbFdQqe2L6RKxKaEB3+j+7YqNJYr+pvB2rUefb8ggrR+g84WSiXpAcQKAWP6e9tl4Z4z46rXyNCOmDvD9AMF59JPJd2FCeEEmQp4TbPoAPc9deyk4tKfDkCcLkqqg6U=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by DS0PR10MB6869.namprd10.prod.outlook.com (2603:10b6:8:136::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7633.36; Tue, 11 Jun
 2024 20:02:13 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::7878:f42b:395e:aa6a%3]) with mapi id 15.20.7633.036; Tue, 11 Jun 2024
 20:02:13 +0000
To: Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe
 <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        Mikulas Patocka
 <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
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
        linux-scsi@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>,
        Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH 02/11] block: remove the unused BIP_{CTRL,DISK}_NOCHECK
 flags
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240610115118.GA19227@lst.de> (Christoph Hellwig's message of
	"Mon, 10 Jun 2024 13:51:18 +0200")
Organization: Oracle Corporation
Message-ID: <yq1tthzz29i.fsf@ca-mkp.ca.oracle.com>
References: <20240607055912.3586772-1-hch@lst.de>
	<20240607055912.3586772-3-hch@lst.de>
	<yq1le3d3ua9.fsf@ca-mkp.ca.oracle.com> <20240610115118.GA19227@lst.de>
Date: Tue, 11 Jun 2024 16:02:11 -0400
Content-Type: text/plain
X-ClientProxiedBy: BY5PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:a03:1a0::28) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|DS0PR10MB6869:EE_
X-MS-Office365-Filtering-Correlation-Id: ed95e81c-3ddb-4c42-f5b7-08dc8a5162b7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230032|376006|7416006|366008|1800799016;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?HubbJf0gOE+f0wOWF/nkUw+ODRwLLWE6c2OnuR8mlMItBylXd2VulYk1m6qY?=
 =?us-ascii?Q?DbAom2bHkWK4AENnvbP7mT98MY4DtZMmRp8ZuH/KVqg21bseqFi8vxe28Y0r?=
 =?us-ascii?Q?WKB1eYl3jnyHS0rwyzK+APV171yXOZZpWDRb3EfrzaK+qthggTGcnX2jrfBo?=
 =?us-ascii?Q?KiF9l+7xjxyFv2drpwg69lPrCGJ060p0TlpUDcLbsfUQlrPtSrjg+ND4064B?=
 =?us-ascii?Q?amxl3fjL4Kr2rpQ4H8MvA2cqW04D9K1ysYSvBc/eznwDCOTYiIVHWoQTbs5A?=
 =?us-ascii?Q?/vSZ4cAG38FS9Jt1OyfJ9nSEG45nFi+l8tT8M5f1BNzm18BM8yIfCH65FwNm?=
 =?us-ascii?Q?uxmWnBw3MKgRSZ/ikAC+1+yVGprU7QkYvhKgHYGwJXfWPZohnQ3yO8mPqjP/?=
 =?us-ascii?Q?X8nX32GiJkKqxM5pcZ1ZGscCdUnkXvpEzKt0nT1yKROorzucdrV0Wud+AoXQ?=
 =?us-ascii?Q?pnjJhRxbNUHl/N12YdJO2JcyJiSYyla+mV0gdptf8xyIVW1Oige+Yn2qG97p?=
 =?us-ascii?Q?SywO3soKQRWNGKYxtl1SKpoDnurtCx9NAKCmbiX8c1qpGrrCIrsTGh1yKJsV?=
 =?us-ascii?Q?AbmgdQrTyefDwYSczlJZMlYf0sXkhzE+mMx4pDJlj/GIghpnNcbMp7VUA66s?=
 =?us-ascii?Q?5Cr5lK2lmndFh2zpMobtEe88pYUhxpZ31Bg3nW9Jjc13ooH9bJrV8dxmOhDX?=
 =?us-ascii?Q?SO2QRz0Qb3UbVfNpfHaRZHaT72pOfNdLty+vGWT/OnzizQNTwKQ2zq7H4nf0?=
 =?us-ascii?Q?TMcBp2CeRMlzjXwxsQn3k775m9ACs8SwxBfmdW83bAxNWG8ui65ahzF+8UIw?=
 =?us-ascii?Q?YcAeEW4uy3GAgLZsC37gua58Sn5H172mx+K73a3oGvbiMK9YasB2LmglOFLE?=
 =?us-ascii?Q?w6hVUuGzsvMt3FCX1IRSwtZw2njcuCjLfl4RYjeIUnVKZpNBYMIv1mjz/FVf?=
 =?us-ascii?Q?juOgD8eSK7jI32imLao6FL0ZRZjfrthUgA+9Q0G7CLy1oVoB2e27JCVqWOFs?=
 =?us-ascii?Q?eA2CkJf48ViStyUDWIYCa00ekj/J3SdwkA2UXNyavcqHEnDDOPNbaZrYPWCc?=
 =?us-ascii?Q?FC4EzhmO5Y6yxVIclp1Bvw0P+6BzefDdn4f+ngBR1SrbKY26xxSr7P3uTqPU?=
 =?us-ascii?Q?a1WB88EsN2aMBTL+SPPxBSfzkOuknZQXYkLmToK/k2wPKVmW8WzfcnXtgRBI?=
 =?us-ascii?Q?//q4u00mXGkrUQNLa+ILKSF68zPxm0G4+ArXVqv5pQGoXnCah0pFk/Xz3vgo?=
 =?us-ascii?Q?aLlZvNio9K4fq0l9zVC0vuznCmT+CtL0z0PPu9pWKhJp5f2Hatu0/WF01KaQ?=
 =?us-ascii?Q?uY/97jqgWmntDMYizBIekOdd?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230032)(376006)(7416006)(366008)(1800799016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?S2B9+k0O2gWtthvfyn6478EssSInWXjcrAoXlT14Gpob2/uWImQkCNkQFz2c?=
 =?us-ascii?Q?el4SmhZW6R7a8KJXnPqPIjFXzCYuBsEjXxeDnki2xMZ3H9hxyESP1/TmdXe0?=
 =?us-ascii?Q?w/MYhvLNZDb2rOHCLO8cxuBYLaoK2l+3y4U+6Y2wjHf54XdzQVBQ1fyDpYB9?=
 =?us-ascii?Q?FMo9s320RlzbZZl/fKIETXIUJJFFUiv3IiUCGYrt2IF93CvA3v839x8OmOCd?=
 =?us-ascii?Q?fC5jlGLt7jeag/nbfuCJQNur69uumKjz9qb+Ne9A1h/dVpm7HwuliaW0ma8y?=
 =?us-ascii?Q?oIemmZ4BZ9+FPXA3jzAMrf4cXUGXsHXNI5sV/TC4w2956Yx7K71sG3IF4b6Y?=
 =?us-ascii?Q?Mv/x/0R36OR2AVyR8x69XxReQYd1oUdV0Cwtp7W8ZQ50xqaAL365+S3trqjB?=
 =?us-ascii?Q?XEWoybzkAdGLvbfK4useUN5547cS98KBhFw/tGaGHRYKjV2MqO6YupSoW9V1?=
 =?us-ascii?Q?iEdA65cnPWeCaM5Kn+FTY8IjrcTcsc2Jbq0xiPmX8+U4sSPfK7snXtZaLT1O?=
 =?us-ascii?Q?2jfZ2aNqjx+0SmZVRSaH+KS2uTyRkpSqeGzjDQRJUPYWPrwFb3A42Rq4dzSp?=
 =?us-ascii?Q?P5NdBWSEGv5kbvUAmIWtn1XTQkMga8+vbzrZDbd4+JoE+gCviNPZE70f28sm?=
 =?us-ascii?Q?z3QflMEiayj2zOi/MRAny3BG5AUCXFP+CRM7l2X9/Uf2kg60uEk4MvxQFRI1?=
 =?us-ascii?Q?BBe/2PFX6DyaU/OxD/htuTqoaOQsj7r0kslrKGDsoUrccl+X6F+7i5gF9vKO?=
 =?us-ascii?Q?SJ2Lx6GOlRkNlTVwBEcshmTAstYuOjINL6GcIvCLDgSBlunKxuhRgubvxGFS?=
 =?us-ascii?Q?RO01MXnckVk/Plzs7HIfQZNIZi7Zl3CYO7Gz+krS+kEt2gLvZWMrrHsrUbEz?=
 =?us-ascii?Q?Mh9cXlKKtnsrpcXzca+n8QIaosu9ZGU6bCjqSLMt29IEwGnrjJz+qfN3Mshk?=
 =?us-ascii?Q?Fy029Y/7DhfyPbgQDxkWZx3GtVxvhhpfv85lDvL2oI/mkwUn+fCPl2LB/COX?=
 =?us-ascii?Q?YgRRzdpQQFRw7vq4QsXuOTW1JiU1hy8PgIpr9KkCApFtLYZq/2EhKsD3d5ba?=
 =?us-ascii?Q?8HttRqCUuCRuVHenWggdFeOPqTeuWe2pWha5EmSvNql1P7SNbONETrgGqd9l?=
 =?us-ascii?Q?u7WzTLQgU21VmSMzt3iflZvAz7FEqLYaYXMAF7WqOCbNtmj6H4rzT75uLx4+?=
 =?us-ascii?Q?czEbA91JRUAjRhS/UyIU+CecIuymBaFRsT8NCWDkdvwngaGRSXVMHBC7KX9w?=
 =?us-ascii?Q?sylm4VaMG5Mee/3sggK73uKTyZb2uq6jb2WCAb71A0mcFsA2ah80S7nISE1G?=
 =?us-ascii?Q?PPtODJQWwvIGj9mJ2Mf7nRJ3YIyWxOqbqLysZBbK1tnpDFRgrvPTOoNJyolr?=
 =?us-ascii?Q?dSTa0oXTbkPiTmrjTJCf81uQYSZU0vxMtWZa8iJtRXfqgDXldSI+2wyzX/l7?=
 =?us-ascii?Q?eOa2JgfpGGem1UC3lqpHOdhRdzkADoWHCrxyLy3mI5G7Jxem3RYuVqD80/Cd?=
 =?us-ascii?Q?A9sikFO3nZDyXN2ym0zOdGoCsKIpI8AMchFMIi1neF4tHgu/bbcgTMKFLnsJ?=
 =?us-ascii?Q?IRPNkA67O9Rvlt8Z03Fa/mU9MIqjksIE2EDTrj06tFsTseNR4QqOlP8EoQaw?=
 =?us-ascii?Q?DA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	mXMxKTldpiUCQXfUTaacHRr4OGBU8yoE66yJsnPFoSm+aKfJJnX978J4ty0Hao5sGsXSFv7vDLUTVOsYZb1kmPcbzt0TVqZJEFQAimO1kZ/sSA9JZ1ZPNFbWfGIPQwxTMDjNY6dF5itfiMfRd6fXXf3S04kwk41j4SDYoAWfr0hhRph5mqwyeEdeKZg2V/e7c9iBEVCC2f1fwrBsbOromeUiPt5yrcMTtRc9y6T94xYdiL1S9w8H0Tw21v0ztX0vqjyYSEtk7DEQ+KleZSbRVshv4dwvq9MmFIse9oPyew9CXcPcJbsqUubUfapSGZaeM1SQuGyZ3NjSu7JVWBSA20krQcRR98i0RCvrTEzjXE/RGpJSatJnIPE1mxDVyTcXTfbrE36HJIALMHa7K4hyV3gBCmSQ6yJPlWkJiruGrk2mGaCvARb5IskFsnUDXAixS8jrzvrlP8Mc+JfHwpsFE/dzOASxrcODxihFuUbxQJFBHMOtQE56ptVBrgZqZlBdO4Fc0uc7fN/3Rh8vM5MnT9tzcsM+XHdQqPKxzo8S6mmVT/h4S+EAHQ4Bb/do3AL9nR7wUG2fi994bJQ1ImI/10PD/HLnkCyN2oma2dMv8OY=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed95e81c-3ddb-4c42-f5b7-08dc8a5162b7
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jun 2024 20:02:13.5066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rgD4CK0sCtRPRiGNqw0rm4kUfWe5VE3OdC03X8gHW0S2SB5Y0yA2wUlS3KpoIix5DpDVUgpu1DRK9EaDhM1QuQClxXTKJmplO+lm881VLcE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6869
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-11_09,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406110137
X-Proofpoint-GUID: _cO4eZT78KU7Ls15xGYg_h-i7pR6HgSW
X-Proofpoint-ORIG-GUID: _cO4eZT78KU7Ls15xGYg_h-i7pR6HgSW


Christoph,

> I can just keep the flags in, they aren't really in the way of anything
> else here.  That being said, if you want opt-in aren't they the wrong
> polarity anyway?

I don't particularly like the polarity. It is an artifact of the fact
that unless otherwise noted, checking will be enabled both at HBA and
storage device. So if we reverse the polarity, it would mean that sd.c,
somewhat counter-intuitively, would enable checking on a bio that has no
bip attached. Since checking is enabled by default, regardless of
whether a bip is provided, it seemed more appropriate to opt in to
disabling the checks.

I believe one of my review comments wrt. to the io_uring passthrough
series was that I'd prefer to see the userland flag have the right
polarity, though. Because at that level, explicitly enabling checking
makes more sense.

I don't really mind reversing the BIP flag polarity either. It's mostly
a historical artifact since non-DIX HBAs would snoop INQUIRY and READ
CAPACITY and transparently enable T10 PI on the wire. DIX moved that
decision to sd.c instead of being done by HBA firmware. But we'd still
want checking to be enabled by default even if no integrity was passed
down from the HBA.

-- 
Martin K. Petersen	Oracle Linux Engineering

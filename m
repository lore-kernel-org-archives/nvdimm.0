Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C65E2114;
	Fri, 13 Dec 2024 22:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734129026; cv=fail; b=Xx92mhFYJ6TwIOuxlRZ6ke+01aFMnxRjL/DeorugKZp3F1MCvmsb41o4ONsNJruyvtPznPH03GTp9AUUg1benujvyGCaycGqGZH7/NVTBfpE4/AY2LCSmFIzM+mUXt7b9WvO0JVHsbLzTCIn7G7oYIcCrdgX1+BeFdDTucw0s8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734129026; c=relaxed/simple;
	bh=F4fHJMf7FFUtKMaUEdm4xVFR9NyI9TxHlPdFJWwLJa0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ns1IqpjS5Q4ZRDxEZB6IedTzbMR1PrjqS4hVPZArFTu6x5U+1k4iNT5fU8Af40XDVHEs4m5+V3rfcaA8ldIE3HfsbUZbFbiu2PleYLZsUVtJ4Tk1ncQF1US5QY84Om33m4mxOaeDpGyvMbw4R4gtjlvc6j/V9c+e097Yeyn9eJ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VUEuW3HO; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Ca4/mPt0; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VUEuW3HO";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Ca4/mPt0"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BDKBoev015477;
	Fri, 13 Dec 2024 22:30:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=zgV6L1z4BlXEs19dMq
	YOqDryEonF66DoNnZAVNQ80EA=; b=VUEuW3HO/5kSpevKVEE79agKWUisa7X5cs
	Zo820hSNVeLvVNclsfxpO5ZhFzt+a7z2Lpf/Ob0b+QvajkILRhnFLss628ARNG2U
	SjPij89ck0JbGSdgvDPzXKNhFJOalzvpB1oKTJiKCpYLvHjQA1Wc4ljjpMzSKROM
	m8oAnjIZLb3K1Hen2VrsvU0NLklkyguSYm3UBNPqewvkqsNveFrdqy4iakZ1b91K
	div1E3bSt/ihKnQXb+FmFDFpBid+/AflgfrJqTqUB8Bi74mcX2+rszPeMSJMGYlZ
	T+W1EhIzv2INFt6UVJPIVK+QGn0vXH+XKei1ouUivUHhnoqP4K1g==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cedcefnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Dec 2024 22:30:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BDLXfHJ008679;
	Fri, 13 Dec 2024 22:30:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43cctd10gt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 13 Dec 2024 22:30:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nbOJOK+E3IIu6964T95xX2Spk1O+IKTm8KdwN0yOi4Ki+i0TIB/pS3XZvbHMEjN5kD6El17W7phz2hzqFGFpTMMULxLD7NUDfKYjIx4NAChtIYlavskUdUWYSbf0xA055Sn7FVV/sLWhDxpQOE/OPZQVc42D1sGjKsHJG1KqqRs3ZscqrYY7PmVHn3rp8Ep49gCnqBAhFro5U7gW6Ad7+CDdBa49iQQgwfAUBJ0LU5qwYRFiJEn2b1dvEX4UIc3TMxqMfToIXhEgKN/YGvBmOtaeSK6udfx3dWidBZmX0XqZXGiXF0GK6WyqyN3XbgruEW2AVs86RMSMb/pgTDaPbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zgV6L1z4BlXEs19dMqYOqDryEonF66DoNnZAVNQ80EA=;
 b=tA4jLogC61DIFr5g3GithtWBnlvN4p2O5s2/7+8yJbD4eP1PKjHE7RL2JDftaiFeJVKZmyCZSXV9Cf7ymTEA4rHih48O5SJwiMpfGEWBwXchBG5kksWUzp15HPQ4/H/nS3zE8i5Md+ChpgbjKvUQgpYTRh79tJAIwIh7DPc3c0KsdJHcSN+TvFwZwWxRdPed5qlbM41HrFo4AdclfDLDJHXvuTAU2pgTWJSX/R+RQoOuhqt+geoj+jP/tJqZedzCmpTnxE9M8lFGZUOOY0XeJSDtfMen7XmIuPZTC6q8rOOyEcNWPwETJqDQJ/DnMEV3yeTiwZSHtJw2x/gw3inNhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zgV6L1z4BlXEs19dMqYOqDryEonF66DoNnZAVNQ80EA=;
 b=Ca4/mPt0ITAd5dLEni1bjiN5FeKpgVPsPuVqhAf63r0uZOVvBEHXZu1buew6+Y0X6oTUDTaHy0zeqDQ8gNttrry1GFE3RIHbrEx7KxRhA1gJvlIz7ve70Gc566Sqn5eqb6PLcYscZmXJFDv1gxNw/uaTsRkXFEMIwPgugCJtJFg=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS7PR10MB7130.namprd10.prod.outlook.com (2603:10b6:8:e2::6) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.8251.19; Fri, 13 Dec 2024 22:30:19 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8251.015; Fri, 13 Dec 2024
 22:30:19 +0000
To: M Nikhil <nikh1092@linux.ibm.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-scsi@vger.kernel.org, hare@suse.de, hch@lst.de,
        steffen Maier
 <maier@linux.ibm.com>,
        Benjamin Block <bblock@linux.ibm.com>,
        Nihar
 Panda <niharp@linux.ibm.com>
Subject: Re: Change in reported values of some block integrity sysfs attributes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com> (M. Nikhil's
	message of "Fri, 13 Dec 2024 12:46:14 +0530")
Organization: Oracle Corporation
Message-ID: <yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
Date: Fri, 13 Dec 2024 17:30:17 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL6PEPF00013DFA.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:22e:400:0:1001:0:d) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS7PR10MB7130:EE_
X-MS-Office365-Filtering-Correlation-Id: ed251cfe-de1f-44f2-3d39-08dd1bc5b970
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|7416014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?DwXR0sqKzF9Hu/2c7vWADhdwhCU9SA1d90sfy5SZ358QYy+5Eo45bR8a87Fa?=
 =?us-ascii?Q?HnRyh8ycDC8P+GIp9pVRBMIdu8YdYqghjp97WhnyBod3/R/gLU2u4qfUvDr5?=
 =?us-ascii?Q?xO7pkcnvHEOgaocdPLMxALi8nEL8Nzi8I/BM3h04xCtRfcLTXpoSVhwEwy9/?=
 =?us-ascii?Q?xn97jmtl+xrbD+ZeVB6pZt9K5udUkoqsBdZ44N/6QA6Vfta7de1b/xVD4551?=
 =?us-ascii?Q?RLPTbwm2YfTOEKyD45FecxFewgdyAePr5OOaRMjXaXVxDvP14eQ0tKsHib1c?=
 =?us-ascii?Q?xcyinNQLuonfLONX2+f2krj6gaNtajM/IkdGQBQuXdUZZ9pMP1VuqImpdg2L?=
 =?us-ascii?Q?rUn7O7skbejv0TN84YEFS2QxJP52q0ZRKY+m20YHxME5yJ4d7Km9vNwjh627?=
 =?us-ascii?Q?1VuDJppEJvohB0y/Mi3D8x+FMvDMXwoC+vlLCunWpZvZXo4QSnh2ecrCEyWc?=
 =?us-ascii?Q?NRJYMrCOMqn2E98xyRpwa0lycRMAL4vF4daHch3iVBa9fH05a+W+6LxL61hK?=
 =?us-ascii?Q?AXB9o+Oiios1uggGQ2uob8lYbtjLNUbIQElnEMp50HCPqw1/t/QqfxudAd1J?=
 =?us-ascii?Q?liI87ITtpL2EiwG2Al1VGtiNF0w7JK6FWebq+ircI33hLEIVK0kOa4tVm1G/?=
 =?us-ascii?Q?6AS3RoRpArmnQTbLc/16d3+stNSAbAVeqOIqXVDsfxJjTQEGsz/cj8e7/S3X?=
 =?us-ascii?Q?84vQvC1Uug3G803d2zLP5rC7ZlnoSMKENhrp3FYSgzPa1c/whrvL5S2aAH73?=
 =?us-ascii?Q?c6PmwuCX+2MCJhbBhIdac5rEmGu96Zlf2dafmjCK9uqPYUK4+ZFntjYc/ckW?=
 =?us-ascii?Q?fvSqJ0KfsP3Wb9nu/yRHSoYvfK9gYrRdGIUhU7lHMLfcTe8K0+Y3zG/LLMp4?=
 =?us-ascii?Q?gaq7adbwxqpx7Sc0J/OpCjJrHCsSmIb7dKS9enJJxEtyVTE2tJi6hk8+YpDh?=
 =?us-ascii?Q?m5Tq2C08k3jwOS2XhVthSaH1/HYv6bZeZsKewyoQMOtE2HFFnHLLQabv5fVB?=
 =?us-ascii?Q?sDOZaaDxo80cN3B6WR4aEesV6PJgrwlG/7wXIGFU+mw/tP6rehwU+fN+mKvG?=
 =?us-ascii?Q?9Tft8YwAkR2nNFf9vMC3zrfbZMDSUBsJgEL8MLUMMeUNO2i3ZUWZIMuCH3YA?=
 =?us-ascii?Q?HS8ch6RwybfHMmE4uGOKU/lD0Mr5aRyGeD1B/icPrmB/hPBxGA9T4E0OtFGQ?=
 =?us-ascii?Q?Ci8QijnsKT2WEg6Dll9swKzgiPVNabKKCOlWfldOkuMCp1M0Hd5As5p8Rr8K?=
 =?us-ascii?Q?uTRp4Hdvom4LR7iGRdTY+TX6fHF/fJ1mMpWZBvxJGmtGslGMMfX3j9akHWh1?=
 =?us-ascii?Q?SFX+vEnvTtWqg9T+JwZZfcaHa0eLOsCAmn1AVXGucP/KoQ=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(7416014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?RM4NK4tIebog7y0MaOnq/Phw9QKL9kuKKkvGP3mXI7s1Zv4UYdsZGNLwrt3Y?=
 =?us-ascii?Q?RIzWXRCfWcEsFYIof+MLPUHCvYHNzRoLooF7mUA+30eMB/QD6S3I5NTQQovb?=
 =?us-ascii?Q?MqhDWnzzsy0RkOFhVFuU+t0vF7ALf9aCitYS9N+RBJMT+21HOuPkRpFFabnr?=
 =?us-ascii?Q?wraXrQlM61wdxCaASU57fxTtL6p8NVcwur8D9aSIFA6DnI5z/UQMfvxR+Km7?=
 =?us-ascii?Q?FxWC7QdEethtooq6i5X2tCciLxKlN0FR74/a0KnV/Udx1qM5+AIgGZoNt4uH?=
 =?us-ascii?Q?WeW8ImhRdTvy3n7MX4eCpGLOo9xYrU9Im3EMtHflMUojT3KCkt3+gfMjH7Tq?=
 =?us-ascii?Q?vV73zGS+Qwlp3PIWtSkVVc2TSNLbn9UnwoasvKp6WphaZXeu85borl0U0Bsq?=
 =?us-ascii?Q?A208LyY1766XXQ8utyGJaNCoSsDaTDuhDytK+D7RlBK02cbsUavIg7lqMjyC?=
 =?us-ascii?Q?/JB/VFPSCN66DW0+68mZPzyhHh4VIed3hY1kx1OXMpeCOLjGS6bgqx3GHIjt?=
 =?us-ascii?Q?JnNIpkkSZO1K83zhkrgZqSB/gId7nWAROOJN+rcIkoBO8mI7vAnB0eFx132s?=
 =?us-ascii?Q?YGqUuXsWpvZic7fXuYMkd/JWi7g8o4cE3Fz5DmusaIVWbBtvn1NHJdgYCiNU?=
 =?us-ascii?Q?p0kDu/pSAugn4AhtMmA9q9P7FChcrWUac/YPa8CS8ncY6JTLnbD6k20G+R7u?=
 =?us-ascii?Q?7mbiG0XRXBBqRA7ZEYM/V9HGjOgPudSvP6J43tWhF7KVWbXW97JBXotqEBY/?=
 =?us-ascii?Q?ONCVSrvujdIQmXb2V3rm4Q9wKTMLtDpWctj8mkeaK60/u6bboQtlQJlhpAzi?=
 =?us-ascii?Q?HsGczVEWrP1Z+GSk7urd3OaCADU1JW1FiQKWGLF/RG5kwleLhhYCz8df6tl/?=
 =?us-ascii?Q?czkyh1PFXUP4xK2S9vhDJHwvbd1JgbDKJUhyhreVapBfjK8LJxcHNOR5gpaV?=
 =?us-ascii?Q?OL2i2o7ktl6e/iunAV9+BGmZ5SEo+GztjTr2vWa7hnFI/pQaVZhpL9P9Y7Aq?=
 =?us-ascii?Q?iPw/QCl64KhctiO69uyiNR+CHsSbDqbIEIevc73Du2r7idP7My6WMpDZHt80?=
 =?us-ascii?Q?dATR+iFAcYaZki/sOfP+zDKSSokSPyX9l4ivcmCmMnVxrCesj+YxgqLGncb1?=
 =?us-ascii?Q?rkNPMCz23+s5/xe/XIylX2aJplfncXo/0pT90mN+/8jcMPYKeWvxwBPT1jEj?=
 =?us-ascii?Q?q+RQGnb8FT0A85Vhc0Clksp/n1VCO0+qC3Ja7Fz07P3UG51QdUCr03fjC03A?=
 =?us-ascii?Q?XlcNfNa1VxbCfPXZmqk8atCTGLniOXryCNEb6aXY8kwO0rDbg3wVqvPEHRvm?=
 =?us-ascii?Q?ArJNBlxkxQlV/3yemgOMa3eYrMSKXV4JKWJPJ4ruQVgMiUBXjQsx8K2gOrPj?=
 =?us-ascii?Q?vTit8OXQBQfRDyrUh6kL50XYf/HDqLSlMLzA+zVwcbZlBTu1H6HlbnsTB0/i?=
 =?us-ascii?Q?xqxRmjfooBqrbv24Mvu5f8SL8GNE2Hw66lN3QnoD8u8KK54zx/HCzFrCiA77?=
 =?us-ascii?Q?3fty8QUhChDGCpZn/dhlW/YHVcMzeRqNlpSKwR0iAAyDErg5p0cFI/szX6NB?=
 =?us-ascii?Q?r+bdehUUvvnSRYJhA988/OB+a2kxI3afD9fVHd/KMxjmk8QV2cDu3GO9gNYe?=
 =?us-ascii?Q?Ww=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	OOODMTCpwqnPitKqHqsbu4+aK5pXafEUuZ6UzBlBpkIIO1fr9K6bRareIXynrAAxtveaiQ9+HIeuhYn0Gtf2W4TY5Wq81aJWi3NSokTPQqgUldNtkZEAwsJz9DX1Vbj58vYwOrj+XWjjXiiS1FysbQA5bG/UTyRVhZhrcPwIcNK8IzDPb/JpGLXojGQxY8sJDiDo2o5vTmtyrFzfmQ1XhXZ+RVF9m7MvovV+ag4U7IBLdf9y6PXRwaMOnq/x/DWZR0Gaxx+0aNCbvt5yAZSovdjtsmh4SsMyV/IngTbJ+K/Mk72A3WxpQqzrE4j0QO24cFKumfbOH7v7Gd/aSy8UffkWL/ojxvCKIiPiR+NF+csg8QTb2KpFddJ/JB+vWAwNuJMYIuPcPzho6ASYytlFR96JOsYpeHYcaFvA7Yst5ZwoMxW6x54xI//oUrkXvCOnOoxPcQvctLR2cG4JIcIRqQ+npEXmSFRFnq2jNpdB+4xt0O/8xBJhaAUqbOeNMS6DVy1748++QgjA1stOq9P90gBuP8DFRHLD7pc8p6idqDdlrGSahqvdTeyBKn0EMIhg1x6ZzV/uLRgCoBgpMtNNYwttloWpVwmx8IuVJFJzpsU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed251cfe-de1f-44f2-3d39-08dd1bc5b970
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2024 22:30:19.2057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XOvh4dMoJ+S0bcAg5QRJP6ure54iKQVvylpMppyZY1s66NJXixxwmDj2cygmA6ymmbiIwfSMcELjUE2id/sQ045Md87KQu/6fd93aVN75fQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB7130
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2024-12-13_10,2024-12-13_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 malwarescore=0 mlxlogscore=951 bulkscore=0 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2412130159
X-Proofpoint-ORIG-GUID: 9oF0VwXYnbUwcAEzQZ1gKc4-M-vbqPy8
X-Proofpoint-GUID: 9oF0VwXYnbUwcAEzQZ1gKc4-M-vbqPy8


> The sysfs attributes related to block device integrity ,
> write_generate and read_verify are enabled for the block device when
> the parameter device_is_integrity_capable is disabled.

'device_is_integrity_capable' is set if storage device (media) is
formatted with PI.

That is completely orthogonal to 'write_generate' and 'read_verify'
which are enabled if the HBA supports DIX. If the HBA supports DIX Type
0, 'write_generate' and 'read_verify' are enabled even if the attached
disk is not formatted with PI.

I don't see any change in what's reported with block/for-next in a
regular SCSI HBA/disk setup. Will have to look at whether there is a
stacking issue wrt. multipathing.

-- 
Martin K. Petersen	Oracle Linux Engineering

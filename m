Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2112571B4;
	Tue, 25 Feb 2025 01:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740445653; cv=fail; b=X1rR2+zQwMBF88BcJ9Q5nXuHD49UCnvenCKOmx88KeIuIx/tfAIUhM6Ta1FbdCT+uL96P4W5G35g+T0/2tIPXGGLlWfQD+QSGKmrN72cNiQfrEdKNii0aRhdILK0JVui9vQdVEYFI4yrlkE1wdTrwAPw5aKMcbLQSFD6v8va8E8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740445653; c=relaxed/simple;
	bh=2DvEJ4FyLXBTEWiZyofpS0Wc5t2HVZ3rgehY1/IM91Q=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=VL9491TPVe6NXQSkHRLJ4xg+t/6NP9378WY6PgTYFIISidxQsCJgQaFtg2iMe+CVbEuu3w8IPV1KDkESUdk7jIhGSPCWsbWL6A4rttf1L2O1ITC/Eq6Pnjx3GNItbPufzjOqFOp2F3IaMmcGh2eph1n4rV094DaFidXvz9XkaUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=evPC6NTP; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=YlXb+aDS; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="evPC6NTP";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="YlXb+aDS"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMK6eh014580;
	Tue, 25 Feb 2025 01:07:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=6MLvyJ7Yult5Ouaf22
	BQ2LU+whC0Vps8RoeBAcO+HaA=; b=evPC6NTP7dg6DIZyera54fnPjOUAQyK+ms
	i1RSJItXWwR8aM2myPC2Fvvlg5J+Fblz9e73ZDbas1kVX9XXO5jw0SWK4VMWM32/
	Fpwv5n5jgzFr+Mlf8fgSt9eyB7Fn4L+LHrXRiN+Ce+AT8P7R80YvR2mQaqU6SS6O
	ePYMrOjU2CAP/FaueHPfqe3V9NazOP2T7+7orYLPN1rAp06MpYB0u6BFKGvX5ulO
	P45JFIVRbSqoL4cefMkqAm9stVVoeBVV5tVkI0fqsg1X5ou/+9Cy6V0iHbQD77hn
	cc9tMaE02ohAWVl4ILYN1OYsz8hd2DG3DNU/kNkMLJ+HoBeca2kQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5c2byqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:07:28 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51P0U5cr007534;
	Tue, 25 Feb 2025 01:07:27 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2046.outbound.protection.outlook.com [104.47.58.46])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51eh4au-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 01:07:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=eE3aXjxS6PelciiG0Vd5e57UHRFy7b1YyGVwBKRce7BTEhUwBHG1KPshJYrBeK1/xlGTXPABKf56v8svJtpXNpxSYYHJhaIxjmmZctltLUT5AX8mfcayiBz+nYmH8KV+5urqe971ap/H+5VtSqM4JzVoA7FbwJ4ar94NcqvsbyjCYTAxzpfdHXukCTriBp60fP9xUsTxK6m20bYFDWlqGnH3qm7+b0mHYNzZxXJldqebvzbsozhLlIKn34VyaL7eqmVLP/Zl0MIPQ95LDt3hIqAonAm94eSXnK39zQhx5KBU+Frw6Eyo3xzhMKuG4jNXQy0xRt8X03ctabZw69DGaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6MLvyJ7Yult5Ouaf22BQ2LU+whC0Vps8RoeBAcO+HaA=;
 b=aTSJU0X08zSt65hBOjwxqvokRHK9oChSsTKWGKk4NM6IReuh40MscoeGrE8tI6r+FJyYQsgPHmOvKP/qOkwJa3sfV2M1Hr8gO1lZNwVyrx3j+OgCK6ENSOUhu+SZFZ3uqBANvXw4YHI9Rz+ERbgbhiDjfO2k17FyZCtfANVC5Z6JZZpebiSXpWHy7Vc/H3ClgvtRMqY0mZxepESjGfEefSQ3a4rmONwCJWRS0EMcy+csac0w7FJ9CzPpr0YvQ/4eVQdBUpr4X0KBtMaGCcn0yaPNJcWw/Cm2ov+HV+lVhmlG8NxSe8iODnLhLHpvskGlse3DuTMsBd+zS4f2F9ZeSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6MLvyJ7Yult5Ouaf22BQ2LU+whC0Vps8RoeBAcO+HaA=;
 b=YlXb+aDS4uml1EJMWj8LC+U0uOtFuaqBQcNE3orXDpcLlSQ0nmbM/F2U1B0SkXhGqb2WSou4+t7AVdcPhORB8i1kE7sXBgGCGsjLxPQ0kxETWSP7zYYi67IXahbGKy9/4tmJa8QYz6d2iAUQ45B9xtRRZGsfVA8SOKnRiOcCN8Q=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6449.namprd10.prod.outlook.com (2603:10b6:806:2a0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8466.19; Tue, 25 Feb
 2025 01:07:21 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8466.016; Tue, 25 Feb 2025
 01:07:21 +0000
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Anuj gupta <anuj1072538@gmail.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, M Nikhil
 <nikh1092@linux.ibm.com>,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
        linux-scsi@vger.kernel.org, hare@suse.de,
        steffen Maier <maier@linux.ibm.com>,
        Benjamin Block
 <bblock@linux.ibm.com>,
        Nihar Panda <niharp@linux.ibm.com>
Subject: Re: Change in reported values of some block integrity sysfs attributes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250221120729.GA5233@green245> (Anuj Gupta's message of "Fri,
	21 Feb 2025 17:37:29 +0530")
Organization: Oracle Corporation
Message-ID: <yq1frk2debi.fsf@ca-mkp.ca.oracle.com>
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
	<yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
	<CGME20250221103836epcas5p2158071e3449f10b80b44b43595d18704@epcas5p2.samsung.com>
	<CACzX3AvbM4qG+ZOWJoCTNMMgSz8gMjoRcQ10_HJbMyi0Nv9qvQ@mail.gmail.com>
	<20250221120729.GA5233@green245>
Date: Mon, 24 Feb 2025 20:07:18 -0500
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0014.namprd10.prod.outlook.com
 (2603:10b6:a03:255::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6449:EE_
X-MS-Office365-Filtering-Correlation-Id: 2ff8485c-db58-467f-eec0-08dd5538c15a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SrJepj2khL8sDTyqM+UCw/+AS8nqy3AMUXHvUhuaaT/xECr70d5XaJskpkf3?=
 =?us-ascii?Q?2Q9AEZ7pL8Rwnytl7Rl4ziOy07nOniJUO4XJLLIAZYDn/1w2oSLogqr/+gvP?=
 =?us-ascii?Q?aoBOKtYcL+PWdeZRiGSFatswpA/ECmAraCWCvslWdhheZGSiIOvQM99nCIHP?=
 =?us-ascii?Q?apCwVJNZV3dfZlrHa2JdYKfcg0FIxhP+9FYc6wD7/m7rnGzfmdN5Brhr+f/F?=
 =?us-ascii?Q?VQSLlGVKNcd9Zcz8bdXn2kDmt1k+E+Q+7t5CaEovaIiLg8eVX76912J2yOWP?=
 =?us-ascii?Q?7uhV1CXMjwycDarAzBpax5HSj66AicORKGihi9AP8p92vJF7epcsR65X/0rh?=
 =?us-ascii?Q?EaXM8GewrrEEztQQw21y6eAxmaaZYf7nFR09x6iM+Grf49HtXjcW3fCSKxAq?=
 =?us-ascii?Q?5EQaA8EnTPc7nsqGIZLM3U/ZujHZqwYTgI+RuFK1ULATolWjC1tuQS+r7GCB?=
 =?us-ascii?Q?AXcAj7/NyYTxR0xtL1cIMH4vXcTsoRkP0Whx7UEYIibxtLf8rb1PZLwVGbPt?=
 =?us-ascii?Q?Pr+Uv7DOR+/6r7BSEFJDFXGxLYiRw2ThyxTcbDH3afTPg4wiTfGZLmu0YDUJ?=
 =?us-ascii?Q?dihuH7xeQG/3pirR1GXtsLm5CMRtplilxp5frzWjGvPrE8zIY+AQ8mLBHIFc?=
 =?us-ascii?Q?oqcQeG6wMtTB/shhpo0HPuGK/dHl19SkYsIQEi3jCBHhlzaj7nu2TthzjY7H?=
 =?us-ascii?Q?584b6c9SyarbRs1uG85D1ghZi7CUVaAyqThjoDPYVK3HC4LHLz+CWuFGi+1G?=
 =?us-ascii?Q?0XjfEFxxwsCkZ1D0q/UwR88Vk1LKpdjjYUeyJy7gCXNcnRtiqypPEnhcV5Bn?=
 =?us-ascii?Q?Quga7sSWJPytklmrXYJ8WZQDQo4u9rQCVQGkInh1Og0bXPGkkoxjLkwX+vtR?=
 =?us-ascii?Q?kJVJ7FBfUAynM9zf/4891k2WJfT0LsbDcNp3DFS9k9lzjqzTvhjPtE8HRKcW?=
 =?us-ascii?Q?qPBVMtARR6SrbfbFRsIBLd5wCYTnuBezFwT8wbsuBzyWmZWzP4KPhm+MDc9u?=
 =?us-ascii?Q?xVVjDtrQWb+kbLYYHaGE2wnYEPKU2fEQPK76G23qw7IyJLTBzGZQihWE9qC2?=
 =?us-ascii?Q?R70apmuk7tvDaoXHKKd9hsJ6WKxSU7nxJguq8TfGcDSjZqjIwWAH7xJ2V35f?=
 =?us-ascii?Q?UTH/P5efZbVbDOvRyhPJbicvsa5U8F6SYvz03NVvDR+5rEiNUS3D8gXaRCuN?=
 =?us-ascii?Q?RItXPu62qkWlzl9fI1WwtyCxD+TtXR4GjaRp9ZnWcsI/176MYEL22C+Bj8i/?=
 =?us-ascii?Q?IO+R57D8nlWkmuc5IwcNJHCEh+NNol7WVwiMytHGix+90yXY6LhQ7JfCk18f?=
 =?us-ascii?Q?Xj1eV/swTdoyeyYspREI82Hl9VV0CeNXSwsseYsIsI3yPCNQNZs6FDSZxc4A?=
 =?us-ascii?Q?jN/QmC07k9KFi5GVcsPRNbvmURyN?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1dKQDv2mldemwfiabvO/kXk/LjKGpwSSSq/3Zot2jOLeMEteDi5ScuNzroZ5?=
 =?us-ascii?Q?ftV03Gy/s9a0ItAm8e10V3ZaY4TXf3IPU3Blg4TNEHT+yQgbwLl9LI9+Bofw?=
 =?us-ascii?Q?vlrcDDB/sJIxBQFxK06QypaFo99vSV7m2LSkGxI8Q0VS4NuirSp1BIpiQQzq?=
 =?us-ascii?Q?T8EBZeTAzLfdVmXpu0W+SItJzoebLgTu3dtXovkWXQR+ei22yspovudcmidr?=
 =?us-ascii?Q?/QABFHuvSjvzTMnhw6bfaSn31QYeYfnQAYmJHLWJAF2o4+G5NRGOMutzragf?=
 =?us-ascii?Q?t0+qiFlsjH9pWXFu/Na7IoSU/nAkjavNqJq1vo9QZ7AO26fDtAyMp1wyVygs?=
 =?us-ascii?Q?uHf1vKBPys2AvdgAPA+Nov6T12IYLylipuboBXaY02PdTwwaZoVifid8IXGP?=
 =?us-ascii?Q?pBGfJmAMckzyNsUvep6kzFRbwOsv5u6ZlXQ/YJFGhEpBis4iGUjkJA9mAcbu?=
 =?us-ascii?Q?6YBH+X154HV6ngvbhmopSqHhjfxv+jzyL51ZmRxvVz2Oas0RBU/NoQid6ya8?=
 =?us-ascii?Q?2ro6yZcIJ9+qf6u+nQZd5gtSh53XBxiUU8lz0ak+PnRwGEYqEgAgLASFWE2l?=
 =?us-ascii?Q?zYxNmkSOLmCPeHgJ4tp2F+bD6yHcIpympSClDvYKxZpOkmZ6FV5BP5yjxfns?=
 =?us-ascii?Q?+FuiHBU8N6yqbT1+WDsQn66kZhAky2yBm/vo6eePuhlCxflDJyQsNKwy1QKk?=
 =?us-ascii?Q?K0DVXvdmDC0+pU2gQWKh2AkCD7dBbcJwvcpwrLDHtcXOMtQ5r7OkoyOEQ5As?=
 =?us-ascii?Q?8PT17MiZ/3mdErp66ajqaII6VYoczaAI7qn75JeJl7K/H1ZL80+/ojGuSz4O?=
 =?us-ascii?Q?wK/0rer4mDBydiQLsFOCIb39gAfq0zOfyXRNaQaT9gm7b4/ylnz+U9Om37mN?=
 =?us-ascii?Q?henvccawQAdRynVSpEkxwOaKlczCG73Lx0z7d8bSSkj5MZejKhV+mxRmNwZH?=
 =?us-ascii?Q?mklLMyGHXJvwj80AGillB0/vaNty0H/Una1DXG0FF227GbZjaJ88hg4X58U1?=
 =?us-ascii?Q?3Fu3NcrXnLyjsKJXeWf5FWMB2UiROvscF2nHvzPdmeOzU25XeV/ophXRCMGZ?=
 =?us-ascii?Q?j7EMpjbHIx3CbjRF9mbRwoHaqE4wQB9phXyWs+FiiZb0N+SCvHTFdGi7Vthn?=
 =?us-ascii?Q?c8KT7++4foKYk55Ll1haH5BaxpLmODtZheUv2Bf244aPR8ZmHTabcrFLY3Wo?=
 =?us-ascii?Q?3KSAFxMAufuajv4OI6EmCAQOCr4Ush82jJYVl/FmcgGvqHJEb9fDCDmZNlQi?=
 =?us-ascii?Q?fYoyT03t9OQf0CG6G0haGAI2yk6Sn3ckRNj7JuI2i1YThB+4iYug7j8Ear6v?=
 =?us-ascii?Q?Zc42rJNszvVnaLgk8XU4evm5AGNWO5tdVL8VzBCQB22/2XBT4/bykdzlVvNf?=
 =?us-ascii?Q?nynnzn+sWLyfx1V5NjAz7+Tc8B7mHD6wVeSOSYGnOnDU3Wk0mPmfSWdv/pgH?=
 =?us-ascii?Q?hr9ze2TQfbXUM5cTg9XqzuFZr8t3pYyOyku6i2vDojrdaF3Hr+277NvklZuy?=
 =?us-ascii?Q?FFH9yeNY4kjTjgfD5hBqxt/YKWOlXbmUhp7CFvuzY4LxnyQuprjHbxvweRTR?=
 =?us-ascii?Q?30tjMcsmJQf8E8nn56s+UBbx+GZd5w6Ck1h2FIdDZfGYcigtdHE5BHdHx/Mt?=
 =?us-ascii?Q?hw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	zzOYMAy0dDerXKActP+Onw6K/cDIiwK/1AA3a5YpNXzvOQznKqzE6go2NqgpPn6Q0E4gNcOjUohxuv35v6zXi64AOGkmxeBjsjz/09B2/MHRJrW7r8p/ubyoL6GDuOAiDtGdCtTi4XIJR3WtblNC3u00QrFWCPuMPw7pu+SbibELmaChMCQvQq5J7adoT2l6Lx5U+ZjUtM81AomFGS0RuFQNZ3h/h71LAuKksT9OElUpMObcXcBKUpnUmRx6GN8+e6UukCC9q/87flebrQcP613yzNCYBeiANvkqMadSIOVhdSukoUMFKzDxLV9CCRLSF3JureLTQSlsY1Pb1MArCcQWf1cmWr0ceTOIZ22sPXLn0Tllwx9UD+51hFk5z5hcGoK+lwaVj15QxtwUGIW5Mcojk81zUuGMCueu9CoLJAijkpjpFIVF3/0svUbGU/Wely+iIB1Lqetm45dbFUBv8UkWaKFsRek9rf8IgY3WiV1PermgG1E8NU5o1x2OmDMxB7D1NllaZo85/3HGuu/U7Z4zs3OPSgnnT+qX69xvngDaVleUnxRAB/OhxhkW8Zaoq7IO+XEEjbrGkgYkVSAJLdJn1LRw+7eOWehIpqL3n0I=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ff8485c-db58-467f-eec0-08dd5538c15a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Feb 2025 01:07:21.0418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kdg95MbFxBr5ohrJ/Cn4bac5mtYQ0ZHkz6+0Q52cJd8iOhRjEQvRjPLCqUwbh0GuomyKiP7ira1rVuJVGGL7b9E3G8WQtvqRBIF6PM91Y9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6449
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-24_12,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 phishscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502100000 definitions=main-2502250005
X-Proofpoint-ORIG-GUID: dDwoQH9QnktDKtYQJ2p0uHlK45Bp9gNj
X-Proofpoint-GUID: dDwoQH9QnktDKtYQJ2p0uHlK45Bp9gNj


Anuj,

> diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
> index ae6ce6f5d622..be2cd06f500b 100644
> --- a/drivers/scsi/sd_dif.c
> +++ b/drivers/scsi/sd_dif.c
> @@ -40,8 +40,10 @@ void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim)
>  		dif = 0; dix = 1;
>  	}
>  
> -	if (!dix)
> +	if (!dix) {
> +		bi->flags |= BLK_INTEGRITY_NOGENERATE | BLK_INTEGRITY_NOVERIFY;
>  		return;
> +	}
>  
>  	/* Enable DMA of protection information */
>  	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)
>

This looks good to me. Originally we didn't register an integrity
profile at all unless the device was capable.

-- 
Martin K. Petersen	Oracle Linux Engineering

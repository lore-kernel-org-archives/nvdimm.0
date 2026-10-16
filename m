Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA531423E9E;
	Fri, 16 Oct 2026 10:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792144848; cv=fail; b=RTjNY8lJd4H2RtWEExVT5MxKPxGz93WxrkIGOIqPGbDNL2r1YoC+8SUjLVyEMk7prQ8r4lPxG1fLpWX+JBaUR1n53U3hmy5ACr1hKJUS7o0rmHU1aE7fcpkNbybU6vyON8UBAshFSBh+kLzXoZu5+dOc9JTzSJTFA+MNC9YMwfs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792144848; c=relaxed/simple;
	bh=sYAItRzeE057Gqds+ruiVHtU9wz+CeP/IY89p/zRrk8=;
	h=Message-ID:Date:Subject:To:Cc:References:From:In-Reply-To:
	 Content-Type:MIME-Version; b=NdfFFWtsJil1VeOPlA18V/BgVp2lE16dTB4C5hJq1qbAc0JTUcyt38Fd9T3WUwQCSQ6/AoqLj14leH8/u8LmxJBiDwcZDT6+ZheX12ESlVIqHSMemtXAsTO2la6e97x+SycTRPrFquVWyKv3jkYdsnbZSCGlw8LWRvG5PK0oqyg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bnURvJzf; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=Wl5Dqo5K; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bnURvJzf";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="Wl5Dqo5K"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69FN6c2L1452641;
	Fri, 16 Oct 2026 10:00:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=rCSpRylDt/3TgRmASxb2JJRxe5C9lmTQaJ08V8cuArk=; b=
	bnURvJzftfp17OkxCojEjNQ9TXwQBDnTiWgb4k+c8JGYyHjmHb+q8yyqk03tWiPl
	tR/Z5lzjwrDzcyQsHv+RQXI7GkPI4no40tHEqTtxs/lHfxI9iQIo/663nr4YoISt
	M0Ju5VkcHXGXCLEC61wQV9dCLqaiKD/69iCSw2n8PSzSUrWA5yFeANmqV4UnjqMw
	8Gx4cIWLfbDKJHbwQ3QuOE+/O3/vK3pj3cXeks6o0XSGBHMkjzF1GtRRnglGp+RW
	r8U23vkGmFywMZnIGe/04oR3mbapbK1dI4sLAu44agalZAN09aazDElqndBKAgtF
	P8SGz3/7tr5Sd1GDEl6nPA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4hautdt0ec-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 16 Oct 2026 10:00:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 69G9pNDj009519;
	Fri, 16 Oct 2026 10:00:16 GMT
Received: from bl2pr02cu003.outbound.protection.outlook.com (mail-eastusazon11011051.outbound.protection.outlook.com [52.101.52.51])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4h7btd86f7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 16 Oct 2026 10:00:16 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=d7jNyzxUPlPPVvb7UfXo3yFSDUFGK6Dui4/Qtmca/T3+RPGF8rCeY2yXeZOxfmr8EhXbstNup12EZi1QtUDfjlYz/w/BIJcV2AXNONMYbSHzwDCdyPVBfZkyXEKYwX39tJ+7a0EldWw5Y/QMe2S7UXkSM17bBZI5t1yujIEQQbGEgGybTPhaDTvu7KEIr7UxTpqJ6ZEI82uxiZG2aJ77ZZ3TGEYyx1W3pT1GjxT7LxgpQbyMehmU3lDAMBMVHQI55lkB2Xf2Un6anhttHKK8cIQ6TZSAPtnjbhpbgzniguYNB5sqRZDtEUzgHYBRStS+/mtafntIs8xDGtCl+da4Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rCSpRylDt/3TgRmASxb2JJRxe5C9lmTQaJ08V8cuArk=;
 b=FsU3psMVXJK5YWmyseeJS+EV5jL9dXLTPVvzLOKBnaW0T1tFueRQNxgclodiKCWb3Tc8jtUY1hDnBIMjVuhqn8WTlYXXf8hE/09Se0tM7UAXbNZ6q4HekbJZjGueT05REl7b6x8xzzOjhPrV9uGf9+TTC1XuVhWBUedAxZ5+jwC3heTf+QAMXRpOAKnawnO7kTtvHIcjI3eOk07h3h5Orwfl8vfUdv5M8GWeKFt6CJ5+0vXiPHfnaTrwWPgJt3EnmC/VdpxoqzYYGRr9j9fhuOy3KBdghgbXEj2vrVYohnKkBA3mFaA1+VOqivFWfhxNp0qUqjsADSzJdR1fIWW6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rCSpRylDt/3TgRmASxb2JJRxe5C9lmTQaJ08V8cuArk=;
 b=Wl5Dqo5KbseC4vrLYm33TofNnRRrh8r5JmZeauaWIFfYhbIi1x5eNv3/BVWGAH//l384EDyWjdvuYBx0amcF/4ArkiF6EuyzlnY9IPiVP4tQe5o7qVGyLmxoZgl1OECxXz+OjHBfgASW3VM7vaM2epmIby+MQYok7/0i4SvqFO8=
Authentication-Results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=oracle.com;
Received: from CHAPR10MB997722.namprd10.prod.outlook.com
 (2603:10b6:610:2f3::10) by PH5PR10MB997735.namprd10.prod.outlook.com
 (2603:10b6:510:34d::5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.546.7; Fri, 16 Oct
 2026 10:00:09 +0000
Received: from CHAPR10MB997722.namprd10.prod.outlook.com
 ([fe80::d6fa:c744:373e:9f4f]) by CHAPR10MB997722.namprd10.prod.outlook.com
 ([fe80::d6fa:c744:373e:9f4f%4]) with mapi id 15.21.0546.010; Fri, 16 Oct 2026
 10:00:09 +0000
Message-ID: <31c89da1-6d3f-4a42-b6bb-2b8f8170eed6@oracle.com>
Date: Fri, 16 Oct 2026 11:00:04 +0100
Subject: Re: [PATCH] dax/pmem: fix unaligned compound devmap initialization
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>,
        Muchun Song <muchun.song@linux.dev>, stable@vger.kernel.org,
        nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
        linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Alison Schofield <alison.schofield@intel.com>
References: <20261016054914.2601510-1-songmuchun@bytedance.com>
Content-Language: en-US
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <20261016054914.2601510-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR4P281CA0370.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:f8::16) To CHAPR10MB997722.namprd10.prod.outlook.com
 (2603:10b6:610:2f3::10)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CHAPR10MB997722:EE_|PH5PR10MB997735:EE_
X-MS-Office365-Filtering-Correlation-Id: e1f0a881-08c9-43f0-8ef6-08df2b6c42d5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|7416014|376014|366016|1800799024|23010399003|6133799003|18002099003|10067099003|22082099003|56012099006;
X-Microsoft-Antispam-Message-Info:
	llcfsWSS51CxRl01CvG4C4HpBLi+G1S6BYq0B8C7HqrDFyBTP6Mak2ddsWstE3vfS8a5kz30T5u2/0b9MuKNIxVPCbx97XvJAN7qSn1QeXwNk0RGC+0I2BscpJhgDrqi6hyTP5Y0EqrNKSXQmzhhpPqm1ML6wouyEgT2E4Tsj2v73D+LoNLt3VGUy6NDqMhRl5Ga8dGPm4mSh5p6mmfy3Zhp8UlCla0ZkTYyjiFvs6sOSFQp14LoCalFdURojD9GWTiwGZpW97DFP/Osd1+XNkVAqy460riw38SWi8sxObfrvDFXuc/GShuwuOKd/jv3D7dmrFzLypLtr7+GW0qL9T2ugmXzb2KZ54CWnaxtfEnzu3SFB/v37Uh00+VWBi6LdTTF1BISsZ6IzoDePlp4iuBo8DnfHfd0KeVUrOffg00V/XVwADAveaZN0bzfjHRjHLuHs5QU/MnarqeZNnBMmQreXU9oWiqG4+WIVv8Vim3NAEeNiojxyHAJ1tVucOgNXXTszHKsAWQfQ2Mr5TU6fyKwu5I5RWKlCvwRayn1+t/0XRFDJS7Id0EdLtoCO6qVEpQUwcYth7S2eY+iU3mIBUJxsLhzY5dpllludAUQ/+pB5celQtIajy/2dffs0QBn
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CHAPR10MB997722.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(23010399003)(6133799003)(18002099003)(10067099003)(22082099003)(56012099006);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?WHhhcE5jSU1DeVhTVDFTSHd4ZDBZaFRiSGt2c295UFUydVRxMmZQcU9pYnpZ?=
 =?utf-8?B?K2x6c0lhTEtZbDd0aDZ5c1ovbnZqV2dnN3ovU2NNVHRXM0lweXB6eEcxd2pR?=
 =?utf-8?B?UU0yNWhJT1RxREhUaThna2x0VHoveEJUVklRN2hFekQrQWVMVmlUUDJ4ME5z?=
 =?utf-8?B?c253bXd6SmhMQTdKcTZsODZJckQ1U21ZbjYvMU1hUmdTWWZ1bHFJd0Vxb2FG?=
 =?utf-8?B?dWtzYVZvWnZTWXp3M2xYSitNRUZBcmF2RHFheGZBeFpPSU1XUDd4dXVkUjlD?=
 =?utf-8?B?eFV1SlBqb1I5VW5QSGZhVVlTb3QwWHJmbWlpT0t3eXRKalNBNmhaZkx6bFIz?=
 =?utf-8?B?KzNYV0hpMGt2QUVQZFhqYklsa3NGRGZ2cWY2azZyWEpuYVE5Tk5VSWp1eFE5?=
 =?utf-8?B?L2ViNEVCZVZTVk1kSFAwakd2NVd2cFUrTlRWc2FVb1Frb1ZuL295VlRzVm9H?=
 =?utf-8?B?Sm1RNnZQYlBaTUZTOGN5TkJlTThBaWJxM29mZ3JqQzdFNGZncVF3UkpIMzBU?=
 =?utf-8?B?ellwTEZCbWZmR1JEOHZkT1IyWXVTV0NTeGVPTEFzSkIzWlJhNVN5a3pFRWk2?=
 =?utf-8?B?QmtPdnJIdDZWV2k3dzVvZHJoTWFxRVgrNjExZ0ExWUdGb1RsWG05Sm85YnpK?=
 =?utf-8?B?MUFQNjRlZ0haODloSnpmenBoSGw3MlB0R2Ztelp6VkVYNFg3V3NrY0UzUHVW?=
 =?utf-8?B?SUlMSXFTN3pXdVd4L2FiS2U1TjNENXgxQ2syOW03dXRCYWZzR1I4STc3aWpR?=
 =?utf-8?B?NUc2Z0pZVkpaQmJCNWNHZldGVXdQYThvT01OQUxQR1RBN0xmcndCUEdmbFVp?=
 =?utf-8?B?V3ZQNzd0Y3lwMVRPZ3l3Q3grek81SVRmcWNBOXkrb2p0cFVoSCt4eVlkUTRH?=
 =?utf-8?B?MEFYWVFsYXNLckZkd0l1UDEyS2RWV0pURkhab0lLNW5ZM05RcGJ6S0lDVHJB?=
 =?utf-8?B?YllONWVObjJmMUIxUEppMjJURmxMZVJvaTQ2TjY1STVNNk5sU3BSOTZ3WkhK?=
 =?utf-8?B?S3lDVHBZMHBPNEhqSS9adVk1YnBCUWJTSi8vTllPdjVkNVprcVJhMUNFZ1dl?=
 =?utf-8?B?bWlrMWg5VDRUK24zMzdSaks1WTZIZSttN1pEUmllZGhYcVBDd1NLS1IyZkpn?=
 =?utf-8?B?TWo1eWw4UGFsdmJySm1hcE11b2ZNTDBBdjEzd21oYTVOTTdJbDVkdnJGVERu?=
 =?utf-8?B?MkE3dFhNdXZnSlRJK0d0S2l6c2VaWTNoUURNSW4wYUk4VnFzM3BUWEpQWlVP?=
 =?utf-8?B?b2xaZEF2K283dVBLVnZLRDNGWFFDci91V055ZjhXSFdsL0YvV3IvWFNCWldt?=
 =?utf-8?B?VXhVV0ZtQ0M1eHRORS9rSmFmUjN0NlBJTU13YmJBN0dHdFpFb29aRUVzMzZJ?=
 =?utf-8?B?bkVxdFBVMkJ0WWpsK2JEUlF0bWVNL2tqcm9jYjdBNmcyMXJVTHhlRXljRkoz?=
 =?utf-8?B?dk5FTi9la3E1Qmh4ekNsTWkydFZMeERTRUt1bllWcVJOTzBuWm0vWDBlMEpB?=
 =?utf-8?B?ZnZUWEh4M0JVYjNyV002UllyYzBBM2hlRVRnT0grbkdxWVF1OVFkQjlqc0J1?=
 =?utf-8?B?UlFubTdDS1E3M29vU05UcWFZaHZ4dmRVaWpZcDdKdWM2UUxlT1lQYzZOaWwz?=
 =?utf-8?B?UkRlQ1MyMEEveEtsL1pMNngzaXJzSXBFZVVrMUhLWjFvQU1JQjBraUt1dEYx?=
 =?utf-8?B?THBrcDYxQmw5VGc2S2xNWHVjSWZTZE8wVnp5dDBKK3Y4T2I1TmFpSHVEeTZt?=
 =?utf-8?B?aXAvYVh0U2ZQdVBaY0t3NDNpeEk3bkUySkh6enM5NWNGTGJxRDMwKzZ5TnFQ?=
 =?utf-8?B?dTByeVd0c0Urd0VheSt2RnlMNEZtTk8yUnhMUjdGdmlOYXAzSndRam1UVGRB?=
 =?utf-8?B?QWF6QWd6QzZCVlRjanlQVk9FY2VwUGtBMExHdGtkRUVKT2ZrYUh5ejFxdmpG?=
 =?utf-8?B?QWgwRnZ2WUVkMWEvZ2tBRmhXVHhqVHB3cFM3N3hyYUd0MDlaM2MxOURBL3NR?=
 =?utf-8?B?Ymt2WS8zZmZwNDFPM2EvTUE5MG9lMXVKbkFmaHlqWkxHNEFaaG4vdmtNVk9H?=
 =?utf-8?B?b3V1cnl0eUVuYk5OaVROendQeVREVXNlSnhwL0plWnNQZmtaVjcwK3haN3RH?=
 =?utf-8?B?d1oxMXVUZlhiT1NxMmRzS0l5WklmbmZWUzRwdVkwTGhTVkExTFNuZVhZclE2?=
 =?utf-8?B?a3lDQTlZVzNySEF0ZCtZaldRdHdqUUgvM1QyYjJlMllWZlRxbVlqeS9JQ3pB?=
 =?utf-8?B?R0Q5T2R0bGNZT0gxemJUM1o5aWFhVVdwN0hjRWdCK3pxU1hqdFhTZWgvczZO?=
 =?utf-8?B?L3ROVERKeEpqOWx5VWU3M3o4aFBOUVdlWXVacDRqM0FTbFA5ZngrbWdBRnZL?=
 =?utf-8?Q?dwL5dMm8oB+jyEa4=3D?=
X-Exchange-RoutingPolicyChecked:
	pxTFvIyBfeg+zutKEDWaLmMWJFXhdujP820wN37dhVwY5pzhW6+KIQdvgMStP0JXzWjy7p8SiI7reenmM6taqUMBAb0O/qJNwidEuzbkVHtbY5OP6Yf8Ha2wbXccCWCO/1w8Bp18GnCHVXh4V236JDNH0oQ8oNF88YZQM1CKSDnRoAM2fnCH+xiby97Q7qA16ym13fIyXJMZQPDLusGWeVzoVY9dqMDocm7zNEnq/EAsC1Kxvug2bI/QZ7pfI1NoYS4d4/faTS4DcmVqhL0u4kPqDOPPpMg3zaFBqKCr+T3d5u+Fnobd43Kl91lmT3wBenXS5qO9Tf82EziApjmiqA==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ZItLG8iLYIHfaJ+r6opW2AOYk4/tuZ+Do7Srf99Yct3ZylsizPFESEG1l7qkXkR8cPpj1Ge8goOrbQcD5fPnvuChgC+hShDCrsQU5XwIoagwE7EaohwrTiuytOXHZHjBlKicUMqybbxpZCmk7wIvs3771BZKWKLW0+wnE/v7bee3+j+X8OzykRDUa/Khm0Ldz6LTWcOsPU2LXJJghQl9jCDUlvXn8jWilw/qlruFRPN1fWRbgdSrqR2K2Lzua63ME1lMh0EQJM3BWhTnQnIkt+jYw9h/zwCh3OljimjoNZAfBjERk60RN0BYUTCQfsx6N/082rxWp2QrbS6dSg0Sh2515H9y1Fiu6Fii+0jv2xrZWQr+JCC/bbzWWqZ8hrWiWB2NKlLiW90GqjiBsa+10JdJnGfHsRy5OGKXjcvO8kVWLhcfbiN/9mfLOKZvWG3tkfBLagYueziEMo1mOyetfx21mc1+6BN7dHZxBAGgAkX15S/kP2AKs7oYlcJPy2OtJM9cT/CNZyk27tuqvS5Zk74uSi2NsSyv1u9BZ1Apihp1xauqf3hceQk3yYMrX9JIJxWJ7VpHN+krysetDLLlTWx5YCRR8/lZPMQ3jvf9hVo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1f0a881-08c9-43f0-8ef6-08df2b6c42d5
X-MS-Exchange-CrossTenant-AuthSource: CHAPR10MB997722.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2026 10:00:08.8739
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z1FD7KA0LLh+oVsMDKc8dOWSEWnD3K5hqfI3co+J4lwJIPN34tuYjge2CiDYriPsCNMLzijuI2C4VN172adfV/PQnRakbmBusUhfyQs4/0s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH5PR10MB997735
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 spamscore=0 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 adultscore=0
 phishscore=0 suspectscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2610020000 definitions=main-2610160039
X-Authority-Analysis: v=2.4 cv=eK+GH3p1 c=1 sm=1 tr=0 ts=6ad1f5b1 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=660iZSQnnn4A:10 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=968KyxNXAAAA:8 a=Wow7f_iewQhk52Bz9CoA:9 a=QEXdDO2ut3YA:10
 a=WmVTiCyuxqgg3mnwYu6p:22
X-Proofpoint-ORIG-GUID: Avdi0c7mkLzSs38m9LUOmJI5zlCUcB-o
X-Proofpoint-GUID: Avdi0c7mkLzSs38m9LUOmJI5zlCUcB-o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE2MDAzOSBTYWx0ZWRfX9VCzD9uA+x7Q
 CfWl5qYVHcyy/wOh2k8StXO9pKrXzOnHBq/N4sggZxDAiF+afLPNIQjyZcbDLZAWeXh2qx7y4ic
 NjKNSs6WvTRFlyIWcAwmuK/j2/99yhc7QunP980c5MkNI6Aeg1Fp0zyTpdDaPcGtuR452O4+zNr
 +3sOZ4LJ8iVjnzTzPgO551DuPA4DdH1U+kt4bm3wfxMCZEMmB3dwp9nu/i5rTNPVfnne8wFItmH
 AHC8WvQKQX4XgSN3ufYs12XyNkqqSuXhF6pnhojrDcl2yEYxnSShn/gN9e5vA+lYMHGVzsS15Jc
 +jHubM+oe0BuGkWEeqI00Ts76J6qY1rzxA0prP+/PZXO6vU1CSdO901bFnocgRBnJVw3CDDA03K
 MJqIjmw1vAbYItawl52CPMKVK9yZ4KNw6CuJ4Vgb/eJv+ryy4dCjHcxJYSDYvi3UKSNA2fCPWET
 VRBGXHb79ZyWLFmduDw==
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE2MDAzOSBTYWx0ZWRfX0OFdsAHF8xyM
 enAVvBb4SxuRjflnwDTI/RFNICHg4qgW4brPsBhxit/kv7+j3m9GVcZ/3O7BSvp0EToCxfTPip+
 PLd3MRrH/YGN+MzlQLo40NqvKi9NsOrT0tqWN+AqIFUKOBAlF/t5

On 16/10/2026 06:49, Muchun Song wrote:
> Static pmem Device DAX namespaces reserve space for namespace metadata before
> the user-visible data range, and may also include padding needed to satisfy the
> Device DAX alignment. __dax_pmem_probe() adjusts the dax_region range to start
> at the
> 
> Static pmem Device DAX namespaces reserve space for namespace metadata
> before the user-visible data range, and may also include padding needed
> to satisfy the Device DAX alignment. __dax_pmem_probe() adjusts the
> dax_region range to start at the data range, but the dev_pagemap range
> still starts at the beginning of the namespace.
> 
> That is not valid for compound devmap mappings whose memmap is stored in
> system RAM. Compound page initialization requires the start PFN to be
> naturally aligned to the compound page size, because the head and tail
> struct pages are initialized according to that geometry. If the pgmap
> starts before the aligned data range, memmap_init_zone_device() can build
> compound page metadata from an unaligned PFN.
> 
> The resulting struct page layout is inconsistent with the Device DAX
> mapping. A later mmap fault can then resolve the user-visible PFN through
> invalid compound page metadata and hit a kernel panic while inserting the
> DAX folio.
> 
> Fix this by advancing the pgmap start to the aligned Device DAX data
> range for non-altmap compound mappings. Leave base-page namespaces
> unchanged, and leave the altmap path unchanged because
> memmap_init_zone_device() already skips the altmap reservation itself.
> 
> Fixes: 14606001efb4 ("device-dax: compound devmap support")
> Cc: <stable@vger.kernel.org>
> Reported-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Closes: https://lore.kernel.org/r/wlrkqqvg.ritesh.list@gmail.com
> Assisted-by: LLM
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> --->  drivers/dax/pmem.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
> index bee93066a849..d3a9b85107b0 100644
> --- a/drivers/dax/pmem.c
> +++ b/drivers/dax/pmem.c
> @@ -51,6 +51,13 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
>  	/* adjust the dax_region range to the start of data */
>  	range = pgmap.range;
>  	range.start += offset;
> +	/*
> +	 * When the memmap is stored in RAM, exclude metadata and alignment
> +	 * padding from compound page initialization.  Otherwise, the pgmap
> +	 * may start before the naturally aligned Device DAX data range.
> +	 */
> +	if (!pgmap_altmap(&pgmap) && le32_to_cpu(pfn_sb->align) > PAGE_SIZE)
> +		pgmap.range.start = range.start;

Should we need to check here for pgmap.type == MEMORY_DEVICE_GENERIC ?

Considering the dedup is not quite applicable for FSDAX.

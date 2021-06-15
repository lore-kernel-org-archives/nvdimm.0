Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66A8173
	for <nvdimm@lists.linux.dev>; Tue, 15 Jun 2021 18:55:33 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15FIleZB031514;
	Tue, 15 Jun 2021 18:55:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : from :
 subject : message-id : date : content-type : content-transfer-encoding :
 mime-version; s=corp-2020-01-29;
 bh=fgsz0LY5CxuG/Obmv2D3EEJ9teYw9arYBL4wXBFjihc=;
 b=fX6FCgY5aq7kF/GfBD8WoBRsgXdjgqJCJhbIfqOBPLVvCQKj1G1+MaC6btr6jlxWW4mJ
 Csloi53+Z3ddxAh2+FkTKCN6WUeQh6Uen21vXkMZesswrRIRj4RdiHwPIDDPzucDWNtB
 IMt0G3lTjsAjamGuf3LtKIl4UI52feHZ5i8SjtilSzZ23Rmj0SYzx63V8COOwQWmI4V5
 v51BRA9WMYd4QDk2Evwlwe9OG4gMo7FYcplnSgkXLs0FQGfHHcpR3D+lrmD3W/hzKVa1
 FQPwFM+0aqSvgbk+YYL+qp+nIctfMHwz/yJGKL4x68M/dtcYexqqLdbgN341bvxme01J 5A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 396tjdrq66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jun 2021 18:55:26 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15FIt2TU163666;
	Tue, 15 Jun 2021 18:55:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
	by aserp3020.oracle.com with ESMTP id 396ware0v8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Jun 2021 18:55:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4Q+M4aviPnqJ3vmlba8PW3kgOeUJJOQGY/taKaxCXBKKh5/aBhX44SG7ujxvlUTgvD9KImIEJwSbN6ANskDKDwVR1rq3A9D8h5aSI940fXLXt6JPzqUQdP/vln/89N9D/ZC+63uRQvemJ7QLlFG2F8dVPbYgX6XO+g9UcmlHVznVtEqphHK8KXGqpbxNL3NGh5FZz04NJkX2J52eApua1eSDNoYr46VG0gGcLwJ7kXHUie16zO0DtMM3aFeYYTIuXhYacKJfjDmi1ytbtxn/wOM7WXIpEv6CBwRiKKDQPzj2W10mXzMOzhkpIx7pkfNGx9qip+B6V/GreRupkpc5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgsz0LY5CxuG/Obmv2D3EEJ9teYw9arYBL4wXBFjihc=;
 b=MS80zBwFyIaH60jfdmRKpyr695FPpBwZQELq2BeoSyC9cHmtNJazWG3rFcctyxPDWfdRcktaLRqn1eYM/z2C6UtfYsmZ1sWtcLS5R43q6l+j4wp+iszkKLsbYzQ1xSjh6pRWWdcOFBWMi7Yb4S0ejufb+JPv0YMTBylLrtOERB1/j1jynOvvn3b1cOZkWV45e8LX3up05qu5vryx29hRZ6nPfEOgz9VqxPQWJeqbdXftcVCztwWYWpExcLUiBCW7UewvyClE91K3e0WpiS4nyLQFGQONDCcLMTgBjZnARMsha7bY8wRYbLNPMzC9nAKAJUhu2Is5oo3wSDknqIHbxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fgsz0LY5CxuG/Obmv2D3EEJ9teYw9arYBL4wXBFjihc=;
 b=Jjn6CkiDdhrHlLmmyy3P/4V4XiycL6w3M3DtgP+sQ/K181MiwpEHVSopnMoWNceeUaq5WCnlOzJIvyn8QzZM6vQWMxQnExQnes/PMsWFrBOm89DLttVu55hGSO7ZlzYAnLyByYgJtwN4pWr30IH9C2utnZo4cx92u4WzO4GO3RY=
Authentication-Results: lists.linux.dev; dkim=none (message not signed)
 header.d=none;lists.linux.dev; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by SJ0PR10MB4608.namprd10.prod.outlook.com (2603:10b6:a03:2d4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.24; Tue, 15 Jun
 2021 18:55:24 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::8c71:75d7:69ce:e58e]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::8c71:75d7:69ce:e58e%7]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 18:55:24 +0000
To: Dan Williams <dan.j.williams@intel.com>
Cc: nvdimm@lists.linux.dev
From: Jane Chu <jane.chu@oracle.com>
Subject: set_memory_uc() does not work with pmem poison handling
Organization: Oracle Corporation
Message-ID: <327f9156-9b28-d20e-2850-21c125ece8c7@oracle.com>
Date: Tue, 15 Jun 2021 11:55:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [108.226.113.12]
X-ClientProxiedBy: SA9P221CA0029.NAMP221.PROD.OUTLOOK.COM
 (2603:10b6:806:25::34) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.70] (108.226.113.12) by SA9P221CA0029.NAMP221.PROD.OUTLOOK.COM (2603:10b6:806:25::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Tue, 15 Jun 2021 18:55:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 47bf0350-b7b2-4498-7827-08d9302f21af
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4608:
X-Microsoft-Antispam-PRVS: 
	<SJ0PR10MB46084327CEAF8A8DF69214F4F3309@SJ0PR10MB4608.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	nm+VGmYQaCTRM17uPB60xmzSI9fButKK6OCYy8rrwzotcUoVEQ4Hw/+sp46XYzuxsYuEwT5BBG/9odCnpHKhrRe+5CR8kCvFByaK2IUJxPIxcfRnLO04bjq0d9zbZl72urHok+sGsxzbgg2yoWukFLQyWX6SvHf+YF7wg5hX0QnBjsAoLnT6jPxWUoklmHG4uW9v182CID6Ds9ZPbFxUo2ve2Hh0YshPLO2a1RZF2lCrM5gpNBBqKrIIFOzvCA528nU7MpZoYWkGJQ/xdL7PvRR35tFRN7s3SLr3T0LqIzw0EbEmJYqsv0pfj/y+X1Ejq7EUCnI776EACH8Iyh7Ej1K+Mo1F/zF6IiDim5ojdgs5Ok0rDQNJENIw0od4MgtHSphv7JBOHevZEXk8RME9FGR+EbiH6n4/ToXokFIv1czshzUdtkzFFgncDpuE50+XmT29W03hDnaikA4z+NPSceeTajOJygY09WYnoCF8SJRb4126u28liWDqN1oBof7i3QFQ5Sk6XoT7yZK7knIE2RY3GqGu6bwiHqkpsjZLfYZ//uz49MBcWKhLRA6CwbgwBSUsSUCollBhpikdb/vhZcNDmd9yCjvNsczZu2RFUsDHTYNebYFXttp2n9wKKj9AbuRD92CuJgPKsANNGftMQXfbJCkJA3DBElL5HkrmTw4s0iqRfktiQJCWBuObVzEC
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(366004)(39860400002)(396003)(31686004)(956004)(44832011)(186003)(16526019)(86362001)(2616005)(36916002)(6486002)(2906002)(66946007)(66556008)(6916009)(66476007)(26005)(6666004)(83380400001)(8676002)(8936002)(478600001)(38100700002)(36756003)(31696002)(316002)(16576012)(4326008)(5660300002)(4744005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	mkVOQ3YAGqNN8/B4UQ4LjKvJPbt+PWZ4ovKganqmcbtjBSovgtDon0g9uMkez1J5TOlCBastawMIwQ6QEmnZdfEeJrcJf8syq1qcfPrRKA1dP6ZI1Zo2h8gCe3qW3uCqt/95Q9fJ3QOl7B/5k7iobXHHXUojsiy2Rg9ytURWIZL334KpEjKgI226lVXsoHHgJslWp8TvdS0amkHvqHhRttG+kDwvKiGxwJiLQQvM+lc/ayUYDpqME3lJMGZZoK7il/nTRQSrGuqDq3iHuU2R18xPPaH2Ky9BZFkqfeqsq/1KXEGjm/8MoyPucdKva1gHUmLuaB7dcRrduVuCNGVyGdqKpUc3cOoQlR0EZwVdRsvl5sG8JP3aWSlYOEigsuw7jxJ08J7hlGbC0ZxivGrypl3yQ43sCrP2Y+RadK1I6gSTd8/rMzbvycbERlSplZLQAVX6fMBik0vbDN4eo2ihNoKwr05PArrbox6wUZD0CxCn344Q/6bt8I8oqh7vmpQyUh67ZthtFl/FZFpTGYJIWo+75K3f9lK5rDhgTuNmrhp8IdPsi7Lp8WauZgGjjqMYg/+KN8dG6S+qLAPcXnGcL4aN6cmwPS5VtI4si/r3u/RtDi7tquaOy8yuTa80x9Taj591NJtPAlS0Y4NG+2hQBCEwT2zoABnQkSVsIdijcAlDn01TavlNgs8wDhk+W9UcZwFZdcmmdMgrKRjBxP0D4O4Y3iIIht0DSnNM2LFvI0wGtJRPwSEtsPShPtLuS1QE
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47bf0350-b7b2-4498-7827-08d9302f21af
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 18:55:23.8918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Hj0t8Ba3/8Ph7uI94YuXlaM2KLcplfyNpMXPVbrnwMw7K2mDxd4fG+1fvZFUVPmCcTX5m5cufk1icd2T+mGkA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4608
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106150118
X-Proofpoint-ORIG-GUID: -FdT7wevXXiOd0ONy4o37x2m7Nlvib4A
X-Proofpoint-GUID: -FdT7wevXXiOd0ONy4o37x2m7Nlvib4A

Hi, Dan,

It appears the fact pmem region is of WB memtype renders set_memory_uc()

to fail due to inconsistency between the requested memtype(UC-) and the 
cached

memtype(WB).

# cat /proc/iomem |grep -A 8 -i persist
1840000000-d53fffffff : Persistent Memory
   1840000000-1c3fffffff : namespace0.0
   5740000000-76bfffffff : namespace2.0

# cat /sys/kernel/debug/x86/pat_memtype_list
PAT memtype list:
PAT: [mem 0x0000001840000000-0x0000001c40000000] write-back
PAT: [mem 0x0000005740000000-0x00000076c0000000] write-back

[10683.418072] Memory failure: 0x1850600: recovery action for dax page: 
Recovered
[10683.426147] x86/PAT: fsdax_poison_v1:5018 conflicting memory types 
1850600000-1850601000  uncached-minus<->write-back

cscope search shows that unlike pmem, set_memory_uc() is primarily used 
by drivers dealing with ioremap(),

perhaps the pmem case needs another way to suppress prefetch?

Your thoughts?

thanks!

-jane



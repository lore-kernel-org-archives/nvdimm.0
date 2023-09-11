Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B5333EE
	for <nvdimm@lists.linux.dev>; Mon, 11 Sep 2023 16:37:46 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38BChg9q022357;
	Mon, 11 Sep 2023 16:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=bR5I3rwGI82Kgg/vz9zy50KTCgs1ExPIzBQKz7uFwkM=;
 b=hKWau4uTKIfvD9i1mPRQmaaKlEIi9ulTR+P62SDS1QhW8kx91eYwTqu/ldxHd5TcAz8q
 x6OYBt42GwQThiCLQhax7fV9nJA3O4VkZuPDuvIpr/0auen6M8Rh00ZrpzI1B/LHzD1T
 qE4M7EdKCJ0wILELM8i5/5Ws5Ol99QxiKFBvsQKa+CFcpU+johFg1trlZuE102vQ3xYN
 sPOfj6ReJ/whbmAqOnX+K4Q+CbM3p2gbY93a34lnzUTgzQo9kYpfuoWFSU6d9EHkP1uo
 DTlmvQLR3KCrxZkHRTMU6ITaPwQHEMDQZ/TqHIAQcIjpemOKrdxK2QuoGMXqhK8VpiMj rA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1k4c9w1t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Sep 2023 16:37:22 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38BG93NH002335;
	Mon, 11 Sep 2023 16:37:21 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2107.outbound.protection.outlook.com [104.47.55.107])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5aq7jh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 11 Sep 2023 16:37:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OIhmmKIGXhr23s4Mbiv2P7e2bBYCLRx9y/SAg+Pzo+PSmSXy9ocQia0hYQyHVbM+57qAIoFsMwbMSbcNC2ZbW/4Cq4QKdQE8twMAEaDijmSyAGqtMTpPOy3gsEuK68BuMkwrUl+LFad/8h01LLn4AfgpEcevji79lloLGmbS3mShHm6a3XCg0eCWJOS3QIMuDPIS6Fo3Die1z+2fFDbKIEX/ggvGrneuov4KLkgdIqqsiR7E4uE2FWpmlIx2jWLUOPjaPO4+A40lDV4FQ18+6bRaaZyER5oQkI6p6Z03ibwE8TFuciO5NjLuCgUJNtyTcpH9vmFpqw9yhSBGQz422w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bR5I3rwGI82Kgg/vz9zy50KTCgs1ExPIzBQKz7uFwkM=;
 b=Q9x6eJiMk3KLTZc2b7bhYAOyM7WXuAxmOmYkwz8SsHXqmc8vqVb7CVcQUCOxcVWQlLL4r1qVz8rp6Et/bsS/NuAF+TM+nd3awpdy7zq4wj7WqLqlC3TxOAUqFLb2yL/FcYSSVsjMyQ/9tHzhUh16WWG68qdY9+cpOVJDE3xKsMsGm+yH7NK/dn81b35xQm3OQluHYk2Pp72KH1n1KLC3bmTEJfqVHQ/+MYThQaj/XX8O/B5SWFeXfHkFAEzlkVNZ7EDbKtfjv/dwQ2Fu+WLZn6yunaQENpzdRAnynxkW0uLquiRAyhFtnAHpVNmmnIfWgvIux3gD+cZBkaowuRfnzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bR5I3rwGI82Kgg/vz9zy50KTCgs1ExPIzBQKz7uFwkM=;
 b=u/mebh4NnLtN28Ze61UY+7wI5JLzggiyHZNzDdx6HPrYsuOIx/K1vAiy/VQEqoSf6Io31UJZRab17IuRZEVZ9Kt4WH0Hx0hsy/DTbyIRKA+t6XVTgQIhK9MNnXbsLnlelo+1WysJokt+ORVv2HxeDH03eHpxQ3ZvN/kUMVBG94k=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by CH3PR10MB7329.namprd10.prod.outlook.com (2603:10b6:610:12c::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.34; Mon, 11 Sep
 2023 16:37:19 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::466a:552b:a12c:6d53]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::466a:552b:a12c:6d53%6]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 16:37:19 +0000
Message-ID: <1e527b5d-f4ed-eecb-d749-7a512496bc8a@oracle.com>
Date: Mon, 11 Sep 2023 09:37:15 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v3] mm: Convert DAX lock/unlock page to lock/unlock folio
Content-Language: en-US
To: Andrew Morton <akpm@linux-foundation.org>
Cc: willy@infradead.org, nvdimm@lists.linux.dev, dan.j.williams@intel.com,
        naoya.horiguchi@nec.com, linux-mm@kvack.org
References: <20230908222336.186313-1-jane.chu@oracle.com>
 <20230910124618.06a8284ba0e059da11cfa823@linux-foundation.org>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <20230910124618.06a8284ba0e059da11cfa823@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR13CA0212.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::7) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|CH3PR10MB7329:EE_
X-MS-Office365-Filtering-Correlation-Id: 8aa29311-d9a2-40e0-85e1-08dbb2e55d75
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	VlHvTtmh82safDuxPcBa4MxDAFZarozpArAQ+5I+NZYCisjsI5mPp/5q2kOp6dBEhGiXLKcGjk8Uu29O6iuUDMKbh3CzI8/9WGqRR7NIjrSRS8ACQT5rQwQb9ePNu6XFV4FpQ3iGRwcf6o4BFS3AhkaaDd9NMhFiefA29ACgJD1omJxHDYUowCCnOK1IjITReU5364GtBA2H1GcucFmgSL0djXQeQxXO5MyJyKMSrMzdDcpFrqPR9qiLklHYvJn7N9tUNf8MgKOFj7FD52AzlbmVvFgo85jUE4baX26m+owa5hoQf2CtnA8Y4ds/pcnvyfs27sk6tB8hmlYB725VVDwMIFW6I15g4JNZfZ5Vme5inBmEVFPpH5d/oqLwXGM4/XwixQQAKl62Z6dKBYl2ictInLyH0xp/G00ChaWp5erH30KRXyJZSKB8fnYbi9V6NhZRqNxECHKM6DA4xyQgLGE6LW4rqjKDwVUpexD/iGEnhx8+dOhwCK6SZlYa+gndGDUEPo0oVE3hfxubWVqgXBnN35v3pFcVZRgqomXluNPOiv1/VzqpwdNgdnPC1tQWok0NS/aUYtPFELWBgNw4iXP8DHo0SYvk++M+CKUV4uEFVRjao/D0ZjdhRUhoLccdthATHhHPrE4qr3nY9tVKyw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(346002)(136003)(366004)(39860400002)(186009)(1800799009)(451199024)(31686004)(66899024)(53546011)(6486002)(6506007)(6666004)(41300700001)(36756003)(31696002)(86362001)(38100700002)(2616005)(2906002)(966005)(6512007)(83380400001)(478600001)(316002)(8936002)(8676002)(5660300002)(4326008)(26005)(6916009)(66556008)(66946007)(66476007)(44832011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?TGhQQVRFOFJkclg0UmJlMzhoTUgwVkU4MmtwYU1TTU50NVlDbGh3Z2Y2d3Vx?=
 =?utf-8?B?aEZpRmZqVFExNXg3YTV5MGxkcTg4Tk83Q0x6aHVYaWRjYk9EZWFNaEdadU13?=
 =?utf-8?B?cGhmSnRsVlJJZmpLdUNLL0R2SEJmOUROcDM4d3NZZHR1elZ2dUtmMEVOY2pi?=
 =?utf-8?B?QzM1NkphZ3pTRnovcHltaGlXNTdDWmRucFY1d0xaRDNBeWJxTzU0NlVWZUhF?=
 =?utf-8?B?ODZWa2VlaWU4Y1l6RGU5VGVMR2Uzb1hiRmxaT3JVcjc1WEZFTzhLMFlYYlBn?=
 =?utf-8?B?U3gzWk9kUWlwM0RQZWwySmhoMkRDTWRYWUVJd1JBYmxzbTNJWS9xNUJmanlz?=
 =?utf-8?B?L2NyOUhtNUdZS2pXUS9yNlVUbGFRQkNaZ1czenAyWGpkaVNZMkVuemZmekhY?=
 =?utf-8?B?TDJHWTFCc01CU1Nqcnc0ZTRCRUh3c2NEUGJja29aVU9yeVFXU3NxalY5QU5M?=
 =?utf-8?B?bTZ2eEFtRTdJbmxGN0Q1aGVoWnpncUVMdGpSdFRsSk44UFB6S0JsRDc3cEJ3?=
 =?utf-8?B?bThWZzE3cGZjb0VkTjJuMzFPY29QaTdsdFZpOFZ3QTRhb0tRVUxySWlmNmQw?=
 =?utf-8?B?YXVCdzU3dFd6TysvV3VJS2JqenpHK25kbjArQ2NxM1V1SVh5bUkzQ05wa3FW?=
 =?utf-8?B?b1docTNuQ1hmWlJPYW1YaWpXSHkydzVUeXBOUmlUWityb3NjdXZ2bUE4aFBD?=
 =?utf-8?B?QTNRUjlDMmoyK25oSlArS3Z5Mkp6Ym9sSDgxNW9LOE1odUxueFRGR1ZQU2N4?=
 =?utf-8?B?dkpRdXUvODNNdEFteDFraG0ySTdkdGdHZUd1Z0hkZnpwZEd1S3A2UEU2OUJa?=
 =?utf-8?B?QXdMNzhvOTBaRkVlZFo1NkpOdSthSk1vb2dMb2hJL2p5NVJiR2lpRGt5YlFI?=
 =?utf-8?B?UkZIUnc0UFI2Y2VIY3JTeXcvRmtGU2pVQXdoVjYvZVNXMWRzY0RDUk55S3RR?=
 =?utf-8?B?cHBIc2VFMjc3TXgyUXUrQmM3VUJWZG51amlaSzhEcUp0QVJyR296VXhlSEJE?=
 =?utf-8?B?Q3NQK0tSUEtKUW9RdEdsdThtSWhQYmZabmhkYkNPNjhFcmlyMFlpdnFhd2hT?=
 =?utf-8?B?SE9sZjVtR3plTGMyWE41eko5dkh5Y2tUVlcxbWx5Si93K241dDdtMHo0K2Fp?=
 =?utf-8?B?MFJBUEZNSHpHbk1TekNkRFR3ZzlZOE12YStMWWlHWXV5cFMrS0svdU1sbG84?=
 =?utf-8?B?aVJNUC9WbCtMZ1NyNThFMjA3cXpLemZIa3I4RDg4M1NSdC9DM240cXl3R0J5?=
 =?utf-8?B?MnY0QzBBYytoUFVtUCtGYWFHOHM5SlVPV1FPYmhBM01yNUFhQThLQ09BWUdJ?=
 =?utf-8?B?V1gwRG1FWG9CaEdyczl0anhnUW5UeDdnUUl4cnd3ODh2Vk51TG9WMGUvT0Qx?=
 =?utf-8?B?U1JOUXpHYlhaRWkxeHNsQ3cyNUpyZ1FmT1FEK1lrakpsakpON0d4WXc4aVJD?=
 =?utf-8?B?cGZaZ1NHS1I1T2o5bmdORUhXZ1I5MCtQN3pOcWgxbW5mMVJXYTVqVUR1NDNG?=
 =?utf-8?B?T291dWtOeFZISVFRYVhqeU04NE80NktoWnU2aE82WVBXWkJacldVcUFNcTVL?=
 =?utf-8?B?elJCeGR5UWxOak1UNU8yRDk3eGR4RDFaMERRWnBxcUtrd3hJSnR0Qm9xT3My?=
 =?utf-8?B?TjZpMkdDeWc5VVFNR2JyUDRMWEdZMXNOSk9lSU1iSTIzQ080TDZjVFdzYmhy?=
 =?utf-8?B?NU5KTmV1Qlo2citvMzFJQWpsaWgwalRacnVKYWVQUmo1d21NWW81eFpXSlpD?=
 =?utf-8?B?eVd0VVRCbjQvTjlSRUowcy95QjQ5elpCWkxnaGlrUjRwVnFzcTdWSXY4eXRZ?=
 =?utf-8?B?eHZQVUpCQk1PcE1sMmVscTYzQitodk5yTmFiWkNsT2dJc0tyd0FMWXFvcmFp?=
 =?utf-8?B?aHEzSUNVYTE1b21Qb0F4Mld6MVZWeHhvSTl4bUt6Wi9HcmRwUU42b3FHaTE5?=
 =?utf-8?B?Q2VnMS96dkJEejI3SDNHUkNwVXFKOW1Ka2o1ZGJ0VVltNVgyMkx2cDJJcHo4?=
 =?utf-8?B?THNDcU8xU0Z0VEQzanNEZm5hV056Z0hXUnN0QVFkbk5Vc3YrVW9rd3VMeGxl?=
 =?utf-8?B?YVJtdi9BeDBMcHo2aUloQ2p4czJSbFNpT2MreGdEN1Zmb0tHNlEyNmFEOWU2?=
 =?utf-8?Q?E5r8mf5XL41pqwUXL+KMKG9JK?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	bBslGt+AalEBtLYW0Vs8ePgYIa+abCf513FSVvfjbwWyHwUdKZH8C8OJVbebDgKXJBJ2bw/Kp037GV/U9tiFi9PzLnK8NIhaV+m/AbPs3CtkMARW6HziBKUN0dwURshYiK0evJjSLcp/y/OLR6jNrTFfljvvHrLIbgyMVb0VJoJDRgKSzCmLV6I+IfMb5uDvQKLvz6XAouqSJXOlHj0O+srkJt6d4rLTqZKJ4C8Fr7tlfrwhJVtRreP7oWi8Vs9Iog7rgOLcSLLSKkzQ5DGfraH3r7Sl73+6q0pX28K5bKFpl2VGzjJQLqTcwF28P7RNCILdi8gzDQ8iDT9xQl8sCXwWMF3kGpfD5A4U+VR/EQxikIKpiMhlZHeC5u7OEHEppRWIRch3t7rgTAe5zG2qIiQ8Ps4THfMYNSr15aT9716JUQ87E0OSzF3BRVst8VEKImbwUSBW4l4ieEklmhgb5ApnbVtX/V4RNR9PbIZosY6kl2BchXU8ierHHDT1b22lVV924GwdW9qT1QF4TMknVgkn9cVQGM271IlszfNBhTs2FR1nMD6PzvlgyDrjKkzVNqXshVp0J7G60+jUWu6GPQe3hlxnsy2+jWPzcG080YuW6plzGtB6ll+nNtmbN/tjUeccd0MYWNvySGl0737BSW3oQW6RhPghouowIo91gzLlaVdfnwFApWJsv2yVn0xkJEIz+vTGinBmwFBFfydeRUrZ4RJKjtTJc7jSxAD3v/0xBfhal4IbN70i/piwgeHcsyYmpIKIzWW+0cLEyRy3N01wJxSvnpGnvF+6P0T7V7OfFMl4DTxRgzTL8fBHXsW6NYEgBMVyg/x0H6zNSzc6bDF1x2ESssTOS5BMorNPvAHuBxHcCblnkdUhwrE2vFwPWzTOX2xAEkDLHYf45unEk1TU3tY4k/OPzs5pvUPNFM8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa29311-d9a2-40e0-85e1-08dbb2e55d75
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 16:37:18.9762
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: msba16s5NaHR4vdeuOrXW10ZKErp4EOSQOYbyXVNxMpBHJimie4QrkU5k0j9Nw3KIg+4TOzxET/yj3O+s9VB6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB7329
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-11_11,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309110153
X-Proofpoint-GUID: SI1aY02ecv2td6q_ldLiqMq5brjEWFCS
X-Proofpoint-ORIG-GUID: SI1aY02ecv2td6q_ldLiqMq5brjEWFCS

Hi, Andrew,

On 9/10/2023 12:46 PM, Andrew Morton wrote:
> On Fri,  8 Sep 2023 16:23:36 -0600 Jane Chu <jane.chu@oracle.com> wrote:
> 
>> >From Matthew Wilcox:
>>
>> The one caller of DAX lock/unlock page already calls compound_head(),
>> so use page_folio() instead, then use a folio throughout the DAX code
>> to remove uses of page->mapping and page->index. [1]
>>
>> The additional change to [1] is comments added to mf_generic_kill_procs().
>>
>> [1] https://lore.kernel.org/linux-mm/b2b0fce8-b7f8-420e-0945-ab9581b23d9a@oracle.com/T/
>>
> 
> The delta versus the patch which is presently in mm.git is:
> 
> --- a/mm/memory-failure.c~a
> +++ a/mm/memory-failure.c
> @@ -1720,11 +1720,19 @@ static void unmap_and_kill(struct list_h
>   	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
>   }
>   
> +/*
> + * Only dev_pagemap pages get here, such as fsdax when the filesystem
> + * either do not claim or fails to claim a hwpoison event, or devdax.
> + * The fsdax pages are initialized per base page, and the devdax pages
> + * could be initialized either as base pages, or as compound pages with
> + * vmemmap optimization enabled. Devdax is simplistic in its dealing with
> + * hwpoison, such that, if a subpage of a compound page is poisoned,
> + * simply mark the compound head page is by far sufficient.
> + */
>   static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>   		struct dev_pagemap *pgmap)
>   {
> -	struct page *page = pfn_to_page(pfn);
> -	struct folio *folio = page_folio(page);
> +	struct folio *folio = pfn_folio(pfn);
>   	LIST_HEAD(to_kill);
>   	dax_entry_t cookie;
>   	int rc = 0;
> 
> so I assume this is the v1->v3 delta.
> 

Yes.

> I'll queue this as a fixup patch with the changelog
> 
> add comment to mf_generic_kill_procss(), simplify
> mf_generic_kill_procs:folio initialization.
> 
> 
Thank you!
-jane

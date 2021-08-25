Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59913FC2
	for <nvdimm@lists.linux.dev>; Wed, 25 Aug 2021 19:26:41 +0000 (UTC)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17PIU6ih005570;
	Wed, 25 Aug 2021 19:26:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=9gELohL7puACL5fsaAeuHed7f6AYlC0vAo4Vt8YC+PQ=;
 b=Gx9w8s6ia4WMm66ioYDFdx2T3ijERWPe0uzF+5YhaKSUDmaB9TP/U5tKBOY20qj0zdV1
 12UZJf3AxSqMWLcnH458Ttz1l+NlvoDdmxZ6r919KgnEijJe+hZaOm0fdBL1bkoTUhOL
 n0hOgbSudwTWfa44tn1WyGqmqfaEjfYqTKV/WBXOwG7QRJNqDJo2xFPbYoBRzgrFIcnt
 2CQPEmCVVjwy5GhYn4+VzO8IN2tVtHcHQkubLHjhOzqo5jDLPIuqb8oKjNgXGNgvEk+H
 VUXcT9IPbcsfTv05/mpo5L2j9zPu1f3fFAgDaXcw2mIh5xHFNlkNu29ZsvaKwsfi29gN IQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=9gELohL7puACL5fsaAeuHed7f6AYlC0vAo4Vt8YC+PQ=;
 b=ispFwS0pJD+xx1Vdi+LVCgPul26xz9hto6yU7gu1J8+mPl52aYw5KK6lQFWF0gsKeGD1
 VlyvZLtLGH/oTzozHyw4ou43WxARzwiqMWAAiE/P1AgYZy5oOZehmf8xaCDCTZmGkBgQ
 JIXno3nHKYJ1PY0rKl2k/prDigeHS7otdXGPu7oXD3hUscVMlnmW2cCJgFz6yb68gO/E
 DZGYqNNj6LMn1w6At04jTpmztq9ALfvqGp6R+LGDqm+TKSaV6R08sZjEDSn+ZzaG1BwZ
 A+FZacmt+XJLtTFbHUQxEHbAfCLI7/caDtw8MOw42V0ng5ZCYNrESmeZcnQwUwRgQdqR Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3amwpdcadv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Aug 2021 19:26:35 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17PJFfJQ114267;
	Wed, 25 Aug 2021 19:26:34 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
	by userp3030.oracle.com with ESMTP id 3ajpm13usf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Aug 2021 19:26:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBLmXfbiSD+gjQgv0M/gfDzHddldJ97iLraRaaPQDhGrGEqa4/iPd8611x08yTzVd2GQt+w8JtN2dx8vlY+nofG739BOUDTjKttxOyp0gt5BxGeZwZii23qp20ewjsqqRCJWAuMH3yB2LrlZW5qptjwdtDb01fnnMHLL3+HzseOuaC9vz0iFdbJvOzFN0E7K3VRWYc5Q+PeR3aRdnn3qZ9Gu2Xr3Lgz/zxNzQ9O9mzpZbw3HN1NC13KLqQlasLvSWEypBPlveL7qskO37ERnJBuZsDpGwSZzKlLXu+D/TrzhWe/DZXv0S/lcyiIEFnQeNwDxuBzHRPwsMMrE7y7How==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gELohL7puACL5fsaAeuHed7f6AYlC0vAo4Vt8YC+PQ=;
 b=HQXL1O/9yXJmqdVHfrqFZgcCP0eAK8Q6ZFlJeGQwuK2dBBoZyUpysJgPuPmRU+XyqNbFCJWzntm5ogUC2GYc3pqQNOiIyGQin+7emnO5boH9IuHTWKvPXjmHYi7oGvUiTEWjlaZnPuLsqyJq9+EQ+v1BqqcEjltXr7y1IDActkDQFc//aAL1/4FTP7jAjHhY6ixp0/a153OWrl+tE8aT0kM8B5jBblw6LV/EKH+4o50eHsi1k/oYThTkUESiJ9CF+IvoftX1E6BuAb3MbxtptV94q8dv+WLk1Cwgrw19t5nhjrkN5w6d1x9nC3sOLxPPaNgirNGCkELJg3y5GqZi2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9gELohL7puACL5fsaAeuHed7f6AYlC0vAo4Vt8YC+PQ=;
 b=h37xCQECpCVdvGikqOIMfOnGstYhOjPBXmHA4xSWc8aDPnHXVULcHooA5r0X0Ls5DnBF2Dgj9gkOvjzWCil0+XmE4xeWR3RZ3EXoJ58wt1uVNXPM0OBEnCmFEXIhSG7eQXItUrXi//NAvME/k7FX1to9Db25ic/k9TlBO6Vk1AE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from DS7PR10MB4846.namprd10.prod.outlook.com (2603:10b6:5:38c::24)
 by DM6PR10MB2651.namprd10.prod.outlook.com (2603:10b6:5:b9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Wed, 25 Aug
 2021 19:26:32 +0000
Received: from DS7PR10MB4846.namprd10.prod.outlook.com
 ([fe80::97c:b35c:49ea:13f3]) by DS7PR10MB4846.namprd10.prod.outlook.com
 ([fe80::97c:b35c:49ea:13f3%8]) with mapi id 15.20.4436.024; Wed, 25 Aug 2021
 19:26:32 +0000
Subject: Re: [PATCH v3 13/14] mm/gup: grab head page refcount once for group
 of subpages
To: Matthew Wilcox <willy@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Linux MM <linux-mm@kvack.org>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
        Jane Chu <jane.chu@oracle.com>, Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-14-joao.m.martins@oracle.com>
 <CAPcyv4i_BbQn6WkgeNq5kLeQcMu=w4GBdrBZ=YbuYnGC5-Dbiw@mail.gmail.com>
 <861f03ee-f8c8-cc89-3fc2-884c062fea11@oracle.com>
 <CAPcyv4gkxysWT60P_A+Q18K=Zc9i5P6u69tD5g9_aLV=TW1gpA@mail.gmail.com>
 <21939df3-9376-25f2-bf94-acb55ef49307@oracle.com>
 <YSaW3kkcwATVtbVv@casper.infradead.org>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <aabb67a1-9ef5-cda4-29db-8bcd4692ab28@oracle.com>
Date: Wed, 25 Aug 2021 20:26:24 +0100
In-Reply-To: <YSaW3kkcwATVtbVv@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0491.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::10) To DS7PR10MB4846.namprd10.prod.outlook.com
 (2603:10b6:5:38c::24)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.175.179.129] (138.3.204.1) by LO4P123CA0491.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:1ab::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Wed, 25 Aug 2021 19:26:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 964deeff-57eb-4fff-1463-08d967fe3e73
X-MS-TrafficTypeDiagnostic: DM6PR10MB2651:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<DM6PR10MB2651C17C292A0972C7CDC618BBC69@DM6PR10MB2651.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	R7u8XaZMTsHAqMHvuCW7tq6ol7twXcBt/9mvf5uyUvnnxYUr0d0o5RnuYiITECBg6aWuHp4bsef5/nFhwxJfeuXn3r9YPuRKbYq4NqOH4E1Hinc2TAHyOvUvi9njxDtUlxgsoo6oEnetqy+GDIowc6I3TziARgs9MOoGtq8CDb+a/1bBFT1ZlWTyz+gttvkZJeIhYOfFbgnyWAk07i6JntPr4bh0mmjUM6gqZnB67u5RFLy3dARKcDQIuBcNeNl45KwFe/66i0fQJEBhMqeiQ23Js0yasLPIdzKbvFvwM66BVGFTT4yJOmuFecbg5X5TVteFWAytgrLxO4b3t+rFffrndA5MrqAJj6rj8lnba7r4zw6EwHF7CEUfwd4SpB61Jo3d7vgIT2vlUqDv5s0Wj0dmUeqJqzLn3r9wJuhjmacECtbQ/6cm2eN2Qh+A2wVZ0hizg/Oi9qG+FU56x2vW6olniOhsw9An9fcm8Xtt0G+AvVa4XZh/M/3N6hier1Ir+meIJjleinT9BrEThsggyQK9+4z7T62SYjPrDkfJUaNYXRiE9vC846vtEGuwuIYgKF1r6DFRTM15jZuAif7Q0d0f+MjH3TQcpajcJ3gPLAOa0et1yTSOWOXWb86+NENLVy2QdY5KtMlvSNajzJi28YLLr1/OBBxaXt3R+Q4thuY50KC98yTMDogVARCO0l6r
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB4846.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(136003)(396003)(66946007)(66476007)(66556008)(316002)(16576012)(54906003)(4326008)(6916009)(7416002)(8936002)(38100700002)(36756003)(5660300002)(2906002)(8676002)(478600001)(53546011)(956004)(186003)(26005)(6486002)(31686004)(2616005)(4744005)(6666004)(86362001)(31696002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?anBwN1JNRFpmVHNsRmdwNjJNblpKalcxT1YweEVoYWFqazR6MkZFVlZVN0I1?=
 =?utf-8?B?a0MzUTc5dEE1bjQ3TTI0cks1cEJrOVJwVnJTNUMrRy82aTBEa2xqUjIxaEdu?=
 =?utf-8?B?WW1neFVReW52OUlYY0dzd0c4Y0hGbjBETE9FUWhlMTlGUHlWQk16UmRRTkdS?=
 =?utf-8?B?emFJejlCSjNQY20rNjE5SWF4Q2NkVXdCb0NLekcyRWZ6ZGFqcW1GUUtzZzBF?=
 =?utf-8?B?Y2lGb2Q1ZkU2ZjRvMm14TFFkWGdqR0laWEVISi9BVklzY3BpUVl6QVAwa2I3?=
 =?utf-8?B?TkowcFh4aDFUYW9XS1VHalJqZHF5cm5USVRLZXIvV3lJSTJsakFyMTVZaFFN?=
 =?utf-8?B?YkZGcXp5My9Gc2s0TUxEcjdhdVNWNkQrSGNhdThHWk5hYVNaS0VwaWh2MU1q?=
 =?utf-8?B?dHNSUk1kSEc1d3R4UXpTamVzb1FXTzhobVZFMDhnMWY5aWc1MVloVU9GbzNr?=
 =?utf-8?B?VXlCekEvd20zaW5ZTGhSSlphbm9FeFdUdm9NcnZwMWVoQ2hPSWJNRmVMcjFT?=
 =?utf-8?B?YWR1ZnYvWGd3L2FyaHE4cy9rcjh2WWpLN1RmT1A4L1NJWDFYM2JRU256ZG9k?=
 =?utf-8?B?SmFpSW9yWEo0NFpDcVVwZGl2ekFEZFhTY2NsSjhwM1U5VXczLys1TzFGMFlt?=
 =?utf-8?B?bjF6NUZ1aUNRRi90QzZyZHQ3cUI0ZTVRa2U4WjBjRThEOElPQTlwZU5vSUtS?=
 =?utf-8?B?RnkycHJxZGxQeW1KUUo0eFpHRSsxd3NlN1Blcy93TnFHa2tiV1RoZGxwS0hv?=
 =?utf-8?B?L2gzRE1RU3lBMG94L3hiM0dVU0tqWVVNenllNThZdGlZdEFHS0dLTERxREI3?=
 =?utf-8?B?QUNjNEZDUmF2L2xybEF1ckVtK0ZhNm1hdkNyYTg2RU16VmoxOUVkTW14WDVN?=
 =?utf-8?B?c3MxekdOQWx2Qi84YUozeXRkYzZCTGtsek16aVFPMGk0S3JNSGNneWI3ekFZ?=
 =?utf-8?B?SWxxQXkxNHBRNXhDY1lIUGI5RDJUZnlvWnB3bm9RQUd0RjVCS3VXc254WUZx?=
 =?utf-8?B?YlRyVHVzVk1OSVJQelZUaStDR0h1WGt4K3BqVTI4SWtnMG1yMk9iZDQzM21O?=
 =?utf-8?B?cUZtbW5hYmFEK25lSWV6Rjl1T1FJNU1WYzF4ZnZZWHE4UmtoMFFWZmhXN0Qr?=
 =?utf-8?B?NXlJcFhyVVZ1RjFMa2dLNm1ObHV2UEtQSCtQVGF2bldmYXFQSDNaWHp2czJE?=
 =?utf-8?B?cWY3UnMxd1NRaGRpWklZdUZrRVpFNVg4VEl4NmtaajV5alU0bWdRR3NicDBu?=
 =?utf-8?B?dGdxRWV4c3hMbVlOYTBhMG53VmU3VExlUUIvYU81djJJTlg1eGorV1RrZm93?=
 =?utf-8?B?RUJjQVp1ZkRDN284dWtzcUJqWlk0dEJ5MndaT053bGQ4WmNaZmY5U253Tlpt?=
 =?utf-8?B?MVlRcEN1VDVaOS8rWWFjbzVuYW1Yb29KUDJsYXFIaDZDMHhpODh2ZmhLUXNH?=
 =?utf-8?B?QWVWZTQ4TTJLdjRpS2p6YVNOTmJlRjg2Tm04VWdSaVBOTFltNzlTaU5XblJs?=
 =?utf-8?B?aEgvZFR4ZzlUUlE3NnlPZGRGcHBJUnFyWk1lUWU4eFFmVWpralU4OVFYSmJl?=
 =?utf-8?B?UVluWHQrdXU5bVhZMi9KNnRBZ2NtcTk5ZGNPTStrT1ZZeTh6dTF1Skh0NEZk?=
 =?utf-8?B?THV0M1gxNW1iRUFCY0FqaWlhbGJaRm9UdHlKaGo4QkFSZm9WK3diZlV0NXpq?=
 =?utf-8?B?UFRNSkUyU2syVUFTeXFtR2xMMVhjZGFzQjVVZDJwL2NBY0xRZ2FSOTZTNkJC?=
 =?utf-8?Q?2UtCSrfH3dW2GzPfmOkL5XHUkMImjaIYAPM9nOF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 964deeff-57eb-4fff-1463-08d967fe3e73
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB4846.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2021 19:26:31.9626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lpnvO8RkqUm8nGIrqOYrdK/geElnH1rXR+rZUbuONkfZDUDq0pD9dij5JWoqB9B1qMlRQvTvGUZiujqV2hvfC4wcylAX9rekFqrej5p7tGY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB2651
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10087 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108250114
X-Proofpoint-ORIG-GUID: DvfEWWB0pQor_jBu-h8WYZsxgRDsJfOJ
X-Proofpoint-GUID: DvfEWWB0pQor_jBu-h8WYZsxgRDsJfOJ



On 8/25/21 8:15 PM, Matthew Wilcox wrote:
> On Wed, Aug 25, 2021 at 08:10:39PM +0100, Joao Martins wrote:
>> @@ -2273,8 +2273,7 @@ static int __gup_device_huge(unsigned long pfn, unsigned long addr,
>>                 refs = record_subpages(page, addr, next, pages + *nr);
>>
>>                 SetPageReferenced(head);
>> -               pinned_head = try_grab_compound_head(head, refs, flags);
>> -               if (unlikely(!pinned_head)) {
>> +               if (unlikely(!try_grab_compound_head(head, refs, flags))) {
>>                         if (PageCompound(head))
> 
> BTW, you can just check PageHead(head).  We know it can't be PageTail ...
> 
Ugh, yes. Your comment is also applicable to the other PageCompound() added before, as
it's done on the compound head. I've fixed it on both, thanks!

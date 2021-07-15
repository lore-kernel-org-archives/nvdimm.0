Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71A3A72
	for <nvdimm@lists.linux.dev>; Thu, 15 Jul 2021 13:17:47 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16FDBY7l022087;
	Thu, 15 Jul 2021 13:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=OnQUFi6hC9kNVQ8N/J9QIKgVX2CDd8IQaH7o6z2E5ZQ=;
 b=XR6QcXstY3R67by3S/BU+qPGA/fg9Q2Fwegk9dbaZ8aBp/S7S/QjWHtHLHLt9g1+f7vj
 tmUQUWbG+6JodluMm7I24htIFt/Z5P5TEhl5Cgwv4MZ3VPXaBZmysTNeMIfj5c17sxiX
 W6Xl8Zs5FvGWGZZ7VE5OEtfxcnpOMaSHIR3FZpd4KROiwyY9RmR+VYroLoSwnR7wFcZD
 GoIPQZRnUJPzYC/nbQrzGsrU7nFSQ0KSYKnNM4KM1cU5fAKyEoeO5ji//fZPnLZDzI6J
 Ou8Pi8XrazSzQYggwt0P7vozeSohV8M10znmPnGWwmevmgzZFOxvsiWI35X7Mi2cZ3dk Vg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=OnQUFi6hC9kNVQ8N/J9QIKgVX2CDd8IQaH7o6z2E5ZQ=;
 b=CptTBuKzWQkP9Tpb/QqQIrRqvGSQzz4E/C2z0erO4HNjro7HyPQ32GlnmgwCgVQ3OhQc
 Nls8KGq5vvNwvQrCiOvbgaW0ThpSKvFN9YQofSnRr3isyO/27/DqT+lGpE6dle61lT2S
 Lw3Kfa+GrDZaHW2TAPlBLPg7qErJLcXl8DfjQfZjo/7P3N/lf500KmTwb2inU5VvFkeJ
 9vE48lxe2xaqZhS+AMxYSyyJPMpH6gLy55IuwbN569ImlKVe2hvnQQyc0iiMf/nu2sxO
 ONYDuMi8ymXc4HOUrtO0AotBkB2Vyd0H3wv/M28oXqR/RmmX/pVjK86TWbaMvvPvTS/E 6Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
	by mx0b-00069f02.pphosted.com with ESMTP id 39t77usd5b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:17:41 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
	by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16FDB5uG177973;
	Thu, 15 Jul 2021 13:17:40 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
	by userp3020.oracle.com with ESMTP id 39qnb5mhrf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Jul 2021 13:17:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JSylN47eeNWrycn7MpC7DFZND/R6fWoscJMH3jtQfds0lG7pyIFuPuKEDQpNRYidB/Cy12mbKT1J++KAw0cUlkv+wGBM81PzQj5T1Fgu3v+DSwdDs0NL8q33LIbIcWaEdNBaAJmrl69lIhnXZz8HLBNjAmsvF0amvkqvUXDEUL3pkrXdQgAm/LXqaZpeXHRwY5CjKIbMIz1+3qVHbYh7ghu0ufIUNL3h3JkeTG18Ppm+PsGf4z+mMgdQ5IwBTdhdg3at5aAr3YP+962zfa79llFdyT/kf/3TGSqLltTr4pxIE7+3BX4W3SjWY80JDcxYwDroqoJo10fOJDmeLFZxmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnQUFi6hC9kNVQ8N/J9QIKgVX2CDd8IQaH7o6z2E5ZQ=;
 b=U/sttBtF91YDQvP+EDDx4ukze9BdoKg9Rydysqmt+CnL2PWcUWyOjMZayLvwQ+asnPzr9OCoeYPSysEQUs54Inl/e96M8nQ6/iot+OMKByuD1g0q0Csah0O4y4qC5UR5WU2jTUYh2RtoRknSdlFzFR25jjMVs1zQZpsNIJHMR+pgEy6Y47mNwAufRxxLD1qAmuHwpqveFXuHewH5/hnJa95lqyXBtYSyPEyEjeDvM7Tx3pIJ89pDucMMiAfD5DdkXT56jSLOExhwwBE1yPyxpgeSzy4W+t78VrFhN8RahlgKCjEughQ3n1up3qSnK3k/TaP1KSeK14PIx3v/29PdaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OnQUFi6hC9kNVQ8N/J9QIKgVX2CDd8IQaH7o6z2E5ZQ=;
 b=mO9IORSPEOy6kd6VOjkN5P7njYBdortXuFrkCBHfVDnLHPhBzuM7Jf4JnWKmp6Oa41tKjzh4t+YOk8fCm0yEVwlgFXmjwjDfo6Yl4mjcBAyEvGIKkiUPIGRnCl96VtVmetrWgg34GSjMcRRShcGfFnPE1tdGT0dLKbBuB35HECE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB4142.namprd10.prod.outlook.com (2603:10b6:208:1d2::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.21; Thu, 15 Jul
 2021 13:17:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4331.024; Thu, 15 Jul 2021
 13:17:38 +0000
Subject: Re: [PATCH v3 02/14] mm/page_alloc: split prep_compound_page into
 head and tail subparts
To: Muchun Song <songmuchun@bytedance.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, nvdimm@lists.linux.dev,
        linux-doc@vger.kernel.org
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-3-joao.m.martins@oracle.com>
 <CAMZfGtVhMbQ=QH__SbM4zf1KYBPSVsOcA-Cho2k832Qqmz+uMQ@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <4bd02d46-c8ea-ba4a-54bb-50a4032d1926@oracle.com>
Date: Thu, 15 Jul 2021 14:17:32 +0100
In-Reply-To: <CAMZfGtVhMbQ=QH__SbM4zf1KYBPSVsOcA-Cho2k832Qqmz+uMQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM9P193CA0023.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::28) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by AM9P193CA0023.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Thu, 15 Jul 2021 13:17:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e54cb7d1-676f-4c62-e525-08d94792eadb
X-MS-TrafficTypeDiagnostic: MN2PR10MB4142:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB41420DCBF2B9E3DC45C7D756BB129@MN2PR10MB4142.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1107;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	vGjaQeuyI29JI+pt3jpzAjn1seJXd5IWO5nKIMZ6fqsEKOZMfWUVcljMwb7DR+TwWTu7ljMc5V1jRVPoJ7Eymcc5FuYUH6wYejPmKSkANooY3WgmwRqWQhN5Kq4CmDfq0WkL+HlepbNfxSbvebluTIM9oiAIae+jvqFbiTUuo/g1QQmniR60fVLrSGbTxNCZbmkfhJYoczBzy14D8g3HBApjCUwJCdWasDkPGnFj0r39FdzvKxmWXh5ulqctgvJ4aZP4eWa5XDZ69JDKnk8Zw0+XftrGAabrwgmNT9l1XRInPXsYWWNMrnIYjIuJPrvH/WXKX7kCnrmXDm1fwrR0gc9VWRS/Wtnw8O0PULGesN2/OLQc1Wtu31ko3z3pyGq3EDXoMfr5Zr7zm6MN2Upi1td0qyiQsoWLTcb3bTq0BISed8QzybfcsIOEMkdoyDyN4vyCVcJQmXkOM40I8OYs9UtuCpuf1fegYGqPEMv2Hf7fWsQJwURJ7s4Z8fgqdEB/Mq/9RNlu0dQwo09Wj2uWtm8EfZYAeRUQRq3q9uSzwASyjARgMFqv0038RhkyUIL6GVSppD+jmFr/MosoJKnIuh1AE+nFLGZW8n/ZQw52hgv2fsShv+8qHqwbCkzXP8XQIlOYiwBGUQIRhJ8ks8jSY6WjL3/GduPAqTPMVM8xpTZS/qPnKRGV700LIuTaKGd/wA0tA3qhAnfQAVE4+ve+lw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(39860400002)(136003)(86362001)(2906002)(26005)(8936002)(36756003)(31686004)(316002)(6486002)(66476007)(66556008)(4326008)(7416002)(54906003)(16576012)(478600001)(6666004)(31696002)(8676002)(5660300002)(956004)(66946007)(53546011)(2616005)(4744005)(186003)(6916009)(38100700002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?bmNoUmY3RWpmMlQyVHhFQkx4TWV1SmdCaUVWWjQwU2hNNndYbDhvZnJiVE50?=
 =?utf-8?B?dUZRamh1VnZWeVpPYjJXK05vcE1vdFNoWWdwd2QrOTd5cEZXTHhmWmdiQWFI?=
 =?utf-8?B?SFJ4NzIzcjgwYnpHTUNOLzdIT0NXSzFYTTVsc0tTMmU1VUR4UGJwb1hOalB6?=
 =?utf-8?B?am5IZGJWbkxZQzN0aU9kSHlNN2wrbUZsUS9mNFlKQmhwdjUxWEZESDdZSTcr?=
 =?utf-8?B?cUlodDlNUUFlN2g1UnpjM1VWdUxTT1QzYmd4anJVck5nNWlnV2NhcHVxb25l?=
 =?utf-8?B?dXIvdDU3N0VYbFMzQUtHaFNmL2NDaG9ZNjFEdVoxN3ZCYVJlblpNRk05dFF6?=
 =?utf-8?B?ODZFcFdhUzNTQ2N5bitKeUFCS0NhaVI1R0RTS2tSbmlsc3d6a0xRSDRNWUJz?=
 =?utf-8?B?dGx1bitOd0I1MVZnWWQrbHh1cFhzMnBUbmVXK3NtWGdxOS8rRE9pVnhyblJR?=
 =?utf-8?B?V3k2aXQwSEJNMWRjd3JJQjRoR1JNRWt0RVVXQU5XallCdVB0c3FzNUdiTXMw?=
 =?utf-8?B?OS83M0FsMzBpd2w4Qk4yM2JhWDRsVWtrWktmMGExQ2IyL054dndmTE1pWUdh?=
 =?utf-8?B?N3JOV21ZVXZHK0IzbjN3L3hDYXdaSkR0UmhnSGhaZ3pwa3pXTDZCV3pJU05p?=
 =?utf-8?B?S3FVeHVoVXhDZXJvZmovSjJEWEw1aUoxQlpNQ1o2ZTh6bzZIdW5aRW9CSUIw?=
 =?utf-8?B?YU1na3RJM1E4VW44dnU4WVgwTUJQZ2dkU0ljQjNpLzhBV2ZaNGJqeUlhREly?=
 =?utf-8?B?MCsvVUZ3U25LWHNaeTJPa1hEejROd043WDBXQTgzcjYrbUJiZXpEVGFUSTJG?=
 =?utf-8?B?YUFyMkwxd3VNRWpWaXFOa0xXWCt1Q0M4K2VBUU53aThoU0lmU1JlNUNlU2Jn?=
 =?utf-8?B?MnFJZnMvZzdSaTVGc3ZxeldIQkdjU1RDelhyL2Q0OHg5Y1BhUW9xVnBnNGYw?=
 =?utf-8?B?czg0WWlwekoyRE1tUHE0d3VVL0ZjRVE2RmlJcWMzOVptZVhQRi9kd25qRmM1?=
 =?utf-8?B?WUxXbENrMW1VV1BUcXk1dG1EWFova2kzOFg3a2RnQk5DTHUxUnBEZUpCbUsx?=
 =?utf-8?B?ZTZVNlI3em1EYkFhNE9KRDBtamt3TUpHcUt2T2VPdzFnMVhJdGhmc1NlZzFR?=
 =?utf-8?B?emtSY1QxQy9VTFF6SzRJY1lDZStZQUxyRlNnZkptMlRXVGdWTGdkeTlXM2dO?=
 =?utf-8?B?WVNCK0kvc3RpVTdZY1dYTU5taWxXRDJPZnM2SWZqeGltbjFPZmtLTWpXdzVk?=
 =?utf-8?B?eEFxVk1kdkgya29Pa21RL3FZSjdIRDRkeld4SXRIOUZlYk1DakcrY1RnZ2k4?=
 =?utf-8?B?T3Y3MzZDcTRwa0ZqOC9xSFN0YWxFdnBYQ21zQUtlcE1KbmtvQ3EreHhrTk1D?=
 =?utf-8?B?WVhFRHFlNTB5TkJwSUpOc09EZk1vRVpzYUFITFNLMWhBeFFsL1psRkZJczdk?=
 =?utf-8?B?VnNKaTdkdVppaXpEU1lnVGdXTE83Y2p0eUpaaTJZS1hZbWlyaDkvNDlvQml1?=
 =?utf-8?B?c285NmhFMWFtbHZ4SFpBc2tMa2k3VndGTU5MMjVGaS9UZHd3ajg5UElDdTc2?=
 =?utf-8?B?bDRENXoxY1ZodlFEQjcvUlJzcWNhVnMxWEV1bjNzaTNycjFmZm5lTDRTZ3RD?=
 =?utf-8?B?eE9paFVwRzNsdmNRY0paTkc1WHpvWDh5SVJZN3g1YWxDME9HVUhFeGpxWDRp?=
 =?utf-8?B?Tk1xS055SGRaYkJyZmJVMmtPbEtnUFNxV2d2SEtocGovdkt0QmdoZGl0RkdQ?=
 =?utf-8?Q?E3tcNIymS7/mrs0i5N6Eqrftd6YSk+4ZutM2BDX?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e54cb7d1-676f-4c62-e525-08d94792eadb
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 13:17:38.2594
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4ycHJ4+q7BFPiV4bfkSgctcUhUCaqEgGOaKQ9oTkjhbHfsvyiZjrGD05TLj2HsxIu16bBJWJw1QYVqHNacHzLoXzx5CqzkDQmbAPozmH4bs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4142
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10045 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 spamscore=0 suspectscore=0 adultscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107150095
X-Proofpoint-GUID: YOKvCrcSDrV74y2CNzlbOKSVA6KP8tkd
X-Proofpoint-ORIG-GUID: YOKvCrcSDrV74y2CNzlbOKSVA6KP8tkd



On 7/15/21 3:53 AM, Muchun Song wrote:
> On Thu, Jul 15, 2021 at 3:36 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Split the utility function prep_compound_page() into head and tail
>> counterparts, and use them accordingly.
>>
>> This is in preparation for sharing the storage for / deduplicating
>> compound page metadata.
>>
>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>> Acked-by: Mike Kravetz <mike.kravetz@oracle.com>
> 
> Reviewed-by: Muchun Song <songmuchun@bytedance.com>
> 
Thanks!

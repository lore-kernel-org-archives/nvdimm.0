Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704593FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 14:17:15 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17ODg4F9025089;
	Tue, 24 Aug 2021 14:17:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=mEyC9Yb4uSqseWpxC8yUYjHvZE5LWF1tSQjNAFi4n3Q=;
 b=Ce8QRtRtXjq4AOBWRvx8e/ZROKadF63xJiBN+iPI1XWbaqi3u1UY/PFz2oIvPp4RrS4y
 x4QQ/fE5JtKbi/nJ4J31ueubmVif8DGLO55QXlJl5SDL/GIm9/VIugv7Vc5lsrjhpan9
 Keri5aKovdhoc3ak+0FOoSjln585nTOnc6PgjT3MSGQ51o54JxAOog/OonfSnrXfaDJi
 5mjvWXR1VEGJdTKn23h4xVlJPbFqtn5plvJ+oNNEr/bbBcpGQQopBUsYNQO5rw12grud
 quscF2fQpJKCx3+xAZMdckw0jGWGJt9HqNu8fZUgrUV/To76chI7Xpbl+NwyXupZKki8 MQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=mEyC9Yb4uSqseWpxC8yUYjHvZE5LWF1tSQjNAFi4n3Q=;
 b=qWdZcyK8O+tlbB4/wwZUEwgrTRy0PKpJ5qPY4fs58YHWFLD8zL5tJY04cGfZImKeU1gQ
 3eXfsAW+YAxk7t4Pu8Czz0//JCnI7qMEQ4nIW+UgkyB7TcmFrak4xWtyZz6P4vIYSfZE
 1K8lFWuwsRgd5zVGD5pJMl2pClVdsoEpepgBSloMXsl0gmQ5j+fa61e93HzbDJg0l8R3
 2mGiD+9/+08AXiHeG+2Kh+FHH+Iay5l+5h2hEXDUkMLWAKi9dXHAeI3ZOIFo2F/FCheX
 ruOSNwtQqcSdQ600VZkkTFFH2bVK+ngMr+TwpxANVJd86POgXlXXb3QOYDLyVDTPjMm+ Iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3amu7vs67q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Aug 2021 14:17:11 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OEBFGF040446;
	Tue, 24 Aug 2021 14:17:10 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
	by aserp3020.oracle.com with ESMTP id 3ajsa5c46h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Aug 2021 14:17:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNxoE6ktaNXIvHcFyAnoSd77EQCwl+ZnBIRTk7wATwG6kzRli+jcZP8TGfd+ohbxQHwxBK8wBaoergrEqKNHnPYmkMzv0EmDQ9mAX4d2Nnyil9FkTGcW/W1DV8Sg9MFvNflJo/oJfPMBRchWd8/37jubx1qKYPVpMS5/rGvK2fhwbFvX9+lV4V5ctovO3/XFWMuxlt/UlK+45w/shMKdXObTBjTqEp2H/t29Nftn/qTsl4xG9VbwP1PrMT42xcp+lsJ6TD29WWpdY+hiHqjCE9FCrww4QJc0aU7PNFmyvcIABjKDTBIlIcAurMd11Nnu0SVPFCUMqfiAIQYqB2yn/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEyC9Yb4uSqseWpxC8yUYjHvZE5LWF1tSQjNAFi4n3Q=;
 b=LqUvHejCFEKkf40cYrI/F+Kv0aMFTSeXrobz4UqchIHGXVfwygxpBkEmwHFLj2olyM3ib4fPfLFU21Z0OoPpEKRooXn00/lScVaSqlYsmQ8pSy6dmlz4WpYNmk5nbGlkTJ+HXRdd9/DYHygnKKOi8Nq+kVCNYMu4gHxIECaHJYer1Ad6YeyRq/SZM7i5kuiNI2DY5k299ZtY1QKtIhxBxU9sCQC7vnmutnNm11jDgx/EOTqX08t/y4hCgWCd4A3xcxnwvRVJCqrftkgdjVPhtHhthZmYZ/++yNLciSJHkCBkhUNFO4lJXKkrR+RG5is+2KJVh02svPBIm9KYq9W8tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mEyC9Yb4uSqseWpxC8yUYjHvZE5LWF1tSQjNAFi4n3Q=;
 b=S5cWdEUf9IPYvAPxvh2v3MibDQpSfDteuqtRVTcmD1v5XqpTEFeEkzSPqlc7jRJ+3psyv6+OS9Zp47tRASvrxY5KFrmZW1BhWZ4ifZbgl4K+WkxPjSM2m5a9OXJnibDmTxKyX1UsbwgVuHb8Qj5yLrt73LMS+kshx4AFwS5rBU4=
Authentication-Results: lst.de; dkim=none (message not signed)
 header.d=none;lst.de; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by MN2PR10MB3774.namprd10.prod.outlook.com (2603:10b6:208:1bb::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Tue, 24 Aug
 2021 14:17:08 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9dc0:5e0c:35ce:24e1]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9dc0:5e0c:35ce:24e1%6]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 14:17:08 +0000
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Dan Williams <dan.j.williams@intel.com>
Cc: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>
References: <20210820054340.GA28560@lst.de>
 <CAPcyv4i5GHUXPCEu4RbD1x_=usTdK2VWqHfvHFEHijDYBg+CLw@mail.gmail.com>
 <CAPcyv4jpHX4U3XisqVoaMf_qADDzKyDS1wOijCs3JR_ByrXmHA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <e3f49c83-2391-4a7e-6255-e4e577790983@oracle.com>
Date: Tue, 24 Aug 2021 15:17:02 +0100
In-Reply-To: <CAPcyv4jpHX4U3XisqVoaMf_qADDzKyDS1wOijCs3JR_ByrXmHA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0314.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a4::14) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.175.176.190] (138.3.204.62) by LO2P265CA0314.GBRP265.PROD.OUTLOOK.COM (2603:10a6:600:a4::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Tue, 24 Aug 2021 14:17:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 76466976-70cf-4aba-a769-08d96709dafc
X-MS-TrafficTypeDiagnostic: MN2PR10MB3774:
X-Microsoft-Antispam-PRVS: 
	<MN2PR10MB3774FA0A9EB3F62FDBB9CBB9BBC59@MN2PR10MB3774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	SGNYlBb1BWaDCbWTefGpTbsCtS1/sJDpubTaFQIjPV85BxdNHOsOmReXZ7g6YFf73zRHCNU/T7yO7Zn5J+1WrAtUiZdeOqhv7tjP6KLxQnrO916OV0V0WhFq4P8DClZ/WshjcyU0qomqpQIwsElBOqbLanA/lygxjHFnhenUUdtrKUvzdHNdAn+/ZR004Az8i71hQcRdYQta4TrE2iy2WtVvrRMvTRdaDu7Elw/dPM8IqfukGOWehK/1j57FYUo5r4R05hGUfCWr7xgcJoKh6qCHiqM+sVYys5lMniisjNoeATb6gBRCWRLtxZ3Li34/oIQnPhQuMe/gPqiyUCwaQSG8GZ3oHwzYRP8EZgQp+m0W0g8D4vcedjMb3XVahDEkmsED6VdDiVN6yEKWdJCnYDyEJYcFHFwE7DcXROEK1GEiZbzrGd9aTooi6Z8+59cWy8BENP9Sudp+SYOyj+gi0sqxWDY4yuuERMdyEVqJuua5efravleAHkqn2OjUWQ30cSZYLuORtjqllLabFs94H+JQdGpywTpC6l8cdoOssdl5CaFyZ4FB0jSgNqpQbNq+z3+BDSt2b+XuRwnY9EbtTea6i3tLQxqlLiCvWJxLSdWz3NRdbdsSJwBHhb+FdS0tVp1zN24xOWKW8bNN7L7zXeFM3FqMdoAoaT4etquL+PUaifwqRU2An6uSGGHZZ8PQnOslwdfnSTYkTNVbOQCuF0knBnsuopY/iEpymR0wW2ly0HxjSk1mqnhgwomLE/JxXoeBMpBmwm5tIV2gEVmrfvMeI1w1KQ6hPpNr61GUVto=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(39860400002)(136003)(396003)(376002)(966005)(4326008)(6666004)(36756003)(8676002)(31696002)(83380400001)(316002)(956004)(2616005)(31686004)(53546011)(54906003)(38100700002)(16576012)(186003)(66946007)(2906002)(66476007)(8936002)(26005)(66556008)(6916009)(6486002)(478600001)(5660300002)(86362001)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?ZzdnQllMZ25GWS85RjNTR2pWWEdiYllSWnN2QURWSXZJR1ZKYUZXUVg4ZjR1?=
 =?utf-8?B?Qk1GVFBVa3FkN0ZzWGNwZ0UyRW5oMHh6RE1YeGtlYXM0Vy9ZdEV5djJjZkEr?=
 =?utf-8?B?NUF3dTlWOXdXUUR0V0w3K0hGeU4wTjJZREtySHZaT2VrZHRpc29TN3Q5TzJW?=
 =?utf-8?B?YzRlM1VZaGR0aTdMN0VuSC9zWVFHYjhPWlQwVU1BQkRETDNSRHZvTWQ0ZkNV?=
 =?utf-8?B?Z3lMemZnZ3pEa2VKSm9PT3g3NGhtcm81MS80L1R5d3dHM0EzUUhDdGtuTld2?=
 =?utf-8?B?Snd1cDhxNW9ZZ3d4L0dNZW5HaXlobHBGbHNySXdCcmFLQzdDcDRzeGNEKzYy?=
 =?utf-8?B?R3ZhNVVZSkhoRFE2UnVMNGdFUG0zaUtDZktHUWpzRlMxWC9UNUlGRThITmR0?=
 =?utf-8?B?MEQ2eUFGeEFLTTZUclpJWGt1c3hwWGpLLzA2am9xQ2lPVlJ3YUF5b3AwekNi?=
 =?utf-8?B?NDdjNzI4R3dQQ0RheU9COXZrZkZ0TTFXNkJXK09jQ2VFbU1vRDVBbWF0Mmt6?=
 =?utf-8?B?NUNqWm9RWlJhRlV3NlozVlFYQmFOa0VqOVZDNkx3MUo2UlJEcU9xZC95VkZo?=
 =?utf-8?B?UUVPYVpOWUZmSVRuZ1gwNTB1aWZ5YUpvT2FwVDRGT25IV0lZTEJnUkdDblgz?=
 =?utf-8?B?aUhZRDJIaENsYTBiMC9IVUxvYXBSaE9KaU9samtKSjJOU2ZDQXp5cGZGU3hq?=
 =?utf-8?B?RzN0WlQxejY3cDFyVkp0bVVEemJIc3Z2WHhUZjIrVEJieGozT3hQZE5CbU9H?=
 =?utf-8?B?L3NJUThLREtRUlM5Sld5Tzh1emFiSDd3TmU4YmdTSHM4anl5NVFacSszUUpV?=
 =?utf-8?B?N3ByUytlL3hOeEo3WnBvc0hodE02ellQNE1GUkwxWmJUamUzbU5EU3cvRml2?=
 =?utf-8?B?eEVQbVEzQXFXS2JWdGZ6RU8zb3VnMm43ZHM0anM2alR2ZmsybXRxbmxxNnVL?=
 =?utf-8?B?bGs2UmthYitYeUJJREl2YyszNGdLMUFmK2htdWwxSHJOeFZkUUVvbzduTTM0?=
 =?utf-8?B?N2Fmcjd2UGdNbE9oUVVnTU93QjhUWnZVa2M3MGJYL2tUb3JXaGwxUG5ic0xp?=
 =?utf-8?B?dG0zRTljMXRGWGo0UkNrK0d2RmhVMHlmZGVtNjBBK29xY2laY0x1QTFyQ2Y1?=
 =?utf-8?B?QzZsYzJEbG9VTXQ3L3J0RHZ4cFhuU2lPb3JIZE1yRHA4MFV0WXpBZUFQRGww?=
 =?utf-8?B?Nnppem1Xc3RoYmZqZVA0Ri9VVDg2NXlVejdvemdGYis3eXl3dXdLRHZ6Q0cx?=
 =?utf-8?B?azB0Uy9nTXRzaUpFVVM2U3FjZzIrRG5yYnc2YVRrVWRUaHJSY1RCT1ZVUGs3?=
 =?utf-8?B?RE12dTlhVU8rYUIvOE1lTkdVRTl4V2dXYVFMaWlzZWM5b0JVR0dELytnSE1N?=
 =?utf-8?B?MktHcy84NlpKWTR4YmdrTDJrd0VUY2l4eW9NdTVMYVVYRjRqRHZkRjhaWDBP?=
 =?utf-8?B?Si96MWJYMEhKbVdBclhkNEpJTGg1QUczYnhCREpFWkVuWk5LQXlPNlM0ejRs?=
 =?utf-8?B?UWNRUmw4K05yUjlhSlFvMjB2T2JqUytmREd3dEZFcTVGMEJYRE9ZR3N1QjlW?=
 =?utf-8?B?eTNOdDg3WUp1R1hETjFGVGhOK3BESTIxVVNGVFNPblhYWC90MU1JVk52V2Ny?=
 =?utf-8?B?TCt5cUdkN3hlNXFPT3ZXbFl3aTVoNEhlSjRNb1RSTHpjVWNJSFFtV1M1WXlO?=
 =?utf-8?B?aEhjQ2xUZGVLR0JnVmZmKzcxWERFL1RLY1l4RjREOWtqbnZMSjVQYmlERzdC?=
 =?utf-8?Q?n+9M1cgzhk8kXaveismcZwNZ+m4aXqofcc1piFl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76466976-70cf-4aba-a769-08d96709dafc
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 14:17:07.8970
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C/friKlaRElFB2QbeA+mwkPEjXv75gtvJZ6FHdkcgffQG2WbGPW6ZvuNk79TJveiZH3sCCTposstkKcHIslC8dCPRUkGWICTL39DH7yCxZA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3774
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 malwarescore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108240095
X-Proofpoint-GUID: nybHAL3Dls-SLfMhwX6KOx1rcKYvifKP
X-Proofpoint-ORIG-GUID: nybHAL3Dls-SLfMhwX6KOx1rcKYvifKP

On 8/20/21 6:42 PM, Dan Williams wrote:
> On Fri, Aug 20, 2021 at 8:41 AM Dan Williams <dan.j.williams@intel.com> wrote:
>>
>> [ add Gerald and Joao ]
>>
>> On Thu, Aug 19, 2021 at 10:44 PM Christoph Hellwig <hch@lst.de> wrote:
>>>
>>> Hi all,
>>>
>>> looking at the recent ZONE_DEVICE related changes we still have a
>>> horrible maze of different code paths.  I already suggested to
>>> depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
>>> architectures have anyway.  But the other odd special case is
>>> CONFIG_FS_DAX_LIMITED which is just used for the xpram driver.  Does
>>> this driver still see use?  If so can we make it behave like the
>>> other DAX drivers and require a pgmap?  I think the biggest missing
>>> part would be to implement ARCH_HAS_PTE_DEVMAP for s390.
>>>
>>
>> Gerald,
>>
>> Might you still be looking to help dcssblk get out of FS_DAX_LIMITED
>> jail [1]? I recall Martin saying that 'struct page' overhead was
>> prohibitive. I don't know if Joao's 'struct page' diet patches could
>> help alleviate that at all (would require the filesystem to only
>> allocate blocks in large page sizes).

/me nods

Either that or dynamically remapping the deduplicated tail page vmemmap
areas when we punch holes in what was represented as a compound page (or
when we collapse pages back together). Not sure how crazy the latter is.

>>
>> [1]: https://lore.kernel.org/r/20180523205017.0f2bc83e@thinkpad
> 

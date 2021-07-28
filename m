Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A7503481
	for <nvdimm@lists.linux.dev>; Wed, 28 Jul 2021 15:56:58 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16SFumhl030594;
	Wed, 28 Jul 2021 15:56:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8kyRc6pFdTr6jnnsJyO+Ha313zNDWPk3JYrju045KpY=;
 b=obkQ50TZ4jcbt1QvYqYPXo73HIxOW1SC+E9QcIrVluSy9qIh9IxF74JU0JhoXV/EFdZx
 bx7poeA7ejHXM9+lkO2jg/851643iqyDkM2A0Uub5VAPdXqZbZZixB7T5Czib/0tYcK9
 dWWnw49iB8P3QLYQnEjSZiZ5260H/QwJFZGkSzt9RCqCCBM9rOYp7et9Er9BUDjESTlu
 tqj+ssq1HsaiI+RynwDnlom+nlgQbZIsdOCmaK+k7/0lOCRyPHIg/dj1zELO46Ac9bov
 2l1zTiTQvA3MNWuqg8NoDQcNuzUxNNxphcnOeq+Q1gZh52D+eQRJqtYwlW0bcNS8vAEy 5g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8kyRc6pFdTr6jnnsJyO+Ha313zNDWPk3JYrju045KpY=;
 b=Dw0k8U8ginrcDT6PSgZx8LmQdZgrd2mHTN9VEWBZL6p8pNg7z5cXMMk9qhGvEvQ+dmT2
 O97ENHOV60hIrJUntDPp9JPNSCJ5mixxwqVAQOjLYY4WnP4KBnOyNutlLQg6R9FLQf9L
 dnbVscTA1sZrWU2UtdGXzIwLmGJJ7P3oH+ducgObflowLwq9d3NFzghKzf08oEFUFHam
 gYuezNXkGnbeSTcTMwj0Vah5Z5Sd4/gbFDY9z4QalWqtUOWtLrlpBh5+aErGh2aF1LBT
 ES+QmJVdO7UQft8d8vOP66+lxzWNbfUOoyxJMUoHz7oxgprLWUwGUJZEGPp/LnizQZz6 Lw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
	by mx0b-00069f02.pphosted.com with ESMTP id 3a2353cv7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 15:56:50 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
	by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16SFtiBt180111;
	Wed, 28 Jul 2021 15:56:49 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by aserp3030.oracle.com with ESMTP id 3a234cr7p4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 Jul 2021 15:56:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MD6ZHmYJ4y8aMweSBIUL+qeqCibh0OegG4vdMGTGiD+ll9BzdeBYRDfNy8KuniuvjcCJuWH4vlqgDAv1QV639OoGUzjffhRvE0GfgvaI6UsGtSM7LeglQ3wq5Hh6RxXaeF9a62x8Dbu9u46+hDBvpMOwH34h3l2KtPznD/RvUC222tY9N+7+57+hQ2vGPlkkQUDjN4t2dBjqNP6uPiVIgow+Kj4kuAzjfrhdktU2rC1slU/YfWkS+5Hmxi3a5Ay5mm8tyhoZMqVod3a03J87vGlYjyxj/KpiwOmSa/8MYPHNvMKtCv6KEfRcxW0jN3NfGerQtisSXH+xaJigB3+h0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kyRc6pFdTr6jnnsJyO+Ha313zNDWPk3JYrju045KpY=;
 b=mgCQhVVM//fUlPOf6ll5NN4067JGApDHCU+WSOtQvo1JVYYOgzLDj/NMKZC42Z5i9OeYMWp1APPcDkKCo65Vhgg6tJWYPnjnICC77wUz2TTtRXkhOMa8/yAyujfENr3MCInNOThJpOLxmYdexEMeZ7vvLraHir/7IlxBxcXnUJFIGrIHwEHH04XBFbppxVkYJcuS7GNWtc1aBZRJWKhjBXB3/IDnEcAzjkjH7LYHFA3Fssn0vD1k6GPlaaivTKQN5GFp9gdW9Q+qfuv+mFYFK/KZ/SmHgR9Xl1rCpsem8RL6dSpi0BOurkQknCkDY9wOrQZBODHuZ079I7ax5+BGRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8kyRc6pFdTr6jnnsJyO+Ha313zNDWPk3JYrju045KpY=;
 b=rlGbFUbaO+YcepIqY3LUq4Hx75h1RMVZonFHIWyIqWyyNWP0/GBnPbmhWANbcKLMqRFoBEQBFJWWHE4ZAwmWXY/h3H1db9q7unMvlaVZO78iDrj2ChAbwsJMjMmcdjIuc0ejKaa9LOoiHSKwD5mWkDWVmo2zfMLEOJzNF2CjFzE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB5137.namprd10.prod.outlook.com (2603:10b6:208:306::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Wed, 28 Jul
 2021 15:56:47 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::5833:5ab2:944c:7360%9]) with mapi id 15.20.4373.020; Wed, 28 Jul 2021
 15:56:47 +0000
Subject: Re: [PATCH v3 11/14] device-dax: ensure dev_dax->pgmap is valid for
 dynamic devices
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Vishal Verma <vishal.l.verma@intel.com>,
        Dave Jiang <dave.jiang@intel.com>,
        Naoya Horiguchi
 <naoya.horiguchi@nec.com>,
        Matthew Wilcox <willy@infradead.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        John Hubbard <jhubbard@nvidia.com>, Jane Chu <jane.chu@oracle.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210714193542.21857-1-joao.m.martins@oracle.com>
 <20210714193542.21857-12-joao.m.martins@oracle.com>
 <CAPcyv4hv+LXmAs-BMATuyoPLRAF_-+d5Yap450sbCDFTcvGO4w@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <9e361442-f8e9-cdac-ce7d-94c0bcc6cb0a@oracle.com>
Date: Wed, 28 Jul 2021 16:56:40 +0100
In-Reply-To: <CAPcyv4hv+LXmAs-BMATuyoPLRAF_-+d5Yap450sbCDFTcvGO4w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0142.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:193::21) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.67] (94.61.1.144) by LO4P123CA0142.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:193::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 15:56:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eaa1ecba-36f4-4515-f4b7-08d951e04d59
X-MS-TrafficTypeDiagnostic: BLAPR10MB5137:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB5137C1BFA03B4CEF121AF329BBEA9@BLAPR10MB5137.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	xwQgtXxU4VWCpXoeyk/ool04F/gN+LUOgHo1pfNK3eytR3zEK51ivRA+TpvOEE1ERu6GU90Uu1t4CZXjHuu5KHiTtNzleA8syKSq0kWeHRZk2VLwdUxctVkzbYMR8JJ6EqLLmc0R1SOBmrJRjk5IvLEqkUsCRrVNzyniWqFJEoewKQVyopLtkJUpC3PGl7YoHXYdk5CUUDRoxS7+P7EokFXXi73IT5W75WtoSm76mbJSETd/09pWmwoMRn8vwkETLzCFf0p7F+M662tGBDB4YrQ6QIvq0lUxwT5uS7xL5c70y4s1img7TwtdrwYZCmnAIoJ5hA6qiuXXzFUljavPL7eJoMWwX7eYdoQhoUv0wlEimFvh4x7MOfwy3K0EM+KZ7CKzvQtJSn6NJVir0TIrEzIObELRa6F7rL+rYjO9OC7UrzSy/BhBIU3N5mRdFGd1Cjc0HRk0ghC+wi8ljWeeyWZS2evhcheFLCKVXnHk2GHFPGpkZnOUdPnrDFXQB2+E5bDqJ4F28quEfn/JjcHSrXxk6te+C84s9S+8cemmVIDko0smmlj4Z8f2GIHMEmeipmKhXjoOzVbl26sMvX2m91c0ap29KUlhIfi24uIFWotwUqZ6s0/JtAE3budU4FoK8FQLQ3/MRGrloqWZjItTEVpAh6O4RY05l/YBerY+0xmZJH/y0n2Dxe2mdk3bGhjA5ozSiTt1uH9j/OkohqlxZQ==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(346002)(396003)(136003)(366004)(316002)(66476007)(16576012)(86362001)(54906003)(31686004)(66946007)(66556008)(186003)(478600001)(6486002)(2906002)(36756003)(8936002)(8676002)(4326008)(4744005)(7416002)(38100700002)(956004)(2616005)(26005)(31696002)(53546011)(5660300002)(6916009)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?aEh1SWpMa1BOMDN6bGZZVHlUZ09TTEIrUUJkbDlIVkxTQVl0Ujg4NWJSb3k0?=
 =?utf-8?B?eDV5VlFtWTlXWTlxMXNaRWI5Z1lSTSs1N2dScTYrblBHbHB5S2o1b2ROZEM0?=
 =?utf-8?B?Q3RhbC9FaGsxK212azR4MFo0YW9kam1Ma0tTVVMwNk13eXZHV3daZFljSHpD?=
 =?utf-8?B?cVV4amNpTW5kbnk5aXVweWNhdW5PZ0hXV0g4cTIzdnBXM3dIcWM5di9JNHRM?=
 =?utf-8?B?bnRsYnNiM24rcmVCUzBkSmZuM24xRlNvLy9zcEZlTWQ1QXRCY29nbTdSTWFa?=
 =?utf-8?B?OTE5cGpQNjdZakduY0dXT0tiUWpWOHozVWQxbURuR2x3SDJUSy9rWGxoOC8r?=
 =?utf-8?B?d1hjTDdRL2l2eW9lMEF6VklPc1pwRkNZN1ZxaGs5UlZ2MUk4MGpOMFhqV1NM?=
 =?utf-8?B?Q0VQekNyNmVwUWltclZLK05PRFFLVXgwWnVCd0E4R0QzQlRFNzBKMVQ1bU5F?=
 =?utf-8?B?blM4THNSVVVMVzNhQ0plSU9jZVhodmxwRnBaZ2ZvdmJNcE8vdjkxNTBLUzBW?=
 =?utf-8?B?SklnLy9xT0poNklKeHU1Yno3bFpOR1NoNGY4N0MxYWRpS2UyWktrTjlmOWg5?=
 =?utf-8?B?ajJScTNBdEllOUk3c3pCYnU5cFhvVlpUWDk4dHAyejRMYklwd0JYREh1RGNN?=
 =?utf-8?B?bmVrb1NkL2FXaTBEMXNmRktZckdaRGtNRE9nRDRUeENUNWZmalQ4anN0c3JW?=
 =?utf-8?B?MzRNblg5Z0tBRjlBaTdtYlQ2Mm5pMEw3V01QSFJ3elV4eFc1QVRMT3NUa2w5?=
 =?utf-8?B?RlBoQjhMcytGandQekorVVhrcjE3VzdKTEdLMURqVlB5dTNOTlhXWFV2Tzhs?=
 =?utf-8?B?SHdLMTgydldjQVo5MmtJWnJTSWhVbDkrdCs3b1lyRzRsQVl6V1NNbUl5OFoz?=
 =?utf-8?B?ek5PUlk1eSsxLzVJdlpORVVDa0FUaHJHMk4zbmtCa2JpZ09SYzlPTUo0Vk4z?=
 =?utf-8?B?RUJhNVhtaDhDL1JJYXhzU1dkcnNyakhKT0hjRHZseXE0bXpndU5zUHNnZmt3?=
 =?utf-8?B?bEN2amt6OWlodnMxemw2N1U1N1dnaVRRZmRzSVY0Q2d4Q05ZTjhmTXN3ZnI4?=
 =?utf-8?B?ZzJWaUk4cUxSb1o5QkZqcittaVBRc0drMDh1djdMWTJFNTJxNUNzL2VlSDhh?=
 =?utf-8?B?SUgyYk9tUmFSVWIxVG9jVjhQRHBZZzVaMGs2UjBYeVNOYjhJZHVHWnU4Y0Mx?=
 =?utf-8?B?Z3FWL3FHaWg1VEF6V0N3V1VBUHp2cXlFUW1WUVNqZ0wrWGFNVFh3NDFXWldi?=
 =?utf-8?B?MUI5djVMQW9PQ2ZVLzliUCtTclZoWkhpaXROZkMzMTR6Mmg1NTFKenNDS2xt?=
 =?utf-8?B?M0ZYNktHUlpMaW1QeGFGQmQ2M0FZaDhsWkNwcWdnM2ZsZFN3OSsvWGh6QlVO?=
 =?utf-8?B?K0JQNVpGV1J6RjNYNGRJNmh5UmpwMExManRuZXVWa3FJNWE5TDJJNi81bWRP?=
 =?utf-8?B?WHVWL1dkSFRMZ1RtM05IWFlhM3RraVFua0N5bzVMdkZpZ3hWMXA4QUtRdDY3?=
 =?utf-8?B?RHdGaE05Y1BZMFoyWldkeHJnbnFnUm9rNE5oS3RHSTk5bklTUml5SU8vMlZS?=
 =?utf-8?B?TUdudFJ2ODFpdVB3aWR2aUpnT1c2ZWNnM3FJNnpHRlhlbFljNW5uenVnTzFn?=
 =?utf-8?B?Z0tMcUI3eFBoZ2FaSlRtM0JkVzRhTnJmRjV2QlVFNUZsYmJEaGIrVWNoSElM?=
 =?utf-8?B?ZHBiVTczK1JPRGpPY3IvdEFyeVo5YjBsazBWeERET1JsQzJLRW9FQUN5S2l4?=
 =?utf-8?Q?/G1zGE6Vy17v1cavOlToHdFeGT0AdRknVYPJuXJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eaa1ecba-36f4-4515-f4b7-08d951e04d59
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 15:56:46.9218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C3+udTpgYOlIxOrE6IvxBavgVQmEuvsIGQti0ZNftNhyooW2bA+dKawLjCuqzphUv2+sCQ7IuEAgFEA/tqBd4Yq0SeZPdr7lHvPVjOpzbYY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB5137
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107280089
X-Proofpoint-GUID: AyJqbne8J-m9t3Nrml091bj0N02rSDkb
X-Proofpoint-ORIG-GUID: AyJqbne8J-m9t3Nrml091bj0N02rSDkb



On 7/28/21 8:30 AM, Dan Williams wrote:
> On Wed, Jul 14, 2021 at 12:36 PM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> Right now, only static dax regions have a valid @pgmap pointer in its
>> struct dev_dax. Dynamic dax case however, do not.
>>
>> In preparation for device-dax compound pagemap support, make sure that
>> dev_dax pgmap field is set after it has been allocated and initialized.
> 
> I think this is ok to fold into the patch that needs it.

OK, I've squashed that in.

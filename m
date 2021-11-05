Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5EDE2C80
	for <nvdimm@lists.linux.dev>; Fri,  5 Nov 2021 18:12:08 +0000 (UTC)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1A5HPxZs020804;
	Fri, 5 Nov 2021 18:11:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=C5QCIqtuahISQvqyNeuQS1NwvYCFRzEtz3SxCL7Opg8=;
 b=jQTgssI/9BG+4rX4b7XJkgpgzXVuGo8/5ZPz+5Hsx8OIheWXjdZPEB8jCN1bQBZb5s8N
 92PGdehLX75ImPcKWJdLcEsbz1XZYyEUWGFTDwmejGJmuCvriHgriVRKKJavRQzpaNeP
 htlhRe3kDMdgexL5i9Lytuk0/bsDChoGA9a22b2UVHNF731UWFOlbxJRxRA+LR6GqHLG
 QDwI4ONZFSUA8gv1tMW6b8LrKM1FLnhq6PCN/U/vjUhm4VbIuFhfQB81n62lBL2F+TnM
 3CW6IJpK0XMjTwlwIHYUVb39xJCPOx+Is1KC93em3D2YCCtsdFpKokOt7ULCKgxYITAr UA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
	by mx0b-00069f02.pphosted.com with ESMTP id 3c4t7f3wvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 18:11:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
	by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1A5I64Ac072533;
	Fri, 5 Nov 2021 18:11:53 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
	by aserp3020.oracle.com with ESMTP id 3c4t5sr3sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 05 Nov 2021 18:11:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5sz7V9DsR3J+kIH9IBLVKvjUomSPnXlHtNJKPPD1pW4iNLCpFRpzOcyL+nwK9tZb1jOiyIxCtKCtFzjUHneXoyX8kYxMKT+PlQxcBFiaRHqlJG7dgZlaL3Yew/Mt9IPaOrusxvcTLc6WCssFabsnbRtjegzOVvwixhFB28fWZ+DogCI3D9k3q2s1RnLFK1Zjz72oHsK8pNNrEMWRXcu+NPKlTeTJnbfssrc/2McNdqZNaucgSXpdDYIqWcy+ZYDYmsQVQXzFyfCv16plGSDvgBgxm7lieGTx8iNBdkENQpe1/uDvd9bZ3+y9BSODSh/QtPH2LN+cNPuTuSTXbTGqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C5QCIqtuahISQvqyNeuQS1NwvYCFRzEtz3SxCL7Opg8=;
 b=kgof9leH3LsCcBshJUGX65ZMo/wPSUD95Eg6KlSuWEBF++npFy3qwYBYGmOBaUQgUZDmazVscR+xA0CclzSe44GQ06xPLENTQeJmNfbULOJtrEiJR/SXRBhbB+4LXyQR3Mpimt6PazCWVPUzvPhPBpQlg1ia9jP47ZSfIzPEpDxpbBehtBkAnKJOCZ8pvVnkn/FdLqTQ+Z3rcHErm9kdVnPI3AsRDJsrQqXeTVsmDOVzOh+bPiN0ST/R7MtCFTLA8ymTfpA/wNYIjg0UoktbzSV9QWA/WJlVl5xYtTHmiVw6Mpbnh3FDwgiLIthXIY3e/jHJu11ojRkA+/BvOi+fgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C5QCIqtuahISQvqyNeuQS1NwvYCFRzEtz3SxCL7Opg8=;
 b=uLQVp8RHFNPg08eZLAYNF66IxM4j/Q8zeR+6Vsyai4mn0b4ZWUfjRMr482sT6WoEb34c9eHNwe/7RNmANxZgzeY7rb/a+yYIlREHbkjcG8Zg+Soz1cxemuHLhjBA1VtiySen9UKaoTganx4HE+FaXf/QY8rn5rd+Nj7rEv9kxGA=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BL0PR10MB3060.namprd10.prod.outlook.com (2603:10b6:208:79::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Fri, 5 Nov
 2021 18:11:50 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::d809:9016:4511:2bc6%8]) with mapi id 15.20.4669.013; Fri, 5 Nov 2021
 18:11:50 +0000
Message-ID: <59d01f51-4542-dc87-ebe7-6013cff40e18@oracle.com>
Date: Fri, 5 Nov 2021 18:11:39 +0000
Subject: Re: [PATCH v4 06/14] device-dax: ensure dev_dax->pgmap is valid for
 dynamic devices
Content-Language: en-US
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
        Jonathan Corbet <corbet@lwn.net>, Christoph Hellwig <hch@lst.de>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
References: <20210827145819.16471-1-joao.m.martins@oracle.com>
 <20210827145819.16471-7-joao.m.martins@oracle.com>
 <CAPcyv4hPV9Vur1uvga7S4krQAmKZK5jrBrdOuK1AFHVE8Zk1DA@mail.gmail.com>
 <f33c2037-4bee-3564-75c0-c87f99325c02@oracle.com>
 <CAPcyv4hE86SXyamXWhZEDHnhAZ_wty-DqD6t4cmkEdKdDwhpMw@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
In-Reply-To: <CAPcyv4hE86SXyamXWhZEDHnhAZ_wty-DqD6t4cmkEdKdDwhpMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0019.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::31) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Received: from [10.175.160.24] (138.3.204.24) by LNXP123CA0019.GBRP123.PROD.OUTLOOK.COM (2603:10a6:600:d2::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.10 via Frontend Transport; Fri, 5 Nov 2021 18:11:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f0e280b-7961-43bc-c55d-08d9a087bd13
X-MS-TrafficTypeDiagnostic: BL0PR10MB3060:
X-Microsoft-Antispam-PRVS: 
	<BL0PR10MB3060FB215C1728064E02CD60BB8E9@BL0PR10MB3060.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	QdjXFUmQusUk9ic02HEAfoUfgTn1g1UqzCB1C9lf1q/bg8z+QeHQKHgMMzEwSjfwh67N0HUgRKM4IA7zjec3xjt6+sMHEvkXqWnHq2ZV5HlKben+3r7nI4cmZK6u8iNuYcrQEY/uFBLXtfdj0ycd6S3JtmKoIGuJ3a+cKZoO6RsitGWJpNb7AevZsRLWkOvDKLIreEq77M4+95/P5GiX8YHY7RYhEpcLz+V/E742C3KirYdv2V40sQh0uGmyu+kyitikojarAPULTynM/73OBpcztwZD1aRtRD7nX7X52/hzkP6pwZFKqCreqEdIXsRfvn6qFHG1y61giFXaVw+28xCTKrRIQnldit38mbAnzmqagrCsp2BddsxpoNCAAxOwc8r2A2fQugNtEju6S5t1NxQ0Bd+ZfRKBhlW59Y/W5GyoI/zoHr07+Gv1Xe897ygOsrQ19DHzxuEUzavRXyVE6EvjPeZ+iuz9RE1UQehBe+bI9Xk8PfFNSbyhwIutmZETDrUxIRh2vxe1ONxQfUSUc+KiClN0JfOHCR/ousJylX7HvkFGM9X3Z3UMrl54lPUbyGr5HaSYh251M1livIC5VMHxYnP8SxvOTP58t+S2/njGFZQCJilXPHiVAjyXc+PZmB9pO6ASQYfkmrzNHGHNbLWu5wQq00LP64Fc7trqPOThOU+OiQAl04QSIh7g06iMEIDa7BawJvXu3msDtM5vGA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(5660300002)(83380400001)(86362001)(8936002)(2906002)(66556008)(31686004)(956004)(186003)(66946007)(16576012)(31696002)(2616005)(316002)(66476007)(6486002)(6916009)(8676002)(38100700002)(7416002)(6666004)(36756003)(508600001)(54906003)(4326008)(53546011)(26005)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?RU90dkpqLy95d0V5YXBaN1FTZ21VenpyZkRZc0dCUTFMM2tlZXlvTXNUTjBk?=
 =?utf-8?B?TlplUTJlQ0h3TGdVNS8yUTJIWWcydjNVVmdxT1dUU2E1Nmk1RkJrZnUyUDlx?=
 =?utf-8?B?WGN2d1RWVnRYcEpINVlvNTc2WVVqTW1ZSzFPY2VYeHNTdFBFS3J0OGhtZHpo?=
 =?utf-8?B?OWtySmVZN2QvY0FEU0lZTWNpSW9YZFdBam90QnNSRWI5SkpSaFZUUEhxbEFT?=
 =?utf-8?B?Yzc0MzRnQnpuRG8rS3ZNdTZrcm9EQmp0NHZaMFROYTBNWE5OYjJNSWFiVUtN?=
 =?utf-8?B?SkFsWWxhbm1kWTYvUnp5N2JCb3I0YjAxWEtGZ3UvRUxONjVhSmdRa3lna3lM?=
 =?utf-8?B?dDJRNGpIcEFFS3V4WDRJSjNsb1E2U3RGWVVIbnZDS0hOZlNKVzdPYTJQcmhm?=
 =?utf-8?B?SDBlZ1hBZmRWN05JNVVkd2s1QmRrcXBpTnRSV2srYXEzQjVtWUdSRFkyeFBS?=
 =?utf-8?B?TSs3K21VYnVkYUZHN1VjWkVJVXZQVjU1OU5IQ2V0emFNb0ZEcTdRSjd5dGx6?=
 =?utf-8?B?STZTMzRiWmRUeWpRNkpRUTVZblVGaGRUWVpXS0JNOEd1UU5hdW5zZkdBTWtF?=
 =?utf-8?B?WDdqamduRThsWE9DZDJ0alhJRUtBOCs0bEZLelc0QUFBMW9PR2U3Mjh3dEFQ?=
 =?utf-8?B?SlFiTWRuZjA4dzhWazJjR2pOUmhoR2VMNmhQSXFrZTh2MU1ML1ZoUFhsS2l3?=
 =?utf-8?B?bSszWUNnTCs5UDFRdkM1STdNZG9lWXNhQTJ5SzdXNVVOQXl4UW96ZExCNk1V?=
 =?utf-8?B?YkFkV25nTGxIY01TUjFsaTVubGgwNThZNllsUkUrZktBOTYwZ05HampSUDQ3?=
 =?utf-8?B?NGVsdG9MWUhybXF5bnZLTXF1NkkrZFNmWUxZSFlzdW5wZ3VUL25pa004UXl1?=
 =?utf-8?B?TjltNXBIUWQ2RjlUZlN2Slp2QjBoYnF5U0VIakJlS0Fxa1hRSGJuVTlpV2dG?=
 =?utf-8?B?UFpTTUp5K25UQVZkdFoxZjd1Y1NDRW1LL1lPRHJmSVAzS1E5ZGc3RzhWOUVn?=
 =?utf-8?B?T0w5ckxJVjZoSW1OeW5scUh4UWZQRlRLa3ZpUForNnFlUnpxeUYzNC85dlpp?=
 =?utf-8?B?Yy9nZDg3VDd5ZExKQ1hmdllDUVErcVdyS2tDWjVFT2phQTlQb2JRUnRMOGFy?=
 =?utf-8?B?ODMxVEcxM3c1SERlVnozdEFqTlArTUhhMGlnajRyaFd3RS9XV2tYV2VhMk9s?=
 =?utf-8?B?Z3hHNjdyczBqc3BqNzlMdWZLOXVFUkhraDNvR1UzSDYwRTVQc0pFNnZXOGFv?=
 =?utf-8?B?ZjNYN3dzdEg4UzNEM2RzVUxoaHlyOE5WbHlPSUxrL2NUbHpaR0IvUXJmRGZq?=
 =?utf-8?B?NnQrZkNEYTRwV25hWFJSTnZuN0V4TzFla2M2MmcyUnBKZ3NZTktjM3ExRUl4?=
 =?utf-8?B?Wldkc2ViOWg4bkQzU0kzdzl4VVFJK25MVnh5ZUZKT3kweUVHZmpOQmFpOVlu?=
 =?utf-8?B?Zm55U2E3WXlhQkdaV2JXT3Z5RGxocDJXbHhkbzgxWHdOb2VsbDlvbEdQM3Bt?=
 =?utf-8?B?QWJQTjNiUHkrODZ3bjZXMVpXcXNuOVBOby9QNTI2cGsrYkpBZGxwZG1Dbndw?=
 =?utf-8?B?ZE5oTU95VjZ6MEpPK3J4VWJJSFlwNTU0NVFtM3c3TjBhRG96eEhPVFo0Vjcr?=
 =?utf-8?B?MC9XOFovT3ZwU0NnOWt4WVZKV3NSQjdYZ3dSamN5TnpQK0JTb2toaGxsYzlC?=
 =?utf-8?B?bGZ4bTlkSWM3Q3pWcVZFM0tqR2VxV3FDMldpdFh5eDlsRjJSVC9kVGU5SG5G?=
 =?utf-8?B?cGVWQnNqdkh5bHFOMG5FM2ZNcm9PNGRWaFZ0N1RVL21vUGF4bkxva3E5RWhl?=
 =?utf-8?B?RXVtV1MxVUhoNmZxTHBQU2JPWWNlaGU4TXBOcURCdVBzaEk3by81U3VJTU9M?=
 =?utf-8?B?NDZQQnF6ak9UM0k3WGVpbE4rMlkraGhhdGRzUXdaUThXc0M0WVo0b3ZKRW5M?=
 =?utf-8?B?MUxJV3RUeDBHU3NnK2ZCTE9WMlhJK1JLeUdkS0FrWkhPYVdPMVRRM2lDUWRG?=
 =?utf-8?B?N3oxampicU93UEJnb1Z5V2tOdW9Mdjh6MlN6ZUx4emRWbVBEOGI5R0N2ZWl6?=
 =?utf-8?B?NlFVWkVVbVh4VEJPMGczbWR4OGx4M1h5ZTdmK3c1RDRZS2VmeFdrcDk5MnJo?=
 =?utf-8?B?OWVBRXJlOHlMYWtIb1o1WmlqdFRRNU5JOU1XKzB0VmxpL1F4VzFtcTgrRzRD?=
 =?utf-8?B?SVNJQ0V3SnZDVGVDa3dzTGVzOTl6YWdEbFVxNjhmS0xFS1U3aWtBbmNNbFZD?=
 =?utf-8?B?WERiam1Ed25QTzltOVNpOW1RVzZBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f0e280b-7961-43bc-c55d-08d9a087bd13
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Nov 2021 18:11:50.5572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: seVoxno8dhJ4RPM5JMhwNAq7RpfttYAoYogA+Y62EEzYkli7pmgMOuZm775Y2PRA4aSKyGWhNl8aTA9vGbNnMpAq4QXeHMbmo9O4zSob/7g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB3060
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10159 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 bulkscore=0 adultscore=0 mlxscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111050101
X-Proofpoint-ORIG-GUID: cO-xW4gsRkVFovqZBpZlGnpbO1EgawdM
X-Proofpoint-GUID: cO-xW4gsRkVFovqZBpZlGnpbO1EgawdM

On 11/5/21 16:46, Dan Williams wrote:
> On Fri, Nov 5, 2021 at 5:10 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>
>> On 11/5/21 00:31, Dan Williams wrote:
>>> On Fri, Aug 27, 2021 at 7:59 AM Joao Martins <joao.m.martins@oracle.com> wrote:
>>>>
>>>> Right now, only static dax regions have a valid @pgmap pointer in its
>>>> struct dev_dax. Dynamic dax case however, do not.
>>>>
>>>> In preparation for device-dax compound devmap support, make sure that
>>>> dev_dax pgmap field is set after it has been allocated and initialized.
>>>>
>>>> dynamic dax device have the @pgmap is allocated at probe() and it's
>>>> managed by devm (contrast to static dax region which a pgmap is provided
>>>> and dax core kfrees it). So in addition to ensure a valid @pgmap, clear
>>>> the pgmap when the dynamic dax device is released to avoid the same
>>>> pgmap ranges to be re-requested across multiple region device reconfigs.
>>>>
>>>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>>>> Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
>>>> ---
>>>>  drivers/dax/bus.c    | 8 ++++++++
>>>>  drivers/dax/device.c | 2 ++
>>>>  2 files changed, 10 insertions(+)
>>>>
>>>> diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
>>>> index 6cc4da4c713d..49dbff9ba609 100644
>>>> --- a/drivers/dax/bus.c
>>>> +++ b/drivers/dax/bus.c
>>>> @@ -363,6 +363,14 @@ void kill_dev_dax(struct dev_dax *dev_dax)
>>>>
>>>>         kill_dax(dax_dev);
>>>>         unmap_mapping_range(inode->i_mapping, 0, 0, 1);
>>>> +
>>>> +       /*
>>>> +        * Dynamic dax region have the pgmap allocated via dev_kzalloc()
>>>> +        * and thus freed by devm. Clear the pgmap to not have stale pgmap
>>>> +        * ranges on probe() from previous reconfigurations of region devices.
>>>> +        */
>>>> +       if (!is_static(dev_dax->region))
>>>> +               dev_dax->pgmap = NULL;
>>>>  }
>>>>  EXPORT_SYMBOL_GPL(kill_dev_dax);
>>>>
>>>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>>>> index 0b82159b3564..6e348b5f9d45 100644
>>>> --- a/drivers/dax/device.c
>>>> +++ b/drivers/dax/device.c
>>>> @@ -426,6 +426,8 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>>>>         }
>>>>
>>>>         pgmap->type = MEMORY_DEVICE_GENERIC;
>>>> +       dev_dax->pgmap = pgmap;
>>>
>>> So I think I'd rather see a bigger patch that replaces some of the
>>> implicit dev_dax->pgmap == NULL checks with explicit is_static()
>>> checks. Something like the following only compile and boot tested...
>>> Note the struct_size() change probably wants to be its own cleanup,
>>> and the EXPORT_SYMBOL_NS_GPL(..., DAX) probably wants to be its own
>>> patch converting over the entirety of drivers/dax/. Thoughts?
>>>
>> It's a good idea. Certainly the implicit pgmap == NULL made it harder
>> than the necessary to find where the problem was. So turning those checks
>> into explicit checks that differentiate static vs dynamic dax will help
>>
>> With respect to this series converting those pgmap == NULL is going to need
>> to made me export the symbol (provided dax core and dax device can be built
>> as modules). So I don't know how this can be a patch converting entirety of
>> dax. Perhaps you mean that I would just EXPORT_SYMBOL() and then a bigger
>> patch introduces the MODULE_NS_IMPORT() And EXPORT_SYMBOL_NS*() separately.
> 
> Yeah, either a lead-in patch to do the conversion, or a follow on to
> convert everything after the fact. Either way works for me, but I have
> a small preference for the lead-in patch.
> 

The one reason I am leaning towards the after the fact conversion, is that the
addition of a new exported symbol looks unrelated to a drivers/dax wide conversion
to namespaced symbols. Looks like a separate cleanup on top of this series, as
opposed to a dependency cleanup.

>>>  EXPORT_SYMBOL_GPL(kill_dev_dax);
>>>
>>> diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
>>> index 1e946ad7780a..4acdfee7dd59 100644
>>> --- a/drivers/dax/bus.h
>>> +++ b/drivers/dax/bus.h
>>> @@ -48,6 +48,7 @@ int __dax_driver_register(struct dax_device_driver *dax_drv,
>>>         __dax_driver_register(driver, THIS_MODULE, KBUILD_MODNAME)
>>>  void dax_driver_unregister(struct dax_device_driver *dax_drv);
>>>  void kill_dev_dax(struct dev_dax *dev_dax);
>>> +bool static_dev_dax(struct dev_dax *dev_dax);
>>>
>>>  #if IS_ENABLED(CONFIG_DEV_DAX_PMEM_COMPAT)
>>>  int dev_dax_probe(struct dev_dax *dev_dax);
>>> diff --git a/drivers/dax/device.c b/drivers/dax/device.c
>>> index dd8222a42808..87507aff2b10 100644
>>> --- a/drivers/dax/device.c
>>> +++ b/drivers/dax/device.c
>>> @@ -398,31 +398,43 @@ int dev_dax_probe(struct dev_dax *dev_dax)
>>>         void *addr;
>>>         int rc, i;
>>>
>>> -       pgmap = dev_dax->pgmap;
>>> -       if (dev_WARN_ONCE(dev, pgmap && dev_dax->nr_range > 1,
>>> -                       "static pgmap / multi-range device conflict\n"))
>>> +       if (static_dev_dax(dev_dax) && dev_dax->nr_range > 1) {
>>> +               dev_warn(dev, "static pgmap / multi-range device conflict\n");
>>>                 return -EINVAL;
>>> +       }
>>>
>>> -       if (!pgmap) {
>>> -               pgmap = devm_kzalloc(dev, sizeof(*pgmap) + sizeof(struct range)
>>> -                               * (dev_dax->nr_range - 1), GFP_KERNEL);
>>> +       if (static_dev_dax(dev_dax)) {
>>> +               pgmap = dev_dax->pgmap;
>>> +       } else {
>>> +               if (dev_dax->pgmap) {
>>> +                       dev_warn(dev,
>>> +                                "dynamic-dax with pre-populated page map!?\n");
>>> +                       return -EINVAL;
>>> +               }
>>> +               pgmap = devm_kzalloc(
>>> +                       dev, struct_size(pgmap, ranges, dev_dax->nr_range - 1),
>>> +                       GFP_KERNEL);
>>>                 if (!pgmap)
>>>                         return -ENOMEM;
>>>                 pgmap->nr_range = dev_dax->nr_range;
>>> +               dev_dax->pgmap = pgmap;
>>> +               for (i = 0; i < dev_dax->nr_range; i++) {
>>> +                       struct range *range = &dev_dax->ranges[i].range;
>>> +
>>> +                       pgmap->ranges[i] = *range;
>>> +               }
>>>         }
>>>
>> This code move is probably not needed unless your point is to have a more clear
>> separation on what's initialization versus the mem region request (that's
>> applicable to both dynamic and static).
> 
> It was more of an RFC cleanup idea and yes, should be its own patch if
> you think it helps make the init path clearer.
> 
OK.

Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E72263FC1
	for <nvdimm@lists.linux.dev>; Tue, 24 Aug 2021 14:09:47 +0000 (UTC)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17ODmr1i025062;
	Tue, 24 Aug 2021 14:09:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=je9K7gWckJJUI5FDF1qslcNyKk1qwigxL3HLjrJHyPY=;
 b=vFgd1bJ4/oSBlh8HmmN62imb+ZiAavZiaZIIFYuy9hjLZGKUFUkjV5XpsEdXsh92HJTi
 RDF6Z6F36HRtXp2S6u5Upbt2OcZFCzeXnJj//AzSkjnZkV71G4aWDrufleoCNc/NB7Za
 PM4BzQUIEYmz8gbYYtN5IqS83lZ8sUnAH8KBC74QbH6JHsfIx66mY1gg/chy/a8inV7u
 BzIkzcc4+AlqLLkff5Ii8L4sKAW6FFTge6xpLZ9G5xmkE8jdWMeM9Q3/ZiZYJwDiUOV/
 SnLGhMNrfM+cCOrYM3Dl5hGy86/+vqGij8u2DHvw633wsgN5zSMvAEctnynnHAJMeWUJ Yw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=je9K7gWckJJUI5FDF1qslcNyKk1qwigxL3HLjrJHyPY=;
 b=WdS0b/woI147W6hNl+uCebeExOgreCAuY/1zQuSSvGA2N6MgDmfsjyZONSd/scHeOxYa
 j2xulFZAXaO9qgj5067xPdYjjjc9QTJ+D5tYfUaxIAIMkYBY1p0jipUB0earJJO4grNJ
 pZY6h4WVixE/0vcoowvDOhwNvrpCxTl2myp9gzrt5Pmw2QGb7OAMEHnxxS5iJzaGYa3w
 DQm611K47j5yc7C2DB6GkuhKV3m4pyVrpk3nF0qmK4in/Cf1YHQx710yeopE7OA3d902
 0gCYIJATdB4HRzKvwwdn56YxmFRH5wwAIyNO7FpPtRGQSYizBffjyZ4ecEp/9CVvzOvT sA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
	by mx0b-00069f02.pphosted.com with ESMTP id 3amu7vs5jw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Aug 2021 14:09:42 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
	by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17OE1Xdx004449;
	Tue, 24 Aug 2021 14:09:41 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
	by userp3030.oracle.com with ESMTP id 3ajpkxc791-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 24 Aug 2021 14:09:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fwJZTXSHoXsWHe8xIil+Yv/JVcKCHPMnc6IJplZSU4au4XmPldCyQdI5IDO7Gvub/qh919zMrJoJyeUjnWi0TahtwQiXXvU0bYknGPkqGt3KpZ2OkP6vOjzmsPdCcfOk4Ke4qJA+ipq9eWfPEZMZS42a7XM4n9dU3Cs2saebgyHIQff8GHu0PK9zICstKHcSprkHpHaFtkiebEaKPludcodHAQYGQeXPNWGotdkyX87nwyUu2wSeoJBgmMLEzPDxnOH0QJAc8eFWbKEX14yjpQlfKLirwDit+eFEUoBSPmxKIPj0aApl3IpIY1lwSfhkgeuC9kpQO4sm90KH2mpm6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=je9K7gWckJJUI5FDF1qslcNyKk1qwigxL3HLjrJHyPY=;
 b=IkgZYvKDnIpz1Qjv7QO4q/MBWhNW0lc3JclZXMYAHobh/GKctB5uA0zLD/EsDEbSHEheOxFXkHx5w8/i0muYeKiHTTtydudxtEgNu1OAZCa1WshD351sAuD8ZWkjq0iKOr2goNmRwPr0uvkazugNxQd3Nrw/w7pxRkdZryc9RU8oyqNWkSQGEI53QB+JYkqQt400wVQhl9Hv/c2lgHTf9ZfwVTc1sjlHQ2we4F2gNRUKk0Xbgn7zRtBcBeoWF6rU4WKH2tbbU55z5aAZ6h+Xt7ySZReB+XrxQm+QD3lGW3J9loNi43beiUA6evrN1/OVyfdje2s05BMNAkx3LnFTsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=je9K7gWckJJUI5FDF1qslcNyKk1qwigxL3HLjrJHyPY=;
 b=h5RVyMlVDRmNfpPfnd5MMb1HuTfkNnbzLL6/aShfHNV148vErSZuhFxkjgWgtlFzT5sR3td/aT2U8qZWX4w0ynCfj+a0QMRLfmFkSyyjKtq0ga/E1JKFrrRi+ij3WMUuXGgceSHGxTirYdve3RdP763MHRJUqXcRRFuUyTavyiM=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from BLAPR10MB4835.namprd10.prod.outlook.com (2603:10b6:208:331::11)
 by BLAPR10MB4979.namprd10.prod.outlook.com (2603:10b6:208:30d::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Tue, 24 Aug
 2021 14:09:38 +0000
Received: from BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9dc0:5e0c:35ce:24e1]) by BLAPR10MB4835.namprd10.prod.outlook.com
 ([fe80::9dc0:5e0c:35ce:24e1%6]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 14:09:38 +0000
Subject: Re: can we finally kill off CONFIG_FS_DAX_LIMITED
To: Dan Williams <dan.j.williams@intel.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Linux NVDIMM <nvdimm@lists.linux.dev>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210820054340.GA28560@lst.de> <20210823160546.0bf243bf@thinkpad>
 <20210823214708.77979b3f@thinkpad>
 <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
From: Joao Martins <joao.m.martins@oracle.com>
Message-ID: <e250feab-1873-c91d-5ea9-39ac6ef26458@oracle.com>
Date: Tue, 24 Aug 2021 15:09:22 +0100
In-Reply-To: <CAPcyv4jijqrb1O5OOTd5ftQ2Q-5SVwNRM7XMQ+N3MAFxEfvxpA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SG2PR0302CA0012.apcprd03.prod.outlook.com
 (2603:1096:3:2::22) To BLAPR10MB4835.namprd10.prod.outlook.com
 (2603:10b6:208:331::11)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.175.176.190] (138.3.204.62) by SG2PR0302CA0012.apcprd03.prod.outlook.com (2603:1096:3:2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 14:09:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7dd9538e-c48d-4a53-db4e-08d96708cea8
X-MS-TrafficTypeDiagnostic: BLAPR10MB4979:
X-Microsoft-Antispam-PRVS: 
	<BLAPR10MB497919D80235D5231AD1842EBBC59@BLAPR10MB4979.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	4ziJS8p5e+tZClSTeJ57EccvOHhH7IJaQJiQMU2qx+S3MHETWl29qcNp0U6j7z47Ga2k44ohPPk1PWrgTv7EzkR/JfpQElv7o6s5enZcxSrUQomH6B2ma9lF+7o+B0T33w4UqWuGf/A5gB9VH34ryHRoJ5bqUAyGCiYkW07dsHwlWFWEapfR8mzEEN1ciQRscni5qaNZpWxBD5oA3hlFXw+2vRQkNFL78z3sE1Atianzou2INGNafxcDEnhRDOutMAnTVwBEwv1uKvpJiLP45QPRSBpmWxk2NWQBRyjLAaey20ZpBylOtveL5GV/l2GSUrzVbpC1KiKnwoG1misyBeuCkhJ9f3ZXOnJbA49DtilhjKeW6d4dp3Qh7y4V+AW6cG7VmMLZ0RRFfv1QWmQVAvt9i3tlWTzPFxu/hYXGzCC7/m0vANlJ6TPJf1fGwlTS/sF6J7zr6E4zzMxmWJAWwA5uiTbGCG0COPvzLmlLdVC00Ov1FzkN19dL10cyIKa2eieUVHnCU9mnhT3GFFmJvLFtbDB/eC83nN21KYXwYmQ510mBNiqh0HPfNQwaeZswVkdBlTHmWdI2El67geQBB1TuQ0bJeUXQlgyjyL66NMunMAo59g1thCPVJnD9clpPzdx04zgCvtvnUq9fFmv4kQVunDLoEWy/oQbOn5aT72nKhrL2ga89vmAad+QHTjTar10FDI6KBGESd8stAze8TZrIMAQ0JUNPOTl//zYlsfu1BkL7ZVv/knfCjV3QounS8JRZ/0mR58CeBhZiNe64xKN84PghVeuR1+hQd+6CR3ILkJC+hhdxnUI3zaT7cP8c
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BLAPR10MB4835.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39860400002)(376002)(396003)(38100700002)(86362001)(31686004)(16576012)(54906003)(110136005)(478600001)(316002)(53546011)(31696002)(966005)(5660300002)(6666004)(4326008)(66476007)(66556008)(36756003)(8676002)(66946007)(26005)(186003)(956004)(83380400001)(8936002)(2616005)(2906002)(6486002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?R3Rsc0lJZVVRMWhmNUkrYWFFc3JpSmRVT0kwQ3plcVJuTEs0TjJMUTVNbzNX?=
 =?utf-8?B?TVVHQ2hKVlNPY0ZJRWpRcmlvelJKdTZPemxlWG96L0Qvd3RzdEhZQUFycW1k?=
 =?utf-8?B?TXB2ZjFyRlRvRHZnNDR4TkxXRGo5SEpuSTk1eUcvY3E4WmZiZFR5eUhtaDY5?=
 =?utf-8?B?cXh4VWtubGlGSm5aUERRaDlNbU5naGo1YStOOHNqeEhqWC9RL1dXbUFpOVJu?=
 =?utf-8?B?TksyNEdGSEplODZnNmZKTERMU0dMcjZMTTlubnJRZElEYk1TSnBQK2VjdjlU?=
 =?utf-8?B?VTZpUDhJVUhCN2czT2JvVFQ2THcySVptZHljSzRsUFYwRjlCZE5wc3V3YU90?=
 =?utf-8?B?VExpWnBJT3djM2FSbXdjbkkyUGN4Z0JVcXdqbnd6QW4rb0FmWDJrc1NLN1lI?=
 =?utf-8?B?cE5BeUZxZGtXcjRRdzBZWVhXWHB4aGI1UEFmczkrbnRhWHVWM2VZRUorT0xk?=
 =?utf-8?B?allVcGdOQllwWjVIV2tDcXhPMmlHNGRwMHo0b1pjR2s3VXlhOXdmdjdQZ2hw?=
 =?utf-8?B?c0QvQTRLN3lBZGhaZ1grRHFDVU0vYjJldU1acXF6VitwTVVxd3VHQU80Z2ZN?=
 =?utf-8?B?K2N5eWVGTHByMWJiRmZhV1FVK0FWODBGRzAvRVdIWExtUk1xRnJ0K3J4bU5C?=
 =?utf-8?B?V0VoN2xxdGorY1FXTlFOYzlHc2ZqYlcvM2p2VzJhNnNMR0xHRWRucUVIeHNB?=
 =?utf-8?B?Z09zVGdjSEhBT3FaREYyUEZVcUFXZXFmd2hjKzN6V29rRjV6SmVBWVpmNnhj?=
 =?utf-8?B?Wi9OUVhMcjJzNFQ0clRaSmprVUNjb3hTbTd3NnBpQ21zM3YrTncrMWUzV2Vi?=
 =?utf-8?B?VmtSZ0F0cld1SHZGNTgvWmZEK2l2SWE0SUdMNFRlMTJiQXVsTldTdWpjRTBX?=
 =?utf-8?B?bVNzMmZxRGtiU0pkS1dFMjBtYmlHVkgyUlZ4elltdFJwWlp3OHAzTWIwZmNl?=
 =?utf-8?B?WXpoV3U3YWVCejdYRXJCVklsRmt0VzlTWUU1bjF4d2VWRzFWb0RjazZkVGRu?=
 =?utf-8?B?SUt3TFBSd1ZNdm8vMHpGK1lOR3p0SGp1N2ZURHZnMURwWkZMQnB0M0tGMjFo?=
 =?utf-8?B?RVlUVFZQdkZDUHIvVkV2elMxNUUxa0E0RWFwdjY4MG9uM1pyNHg5L1pDQTlJ?=
 =?utf-8?B?WGQ4MXRPeUJvditVSkp5REZESVVGOVdHazE4MW1NSjNiaHZBK08zNk9OMVJX?=
 =?utf-8?B?SnBFTzUvQ2R2WEJrejhTMUNOdUhMK1dPTWdOcEovNkFXclpGbnc1aVU5dEQ1?=
 =?utf-8?B?VnZ4d2xtd0toNjdFVnZXL1hFVEZTN1JyLzZPN0lXSEs5bHNGSmFWUGV1bmNX?=
 =?utf-8?B?M2RIMWttL3lQd2w4WktLWkFzMThtS045NG9ac1BETWJvb3Y2WHduOWx6ckRh?=
 =?utf-8?B?amFTZXhGdXBWdzBDNE8wUnVYUkdHZnJvTThhbEllWE1BVEtBb0M4ZWkwdHdz?=
 =?utf-8?B?eDgwZFZTNXFUY3pxZXBHVzhGaElqT2Y0R2JZNWhaZW11VVJOOUp2SDluN3lI?=
 =?utf-8?B?Tk1zSmZCazZUbmpBMUNqYU1Za2N5VWtYTStuOHZTY0dUSWlXWmFxME9DVjQx?=
 =?utf-8?B?OTVsU01BR3lrNTY0VUk4T1VSSUVLcTZ0Y3JEN2hnRmcvaGNyZmdFSXJPbGox?=
 =?utf-8?B?S1hlQi93ZUE1dEZVYTdNd3g4Tkh4eGZtSkIvVUtLVlQzVXdEeFNPVllwV3ZE?=
 =?utf-8?B?Y0dOV0R1U21HOWdLZk1DVnh5MjZaanA1ME5WME5FdEtMejZIRnFhN3NzM0xh?=
 =?utf-8?Q?RzlaCXsvXLUhH552WaNeXiEcwyQOEQWQ/hzzNdt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7dd9538e-c48d-4a53-db4e-08d96708cea8
X-MS-Exchange-CrossTenant-AuthSource: BLAPR10MB4835.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 14:09:38.4124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1xxBtZcCHwJDy/Jbt81BxqO31mKmztZfByInMbSXsF42nl/S7yTvZwkN53i4HrpXdEREDEmx8922wW7RMgiHTfa1Oxyj1kUuXg4RTlbWSiw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4979
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240094
X-Proofpoint-GUID: avYNRuHKYbvC-vqmA8e65f0l3E31uudT
X-Proofpoint-ORIG-GUID: avYNRuHKYbvC-vqmA8e65f0l3E31uudT



On 8/23/21 9:21 PM, Dan Williams wrote:
> On Mon, Aug 23, 2021 at 12:47 PM Gerald Schaefer
> <gerald.schaefer@linux.ibm.com> wrote:
>>
>> On Mon, 23 Aug 2021 16:05:46 +0200
>> Gerald Schaefer <gerald.schaefer@linux.ibm.com> wrote:
>>
>>> On Fri, 20 Aug 2021 07:43:40 +0200
>>> Christoph Hellwig <hch@lst.de> wrote:
>>>
>>>> Hi all,
>>>>
>>>> looking at the recent ZONE_DEVICE related changes we still have a
>>>> horrible maze of different code paths.  I already suggested to
>>>> depend on ARCH_HAS_PTE_SPECIAL for ZONE_DEVICE there, which all modern
>>
>> Oh, we do have PTE_SPECIAL, actually that took away the last free bit
>> in the pte. So, if there is a chance that ZONE_DEVICE would depend
>> on PTE_SPECIAL instead of PTE_DEVMAP, we might be back in the game
>> and get rid of that CONFIG_FS_DAX_LIMITED.
> 
> So PTE_DEVMAP is primarily there to coordinate the
> get_user_pages_fast() path, and even there it's usage can be
> eliminated in favor of PTE_SPECIAL. I started that effort [1], but
> need to rebase on new notify_failure infrastructure coming from Ruan
> [2]. So I think you are not in the critical path until I can get the
> PTE_DEVMAP requirement out of your way.
> 

Isn't the implicit case that PTE_SPECIAL means that you
aren't supposed to get a struct page back? The gup path bails out on
pte_special() case. And in the fact in this thread that you quote:

> [1]: https://lore.kernel.org/r/161604050866.1463742.7759521510383551055.stgit@dwillia2-desk3.amr.corp.intel.com

(...) we were speaking about[1.1] using that same special bit to block
longterm gup for fs-dax (while allowing it device-dax which does support it).

[1.1] https://lore.kernel.org/nvdimm/a8c41028-c7f5-9b93-4721-b8ddcf2427da@oracle.com/

Or maybe that's what you mean for this particular case of FS_DAX_LIMITED. Most _special*()
cases in mm match _devmap*() as far I've experimented in the past with PMD/PUD and dax
(prior to [1.1]).

I am just wondering would you differentiate the case where you have metadata for the
!FS_DAX_LIMITED case in {gup,gup_fast} path in light of removing PTE_DEVMAP. I would have
thought of checking that a pgmap exists for the pfn (without grabbing a ref to it).

> 
> [2]: https://lore.kernel.org/r/20210730085245.3069812-1-ruansy.fnst@fujitsu.com
> 

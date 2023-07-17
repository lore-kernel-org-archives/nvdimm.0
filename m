Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2069.outbound.protection.outlook.com [40.107.244.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C7D3AD3C
	for <nvdimm@lists.linux.dev>; Mon, 17 Jul 2023 13:19:13 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKgUJnMUwW3nzSsfHVVVVbPGPXMF77HBk0BtYRWzX1u/kK41IVvMZWNWCjVKhn7i8Ff1as+kQgh+RDK+TbSSIUDhILMyJ5upRhHNql84R2eG09y10B8C5PVY9OHG57TcB+kp0+fPi3AOUZIAmhDCfQE9SwzR9Ib6lgAoB3Osji4X7AoTvuZnopqq0G+mcwHLYCUbfCshlKLd6N/X96mjgerANejhgFhnyAKjmgKBDo97k4uFgNuzAre6u7J0yrUexLzTqRLJy43HxUVsC/YDSmHqDSf7qfeFBA3gUMTTCha9WPyyPFTJYPs3CFMsf5cly8iFvqMCpr8bIqfHUA6nEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dW0TdxmGsiC/9D+CblSgmzLd8ZnfEs+wPjaFnS8T+60=;
 b=R69/Q8880468xYycqLOttMkFgc9AmMUBT0UnQagw75NBr6zfAh/dT6vXucCJ2/NgGcfSYpeIjvKPJ4+diKPcaHQ0/UJ/jsqkFx/EPhOuv4cxJ7sVC946NtEyl8dw54ff0D44BL/BmgRkEqLqc/rD2hgeNdL0pjiSPo6IbxJFePfB/aDCIRE16bvCiEJ1uXX5AaHVPzQtKnWELS9zj1MYUH82PsCdEC5SslkaHBzl1/bR7luquuFTcINkK+nx4tzLP5cfZp3N52YedH/3dIqyYl0CJ9iUDowiKryH+ZdKpIw+IemRVBvY4U4z1m1CzhKnYopw7os0gAnw0nqNpvsqrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dW0TdxmGsiC/9D+CblSgmzLd8ZnfEs+wPjaFnS8T+60=;
 b=wkdZWWkR9PqwuAd2IFIW2fHB9wXqZP5Fr+y9i0gLROHWoPNEoBVZg5IujXzgdARmka6oJQSo826vlZABzAKzWVB6XuEUEWfQ7nhG5UYV8Jc+H0HLl2sjgrUhjgKAuYRF2O1qB6Vx7Pk1AZw1niCTc3EfD80z+YoFJpCB4vo3M3A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6222.namprd12.prod.outlook.com (2603:10b6:208:3c2::19)
 by CH2PR12MB4327.namprd12.prod.outlook.com (2603:10b6:610:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.31; Mon, 17 Jul
 2023 13:18:58 +0000
Received: from MN0PR12MB6222.namprd12.prod.outlook.com
 ([fe80::eacc:48fe:f40f:f633]) by MN0PR12MB6222.namprd12.prod.outlook.com
 ([fe80::eacc:48fe:f40f:f633%6]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 13:18:58 +0000
Message-ID: <f9caa859-0f65-a658-d144-0332cd4f0833@amd.com>
Date: Mon, 17 Jul 2023 08:18:55 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [ndctl PATCH RESEND 1/2] cxl: Update a revision by CXL 3.0
 specification
To: Jehoon Park <jehoon.park@samsung.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Dan Williams <dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>,
 Jonathan Cameron <jonathan.cameron@huawei.com>,
 Kyungsan Kim <ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>
References: <20230717062908.8292-1-jehoon.park@samsung.com>
 <CGME20230717062624epcas2p2c5a14cb450b04ccc0ccd2292312d9636@epcas2p2.samsung.com>
 <20230717062908.8292-2-jehoon.park@samsung.com>
Content-Language: en-US
From: Nathan Fontenot <nafonten@amd.com>
In-Reply-To: <20230717062908.8292-2-jehoon.park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN6PR16CA0047.namprd16.prod.outlook.com
 (2603:10b6:805:ca::24) To MN0PR12MB6222.namprd12.prod.outlook.com
 (2603:10b6:208:3c2::19)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6222:EE_|CH2PR12MB4327:EE_
X-MS-Office365-Filtering-Correlation-Id: 72b4e251-5c29-4476-443f-08db86c8610e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	KYZfZZ31KYBfCyFT6tMiejAN1dfu15XSYIJT0cALEKJUwL+KBknZcDP+x/BWPrCQCIBJM2RwNRaD+CN9kXR+TNeS6K47loYjQzpoZpafRFZPDeXAI0FwgsLALMdP/tBVoflJm4E0LJOVHFekbf8/eIQU8qgBxXtAaCK4BhAAJzVytSOkglGE2AbSSLsyawoXEzTKfdKP+NOyJzrE0tFCH3x7CKonltoW4+FssXCofq1otrj1pEBgtP6XWZ6DGIHc+88dsjiDwCStXrmpTq+cUNTOuLjxQpiw/hbqZlD0TEyW9pQi1smQJ7geDlgLGB9Q8qXom79LsgMmUviV7VluEdFlbjvBCjHtDX67KwT1vfFMvlJkITuGBzp0tYslEErv93UPjwkvWD+/c2T1DFxNOttCVwSznfNrVb4fiVnmrOjGseM/aNgBaDt/wJTd2fWi/mQ+Z3mBGu3suCjJS8vWEZ8JsJxt4U8Zscc5SqK9b4V8897j2zoPyoKqZXT1kwro2VSrqUTjyToUKPJa6bSF/ToGHH+d+MSBPUh0WAB9q2TIOUjBgiey73EfVMvV3TN/pXNx5aXVT6IpOOTbz0r8IQu8Aa0jedxJLeYxG65p6ftD4GX/rv04Ncw3/+fPegChReP9snAxhoH+/NLgWShCJA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6222.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(451199021)(478600001)(6666004)(6486002)(54906003)(6506007)(186003)(53546011)(36756003)(26005)(2616005)(6512007)(316002)(2906002)(15650500001)(41300700001)(4326008)(66946007)(66476007)(5660300002)(7416002)(8936002)(8676002)(66556008)(38100700002)(31696002)(83380400001)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?djk5aER5K2pZR3ppREY1c25NLzhjL1ZKTWZodldELzZlbnRkakx5bTlLNGJi?=
 =?utf-8?B?NXJSOStOazYrL3B0b2krTndtVytHblVTNG5qVlNjbTlJT1c1VThPdXYvc3ZW?=
 =?utf-8?B?NDNITkRhYzYxNHV3L2tuOExJR0IrclQ5NzAralRqSGpsdWErRUt6Z29OT0ZB?=
 =?utf-8?B?dStNeFliWHBncGdxT29jTjU4YWpxY3hJR081b0p4ZWVJa1NjY0RhWTB6T09r?=
 =?utf-8?B?SFc1VExqUTdkUmZmU0RWLy9QMXV0dEVKdTZEVFJuMmRiTjN4bWM1N2EwWlYy?=
 =?utf-8?B?bFE1TGhmUEt0RnZuQnkybTNuRnBkTXlrc0xXMFdwaGUyalpXbDlNa0NCWTg4?=
 =?utf-8?B?NklId3FINzV5d2NTN0kwdTAvdWViR1dEYmdueExMd3U1enh6cU1lOTk0YVBy?=
 =?utf-8?B?RnJDNnhPWFJPSFBaZFVIZ0ZXaU44L2U4c0xML1Q5Q1o4QU1aMy83Tk5GUEZ5?=
 =?utf-8?B?V1hsZ2UzaURDSTEzRG1Hb3IydWFNOHZKRG1KVTdlUkJVTkpwVGtlSGNMR014?=
 =?utf-8?B?c1hKMkRhS2xBcUppRE9kRk1qSkJoT3lKWWNqY3dJZklxb2Q5ZzVKaXVUM3Ns?=
 =?utf-8?B?aTF0SjlEamNEbFRNQVdEWVZQdllVcEp3NUVHWmtoMFo1bGhqVisrUXN5WVpq?=
 =?utf-8?B?VTVKdjlLSkdpUDFRSmxENy9hY29Rc2xFZENSNzVyQ3g0YnpzbjFIZ3RadVRi?=
 =?utf-8?B?UG5TZlFzS0JlTTZPQ1R0cHFFTmw2OFFXVW4rUDgxK2o4SXp0a3dCUWpndGZr?=
 =?utf-8?B?RTJqc0JQbHVFTjRjQXBQVXY2SEp3bkNaa3N0eTNmWUR5Y2dwZjhzUG5uYVly?=
 =?utf-8?B?UGV0VWpvWlJvMkJ1TDBGYmhSSUE1R2p2cVVNdVVvd0RDOTZKeUFJYVQyNlNN?=
 =?utf-8?B?UjNSaWNyOS9XQ3M1Wk5pK2MzSGZWQ1R1bVJybTNIOW1udTFWbi9NcVUwWVNR?=
 =?utf-8?B?Qy9raUV5YzFyM0QxMjdGWGlPbmpDM0JjYTg2ZCtrYzRPM1dOM3lMeXV3SU1N?=
 =?utf-8?B?Y1ZWcGlub0hIVS9XbFRSaW94TFBTTDhwVjBhbXJBVm4zVjRmdGhnazljT3ZW?=
 =?utf-8?B?RHRvR3kybzQ0cHdqY2VtM0JtbUVGNlR2dFBTWnRneDhrdXd6OVE2WjBVaHMy?=
 =?utf-8?B?V05IeU9tN3hMaFYzRkxEQmdEYi9FOUQvUmJLM2RoeWt4RytMRU9GcEk5UElP?=
 =?utf-8?B?NFBRdTMremlqYXJ0cTUySFNrSmhXV3VndFdKUHN2V3dXVnhFRUJqSzVWV2c3?=
 =?utf-8?B?S0M2Y3JDcERuek94Y01pYWVPNVZDd2xiN0RGaDRPaDYxaWl3K3EwYWlpM29y?=
 =?utf-8?B?cTZ2WHRZK3hVZGJRUGVlQ2dkcW5KaFVVY0phazJRWDg5c05lWkI5UVgxcnlp?=
 =?utf-8?B?L2tXK0JMeWg1dWYvTEpzRFlFcjZMZFNWbWpTMFpHMHRRWDNNZE1udVQwcWRZ?=
 =?utf-8?B?MDBrWXpVcmVibStoenFWSDFXM28rRWQva09HeForSlRGK3hobGxDb1hLOGwy?=
 =?utf-8?B?Y0tEcHFnTXZvSE5EdDhKUXhhRmJ6ck13enI2ek1xT2pselpIUVpWM2x6L3Iv?=
 =?utf-8?B?ODNFNGdlNzhrZ2JPMDVFUkxHYmFWRjBHdGlQbXg5cU9TbVdQRHhaNDJQUVBs?=
 =?utf-8?B?TVVob2t1SzhvUEJkbTFVQWpzSUFIRlh2ZXZFd25OMXBvQlNQVkN4TXFsdkhZ?=
 =?utf-8?B?Z0QxOUE0bnZ0OWw2U295azR5UjdpblU0cUJPT2h2NUlRWnJha1E3WENROGhj?=
 =?utf-8?B?NGNRSURLblZkWmhmRE02SGpJVUJaMmg3K1llbkFxTHdhaElNeWdzeDlMODM2?=
 =?utf-8?B?NStRaGhHajRhRnEvT3ozRkpNbUJLRlZvd2lMMzRVTnE2c3RmZWNpRTJGc2RB?=
 =?utf-8?B?ak9oQkZ5V2lxWjJwM1cxU0UwMUFuaDcrUWJLWEdONXhJaG5lU05veHlrYmpR?=
 =?utf-8?B?SUIwc2EzMnIzUmhrOENZZVZOeXdkTEVINWxjUWJNaStrQzdPNDFUOWh1MlZh?=
 =?utf-8?B?NzNnbEtSRzBybDE5RWxadmVBZ0NyVjNPY1lQYkRydFBmYUNiOWFsRW40MFBq?=
 =?utf-8?B?blRCOW1WTTJDUWI3ZkZ4SmRSSFQ4OWEzb2pSOVlHNU52WkwyUDE4aEN4dEhs?=
 =?utf-8?Q?AUWR8NGjtWzL/3/Pxv5Ax5t9F?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72b4e251-5c29-4476-443f-08db86c8610e
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6222.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 13:18:58.5474
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: M5ybxBYUy/fSS4CXoQQQ7EJfBUUBtAWS7P8wjGGtaBm4vj/VU1iZEyi7W1m8E/uztVz3YGrJnPWu9kmOsBaLjw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4327

On 7/17/23 01:29, Jehoon Park wrote:
> Update the value of device temperature field when it is not implemented.
> (CXL 3.0 8.2.9.8.3.1)
> 
> Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
> ---
>  cxl/json.c        | 2 +-
>  cxl/lib/private.h | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 9a4b5c7..3661eb9 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -155,7 +155,7 @@ static struct json_object *util_cxl_memdev_health_to_json(
>  	}
>  
>  	field = cxl_cmd_health_info_get_temperature(cmd);
> -	if (field != 0xffff) {
> +	if (field != 0x7fff) {

Should you also update this field check to use CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL
instead of using 0x7fff directly?

-Nathan

>  		jobj = json_object_new_int(field);
>  		if (jobj)
>  			json_object_object_add(jhealth, "temperature", jobj);
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index d49b560..e92592d 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -324,7 +324,7 @@ struct cxl_cmd_set_partition {
>  #define CXL_CMD_HEALTH_INFO_EXT_CORRECTED_PERSISTENT_WARNING		(1)
>  
>  #define CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL				0xff
> -#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0xffff
> +#define CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL			0x7fff
>  
>  static inline int check_kmod(struct kmod_ctx *kmod_ctx)
>  {

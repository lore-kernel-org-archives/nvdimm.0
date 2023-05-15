Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31ABD2E4
	for <nvdimm@lists.linux.dev>; Mon, 15 May 2023 19:54:17 +0000 (UTC)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 34FJrwRP019160;
	Mon, 15 May 2023 19:54:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=MF/gFnZ9aA5rPpM8CNOBlBtJFGJvXkvIFpzDgJnb4U0=;
 b=SqkBQen6fwIUpEFm0L1jDixd/sPOM8tQ+135YXYvPUUPsJ+VmZbCPw3Ug5FzaarFtHLG
 Ki3DcjFT+EigF6XW9kMU3hunL0vdLET+MV1/DSV+xNKuL3VRvgWDXmh4u60GpuwZ8BIN
 sCBt7UnNhiy7CXFDog71vSrSPQfFHjLEpHkJqVt9DtdBTXH3q3epeVsPhuzUmDglLs4z
 Qp3NQYnvAX/Nctv8wivzUjfWTu5qMyU5nQrodSA/rDDFlpQ4oWZSnpq6KmbhY6Lvaesh
 C8Ra9KGa2v0EoXZ62AG/1FcIZDgcwe80cXz4cbgg5+QI/7F7+uBHvSRc0AloIF++hKIt 8w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3qj25u0yfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 May 2023 19:54:14 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 34FIZmAc023014;
	Mon, 15 May 2023 19:54:13 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3qj102vv8m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 15 May 2023 19:54:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nFNFyXththXc94YNX2l/deu5QRVzoRii5sYtBhJXJ4lRl7EMaiCyPGm3KW1Qqn+bOg2hMS28hRjaQoAA8kEA97vLWYmD7Okf2tr7HunfnjZOfUov4lNx2frf+SEVqVLFCNqhDbSWwMqxagJO6NRszTTTyk5cJxw4DVNvqSYH9J3A6jljt8QYpNtcQKy72l4unVAdobhwVb+Rm44aQKN5khNyJIzd3Qn3yVhZicjBrLJs3l3d7OAW7nHgzR/FnpKEgxvo8p8Zviw/RJA7K8tyy3Yesb4kwAbeIUCaTBdlBYHPhkBEwK2QO7I1AII2nnpseascfMhAsmtoXAbHaa/gVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MF/gFnZ9aA5rPpM8CNOBlBtJFGJvXkvIFpzDgJnb4U0=;
 b=oL+U0SX3DD8IQRoQG/FUpji31XtK4wK2Ze+5EEAsdCEXDXMZVcqrcCFYqjPBje0ul4Vdzr/98FNMwMEfaAhum80EC4lcqurDO2M/fAfNPqsG1Wgo0YdwqgNzFVHD814z2SSD+LQ6E4WGuBlSDED+8QidxY6kWWB3DScJuFtGzYH4vnePYXSasVOo10kn99nGQq4AlRdT+1dnDwRsHabMejwbtdYU4xl40DtJQAEIZuc1fJ44x8+mFViCaL/d9OBv9SOpCOisnyOSGXKNFWjEdR+EbA90L/egH5nWJbyVwgISEb8xCZdYQ5iq4AhycR3etAp4WsAHHbqta41EhDsR6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MF/gFnZ9aA5rPpM8CNOBlBtJFGJvXkvIFpzDgJnb4U0=;
 b=j4iCM0G3oFNqeQJXuPMKcV8k2JXf8IxAvMdTkK0bo0IJUayRjfhk5mKHwE6vto7TtDTumYHYLGvFyHg9ynN4o4y/OEhwa41jY01oHjTYTbVWpe8PnG9mXJQiO91k5LTxapw63baScg8LTRCalE2rSXPvqJ6J2o4C5Hbqpk0OJ+0=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by IA0PR10MB6747.namprd10.prod.outlook.com (2603:10b6:208:43d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 19:54:11 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::256d:125b:8053:eeb9]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::256d:125b:8053:eeb9%3]) with mapi id 15.20.6387.030; Mon, 15 May 2023
 19:54:11 +0000
Message-ID: <7d36645c-892d-33b1-18d9-73be5369a791@oracle.com>
Date: Mon, 15 May 2023 12:54:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 1/1] pmem: allow user to set QUEUE_FLAG_NOWAIT
Content-Language: en-US
To: Chaitanya Kulkarni <kch@nvidia.com>, dan.j.williams@intel.com,
        vishal.l.verma@intel.com, dave.jiang@intel.com, ira.weiny@intel.com
Cc: nvdimm@lists.linux.dev
References: <20230512104302.8527-1-kch@nvidia.com>
 <20230512104302.8527-2-kch@nvidia.com>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <20230512104302.8527-2-kch@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0103.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::44) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|IA0PR10MB6747:EE_
X-MS-Office365-Filtering-Correlation-Id: 6744a86c-7bff-4a44-eaf5-08db557e270a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	+sSF9wGxJl64R54ExqjA8bqVIbm05SwevE4HxeqC8DzveG5L9Ks37xqk7aT/lXjRuEe4uvFeddD7qT3kfCcaN30QQgrF4w7cH/pdKW8wpgBuZu2GBFHgFc2LCa9NOLQRAVCNd65+AAl98O8F9AikJqKTwzv5UnX5B0aLQx9dQcbQu+umtTeCNGeMlK7nhRn6PMhTc7J7UnErcDmM1p5BDSIi0RE490Y/BOFrv6YwUs/hsVMdgx6MY7UjNmGAs7z1Bgy9x3m1/fBdzZAKncWRP9Vhmp17x0vsbAcIhPZ+dQfdkWCXBRxBal034zHLcD2sXRRy1Vv5T0xWcbExRq9sB6BBgPlVGpdWW0pzAidvGIhwhdHf57uQrwQIErYPzCW+s2lQN1azZTjvYCujuqFYR+ZBbAcFuza2sZUKm1oYC9I2gsorMxcFZuoG7kdogiGBCTDLSe7IlcEpyUK4w6o0R9bzilJovDKm0OdjIrhi2bpzwArKxW/Yli1ycfQSMxwfUlYBqf30zNBYKa8KVPPIgRmFU/hPBmCGCtZPKkmhZagaAujCzhxDFvkD+0ikEEAXU+cO+tsgSZg+0Mn46nS0t/S49xc2LkL/hgekH7TmuTbAxsOi15aSfCMz4Z56Y0N9gx80vyf/YpNO2P16+zGZpw==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(366004)(346002)(376002)(39860400002)(396003)(451199021)(66556008)(66946007)(66476007)(41300700001)(31686004)(4326008)(6512007)(26005)(6506007)(6486002)(38100700002)(316002)(2616005)(44832011)(5660300002)(8936002)(8676002)(83380400001)(2906002)(478600001)(86362001)(31696002)(186003)(53546011)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?dnE5VnYrMWh1c0lwYlZybjBjQWJZRGtudEU3b3d1SVMrSXVUdHk3aFBKbU9o?=
 =?utf-8?B?VXc5bktFelV0amozM1pmVVc0TkRsUzFLUFJZWkptd3V5ZytuOVo2TlhIcEVD?=
 =?utf-8?B?UUlCc0FSZ3hHNGVrSUwwS2ErczNydUIwRW9YcThGbkRTUWVONkNIR1UxZmZ2?=
 =?utf-8?B?UUE1ZGZhZkQ5YmJ2MFZ4dk5wcjNCbEc1TVZwQ1RPKzE0U05NQU5KKzd6a3RC?=
 =?utf-8?B?SklRQXE1SjZJWFpqT0dqODY0UjVvRXFtSkVqYXlFSzlvcUpHZnZuZ0wxNk5x?=
 =?utf-8?B?NjRzUWZBc09aV0UxNDNqdTUrUGpPbmYzRFRMYldVSHI3bjgyNVBMZXpNaW1s?=
 =?utf-8?B?NjMwTFZoWngyaVp3Z0ZTQll0YnI2aVhTTERrZ2o0OHdqaXZNQjMvR3BCWDYy?=
 =?utf-8?B?QkFxcFI4cUZmWXhkQzVCb292K2V6SWR1N29UVFlhZG1RZWtPQ2pEbHdBc3gv?=
 =?utf-8?B?ZmlwcFBwaXdvbDFhNjl0eUlXczNDOXIvNjN6LzJCajZGTFRIaFJtWHlOblNz?=
 =?utf-8?B?cFZMRUFFaUIzdzdtd3FITzM3enF6b2VUQzlKTEI3T3UzYUVjWXBlTk1yT1pS?=
 =?utf-8?B?MHZCUGhwMENwT1VzNW8vODdWVUREZllJZjhXNWNXcmpsbU5ma3FBYmhhaHVF?=
 =?utf-8?B?TFZheVFZZDRlK2EvSmw0UFRyQ1IzY1pjVUdGcGhsajlCc1l2ajVPSU5HcjBr?=
 =?utf-8?B?OEtkV1N4aUVrMWRROFc2eGRFbm81MkVoR0lvNEhVMUtRMXlOQ0VwUXFYL0hT?=
 =?utf-8?B?R0xEQm9GNjhNTGVtMmgzcGRhWlJEbEZkSmZHTzlXVzNycUFWbGx3WkVmb01u?=
 =?utf-8?B?M29MYmNLU1JxOXdUN3daekZRL3NaRlMyMUJjYWZsOFhMUW5QK090Tm85dnE3?=
 =?utf-8?B?MENvazBiOHpLMmtQNGtVM2psVUdySThDU1Q5cFduQUlISGpJSkZNL1g0R3Nu?=
 =?utf-8?B?Y2kwVmpCK3R2dFpReVAycnpsKzMvSkNPa3pmT1BtSXlpTHoxR2tBQ2tMUDYx?=
 =?utf-8?B?TVBCbkFYN2tWeFBQdEg5OS9nWDV1YUFVS0NmendjQ3FrMTlVcjNtemtFMjJi?=
 =?utf-8?B?eDdYdEVPRzVBdTMvSmRhUS92MVBSSjBObjJ1aU1NdG1ZaktGOVFqRDVjVGhD?=
 =?utf-8?B?WUtNMXVqelBBV3NYUVZwYXZQV29GUzgzL2R4dDVoL1dMYzNHWDRFaUlHcEVq?=
 =?utf-8?B?alNFOEc5OE5xb2twTzJ3aW9kendzdFhKdklqOTBmZW5ubHJlcUxTYThDL1Za?=
 =?utf-8?B?RTBGdFhxMzVYR1AxeWpDdGRMT1NIM3cwZ1RJZ1hFSkdGZmQ2eG1JSjFsdWVW?=
 =?utf-8?B?WVVqUG1HTDc1N3pYRjUvM3JRNytURXhhTXVFdjNnREpjNXR5SHlTY1YrQnlP?=
 =?utf-8?B?RG8yZmhBWlY3a0NtR2lXVUJuaWkveFFWeElaRWIvS0I3SHpRVUhvK21aS2s4?=
 =?utf-8?B?RmJ3NTdNbTFDUmhFTkp2Um0va01SWkxMdEVWSC9Sbkh1aTZPSDdteXU2UFEr?=
 =?utf-8?B?T0NROUdnMTNDLzRnSVJrTUJiaFZhMUJndll3dzVlYzB2MUxwc2xHY2NUL1pF?=
 =?utf-8?B?ZnYzcFU3ZWJlcHRCU3BEbzAwc292VVU1NmNPdVpQRDljR1NnTTdZaG53VlJs?=
 =?utf-8?B?Qy9xVGJqL1JCNkNjYTU4UlZCU3VxNTI2clRDVzFsem5hWHdsNFc5NmpWMzlV?=
 =?utf-8?B?TUEwWlFlNnR6dUZqWkxwZUJIYi81bEMzM1M0K1Mvc3NrOGNSQ09xN0M2QW4r?=
 =?utf-8?B?Mlg2d3F2bEY4alhXRHpWMm1GRnVtSFZabW1GMjZLNEVtcDM5K0RyaUJ5clRj?=
 =?utf-8?B?WUEwbmNsQ3lINnRSZU9la25oeHppd2RBWDhwN3ljdlMzdnllRmllbjlCUzFx?=
 =?utf-8?B?cmQvUnlEUmZFWUV3S1RuR3VVdDltSmlBeHFlcEQzUTFFV0hsYXhkTE1ZdEtU?=
 =?utf-8?B?bzVaamE0b0tnS2RnQ0R0YitVRTBmbGNGcjFDUlllaGRwM215UGplV1o5OVVP?=
 =?utf-8?B?OU1lUkNSeGxMbStKZDlqaXpvaExYdVhmWHZrdDZLdXRObThyNDQzMlJIRHoz?=
 =?utf-8?B?YU42UlNKVVRDVnRManpMSkRZRW1HN29ETTFUVVhmWE53TDdoNVd0V0orcFUw?=
 =?utf-8?Q?UD+mNOrdofd8APWINvM39Qzs8?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	hPRuJzin7QqtOO3aFW+k72jM3qL4zEYXDtHZhHMZaySZ0pBBGeBbgrch+rQFfv2x/YJO9fd6t5qrtP36JIGfH7PoTvWcwpE0MhzkqrCd9Qa90qmkL5Z/7ZA6WvJ/q07bwuHDmtJcS4wbmhUtCgyGySG2xd0LZhdmDFJJEzsjgQvyfIwqglVRgBnvQ5ilF/tcjaLT1SM95HmCbkg4VLwBvbp4BbNnhWtKR1BwOG8UrErpXqr6glU7FcOWj7S0NcoVBZNJNmvd8wA9RYTnfJmWSDy5DZ5ZMejAHK30VZxArJbDgcRypPaFfOazdGip+6cCtfJBGJjsbKcEgWfyufngrbvPwk0xtfon7DTY/9zAAIlAGusaMG2N/m0zojlz2b/VJ5pVwUqy24ptR+RpyjzJVch0XTZfhhYsTlMzRrcv03PCQ//5qe+LCb6YbLDehPP3RtJPFdktiW9arKZbmRk7ZHn667cB+faK0Zf/Iq0LgP0TbNf64S8Tnd6Tg/RX69mkA9NcQTCfcUEVGhN+G3X1wNp9a8+ou47+wKSdky5+nv1qEBLYsbcDAw6cQXE7U+I/GbL5BZ8+pH/cLYAFJH2YOj9Wa0YXpF0J64lNSVOCwRZ+/0uHi6ZgIT38BSPL2UMrIsYfmhMPD8K1SBk91YUK1AP5SBxF4jNZ+De+GPK0uYr3tp/EynuK1j1AR0w67CY83DhRr/7ucW0I5w4oPQsHhAHcDaEEJWy1Oi8oGMpnch7JPSrdUe3sQMg6TKN193rK/JNyX2hqhpOMwV4xInO3yYBYcYnUKMSpiNjxj/7XkC2RBJuG1Y4mU64yVXcDmQNI
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6744a86c-7bff-4a44-eaf5-08db557e270a
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2023 19:54:11.4809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1N8X5jsiUXIKcRUj/ybufq8PBfUwwlPcO6ePe9DegcitPAzANc17DKDYlbhb0hvbMYtSWgI2+e6oCaBllp4Pxg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6747
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-05-15_18,2023-05-05_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2304280000
 definitions=main-2305150164
X-Proofpoint-ORIG-GUID: 092zkHgb-R8udn9gUFxqW35Be-eqs8hs
X-Proofpoint-GUID: 092zkHgb-R8udn9gUFxqW35Be-eqs8hs

Hi,

Does it make sense to mark this patch a candidate for stable branch?

thanks!
-jane

On 5/12/2023 3:43 AM, Chaitanya Kulkarni wrote:
> Allow user to set the QUEUE_FLAG_NOWAIT optionally using module
> parameter to retain the default behaviour. Also, update respective
> allocation flags in the write path. Following are the performance
> numbers with io_uring fio engine for random read, note that device has
> been populated fully with randwrite workload before taking these
> numbers :-
> 
> * linux-block (for-next) # grep IOPS  pmem*fio | column -t
> 
> nowait-off-1.fio:  read:  IOPS=3968k,  BW=15.1GiB/s
> nowait-off-2.fio:  read:  IOPS=4084k,  BW=15.6GiB/s
> nowait-off-3.fio:  read:  IOPS=3995k,  BW=15.2GiB/s
> 
> nowait-on-1.fio:   read:  IOPS=5909k,  BW=22.5GiB/s
> nowait-on-2.fio:   read:  IOPS=5997k,  BW=22.9GiB/s
> nowait-on-3.fio:   read:  IOPS=6006k,  BW=22.9GiB/s
> 
> * linux-block (for-next) # grep cpu  pmem*fio | column -t
> 
> nowait-off-1.fio:  cpu  :  usr=6.38%,   sys=31.37%,  ctx=220427659
> nowait-off-2.fio:  cpu  :  usr=6.19%,   sys=31.45%,  ctx=229825635
> nowait-off-3.fio:  cpu  :  usr=6.17%,   sys=31.22%,  ctx=221896158
> 
> nowait-on-1.fio:  cpu  :  usr=10.56%,  sys=87.82%,  ctx=24730
> nowait-on-2.fio:  cpu  :  usr=9.92%,   sys=88.36%,  ctx=23427
> nowait-on-3.fio:  cpu  :  usr=9.85%,   sys=89.04%,  ctx=23237
> 
> * linux-block (for-next) # grep slat  pmem*fio | column -t
> nowait-off-1.fio:  slat  (nsec):  min=431,   max=50423k,  avg=9424.06
> nowait-off-2.fio:  slat  (nsec):  min=420,   max=35992k,  avg=9193.94
> nowait-off-3.fio:  slat  (nsec):  min=430,   max=40737k,  avg=9244.24
> 
> nowait-on-1.fio:   slat  (nsec):  min=1232,  max=40098k,  avg=7518.60
> nowait-on-2.fio:   slat  (nsec):  min=1303,  max=52107k,  avg=7423.37
> nowait-on-3.fio:   slat  (nsec):  min=1123,  max=40193k,  avg=7409.08
> 
> Signed-off-by: Chaitanya Kulkarni <kch@nvidia.com>
> ---
>   drivers/nvdimm/pmem.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index ceea55f621cc..38defe84de4c 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -31,6 +31,10 @@
>   #include "pfn.h"
>   #include "nd.h"
>   
> +static bool g_nowait;
> +module_param_named(nowait, g_nowait, bool, 0444);
> +MODULE_PARM_DESC(nowait, "set QUEUE_FLAG_NOWAIT. Default: False");
> +
>   static struct device *to_dev(struct pmem_device *pmem)
>   {
>   	/*
> @@ -543,6 +547,8 @@ static int pmem_attach_disk(struct device *dev,
>   	blk_queue_max_hw_sectors(q, UINT_MAX);
>   	blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
>   	blk_queue_flag_set(QUEUE_FLAG_SYNCHRONOUS, q);
> +	if (g_nowait)
> +		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
>   	if (pmem->pfn_flags & PFN_MAP)
>   		blk_queue_flag_set(QUEUE_FLAG_DAX, q);
>   

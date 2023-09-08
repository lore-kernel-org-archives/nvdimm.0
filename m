Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4244B30F90
	for <nvdimm@lists.linux.dev>; Fri,  8 Sep 2023 21:57:01 +0000 (UTC)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 388Lfq3t014319;
	Fri, 8 Sep 2023 21:56:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=rorG8ykDRxpj+XX1Jdrtz8aV2qkLtHX+MdgUlLm9JoM=;
 b=B+cU5jGeO8lD2AgzSJ/gD9EjFQWZ60c8iWlVAWEzXipaO1E2VeXnnHWSgetj8KX80myK
 A6LVyeOsrANFqXeZJZzyN9IWHo/bGYpPbez+EQduFlOJ3nyA90BU68w+241MxenTHAmu
 vnoLkK3XrjNvgSiuiruT/z1uQCpit0ElygBxBEYcJykjI07FHEYZyrZLre7FTJ8RRLMt
 4PEyKCxKWGhwii7G46mlaLEXSo9dN6eAfxg9HrP0RZ9BbGNCRW+NRwYcpzAGoGYbtWY8
 xzHxFhfbSdiYZHjR85e9XxsbnP97xIaFOMjeyBZBZkUTmH1EMgH8fHGknUMn9n/msMKH Mw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t0bqm00v3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Sep 2023 21:56:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 388JqJi0016770;
	Fri, 8 Sep 2023 21:56:31 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3suugfy4h0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 08 Sep 2023 21:56:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2vhfoLR3A8LSC7UlPAkAGyy7DwMOlN/mTOIPjQpLJ6Z6UxWnjoQd9um2ZniYrkQXkhkZcxs4VhEzfM85HZjl33JZxxDbao4nSt39S4T+B8FNn46k2hXKpQy9C4W7At01e/3p2ldh2hNJERgDBl7WqWe5XXMVfdd+cqglJginKi1QBwxUbNqiD5qO9qkDR9UxQxTYy1/QHNzwMh0YnK7Z1fZupj0NVwLBG5aeX5f1vWYjIayG9HDzr+htRhP/DKl9VhZeDlV8lr1vx87QIIZCqNAiHotNLpr65jaQz6iwMnrOdckLn7NPSpkrQkiKmwMOLh9T3DtYmE406ZyknzsKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rorG8ykDRxpj+XX1Jdrtz8aV2qkLtHX+MdgUlLm9JoM=;
 b=Nd5cKCiFfh+d4Z60LDO08EorU6DsJ38diFH9fCyMudyOSWMNyrZd3XsGxDF5353Xm8jyYw9+TqVe0Og+JDpJIJyxkxSsvuG5rs6I2DZbFnjteRe7k4Fl9fPKT6LkqZaktG+oJX9GuSBp3LIacllCy+2NwFM7ha7/eZjGsYTgyf5fM1ZeO+99pCsqiVatfiZiVKTH/bDwdSGIUXPKHJbDfISMO6B0Mz3UwP5ZftfcyAp/fsaBVUi9xBAzk3w6V3C0ipLuOxbkbRzTvfSl2z7XW4pfjB+jkpzHH8qGEnk3enzsSlDwrIxd70mvjve/5E0Ux8AWub90t+VMPJ6Uh4+ZZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rorG8ykDRxpj+XX1Jdrtz8aV2qkLtHX+MdgUlLm9JoM=;
 b=EyfgGbdqRJdV9VBnvY4pIEdjaJw/IWW9ANYgpoeMWXbJeNDb3COw3kSdNJt305RE0Ci3Ii9j/57Fvso44dbdzbM6fAcf4ruzCEon6CYIW4jz951okGZVb4PGrttmY1VGqIi+SB+JGntiy5JJA+WEnzFnZXA80JBrDEXm3Hnkah0=
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com (2603:10b6:a03:2d1::14)
 by PH7PR10MB6604.namprd10.prod.outlook.com (2603:10b6:510:208::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.36; Fri, 8 Sep
 2023 21:56:29 +0000
Received: from SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::466a:552b:a12c:6d53]) by SJ0PR10MB4429.namprd10.prod.outlook.com
 ([fe80::466a:552b:a12c:6d53%6]) with mapi id 15.20.6768.029; Fri, 8 Sep 2023
 21:56:29 +0000
Message-ID: <3336c9ef-eaf2-a66a-c50d-80746a901393@oracle.com>
Date: Fri, 8 Sep 2023 14:56:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2] mm: Convert DAX lock/unlock page to lock/unlock folio
Content-Language: en-US
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, nvdimm@lists.linux.dev,
        dan.j.williams@intel.com, naoya.horiguchi@nec.com, linux-mm@kvack.org
References: <20230908195215.176586-1-jane.chu@oracle.com>
 <ZPuNPKz4fMfvTe//@casper.infradead.org>
From: Jane Chu <jane.chu@oracle.com>
In-Reply-To: <ZPuNPKz4fMfvTe//@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR07CA0097.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::38) To SJ0PR10MB4429.namprd10.prod.outlook.com
 (2603:10b6:a03:2d1::14)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4429:EE_|PH7PR10MB6604:EE_
X-MS-Office365-Filtering-Correlation-Id: a6ae43b9-5c47-4832-ff77-08dbb0b674f5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	pVThN+Y2qbu+91pEW7Kn5Sa4QNm6U9jxsI1WsQW3C5GltgJxU1GIYWFg0ZAGFczEx5H3OvHUnU8UF1/3Bxkf+IKrbcmdTIzAlhZ06XKWH3jyuZJB1XCg6uFT10t2nRSMPrbp0fyYjkdVR28N1ADcQpxNpHl8MPvTzCXLmaW56eKCh5nd3EajWeqPlrOWs3ChGnIajQvP0FCMwa2jXnuTfYSHUi8G/ysCz9lQ7NJl4G8r9XCSEet+Q3e6HX2TkM0eXTm7722brqqGn6/InHbuHHX54GpJJZoLNYXu1dN/Z4tLZF5sxynRrt8P078mKXeuOgF/IqQSil0in3nxVA2GrpHM1wQr6DanoDo7t1k2oDC+lwZ/8ybIa4zqKXUzpmU7OcVgpxFpurG6Nm9O9lELN4BP9tTGM7egYW3c5JnCRzpR/FyjvUv8YNmp14zugc7yZFZIChGEu3u7I4t7f3O0GUXlgrvItavXi8s3ZrMKcajXPP/2KC/QF2zYhb4/Lixiz1fKZfZ4h2miHc6LTzUOtZrQZkYhtPocliaBoGbs4bAlE4o8/ntxuVH40ZEJvbKgIgF8bZYj623cUMXtA3sASPe56FeBGqDJoQXqeiuUK+kt3e2rkv1aDLqvxhuKH6T528z4YWr4/Jtuuiwil84fmA==
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4429.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(366004)(346002)(396003)(136003)(376002)(186009)(451199024)(1800799009)(66899024)(38100700002)(36756003)(86362001)(31696002)(2906002)(6512007)(53546011)(6486002)(8936002)(6506007)(8676002)(4326008)(44832011)(5660300002)(66556008)(316002)(66946007)(41300700001)(6916009)(66476007)(31686004)(83380400001)(478600001)(26005)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?utf-8?B?UDlhMEJ3THJyTnBwZ2tGZkRITjRTKyt4d2ovT1JEcDkxNzZORTFad080dEJI?=
 =?utf-8?B?VjBaaVRGTHBDdmhNMksxbkZ1eE1EZEV0ODhWdUF1bWh6QUdvd1JxcUhNZjB4?=
 =?utf-8?B?K0pRNXg1L0dSYjVHajRNWDJ4bzFPbXZPRWV4RHIveGZ1R0F0b3ByN3FrMjk1?=
 =?utf-8?B?YlJaTkpOQklOZCtWemZ0NVRkeVZuRmNOTnk5eVFUaFg1b3B4STAzOVR2QUVk?=
 =?utf-8?B?TFloNFFUOWUzbkh2WXFrbHhyOHAwT1dMMzlwKzByMlFyUWpaNlV2TjZEdysz?=
 =?utf-8?B?azVmV1draWNURlVtT1RiNVdnMUp1eTcwbFZzY1hVUmdQS2J1M3JRdTBUWDFx?=
 =?utf-8?B?YUhPKzMxYStSQlBETVRkeW5EazBVd2ltVmljdmZVcVZXL2NJb00vQTRNNFNQ?=
 =?utf-8?B?N2hMYlU1RjUwd3orZ1NuK21memVlajBsTVhSai91eHVkN0VwZVdIc2VvUDdI?=
 =?utf-8?B?Y1p5c00xN3BqcWdrVUFYVWZJWGg1dTFWd0dBb3E5aFVkWTBQc3RwVzMvQmNy?=
 =?utf-8?B?eTJidkhrRkZYeXhQdkFkUHdZSVArNVF5enJQMk94N0h6Si9valpYSXZFVXlO?=
 =?utf-8?B?b1cwK3dNQXFuWVVNb2ZoTlUxcW5JN3NoWVYrcXdGSGNCdmRRd1NSa2dKTHQz?=
 =?utf-8?B?OGNCcmZBdnZPQ2gyaDc3OEoxYkhaSjdNZ3NVSTZPc2cyMmFOOU5HVzJrS2Fx?=
 =?utf-8?B?WldwZmwvTm1LWDNEdElFYUo1RHdxSjZDelpvNUk2QWtkeDNMc2VDdm00QTh1?=
 =?utf-8?B?ZGJkU0RlclNJWTZtbG9KQU02Y0I1Nlo0eitBMmlBaHpuSTBQZFdmdUVXelpr?=
 =?utf-8?B?dmc1SU1abUxqdWg2aEdQSUl0WDYrYmJ1ays2OGVUSy9qM2YxUjBVcm9rWVh5?=
 =?utf-8?B?UTRxei8rV1hiVTB1b1RQcFhDWmNxUkZKVU1OSTBIS0N0VHZLNlFJUWRsZGhn?=
 =?utf-8?B?Q2tpVXgrQnN3UEdrS3BHelhpNjdEQVJHN05FdU96RTU2T1FsMnBZcWZTOVZk?=
 =?utf-8?B?a0tIajFQU0xtMHJEaS9lb2djUGVHeHljZldodjQzQmRjWXA4MGx4MzA0MzNF?=
 =?utf-8?B?VlZGazVldUphejRySFFUOG9wTTJUZTJLNGRJY0FGOHE2aXlWMitwS2JTM2pp?=
 =?utf-8?B?YWZhcFRxOHFUNG9UdEh5ZHVLKy9uUmlLWTJvQnlLaENSWVFEdklpVE90eWtS?=
 =?utf-8?B?SXd5TnduWllhVzl1SDNYM3Y2dVg0dkljdm1OMFFvbTU1V0l2RmRzaFUySSt3?=
 =?utf-8?B?UHFyVUc2M2JoYXppZmk0Vml5NVpDZmpxSVZsSm9pR1FBVEZDNENwOHhBQmVY?=
 =?utf-8?B?QVhoVVJsMmRLbEtCRWhMM1NHRkpkRVVRZ0hjbHgzdTBRQU8ycXVsU1NIMXk1?=
 =?utf-8?B?c2JIdzI5bkdWK1VCNmxOWUtlYkxIU01HclJ0SkF4d0x4ak9lSFo1TjZCeUlp?=
 =?utf-8?B?MEQ3dk1Pa1V1eTBleXVJUGt6YWEwS2p2MzRMU1R5VjlwTUVyZ3JVYmNtclEy?=
 =?utf-8?B?emtMUEQvdjFFSUVGU09VRVhDa2pnUkp5WVdodlpqNko2YnZ2KzdVdDBrU0dw?=
 =?utf-8?B?WXpVWWNua0ZmaDNYY3pJSHJjV3oreUxDSUZsMDhmRzRmWk92eUM3S1ZDNnM2?=
 =?utf-8?B?aUNNZ2c2YUQ0bDl5TFZkbmdHcWdqeXhtYlZDZ2NMbDIxOSs2NzljbXk3ZTE4?=
 =?utf-8?B?Y3k4Zk5aaXJtc05HbWpYbXV0am5LYXBmVVB0TDdrL01pN2l2KzIxNEM1cXFB?=
 =?utf-8?B?R2NFTEtCdm4zUjRJb29yOTJUNmQ4UVpmUjlhZDNwKzlVeitIOGYrUUVxWmRV?=
 =?utf-8?B?c0pTVVpVSnpjVzlsRlJuZVJISkczSkk2eWZaQng0TzY3WExQdlU4Q3RILys4?=
 =?utf-8?B?U1lwL1VxQUtQeFM3ZERnaGpPaGtLRFdDcysvOTk0VGVQVEpLV1RyK0ZVTWZ6?=
 =?utf-8?B?dzUra2tyTmh4aXpHTlVHS3FKYVV3dTdDTXZlSk9oSVk0anJqWndDU0R0Wk9T?=
 =?utf-8?B?aitwY2l2cFpjSWhoNFhDcVR0STdTYlliczhST2FzNG5VVWJEa2NTOW9ITEpU?=
 =?utf-8?B?MERxdVVPNEpOQnFCUjZMMDVWMzZwZFVURjEvS2lPbm1ja0d5YjNlVTRtdmV2?=
 =?utf-8?Q?L1+Nkrt+7MFydx94cGg9gRz7q?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	L0fu7QBLA29J21dT5FDazzyeL33svlzgvXE3YdUc+n4xzERt/f9sI18qq2eVgm2WTOA5O4CTyc1vKJ1vSpdwEp7N1jBWwmSXHqtza2CUE/3WUGOawK5HQhvSKVFhhZippc+1VU6Tx0Cl2Ce7D6n+xyzNiGoVHbaXwnXPqbDqlIL89fEMDeVQRKOhVYHaOt8QAVIAl20918jfqVCcWUPhFb6ggKZD91UycKC6eNkAaRTX0e3Z4aYePi4gx87lBhtgaE+OJ9W/5SYVQ4gZ9pw2wucMbOlnn447xwV1WjKwqW8qhfbHxDV4046rY8aL22JmqrY7WomL97OXRpqVZanUmMryJN7iR3zIcMnXiZhcw/oFmqPbo7u1UVsnYw1tG6zr/aRdcfoOV8qrAiR3uCCd5XdtaJIaXSxNw26FJKC6Vmf2YM4B1112cHXv01jF7wcXcy2g0QXzx0m8x5P3WU1gBNUS5dSo1V7+ZItipfNlNNnLEY2AAVUD/MyY4vwATYAXaWgaW1C2kHck/1crYUCjwK7JwCc8tJNOWqh5bH+qPWGHiaxF0JtcUOME5Acqe/24r3kGWB6zv0/rxdx/MLhEzRrazMwUrLCzra2LcMp+JyWbzU2tPTeLTzo7FdYup/9APTwsrSJ2iUokP/eDmH1Kjjdm3uJlHvsOQlbCC7ZuXKUdqkgQL6QDAI8TRwvw+VsaHYeeCVxQsa292VN/VyvAOtfxI54EEg4pZcpa9zmvHYd+gcK8tCon0TosN2Qm4FiMbq5fEa7C0wCrpPVEMFOkrfvr3HY5PhPuufds9ILrSMTiP+DwDSVpkQRjJLv4UQH6QscLp0VWRyBnqUcTK+Dcz3mLNAJS4qHMmxD2qfozi43HokXTCOaSpqPe4j7WO2zCEvIM22Um8pr0xWi4Lty0dQX9Xa4i7Th3//oqU44Bk6Y=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6ae43b9-5c47-4832-ff77-08dbb0b674f5
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4429.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2023 21:56:29.8057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jUqaYKhQBhwmOQOIVz9VJWs6B4gBHb0fDnCRIb2I5Z+yXaHrMIC2jHC0f2gn46F5jMBRfgCcFKoVyi6uj0kNcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6604
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-08_18,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309080200
X-Proofpoint-GUID: laPtHaLGPUW9LaQ4-kH_gzNJPqgYSkn_
X-Proofpoint-ORIG-GUID: laPtHaLGPUW9LaQ4-kH_gzNJPqgYSkn_

On 9/8/2023 2:08 PM, Matthew Wilcox wrote:
> On Fri, Sep 08, 2023 at 01:52:15PM -0600, Jane Chu wrote:
> 
> You need to put a From: line at the top of this so that if someone
> applies this it shows me as author rather than you.

Sorry, will fix.
> 
>> The one caller of DAX lock/unlock page already calls compound_head(),
>> so use page_folio() instead, then use a folio throughout the DAX code
>> to remove uses of page->mapping and page->index.
>>
>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
>> ---
> 
> You should say what changed from v1 here.  Also Naoya Horiguchi offered
> an Acked-by tag that would be appropriate to include.

Sure.
> 
>>   fs/dax.c            | 24 ++++++++++++------------
>>   include/linux/dax.h | 10 +++++-----
>>   mm/memory-failure.c | 29 ++++++++++++++++-------------
>>   3 files changed, 33 insertions(+), 30 deletions(-)
> 
>> +++ b/mm/memory-failure.c
>> @@ -1710,20 +1710,23 @@ static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
>>   	kill_procs(to_kill, flags & MF_MUST_KILL, false, pfn, flags);
>>   }
>>   
>> +/*
>> + * Only dev_pagemap pages get here, such as fsdax when the filesystem
>> + * either do not claim or fails to claim a hwpoison event, or devdax.
>> + * The fsdax pages are initialized per base page, and the devdax pages
>> + * could be initialized either as base pages, or as compound pages with
>> + * vmemmap optimization enabled. Devdax is simplistic in its dealing with
>> + * hwpoison, such that, if a subpage of a compound page is poisoned,
>> + * simply mark the compound head page is by far sufficient.
>> + */
>>   static int mf_generic_kill_procs(unsigned long long pfn, int flags,
>>   		struct dev_pagemap *pgmap)
>>   {
>> -	struct page *page = pfn_to_page(pfn);
>> +	struct folio *folio = page_folio(pfn_to_page(pfn));
> 
> We have a pfn_folio() (which does the same thing, but may not always)
> 
It does the same thing, will replace in a respin.

thanks!
-jane

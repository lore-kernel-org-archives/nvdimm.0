Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2059.outbound.protection.outlook.com [40.107.220.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAB98490
	for <nvdimm@lists.linux.dev>; Mon, 14 Nov 2022 22:27:22 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W64g2tRccBQofjsZVYyJay/g0dslfZMWuifMM4/1QA3sypGW6/rp20UIMkVASgLjYxqcC5lD66DOPCeaGyoBJsyL1MrfMO0c/FRWDRr2TStGWsMhge1GMwocy9nfCp3pVDgWZTmsac/ibG8qFHzWQP+AIkT3sbqPIRChWJbeCizZSM3IWkm91pA/C1w/zV+mkHgGclILbPX6J9SdiQbLEkAnJEFRX40Bc4jrwfLGhmCgjGiZJ8TF7kxjl1LeEW9/HbhQkithgM/mfrvGuiP3Tw6LNcRNpp6+nUqqHcE14VWwZsmiPICQjkj5M9kdx3kB38gXd0MDzL0BdGqb2VxH5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zR9k63Kl0uKEhsfe1Ury1xFPc7BoMFR/wl+Bsr8gTbg=;
 b=Vozp2hIChPqua+r/3WJIRupR7O89J0UT2ICInJ47ghufdKjklKmKB8gaZ5EmUQfyu+94DQYMDWxuF5CRqy/HbfBCrhPP5SrXuXhXyaqUcpunACeM5qbYsQ+A2jjbhsP2ye3gwFGu/Q7JsnJKHEJEjTGdBN3QJnP5Hbu/+pKyTUcjib6RhLMmMoTWfRZ5ct6uiEZo/GO9ck4jYm4JboWSR9uA7nfCHFOvmQuPg/xkloMU+dwjJ7838zglwFzdX5U6aQwmAvaWGfg0/IEkqXLftn4p/eUCFNcCTydOzdokdPcKTHwdlBRN4dwLSljJBqf/ErBftEJGWEkzrwSGTAvJ/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zR9k63Kl0uKEhsfe1Ury1xFPc7BoMFR/wl+Bsr8gTbg=;
 b=oNPBhl6BaD16uR58LMDnmKFlUH2KdJWk8S0QAzmHHee41l2YCnJRdBif14p0ent1KIrw7vK0ONkfwtvxXTiq8Z4xrZCxuZq0E6q0tCSmaSgBIIuOXJWNfqUNGkGYoupoJT0vLsGjF4E2ZuvAocoApcnqjT2RpcJyvtgaPc97WQc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3268.namprd12.prod.outlook.com (2603:10b6:408:6c::18)
 by SJ0PR12MB5676.namprd12.prod.outlook.com (2603:10b6:a03:42e::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 22:27:20 +0000
Received: from BN8PR12MB3268.namprd12.prod.outlook.com
 ([fe80::e433:d24d:69d8:7daf]) by BN8PR12MB3268.namprd12.prod.outlook.com
 ([fe80::e433:d24d:69d8:7daf%5]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 22:27:20 +0000
Message-ID: <1cc14f3f-6500-778a-087c-e7601f82adf3@amd.com>
Date: Mon, 14 Nov 2022 16:27:14 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v4 13/18] nvdimm/cxl/pmem: Add support for master
 passphrase disable security command
Content-Language: en-US
To: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
References: <166845791969.2496228.8357488385523295841.stgit@djiang5-desk3.ch.intel.com>
 <166845805988.2496228.8804764265372893076.stgit@djiang5-desk3.ch.intel.com>
From: Ben Cheatham <benjamin.cheatham@amd.com>
In-Reply-To: <166845805988.2496228.8804764265372893076.stgit@djiang5-desk3.ch.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: MN2PR06CA0025.namprd06.prod.outlook.com
 (2603:10b6:208:23d::30) To BN8PR12MB3268.namprd12.prod.outlook.com
 (2603:10b6:408:6c::18)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3268:EE_|SJ0PR12MB5676:EE_
X-MS-Office365-Filtering-Correlation-Id: d2047866-eedb-4d1a-28ca-08dac68f64fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	7W7wmnwXjiOxwbt8o2/NxWG1qoh2nRuRw9axbi+bw8Tkd9UV/OAWuK/kfpASu2ZP989GqJ2nm7VSYAkUICS1+8gwiriAJSq2p4NbQht8PMmwuelLOg99DSk/rBVYwetmHHsM2pPBENzaDcm+GZTK9MzdCIGZkD47tUVseyxBE2PRdXCbHig0DacmCZ+20gGdFLHdocYE+Ej6P44YvWa0ACTGozklyXWLfH928OTIKoFIgvzx2yWGby3W4MWd9pb3SmX4/3uciTh4zEgOhV1gEx3xtmPOlKYxMjBCf3YKwQLQDG4ZcEwohgirh6YPcgMtCQC3y1dnGWsac7nEiZbnFF8zi5m2CZneIpQyaSWlNGHWXITca8o4QPjAthsPCqgYkFCMj4P27hOe0k7fnx5O24I2wBT3dafMx9AbyGYPXxdKPrucivN7DOmifq1Y0nqaC6D/XqVG5JqF7N8b9+AnKlagmW0JrPZBWaNWYxN5FYTaZ+slOw4cygwMzZNy1Ut1VENQKLxq9rl/sMx/e+cAGWaxvRFMgoqSuz4Hhf6G6uT2if0nAQd4nbDD9S2BsfXGRR2zzycOq4bFjIKANXIF6wHaxTN5wjm401rlv5A2qjKFJhY3GLA31Mlum7kupe+aZ5xsZCePjWuMwb8l63mfgXNpFxSUt/DSYIZa/+6qJkHoHEpAfzEYnwmlSnlFvWjVX4tJZ3bblek3asMAkhQhcYhE+Yv64FUcfgc2E+7GNbHWsDtio8Kb/MSY5kZMyU7TJ6AchNuUQM5YjamJAphkZNQHuYwKkVfe4saPSQ8lVVo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3268.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(376002)(136003)(366004)(39860400002)(396003)(451199015)(316002)(31686004)(36756003)(26005)(6512007)(53546011)(2906002)(6506007)(6666004)(86362001)(31696002)(15650500001)(66476007)(8676002)(186003)(66556008)(83380400001)(8936002)(66946007)(2616005)(41300700001)(5660300002)(478600001)(4326008)(6486002)(38100700002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?utf-8?B?M1lra1Qway9SbjdzNkM0dnNDSUVEZmtRTWNuR0pkajR2SWYrMnJ1VENhWm9Y?=
 =?utf-8?B?YjJZUGY1SExPd1BmM0YwbFZDcE5IYkxkYkxvZ2FveWtZSXBmMjQySlI5ZDZI?=
 =?utf-8?B?UHdsRHludnRNQXBqS1V1SFlWOHVGWWJzNzFsWEFGZFdLVHFRNVlhZ0hUTEJo?=
 =?utf-8?B?aUF1bWdJUFBIRG1jOStzT0ZMcXpxS21ZMjJzUnFMZHY0d1NiQVcvQUJ0QkUw?=
 =?utf-8?B?TWt0NURybnNLbExlYmdRRnFHQzZ1K1A4Ymo1RnRxZmVxeE1MVE5kVGZlZngx?=
 =?utf-8?B?V1ZjN29LYm5kL1JrTVpSc3lwYnl1UDBRWkQwcjZsYzk3K2Q2cWVVM2xRTnBn?=
 =?utf-8?B?V1pidUM2WitRWFlnVGtmNi9zVHc2cE5vMG9IZkMvUzdoMFdJb2ZBZFV1QVdE?=
 =?utf-8?B?d0Z4ZWZ0UWYrUE9WditRWk1GWXVpUER6dzcxOTdaY0o5ZWxGV2pjS05zSTB4?=
 =?utf-8?B?K01YK0RyOU5wU2ZzNy9iUWl0YmM3alVOaGxIOGRXeXdVb3BKRTFkVHBPczR0?=
 =?utf-8?B?d0ZwUlE4UlZkM3pTWEVlUWFPODl0NlB0RlBVdmpQc1haT25hNzNRdVFvRlJH?=
 =?utf-8?B?ajZpUnJCN0pteG1SdDZ4d3RVSzJIa1VLTWZ6Z1lKbVhndHRTUk8vVzhVditH?=
 =?utf-8?B?MFZXL1IvZGk4ZnZlZ28vL2lUamZPUDR2V2sxc243T0dxNTZTcjJzS3FaNXJi?=
 =?utf-8?B?RnVwdzM2NFdxVGtXdWFHdHQzWkoySTBpU2FuZTNEaWxLWmEvbjV6RDkzTCtC?=
 =?utf-8?B?eEprOU1US3JscnlacEV4SmQzcjhwQlc3ajZLOXgycFNJRUd6Q0YrTS9MVjRL?=
 =?utf-8?B?MU1taVM2MjRIcnplYjBzVWpyZGpVcGNxaGRBUnhXMzR6SGtWNGhEVC94TTFU?=
 =?utf-8?B?L1R6OE5jTEVCZ3VLODlZWGNoL0FEd1loa0Uza205MndNdmNxdXMrWWFUN1VM?=
 =?utf-8?B?L0YvOFhSeW9FNllQY01vRkJKTDNwSUZWYzBxV1hSbXFndWI2Z1J3dGFmQysy?=
 =?utf-8?B?bFlhM2NHQUc1NVpTQXByYisyWVdZSWdHNUdmd0R5R3AySEZ5ZXg4SlROMmsz?=
 =?utf-8?B?ZmVmNDlZY0I4QlRES1RKK1pjMzBiWis1WnZBQ3VPOFBsWVM1N2gwWmEyS0dl?=
 =?utf-8?B?c2RMdEJIT3JWTWUvQkNiY3Bqblk1RnJNRVNlN0xMNDJQYWZVMGlRUjNpdVhq?=
 =?utf-8?B?MHZnRFpYZHBkY2JhS2FDejhwMi9XUG9La2s2cVJSTmN2MWdjR3UzTHhvVWNy?=
 =?utf-8?B?SXVBSTFsRWtON3VRa1pzRVpkY1c1U3NlNk8wV0k0UGQzaXZpZURCWi9ZRGxh?=
 =?utf-8?B?eUlNQXlIa0ZoeUZHU0o3Q1hqeDdOR2FUa2Y3RXZtL2o0TklkU1RBREd3WDlz?=
 =?utf-8?B?dWRHTS8xQXR4Rm8zdFl6L2o3aXlPSWhjYWhZUFNrTzFFQWpydmZkNEZYbjY0?=
 =?utf-8?B?c2VwUkx2cmxxc0hOOTNvVlZIdlJLZHdTc1NGa0twd0w1aFFMWlZnUmJ6eDBn?=
 =?utf-8?B?QXhJelJXNWVCVmRiQkttalFDWE5QbjFYdXBDM1B0VFR2QUVZNytQK0FLZHZr?=
 =?utf-8?B?cE93ODd1NTFDa0llSEw5RmRiTnovcG1aM3JoT3d1RzJSdlQvbEh5WEJVcFdJ?=
 =?utf-8?B?czM4cVNhTlhXNmtLN1BHRFNiblM4YlNrNlVONXJONWwvZTY2WUd6SURMZ01Z?=
 =?utf-8?B?c2M0dlROcGVWSENKcnEyd3V1amU2bXdtd3pmMlI5WWZ2WnhIamtRRlNKZGlo?=
 =?utf-8?B?QVN0eEk1cEZLTm5rbWIydmlHSXVIeEVSRTN0dmt6aThkZ2dheFFySkl1SURy?=
 =?utf-8?B?c0dsdUcvOHJPcWdBU0FWN3FEdkR1VmtjMDExTklFZVVheWlYcnBaM3VvZlR1?=
 =?utf-8?B?ZjJtb3hGQ2lkcjFDRVRONm1CczFBWmtwdjdBY2hJNStNazFucXpKd28yVnBw?=
 =?utf-8?B?WFc2NlNsZnZyb29mVUFQYS9GbXovdTk3ZGlLZEcxU0VaVkFTZUd3cDFCRTUx?=
 =?utf-8?B?R1ppL0E3NmRYOE5zb0g4ZlBDbGhhVVVBSDQ1WTZQOVdxL0ZqWC9GNHZ6eVl1?=
 =?utf-8?B?dFpsY3RCMDZlOEhZT0VqK0ZGOE5qTFp4S2FxekIrbURhZU9aVjJYOXBCVHB6?=
 =?utf-8?Q?AeucT4yAJ9UAyHaiS09VCTifn?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2047866-eedb-4d1a-28ca-08dac68f64fa
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3268.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Nov 2022 22:27:20.4335
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qb4Wl+Y7oqEVZLDOvxXf8BrCJxJSSYw0vIP1zYvoGbie4XWWMyLL6YgSyGyAW7NN7ZMsK5xLc03I7ROQimw/sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5676

On 11/14/22 2:34 PM, Dave Jiang wrote:
> The original nvdimm_security_ops ->disable() only supports user passphrase
> for security disable. The CXL spec introduced the disabling of master
> passphrase. Add a ->disable_master() callback to support this new operation
> and leaving the old ->disable() mechanism alone. A "disable_master" command
> is added for the sysfs attribute in order to allow command to be issued
> from userspace. ndctl will need enabling in order to utilize this new
> operation.
>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   drivers/cxl/security.c    |   20 ++++++++++++++++++--
>   drivers/nvdimm/security.c |   33 ++++++++++++++++++++++++++-------
>   include/linux/libnvdimm.h |    2 ++
>   3 files changed, 46 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
> index 631a474939d6..f4df7d38e4cd 100644
> --- a/drivers/cxl/security.c
> +++ b/drivers/cxl/security.c
> @@ -71,8 +71,9 @@ static int cxl_pmem_security_change_key(struct nvdimm *nvdimm,
>   	return rc;
>   }
>   
> -static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
> -				     const struct nvdimm_key_data *key_data)
> +static int __cxl_pmem_security_disable(struct nvdimm *nvdimm,
> +				       const struct nvdimm_key_data *key_data,
> +				       enum nvdimm_passphrase_type ptype)
>   {
>   	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
>   	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
> @@ -88,6 +89,8 @@ static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
>   	 * will only support disable of user passphrase. The disable master passphrase
>   	 * ability will need to be added as a new callback.
>   	 */
> +	dis_pass.type = ptype == NVDIMM_MASTER ?
> +		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
>   	dis_pass.type = CXL_PMEM_SEC_PASS_USER;

Hey Dave,

I noticed that you are overwriting dis_pass.type with 
CXL_PMEM_SEC_PASS_USER after your added change here. I imagine that's 
not intentional considering the rest of the work in this patch!

Ben
>   	memcpy(dis_pass.pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
>   
> @@ -96,6 +99,18 @@ static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
>   	return rc;
>   }
>   
> +static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
> +				     const struct nvdimm_key_data *key_data)
> +{
> +	return __cxl_pmem_security_disable(nvdimm, key_data, NVDIMM_USER);
> +}
> +
> +static int cxl_pmem_security_disable_master(struct nvdimm *nvdimm,
> +					    const struct nvdimm_key_data *key_data)
> +{
> +	return __cxl_pmem_security_disable(nvdimm, key_data, NVDIMM_MASTER);
> +}
> +
>   static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
>   {
>   	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
> @@ -163,6 +178,7 @@ static const struct nvdimm_security_ops __cxl_security_ops = {
>   	.freeze = cxl_pmem_security_freeze,
>   	.unlock = cxl_pmem_security_unlock,
>   	.erase = cxl_pmem_security_passphrase_erase,
> +	.disable_master = cxl_pmem_security_disable_master,
>   };
>   
>   const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
> diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
> index 8aefb60c42ff..92af4c3ca0d3 100644
> --- a/drivers/nvdimm/security.c
> +++ b/drivers/nvdimm/security.c
> @@ -239,7 +239,8 @@ static int check_security_state(struct nvdimm *nvdimm)
>   	return 0;
>   }
>   
> -static int security_disable(struct nvdimm *nvdimm, unsigned int keyid)
> +static int security_disable(struct nvdimm *nvdimm, unsigned int keyid,
> +			    enum nvdimm_passphrase_type pass_type)
>   {
>   	struct device *dev = &nvdimm->dev;
>   	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
> @@ -250,8 +251,13 @@ static int security_disable(struct nvdimm *nvdimm, unsigned int keyid)
>   	/* The bus lock should be held at the top level of the call stack */
>   	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
>   
> -	if (!nvdimm->sec.ops || !nvdimm->sec.ops->disable
> -			|| !nvdimm->sec.flags)
> +	if (!nvdimm->sec.ops || !nvdimm->sec.flags)
> +		return -EOPNOTSUPP;
> +
> +	if (pass_type == NVDIMM_USER && !nvdimm->sec.ops->disable)
> +		return -EOPNOTSUPP;
> +
> +	if (pass_type == NVDIMM_MASTER && !nvdimm->sec.ops->disable_master)
>   		return -EOPNOTSUPP;
>   
>   	rc = check_security_state(nvdimm);
> @@ -263,12 +269,21 @@ static int security_disable(struct nvdimm *nvdimm, unsigned int keyid)
>   	if (!data)
>   		return -ENOKEY;
>   
> -	rc = nvdimm->sec.ops->disable(nvdimm, data);
> -	dev_dbg(dev, "key: %d disable: %s\n", key_serial(key),
> +	if (pass_type == NVDIMM_MASTER) {
> +		rc = nvdimm->sec.ops->disable_master(nvdimm, data);
> +		dev_dbg(dev, "key: %d disable_master: %s\n", key_serial(key),
>   			rc == 0 ? "success" : "fail");
> +	} else {
> +		rc = nvdimm->sec.ops->disable(nvdimm, data);
> +		dev_dbg(dev, "key: %d disable: %s\n", key_serial(key),
> +			rc == 0 ? "success" : "fail");
> +	}
>   
>   	nvdimm_put_key(key);
> -	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
> +	if (pass_type == NVDIMM_MASTER)
> +		nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
> +	else
> +		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
>   	return rc;
>   }
>   
> @@ -473,6 +488,7 @@ void nvdimm_security_overwrite_query(struct work_struct *work)
>   #define OPS							\
>   	C( OP_FREEZE,		"freeze",		1),	\
>   	C( OP_DISABLE,		"disable",		2),	\
> +	C( OP_DISABLE_MASTER,	"disable_master",	2),	\
>   	C( OP_UPDATE,		"update",		3),	\
>   	C( OP_ERASE,		"erase",		2),	\
>   	C( OP_OVERWRITE,	"overwrite",		2),	\
> @@ -524,7 +540,10 @@ ssize_t nvdimm_security_store(struct device *dev, const char *buf, size_t len)
>   		rc = nvdimm_security_freeze(nvdimm);
>   	} else if (i == OP_DISABLE) {
>   		dev_dbg(dev, "disable %u\n", key);
> -		rc = security_disable(nvdimm, key);
> +		rc = security_disable(nvdimm, key, NVDIMM_USER);
> +	} else if (i == OP_DISABLE_MASTER) {
> +		dev_dbg(dev, "disable_master %u\n", key);
> +		rc = security_disable(nvdimm, key, NVDIMM_MASTER);
>   	} else if (i == OP_UPDATE || i == OP_MASTER_UPDATE) {
>   		dev_dbg(dev, "%s %u %u\n", ops[i].name, key, newkey);
>   		rc = security_update(nvdimm, key, newkey, i == OP_UPDATE
> diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
> index c74acfa1a3fe..3bf658a74ccb 100644
> --- a/include/linux/libnvdimm.h
> +++ b/include/linux/libnvdimm.h
> @@ -183,6 +183,8 @@ struct nvdimm_security_ops {
>   	int (*overwrite)(struct nvdimm *nvdimm,
>   			const struct nvdimm_key_data *key_data);
>   	int (*query_overwrite)(struct nvdimm *nvdimm);
> +	int (*disable_master)(struct nvdimm *nvdimm,
> +			      const struct nvdimm_key_data *key_data);
>   };
>   
>   enum nvdimm_fwa_state {
>
>

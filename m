Received: from BN8PR05CU002.outbound.protection.outlook.com (mail-eastus2azon11011039.outbound.protection.outlook.com [52.101.57.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D204A48FF8D
	for <nvdimm@lists.linux.dev>; Wed, 16 Sep 2026 16:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=52.101.57.39
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789576880; cv=fail; b=UWyFbPoWiLU/zpiGHIjNhlr0XI5Cd7S7mZ4xlYA+bEVNsF1YydGvL7Jl7hL7BedR4okiRI5n4wNtPQJkoJoQDgzznf7po7cs2z9TEjJ5bI4/MTlSqZDdpd0LFb2ExvYfkQE5+FDpKNhuJ2N8+6jYx1/YWOG3TshHX3fDn31DMeQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789576880; c=relaxed/simple;
	bh=1xttxHR6Tda0SHDnELDFkOUUBjksu93WPl1WTCEkswk=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=MQp0CFPs3dBppyIEyxe68Vzmk8SVL6Geo7Uhdr/FuDXzHOzFXTWsrI3CwT8wUr58zI9OLSCpLWQnz7mbrCbZ7zjNqSyvYKvEM9OvdybheXcL++cBzzaJ8IT7lf+UgLXkvnUOr92cqdjPxg+o3IVUd5t7sABtscFVoRkWNYmydbM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com; spf=fail smtp.mailfrom=amd.com; dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b=OTW9F5d7; arc=fail smtp.client-ip=52.101.57.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amd.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=amd.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=amd.com header.i=@amd.com header.b="OTW9F5d7"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=vbt0YBvtcVVI+JnCmonpcNM6P3EseCtGMIRn6JbDdQcEh+yAPQ3kQtrvIgFCf7DYg85MDRw73qK/30/MS9UC03ljyF5CYiWDIbHpdpUhgTEV3lu7jM0OCFMkjDrz85zMuCVzQJ4VgMC9mu+MUuK3jfrcdCiADIVnFofh60Ka0I0pPHJHs3N+C2ZQ+8TkByOtn+CaXQ5WB6XhjAvnSaT0EGR+oFvANAHgBoDr0srKoCJ9FPJ1C3Ls+l2T2j4gQnKnMdzKU2r5Uct2Ernaq2pKY/YT8MwHGDU4Rgs+NUXIDj7WQyHrIUHVYpHEKVgdsE9+IoZiCO7r8RZhJ2VnhxzaEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjZPM2OVTX/h9qwmyIHLcVIR+qaNMCBjO1KfKmAYtL0=;
 b=sPIwXYD0ZOHhCkLZSrdApALKiW3EdF7wNr7yF8KPBTEuFgzrfkQYUUj3HoF1TobDI3ZSCKrkpajpXYOi913dqngF1AcObH/mHupqGHXU6gmjjem/HX8thE3jTT5DUyWMHzS/OnNQqBSRyZLRzz50g8q6L6KdL0NJpgzpYlBYS4dhJsfi7FhTmmpHV5PvSUpaCtSZfS9zahLbPhgNqv12b4eIJqzMPE4OfAa0nnOEVTFwZWMJAoXePUvR1yVusOIBrcluVF4a2GzARNFVnfL2RL0qW4Zf0rH3285ED8eehFpHAtfAlVklYj61fCIht/URoU51jHrQDkUDXL8733kYgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=gmail.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none (0)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjZPM2OVTX/h9qwmyIHLcVIR+qaNMCBjO1KfKmAYtL0=;
 b=OTW9F5d7Y8VzeXuMYH/fyhW1oCN4r09OsoMrXh4n421uAAnrsxKREOA1bxrbR0Xd2lNu18/buh+SpiCLyH850X5Fi7x4V64rvtNIs/v8VvoakEZ0A8ET13eIN6jZUszeJ37UHFwOplJJyPJ5rkAmbIGls3El/rxEiqXKG1JTikI=
Received: from SA9PR13CA0162.namprd13.prod.outlook.com (2603:10b6:806:28::17)
 by CY5PR12MB6106.namprd12.prod.outlook.com (2603:10b6:930:29::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.406.12; Wed, 16 Sep
 2026 16:40:56 +0000
Received: from SA2PEPF00003AE9.namprd02.prod.outlook.com
 (2603:10b6:806:28:cafe::a7) by SA9PR13CA0162.outlook.office365.com
 (2603:10b6:806:28::17) with Microsoft SMTP Server (version=TLS1_3,
 cipher=TLS_AES_256_GCM_SHA384) id 15.21.428.9 via Frontend Transport; Wed, 16
 Sep 2026 16:40:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=satlexmb07.amd.com; pr=C
Received: from satlexmb07.amd.com (165.204.84.17) by
 SA2PEPF00003AE9.mail.protection.outlook.com (10.167.248.9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.428.7 via Frontend Transport; Wed, 16 Sep 2026 16:40:55 +0000
Received: from [10.236.187.71] (10.180.168.240) by satlexmb07.amd.com
 (10.181.42.216) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49; Wed, 16 Sep
 2026 11:40:53 -0500
Message-ID: <c60ee4b7-f2b5-4c45-8414-6f7c31462d28@amd.com>
Date: Wed, 16 Sep 2026 11:40:53 -0500
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] cxl/test: Add ELC MCE alias retirement tests
To: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>
CC: <dave.jiang@intel.com>, <dave@stgolabs.net>,
	<jonathan.cameron@huawei.com>, <alison.schofield@intel.com>,
	<vishal.l.verma@intel.com>, <ira.weiny@intel.com>, <dan.j.williams@intel.com>
References: <20260906041844.13891-1-shaikhkamal2012@gmail.com>
 <aqqtlTAh9faQzqCE@acer-nitro-anv15-41>
Content-Language: en-US
From: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
In-Reply-To: <aqqtlTAh9faQzqCE@acer-nitro-anv15-41>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: satlexmb08.amd.com (10.181.42.217) To satlexmb07.amd.com
 (10.181.42.216)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SA2PEPF00003AE9:EE_|CY5PR12MB6106:EE_
X-MS-Office365-Filtering-Correlation-Id: 800d1d4a-5956-405a-b397-08df1411478e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|7416014|82310400026|1800799024|376014|36860700016|11063799006|4143699003|6133799003|56012099006|3023799007|10067099003|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	FBliAVk0rF8XMlwUGqPhgen9HddkF2JgguZaujvzeS8mryJmZuMFj5LsgnJwsMJGgT35qIAVq8tdIQnmUt576DZs0gmc08MsY/99X4Nk4FtjkSYYgdFaf3fJ0UiV6DhLLFWCh4WKxiN/IzgZfHm0FB2pLygmYJhKurx1Fbuo15661s2hyQDhULAL3To5u1Mg/gibz5pXwG4r1OQ36SVXV2Z96kVE7RFhXAcSQYmUBQyysN6Nro5jMVh68ESaNq2vAM7vdY/3SLT4fhwuC+qNJqfVvUVY4HPT9ZQjS33MLvKocxESOuNaXfzeSgmas2zEfyqC6tgWWcugX/Sn47R0wZj9aYvFQoR7UIQSHjFebk6I2M/UrBwwuQhs01UGzc8Tc6wmBaXcRhJdAqaAXD0RuqAAg5O41/18gfqBRojoDhSOpkobHIK40QaNrRFd5117tzKoz+dMsQBXz1Wd5PHLztISmF3KRyzlE3ttwnSGLibQOLQ+zZXbHqaniFMKnPhDLYcmjMbHF/rANY6ZviAn3t2unAoHS/txG2yU2aMFAlHhaj1QLrg7p3Re05+fJeZ9wZtbk0Qgaj5jeOqeiBJcQ0ru1fNos7YeqHA8KorbC7EXjUClB2KGWmf+cKzZErzIubTgbEBWpH75bgFZ/FmA3z9obKiCIDhaC8TWCzbTLCDu9d028gX9oSI+kVQ5B6nVbPRZ+Or+QlCdkyoNxbO3sQ==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:satlexmb07.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230040)(23010399003)(7416014)(82310400026)(1800799024)(376014)(36860700016)(11063799006)(4143699003)(6133799003)(56012099006)(3023799007)(10067099003)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	gJieIkDxeBZ8LkkYBIRwStsqxA0Bk7AKa+F/dgN2pizedJWEGOuCmddM6YBFIBt6S238P+IE6Cxdc6GR3kNTPOh9CQ1ee6sx3O6yeoJ6Sz1lVotry0tcGVpxHpmeWzdiTFxilJtLzkEjCSiXdHXgLGmehWjxc8FMA5PozqllNGjbCO9OgaqYM4bAIFaJlpFVQVQpHHb9CNiF2jKxcr7euRf0rlyiO90wAj6Xn3oCTxr9RWxcmiC+XQ/Z8luRlelYzMuT+XItDfU8xXy1HggfrNXmPz1wD33FzSnox0Wu8FAFA7uRXaeJjHNevRA1AZNRDSEpWcvT3Y4qhMWuyRHBbEPU3UDY+KvWg1tJp18i24DaN0Po6Pw5xuxZ/0MxJMuMadJpjkzM6Ri+kANKu7T7ueWRRYcgq40mV1hk/z/JQRjG9EWX7nnVm2p0v2LQocnR
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2026 16:40:55.6775
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 800d1d4a-5956-405a-b397-08df1411478e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[satlexmb07.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	SA2PEPF00003AE9.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6106

Hi Shaikh,

Sorry I've been on vacation for the last week and half and just now starting to get caught up. I don't have time
to do more than just a quick glance at the moment, but I'll come back and do a full review in the next few days.

On 9/16/2026 9:54 AM, Shaikh Kamaluddin wrote:
> Hi Alison and Ben,
> 
> Gentle ping on this patch. Could you please take a look when you have a
> time?
> 
> Thanks,
> Shaikh Kamaluddin
> 
> On Sun, Sep 06, 2026 at 09:48:44AM +0530, Shaikh Kamaluddin wrote:
>> ELC alias retirement depends on the error severity and on whether

You should spell out ELC on the first usage, helps with context.
>> vendor-specific MCE rules consider the reported address usable. Add
>> regression coverage for these decisions to cxl-elc.sh.
>>
>> Inject MCE records through the mce-inject debugfs interface and verify
>> the resulting bank status and alias-offlining messages in dmesg. Test
>> corrected and uncorrected errors on Intel, and exercise the poison,
>> deferred, and legacy bank-4 cases required by AMD address validation.
>>
>> Derive the ELC SPA and its alias from cxl-list output, select offline
>> test addresses from lsmem, and discover available MCA banks dynamically.
>> Use a distinct SPA for each case and clean up modules loaded by the test.
>>
>> Suggested-by: Ben Cheatham <benjamin.cheatham@amd.com>
>> Suggested-by: Alison Schofield <alison.schofield@intel.com>
>> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
>> ---
>> Testing:
>> The test was run under virtme-ng with cxl_test configured for Extended
>> Linear Cache operation:
>>
>> Intel, GenuineIntel:
>> --------------------
>>
>> 1. vng -v -r ./arch/x86/boot/bzImage --disable-kvm --qemu-opts='-cpu Skylake-Server-v4,+mce,+mca -m 4G -machine q35,cxl=on -object memory-backend-ram,id=cxl-mem0,size=512M -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.0 -device cxl-rp,port=0,bus=cxl.0,id=root_port0,chassis=0,slot=0 -device cxl-type3,bus=root_port0,volatile-memdev=cxl-mem0,id=cxl-mem-device0 -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=512M'
>>
>> 2 . Go to ndctl-main directoy with this patches 
>>
>> env NDCTL="$PWD/build/ndctl/ndctl" 
>> DAXCTL="$PWD/build/daxctl/daxctl" 
>> CXL="$PWD/build/cxl/cxl" 
>> ./test/cxl-elc.sh
>>
>> RESULT:
>> --------
>>
>> PASS Intel corrected: alias no
>> PASS Intel uncorrected: alias yes
>> CXL ELC MCE validation passed for GenuineIntel: 2 cases
>> -----------------------------------------------------------------
>>
>> AMD, AuthenticAMD legacy MCA: 
>> -----------------------------
>>
>> 1. vng -v -r ./arch/x86/boot/bzImage --disable-kvm --qemu-opts='-cpu EPYC-Milan -m 4G -machine q35,cxl=on -object memory-backend-ram,id=cxl-mem0,size=512M -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.0 -device cxl-rp,port=0,bus=cxl.0,id=root_port0,chassis=0,slot=0 -device cxl-type3,bus=root_port0,volatile-memdev=cxl-mem0,id=cxl-mem-device0 -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=512M'

One thing to note: real Milan hardware doesn't support CXL; CXL 1.1 support was added in the next generation (Genoa). The kernel is also broken on Genoa since the driver is geared towards CXL 2.0+, so I'd
recommend a Turin+ machine for hardware testing.

I don't think this is really applicable though, since I'm 99% sure AMD hardware doesn't have ELC support to begin with. I'll try running the tests on hardware and see what happens, though I think it will just
break. There may need to be a check to see what platform the test is running on so we can skip platforms that don't have support (i.e. real AMD hardware).

I think it's probably fine to leave the test in place though in the event AMD adds ELC support later on.

Thanks,
Ben
>>
>> 2. Go to ndctl-main directoy with this patches  
>> env NDCTL="$PWD/build/ndctl/ndctl" 
>> DAXCTL="$PWD/build/daxctl/daxctl" 
>> CXL="$PWD/build/cxl/cxl" 
>> ./test/cxl-elc.sh
>>
>> RESULT:
>> ---------
>> PASS AMD plain corrected: alias no
>> PASS AMD plain uncorrected: alias no
>> PASS AMD poison-only (invalid encoding): alias no
>> PASS AMD deferred without poison: alias no
>> PASS AMD deferred with poison: alias yes
>> PASS AMD uncorrected with poison: alias yes
>> PASS AMD bank-4 non-memory poison (invalid encoding): alias no
>> PASS AMD legacy bank-4 corrected DRAM ECC: alias no
>> CXL ELC MCE validation passed for AuthenticAMD: 8 cases
>>
>>  test/cxl-elc.sh | 313 +++++++++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 312 insertions(+), 1 deletion(-)
>>
>> diff --git a/test/cxl-elc.sh b/test/cxl-elc.sh
>> index cfa09cb..bd600b4 100755
>> --- a/test/cxl-elc.sh
>> +++ b/test/cxl-elc.sh
>> @@ -8,6 +8,30 @@ rc=77
>>  
>>  set -ex
>>  
>> +mce_inject_loaded=0
>> +
>> +cleanup()
>> +{
>> +	local status=$?
>> +	local cleanup_status=0
>> +
>> +	trap - EXIT ERR
>> +	set +e
>> +
>> +	if ((mce_inject_loaded)); then
>> +		modprobe -r mce-inject || cleanup_status=1
>> +	fi
>> +
>> +	modprobe -r cxl_test || cleanup_status=1
>> +
>> +	if ((status == 0 && cleanup_status != 0)); then
>> +		status=1
>> +	fi
>> +
>> +	exit "$status"
>> +}
>> +
>> +trap cleanup EXIT
>>  trap 'err $LINENO' ERR
>>  
>>  check_prereq "jq"
>> @@ -85,10 +109,297 @@ compare_bases()
>>  	((cxlrd_hpa == ep1_hpa - ep1_size)) || err "$LINENO"
>>  }
>>  
>> +mce_skip()
>> +{
>> +	echo "SKIP CXL ELC MCE subtest: $*"
>> +	return 0
>> +}
>> +
>> +dmesg_count()
>> +{
>> +	dmesg | grep -F -c -- "$1" || true
>> +}
>> +
>> +wait_for_dmesg()
>> +{
>> +	local pattern="$1"
>> +	local previous="$2"
>> +	local count
>> +
>> +	for _ in {1..50}; do
>> +		count="$(dmesg_count "$pattern")"
>> +		((count > previous)) && return 0
>> +		sleep 0.1
>> +	done
>> +
>> +	return 1
>> +}
>> +
>> +address_is_offline()
>> +{
>> +	local address="$1"
>> +	local range start end
>> +
>> +	while read -r range; do
>> +		[[ "$range" == *-* ]] || continue
>> +		start=$(( ${range%%-*} ))
>> +		end=$(( ${range##*-} ))
>> +		((address >= start && address <= end)) && return 0
>> +	done < <(echo "$lsmem_json" | jq -r \
>> +		'.memory[] | select((.state | ascii_downcase) == "offline") |
>> +		 .range')
>> +
>> +	return 1
>> +}
>> +
>> +find_offline_spas()
>> +{
>> +	local nr_spas="$1"
>> +	local range start end low high candidate alias spa_string alias_string
>> +	local page_size region_end cache_end i
>> +	local stride=0x10000
>> +
>> +	lsmem_json="$(lsmem --json --bytes --output RANGE,STATE)"
>> +	page_size="$(getconf PAGESIZE)"
>> +	region_end=$((region_hpa + region_size))
>> +	cache_end=$((region_hpa + elc_size))
>> +	inject_spas=()
>> +	alias_spas=()
>> +
>> +	while read -r range; do
>> +		[[ "$range" == *-* ]] || continue
>> +		start=$(( ${range%%-*} ))
>> +		end=$(( ${range##*-} ))
>> +
>> +		low=$start
>> +		((low < region_hpa)) && low=$region_hpa
>> +		high=$((end + 1))
>> +		((high > cache_end)) && high=$cache_end
>> +		((low < high)) || continue
>> +
>> +		# Stay away from the first pages of the hotplugged range.
>> +		candidate=$((low + stride))
>> +		candidate=$((
>> +			(candidate + page_size - 1) / page_size * page_size
>> +		))
>> +		inject_spas=()
>> +		alias_spas=()
>> +		for ((i = 0; i < nr_spas; i++)); do
>> +			candidate=$((candidate + (i > 0 ? stride : 0)))
>> +			alias=$((candidate + elc_size))
>> +			((candidate < high && alias < region_end)) || break
>> +			address_is_offline "$alias" || break
>> +			printf -v spa_string '0x%x' "$candidate"
>> +			printf -v alias_string '0x%x' "$alias"
>> +			inject_spas+=("$spa_string")
>> +			alias_spas+=("$alias_string")
>> +		done
>> +		((${#inject_spas[@]} == nr_spas)) || continue
>> +		return 0
>> +	done < <(echo "$lsmem_json" | jq -r \
>> +		'.memory[] | select((.state | ascii_downcase) == "offline") |
>> +		 .range')
>> +
>> +	return 1
>> +}
>> +
>> +discover_mca_banks()
>> +{
>> +	local path name
>> +
>> +	for path in \
>> +		/sys/devices/system/machinecheck/machinecheck0/bank[0-9]*; do
>> +		[[ -e "$path" ]] || continue
>> +		name="${path##*/}"
>> +		printf '%s\n' "${name#bank}"
>> +	done | sort -n -u
>> +}
>> +
>> +has_bank()
>> +{
>> +	local wanted="$1"
>> +	local bank
>> +
>> +	for bank in "${mca_banks[@]}"; do
>> +		[[ "$bank" == "$wanted" ]] && return 0
>> +	done
>> +
>> +	return 1
>> +}
>> +
>> +select_mce_parameters()
>> +{
>> +	local bank
>> +
>> +	vendor="$(awk '/^vendor_id/{ print $3; exit }' /proc/cpuinfo)"
>> +	readarray -t mca_banks < <(discover_mca_banks)
>> +	((${#mca_banks[@]})) || return 1
>> +
>> +	case "$vendor" in
>> +	GenuineIntel)
>> +		test_bank="${mca_banks[-1]}"
>> +		test_case_count=2
>> +		;;
>> +	AuthenticAMD)
>> +		# The usable-address corrected-error case is the legacy bank-4 DRAM
>> +		# ECC encoding (XEC 8). It is not valid for an SMCA bank.
>> +		grep -qw smca /proc/cpuinfo && return 1
>> +		has_bank 4 || return 1
>> +		non_b4_bank=
>> +		for bank in "${mca_banks[@]}"; do
>> +			[[ "$bank" == 4 ]] || non_b4_bank="$bank"
>> +		done
>> +		[[ -n "$non_b4_bank" ]] || return 1
>> +		test_case_count=8
>> +		;;
>> +	*)
>> +		return 1
>> +		;;
>> +	esac
>> +}
>> +
>> +inject_mce()
>> +{
>> +	local status="$1"
>> +	local bank="$2"
>> +	local mce_inject=/sys/kernel/debug/mce-inject
>> +
>> +	echo sw > "$mce_inject/flags"
>> +	echo "$status" > "$mce_inject/status"
>> +	echo 0x80 > "$mce_inject/misc"
>> +	echo "$inject_spa" > "$mce_inject/addr"
>> +	echo "$bank" > "$mce_inject/bank"
>> +}
>> +
>> +run_mce_case()
>> +{
>> +	local name="$1"
>> +	local status="$2"
>> +	local bank="$3"
>> +	local expect_alias="$4"
>> +	local index="$5"
>> +	local alias_msg bank_msg status_tag
>> +	local alias_before bank_before
>> +
>> +	inject_spa="${inject_spas[$index]}"
>> +	alias_spa="${alias_spas[$index]}"
>> +	alias_msg="Offlining aliased SPA address0: $alias_spa"
>> +	status_tag="${status#0x}"
>> +	bank_msg="Bank $bank: $status_tag"
>> +	alias_before="$(dmesg_count "$alias_msg")"
>> +	bank_before="$(dmesg_count "$bank_msg")"
>> +
>> +	inject_mce "$status" "$bank"
>> +	wait_for_dmesg "$bank_msg" "$bank_before" || err "$LINENO"
>> +
>> +	if [[ "$expect_alias" == "yes" ]]; then
>> +		wait_for_dmesg "$alias_msg" "$alias_before" || err "$LINENO"
>> +	else
>> +		(($(dmesg_count "$alias_msg") == alias_before)) || \
>> +			err "$LINENO"
>> +	fi
>> +
>> +	echo "PASS $name: SPA $inject_spa, alias $alias_spa, bank $bank, alias $expect_alias"
>> +}
>> +
>> +run_intel_mce_cases()
>> +{
>> +	run_mce_case "Intel corrected" 0x9c00000000000080 \
>> +		"$test_bank" no 0
>> +	run_mce_case "Intel uncorrected" 0xbc00000000000080 \
>> +		"$test_bank" yes 1
>> +}
>> +
>> +run_amd_mce_cases()
>> +{
>> +	# Mirror the full AMD matrix documented with the kernel fix. The two
>> +	# poison-only records have UC=0 and Deferred=0, so they are not valid
>> +	# architectural records. Keep them as software-injection robustness
>> +	# coverage and expect the corrected-error filter to reject them.
>> +	run_mce_case "AMD plain corrected" 0x9c00000000000080 \
>> +		"$non_b4_bank" no 0
>> +	run_mce_case "AMD plain uncorrected" 0xbc00000000000080 \
>> +		"$non_b4_bank" no 1
>> +	run_mce_case "AMD poison-only (invalid encoding)" \
>> +		0x9c00080000000080 "$non_b4_bank" no 2
>> +	run_mce_case "AMD deferred without poison" 0x9c00100000000080 \
>> +		"$non_b4_bank" no 3
>> +	run_mce_case "AMD deferred with poison" 0x9c00180000000080 \
>> +		"$non_b4_bank" yes 4
>> +	run_mce_case "AMD uncorrected with poison" 0xbc00080000000080 \
>> +		"$non_b4_bank" yes 5
>> +	run_mce_case "AMD bank-4 non-memory poison (invalid encoding)" \
>> +		0x9c00080000000080 4 no 6
>> +	run_mce_case "AMD legacy bank-4 corrected DRAM ECC" \
>> +		0x9c00000000080000 4 no 7
>> +}
>> +
>> +test_mce_alias()
>> +{
>> +	local region_json
>> +
>> +	[[ "$(uname -m)" == "x86_64" ]] || {
>> +		mce_skip "x86_64 is required"
>> +		return 0
>> +	}
>> +	command -v lsmem >/dev/null 2>&1 || {
>> +		mce_skip "lsmem is unavailable"
>> +		return 0
>> +	}
>> +
>> +	region_json="$(echo "$json" | jq -c --arg region "$region" \
>> +		'.[] | select(.region == $region)')"
>> +	region_hpa="$(echo "$region_json" | jq -r '.resource // empty')"
>> +	region_size="$(echo "$region_json" | jq -r '.size // empty')"
>> +	elc_size="$(echo "$region_json" | jq -r \
>> +		'.extended_linear_cache_size // empty')"
>> +
>> +	[[ "$region_hpa" =~ ^[0-9]+$ ]] || err "$LINENO"
>> +	[[ "$region_size" =~ ^[0-9]+$ ]] || err "$LINENO"
>> +	[[ "$elc_size" =~ ^[0-9]+$ ]] || err "$LINENO"
>> +	((elc_size > 0x10000 && region_size >= elc_size * 2)) || \
>> +		err "$LINENO"
>> +
>> +	select_mce_parameters || {
>> +		mce_skip "no supported MCA bank configuration for $vendor"
>> +		return 0
>> +	}
>> +
>> +	if [[ ! -d /sys/module/mce_inject ]]; then
>> +		modprobe mce-inject || {
>> +			mce_skip "mce-inject module is unavailable"
>> +			return 0
>> +		}
>> +		mce_inject_loaded=1
>> +	fi
>> +	[[ -d /sys/kernel/debug/mce-inject ]] || {
>> +		mce_skip "mce-inject debugfs interface is unavailable"
>> +		return 0
>> +	}
>> +
>> +	find_offline_spas "$test_case_count" || {
>> +		mce_skip "offline lsmem range lacks enough ELC test addresses"
>> +		return 0
>> +	}
>> +
>> +	case "$vendor" in
>> +	GenuineIntel)
>> +		run_intel_mce_cases
>> +		;;
>> +	AuthenticAMD)
>> +		run_amd_mce_cases
>> +		;;
>> +	esac
>> +
>> +	echo "CXL ELC MCE validation passed for $vendor: $test_case_count cases"
>> +}
>> +
>>  find_region
>>  retrieve_info
>>  compare_sizes
>>  compare_bases
>>  
>> +# Check before injecting the expected machine-check messages.
>> +check_dmesg "$LINENO"
>> +test_mce_alias
>>  check_dmesg "$LINENO"
>> -modprobe -r cxl_test
>>
>> base-commit: 15e932c4e1318a9608ad9b799ad83a32a8b5970d
>> -- 
>> 2.43.0
>>


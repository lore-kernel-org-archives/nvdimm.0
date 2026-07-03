Received: from SN4PR2101CU001.outbound.protection.outlook.com (mail-southcentralusazon11012060.outbound.protection.outlook.com [40.93.195.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D920A32AAAB
	for <nvdimm@lists.linux.dev>; Fri,  3 Jul 2026 06:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.93.195.60
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783060490; cv=fail; b=TEeVD9xunQNZo3oul/+MDIudsFIn4utBg60hKoRN9eO4W1Vvnf2lSo0iS8iwm5zr4+KSbC+3/HkOIwBT9Gp3w+sYyy200zgJ1pl/3jMa0x8Dt0tiWm36+M74aUKibGQwA+VFUPXFewINom7htrhyRlqFQuARUY1D1QUUksBwoIU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783060490; c=relaxed/simple;
	bh=99HH0YUCBiUz/fvVvHVH125ZIH9st/Ak5zMHNhgbQpA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=GDwhRHhv6nmkqJqqLkZDmeyzhTwUUBlzJfIsBmTVik97q0uHwn2UNg7PT9XGtqsrl5pz+Xlh9/uDbEP9ivQr+B1a8Z2M9RR0GHRukrulb7MG56l1TfiR5alcyx3dJlsaq377eMmqvJP/ititveiEY8G08dB85vp3rQ+hQkNBqjk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com; spf=fail smtp.mailfrom=nvidia.com; dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b=N4ehF/AC; arc=fail smtp.client-ip=40.93.195.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nvidia.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nvidia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=Nvidia.com header.i=@Nvidia.com header.b="N4ehF/AC"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oMx3dcOTtT7Z+CMMjOBrQYJeh3UYQIhCEjFzG/wVDVeT+CA0Nu7vm5iHdVpeUym8QqZG8u3nk2NH/7cft2W7HhxacI9ly0ZyXKa7ymu9ZECdoBQ7JssTgS2Qr5Lwhe0rfrGivqK4Spe8jbrvpAuksJ0Qr+hlhhno+AamOSBrzpeDpABy9RmelUjhJdO+ZI3jzDfqEs/NS2eTsHUhDC8gBUaHVBXmtyGv36BF7GFNeNed2adw637mC9MqnlmOgsG+K/OwJJ01qxMXaxb9DpXfWxFYew8pahGsZk+leQ9RozUDrwnrbC+qXscq9jgod9kYI0P+Yok9g+igTSD1biw8Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EUiFbM6JwTBjwjexTuCRtYx+f4q2V6dRfe5qV7GIr3U=;
 b=A/uc1GiVOJGOyyF6aMTeNGVZL9GJn+UZjdnSJAE67DFmGR6E4VYayZBmn/LtSYvCOXsniak5xVoA2mqbYMhev/6/lNv0GjcWKRgTPo2YDV9ZZiWmaw8NGq8BGWdTQ5wsmXRN2x142IM4E7bCdJX0/iUhI1ljmkNqu8cjBmfvddjWYRc4gSIMOLwe8VtBz5Sn/EQt5HGCau3hp4QBis4wNMILQX87SvvNHY0pJpL/xfvcMR5iqMKZBLSCeYlHNbWM/4xTghLRRWLrXrIhumoQP+3F8hrNkGXuJdDpSsLCHYpCt9NcjeoNMVTJxQAydIHGMwqbZYqr6GUnBmWRnIaA8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EUiFbM6JwTBjwjexTuCRtYx+f4q2V6dRfe5qV7GIr3U=;
 b=N4ehF/ACJ4QwGCczyDj/wm/3da/U6JBZwx8gurROkIzo/p4O3GsPQ7RX0LXek0oapew92kh/qsnuu5QL4igtwt7ZcBd9DHEbjxu/8A0lhaIC6FynMMKaAbLgqroTo5GKK2E1Dr/V/6IjkLBusG8DkiL28ZcYOHDcmlAY5YYa/n24o67mtzj/mFw9rLzvU3mXueBnz5n8DtA/K9P/4NUA/b8r2ymy0s6AGFIOkvx6mSxZpTtnhE+xrbU1NJIH2eQ2Iz1I8/nih8+U7WVLyojYOXlvPa7eyDA4rkb6ucpemjlJDqDiohOfE8PIYGafm5JqvC/7CWlGT6JefSqsL5svqw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB2370.namprd12.prod.outlook.com (2603:10b6:207:47::27)
 by PH7PR12MB9066.namprd12.prod.outlook.com (2603:10b6:510:1f6::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.181.9; Fri, 3 Jul 2026
 06:34:44 +0000
Received: from BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8]) by BL0PR12MB2370.namprd12.prod.outlook.com
 ([fe80::86cf:c3ec:2cf5:74c8%5]) with mapi id 15.21.0181.009; Fri, 3 Jul 2026
 06:34:43 +0000
Date: Fri, 3 Jul 2026 14:34:36 +0800
From: Richard Cheng <icheng@nvidia.com>
To: Alison Schofield <alison.schofield@intel.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [ndctl PATCH] test/cxl-security.sh: test dimm unlock with a
 large serial number
Message-ID: <akdXJgMHvXzQDHzl@MWDK4CY14F>
References: <20260702003407.1611731-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702003407.1611731-1-alison.schofield@intel.com>
X-ClientProxiedBy: TPYP295CA0019.TWNP295.PROD.OUTLOOK.COM
 (2603:1096:7d0:a::14) To BL0PR12MB2370.namprd12.prod.outlook.com
 (2603:10b6:207:47::27)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL0PR12MB2370:EE_|PH7PR12MB9066:EE_
X-MS-Office365-Filtering-Correlation-Id: 27e19a69-a2d7-497d-a62d-08ded8cd2a35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|23010399003|366016|1800799024|376014|6133799003|56012099006|11063799006|22082099003|18002099003;
X-Microsoft-Antispam-Message-Info:
	kaY6Buju1tSHTb1Y2xZMnZeglVoBBTEGoTGpFsrTyj3L5PX9LARUBlwvl3MPqpDVPBuyV9kGX4h1RvhLSm6ITUHzZYFJdlaPAOdNwFBeUFvE4FGPbx7UIwl0Zm+CT/waH3jx9rZDZt4+wFnk3ruby7dszW1ZVt/U+vkZOHxpoPG3qy0k12xQwVWtGQfoXCAxE2EwdKQWPcquarLebRNf2PXn29g2+sp7JfPd9fMyAscnnLX0cM/3CqREWX7CYDt1O3fy+h+ijxwheg/fqSvjQPbcN6WYaRozeWmnSzstTpwTNQAkFsVCN8wkYtMUiHXBWm5fS5j/ZwwCzXMTG+i/kwlzVShRVeek3Nh1hctII4JzLfesyVOycro5AHeRPzKKWN2oMPzY7SRftxwY3TV5sUScQF+RXvjUXJ+479YnRtEyZDmJxOnuCclRus0itpimGCiex5txYdPH78RpKO1iMyQtXICthP0ZxUOMe+dWfr4WAHkl1fzGLKNNzRd4iDM3lS7b4gXIDyiI49vJbaI3iCXdV5Qa8qHY/s4uTSAYrwqdAmV7fKZQdbK8/k0kDnfLDcVI6xfs7igVI7UlKUDK687ON8J7bIzZ2CMh+ulolmp+25YuHYwo07ViRzSCkk8LVa0QThmsGdK659ALon0Uwy4lMEuax9QEcuLORQZ7iAE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB2370.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(23010399003)(366016)(1800799024)(376014)(6133799003)(56012099006)(11063799006)(22082099003)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?67Tp+jLLh+nGH6HLCNn4yWrFKrl7EIHfl9ZAo4sk1/TAP+sXMbJ6Jy6FefEp?=
 =?us-ascii?Q?MFBAe+QF8HOTN8oASzzw/MTDLf0bNuWkYBU7Blwt/FoYW/AWf6VVn/d6DUrE?=
 =?us-ascii?Q?dR3Ty1YgwJmOPa9sK3SWlk6ZJmF79MuM98+kK2xmqmpcAMmohwCl2aYQPA/P?=
 =?us-ascii?Q?eMkrJjIRTqIrCLY+RQT+1HQC8hcsMYCtGQSFSqJBxJ444O30Sa+Dq7p37KHw?=
 =?us-ascii?Q?NDKFrqFBpUXYg5QtZUw4QPdOdC2GWJ45pT0fmTWHiOgnyhEcBXG1hPrSQZK8?=
 =?us-ascii?Q?TVgz72hx3tlaOZuilU/hIuDUFmy6pE4th0i3gO6mPg23WF2ymH1M+MB4Xiyv?=
 =?us-ascii?Q?RBrZpLHBr84r895yIQs7zptFidZ54j6IK6V9/PmK/EkEBKdhWqje2+pBE0WO?=
 =?us-ascii?Q?q0pJKi4FUCqSxSpEAUqPpbOUo15vYl0F45374W9woVgotxl+dnkXxbT7Q5ul?=
 =?us-ascii?Q?iNIB39ApUqNGzvWE7uYQbmJL/mg3rnNtthi4BHe8XFTycNcEZz/o6uIleyDV?=
 =?us-ascii?Q?ljfs1SwgX46p2pq/anYXdVxlFSSw3r45F0Jed6lyu7MZ5gXMB+IkQ+2DvIh2?=
 =?us-ascii?Q?gsS1JblcjsnFJTZF80r9vZlab7MWiCB4sasiZBCo6ck3odKsiNqUAFtYlNQK?=
 =?us-ascii?Q?4AbRUIt1hB7AHr6bk9ZKG3Wif1t1R/Vm3R3hfkxxlc/rj7n4KclS8nClQg/c?=
 =?us-ascii?Q?FEuJadnH4hFY9esyGYCP+2oVK1xgevMbx+Pvxz+9KzjLp/3BC4XfBA3AoTV6?=
 =?us-ascii?Q?16TdoIg3rRDcsFUmeL9Bp9hAjl8JbMZj4jDfNKnyjJXs5KRdeXITkX91SWtR?=
 =?us-ascii?Q?p3GdMH+OaQxRGv0Bl2tAipVt9pPQ6uelFRu5lIjDuD93RLq8IenZufOxhMGT?=
 =?us-ascii?Q?KjlVnFbU3oX/uU5Fp3PGPWnYw/C+7UBo5VAWbLYiCszzqhAECZkE+rhx62p/?=
 =?us-ascii?Q?f32i7i3er9krVikgGvWWSzEBLpZSD/KATHz4QhlU55PY2S20BH48lmiy/D8I?=
 =?us-ascii?Q?BiTrYjrFzVWCWYetf2j6oME4qtvUGorAp/OyEmHJ+KYGGEE+pztyBAxEUIgO?=
 =?us-ascii?Q?XNDd5vx2pLtonIRs0JOHBFKqSdsdvXWL1GX6g2r9pHUWCm2n3T1wvgB7oOdK?=
 =?us-ascii?Q?9NGd5I3miZJ3co4sjLe7FGQD+11Fi6f9WQErhIAh2vGEhdN3wpILtGdAJMwD?=
 =?us-ascii?Q?j4Bi7ish2TLuSHM+zY4RIevPX8+4Lcw9pfLrrUOlFNXRvxmYGr3QfFfqvOaI?=
 =?us-ascii?Q?/AlIfvG+m3hL6bk/E2DkT6uytcy90gSrDI/CLG3OI+9WLYCxLjZD21j65eP3?=
 =?us-ascii?Q?+torm7z2d9uXGbvZ6SCTDrszh9Jk6H55rfgPXLlN+rTzt+4rKMX7EqUYyy+f?=
 =?us-ascii?Q?jIIayev9arHc5Dv29h5XaahKzIFRa/NuQJhq8pZcj1PfaUsjZS01oOs/gFYU?=
 =?us-ascii?Q?VeHrFGWuyVd4Os4YyZEiR6gWyybCojttB28SCOvPNkoFqeAn8IM8WDh/yVcB?=
 =?us-ascii?Q?qFRFBBXMjE6JDMFGSbWylzwz87XMHL65PrN4gx8Y7gEzeQsHr+cqzRsuxZBD?=
 =?us-ascii?Q?t7W+2NeNLImXhHpw+ty0VF+N+q1tF5ukL/UekD6VY6+IcZpnrbsCb3CPQiLu?=
 =?us-ascii?Q?b0q/KLzr80WUfB5gf1LzuYyLiYC4R2EdBhtKhbUlni5Eve8V1jaBkIDD6e1N?=
 =?us-ascii?Q?h5plhnayZYshevbufjMw7NHHdC1Egvt170z8j0/+XatFDx8l9E+wnIA6HER6?=
 =?us-ascii?Q?e8RGK6ioWw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 27e19a69-a2d7-497d-a62d-08ded8cd2a35
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB2370.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2026 06:34:43.6490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R55oQwospHk7kMRVDgtbxaxgbADbvFf2p/FP4DBoqU3qgfoLoIIPl6qEAdlsifzFwhjxAZeevG6rCpOittoyrQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB9066

On Wed, Jul 01, 2026 at 05:34:03PM +0800, Alison Schofield wrote:
> The existing CXL unlock test exposed the hexadecimal-vs-decimal key
> description mismatch once cxl_test mock serial numbers were extended
> to 10 and above. Serials with bit 63 set expose a second formatting
> problem in that the kernel formats the decimal serial as signed,
> rendering it as a negative value.
> 
> Extend the existing "unlock dimm" test to repeat the unlock against a
> mock memdev with a full-width serial that has bit 63 set. Refactor the
> common unlock sequence into an unlock_dimm() helper so the signedness
> case follows the same test flow as the original key lookup case.
> 
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>
> ---
>  test/cxl-security | 24 ++++++++++++++++++++++++
>  test/security.sh  | 16 ++++++++++++++--
>  2 files changed, 38 insertions(+), 2 deletions(-)
> 
> diff --git a/test/cxl-security b/test/cxl-security
> index 9a28ffd82b0b..39b7e001ce08 100644
> --- a/test/cxl-security
> +++ b/test/cxl-security
> @@ -9,6 +9,30 @@ detect()
>  	[ -n "$id" ] || err "$LINENO"
>  }
>  
> +# Select the mock memdev whose serial has bit 63 set. Match on the hex
> +# spelling of 'id' because the value exceeds signed 64-bit shell arithmetic.
> +# A 16-digit hex value with a leading nibble of 8-f has bit 63 set.
> +detect_big_serial()
> +{
> +	local d i hex
> +
> +	dev=""
> +	for d in $($NDCTL list -b "$CXL_TEST_BUS" -D | jq -r '.[].dev'); do
> +		i="$($NDCTL list -b "$CXL_TEST_BUS" -D -d "$d" | \
> +			jq -r '.[0].id')"
> +		hex="$(printf '%x' "$i" 2>/dev/null)" || continue
> +		case "${#hex}:${hex:0:1}" in
> +		16:[89a-fA-F])
> +			dev="$d"
> +			id="$i"
> +			break
> +			;;
> +		esac
> +	done
> +
> +	[ -n "$dev" ] || err "$LINENO: no serial with bit 63 set found"
> +}
> +
>  lock_dimm()
>  {
>  	$NDCTL disable-dimm "$dev"
> diff --git a/test/security.sh b/test/security.sh
> index d3a840c23276..72bb570142ed 100755
> --- a/test/security.sh
> +++ b/test/security.sh
> @@ -144,7 +144,7 @@ test_3_security_setup_and_erase()
>  	erase_security
>  }
> 

Hi Alison,

Just a question,
Does this cover the reboot or load-keys path?
setup_passphrase() leave the large-serial key resident in the keyring,
the this only tests lookup of an already-loaded key.

The failure being addressed occurs after reboot, when the key ring is empty
and ndctl load-keys reconstructs the key from the persistent blob.
test_6_load_keys() exercise() that path, but only after detect restores the default device.

Could this case unlink the large-serial key, run ndctl load-keys, and then
enable and verify that the device unlocks? That would excercise the
persistence boundary relevant to the reported failure.

--Richard
 
> -test_4_security_unlock()
> +unlock_dimm()
>  {
>  	setup_passphrase
>  	lock_dimm
> @@ -158,6 +158,18 @@ test_4_security_unlock()
>  	remove_passphrase
>  }
>  
> +test_4_security_unlock()
> +{
> +	unlock_dimm
> +
> +	if [ "$1" = "cxl" ] && check_min_kver "7.3"; then
> +		detect_big_serial
> +		unlock_dimm
> +		# Restore the default device selection for later tests.
> +		detect
> +	fi
> +}
> +
>  # This should always be the last nvdimm security test.
>  # with security frozen, nfit_test must be removed and is no longer usable
>  test_5_security_freeze()
> @@ -241,7 +253,7 @@ test_2_security_setup_and_update
>  echo "Test 3, security setup and erase"
>  test_3_security_setup_and_erase
>  echo "Test 4, unlock dimm"
> -test_4_security_unlock
> +test_4_security_unlock "$1"
>  
>  # Freeze should always be the last nvdimm security test because it locks
>  # security state and require nfit_test module unload. However, this does
> 
> base-commit: 5fcbbee57319e718bf522436ea6595bd0f71296c
> -- 
> 2.37.3
> 
> 

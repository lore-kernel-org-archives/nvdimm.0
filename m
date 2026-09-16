Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2112F33DEE5
	for <nvdimm@lists.linux.dev>; Wed, 16 Sep 2026 14:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570459; cv=none; b=b4nFyWAylXApN0fYNuvHIRPjxrZkE7p4LKv/SY8rMTklAjQsSTrnKl5OQ7nT/enfDe4lLms2RMTIMkO9F0JslCdQK1/EW2u2G6+RJH7JH1bTb9BmZUgB29CBAIX4J80wZm6K/mDU1f1pN65GATy4gUCSaKHKSmvIMW/xFwXj3vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570459; c=relaxed/simple;
	bh=n/p4WBIEXcMZxs1jRSyT3lLqhJIgLuii8JWQtRW5s+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aSGbdhC/HCgUBFUS4DwfGJllXubrQPbcT/cL+uznAb3SG9rT/hwq+PNMSykoAqJtPrlcCWHRGj50MSi0zr+NG16w+wnmboI68fMN2/NGlFdjzG4XE3l/V7oVyYdC0nE5Y0cTwXjDkkouC4Q8DUls24di7p3epIWfckZOKELiJq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aBV+BgGF; arc=none smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aBV+BgGF"
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-8631d0023daso684969b3a.2
        for <nvdimm@lists.linux.dev>; Wed, 16 Sep 2026 07:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789570456; x=1790175256; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=McgxAHAn6VsxsuT0qiBr3n9Z5oAUL6cScE2jLTG0csA=;
        b=aBV+BgGFkOyOY3wCHyIg2lqWq7NvPTxeIbgMVLjBw4GsPFXXaEx65BMffvYPhodJkn
         dmx99HYvOD9fC1JrOyjF3mCocrBDRVtkYvEqIQMt573bp0KS7IxM9QRQ0m64ESmMaY5L
         IgS6A0R8oRVHbFZUjbzWYh8C0U49Z9u9zhVPn7cY0PK0hYHodkCEoVxHirq5ruY+33wE
         wlFiqeX+0dVWEeUgcw6YZFeH2c2CQ0dxtzyB06XYEgCFOZ0TGrSQ88SwVsGRJck61G9w
         uGYkkB0DXdUTogUSdLwlAs7/BG5cLt6Ketqktp2Jt2tLeCAMMLgzZ28/EO/VaR3xdjFz
         wGjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570456; x=1790175256;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=McgxAHAn6VsxsuT0qiBr3n9Z5oAUL6cScE2jLTG0csA=;
        b=0NAE1AgGKDeInz0fiNZaveH1csXYGFxAqN4CBM5yrpo3SVmS84KIX70wAkcAcGFhoR
         OFNisf/++TwIBSi7A6q8XgZnFYEzHqQc0rVlxb4FX+8hwf5Ab501kZuIbfTm5SPzi7dO
         2R3Ddsk18ttr6EZ95qaAGbkUlPL1J/bcAVybGrHp297ur7rzIHBjjtEG6s6RaN3Rgylz
         vx3oLI58p0Lh6lHdPbx7OJoNfZfDPo46dUt8YQ2AaN1he+riNd/cSbAwWeIyeLucuuuV
         /eN0AabWtNwnw/4xt/LAILjakR4+BmVgFynJplsEnaxbY4S0FrJ2Xq2pxG8XeY/WO57R
         bX2A==
X-Forwarded-Encrypted: i=1; AKwUvBzQOEtiN01Dngm96wk4O81bRel033zzLlN5/st4WkHVHQCyEW284jJVGTOkqHz4t9VI14wIsaw=@lists.linux.dev
X-Gm-Message-State: AFuF++kJCHYVO/jVarx8PkZjJG1h8pF0ppWhFUUL2xS/vRyjXMeQyErT
	h06voJxGjIM7Am4ZK6uECvqEEOWGMbtmmZ1Ir7NExnzy3P0NjbyiiQS5
X-Gm-Gg: AYBFou0AsNTHHw99lT2CMm791pAmKwAP0JNTZyWVk8hYrvEAaarGx/aiNUJvpVMnU/u
	vEOqcJDqggQ7RbWaopuUYM0Zs1BP7e2c4l/P/60wfo8T/OexayWxlzcSlW227SGHcP2cp5dRsUn
	/lIF2f/xnfEaYN3wC5gOcr7Mc8b5lVFb/hROpNZAjaZIOVfI213B9usRambq+/Wd9COsmBkLfPh
	cDgwiCkWMQTnQ/8oj52kAEyoEj2dyM/xkwoq5GHSIOQJy4sCe4Mz67kQPbXr/Tya5FhrHvD3kX2
	J376lQH87oVZ5QDn+lPBhLUO/1p1ZcesoVOKVpTMjVt6zavdNI1NI5i407qr5ouTH7TY47YmCHN
	QSWqCOgBT/swG5yvfBsabrcf8lFs5aAWeqzVpeKyAdRripW51jqdK1gMyKayex/1w25jfH8Rbs0
	1c89h/r8y0mo6Gui3OM4paZbXKFxK1izp8jIZgvFiPbwapJboboBMs+fT9kdXlh9ZbJSz+y7W/
X-Received: by 2002:a05:6a00:1407:b0:86f:68:4427 with SMTP id d2e1a72fcca58-8723a38f874mr5932499b3a.25.1789570456069;
        Wed, 16 Sep 2026 07:54:16 -0700 (PDT)
Received: from localhost ([118.34.230.2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87201240d12sm1352480b3a.28.2026.09.16.07.54.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 07:54:15 -0700 (PDT)
Date: Wed, 16 Sep 2026 20:24:13 +0530
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dave.jiang@intel.com, dave@stgolabs.net, jonathan.cameron@huawei.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	benjamin.cheatham@amd.com
Subject: Re: [ndctl PATCH] cxl/test: Add ELC MCE alias retirement tests
Message-ID: <aqqtlTAh9faQzqCE@acer-nitro-anv15-41>
References: <20260906041844.13891-1-shaikhkamal2012@gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260906041844.13891-1-shaikhkamal2012@gmail.com>

Hi Alison and Ben,

Gentle ping on this patch. Could you please take a look when you have a
time?

Thanks,
Shaikh Kamaluddin

On Sun, Sep 06, 2026 at 09:48:44AM +0530, Shaikh Kamaluddin wrote:
> ELC alias retirement depends on the error severity and on whether
> vendor-specific MCE rules consider the reported address usable. Add
> regression coverage for these decisions to cxl-elc.sh.
> 
> Inject MCE records through the mce-inject debugfs interface and verify
> the resulting bank status and alias-offlining messages in dmesg. Test
> corrected and uncorrected errors on Intel, and exercise the poison,
> deferred, and legacy bank-4 cases required by AMD address validation.
> 
> Derive the ELC SPA and its alias from cxl-list output, select offline
> test addresses from lsmem, and discover available MCA banks dynamically.
> Use a distinct SPA for each case and clean up modules loaded by the test.
> 
> Suggested-by: Ben Cheatham <benjamin.cheatham@amd.com>
> Suggested-by: Alison Schofield <alison.schofield@intel.com>
> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> ---
> Testing:
> The test was run under virtme-ng with cxl_test configured for Extended
> Linear Cache operation:
> 
> Intel, GenuineIntel:
> --------------------
> 
> 1. vng -v -r ./arch/x86/boot/bzImage --disable-kvm --qemu-opts='-cpu Skylake-Server-v4,+mce,+mca -m 4G -machine q35,cxl=on -object memory-backend-ram,id=cxl-mem0,size=512M -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.0 -device cxl-rp,port=0,bus=cxl.0,id=root_port0,chassis=0,slot=0 -device cxl-type3,bus=root_port0,volatile-memdev=cxl-mem0,id=cxl-mem-device0 -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=512M'
> 
> 2 . Go to ndctl-main directoy with this patches 
> 
> env NDCTL="$PWD/build/ndctl/ndctl" 
> DAXCTL="$PWD/build/daxctl/daxctl" 
> CXL="$PWD/build/cxl/cxl" 
> ./test/cxl-elc.sh
> 
> RESULT:
> --------
> 
> PASS Intel corrected: alias no
> PASS Intel uncorrected: alias yes
> CXL ELC MCE validation passed for GenuineIntel: 2 cases
> -----------------------------------------------------------------
> 
> AMD, AuthenticAMD legacy MCA: 
> -----------------------------
> 
> 1. vng -v -r ./arch/x86/boot/bzImage --disable-kvm --qemu-opts='-cpu EPYC-Milan -m 4G -machine q35,cxl=on -object memory-backend-ram,id=cxl-mem0,size=512M -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.0 -device cxl-rp,port=0,bus=cxl.0,id=root_port0,chassis=0,slot=0 -device cxl-type3,bus=root_port0,volatile-memdev=cxl-mem0,id=cxl-mem-device0 -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=512M'
> 
> 2. Go to ndctl-main directoy with this patches  
> env NDCTL="$PWD/build/ndctl/ndctl" 
> DAXCTL="$PWD/build/daxctl/daxctl" 
> CXL="$PWD/build/cxl/cxl" 
> ./test/cxl-elc.sh
> 
> RESULT:
> ---------
> PASS AMD plain corrected: alias no
> PASS AMD plain uncorrected: alias no
> PASS AMD poison-only (invalid encoding): alias no
> PASS AMD deferred without poison: alias no
> PASS AMD deferred with poison: alias yes
> PASS AMD uncorrected with poison: alias yes
> PASS AMD bank-4 non-memory poison (invalid encoding): alias no
> PASS AMD legacy bank-4 corrected DRAM ECC: alias no
> CXL ELC MCE validation passed for AuthenticAMD: 8 cases
> 
>  test/cxl-elc.sh | 313 +++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 312 insertions(+), 1 deletion(-)
> 
> diff --git a/test/cxl-elc.sh b/test/cxl-elc.sh
> index cfa09cb..bd600b4 100755
> --- a/test/cxl-elc.sh
> +++ b/test/cxl-elc.sh
> @@ -8,6 +8,30 @@ rc=77
>  
>  set -ex
>  
> +mce_inject_loaded=0
> +
> +cleanup()
> +{
> +	local status=$?
> +	local cleanup_status=0
> +
> +	trap - EXIT ERR
> +	set +e
> +
> +	if ((mce_inject_loaded)); then
> +		modprobe -r mce-inject || cleanup_status=1
> +	fi
> +
> +	modprobe -r cxl_test || cleanup_status=1
> +
> +	if ((status == 0 && cleanup_status != 0)); then
> +		status=1
> +	fi
> +
> +	exit "$status"
> +}
> +
> +trap cleanup EXIT
>  trap 'err $LINENO' ERR
>  
>  check_prereq "jq"
> @@ -85,10 +109,297 @@ compare_bases()
>  	((cxlrd_hpa == ep1_hpa - ep1_size)) || err "$LINENO"
>  }
>  
> +mce_skip()
> +{
> +	echo "SKIP CXL ELC MCE subtest: $*"
> +	return 0
> +}
> +
> +dmesg_count()
> +{
> +	dmesg | grep -F -c -- "$1" || true
> +}
> +
> +wait_for_dmesg()
> +{
> +	local pattern="$1"
> +	local previous="$2"
> +	local count
> +
> +	for _ in {1..50}; do
> +		count="$(dmesg_count "$pattern")"
> +		((count > previous)) && return 0
> +		sleep 0.1
> +	done
> +
> +	return 1
> +}
> +
> +address_is_offline()
> +{
> +	local address="$1"
> +	local range start end
> +
> +	while read -r range; do
> +		[[ "$range" == *-* ]] || continue
> +		start=$(( ${range%%-*} ))
> +		end=$(( ${range##*-} ))
> +		((address >= start && address <= end)) && return 0
> +	done < <(echo "$lsmem_json" | jq -r \
> +		'.memory[] | select((.state | ascii_downcase) == "offline") |
> +		 .range')
> +
> +	return 1
> +}
> +
> +find_offline_spas()
> +{
> +	local nr_spas="$1"
> +	local range start end low high candidate alias spa_string alias_string
> +	local page_size region_end cache_end i
> +	local stride=0x10000
> +
> +	lsmem_json="$(lsmem --json --bytes --output RANGE,STATE)"
> +	page_size="$(getconf PAGESIZE)"
> +	region_end=$((region_hpa + region_size))
> +	cache_end=$((region_hpa + elc_size))
> +	inject_spas=()
> +	alias_spas=()
> +
> +	while read -r range; do
> +		[[ "$range" == *-* ]] || continue
> +		start=$(( ${range%%-*} ))
> +		end=$(( ${range##*-} ))
> +
> +		low=$start
> +		((low < region_hpa)) && low=$region_hpa
> +		high=$((end + 1))
> +		((high > cache_end)) && high=$cache_end
> +		((low < high)) || continue
> +
> +		# Stay away from the first pages of the hotplugged range.
> +		candidate=$((low + stride))
> +		candidate=$((
> +			(candidate + page_size - 1) / page_size * page_size
> +		))
> +		inject_spas=()
> +		alias_spas=()
> +		for ((i = 0; i < nr_spas; i++)); do
> +			candidate=$((candidate + (i > 0 ? stride : 0)))
> +			alias=$((candidate + elc_size))
> +			((candidate < high && alias < region_end)) || break
> +			address_is_offline "$alias" || break
> +			printf -v spa_string '0x%x' "$candidate"
> +			printf -v alias_string '0x%x' "$alias"
> +			inject_spas+=("$spa_string")
> +			alias_spas+=("$alias_string")
> +		done
> +		((${#inject_spas[@]} == nr_spas)) || continue
> +		return 0
> +	done < <(echo "$lsmem_json" | jq -r \
> +		'.memory[] | select((.state | ascii_downcase) == "offline") |
> +		 .range')
> +
> +	return 1
> +}
> +
> +discover_mca_banks()
> +{
> +	local path name
> +
> +	for path in \
> +		/sys/devices/system/machinecheck/machinecheck0/bank[0-9]*; do
> +		[[ -e "$path" ]] || continue
> +		name="${path##*/}"
> +		printf '%s\n' "${name#bank}"
> +	done | sort -n -u
> +}
> +
> +has_bank()
> +{
> +	local wanted="$1"
> +	local bank
> +
> +	for bank in "${mca_banks[@]}"; do
> +		[[ "$bank" == "$wanted" ]] && return 0
> +	done
> +
> +	return 1
> +}
> +
> +select_mce_parameters()
> +{
> +	local bank
> +
> +	vendor="$(awk '/^vendor_id/{ print $3; exit }' /proc/cpuinfo)"
> +	readarray -t mca_banks < <(discover_mca_banks)
> +	((${#mca_banks[@]})) || return 1
> +
> +	case "$vendor" in
> +	GenuineIntel)
> +		test_bank="${mca_banks[-1]}"
> +		test_case_count=2
> +		;;
> +	AuthenticAMD)
> +		# The usable-address corrected-error case is the legacy bank-4 DRAM
> +		# ECC encoding (XEC 8). It is not valid for an SMCA bank.
> +		grep -qw smca /proc/cpuinfo && return 1
> +		has_bank 4 || return 1
> +		non_b4_bank=
> +		for bank in "${mca_banks[@]}"; do
> +			[[ "$bank" == 4 ]] || non_b4_bank="$bank"
> +		done
> +		[[ -n "$non_b4_bank" ]] || return 1
> +		test_case_count=8
> +		;;
> +	*)
> +		return 1
> +		;;
> +	esac
> +}
> +
> +inject_mce()
> +{
> +	local status="$1"
> +	local bank="$2"
> +	local mce_inject=/sys/kernel/debug/mce-inject
> +
> +	echo sw > "$mce_inject/flags"
> +	echo "$status" > "$mce_inject/status"
> +	echo 0x80 > "$mce_inject/misc"
> +	echo "$inject_spa" > "$mce_inject/addr"
> +	echo "$bank" > "$mce_inject/bank"
> +}
> +
> +run_mce_case()
> +{
> +	local name="$1"
> +	local status="$2"
> +	local bank="$3"
> +	local expect_alias="$4"
> +	local index="$5"
> +	local alias_msg bank_msg status_tag
> +	local alias_before bank_before
> +
> +	inject_spa="${inject_spas[$index]}"
> +	alias_spa="${alias_spas[$index]}"
> +	alias_msg="Offlining aliased SPA address0: $alias_spa"
> +	status_tag="${status#0x}"
> +	bank_msg="Bank $bank: $status_tag"
> +	alias_before="$(dmesg_count "$alias_msg")"
> +	bank_before="$(dmesg_count "$bank_msg")"
> +
> +	inject_mce "$status" "$bank"
> +	wait_for_dmesg "$bank_msg" "$bank_before" || err "$LINENO"
> +
> +	if [[ "$expect_alias" == "yes" ]]; then
> +		wait_for_dmesg "$alias_msg" "$alias_before" || err "$LINENO"
> +	else
> +		(($(dmesg_count "$alias_msg") == alias_before)) || \
> +			err "$LINENO"
> +	fi
> +
> +	echo "PASS $name: SPA $inject_spa, alias $alias_spa, bank $bank, alias $expect_alias"
> +}
> +
> +run_intel_mce_cases()
> +{
> +	run_mce_case "Intel corrected" 0x9c00000000000080 \
> +		"$test_bank" no 0
> +	run_mce_case "Intel uncorrected" 0xbc00000000000080 \
> +		"$test_bank" yes 1
> +}
> +
> +run_amd_mce_cases()
> +{
> +	# Mirror the full AMD matrix documented with the kernel fix. The two
> +	# poison-only records have UC=0 and Deferred=0, so they are not valid
> +	# architectural records. Keep them as software-injection robustness
> +	# coverage and expect the corrected-error filter to reject them.
> +	run_mce_case "AMD plain corrected" 0x9c00000000000080 \
> +		"$non_b4_bank" no 0
> +	run_mce_case "AMD plain uncorrected" 0xbc00000000000080 \
> +		"$non_b4_bank" no 1
> +	run_mce_case "AMD poison-only (invalid encoding)" \
> +		0x9c00080000000080 "$non_b4_bank" no 2
> +	run_mce_case "AMD deferred without poison" 0x9c00100000000080 \
> +		"$non_b4_bank" no 3
> +	run_mce_case "AMD deferred with poison" 0x9c00180000000080 \
> +		"$non_b4_bank" yes 4
> +	run_mce_case "AMD uncorrected with poison" 0xbc00080000000080 \
> +		"$non_b4_bank" yes 5
> +	run_mce_case "AMD bank-4 non-memory poison (invalid encoding)" \
> +		0x9c00080000000080 4 no 6
> +	run_mce_case "AMD legacy bank-4 corrected DRAM ECC" \
> +		0x9c00000000080000 4 no 7
> +}
> +
> +test_mce_alias()
> +{
> +	local region_json
> +
> +	[[ "$(uname -m)" == "x86_64" ]] || {
> +		mce_skip "x86_64 is required"
> +		return 0
> +	}
> +	command -v lsmem >/dev/null 2>&1 || {
> +		mce_skip "lsmem is unavailable"
> +		return 0
> +	}
> +
> +	region_json="$(echo "$json" | jq -c --arg region "$region" \
> +		'.[] | select(.region == $region)')"
> +	region_hpa="$(echo "$region_json" | jq -r '.resource // empty')"
> +	region_size="$(echo "$region_json" | jq -r '.size // empty')"
> +	elc_size="$(echo "$region_json" | jq -r \
> +		'.extended_linear_cache_size // empty')"
> +
> +	[[ "$region_hpa" =~ ^[0-9]+$ ]] || err "$LINENO"
> +	[[ "$region_size" =~ ^[0-9]+$ ]] || err "$LINENO"
> +	[[ "$elc_size" =~ ^[0-9]+$ ]] || err "$LINENO"
> +	((elc_size > 0x10000 && region_size >= elc_size * 2)) || \
> +		err "$LINENO"
> +
> +	select_mce_parameters || {
> +		mce_skip "no supported MCA bank configuration for $vendor"
> +		return 0
> +	}
> +
> +	if [[ ! -d /sys/module/mce_inject ]]; then
> +		modprobe mce-inject || {
> +			mce_skip "mce-inject module is unavailable"
> +			return 0
> +		}
> +		mce_inject_loaded=1
> +	fi
> +	[[ -d /sys/kernel/debug/mce-inject ]] || {
> +		mce_skip "mce-inject debugfs interface is unavailable"
> +		return 0
> +	}
> +
> +	find_offline_spas "$test_case_count" || {
> +		mce_skip "offline lsmem range lacks enough ELC test addresses"
> +		return 0
> +	}
> +
> +	case "$vendor" in
> +	GenuineIntel)
> +		run_intel_mce_cases
> +		;;
> +	AuthenticAMD)
> +		run_amd_mce_cases
> +		;;
> +	esac
> +
> +	echo "CXL ELC MCE validation passed for $vendor: $test_case_count cases"
> +}
> +
>  find_region
>  retrieve_info
>  compare_sizes
>  compare_bases
>  
> +# Check before injecting the expected machine-check messages.
> +check_dmesg "$LINENO"
> +test_mce_alias
>  check_dmesg "$LINENO"
> -modprobe -r cxl_test
> 
> base-commit: 15e932c4e1318a9608ad9b799ad83a32a8b5970d
> -- 
> 2.43.0
> 

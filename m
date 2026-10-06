Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 803D7175A88
	for <nvdimm@lists.linux.dev>; Tue,  6 Oct 2026 03:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791256160; cv=none; b=PaO/OIMkzAJF0LvF5JeENW3zAsAlvzlKMwMoIfQfpafD2wjlTfLIvHx69aIqdvPpqmsstzs8s8J5kYkYjeaZGOwqUw4gtjWcj9YIUlCWeQ77tMR49sHSoIzQHtvvYypZNXrqMLN1l8sAuiqlxcLeIh/p1vGgKXrJ12SfP8c6978=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791256160; c=relaxed/simple;
	bh=OVft/xbEqPgCYgTAUo60M/Gr4LyQYSlQ1eFSvv483Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYqFzkgIsnzgsy95BuiQEMh7MUfw8Nscofh4ovkNnxx3wgkzuvz3c4WhPKlvDKry2YTe3TMpOBVqdPcTUOyVohUP4rZG6wmP/FtIS/87WdnwDqbQjEszo3G73jC7g6rXs4SOL/GzQKObg2anfgnafBF6lwQG5192H7nr5OmwkdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=in66QQO0; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="in66QQO0"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-351348eb579so693675eec.0
        for <nvdimm@lists.linux.dev>; Mon, 05 Oct 2026 20:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791256156; x=1791860956; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XcBjTo8k6f4ZxjFF0dkhyrWCRKv8XDO/3DYCWWX3kBk=;
        b=in66QQO0Q2QSyBSoNLdtTvGL0fvr7xaTJ7ZXE7/yJb1JmgN01UtOsEbAJTj9UKPm0E
         hlp0xZCLFuP9NhwVafg/zgozIkMBC0VYt7HH3uukoSO3WpOFXXvl+82zFEy/Oyaz7UTO
         YKspnohDRUpUvgPEA+2L+UUeVUyuy9blDydXmSoBAA5TiNON5s08URVJi+rTfyJwxbnu
         SdpxrMmREUTn3chfb98b6nImiQ7Uci0qfJ2q1kN4JlcGH2nRuXBGMUXCUCsNzJz+8hSp
         vgRN+tbkghGOlhatYYM+yeJ1vjSBUtMRCt7qSCcZkm+DKBWUXB/hxEE4icpBTGgjBYSU
         OsyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791256156; x=1791860956;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XcBjTo8k6f4ZxjFF0dkhyrWCRKv8XDO/3DYCWWX3kBk=;
        b=n2FH7hP+Ih4PqGE+9ZepvOR6/AFrW8PbwI23p8l5uAWPTrzEjTKWBmpflZMxvlujZr
         WvusmlcyxVLyvEML6Zc8NFb//q9To8MJtfBTluHVunoqZfmx8JuIY8sCUAz+DqVestRm
         wFzQ8TKoAJfCjKJQV7khm4i+cuMGTqb3t/qzdqQNYKDnTXmKE0RanFuoNnLTXBGPcbQx
         Cm/ZdxxO+r5X5CAEkTAWdt3VZiOd51UWE7BkBt74l0ygIEu8UD/6jMbuYiEsdwp9gCCt
         P2QGvGvFVX5Dv8WL70hwo7EtSnZcoMVAyVdLxVdTDEdEiq+12ezox7+mCY6rqNEIA059
         KPjA==
X-Forwarded-Encrypted: i=1; AKwUvBzl1S2R6YaQJGIUY43kwAtLKd4cleEPIYbVOPou7QZyENzjhjGjBsXxsvHYxb/fTpfRI0R60qA=@lists.linux.dev
X-Gm-Message-State: AFq9FYKw0N3pBfF0XuLd1wZZyUYc4XUX5vhzWTJ1+b+S2Sxxddt54+iW
	fOnlwdkQ752kftj9AUKI7g2oNgSfVHSx/m9uswmqzecDSudyFZ2NaPYM
X-Gm-Gg: AYBFou2SFgWE87XOvKYmBp5ymOR5vKvrpCnWGDHGMKMvAtby0wbQKiowHl6om+E2+ui
	nExSivnTbxbgAKzY9+tW3z1ED+AGmAcC/c1fRA4Sig7MkCXN/8X1egER1G73rGnLrwB8sDJkv2T
	Njm4kSLUx7lFNdLA36E/kPoIxg0R91IpE40KGkpp0uVTNSkRcu7DaaZqXnNdiea03nhwnX45V8F
	po41OjjFnfSpFAm1Acb3I/Mv5r6xleynQtkMG22e11Zijy/8WLeshOBJ83FA10qrYKpZotiKSNW
	BMi+lca3AXzuaBsPDRasBkEmbuVn49DueXM7/SyaMCpPb3cfgszvR7LYClVGQnatSdlKEB4OVok
	SGlnmDsA403PrcG7HQ1NdDSsdwpjS8LyzT0mqTjb40nkiAht/JV+ailkHg3F5old4de9rwcoB76
	CSKui8s/0WiQOMaiBRUsbQJXwh7BEWERw8URLXzxC1HMvpVRalgAtln2Fiq44DOQj5fpRJ/KODL
	w==
X-Received: by 2002:a05:7301:2b5:b0:34e:f619:eeba with SMTP id 5a478bee46e88-3514501ead2mr1709782eec.3.1791256155809;
        Mon, 05 Oct 2026 20:09:15 -0700 (PDT)
Received: from localhost ([115.97.153.197])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351469f7617sm3018821eec.9.2026.10.05.20.09.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 20:09:15 -0700 (PDT)
Date: Tue, 6 Oct 2026 08:39:12 +0530
From: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
To: "Cheatham, Benjamin" <benjamin.cheatham@amd.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dave.jiang@intel.com,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com
Subject: Re: [ndctl PATCH] cxl/test: Add ELC MCE alias retirement tests
Message-ID: <asRmWIC64soVVL4Q@acer-nitro-anv15-41>
References: <20260906041844.13891-1-shaikhkamal2012@gmail.com>
 <aqqtlTAh9faQzqCE@acer-nitro-anv15-41>
 <c60ee4b7-f2b5-4c45-8414-6f7c31462d28@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c60ee4b7-f2b5-4c45-8414-6f7c31462d28@amd.com>

On Wed, Sep 16, 2026 at 11:40:53AM -0500, Cheatham, Benjamin wrote:
> Hi Shaikh,
> 
> Sorry I've been on vacation for the last week and half and just now starting to get caught up. I don't have time
> to do more than just a quick glance at the moment, but I'll come back and do a full review in the next few days.
> 
> On 9/16/2026 9:54 AM, Shaikh Kamaluddin wrote:
> > Hi Alison and Ben,
> > 
> > Gentle ping on this patch. Could you please take a look when you have a
> > time?
> > 
> > Thanks,
> > Shaikh Kamaluddin
> > 
> > On Sun, Sep 06, 2026 at 09:48:44AM +0530, Shaikh Kamaluddin wrote:
> >> ELC alias retirement depends on the error severity and on whether
> 
> You should spell out ELC on the first usage, helps with context.

Hello Ben,
Sorry for delay reply.
I will spell out Extended Linear Cache(ELC) on its first use.

> >> vendor-specific MCE rules consider the reported address usable. Add
> >> regression coverage for these decisions to cxl-elc.sh.
> >>
> >> Inject MCE records through the mce-inject debugfs interface and verify
> >> the resulting bank status and alias-offlining messages in dmesg. Test
> >> corrected and uncorrected errors on Intel, and exercise the poison,
> >> deferred, and legacy bank-4 cases required by AMD address validation.
> >>
> >> Derive the ELC SPA and its alias from cxl-list output, select offline
> >> test addresses from lsmem, and discover available MCA banks dynamically.
> >> Use a distinct SPA for each case and clean up modules loaded by the test.
> >>
> >> Suggested-by: Ben Cheatham <benjamin.cheatham@amd.com>
> >> Suggested-by: Alison Schofield <alison.schofield@intel.com>
> >> Signed-off-by: Shaikh Kamaluddin <shaikhkamal2012@gmail.com>
> >> ---
> >> Testing:
> >> The test was run under virtme-ng with cxl_test configured for Extended
> >> Linear Cache operation:
> >>
> >> Intel, GenuineIntel:
> >> --------------------
> >>
> >> 1. vng -v -r ./arch/x86/boot/bzImage --disable-kvm --qemu-opts='-cpu Skylake-Server-v4,+mce,+mca -m 4G -machine q35,cxl=on -object memory-backend-ram,id=cxl-mem0,size=512M -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.0 -device cxl-rp,port=0,bus=cxl.0,id=root_port0,chassis=0,slot=0 -device cxl-type3,bus=root_port0,volatile-memdev=cxl-mem0,id=cxl-mem-device0 -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=512M'
> >>
> >> 2 . Go to ndctl-main directoy with this patches 
> >>
> >> env NDCTL="$PWD/build/ndctl/ndctl" 
> >> DAXCTL="$PWD/build/daxctl/daxctl" 
> >> CXL="$PWD/build/cxl/cxl" 
> >> ./test/cxl-elc.sh
> >>
> >> RESULT:
> >> --------
> >>
> >> PASS Intel corrected: alias no
> >> PASS Intel uncorrected: alias yes
> >> CXL ELC MCE validation passed for GenuineIntel: 2 cases
> >> -----------------------------------------------------------------
> >>
> >> AMD, AuthenticAMD legacy MCA: 
> >> -----------------------------
> >>
> >> 1. vng -v -r ./arch/x86/boot/bzImage --disable-kvm --qemu-opts='-cpu EPYC-Milan -m 4G -machine q35,cxl=on -object memory-backend-ram,id=cxl-mem0,size=512M -device pxb-cxl,bus_nr=12,bus=pcie.0,id=cxl.0 -device cxl-rp,port=0,bus=cxl.0,id=root_port0,chassis=0,slot=0 -device cxl-type3,bus=root_port0,volatile-memdev=cxl-mem0,id=cxl-mem-device0 -M cxl-fmw.0.targets.0=cxl.0,cxl-fmw.0.size=512M'
> 
> One thing to note: real Milan hardware doesn't support CXL; CXL 1.1 support was added in the next generation (Genoa). The kernel is also broken on Genoa since the driver is geared towards CXL 2.0+, so I'd
> recommend a Turin+ machine for hardware testing.

Thanks for clarifying. I used the EPYC-Milan QEMU CPU model under TCG
only to exercise the legacy AMD MCA path, it was not intended to imply
CXL support on physical Milan Hardware. The ELC setup was provided by
cxl_test.

Agreed that Turin would be appropriate platform for any physical AMD
hardware testing.
> 
> I don't think this is really applicable though, since I'm 99% sure AMD hardware doesn't have ELC support to begin with. I'll try running the tests on hardware and see what happens, though I think it will just
> break. There may need to be a check to see what platform the test is running on so we can skip platforms that don't have support (i.e. real AMD hardware).
> 
> I think it's probably fine to leave the test in place though in the event AMD adds ELC support later on.
> 

That make sense. The AMD cases are intended to exercise the
vendor-specific MCE address-validation paths against the mock ELC region
created by cxl_test, rather than claim ELC support on physical AMD
hardware.

I agree that the test should skip cleanly when ELC support is
unavailable, while retaining the AMD mock coverage for possible future
hardware support.

Thanks,
Shaikh Kamal

> Thanks,
> Ben
> >>
> >> 2. Go to ndctl-main directoy with this patches  
> >> env NDCTL="$PWD/build/ndctl/ndctl" 
> >> DAXCTL="$PWD/build/daxctl/daxctl" 
> >> CXL="$PWD/build/cxl/cxl" 
> >> ./test/cxl-elc.sh
> >>
> >> RESULT:
> >> ---------
> >> PASS AMD plain corrected: alias no
> >> PASS AMD plain uncorrected: alias no
> >> PASS AMD poison-only (invalid encoding): alias no
> >> PASS AMD deferred without poison: alias no
> >> PASS AMD deferred with poison: alias yes
> >> PASS AMD uncorrected with poison: alias yes
> >> PASS AMD bank-4 non-memory poison (invalid encoding): alias no
> >> PASS AMD legacy bank-4 corrected DRAM ECC: alias no
> >> CXL ELC MCE validation passed for AuthenticAMD: 8 cases
> >>
> >>  test/cxl-elc.sh | 313 +++++++++++++++++++++++++++++++++++++++++++++++-
> >>  1 file changed, 312 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/test/cxl-elc.sh b/test/cxl-elc.sh
> >> index cfa09cb..bd600b4 100755
> >> --- a/test/cxl-elc.sh
> >> +++ b/test/cxl-elc.sh
> >> @@ -8,6 +8,30 @@ rc=77
> >>  
> >>  set -ex
> >>  
> >> +mce_inject_loaded=0
> >> +
> >> +cleanup()
> >> +{
> >> +	local status=$?
> >> +	local cleanup_status=0
> >> +
> >> +	trap - EXIT ERR
> >> +	set +e
> >> +
> >> +	if ((mce_inject_loaded)); then
> >> +		modprobe -r mce-inject || cleanup_status=1
> >> +	fi
> >> +
> >> +	modprobe -r cxl_test || cleanup_status=1
> >> +
> >> +	if ((status == 0 && cleanup_status != 0)); then
> >> +		status=1
> >> +	fi
> >> +
> >> +	exit "$status"
> >> +}
> >> +
> >> +trap cleanup EXIT
> >>  trap 'err $LINENO' ERR
> >>  
> >>  check_prereq "jq"
> >> @@ -85,10 +109,297 @@ compare_bases()
> >>  	((cxlrd_hpa == ep1_hpa - ep1_size)) || err "$LINENO"
> >>  }
> >>  
> >> +mce_skip()
> >> +{
> >> +	echo "SKIP CXL ELC MCE subtest: $*"
> >> +	return 0
> >> +}
> >> +
> >> +dmesg_count()
> >> +{
> >> +	dmesg | grep -F -c -- "$1" || true
> >> +}
> >> +
> >> +wait_for_dmesg()
> >> +{
> >> +	local pattern="$1"
> >> +	local previous="$2"
> >> +	local count
> >> +
> >> +	for _ in {1..50}; do
> >> +		count="$(dmesg_count "$pattern")"
> >> +		((count > previous)) && return 0
> >> +		sleep 0.1
> >> +	done
> >> +
> >> +	return 1
> >> +}
> >> +
> >> +address_is_offline()
> >> +{
> >> +	local address="$1"
> >> +	local range start end
> >> +
> >> +	while read -r range; do
> >> +		[[ "$range" == *-* ]] || continue
> >> +		start=$(( ${range%%-*} ))
> >> +		end=$(( ${range##*-} ))
> >> +		((address >= start && address <= end)) && return 0
> >> +	done < <(echo "$lsmem_json" | jq -r \
> >> +		'.memory[] | select((.state | ascii_downcase) == "offline") |
> >> +		 .range')
> >> +
> >> +	return 1
> >> +}
> >> +
> >> +find_offline_spas()
> >> +{
> >> +	local nr_spas="$1"
> >> +	local range start end low high candidate alias spa_string alias_string
> >> +	local page_size region_end cache_end i
> >> +	local stride=0x10000
> >> +
> >> +	lsmem_json="$(lsmem --json --bytes --output RANGE,STATE)"
> >> +	page_size="$(getconf PAGESIZE)"
> >> +	region_end=$((region_hpa + region_size))
> >> +	cache_end=$((region_hpa + elc_size))
> >> +	inject_spas=()
> >> +	alias_spas=()
> >> +
> >> +	while read -r range; do
> >> +		[[ "$range" == *-* ]] || continue
> >> +		start=$(( ${range%%-*} ))
> >> +		end=$(( ${range##*-} ))
> >> +
> >> +		low=$start
> >> +		((low < region_hpa)) && low=$region_hpa
> >> +		high=$((end + 1))
> >> +		((high > cache_end)) && high=$cache_end
> >> +		((low < high)) || continue
> >> +
> >> +		# Stay away from the first pages of the hotplugged range.
> >> +		candidate=$((low + stride))
> >> +		candidate=$((
> >> +			(candidate + page_size - 1) / page_size * page_size
> >> +		))
> >> +		inject_spas=()
> >> +		alias_spas=()
> >> +		for ((i = 0; i < nr_spas; i++)); do
> >> +			candidate=$((candidate + (i > 0 ? stride : 0)))
> >> +			alias=$((candidate + elc_size))
> >> +			((candidate < high && alias < region_end)) || break
> >> +			address_is_offline "$alias" || break
> >> +			printf -v spa_string '0x%x' "$candidate"
> >> +			printf -v alias_string '0x%x' "$alias"
> >> +			inject_spas+=("$spa_string")
> >> +			alias_spas+=("$alias_string")
> >> +		done
> >> +		((${#inject_spas[@]} == nr_spas)) || continue
> >> +		return 0
> >> +	done < <(echo "$lsmem_json" | jq -r \
> >> +		'.memory[] | select((.state | ascii_downcase) == "offline") |
> >> +		 .range')
> >> +
> >> +	return 1
> >> +}
> >> +
> >> +discover_mca_banks()
> >> +{
> >> +	local path name
> >> +
> >> +	for path in \
> >> +		/sys/devices/system/machinecheck/machinecheck0/bank[0-9]*; do
> >> +		[[ -e "$path" ]] || continue
> >> +		name="${path##*/}"
> >> +		printf '%s\n' "${name#bank}"
> >> +	done | sort -n -u
> >> +}
> >> +
> >> +has_bank()
> >> +{
> >> +	local wanted="$1"
> >> +	local bank
> >> +
> >> +	for bank in "${mca_banks[@]}"; do
> >> +		[[ "$bank" == "$wanted" ]] && return 0
> >> +	done
> >> +
> >> +	return 1
> >> +}
> >> +
> >> +select_mce_parameters()
> >> +{
> >> +	local bank
> >> +
> >> +	vendor="$(awk '/^vendor_id/{ print $3; exit }' /proc/cpuinfo)"
> >> +	readarray -t mca_banks < <(discover_mca_banks)
> >> +	((${#mca_banks[@]})) || return 1
> >> +
> >> +	case "$vendor" in
> >> +	GenuineIntel)
> >> +		test_bank="${mca_banks[-1]}"
> >> +		test_case_count=2
> >> +		;;
> >> +	AuthenticAMD)
> >> +		# The usable-address corrected-error case is the legacy bank-4 DRAM
> >> +		# ECC encoding (XEC 8). It is not valid for an SMCA bank.
> >> +		grep -qw smca /proc/cpuinfo && return 1
> >> +		has_bank 4 || return 1
> >> +		non_b4_bank=
> >> +		for bank in "${mca_banks[@]}"; do
> >> +			[[ "$bank" == 4 ]] || non_b4_bank="$bank"
> >> +		done
> >> +		[[ -n "$non_b4_bank" ]] || return 1
> >> +		test_case_count=8
> >> +		;;
> >> +	*)
> >> +		return 1
> >> +		;;
> >> +	esac
> >> +}
> >> +
> >> +inject_mce()
> >> +{
> >> +	local status="$1"
> >> +	local bank="$2"
> >> +	local mce_inject=/sys/kernel/debug/mce-inject
> >> +
> >> +	echo sw > "$mce_inject/flags"
> >> +	echo "$status" > "$mce_inject/status"
> >> +	echo 0x80 > "$mce_inject/misc"
> >> +	echo "$inject_spa" > "$mce_inject/addr"
> >> +	echo "$bank" > "$mce_inject/bank"
> >> +}
> >> +
> >> +run_mce_case()
> >> +{
> >> +	local name="$1"
> >> +	local status="$2"
> >> +	local bank="$3"
> >> +	local expect_alias="$4"
> >> +	local index="$5"
> >> +	local alias_msg bank_msg status_tag
> >> +	local alias_before bank_before
> >> +
> >> +	inject_spa="${inject_spas[$index]}"
> >> +	alias_spa="${alias_spas[$index]}"
> >> +	alias_msg="Offlining aliased SPA address0: $alias_spa"
> >> +	status_tag="${status#0x}"
> >> +	bank_msg="Bank $bank: $status_tag"
> >> +	alias_before="$(dmesg_count "$alias_msg")"
> >> +	bank_before="$(dmesg_count "$bank_msg")"
> >> +
> >> +	inject_mce "$status" "$bank"
> >> +	wait_for_dmesg "$bank_msg" "$bank_before" || err "$LINENO"
> >> +
> >> +	if [[ "$expect_alias" == "yes" ]]; then
> >> +		wait_for_dmesg "$alias_msg" "$alias_before" || err "$LINENO"
> >> +	else
> >> +		(($(dmesg_count "$alias_msg") == alias_before)) || \
> >> +			err "$LINENO"
> >> +	fi
> >> +
> >> +	echo "PASS $name: SPA $inject_spa, alias $alias_spa, bank $bank, alias $expect_alias"
> >> +}
> >> +
> >> +run_intel_mce_cases()
> >> +{
> >> +	run_mce_case "Intel corrected" 0x9c00000000000080 \
> >> +		"$test_bank" no 0
> >> +	run_mce_case "Intel uncorrected" 0xbc00000000000080 \
> >> +		"$test_bank" yes 1
> >> +}
> >> +
> >> +run_amd_mce_cases()
> >> +{
> >> +	# Mirror the full AMD matrix documented with the kernel fix. The two
> >> +	# poison-only records have UC=0 and Deferred=0, so they are not valid
> >> +	# architectural records. Keep them as software-injection robustness
> >> +	# coverage and expect the corrected-error filter to reject them.
> >> +	run_mce_case "AMD plain corrected" 0x9c00000000000080 \
> >> +		"$non_b4_bank" no 0
> >> +	run_mce_case "AMD plain uncorrected" 0xbc00000000000080 \
> >> +		"$non_b4_bank" no 1
> >> +	run_mce_case "AMD poison-only (invalid encoding)" \
> >> +		0x9c00080000000080 "$non_b4_bank" no 2
> >> +	run_mce_case "AMD deferred without poison" 0x9c00100000000080 \
> >> +		"$non_b4_bank" no 3
> >> +	run_mce_case "AMD deferred with poison" 0x9c00180000000080 \
> >> +		"$non_b4_bank" yes 4
> >> +	run_mce_case "AMD uncorrected with poison" 0xbc00080000000080 \
> >> +		"$non_b4_bank" yes 5
> >> +	run_mce_case "AMD bank-4 non-memory poison (invalid encoding)" \
> >> +		0x9c00080000000080 4 no 6
> >> +	run_mce_case "AMD legacy bank-4 corrected DRAM ECC" \
> >> +		0x9c00000000080000 4 no 7
> >> +}
> >> +
> >> +test_mce_alias()
> >> +{
> >> +	local region_json
> >> +
> >> +	[[ "$(uname -m)" == "x86_64" ]] || {
> >> +		mce_skip "x86_64 is required"
> >> +		return 0
> >> +	}
> >> +	command -v lsmem >/dev/null 2>&1 || {
> >> +		mce_skip "lsmem is unavailable"
> >> +		return 0
> >> +	}
> >> +
> >> +	region_json="$(echo "$json" | jq -c --arg region "$region" \
> >> +		'.[] | select(.region == $region)')"
> >> +	region_hpa="$(echo "$region_json" | jq -r '.resource // empty')"
> >> +	region_size="$(echo "$region_json" | jq -r '.size // empty')"
> >> +	elc_size="$(echo "$region_json" | jq -r \
> >> +		'.extended_linear_cache_size // empty')"
> >> +
> >> +	[[ "$region_hpa" =~ ^[0-9]+$ ]] || err "$LINENO"
> >> +	[[ "$region_size" =~ ^[0-9]+$ ]] || err "$LINENO"
> >> +	[[ "$elc_size" =~ ^[0-9]+$ ]] || err "$LINENO"
> >> +	((elc_size > 0x10000 && region_size >= elc_size * 2)) || \
> >> +		err "$LINENO"
> >> +
> >> +	select_mce_parameters || {
> >> +		mce_skip "no supported MCA bank configuration for $vendor"
> >> +		return 0
> >> +	}
> >> +
> >> +	if [[ ! -d /sys/module/mce_inject ]]; then
> >> +		modprobe mce-inject || {
> >> +			mce_skip "mce-inject module is unavailable"
> >> +			return 0
> >> +		}
> >> +		mce_inject_loaded=1
> >> +	fi
> >> +	[[ -d /sys/kernel/debug/mce-inject ]] || {
> >> +		mce_skip "mce-inject debugfs interface is unavailable"
> >> +		return 0
> >> +	}
> >> +
> >> +	find_offline_spas "$test_case_count" || {
> >> +		mce_skip "offline lsmem range lacks enough ELC test addresses"
> >> +		return 0
> >> +	}
> >> +
> >> +	case "$vendor" in
> >> +	GenuineIntel)
> >> +		run_intel_mce_cases
> >> +		;;
> >> +	AuthenticAMD)
> >> +		run_amd_mce_cases
> >> +		;;
> >> +	esac
> >> +
> >> +	echo "CXL ELC MCE validation passed for $vendor: $test_case_count cases"
> >> +}
> >> +
> >>  find_region
> >>  retrieve_info
> >>  compare_sizes
> >>  compare_bases
> >>  
> >> +# Check before injecting the expected machine-check messages.
> >> +check_dmesg "$LINENO"
> >> +test_mce_alias
> >>  check_dmesg "$LINENO"
> >> -modprobe -r cxl_test
> >>
> >> base-commit: 15e932c4e1318a9608ad9b799ad83a32a8b5970d
> >> -- 
> >> 2.43.0
> >>
> 

Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019727;
	b=jAssG7rSgO/LHHnuIduHSHOli+rl9eG11HnoJkN+q+/BAWS9uapUSgPqhnLb2z2yo3yH
	 4AqP2ARMgEkJlrnCiir/HMbdvpnWrDbAi62ywMi1GkEmzgtu0PT+8VgcILUQQYwaMR+Kg
	 eDfgwAWcYt450PvPwgPDgyJ2ksviuir7Aa8D7qKzOKswSp9LstHp+mUbnDllE5o6tW/ZR
	 9diAqHaVsLYACBzAJFLeoX7ACwT1YTZWqkNbY/qxvXQHCLL7P8A3WQ1Tl2Jy2/7X77cNI
	 usZUAFsr3oD9wuIvQy1uZoro9ClebjQm3+F9ldeDlf3e8tt2K6MitV3l3gV2ipnsWEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019727;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=kG0ySAZAGtYkbIvxgTKMCCfHCqdTfnuBx/JWOPtX3wg=;
	b=cWk+MYFrF1xMzackcoGWXe4BAHAsUOC18eNM2HS6IQZcxZbDaOse5EQjNVlQ+dGl06wY
	 WZBo9UQOyJR+Ez1z1IJ0Qvkl6OyftcbNoSHn5TNmQjKN34ubdd09LK7yaifNg+BjH02lX
	 6iq/8W8Jyt8PkY6fERZqJU6V/9/ht8T5oU8ucqAI5iKgfkTSjY5RE+q0GALkb2Ajs+tQS
	 H8H9VP1NU8Hz2VFnXkt0z5cQd582zwkm91Na0VFjwgJ6oicfjTWqL5Q662j6tQg9nK58+
	 7ujMF8i6/P+SPt2I1VHukyDLdsnNWAONab0acrHeQa9S1907NM0BTbVXZOPoVQOwVqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="igDSC/hA";
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C342606A320
	for <nvdimm@lists.linux.dev>; Wed, 18 Nov 2026 16:35:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5C342606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=igDSC/hA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1795019727; x=1826555727;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=tPhwvHp3xiIkm4ayESPfRzMmSZfNwHFGJLlzSnv0eEQ=;
  b=igDSC/hA91EgzCUyyVG5FqL7owKJ5mgQX3973tssBg19qvzHX7xUU8cW
   T5IG2pRo8cVo0DmOiDChSdEgQhxr5oek3EcfTDZWEwDPQ41zU+tcSXkS6
   OJssREgo7TKipNvawWB3t/uOdNHH9utynpO/WmfphtUIRjrOFSMhN/vuj
   yxaxbj6MTxEPpBE+L54MtRVrwUHHBM6jdzAJ7HNBPetaULrqRlvaX6ARG
   5+GGdfUTeAaP0eFfbvbKAS7qevvvSq9Rg7plh4dtRob5gt0L80Vnwmo3v
   omUTGANrf6Vu7jDhBLnusLiy8eOSKEsphM6ncH0VEzmTOzTEPnHB+SPVx
   w==;
X-CSE-ConnectionGUID: /5pGD6j9Sp+C5FGfrew+1g==
X-CSE-MsgGUID: OtN/++sYTOKtSy+iPvvDQQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11970"; a="3720971"
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="3720971"
Received: from fmviesa013.fm.intel.com ([10.60.135.153])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 08:35:25 -0800
X-CSE-ConnectionGUID: txKfZ5L0SKed90og67xCTA==
X-CSE-MsgGUID: /dy/8OPdTq2jdiY5MhioTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,219,1787036400"; 
   d="scan'208";a="12127079"
Received: from jjgreens-desk24.amr.corp.intel.com (HELO [10.125.109.2]) ([10.125.109.2])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2026 08:35:25 -0800
Message-ID: <ef114394-23fc-45ae-8631-b1abd6ec88cb@intel.com>
Date: Wed, 18 Nov 2026 09:35:23 -0700
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] Documentation/ndctl-load-keys: document CXL
 passphrase key recovery
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org
References: <20261024011706.552346-1-alison.schofield@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <20261024011706.552346-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/23/26 6:17 PM, Alison Schofield wrote:
> Kernels prior to Linux 7.3 use a different serial number format
> than ndctl when looking up CXL nvdimm passphrase keys, preventing
> auto-unlock after reboot.
> 
> Document how to recover affected devices on unfixed kernels and
> migrate existing keys after upgrading to a fixed kernel.
> 
> Kernel commit in v7.3: https://git.kernel.org/linus/8a80d3d65cd0
> 
> Closes: https://github.com/pmem/ndctl/issues/299
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  Documentation/ndctl/ndctl-load-keys.txt | 96 +++++++++++++++++++++++++
>  1 file changed, 96 insertions(+)
> 
> diff --git a/Documentation/ndctl/ndctl-load-keys.txt b/Documentation/ndctl/ndctl-load-keys.txt
> index 70db57441820..ddb324830e05 100644
> --- a/Documentation/ndctl/ndctl-load-keys.txt
> +++ b/Documentation/ndctl/ndctl-load-keys.txt
> @@ -43,6 +43,102 @@ OPTIONS
>  	then this option will override (but not overwrite) anything that is
>  	in the file.
>  
> +CXL SERIAL NUMBER KEY MISMATCH
> +------------------------------
> +This section applies to passphrase-protected CXL NVDIMMs that fail to
> +auto-unlock after reboot on kernels without commit 8a80d3d65cd0, or that
> +fail to auto-unlock after upgrading to a kernel with that fix. It does
> +not apply to NVDIMMs without a passphrase or devices that unlock
> +normally.
> +
> +Kernels without the fix look up passphrase keys using hexadecimal serial
> +numbers, while ndctl names them using decimal. The mismatch affects
> +serial numbers of 10 or greater. The fix, included in Linux 7.3 and some
> +stable kernels, uses unsigned decimal for both. Devices with serial
> +number bit 63 set may need their saved keys migrated after upgrading.
> +
> +The examples below use nmem0 for the affected nvdimm and the default
> +key path:
> +[subs="attributes"]
> +----
> +# keydir={ndctl_keysdir}
> +----
> +
> +=== Recovery on a kernel without the fix
> +
> +Confirm that the device is locked:
> +----
> +# ndctl list -i -d nmem0 | jq -r '.[].dimms[0].security'
> +locked
> +----
> +
> +If it reports 'disabled', the device has no passphrase enrolled and this
> +is a different problem. If it reports 'unlocked', there is nothing to
> +recover.
> +
> +Check whether the device is affected by the serial number mismatch.
> +Show the decimal 'id' that ndctl uses to name the key, and the
> +hexadecimal serial number of the CXL memdev that backs nmem0:
> +----
> +# id=$(cat /sys/bus/nd/devices/nmem0/cxl/id)
> +# prov=$(cat /sys/bus/nd/devices/nmem0/cxl/provider)
> +# serial=$(cat /sys/bus/cxl/devices/${prov}/../serial)
> +# echo "$id $serial"
> +----
> +
> +If the 'id' is 10 or greater, or is negative, the device is affected.
> +Confirm that the key blob ndctl saved exists:
> +----
> +# ls "${keydir}/nvdimm_${id}_$(hostname).blob"
> +----
> +
> +If the blob is missing, this recovery procedure does not apply. Check
> +that the correct key directory and hostname are being used.
> +
> +Copy the blob to a name that uses the hexadecimal serial number,
> +without its 0x prefix, so that 'load-keys' also installs the key the
> +kernel requests:
> +----
> +# hexid=${serial#0x}
> +# cp "${keydir}/nvdimm_${id}_$(hostname).blob" \
> +     "${keydir}/nvdimm_${hexid}_$(hostname).blob"
> +----
> +
> +Reload the keys and enable the dimm. 'load-keys' names each key after
> +its blob file, so the copy is installed as the key the kernel requests:
> +----
> +# ndctl load-keys
> +# ndctl enable-dimm nmem0
> +# ndctl list -i -d nmem0 | jq -r '.[].dimms[0].security'
> +unlocked
> +----
> +
> +=== Migration after upgrading to a fixed kernel
> +
> +Only serial numbers with bit 63 set need to be migrated. Their blob is
> +named by the negative 'id' that the previous kernel reported, while the
> +fixed kernel requests the key by the unsigned decimal serial number.
> +Other serial numbers require no migration. A hexadecimal copy made by
> +the recovery procedure above is no longer used and may be removed.
> +
> +Copy the blob from the previous negative 'id' to the current 'id'.
> +Shell arithmetic cannot portably represent these values, so compute the
> +previous 'id' with bc(1), which must be installed:
> +----
> +# id=$(cat /sys/bus/nd/devices/nmem0/cxl/id)
> +# oldid=$(echo "$id - 2^64" | bc)
> +# cp "${keydir}/nvdimm_${oldid}_$(hostname).blob" \
> +     "${keydir}/nvdimm_${id}_$(hostname).blob"
> +----
> +
> +Reload the keys and enable the dimm:
> +----
> +# ndctl load-keys
> +# ndctl enable-dimm nmem0
> +# ndctl list -i -d nmem0 | jq -r '.[].dimms[0].security'
> +unlocked
> +----
> +
>  include::intel-nvdimm-security.txt[]
>  
>  include::../copyright.txt[]


Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6042429CEB
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 09:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785834770; cv=none; b=XDyCYbL1wXZxgh+6XcyGAGUzl5bW02/yvDuvZdC4M9E1+6r3BQ0KaqcwoPiwdTtSn0y9aQoRtM6is6dR2JYDmgbdpSvelSuhFoPAFWJaseS/EYpAL6CzoBUxEj+v1v9UQSCqKoF2xrXMC5YTl26VrWneKpP6dxjNhFGsllEgYcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785834770; c=relaxed/simple;
	bh=QrRCjwfLGZcW4M2CiM6v1J4D+OgWeTTYd84b8kYW65s=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TjS6sYswO/japgzHjcacCB8zhYpgZc9uBy8nbnAd9lDXw8lHjIblU6G1A8qeCdHElpJYo37oM/W2/KDacoMNynHh+V3vrzalYIitUur47S8Spfkfc4zKs4eUB5XdItdssZMDNOPQeARkJ4rMmGB7pPb2/P24zteDzH4lN+sQmN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZInmhsMN; arc=none smtp.client-ip=209.85.215.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZInmhsMN"
Received: by mail-pg1-f178.google.com with SMTP id 41be03b00d2f7-cbe3fed2f58so2509944a12.3
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 02:12:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785834767; x=1786439567; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hSTwpiLxQq1UQjrHpomtU2NdX/u0MOULxD6jsG+x0Ws=;
        b=ZInmhsMNIKhK9QjpSEIaysmMwnsOO+/J+prMi0u4K1qjMnnDLRTLS8eZm8yA77msWB
         fxe1HpzxQr2gDCgdHz3S8YLGpyCswLva0gIO9UvEBqMtImMguYqiH8yuZu4Un6+9hkKh
         waq6Hn0DQbKPIIQ/XRPuwTc4R5aZD8eT6kvooJrMRlime8ficRAX8Nyp7czNM2HGScCI
         GsoL+N1iGKO9iSFLvFxloTqJ2F4o+2sQJ838svEnX08GyGV5tqedrR3ali9/2xoUq9Tg
         9zrmSo9WX+7z9C8aJe1X/oVzzNx+5jN6eueNyGPmhA+GEVV7Gy2hRtwcM0cf1dC6tHUf
         tW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785834767; x=1786439567;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hSTwpiLxQq1UQjrHpomtU2NdX/u0MOULxD6jsG+x0Ws=;
        b=ZEEphxpMohk3JvpgRtQTs52bC+7noF/qE2VfiEPM7tj0F1AUUIroVyj7SEEejf+gBx
         Kj7BHxdbbI89DiF0OQC2TgRLXM2XnpT5ZwDSVFqEP7z3lyJwm6CD+czVjIvs3Pts5voq
         39Q5EJgfCClAo8PN2kGX38k5d20pO3paJFF8JXlA37W2nXYpZZA1rI73IpwUbRlZZDjK
         3NYekObCQITpg1LgKR0s7g96OxTJeEzW/yqKVpIJGj8r12xwoFWi/ne3PIPVBhfuPbtY
         0inWbZ6/St6VYmgUFaNvJDg6HfbC6IyQWd+4UIsyBi4tNoudXhyyoh3yGThPwygzoIBx
         XqHQ==
X-Forwarded-Encrypted: i=1; AHgh+RpVkKpDPKnuPOqIs6HPcGy0ZNENMGh3/zh8AkzD43kvRmkvhwqC15OsGNWrI4O188E2I+vGZMM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTaa+2fuGp/deWF5XBDZfQH9YZkcZ09qNXwIvoyCXpSRGUu+Il
	ZCkeypPV+gPCiyetQGB5muXW6CYTP3DckUtH4A7JoJhktb6ANJ8vEx3P
X-Gm-Gg: AR+sD12ssHMvYahvjboL1SVCvT3xiQdhlw0oUd/Nq7K3lBpZuZe0XjvzaBQBdKnAxBA
	ezWxG+eQXZQA8904NytAetn8r3YDH7eEikZ69I7zBbxK+0jmhdNgSB5I2s/XbQtgtFPSY7SvEj+
	e19Fw2cJOLmKxvWhsEGMHbbCQMnAuULfeFZxjpTNrpmRBMo5bmfyrYT1hevFXMij5I26PkiR99i
	7rCESUhElPUYpJtVnaJTGi/vBGStGnhmqI7EVmF9b1zpIAlTCEbFOnUs52Nl2OIUva5g58p7afF
	VTd/5JRAeG1MMbBznGs2JBXoxEmjNGzDDUBnFfu0ta6/VeetFhuwyeQ47KNOlx9PVjWZwh6azd0
	oYW6RtFSt6ltoecGKZN5goUGFTZsH0VVLBPbUs2mXArlTh6QvQFZcWO3bhpxjqB5gbUqptb5vgP
	JxO/aT5MAoE7Npagr+7nKjj2EW6WUevvx3rSPwByfKVPOfO1yKlA5cXNDRDBzN8apAYvsNL5Zxk
	cjoD+o3mwnDjb3UOqZOWiLsJpiOIXQM8SnFxWeJYU0w
X-Received: by 2002:a05:6a20:93a0:b0:3c3:bbe6:95b1 with SMTP id adf61e73a8af0-3c92a5d6d57mr13851053637.24.1785834766953;
        Tue, 04 Aug 2026 02:12:46 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-315863fb350sm2659990eec.8.2026.08.04.02.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 02:12:46 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Tue, 4 Aug 2026 02:12:44 -0700
To: Alison Schofield <alison.schofield@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <jic23@kernel.org>, Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>
Subject: Re: [PATCH v12 2/8] cxl/mem: Read dynamic capacity configuration
 from the device
Message-ID: <anGtDPQ41N-SGQFG@AnisaLaptop.localdomain>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-3-anisa.su@samsung.com>
 <anENkWO2G5tdPtNb@aschofie-mobl2.lan>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <anENkWO2G5tdPtNb@aschofie-mobl2.lan>

On Mon, Aug 03, 2026 at 02:52:17PM -0700, Alison Schofield wrote:
> On Fri, Jul 31, 2026 at 01:48:07AM -0700, Anisa Su wrote:
> > From: Ira Weiny <iweiny@kernel.org>
> > 
> > Devices which optionally support Dynamic Capacity (DC) are configured
> > via mailbox commands.  CXL r4.0 section 9.13.3 requires the host to issue
> > the Get DC Configuration command in order to properly configure DCDs.
> > Without the Get DC Configuration command DCD can't be supported.
> > 
> > Implement the DC mailbox commands as specified in CXL 4.0 section
> > 8.2.10.9.9 (opcodes 48XXh) to read and store the DCD configuration
> > information.  Disable DCD if an invalid configuration is found.
> > 
> > Linux has no support for more than one dynamic capacity partition.  Read
> > and validate all the partitions but configure only the first partition
> > as 'dynamic ram 1'.  Additional partitions can be added in the future if
> > such a device ever materializes.  Additionally it is anticipated that no
> > skips will be present from the end of the pmem partition.  Check for and
> > disallow this configuration as well.
> 
> Hi Anisa,
> 
> "Additionally, it is anticipated that no skips will be present.." sounds
> woogedy. The paragraph starts with a Linux limitation of only one partition.
> and next mentions skips. Is that a Linux implementation rule, a spec
> rule, or something else?
> 

Sorry for the lack of clarity. The commit message has been revised to
make it clear that DPA gaps between partitions are a Linux rule. The
spec permits a gap: the DC region base is device assigned and only has to be
256MB aligned (r4.0 Table 8-347). It now reads:

    Linux has no support for more than one dynamic capacity partition. Read
    and validate all the partitions but configure only the first partition
    as 'dynamic ram 1'. Additional partitions can be added in the future if
    such a device ever materializes. Linux additionally requires partitions
    to be contiguous. Therefore, check for and disallow any gap between the
    end of the pmem partition and the first DC partition, as well as gaps
    between the remaining DC partitions.

> See below wrt validation checks.
> 
> 
> > 
> > Based on an original patch by Navneet Singh.
> > 
> > Signed-off-by: Ira Weiny <iweiny@kernel.org>
> > Signed-off-by: Anisa Su <anisa.su@samsung.com>
> > Tested-by: Wonjae Lee <wj28.lee@samsung.com>
> > Tested-by: Junhee Park <jh9934.park@samsung.com>
> > Tested-by: Heesoo Kim <habil.kim@samsung.com>
> > 
> > ---
> > Changes:
> > 1. mbox.c: bound the Get DC Config request by the negotiated mailbox
> >    payload. Requesting all CXL_MAX_DC_PARTITIONS (8) needs a 328-byte
> >    response, which exceeds a spec-minimum 256-byte mailbox and fails
> >    -E2BIG, disabling DCD. Cap partition_count per call to what the
> >    payload holds and read the rest via the existing start_partition
> >    loop.
> > ---
> >  drivers/cxl/core/hdm.c  |   2 +
> >  drivers/cxl/core/mbox.c | 220 ++++++++++++++++++++++++++++++++++++++++
> >  drivers/cxl/cxlmem.h    |  55 ++++++++++
> >  drivers/cxl/pci.c       |   3 +
> >  include/cxl/cxl.h       |   3 +-
> >  5 files changed, 282 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
> > index 0c80b76a5f9b..0ef076c08ed2 100644
> > --- a/drivers/cxl/core/hdm.c
> > +++ b/drivers/cxl/core/hdm.c
> > @@ -446,6 +446,8 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
> >  		return "ram";
> >  	case CXL_PARTMODE_PMEM:
> >  		return "pmem";
> > +	case CXL_PARTMODE_DYNAMIC_RAM_1:
> > +		return "dynamic_ram_1";
> >  	default:
> >  		return "";
> >  	};
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 4790524c32a7..d79019fbd790 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> > @@ -1352,6 +1352,197 @@ int cxl_mem_sanitize(struct cxl_memdev *cxlmd, u16 cmd)
> >  	return -EBUSY;
> >  }
> >  
> > +static int cxl_dc_check(struct device *dev, struct cxl_dc_partition_info *part_array,
> > +			u8 index, struct cxl_dc_partition *dev_part)
> > +{
> > +	u64 blk_size = le64_to_cpu(dev_part->block_size);
> > +	u64 len = le64_to_cpu(dev_part->length);
> > +
> > +	part_array[index].start = le64_to_cpu(dev_part->base);
> > +	part_array[index].size = le64_to_cpu(dev_part->decode_length);
> > +	part_array[index].size *= CXL_CAPACITY_MULTIPLIER;
> > +
> > +	/* Check partitions are in increasing DPA order */
> > +	if (index > 0) {
> > +		struct cxl_dc_partition_info *prev_part = &part_array[index - 1];
> > +
> > +		if ((prev_part->start + prev_part->size) >
> > +		     part_array[index].start) {
> > +			dev_err(dev,
> > +				"DPA ordering violation for DC partition %d and %d\n",
> > +				index - 1, index);
> > +			return -EINVAL;
> > +		}
> > +	}
> > +
> > +	if (part_array[index].size == 0 || len == 0 ||
> > +	    part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
> > +		dev_err(dev, "DC partition %d invalid length; size %llu len %llu blk size %llu\n",
> > +			index, part_array[index].size, len, blk_size);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (blk_size == 0 || blk_size % CXL_DCD_BLOCK_LINE_SIZE ||
> > +	    !is_power_of_2(blk_size)) {
> > +		dev_err(dev, "DC partition %d invalid block size %llu\n",
> > +			index, blk_size);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (!IS_ALIGNED(part_array[index].start, SZ_256M) ||
> > +	    !IS_ALIGNED(part_array[index].start, blk_size)) {
> > +		dev_err(dev, "DC partition %d invalid start %llu blk size %llu\n",
> > +			index, part_array[index].start, blk_size);
> > +		return -EINVAL;
> > +	}
> > +
> > +	dev_dbg(dev, "DC partition %d start %llu size %llu blk_size: %llu\n",
> > +		index, part_array[index].start, part_array[index].size,
> > +		blk_size);
> > +
> > +	return 0;
> > +}
> 
> 
> cxl_dc_check() above needs rework.
> Please go back through it against CXL r4.0 Tables 8-346 and 8-347 and confirm
> that each constraint the code enforces is the constraint the spec actually
> states. The check need to run in dependency order, and then each failure
> needs to report the specific field or relationship that is invalid.
> 
Done, double checked both tables. The function now validates in
dependency order with one message per field:

    /* Block size is a power of 2 and a multiple of 40h */
    if (blk_size == 0 || !is_power_of_2(blk_size) ||
        blk_size % CXL_DCD_BLOCK_LINE_SIZE) {
            dev_err(dev, "DC partition %d invalid block size %#llx\n", ...);

*** note sashiko pointed out is_power_of_2(unsigned long n) truncates
on 32-bit builds, so is_power_of_2 is replaced with (blk_size & (blk_size - 1))

    if (part_array[index].size == 0)   -> "zero decode length"
    if (len == 0)                      -> "zero length"
    if (len > part_array[index].size)  -> "length %#llx exceeds decode length %#llx"
    if (!IS_ALIGNED(len, blk_size))    -> "length %#llx not a multiple of block size %#llx"
    if (!IS_ALIGNED(start, SZ_256M))   -> "base %#llx not aligned to 256M"

    /* Partitions must be contiguous and in increasing DPA order */

Point by point details below.

> A terse list of what looks wrong from here. (I have not chased each one)
> 
> - blk_size is used as the alignment in IS_ALIGNED(len, blk_size) and
>   IS_ALIGNED(start, blk_size) before it is validated.

Fixed, block size is validated first now.

To clarify the exact fix and reason:

In v12, a block size of 0 would still be rejected, but print "invalid length"
instead of "invalid block size:

	if (part_array[index].size == 0 || len == 0 ||
          part_array[index].size < len || !IS_ALIGNED(len, blk_size)) {
              dev_err(dev, "DC partition %d invalid length; size %llu len %llu blk size %
              return -EINVAL;
      }

!IS_ALIGNED(len, blk_size) = !(len & ~0ULL)

len & ~0ULL == 0 iff. len == 0. Since len is checked before the
alignement check, then !(len &0ULL) evaluates to true and prints
"invalid length". By moving the blk_size check above, the correct error
message "invalid block size" is printed for blk_size == 0.

> - Four unrelated conditions share one "invalid length" message.

Fixed, four separate checks, each naming its own field.

 if (part_array[index].size == 0)   -> "zero decode length"
 if (len == 0)                      -> "zero length"
 if (len > part_array[index].size)  -> "length %#llx exceeds decode length %#llx"
 if (!IS_ALIGNED(len, blk_size))    -> "length %#llx not a multiple of block size %#llx

> - The start check combines the 256 MiB and block-size requirements, so the
>   message cannot say which alignment failed.

Fixed: Table 8-347 requires the base to be 256MB aligned, and states the block
size alignment for the starting DPAs of extents, **not** for the region
base. So the start check now only requires 256 MiB alignment.

> - "DPA ordering violation" is really an overlap check, and gaps appear to be
>   allowed.

Fixed to tighten the check. One thing to note: only DC partition 0 is configured,
so this check would mean DCD is disabled for a device with a usable
partition 0, but which has gaps between later partitions. If
multi-partition support is landed later, gaps would be caught by
cxl_dpa_check when the partition is configured. Should
cxl_dev_dc_identify() only check for spec compliance and defer the
Linux rule of no gaps between partitions up to cxl_dpa_check()?

	/* Partitions must be contiguous and in increasing DPA order */
	for (int prev = index - 1; prev >= 0; prev--) {
		struct cxl_dc_partition_info *prev_part = &part_array[prev];

		if (prev_part->size == 0)
			continue;

		if (prev_part->start + prev_part->size != part_array[index].start) {
			dev_err(dev,
				"DC partition %d and %d are not contiguous\n",
				prev, index);
			return -EINVAL;
		}
		break;
	}
> - avail_partition_count is never checked against the 1 to 8 range Table 8-346
>   requires.

Added in cxl_get_dc_config(), before the count is used as the bound for
the read loop:

    /* A DCD reports between 1 and 8 partitions */
    if (dc_resp->avail_partition_count == 0 ||
        dc_resp->avail_partition_count > CXL_MAX_DC_PARTITIONS) {
            dev_err(mbox->host,
                    "Device reported %u available DC partitions, expected 1 to %u\n",
                    dc_resp->avail_partition_count, CXL_MAX_DC_PARTITIONS);
            return -EIO;
    }

This also answers the Sashiko report on this patch, which asked whether
a device with 0 partitions is failed incorrectly. Table 8-346 says "A
DCD shall report between 1 and 8 regions. All other values are
reserved.", so 0 is not a legal value and failing is the correct
behavior.

> - cxl_configure_dcd()'s "skip from pmem not supported" also fires on overlap,
>   and prints neither address.

Split into two checks that print both addresses:

    if (dc_info.start < info->size)
            dev_err(dev, "DC partition 0 base %#llx overlaps static capacity ending at %#llx\n", ...);

    /* A gap between static capacity and the DC partition is not supported */
    if (dc_info.start > info->size)
            dev_warn(dev, "DC partition 0 base %#llx leaves a gap from static capacity ending at %#llx\n", ...);

An overlap is the device contradicting itself so it is an error, a gap
is legal but unsupported so it stays a warning. Both still disable DCD.

The message also said "pmem capacity", which I think is less accurate
than "static capacity", since we could have a volatile only device with
no pmem partition.

> - min_out = 8 is a bare constant for the header ahead of the flex array

Fixed. Uses sizeof(*dc_resp), which for a flex array struct is exactly the fixed
header.

> - DPA addresses and sizes print in decimal, rest of CXL uses hex 

Converted to hex -- Partition indices stay %d.

> - The Table 8-178, 8-179 and 8-180 citations are not r4.0 numbering
> 
Sorry, my bad!

Corrected to Table 8-345 (input payload), 8-346 (output payload) and 8-347
(region configuration). I also re-checked the Table 8-308 citation in
patch 1 and that one is correct.

> And RichardC called out this one in his prior review -
> - Zero geometry fields are legal per Table 8-347, as already raised on the
>   list. Agreed, and the fallout of skipping rather than rejecting needs
>   working through.
> 

Fixed: New helper, and cxl_dc_check() returns early leaving the array
entry empty:

    static bool cxl_dc_partition_unavailable(struct cxl_dc_partition *dev_part)
    {
            return !le64_to_cpu(dev_part->decode_length) &&
                   !le64_to_cpu(dev_part->length) &&
                   !le64_to_cpu(dev_part->block_size);
    }

Regarding the fallout of skipping:
- Only those three fields are tested. Table 8-347 states the report-0
  behaviour for decode length, length and block size only, so a stale
  base or DSMAD handle on an unavailable region is not an error.
- If only some of the three are zero, falls through to the individual
  blk_size, len, and decode_len checks above and rejects the partition.
- The contiguity check checks against the last non-empty entry rather
  than index - 1, so a skipped partition in the middle cannot mask an
  overlap between the partitions either side of it.
- cxl_dev_dc_identify() returns -ENODEV if partition 0 itself is
  unavailable, since Linux only wires up partition 0. No message there,
  cxl_dc_check() has already logged the skip.

> -- Alison
> 
Thanks,
Anisa
> 
> > +
> > +/* Returns the number of partitions in dc_resp or -ERRNO */
> > +static int cxl_get_dc_config(struct cxl_mailbox *mbox, u8 start_partition,
> > +			     u8 partition_count,
> > +			     struct cxl_mbox_get_dc_config_out *dc_resp,
> > +			     size_t dc_resp_size)
> > +{
> > +	struct cxl_mbox_get_dc_config_in get_dc = (struct cxl_mbox_get_dc_config_in) {
> > +		.partition_count = partition_count,
> > +		.start_partition_index = start_partition,
> > +	};
> > +	struct cxl_mbox_cmd mbox_cmd = (struct cxl_mbox_cmd) {
> > +		.opcode = CXL_MBOX_OP_GET_DC_CONFIG,
> > +		.payload_in = &get_dc,
> > +		.size_in = sizeof(get_dc),
> > +		.size_out = dc_resp_size,
> > +		.payload_out = dc_resp,
> > +		.min_out = 8,
> > +	};
> > +	size_t expected_sz;
> > +	int rc;
> > +
> > +	rc = cxl_internal_send_cmd(mbox, &mbox_cmd);
> > +	if (rc < 0)
> > +		return rc;
> > +
> > +	if (dc_resp->partitions_returned > partition_count) {
> > +		dev_err(mbox->host, "Device returned %u partitions, requested %u\n",
> > +			dc_resp->partitions_returned, partition_count);
> > +		return -EIO;
> > +	}
> > +
> > +	/*
> > +	 * The payload carries trailing extent/tag count fields after the
> > +	 * partition array (CXL r4.0 Table 8-179) which the driver ignores, so
> > +	 * the response is at least, not exactly, expected_sz.
> > +	 */
> > +	expected_sz = struct_size(dc_resp, partition,
> > +				  dc_resp->partitions_returned);
> > +
> > +	if (mbox_cmd.size_out < expected_sz) {
> > +		dev_err(mbox->host,
> > +			"Payload size %zu less than expected %zu for %u partitions\n",
> > +			mbox_cmd.size_out,
> > +			expected_sz,
> > +			dc_resp->partitions_returned);
> > +		return -EIO;
> > +	}
> > +
> > +	dev_dbg(mbox->host, "Read %d/%d DC partitions\n",
> > +		dc_resp->partitions_returned, dc_resp->avail_partition_count);
> > +	return dc_resp->partitions_returned;
> > +}
> > +
> > +/**
> > + * cxl_dev_dc_identify() - Reads the dynamic capacity information from the
> > + *                         device.
> > + * @mbox: Mailbox to query
> > + * @dc_info: The dynamic partition information to return
> > + *
> > + * Read Dynamic Capacity information from the device and return the partition
> > + * information.
> > + *
> > + * Return: 0 if identify was executed successfully, -ERRNO on error.
> > + *         on error only dc_info is left unchanged.
> > + */
> > +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > +			struct cxl_dc_partition_info *dc_info)
> > +{
> > +	struct cxl_dc_partition_info partitions[CXL_MAX_DC_PARTITIONS];
> > +	struct cxl_mbox_get_dc_config_out *dc_resp __free(kfree) = NULL;
> > +	struct device *dev = mbox->host;
> > +	u8 start_partition;
> > +	u8 num_partitions;
> > +	u8 partition_count;
> > +	size_t dc_resp_size;
> > +
> > +	/* Bound requested number of partitions by mailbox payload size */
> > +	partition_count = min_t(size_t, CXL_MAX_DC_PARTITIONS,
> > +				(mbox->payload_size - sizeof(*dc_resp) -
> > +				 sizeof(struct cxl_mbox_get_dc_config_tail)) /
> > +				sizeof(struct cxl_dc_partition));
> > +	dc_resp_size = struct_size(dc_resp, partition, partition_count) +
> > +		       sizeof(struct cxl_mbox_get_dc_config_tail);
> > +
> > +	dc_resp = kmalloc(dc_resp_size, GFP_KERNEL);
> > +	if (!dc_resp)
> > +		return -ENOMEM;
> > +
> > +	/*
> > +	 * Read and check all partition information for validity and potential
> > +	 * debugging; see debug output in cxl_dc_check()
> > +	 */
> needless comment
> 
> 
> > +	start_partition = 0;
> > +	num_partitions = 0;
> > +	do {
> > +		int rc, i, j;
> > +
> > +		rc = cxl_get_dc_config(mbox, start_partition, partition_count,
> > +				       dc_resp, dc_resp_size);
> > +		if (rc < 0) {
> > +			dev_err(dev, "Failed to get DC config: %d\n", rc);
> > +			return rc;
> > +		}
> > +
> > +		if (rc == 0) {
> > +			dev_err(dev,
> > +				"Device reported %u partitions available but returned none at index %u\n",
> > +				dc_resp->avail_partition_count, start_partition);
> > +			return -EIO;
> > +		}
> > +
> > +		num_partitions += rc;
> > +
> > +		if (num_partitions < 1 || num_partitions > CXL_MAX_DC_PARTITIONS) {
> > +			dev_err(dev, "Invalid num of dynamic capacity partitions %d\n",
> > +				num_partitions);
> > +			return -EINVAL;
> > +		}
> > +
> > +		for (i = start_partition, j = 0; i < num_partitions; i++, j++) {
> > +			rc = cxl_dc_check(dev, partitions, i,
> > +					  &dc_resp->partition[j]);
> > +			if (rc)
> > +				return rc;
> > +		}
> > +
> > +		start_partition = num_partitions;
> > +
> > +	} while (num_partitions < dc_resp->avail_partition_count);
> > +
> > +	/* Return 1st partition */
> > +	dc_info->start = partitions[0].start;
> > +	dc_info->size = partitions[0].size;
> > +	dev_dbg(dev, "Returning partition 0 %llu size %llu\n",
> > +		dc_info->start, dc_info->size);
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL_NS_GPL(cxl_dev_dc_identify, "CXL");
> > +
> >  static void add_part(struct cxl_dpa_info *info, u64 start, u64 size, enum cxl_partition_mode mode)
> >  {
> >  	int i = info->nr_partitions;
> > @@ -1422,6 +1613,35 @@ int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_get_dirty_count, "CXL");
> >  
> > +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info)
> > +{
> > +	struct cxl_dc_partition_info dc_info = { 0 };
> > +	struct device *dev = mds->cxlds.dev;
> > +	int rc;
> > +
> > +	rc = cxl_dev_dc_identify(&mds->cxlds.cxl_mbox, &dc_info);
> > +	if (rc) {
> > +		dev_warn(dev,
> > +			 "Failed to read Dynamic Capacity config: %d\n", rc);
> > +		cxl_disable_dcd(mds);
> > +		return;
> > +	}
> > +
> > +	/* Skips between pmem and the dynamic partition are not supported */
> > +	if (dc_info.start != info->size) {
> > +		dev_warn(dev,
> > +			 "Dynamic Capacity skip from pmem not supported\n");
> > +		cxl_disable_dcd(mds);
> > +		return;
> > +	}
> > +
> > +	info->size += dc_info.size;
> > +	dev_dbg(dev, "Adding dynamic ram partition 1; %llu size %llu\n",
> > +		dc_info.start, dc_info.size);
> > +	add_part(info, dc_info.start, dc_info.size, CXL_PARTMODE_DYNAMIC_RAM_1);
> > +}
> > +EXPORT_SYMBOL_NS_GPL(cxl_configure_dcd, "CXL");
> > +
> >  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds)
> >  {
> >  	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
> > diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> > index 616eeaeee5b9..a9782939d82b 100644
> > --- a/drivers/cxl/cxlmem.h
> > +++ b/drivers/cxl/cxlmem.h
> > @@ -407,6 +407,8 @@ struct cxl_security_state {
> >  	struct kernfs_node *sanitize_node;
> >  };
> >  
> > +#define CXL_MAX_DC_PARTITIONS 8
> > +
> >  static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
> >  {
> >  	/*
> > @@ -691,6 +693,39 @@ struct cxl_mbox_set_shutdown_state_in {
> >  	u8 state;
> >  } __packed;
> >  
> > +/* See CXL r4.0 Table 8-178 get dynamic capacity config Input Payload */
> > +struct cxl_mbox_get_dc_config_in {
> > +	u8 partition_count;
> > +	u8 start_partition_index;
> > +} __packed;
> > +
> > +/* See CXL r4.0 Table 8-179 get dynamic capacity config Output Payload */
> > +struct cxl_mbox_get_dc_config_out {
> > +	u8 avail_partition_count;
> > +	u8 partitions_returned;
> > +	u8 rsvd[6];
> > +	/* See CXL r4.0 Table 8-180 */
> > +	struct cxl_dc_partition {
> > +		__le64 base;
> > +		__le64 decode_length;
> > +		__le64 length;
> > +		__le64 block_size;
> > +		__le32 dsmad_handle;
> > +		u8 flags;
> > +		u8 rsvd[3];
> > +	} __packed partition[] __counted_by(partitions_returned);
> > +	/* Trailing extent/tag count fields unused */
> > +} __packed;
> > +
> > +/* Trailing counts; cannot be a member after the flex array above */
> > +struct cxl_mbox_get_dc_config_tail {
> > +	__le32 num_extents_supported;
> > +	__le32 num_extents_available;
> > +	__le32 num_tags_supported;
> > +	__le32 num_tags_available;
> > +} __packed;
> > +#define CXL_DCD_BLOCK_LINE_SIZE 0x40
> > +
> >  /* Set Timestamp CXL 3.0 Spec 8.2.9.4.2 */
> >  struct cxl_mbox_set_timestamp_in {
> >  	__le64 timestamp;
> > @@ -814,9 +849,18 @@ enum {
> >  int cxl_internal_send_cmd(struct cxl_mailbox *cxl_mbox,
> >  			  struct cxl_mbox_cmd *cmd);
> >  int cxl_dev_state_identify(struct cxl_memdev_state *mds);
> > +
> > +struct cxl_dc_partition_info {
> > +	u64 start;
> > +	u64 size;
> > +};
> > +
> > +int cxl_dev_dc_identify(struct cxl_mailbox *mbox,
> > +			struct cxl_dc_partition_info *dc_info);
> >  int cxl_await_media_ready(struct cxl_dev_state *cxlds);
> >  int cxl_enumerate_cmds(struct cxl_memdev_state *mds);
> >  int cxl_mem_dpa_fetch(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> > +void cxl_configure_dcd(struct cxl_memdev_state *mds, struct cxl_dpa_info *info);
> >  struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev, u64 serial,
> >  						 u16 dvsec);
> >  void set_exclusive_cxl_commands(struct cxl_memdev_state *mds,
> > @@ -830,6 +874,17 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
> >  			    const uuid_t *uuid, union cxl_event *evt);
> >  int cxl_get_dirty_count(struct cxl_memdev_state *mds, u32 *count);
> >  int cxl_arm_dirty_shutdown(struct cxl_memdev_state *mds);
> > +
> > +static inline bool cxl_dcd_supported(struct cxl_memdev_state *mds)
> > +{
> > +	return mds->dcd_supported;
> > +}
> > +
> > +static inline void cxl_disable_dcd(struct cxl_memdev_state *mds)
> > +{
> > +	mds->dcd_supported = false;
> > +}
> > +
> >  int cxl_set_timestamp(struct cxl_memdev_state *mds);
> >  int cxl_poison_state_init(struct cxl_memdev_state *mds);
> >  int cxl_mem_get_poison(struct cxl_memdev *cxlmd, u64 offset, u64 len,
> > diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> > index 267c679b0b3c..9b320a2b6fe0 100644
> > --- a/drivers/cxl/pci.c
> > +++ b/drivers/cxl/pci.c
> > @@ -870,6 +870,9 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> >  	if (rc)
> >  		return rc;
> >  
> > +	if (cxl_dcd_supported(mds))
> > +		cxl_configure_dcd(mds, &range_info);
> > +
> >  	rc = cxl_dpa_setup(cxlds, &range_info);
> >  	if (rc)
> >  		return rc;
> > diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
> > index 016c74fb747c..87c2bd73df21 100644
> > --- a/include/cxl/cxl.h
> > +++ b/include/cxl/cxl.h
> > @@ -133,6 +133,7 @@ struct cxl_dpa_perf {
> >  enum cxl_partition_mode {
> >  	CXL_PARTMODE_RAM,
> >  	CXL_PARTMODE_PMEM,
> > +	CXL_PARTMODE_DYNAMIC_RAM_1,
> >  };
> >  
> >  /**
> > @@ -147,7 +148,7 @@ struct cxl_dpa_partition {
> >  	enum cxl_partition_mode mode;
> >  };
> >  
> > -#define CXL_NR_PARTITIONS_MAX 2
> > +#define CXL_NR_PARTITIONS_MAX 3
> >  
> >  /**
> >   * struct cxl_dev_state - The driver device state
> > -- 
> > 2.43.0
> > 
